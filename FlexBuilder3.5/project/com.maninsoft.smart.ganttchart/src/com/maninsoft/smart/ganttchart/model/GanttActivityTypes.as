////////////////////////////////////////////////////////////////////////////////
//  ActivityTypes.as
//  2008.02.25, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.ganttchart.model
{
	import mx.resources.ResourceManager;
	
	/**
	 * 사용자가 구분할 수 있는 각 Activity의 타입명을 정의한다.
	 * Activity 하위 클래스들은 이 값들 중 하나를 activityType 속성으로 리턴한다.
	 */
	public class GanttActivityTypes {

		internal static var activityText:String = ResourceManager.getInstance().getString("GanttChartETC", "activityText");
		internal static var taskText:String = ResourceManager.getInstance().getString("GanttChartETC", "taskText");
		internal static var taskGroupText:String = ResourceManager.getInstance().getString("GanttChartETC", "groupTaskText");
		internal static var milestoneText:String = ResourceManager.getInstance().getString("GanttChartETC", "milestoneText");
		 
		public static const ACTIVITY			: String = activityText;
		
		public static const GANTT_TASK			: String = taskText;
		public static const GANTT_TASKGROUP		: String = taskGroupText;
		public static const GANTT_MILESTONE		: String = milestoneText;
		
		
		public static function getTypes(): Array {
			return [
				GANTT_TASK,
				GANTT_TASKGROUP,
				GANTT_MILESTONE
			];
		}
		
		public static function isValidType(type: String): Boolean {
			return getTypes().indexOf(type) >= 0;
		}
	}
}