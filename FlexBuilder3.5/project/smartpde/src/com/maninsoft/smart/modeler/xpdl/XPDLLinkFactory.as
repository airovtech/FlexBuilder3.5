////////////////////////////////////////////////////////////////////////////////
//  XPDLLinkFactory.as
//  2008.01.07, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl
{
	import com.maninsoft.smart.modeler.editor.impl.LinkFactory;
	import com.maninsoft.smart.modeler.model.Link;
	import com.maninsoft.smart.modeler.model.Node;
	import com.maninsoft.smart.modeler.xpdl.model.StartEvent;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLLink;
	
	/**
	 * XPDLEditor를 위한 Link factory
	 */
	public class XPDLLinkFactory extends LinkFactory {
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */		
		public function XPDLLinkFactory(owner: XPDLEditor) {
			super(owner);
		}


		//----------------------------------------------------------------------
		// INodeFactory
		//----------------------------------------------------------------------

		override public function createLink(linkType: String, source: Node, target: Node, path: String = null, connectType: String = null): Link {
			var link: XPDLLink = new XPDLLink(source as Activity, target as Activity, path, connectType);
			return link;
		}
	}
}