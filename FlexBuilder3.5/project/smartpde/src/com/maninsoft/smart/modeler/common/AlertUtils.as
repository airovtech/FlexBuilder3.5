////////////////////////////////////////////////////////////////////////////////
//  AlertUtils.as
//  2008.01.13, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.common
{
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	
	public class AlertUtils {
		
		public static function info(message: String, title: String = "Info"): void {
//			Alert.show("\n\n" + message + "\n", title);
			Alert.show("\n\n" + message + "\n", ResourceManager.getInstance().getString("WorkbenchETC", "informationText"));
			
		}
		
		public static function error(message: String, title: String = "Error"): void {
//			Alert.show("\n\n" + message + "\n", title);
			Alert.show("\n\n" + message + "\n", ResourceManager.getInstance().getString("WorkbenchETC", "errorText"));
			
		}
	}
}