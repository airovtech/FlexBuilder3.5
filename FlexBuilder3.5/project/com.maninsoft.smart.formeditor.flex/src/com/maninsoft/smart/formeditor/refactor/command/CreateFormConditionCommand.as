package com.maninsoft.smart.formeditor.refactor.command
{
	import com.maninsoft.smart.formeditor.model.condition.FormCondition;
	import com.maninsoft.smart.formeditor.model.mapping.FormMapping;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class CreateFormConditionCommand extends Command
	{
		public var mapping:FormMapping;
		
		public var condition:FormCondition;
		
		public var index:int = -1;
	
		public function CreateFormConditionCommand(mapping:FormMapping, condition:FormCondition, index:int = -1, label:String = "") {
			super(label);
			
			this.mapping = mapping;
			this.condition = condition;
			this.index = index;
			
			this.condition.mapping = this.mapping;
		}
	
		public override function execute():void{			
			mapping.addCondition(this.condition, this.index);
		}

		public override function undo():void{
			mapping.removeCondition(this.condition);
		}		
		public override function getLabel():String{
			return "Create FormCondition(" + condition.getLabel() + ") in FormMapping(" + mapping.id + ")";
		}	
	}
}