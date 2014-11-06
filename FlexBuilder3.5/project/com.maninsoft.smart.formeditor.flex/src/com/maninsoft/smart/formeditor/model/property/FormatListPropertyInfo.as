package com.maninsoft.smart.formeditor.model.property
{
	import com.maninsoft.smart.formeditor.model.FormEntity;
	import com.maninsoft.smart.workbench.common.property.ListDataPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.ListDataPropertyInfo;
	
	import mx.collections.ArrayCollection;

	public class FormatListPropertyInfo extends ListDataPropertyInfo
	{
		public function FormatListPropertyInfo(id:String, displayName:String, description:String=null, category:String=null, editable:Boolean=true, helpId:String=null)
		{
			super(id, displayName, description, category, editable, helpId);
		}

		override protected function doEditorClick(editor: ListDataPropertyEditor): void {
			if(editor.valueLabel.text==null) return;
			if(!editor.list) editor.list = new ArrayCollection();
			for each(var item:FormEntity in editor.list){
				if(item.name == editor.valueLabel.text)
					return;
			}
			var child:FormEntity;
			child = new FormEntity(FormEntity(source).root);
           	child.name = editor.valueLabel.text;
           	child.parent = source as FormEntity;
			editor.list.addItem(child);
			editor.listItem.selectedItem=child;
			editor.listItem.invalidateList();
			editor.setPropertyValue(editor.list);
		}		
	}
}