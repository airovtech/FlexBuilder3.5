////////////////////////////////////////////////////////////////////////////////
//  ComponentUtils.as
//  2007.12.14, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.common
{
	import flash.display.DisplayObjectContainer;
	
	public class ComponentUtils {
		
		public static function clearChildren(parent: DisplayObjectContainer): void {
			while (parent.numChildren > 0) {
				parent.removeChildAt(0);
			}
		}
		
		public static function clearChildrenByType(parent: DisplayObjectContainer, cls: Class): void {
			for (var i: int = parent.numChildren - 1; i >=0; i--) {
				if (parent.getChildAt(i) is cls) {
					parent.removeChildAt(i);
				}
			}
		}
	}
}