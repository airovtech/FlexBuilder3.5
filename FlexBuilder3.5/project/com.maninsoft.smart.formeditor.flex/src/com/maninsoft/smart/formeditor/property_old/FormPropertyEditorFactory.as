package com.maninsoft.smart.formeditor.property
{
	import com.maninsoft.smart.formeditor.model.ISelectableModel;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridCell;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridLayout;
	import com.maninsoft.smart.formeditor.refactor.editor.FormEditDomain;
	import com.maninsoft.smart.formeditor.model.FormDocument;
	import com.maninsoft.smart.formeditor.model.FormEntity;
	
	import com.maninsoft.smart.common.util.SmartUtil;
	
	public class FormPropertyEditorFactory
	{
		private static var formDocPropEditor:FormDocPropEditor;
		private static var formGridItemPropEditor:FormGridItemPropEditor;
		private static var formGridContainerPropEditor:FormGridContainerPropEditor;
		private static var formPropEditor:FormPropEditor;
		private static var formDataGridItemPropEditor:FormDataGridItemPropEditor;
		
		public static function getFormPropertyEditor(editDomain:FormEditDomain, selectableModel:ISelectableModel):IFormPropertyEditor
		{
			var propEditor:IFormPropertyEditor;
			
			if (selectableModel is FormDocument) {
				if (formDocPropEditor == null)
					formDocPropEditor = new FormDocPropEditor();
				propEditor = formDocPropEditor;
				
			} else if (selectableModel is FormEntity) {
				if (formDataGridItemPropEditor == null)
					formDataGridItemPropEditor = new FormDataGridItemPropEditor();
				propEditor = formDataGridItemPropEditor;
								
			} else if (selectableModel is FormGridCell) {
				var gridCell:FormGridCell = selectableModel as FormGridCell;
				if (SmartUtil.isEmpty(gridCell.fieldId))
					return null;
				if (formGridItemPropEditor == null)
					formGridItemPropEditor = new FormGridItemPropEditor();
				propEditor = formGridItemPropEditor;
				
			} else if (selectableModel is FormGridLayout) {
				if (formGridContainerPropEditor == null)
					formGridContainerPropEditor = new FormGridContainerPropEditor();
				propEditor = formGridContainerPropEditor;
				
			} else {
				if (formPropEditor == null)
					formPropEditor = new FormPropEditor();
				propEditor = formPropEditor;
				
			}
			
			propEditor.editDomain = editDomain;
			propEditor.selectModel = selectableModel;
			
			return propEditor;
		}

	}
}