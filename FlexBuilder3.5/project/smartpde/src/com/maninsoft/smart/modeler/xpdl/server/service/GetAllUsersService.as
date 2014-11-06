////////////////////////////////////////////////////////////////////////////////
//  GetAllUsersService.as
//  2008.04.08, created by gslim
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
	 * 모든 사용자를 가져오는 서비스
	 */
	public class GetAllUsersService extends ServiceBase {
		
		//----------------------------------------------------------------------
		// Service parameters
		//----------------------------------------------------------------------

		public var userId: String;
		

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _users: Array /* of User */;


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function GetAllUsersService() {
			super("findAllUsers");
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * users
		 */
		public function get users(): Array /* of User */ {
			return _users;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override protected function get params(): Object {
			var obj: Object = new Object();
			
			obj.userId = userId;
			
			return obj;
		}
		
		override protected function doResult(event:ResultEvent): void {
			trace(event);
			
			var xml: XML = new XML(StringUtil.trim(event.message.body.toString()));
			_users = [];
			
			for each (var x: XML in xml.User) {
				var user: User = new User();

				user.id			= x.id;
				user.passwd 	= x.passwd;
				user.name		= x.name;
				user.type		= x.type;
				user.deptId		= x.deptId;
				user.position	= x.position;
				user.email		= x.email;
				var roleId:String = x.roleId;
				if(roleId == User.USER_TEAM_LEADER)
					user.isTeamLeader = true;
				else
					user.isTeamLeader = false; 

				_users.push(user);	
			}
			
			super.doResult(event);
		}
		
		override protected function doFault(event:FaultEvent): void {
			trace("GetAllUsersService: " + event);
			
			super.doFault(event);
		}
	}
}