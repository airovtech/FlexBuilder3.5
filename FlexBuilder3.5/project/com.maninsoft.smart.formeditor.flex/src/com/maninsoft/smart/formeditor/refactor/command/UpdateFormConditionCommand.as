package com.maninsoft.smart.formeditor.refactor.command
{
	import com.maninsoft.smart.formeditor.model.condition.FormCondition;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class UpdateFormConditionCommand extends Command
	{
		public var condition:FormCondition;
		
		public var newValue:Object;
		private var oldValue:Object;
		
		public var type:String;
		
		public function UpdateFormConditionCommand(condition:FormCondition, newValue:Object, type:String, label:String) {
			super(label);
			
			this.condition = condition;
			
			this.newValue = newValue;
			this.type = type;
		}
		
		public override function execute():void{
			oldValue = this.condition[type];				
			this.condition[type] = newValue;
		}

		public override function undo():void{			
			this.condition[type] = oldValue;
		}
		
		public override function redo():void{	
			this.condition[type] = newValue;
		}
		public override function getLabel():String{
			return "Update " + type + " values (" + newValue + ") in FormCondition(" + condition.getLabel() + ")";
		}	
	}
}