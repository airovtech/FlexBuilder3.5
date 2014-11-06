////////////////////////////////////////////////////////////////////////////////
//  ArrayCollectionUtils.as
//  2007.12.27, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.common
{
	import mx.collections.ArrayCollection;
	
	public class ArrayCollectionUtils {
		
		/**
		 * ArrayCollection 에 removeItem(item) 이 왜 없는지 모르겠다.
		 * 실제로 지웠으면 true를 리턴한다.
		 */
		public static function removeItem(array: ArrayCollection, item: Object): Boolean {
			if (array) {
				var idx: int = array.getItemIndex(item);
				
				if (idx >= 0)
					return array.removeItemAt(idx) != null;					
			}
			
			return false;
		}
		
		/**
		 * item의 위치를 newIndex로 바꾼다.
		 * 실제로 변경되었을 때 true를 리턴한다.
		 */
		public static function moveItem(array: ArrayCollection, item: Object, newIndex: int): Boolean {
			if (array && item && newIndex >= 0 && newIndex < array.length) {
				var idx: int = array.getItemIndex(item);
				
				if (idx >= 0 && idx != newIndex) {
					array.removeItemAt(idx);
					array.addItemAt(item, newIndex);
					return true;
				}
			}
			
			return false;
		}
	}
}