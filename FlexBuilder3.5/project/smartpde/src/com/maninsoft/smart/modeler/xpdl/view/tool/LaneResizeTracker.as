////////////////////////////////////////////////////////////////////////////////
//  LaneSizingTracker.as
//  2008.02.20, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.view.tool
{
	import com.maninsoft.smart.modeler.command.Command;
	import com.maninsoft.smart.modeler.editor.tool.DragTracker;
	import com.maninsoft.smart.modeler.xpdl.XPDLEditor;
	import com.maninsoft.smart.modeler.xpdl.model.Pool;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.model.command.LaneResizeCommand;
	
	import flash.events.MouseEvent;
	
	/**
	 * Lane 크기 변경을 핸들링하는 트랙커
	 */
	public class LaneResizeTracker extends DragTracker {

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _laneView: LaneView;
		

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function LaneResizeTracker(laneView: LaneView) {
			super(laneView.editor);
			
			_laneView = laneView;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override protected function startDrag(target: Object): Boolean {
			return _laneView.showResizeFeedback();
		}

		override public function mouseMove(event:MouseEvent):void{
			super.mouseMove(event);
			if(!canLaneResizeBy(event)){
				mouseUp(event)
			}
		}
		override protected function drag(target: Object): Boolean {
			return _laneView.moveResizeFeedback(offsetX, offsetY);
		}
		
		override protected function endDrag(target: Object):Boolean {
			return _laneView.hideResizeFeedback();
		}
		
		override protected function performCompleted(): void {
		}
		
		override protected function performCanceled(): void {
		}
		
		override protected function getCommand(): Command {
			return new LaneResizeCommand(_laneView.lane, _laneView.isVertical ? offsetX : offsetY);
		}
		
		private function canLaneResizeBy(event:MouseEvent):Boolean{
			var pool:Pool = XPDLDiagram(XPDLEditor(this.editor).diagram).pool;			
			if(currentX <= pool.x || currentY <= pool.y || currentY > editor.height - pool.y || event.stageX > this.editor.width){
				return false
			}
			return true; 
		}
	}
}