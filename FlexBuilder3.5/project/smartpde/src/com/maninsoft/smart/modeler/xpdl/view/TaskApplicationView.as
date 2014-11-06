////////////////////////////////////////////////////////////////////////////////
//  TaskApplicationView.as
//  2007.12.21, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.view
{
	import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
	import com.maninsoft.smart.modeler.xpdl.server.ApplicationService;
	import com.maninsoft.smart.modeler.xpdl.server.ApprovalLine;
	import com.maninsoft.smart.modeler.xpdl.view.base.TaskView;
	import com.maninsoft.smart.modeler.xpdl.view.viewicon.ApprovalLineIcon;
	import com.maninsoft.smart.modeler.xpdl.view.viewicon.CustomFormIcon;
	import com.maninsoft.smart.modeler.xpdl.view.viewicon.MeanTimeIcon;
	import com.maninsoft.smart.modeler.xpdl.view.viewicon.MultiInstanceIcon;
	import com.maninsoft.smart.modeler.xpdl.view.viewicon.TaskFormIcon;
	
	/**
	 * TaskService view
	 */
	public class TaskApplicationView extends TaskView {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _taskFormIcon: TaskFormIcon;
		private var _customFormIcon: CustomFormIcon;
		private var _approvalLineIcon: ApprovalLineIcon;
		private var _multiInstanceIcon: MultiInstanceIcon;
		private var _meanTimeIcon: MeanTimeIcon;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function TaskApplicationView() {
			super();
		}
		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		private var _appId: String;
		
		public function get appId(): String{
			return _appId;
		}
		public function set appId(value: String):void{
			_appId = value;
		}
		
		private var _appName: String;
		
		public function get appName(): String{
			return _appName;
		}
		public function set appName(value: String):void{
			_appName = value;
		}
		
		/**
		 * taskFormId
		 */
		private var _taskFormId: String;

		public function get taskFormId(): String {
			return _taskFormId;
		}
		
		public function set taskFormId(value: String): void {
			_taskFormId = value;
		}
		
		/**
		 * taskFormName
		 */
		private var _taskFormName: String;

		public function get taskFormName(): String {
			return _taskFormName;
		}
		
		public function set taskFormName(value: String): void {
			_taskFormName = value;
		}

		private var _approvalLine: String;

		public function get approvalLine(): String {
			return _approvalLine;
		}
		
		public function set approvalLine(value: String): void {
			_approvalLine = value;
		}

		private var _approvalLineName: String;

		public function get approvalLineName(): String {
			return _approvalLineName;
		}
		
		public function set approvalLineName(value: String): void {
			_approvalLineName = value;
		}
		
		private var _meanTimeInHours: Number=-1;

		public function get meanTimeInHours(): Number {
			return _meanTimeInHours;
		}

		public function set meanTimeInHours(value: Number): void {
			_meanTimeInHours = value;
		}

		private var _passedTimeInHours: Number=-1;

		public function get passedTimeInHours(): Number {
			return _passedTimeInHours;
		}

		public function set passedTimeInHours(value: Number): void {
			_passedTimeInHours = value;
		}

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function draw(): void {

			/* U-City related
			this.fontSize = 14;
			*/
			
			super.draw();
			
			
			if (taskFormId && appId == TaskApplication.SYSTEM_APPLICATION_ID) {
				if (!_taskFormIcon) {
					_taskFormIcon = new TaskFormIcon(this);
					addChild(_taskFormIcon);
				}
				
				_taskFormIcon.formId = this.taskFormId;
				_taskFormIcon.formName = this.taskFormName;
				_taskFormIcon.x = iconViewDelta;
				_taskFormIcon.y = this.nodeHeight - iconViewBoxHeight + 4;
				iconViewDelta += _taskFormIcon.width+2;
			}
			else if (_taskFormIcon && contains(_taskFormIcon)) {
				removeChild(_taskFormIcon);
				_taskFormIcon = null;
			}
			
			if (appId && appId != ApplicationService.EMPTY_APPLICATION_SERVICE && appId != TaskApplication.SYSTEM_APPLICATION_ID) {
				if (!_customFormIcon) {
					_customFormIcon = new CustomFormIcon(this);
					addChild(_customFormIcon);
				}
				
				_customFormIcon.customFormId = this.appId;
				_customFormIcon.customFormName = this.appName;
				_customFormIcon.x = iconViewDelta;
				_customFormIcon.y = this.nodeHeight - iconViewBoxHeight + 4;
				iconViewDelta += _customFormIcon.width+2;
			}
			else if (_customFormIcon && contains(_customFormIcon)) {
				removeChild(_customFormIcon);
				_customFormIcon = null;
			}
			
			if (approvalLine && approvalLine != ApprovalLine.EMPTY_APPROVAL) {
				if (!_approvalLineIcon) {
					_approvalLineIcon = new ApprovalLineIcon(this);
					addChild(_approvalLineIcon);
				}
				
				_approvalLineIcon.approvalLineName = this.approvalLineName;
				_approvalLineIcon.x = iconViewDelta;
				_approvalLineIcon.y = nodeHeight-iconViewBoxHeight+4;
				iconViewDelta += _approvalLineIcon.width+2;
			}
			else if (_approvalLineIcon && contains(_approvalLineIcon)) {
				removeChild(_approvalLineIcon);
				_approvalLineIcon = null;
			}
			
			if (isMultiInstance) {
				if (!_multiInstanceIcon) {
					_multiInstanceIcon = new MultiInstanceIcon(this);
					addChild(_multiInstanceIcon);
				}
				
				_multiInstanceIcon.multiInstanceBehavior = this.multiInstanceBehavior;
				_multiInstanceIcon.x = iconViewDelta+2;
				_multiInstanceIcon.y = nodeHeight-iconViewBoxHeight+4+1;
				iconViewDelta += 2+_multiInstanceIcon.width+2;
			}
			else if (_multiInstanceIcon && contains(_multiInstanceIcon)) {
				removeChild(_multiInstanceIcon);
				_multiInstanceIcon = null;
			}
			
			if(_meanTimeIcon && contains(_meanTimeIcon))
				removeChild(_meanTimeIcon);
			_meanTimeIcon = new MeanTimeIcon(this);
				
			_meanTimeIcon.meanTimeInHours = this.meanTimeInHours;
			_meanTimeIcon.passedTimeInHours = this.passedTimeInHours;
			_meanTimeIcon.x = nodeWidth-_meanTimeIcon.width-2;
			_meanTimeIcon.y = nodeHeight-iconViewBoxHeight+3;
			addChild(_meanTimeIcon);

			removeProblemIcon();
			
			if (problem) {
				problemIcon.problem = problem;
				problemIcon.x = 1;
				problemIcon.y = 1;
				
				addChild(problemIcon);
			}
		}
	}
}