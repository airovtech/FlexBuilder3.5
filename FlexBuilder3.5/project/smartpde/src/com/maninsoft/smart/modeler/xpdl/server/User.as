////////////////////////////////////////////////////////////////////////////////
//  User.as
//  2008.01.14, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.server
{
	import mx.resources.ResourceManager;
	
	/**
	 * 사용자 모델
	 */
	public class User	{
		
		public static const EMPTY_USER_ID:String = "emptyUser";
		public static const EMPTY_USER_NAME:String = ResourceManager.getInstance().getString("WorkbenchETC", "emptyUserNameText");;
		
		public static const USER_TEAM_LEADER:String = "DEPT LEADER";
		public static const USER_TEAM_MEMBER:String = "DEPT MEMBER";
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function User() {
			super();
		}
		
		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		public var id: String;
		public var name: String;
		public var passwd: String;
		public var type: String;
		public var deptId: String;
		public var position: String;
		public var email: String;
		public var isTeamLeader:Boolean;
		
		public function get children(): Array {
			return null;
		}
		
		public function get label(): String {
			return (position?(position + " "):"") + name;
		}
	}
}