package com.maninsoft.smart.formeditor.refactor.command
{
	import com.maninsoft.smart.formeditor.FormEditorBase;
	import com.maninsoft.smart.formeditor.model.FormDocument;
	import com.maninsoft.smart.formeditor.model.FormEntity;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	import com.maninsoft.smart.workbench.common.event.FormEditorEvent;
	
	public class CreateFormEntityCommand extends Command
	{
		public var root:FormDocument;
		
		public var parent:FormEntity;
		public var child:FormEntity;
		
		public var index:int = -1;
	
		public function CreateFormEntityCommand(root:FormDocument, child:FormEntity, parent:FormEntity = null, index:int = -1, label:String = "") {
			super(label);
			
			this.root = root;
			this.parent = parent;
			this.child = child;
			this.index = index;
		}
	
		public override function execute():void{
			
			if (parent == null) {
				root.addField(this.child, this.index);
			} else {
				parent.addField(this.child, this.index);
			}
			// 추가된 아이템 선택
			var e:FormEditorEvent = new FormEditorEvent(FormEditorEvent.FORM_FIELD_ADD);
			e.formFieldId = child.id;
			e.formId = this.root.id;
			e.newName = child.name;
			FormEditorBase.getInstance().dispatchEvent(e);
			trace("[Event]CreateFormEntityCommand execute dispatch event : " + e);
		}

		public override function undo():void{
			if (parent == null) {
				root.removeField(this.child);
			} else {
				parent.removeField(this.child);
			}
		}		
		public override function getLabel():String{
			return "Create FormField(" + child.id + ") in FormEntity(" + parent.id + "), FormDocument(" + root.id + ")";
		}	
	}
}