////////////////////////////////////////////////////////////////////////////////
//  PackageTreeForms.as
//  2008.04.25, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.packages
{
	import com.maninsoft.smart.modeler.xpdl.navigator.DiagramTreeNode;
	import com.maninsoft.smart.modeler.xpdl.server.TaskForm;
	import com.maninsoft.smart.modeler.assets.DiagramNavigatorAssets;

	
	/**
	 * PakcageNavigator 의 단위업무 노드
	 */
	public class PackageTreeForm extends DiagramTreeNode {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _formId: String;
		private var _formName: String;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function PackageTreeForm(form: TaskForm) {
			super();
			
			_formId = form.formId;
			_formName = form.name;
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		public function get formId(): String {
			return _formId;
		}
		
		public function get formName(): String {
			return _formName;
		}
		
		public function set formName(val:String): void {
			this._formName = val;
		}

		
		//----------------------------------------------------------------------
		// Overriden properties
		//----------------------------------------------------------------------
		
		override public function get label(): String {
			return _formName;
		}
		
		override public function get icon(): Class {
			return DiagramNavigatorAssets.formIcon;
		}

		override public function get editable(): Boolean {
			return true;
		}
	}
}