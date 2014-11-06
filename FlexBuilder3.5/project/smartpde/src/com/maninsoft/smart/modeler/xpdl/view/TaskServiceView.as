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
	import com.maninsoft.smart.formeditor.model.SystemService;
	import com.maninsoft.smart.modeler.xpdl.model.TaskService;
	import com.maninsoft.smart.modeler.xpdl.view.base.TaskView;
	import com.maninsoft.smart.modeler.xpdl.view.viewicon.MultiInstanceIcon;
	import com.maninsoft.smart.modeler.xpdl.view.viewicon.SystemTaskIcon;
	import com.maninsoft.smart.modeler.xpdl.view.viewicon.MailTaskIcon;
	
	/**
	 * TaskApplication view
	 */
	public class TaskServiceView extends TaskView {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _systemTaskIcon: SystemTaskIcon;
		private var _mailTaskIcon: MailTaskIcon;
		private var _multiInstanceIcon: MultiInstanceIcon;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function TaskServiceView() {
			super();
		}
		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * serviceType
		 */
		private var _serviceType: String;

		public function get serviceType(): String {
			return _serviceType;
		}
		
		public function set serviceType(value: String): void {
			_serviceType = value;
		}
		
		/**
		 * serviceId
		 */
		private var _serviceId: String;

		public function get serviceId(): String {
			return _serviceId;
		}
		
		public function set serviceId(value: String): void {
			_serviceId = value;
		}
		
		/**
		 * serviceName
		 */
		private var _serviceName: String;

		public function get serviceName(): String {
			return _serviceName;
		}
		
		public function set serviceName(value: String): void {
			_serviceName = value;
		}

		/**
		 * mailReceivers
		 */
		private var _mailReceivers: String;

		public function get mailReceivers(): String {
			return _mailReceivers;
		}
		
		public function set mailReceivers(value: String): void {
			_mailReceivers = value;
		}

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function draw(): void {
			super.draw();
			if (_serviceType == TaskService.SERVICE_TYPE_SYSTEM){
				if (_mailTaskIcon && contains(_mailTaskIcon)) {
					removeChild(_mailTaskIcon);
					_mailTaskIcon = null;
				}
				
				if(serviceId && serviceId != SystemService.EMPTY_SYSTEM_SERVICE){
					if (!_systemTaskIcon) {
						_systemTaskIcon = new SystemTaskIcon(this);
						addChild(_systemTaskIcon);
					}
					
					_systemTaskIcon.systemServiceName = this.serviceName;
					_systemTaskIcon.x = iconViewDelta;
					_systemTaskIcon.y = nodeHeight-iconViewBoxHeight+4;
					iconViewDelta += _systemTaskIcon.width+2;
				}else{
					if (_systemTaskIcon && contains(_systemTaskIcon)) {
						removeChild(_systemTaskIcon);
						_systemTaskIcon = null;
					}
				}
			}else if (_serviceType == TaskService.SERVICE_TYPE_MAIL) {
				if (_systemTaskIcon && contains(_systemTaskIcon)) {
					removeChild(_systemTaskIcon);
					_systemTaskIcon = null;
				}
				
				if (!_mailTaskIcon) {
					_mailTaskIcon = new MailTaskIcon(this);
					addChild(_mailTaskIcon);
				}
				
				_mailTaskIcon.x = iconViewDelta;
				_mailTaskIcon.y = nodeHeight-iconViewBoxHeight+4;
			}

			if (isMultiInstance) {
				if (!_multiInstanceIcon) {
					_multiInstanceIcon = new MultiInstanceIcon(this);
					addChild(_multiInstanceIcon);
				}
				
				_multiInstanceIcon.multiInstanceBehavior = this.multiInstanceBehavior;
				_multiInstanceIcon.x = iconViewDelta;
				_multiInstanceIcon.y = nodeHeight-iconViewBoxHeight+4;
				iconViewDelta += _multiInstanceIcon.width+2;
			}
			else if (_multiInstanceIcon && contains(_multiInstanceIcon)) {
				removeChild(_multiInstanceIcon);
				_multiInstanceIcon = null;
			}
			
			removeProblemIcon();
			
			if (problem) {
				problemIcon.problem = problem;
				problemIcon.x = 0.5;
				problemIcon.y = 0.5;
				
				addChild(problemIcon);
			}
		}
	}
}