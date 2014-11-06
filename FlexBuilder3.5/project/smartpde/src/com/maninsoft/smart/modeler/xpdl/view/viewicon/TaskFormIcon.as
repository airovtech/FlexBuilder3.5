////////////////////////////////////////////////////////////////////////////////
//  TaskFormIcon.as
//  2008.01.30, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.view.viewicon
{
	import com.maninsoft.smart.modeler.assets.XPDLEditorAssets;
	import com.maninsoft.smart.modeler.view.IView;
	import com.maninsoft.smart.modeler.view.ViewIcon;
	import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
	
	import flash.display.Graphics;
	
	import mx.core.SpriteAsset;
	
	/**
	 * TaskApplication에 taskFormdl 설정됐을 때 표시
	 */
	public class TaskFormIcon extends ViewIcon {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var taskFormIcon: SpriteAsset = SpriteAsset(new XPDLEditorAssets.taskSystemFormIcon());	

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function TaskFormIcon(view: IView) {
			super(view);
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * formId
		 */
		private var _formId: String;
		
		public function get formId(): String {
			return _formId;
		}
		
		public function set formId(value: String): void {
			_formId = value;
		}

		/**
		 * formName
		 */
		private var _formName: String;
		
		public function get formName(): String {
			return _formName;
		}
		
		public function set formName(value: String): void {
			_formName = value;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override public function get toolTip(): String {
			var displayFormName:String = formName;
			if(formName=="" || formName==null || formName=="null"){
				displayFormName = TaskApplication.SYSTEM_FORM_NAME;
			}
			return displayFormName;
		}
		

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function draw(g: Graphics): void {
			if(contains(taskFormIcon))
				removeChild(taskFormIcon);
			addChild(taskFormIcon);
		}
	}
}