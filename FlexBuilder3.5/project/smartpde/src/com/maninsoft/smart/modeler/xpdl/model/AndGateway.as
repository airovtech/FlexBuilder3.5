////////////////////////////////////////////////////////////////////////////////
//  AndGateway.as
//  2007.12.20, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model 
{
	import com.maninsoft.smart.modeler.xpdl.model.base.ActivityTypes;
	import com.maninsoft.smart.modeler.xpdl.model.base.Gateway;
	
	/**
	 * XPDL AndGateway Route
	 */
	public class AndGateway extends Gateway	{

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/**
		 * Construtor 
		 */
		public function AndGateway() {	
			super();
			
			gatewayType = "AND";
		}


		//----------------------------------------------------------------------
		// Overriden properties
		//----------------------------------------------------------------------

		override public function get activityType(): String {
			return ActivityTypes.AND_GATEWAY;
		}

		override public function get defaultName(): String {
			return "And";
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

	}
}