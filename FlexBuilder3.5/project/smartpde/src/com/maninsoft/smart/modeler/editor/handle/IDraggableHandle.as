////////////////////////////////////////////////////////////////////////////////
//  IDraggableHandle.as
//  2007.12.29, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.editor.handle
{
	import com.maninsoft.smart.modeler.editor.tool.DragTracker;
	
	/**
	 * dragTracker를 갖는 핸들
	 */
	public interface IDraggableHandle	{
		
		function getDragTracker(): DragTracker;
	}
}