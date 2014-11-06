package com.maninsoft.smart.formeditor.refactor.command
{
	import com.maninsoft.smart.formeditor.model.mapping.FormMappingFrag;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class RemoveFormMappingFragCommand extends Command
	{
		public var child:FormMappingFrag;
		
		private var index:int = -1;
	
		public function RemoveFormMappingFragCommand(child:FormMappingFrag, label:String="") {
			
			this.child = child;
			super(label);
		}
	
		public override function execute():void{
			this.index = child.mapping.frags.getItemIndex(child);
			child.mapping.removeFragment(this.child);
		}

		public override function undo():void{
			child.mapping.addFragment(this.child, this.index);
		}
		
		public override function getLabel():String{
			return "Remove FormMappingFrag(" + child.getLabel() + ") in FormMapping(" + child.mapping.id + ")";
		}	
	}
}