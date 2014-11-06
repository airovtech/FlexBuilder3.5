package com.maninsoft.smart.formeditor.command.mapping
{
	import com.maninsoft.smart.formeditor.model.ActualParameter;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class RemoveMappingFormParamCommand extends Command
	{
		
		public var target:ActualParameter;
		private var oldTarget:ActualParameter;
		private var oldIndex:int;
		
		public function RemoveMappingFormParamCommand(target:ActualParameter)
		{
			this.target = target;
		}

		public override function execute():void{
			this.oldTarget = this.target;
			this.oldIndex = this.oldTarget.parent.actualParameters.getItemIndex(this.oldTarget);
			
			this.target.parent.removeActualParameter(this.target);
		}

		public override function undo():void{
			this.target.parent.addActualParameter(this.oldTarget, this.oldIndex);
		}	
		
		public override function redo():void{
			this.target.parent.removeActualParameter(this.target);
		}
		public override function getLabel():String{
			return "Remove item(" + target + ")";
		}	
	}
}