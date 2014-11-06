////////////////////////////////////////////////////////////////////////////////
//  IConnectionRouter.as
//  2007.12.26, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.view.connection
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 주어진 두 지점을 연결하는 연결선의 경로를 계산
	 */
	public interface IConnectionRouter 	{
		
		/**
		 * 경로를 나타내는 Point 배열을 리턴한다.
		 */
		function route(sourceBounds: Rectangle, sourcePoint: Point, sourceAnchor: Number,
		                targetBounds: Rectangle, targetPoint: Point, targetAnchor: Number): Array;
	}
}