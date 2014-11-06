////////////////////////////////////////////////////////////////////////////////
//  ScriptUtils.as
//  2008.04.02, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.common
{
	import flash.external.ExternalInterface;
	
	/**
	 * JavaScript 관련 
	 */ 	
	public class ScriptUtils {
		
		public static function alert(message: String): void {
			var script: XML = 
				<script>
					<![CDATA[
						function(str) {
							alert(str);
						}
					]]>
				</script>;
				
			ExternalInterface.call(script, message);
		}
	}
}