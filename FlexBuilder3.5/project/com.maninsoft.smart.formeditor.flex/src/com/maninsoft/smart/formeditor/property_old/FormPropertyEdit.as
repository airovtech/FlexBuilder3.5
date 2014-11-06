package com.maninsoft.smart.formeditor.property
{
	import com.maninsoft.smart.common.util.SmartUtil;
	import com.maninsoft.smart.formeditor.model.ISelectableModel;
	import com.maninsoft.smart.formeditor.refactor.editor.FormEditDomain;
	import com.maninsoft.smart.formeditor.util.FormEditorAssets;
	
	import flash.display.DisplayObject;
	
	import mx.containers.Canvas;
	import mx.containers.TabNavigator;
	import mx.core.Container;
	
	public class FormPropertyEdit extends Canvas implements IFormPropertyEditor
	{
		public function FormPropertyEdit(){
			this.percentHeight = 100;
			this.percentWidth = 100;
		}
		
		private var _editDomain:FormEditDomain;

		public function set editDomain(editDomain:FormEditDomain):void{
			this._editDomain = editDomain;
		}
		public function get editDomain():FormEditDomain{
			return this._editDomain;
		}
		
		private var _selectModel:ISelectableModel;

		public function set selectModel(selectModel:ISelectableModel):void{
			this._selectModel = selectModel;
		}
		public function get selectModel():ISelectableModel{
			return this._selectModel;
		}
		
		private var propEditor:IFormPropertyEditor;
		
		public function refreshVisual():void {
			removeAllChildren();
			
			this.propEditor = FormPropertyEditorFactory.getFormPropertyEditor(this.editDomain, this.selectModel);
			// TODO FormGridContainerPropEditor 일 때 에러가 남. 임시로 리턴
			if (propEditor == null)
				return;
					
			this.propEditor.refreshVisual();
			
			if (this.propEditor is TabNavigator) {
				this.addChild(this.propEditor as DisplayObject);
				return;
			}
			
			var propBox:Container = this.propEditor as Container;
			
			if (!SmartUtil.isEmpty(propBox.getChildren())) {
				var children:Array = propBox.getChildren();
				for each (var child:DisplayObject in children) {
					if (child is TabNavigator) {
						this.addChild(child);
						return;
					}
				}
			}
			
			if (propBox.icon == null)
				propBox.icon = FormEditorAssets.propertyIcon;
			
			var tabNavi:TabNavigator = new TabNavigator();
			tabNavi.percentWidth = 100;
			tabNavi.percentHeight = 100;
			tabNavi.styleName = "formFieldPropEditor";
			
			tabNavi.setStyle("paddingTop", 2);
			tabNavi.setStyle("paddingBottom", 2);
			tabNavi.setStyle("tabStyleName", "propTitle");
			
			tabNavi.addChild(this.propEditor as DisplayObject);
			
			this.addChild(tabNavi);
        }
	}
}