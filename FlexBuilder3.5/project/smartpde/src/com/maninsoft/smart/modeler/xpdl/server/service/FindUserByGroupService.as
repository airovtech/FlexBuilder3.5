////////////////////////////////////////////////////////////////////////////////
//  FindUserByDeptService.as
//  2008.04.24, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.server.service
{
	import com.maninsoft.smart.modeler.xpdl.server.User;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.StringUtil;
	
	/**
	 * 하위 부서들을 가져오는 서비스
	 */
	public class FindUserByGroupService extends ServiceBase {
		
		//----------------------------------------------------------------------
		// Service parameters
		//----------------------------------------------------------------------

		public var compId: String;
		public var userId: String;
		public var groupId: String;
		

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _users: Array /* of User */;


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function FindUserByGroupService() {
			super("findUserByGroup");
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * users
		 */
		public function get users(): Array {
			return _users;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override protected function get params(): Object {
			var obj: Object = new Object();
			
			obj.compId = compId;
			obj.userId = userId;
			obj.groupId = groupId;
			
			return obj;
		}
		
		override protected function doResult(event: ResultEvent): void {
			trace(event);
			
			var xml: XML = new XML(StringUtil.trim(event.message.body.toString()));
			_users = [];
			
			for each (var x: XML in xml.User) {
				var user: User = new User();

				user.id	= x.id;
				user.name	= x.name;
				user.position = x.position;
				user.email = x.email;
				var roleId:String = x.roleId;
				if(roleId == User.USER_TEAM_LEADER)
					user.isTeamLeader = true;
				else
					user.isTeamLeader = false; 
				
				_users.push(user);
			}
			
			super.doResult(event);
		}
		
		override protected function doFault(event: FaultEvent): void {
			trace("FindUserByGroupService: " + event);
			
			super.doFault(event);
		}
	}
}