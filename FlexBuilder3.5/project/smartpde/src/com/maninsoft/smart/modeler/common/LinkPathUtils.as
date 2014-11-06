////////////////////////////////////////////////////////////////////////////////
//  LinkPathUtils.as
//  2007.12.31, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
//
//  Addio 2007 !! 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.common
{
	public class LinkPathUtils	{
		
		public static function makePath(sourceAnchor: Number, targetAnchor: Number): String {
			return sourceAnchor + "," + targetAnchor;
		}
	}
}