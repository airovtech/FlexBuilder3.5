////////////////////////////////////////////////////////////////////////////////
//  XPDLNodeUtils.as
//  2008.04.07, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.utils
{
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	
	/**
	 * XPDLNode 관련 유틸리티 함수들
	 */
	public class XPDLNodeUtils {
		
		/**
		 * Activity 노드들을 위치상의 순서대로 정렬한다.
		 */
		public static function sortByLocation(nodes: Array /* of XPDLActivity */): void {
			if (nodes && nodes.length > 1) {
				nodes.sort(compareLocation);
			}
		}

		private static function compareLocation(act1: Activity, act2: Activity): Number {
			if (!act1 || !act2)
				return 0;
			
			if (act1.laneId != act2.laneId)
				return act1.laneId - act2.laneId;
				
			if (act1.pool.isVertical) {
				return act1.y - act2.y;		
			}
			else {
				return act1.x - act2.x;
			}
		}
	}
}