////////////////////////////////////////////////////////////////////////////////
//  FormIdPropertyInfo.as
//  2008.03.17, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.property
{
	import com.maninsoft.smart.modeler.xpdl.dialogs.SelectWorkIdDialog;
	import com.maninsoft.smart.modeler.xpdl.model.SubFlow;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.server.ProcessRef;
	import com.maninsoft.smart.modeler.xpdl.server.service.GetProcessInfoByPackageService;
	import com.maninsoft.smart.workbench.common.assets.PropertyIconLibrary;
	import com.maninsoft.smart.workbench.common.model.WorkPackage;
	import com.maninsoft.smart.workbench.common.property.ButtonPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertySource;
	import com.maninsoft.smart.workbench.common.property.PropertyInfo;
	
	import flash.geom.Point;
	
	/**
	 * TaskApplication 의 formId
	 */
	public class SubProcessIdPropertyInfo extends PropertyInfo{
		
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _editor: ButtonPropertyEditor;
		private var _subFlow: SubFlow;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function SubProcessIdPropertyInfo(id: String, displayName: String, 
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
			_subFlow = source as SubFlow;
			
			if (!_editor) {
				_editor = new ButtonPropertyEditor();
				_editor.clickHandler = doEditorClick;
				_editor.buttonIcon = PropertyIconLibrary.subFlowSelectIcon;
				_editor.dialogButton.toolTip = resourceManager.getString("ProcessEditorETC", "subProcessIdSelectTTip");
			}
			return _editor;
		}

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		private function doEditorClick(editor: ButtonPropertyEditor): void {
			var dgm: XPDLDiagram = _subFlow.xpdlDiagram;
			var position:Point = _editor.localToGlobal(new Point(0, _editor.height+1));
			SelectWorkIdDialog.execute(dgm.server, _editor, _subFlow.subProcessId, doAccept, WorkPackage.PACKAGE_TYPE_PROCESS, position, _editor.width);
		}

		private function doAccept(item: Object): void {
			if(WorkPackage(item).id == WorkPackage.INTERNAL_PROCESS_ID){
				_subFlow.subProcessInfo = null;
				_editor.editValue = WorkPackage(item).name;
			}else{
				_subFlow.xpdlDiagram.server.getProcessInfoByPackage(WorkPackage(item).id, WorkPackage(item).version, getProcessInfoCallback);
				function getProcessInfoCallback(svc: GetProcessInfoByPackageService):void{
					_subFlow.subProcessInfo = svc.process ;
					_editor.editValue = _subFlow.subProcessName;
				}
			}
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
		
		public function get subFlow(): SubFlow {
			return _subFlow;
		}
		
		public function set subFlow(val: SubFlow): void {
			_subFlow = val;
		}
	}
}