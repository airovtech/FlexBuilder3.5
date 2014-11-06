////////////////////////////////////////////////////////////////////////////////
//  ArrayUtils.as
//  2008.01.13, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.common
{
	public class ArrayUtils {
		
		public static const EMPTY_ARRAY: Array = [];
		
		/**
		 * 실제로 삭제했으면 true 반환
		 */
		public static function removeItem(array: Array, item: Object): Boolean {
			if (array) {
				var idx: int = array.indexOf(item);
				
				if (idx >= 0) {
					array.splice(idx, 1);
					return true;
				}
			}
			
			return false;
		}
		
		public static function copy(source: Array): Array {
			return new Array().concat(source);
		}
	}
}