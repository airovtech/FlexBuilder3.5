////////////////////////////////////////////////////////////////////////////////
//  ILinkFactory.as
//  2008.01.07, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.editor
{
	import com.maninsoft.smart.modeler.model.Link;
	import com.maninsoft.smart.modeler.model.Node;
	
	public interface ILinkFactory	{
		
		function createLink(linkType: String, source: Node, target: Node, 
							 path: String = null, connectType: String = null): Link;
	}
}