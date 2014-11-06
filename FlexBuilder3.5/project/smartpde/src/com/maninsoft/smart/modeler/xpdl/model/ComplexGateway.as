////////////////////////////////////////////////////////////////////////////////
//  ComplexGateway.as
//  2008.01.14, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model 
{
	import com.maninsoft.smart.modeler.xpdl.model.base.Gateway;
	
	/**
	 * XPDL XorGateway Route
	 */
	public class ComplexGateway extends Gateway {

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/**
		 * Construtor 
		 */
		public function ComplexGateway() {
			super();
			
			gatewayType = "Complex";
		}
	}
}