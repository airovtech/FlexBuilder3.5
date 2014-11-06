////////////////////////////////////////////////////////////////////////////////
//  INodeFactory.as
//  2007.12.20, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.editor
{
	import com.maninsoft.smart.modeler.model.Node;
	
	public interface INodeFactory	{
		
		function createNode(nodeType: String): Node;		
	}
}