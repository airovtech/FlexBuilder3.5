package com.maninsoft.smart.formeditor.refactor.command
{
	import com.maninsoft.smart.formeditor.model.FormDocument;
	import com.maninsoft.smart.formeditor.model.mapping.FormMapping;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class CreateFormMappingCommand extends Command
	{
		public var root:FormDocument;
	
		public var child:FormMapping;
		
		public var index:int = -1;
	
		public function CreateFormMappingCommand(root:FormDocument, child:FormMapping, index:int = -1, label:String = "") {
			super(label);
			
			this.root = root;
			this.child = child;
			this.index = index;
		}
	
		public override function execute():void{			
			root.addFormMapping(this.child, this.index);
		}

		public override function undo():void{
			root.removeFormMapping(this.child);
		}		
		public override function getLabel():String{
			return "Create FormMapping(" + child.id + ") in FormDocument(" + root.id + ")";
		}	
	}
}