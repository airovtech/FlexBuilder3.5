////////////////////////////////////////////////////////////////////////////////
//  FormIdPropertyInfo.as
//  2008.03.17, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.formeditor.model.property
{
	import com.maninsoft.smart.common.util.SmartUtil;
	import com.maninsoft.smart.formeditor.FormEditorBase;
	import com.maninsoft.smart.formeditor.model.FormEntity;
	import com.maninsoft.smart.formeditor.view.dialog.DetailConditionDialog;
	import com.maninsoft.smart.workbench.common.property.IPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertySource;
	import com.maninsoft.smart.workbench.common.property.PropertyInfo;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.controls.Alert;
	
	/**
	 * TaskApplication 의 formId
	 */
	public class CheckBoxConditionPropertyInfo extends PropertyInfo {
		
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _editor: CheckBoxConditionPropertyEditor;
		private var _formEntity: FormEntity;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function CheckBoxConditionPropertyInfo(id: String, displayName: String, 
		                                   description: String = null,
		                                   category: String = null,
		                                   editable: Boolean = true,
		                                   helpId: String = null ) {
			super(id, displayName, description, category, editable, helpId);
		}



		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override public function getEditor(source: IPropertySource): IPropertyEditor {
			_formEntity = source as FormEntity;
				
			if(!_editor) {
				_editor = new CheckBoxConditionPropertyEditor();
				_editor.conditionEditButton.addEventListener(MouseEvent.CLICK, doEditorClick);			
				_editor.conditionEditButton.toolTip = resourceManager.getString("FormEditorETC", "conditionSelectTTip");
				if(    (id == FormEntity.PROP_HIDDEN_USE 
						&& !SmartUtil.isEmpty(_formEntity.hiddenConditions) 
						&& !SmartUtil.isEmpty(_formEntity.hiddenConditions.conds))
					|| (id == FormEntity.PROP_READONLY_USE 
						&& !SmartUtil.isEmpty(_formEntity.readOnlyConditions) 
						&& !SmartUtil.isEmpty(_formEntity.readOnlyConditions.conds))
					|| (id == FormEntity.PROP_REQUIRED_USE 
						&& !SmartUtil.isEmpty(_formEntity.requiredConditions) 
						&& !SmartUtil.isEmpty(_formEntity.requiredConditions.conds)))
					_editor.conditionEditButton.styleName="conditionEditButton";
				else			
					_editor.conditionEditButton.styleName="conditionEditButtonEmpty";
			}

			return _editor;
		}

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		private function doEditorClick(event: Event): void {
			var position:Point = _editor.localToGlobal(new Point(0, _editor.height+1));
			DetailConditionDialog.popupDetailConditionDialog(FormEditorBase.getInstance(), position, _formEntity, id, doAccept);
		}

		private function doAccept(item: Object=null): void {
			if(    (id == FormEntity.PROP_HIDDEN_USE 
					&& !SmartUtil.isEmpty(_formEntity.hiddenConditions) 
					&& !SmartUtil.isEmpty(_formEntity.hiddenConditions.conds))
				|| (id == FormEntity.PROP_READONLY_USE 
					&& !SmartUtil.isEmpty(_formEntity.readOnlyConditions) 
					&& !SmartUtil.isEmpty(_formEntity.readOnlyConditions.conds))
				|| (id == FormEntity.PROP_REQUIRED_USE 
					&& !SmartUtil.isEmpty(_formEntity.requiredConditions) 
					&& !SmartUtil.isEmpty(_formEntity.requiredConditions.conds)))
				_editor.conditionEditButton.styleName="conditionEditButton";
			else			
				_editor.conditionEditButton.styleName="conditionEditButtonEmpty";
				
		}
		
		//----------------------------------------------------------------------
		// External methods
		//----------------------------------------------------------------------
		
		public function doClick(): void {
			this.doEditorClick(null);
		}
		
		//----------------------------------------------------------------------
		// getter and setter
		//----------------------------------------------------------------------
	}
}