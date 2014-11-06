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
	import com.maninsoft.smart.modeler.xpdl.server.Group;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.StringUtil;
	
	/**
	 * 하위 부서들을 가져오는 서비스
	 */
	public class FindGroupsService extends ServiceBase {
		
		//----------------------------------------------------------------------
		// Service parameters
		//----------------------------------------------------------------------

		public var compId: String;
		public var userId: String;
		

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _groups: Array /* of Group */;


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function FindGroupsService() {
			super("findGroups");
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * dept
		 */
		public function get groups(): Array {
			return _groups;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override protected function get params(): Object {
			var obj: Object = new Object();
			
			obj.compId = compId;
			obj.userId = userId;
			
			return obj;
		}
		
		override protected function doResult(event: ResultEvent): void {
			trace(event);
			
			var xml: XML = new XML(StringUtil.trim(event.message.body.toString()));
			_groups = [];
			
			for each (var x: XML in xml.item) {
				var group: Group = new Group();

				group.id	= x.@id;
				group.name	= x.@name;
				
				_groups.push(group);
			}
			
			super.doResult(event);
		}
		
		override protected function doFault(event: FaultEvent): void {
			trace("FindGroupsService: " + event);
			
			super.doFault(event);
		}
	}
}