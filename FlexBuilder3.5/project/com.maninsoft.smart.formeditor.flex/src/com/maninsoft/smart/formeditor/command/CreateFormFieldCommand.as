package com.maninsoft.smart.formeditor.command
{
	import com.maninsoft.smart.formeditor.FormEditorBase;
	import com.maninsoft.smart.formeditor.model.FormEntity;
	import com.maninsoft.smart.formeditor.model.IFormContainer;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class CreateFormFieldCommand extends Command
	{
		public var parent:IFormContainer;
		public var child:FormEntity;
		
		public var index:int = -1;
	
		public function CreateFormFieldCommand(parent:IFormContainer, child:FormEntity, index:int = -1, label:String = "") {
			super("Create FormField : " + label);
			
			this.parent = parent;
			this.child = child;
			this.index = index;
		}
	
		public override function execute():void{
			parent.addField(this.child, this.index);
		}

		public override function undo():void{
			if(parent.contain(this.child)){
				parent.removeField(this.child);
			}
		}		

		public override function getLabel():String{
			return "Create FormField(" + child.id + ") in FormContainer(" + parent.name + ") at index(" + index + ")";
		}	
	}
}