////////////////////////////////////////////////////////////////////////////////
//  IDraggable.as
//  2008.01.07, created by gslim
//
//  Merry Christmas!
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////


package com.maninsoft.smart.modeler.editor.tool
{
	import flash.events.MouseEvent;
	
	/**
	 * MouseDown 이벤트 발생 시 DragTracker를 제공하는 개체인가?
	 */
	public interface IDraggable {
		
		function getDragTracker(event: MouseEvent): DragTracker;
	}
}