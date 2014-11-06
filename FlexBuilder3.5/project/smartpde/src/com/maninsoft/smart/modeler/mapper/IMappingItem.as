////////////////////////////////////////////////////////////////////////////////
//  IMappingItem.as
//  2007.01.09, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.mapper
{
	/**
	 * Data mapping 의 연결 소스가 되는 항목
	 */
	public interface IMappingItem	{
		
		function get key(): Object;
		function get label(): String;
	}
}