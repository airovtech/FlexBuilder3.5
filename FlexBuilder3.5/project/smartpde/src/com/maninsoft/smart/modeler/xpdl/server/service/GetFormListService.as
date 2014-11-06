////////////////////////////////////////////////////////////////////////////////
//  GetFormListService.as
//  2008.01.30, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.server.service
{
	import com.maninsoft.smart.modeler.xpdl.server.TaskForm;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.StringUtil;
	
	/**
	 * 작업 폼 목록을 내려받는 서비스
	 */
	public class GetFormListService extends ServiceBase
	{
		//----------------------------------------------------------------------
		// Service parameters
		//----------------------------------------------------------------------

		public var compId: String;
		public var userId: String;
		public var packageId: String;
		public var version: String;
		

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _forms: Array /* of TaskForm */;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function GetFormListService() {
			super("getFormList");
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * forms
		 */
		public function get forms(): Array /* of TaskForm */ {
			return _forms;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override protected function get params(): Object {
			var obj: Object = new Object();
			
			obj.compId = compId;
			obj.userId = userId;
			obj.packageId = packageId;
			obj.version = version;
			
			return obj;
		}
		
		override protected function doResult(event:ResultEvent): void {
			trace(event);
			
			var xml: XML = new XML(StringUtil.trim(event.message.body.toString()));
			_forms = [];
			
			for each (var x: XML in xml.Form) {
				var form: TaskForm = new TaskForm();

				form.id			= x.id;
				form.packageId	= x.packageId;
				form.formId		= x.formId;
				form.version	= x.version;
				form.name		= x.name;
				form.status		= x.stauts;
				form.creator	= x.creator;
				form.type		= x.type;

				_forms.push(form);	
			}
			
			super.doResult(event);
		}
		
		override protected function doFault(event:FaultEvent): void {
			trace("GetFormListServce: " + event);
			
			super.doFault(event);
		}
	}
}