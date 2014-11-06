////////////////////////////////////////////////////////////////////////////////
//  IXPDLElement.as
//  2008.01.09, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model
{
	/**
	 * IXPDLElement
	 */
	public interface IXPDLElement	{
		
		function read(src: XML): void;
		function write(dst: XML): void;
	}
}