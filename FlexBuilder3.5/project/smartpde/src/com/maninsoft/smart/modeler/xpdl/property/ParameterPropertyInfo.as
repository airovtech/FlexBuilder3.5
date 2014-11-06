
package com.maninsoft.smart.modeler.xpdl.property
{
	import com.maninsoft.smart.modeler.xpdl.dialogs.ParameterSettingDialog;
	import com.maninsoft.smart.modeler.xpdl.model.Pool;
	import com.maninsoft.smart.modeler.xpdl.model.process.FormalParameter;
	import com.maninsoft.smart.workbench.common.property.IPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertySource;
	import com.maninsoft.smart.workbench.common.property.ParameterPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.PropertyInfo;
	
	import flash.geom.Point;
	
	/**
	 * XPDLLink의 condition 속성 
	 */
	public class ParameterPropertyInfo extends PropertyInfo {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _editor: ParameterPropertyEditor;
		private var _pool: Pool;
		private var _paramString: String;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function ParameterPropertyInfo(id: String, displayName: String, 
		                                   description: String = null,
		                                   category: String = null,
		                                   editable: Boolean = true,
		                                   helpId: String = null) {
			super(id, displayName, description, category, editable, helpId);
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override public function getEditor(source: IPropertySource): IPropertyEditor {
			if (!_editor) {
				_editor = new ParameterPropertyEditor();
				_editor.clickHandler = doEditorClick;
				_editor.dialogButton.toolTip = resourceManager.getString("ProcessEditorETC", "parameterSettingTTip");
			}

			_pool = source as Pool;
			_editor.data = _paramString;
			
			return _editor;
		}


		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		private function doEditorClick(editor: ParameterPropertyEditor): void {
			var position:Point = editor.localToGlobal(new Point(0, 0));
			ParameterSettingDialog.execute(_pool, _pool.formalParameters, doAccept, position, 500, 400);
		}

		private function doAccept(parameters: Array): void {
			if (parameters != null){
				_pool.formalParameters = parameters;
			
				_paramString = "";
				if(parameters){
					var first:Boolean = true; 
					for each (var param: FormalParameter in parameters){
						_paramString += (first ? "":", ") + param.id;
						first=false;					
					}
				}
				_editor.editValue = _paramString;
			}
		}
	}
}