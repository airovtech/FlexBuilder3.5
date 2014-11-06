package com.maninsoft.smart.formeditor.refactor.command
{
	import com.maninsoft.smart.formeditor.model.mapping.FormMapping;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class RemoveFormMappingCommand extends Command
	{
		public var child:FormMapping;
		
		private var index:int = -1;
	
		public function RemoveFormMappingCommand(child:FormMapping, label:String) {
			this.child = child;
			super(label);
		}
	
		public override function execute():void{
			this.index = child.formDocument.mappings.getItemIndex(child);
			child.formDocument.removeFormMapping(this.child);
		}

		public override function undo():void{
			child.formDocument.addFormMapping(this.child, this.index);
		}	
		
		public override function getLabel():String{
			return "Remove FormMapping(" + child.id + ")";
		}	
	}
}