////////////////////////////////////////////////////////////////////////////////
//  ActivityTypes.as
//  2008.02.25, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model.base
{
	import mx.resources.ResourceManager;
	/**
	 * 사용자가 구분할 수 있는 각 Activity의 타입명을 정의한다.
	 * Activity 하위 클래스들은 이 값들 중 하나를 activityType 속성으로 리턴한다.
	 */
	public class ActivityTypes {


		public static var ACTIVITY			: String 
							= ResourceManager.getInstance().getString("ProcessEditorETC", "activityText");
		
		public static var TASK_APPLICATION	: String 
							= ResourceManager.getInstance().getString("ProcessEditorETC", "taskApplicationText");
		public static var TASK_APPROVAL		: String 
							= ResourceManager.getInstance().getString("ProcessEditorETC", "approvalTaskText");
		public static var START_EVENT		: String 
							= ResourceManager.getInstance().getString("ProcessEditorETC", "startEventText");
		public static var END_EVENT			: String 
							= ResourceManager.getInstance().getString("ProcessEditorETC", "endEventText");
		public static var INTERMEDIATE_EVENT: String 
							= ResourceManager.getInstance().getString("ProcessEditorETC", "intermediateEventText");
		public static var AND_GATEWAY		: String 
							= ResourceManager.getInstance().getString("ProcessEditorETC", "andGatewayText");
		public static var XOR_GATEWAY		: String 
							= ResourceManager.getInstance().getString("ProcessEditorETC", "xorGatewayText");
		public static var OR_GATEWAY		: String 
							= ResourceManager.getInstance().getString("ProcessEditorETC", "orGatewayText");
		public static var SUBFLOW			: String 
							= ResourceManager.getInstance().getString("ProcessEditorETC", "subFlowText");
		public static var TASK_SERVICE		: String 
							= ResourceManager.getInstance().getString("ProcessEditorETC", "taskServiceText");
		
		
		public static function getTypes(): Array {
			return [
				TASK_APPLICATION,
				TASK_APPROVAL,
				START_EVENT,
				END_EVENT,
				INTERMEDIATE_EVENT,
				AND_GATEWAY,
				XOR_GATEWAY,
				SUBFLOW,
				TASK_SERVICE
			];
		}
		
		public static function isValidType(type: String): Boolean {
			return getTypes().indexOf(type) >= 0;
		}
	}
}