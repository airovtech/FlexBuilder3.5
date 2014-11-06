////////////////////////////////////////////////////////////////////////////////
//  FindChildDeptService.as
//  2008.04.24, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.server.service
{
	import com.maninsoft.smart.modeler.xpdl.server.Department;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.StringUtil;
	
	/**
	 * 하위 부서들을 가져오는 서비스
	 */
	public class FindChildDeptService extends ServiceBase {
		
		//----------------------------------------------------------------------
		// Service parameters
		//----------------------------------------------------------------------

		public var compId: String;
		public var userId: String;
		public var parentId: String;
		

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _depts: Array /* of Department */;


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function FindChildDeptService() {
			super("findChildDept");
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * dept
		 */
		public function get depts(): Array {
			return _depts;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override protected function get params(): Object {
			var obj: Object = new Object();
			
			obj.compId = compId;
			obj.userId = userId;
			obj.parentId = parentId;
			
			return obj;
		}
		
		override protected function doResult(event: ResultEvent): void {
			trace(event);
			
			var xml: XML = new XML(StringUtil.trim(event.message.body.toString()));
			_depts = [];
			
			for each (var x: XML in xml.item) {
				var dept: Department = new Department();

				dept.id	= x.@id;
				dept.name	= x.@name;
				
				_depts.push(dept);
			}
			
			super.doResult(event);
		}
		
		override protected function doFault(event: FaultEvent): void {
			trace("GetRootDeptService: " + event);
			
			super.doFault(event);
		}
	}
}