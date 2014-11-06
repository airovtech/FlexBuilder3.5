////////////////////////////////////////////////////////////////////////////////
//  TaskUserController.as
//  2008.01.11, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.workbench.common.util
{
	public class StringUtils {
		
		public static const EMPTY_STRING: String = "";
		
		public static function toString(val: Object): String {
			return val ? val.toString() : EMPTY_STRING;
		}
		
		public static function colorToNumber(color: String): uint {
			if (!color) color = "0";
			color = color.toLowerCase();
			if (color.indexOf("0x") != 0)
				color = "0x" + color;
				
			return uint(color);
		}
	}
}