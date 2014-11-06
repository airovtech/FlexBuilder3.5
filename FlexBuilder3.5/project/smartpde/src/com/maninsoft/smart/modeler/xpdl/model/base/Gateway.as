////////////////////////////////////////////////////////////////////////////////
//  Gateway.as
//  2007.12.20, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model.base
{
	import com.maninsoft.smart.modeler.xpdl.model.process.TransitionRestriction;
	import com.maninsoft.smart.modeler.xpdl.server.Server;
	
	/**
	 * XPDL Gateway activity
	 */
	public class Gateway extends Activity	{

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		//------------------------------
		// XPDL
		//------------------------------
		
		public var gatewayType: String;


		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/**
		 * Construtor 
		 */
		public function Gateway() {
			super();
			
			fillColor = 0xa5b8ce;
		}
		

		//----------------------------------------------------------------------
		// IXPDLElement
		//----------------------------------------------------------------------
		
		override protected function doRead(src: XML): void {
			var xml: XML = src._ns::Route[0];
			
			// class로 결정됨.
			// gatewayType = xml.@GatewayType;

			super.doRead(src);
		}

		override protected function doWrite(dst: XML): void {
			dst._ns::Route = "";
			var xml: XML = dst._ns::Route[0];
			
			xml.@GatewayType = gatewayType;
			
			super.doWrite(dst);
		}
		
		
		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override public function get defaultName(): String {
			return "Gateway";
		}

		override public function get defaultWidth(): Number {
			return 50;
		}
		
		override public function get defaultHeight(): Number {
			return 50;
		}
		
		override public function get defaultFillColor(): uint {
			return 0xa5b8ce;
		}
		
		
		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override protected function makeTransitionRestrictions(restrictions: Array): Array {
			var res: TransitionRestriction;
			
			if (restrictions.length > 0) {
				res = restrictions[0] as TransitionRestriction;
			} else {
				res = new TransitionRestriction(this);
				restrictions.push(res);
			}
			
			if (targetLinks.length > 1) {
				res.joinType = gatewayType;
				res.incomingCondition = "";
				
			} else {
				res.joinType = "";
			}
			
			if (sourceLinks.length > 1) {
				res.splitType = gatewayType;
				res.outgoingCondition = "";
				
				res.transitionRefs = [];
				
				for each (var link: XPDLLink in sourceLinks) {
					res.transitionRefs.push(link);	
				}
				
			} else {
				res.splitType = "";
			}
			
			
			return restrictions;		
		}
	}
}