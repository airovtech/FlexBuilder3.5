////////////////////////////////////////////////////////////////////////////////
//  XorGateway.as
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
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLLink;
	
	/**
	 * XPDL XorGateway Route
	 */
	public class XorGateway extends Gateway {

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/**
		 * Construtor 
		 */
		public function XorGateway() {
			super();
			
			gatewayType = "XOR";
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * 출력 링크 중 IsDefault가 true인 것들의 갯수
		 */
		public function get defaultTransitionCount(): uint {
			var cnt: uint = 0;
			
			if (_sourceLinks)
				for each (var link: XPDLLink in _sourceLinks) {
					if (link.isDefault)
						cnt++;
				}
			
			return cnt;
		}
		
		/**
		 * 출력 링크 중 IsDefault가 true 인 것 리턴
		 */
		public function get defaultTransition(): XPDLLink {
			if (_sourceLinks)
				for each (var link: XPDLLink in _sourceLinks) {
					if (link.isDefault)
						return link;
				}

			return null;
		}


		//----------------------------------------------------------------------
		// Overriden properties
		//----------------------------------------------------------------------

		override public function get activityType(): String {
			return ActivityTypes.XOR_GATEWAY;
		}

		override public function get defaultName(): String {
			return "Xor";
		}
	}
}