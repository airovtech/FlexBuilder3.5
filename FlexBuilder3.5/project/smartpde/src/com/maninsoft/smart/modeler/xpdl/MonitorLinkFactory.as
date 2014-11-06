////////////////////////////////////////////////////////////////////////////////
//  MonitorLinkFactory.as
//  2008.04.08, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl
{
	import com.maninsoft.smart.modeler.model.Link;
	import com.maninsoft.smart.modeler.model.Node;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLLink;
	
	/**
	 * XPDLMontior를 위한 Link factory
	 */
	public class MonitorLinkFactory extends XPDLLinkFactory {
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */		
		public function MonitorLinkFactory(owner: XPDLEditor) {
			super(owner);
		}


		//----------------------------------------------------------------------
		// INodeFactory
		//----------------------------------------------------------------------

		override public function createLink(linkType: String, source: Node, target: Node, 
									path: String = null, connectType: String = null): Link {
			var link: XPDLLink = super.createLink(linkType, source, target, path, connectType) as XPDLLink;
			
			link.lineColor = 0xcccccc;
			
			return link;
		}
	}
}