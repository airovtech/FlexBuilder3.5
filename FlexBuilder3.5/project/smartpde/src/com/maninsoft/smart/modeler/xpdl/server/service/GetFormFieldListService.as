////////////////////////////////////////////////////////////////////////////////
//  GetFormFieldListService.as
//  2008.01.30, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.server.service
{
	import com.maninsoft.smart.formeditor.model.type.FormatType;
	import com.maninsoft.smart.formeditor.model.type.FormatTypes;
	import com.maninsoft.smart.modeler.xpdl.server.TaskFormField;
	
	import mx.rpc.events.ResultEvent;
	import mx.utils.StringUtil;
	
	/**
	 * 폼필드 목록을  내려받는 서비스
	 */
	public class GetFormFieldListService extends ServiceBase
	{
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		//------------------------------
		// Parameters
		//------------------------------
		public var compId: String;
		public var userId: String;
		public var packageId: String;
		public var version: String;
		
		private var _fields: Array;
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function GetFormFieldListService() {
			super("getFormFieldList");
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * fields
		 */
		public function get fields(): Array {
			return _fields;
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
			_fields = [];
			
			for each (var x: XML in xml.formField) {
				var field: TaskFormField = new TaskFormField();
				
				field.formId = x.formId;
				field.id = x.id;
				field.name = x.name;
				field.type = x.type;
				field.icon = FormatTypes.getIcon(field.type);
				_fields.push(field);
			}
			
			super.doResult(event);
		}
	}
}