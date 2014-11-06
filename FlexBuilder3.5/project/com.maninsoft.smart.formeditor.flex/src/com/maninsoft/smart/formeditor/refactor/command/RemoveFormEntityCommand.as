package com.maninsoft.smart.formeditor.refactor.command
{
	import com.maninsoft.smart.formeditor.FormEditorBase;
	import com.maninsoft.smart.formeditor.model.FormEntity;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	import com.maninsoft.smart.workbench.common.event.FormEditorEvent;
	
	public class RemoveFormEntityCommand extends Command
	{
		public var child:FormEntity;
		
		private var index:int = -1;
	
		public function RemoveFormEntityCommand(label:String) {
			super(label);
		}
	
		public override function execute():void{
			if (child.parent == null) {
				this.index = child.root.children.getItemIndex(child);
				child.root.removeField(this.child);
			} else {
				this.index = child.parent.children.getItemIndex(child);
				child.parent.removeField(this.child);
			}
							
			var e:FormEditorEvent = new FormEditorEvent(FormEditorEvent.FORM_FIELD_REMOVE);
			e.formFieldId = child.id;
			e.formId = child.root.id;
			FormEditorBase.getInstance().dispatchEvent(e);
			trace("[Event]RemoveFormEntityCommand execute dispatch event : " + e);
		}

		public override function undo():void{
			if (child.parent == null) {
				child.root.addField(this.child, this.index);
			} else {
				child.parent.addField(this.child, this.index);
			}
		}	
		
		public override function getLabel():String{
			return "Remove FormEntity(" + child.id + ") in FormEntity(" + ((child.parent != null)?child.parent.id:"") + "), FormDocument(" + child.root.id + ")";
		}		
	}
}