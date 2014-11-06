package com.maninsoft.smart.formeditor.command.mapping
{
	import com.maninsoft.smart.formeditor.model.Cond;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class RemoveMappingFormCondCommand extends Command
	{
		
		public var target:Cond;
		private var oldTarget:Cond;
		private var oldIndex:int;
		
		public function RemoveMappingFormCondCommand(target:Cond)
		{
			this.target = target;
		}

		public override function execute():void{
			this.oldTarget = this.target;
			this.oldIndex = this.oldTarget.parent.conds.getItemIndex(this.oldTarget);
			
			this.target.parent.removeCond(this.target);
		}

		public override function undo():void{
			this.target.parent.addCond(this.oldTarget, this.oldIndex);
		}	
		
		public override function redo():void{
			this.target.parent.removeCond(this.target);
		}
		public override function getLabel():String{
			return "Remove item(" + target + ")";
		}	
	}
}