////////////////////////////////////////////////////////////////////////////////
//  IMappingLink.as
//  2007.01.09, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.mapper
{
	/**
	 * SmartMapperItem 간의 연결
	 */
	public interface IMappingLink	{
		
		/**
		 * 링크의 소스가 되는 IMappingItem
		 */
		function get sourceItem(): IMappingItem;
		/**
		 * 링크의 타깃이 되는 IMappingItem
		 */
		function get targetItem(): IMappingItem;
	}
}