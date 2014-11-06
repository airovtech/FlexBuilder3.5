package com.maninsoft.smart.formeditor.command.mapping
{
	import com.maninsoft.smart.formeditor.model.FormLink;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class RemoveMappingFormCommand extends Command
	{
		
		public var target:FormLink;
		private var oldTarget:FormLink;
		private var oldIndex:int;
		
		public function RemoveMappingFormCommand(target:FormLink)
		{
			this.target = target;
		}

		public override function execute():void{
			this.oldTarget = this.target;
			this.oldIndex = this.oldTarget.parent.formLinks.getItemIndex(this.oldTarget);
			
			this.target.parent.removeFormLink(this.target);
		}

		public override function undo():void{
			this.target.parent.addFormLink(this.oldTarget, this.oldIndex);
		}	
		
		public override function redo():void{
			this.target.parent.removeFormLink(this.target);
		}
		public override function getLabel():String{
			return "Remove item(" + target + ")";
		}	
	}
}