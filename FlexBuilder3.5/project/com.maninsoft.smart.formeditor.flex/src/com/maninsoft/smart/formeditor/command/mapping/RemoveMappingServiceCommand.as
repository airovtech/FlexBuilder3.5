package com.maninsoft.smart.formeditor.command.mapping
{
	import com.maninsoft.smart.formeditor.model.ServiceLink;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class RemoveMappingServiceCommand extends Command
	{
		
		public var target:ServiceLink;
		private var oldTarget:ServiceLink;
		private var oldIndex:int;
		
		public function RemoveMappingServiceCommand(target:ServiceLink)
		{
			this.target = target;
		}

		public override function execute():void{
			this.oldTarget = this.target;
			this.oldIndex = this.oldTarget.parent.serviceLinks.getItemIndex(this.oldTarget);
			
			this.target.parent.removeServiceLink(this.target);
		}

		public override function undo():void{
			this.target.parent.addServiceLink(this.oldTarget, this.oldIndex);
		}	
		
		public override function redo():void{
			this.target.parent.removeServiceLink(this.target);
		}
		public override function getLabel():String{
			return "Remove item(" + target + ")";
		}	
	}
}