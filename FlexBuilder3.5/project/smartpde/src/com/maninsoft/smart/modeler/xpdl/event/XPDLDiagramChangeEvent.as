////////////////////////////////////////////////////////////////////////////////
//  DiagramChangeEvent.as
//  2008.02.27, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.event
{
	import com.maninsoft.smart.modeler.editor.events.DiagramChangeEvent;

	/**
	 * 다이어그램 내용이 변경되었을 때 에디터가 발생시키는 이벤트
	 */
	public class XPDLDiagramChangeEvent extends DiagramChangeEvent
	{
		//----------------------------------------------------------------------
		// Event types
		//----------------------------------------------------------------------
		
		public static const LANE_ADDED	: String = "laneAdded";
		public static const LANE_REMOVED	: String = "laneRemoved";


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function XPDLDiagramChangeEvent(type:String, element:Object, prop:String=null, oldValue:Object=null) {
			super(type, element, prop, oldValue);
		}
		
	}
}