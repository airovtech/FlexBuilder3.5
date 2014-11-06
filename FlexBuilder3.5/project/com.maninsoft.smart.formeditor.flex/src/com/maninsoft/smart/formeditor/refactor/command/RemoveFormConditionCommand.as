package com.maninsoft.smart.formeditor.refactor.command
{
	import com.maninsoft.smart.formeditor.model.condition.FormCondition;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class RemoveFormConditionCommand extends Command
	{
		public var child:FormCondition;
		
		private var index:int = -1;
	
		public function RemoveFormConditionCommand(child:FormCondition, label:String="") {
			super(label);
			
			this.child = child;
		}
	
		public override function execute():void{
			this.index = child.mapping.conditions.getItemIndex(child);
			child.mapping.removeCondition(this.child);
		}

		public override function undo():void{
			child.mapping.addCondition(this.child, this.index);
		}
		
		public override function getLabel():String{
			return "Remove FormCondition(" + child.getLabel() + ") in FormMapping(" + child.mapping.id + ")";
		}	
	}
}