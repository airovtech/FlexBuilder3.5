package com.maninsoft.smart.ganttchart.tool
{
	import com.maninsoft.smart.ganttchart.controller.GanttTaskGroupController;
	import com.maninsoft.smart.ganttchart.model.GanttChartGrid;
	import com.maninsoft.smart.ganttchart.model.GanttTaskGroup;
	import com.maninsoft.smart.modeler.command.Command;
	import com.maninsoft.smart.modeler.controller.Controller;
	import com.maninsoft.smart.modeler.editor.tool.MoveTracker;
	import com.maninsoft.smart.modeler.model.Node;
	import com.maninsoft.smart.modeler.model.events.NodeChangeEvent;
	import com.maninsoft.smart.modeler.xpdl.model.SubFlow;
	
	import flash.events.MouseEvent;

	public class GanttMoveTracker extends MoveTracker
	{
		public function GanttMoveTracker(controller:Controller)
		{
			super(controller);
		}
		
		override protected function get offsetY(): int {
			var value: int = super.offsetY/GanttChartGrid.CHARTROW_HEIGHT;
			return value*GanttChartGrid.CHARTROW_HEIGHT ;
		}
				
		override public function mouseMove(event: MouseEvent): void {

			if(!event.buttonDown && (state == STATE_READY || state == STATE_DRAGGING)){
				_abnormalDrag = true;
				mouseUp(event);
				return;
			}
			
			if(!event.buttonDown) return;
			
			var oldCurrentX: int = currentX;
			var oldCurrentY: int = currentY;
			currentX = editor.zoomedX;
			currentY = editor.zoomedY;
			if (!editor.selectionManager.canMoveBy(offsetX, offsetY)) {
				currentX = oldCurrentX;
				currentY = oldCurrentY;
			}
			
			if (state == STATE_READY) {
				if (movedThreshold(currentX, currentY)) {
					if (startDrag(event.target)) {
						state = STATE_DRAGGING;
					} else {
						state = STATE_INVALID;
					}	
				}
			}
			
			if (state == STATE_DRAGGING) {
				drag(event.target);
				
				if(offsetY && editor.selectionManager.clearOffset){
					startX = currentX;
					startY = currentY;
					editor.selectionManager.clearOffset = false;
				}
			}			
			event.updateAfterEvent();
		}

		override public function mouseUp(event: MouseEvent): void {

			var oldCurrentX: int = currentX;
			var oldCurrentY: int = currentY;

			if(!_abnormalDrag){			
				currentX = editor.zoomedX;
				currentY = editor.zoomedY;
				if (!editor.selectionManager.canMoveBy(offsetX, offsetY)) {
					currentX = oldCurrentX;
					currentY = oldCurrentY;
				}
			}
			
			// 상태 기계로서 반드시 이전 상태를 체크한다.
			if (state == STATE_DRAGGING) { 
				if (endDrag(event.target)) {
					state = STATE_COMPLETED;
					
					var cmd: Command = getCommand();
					
					if (cmd)
						executeCommand(cmd);
					
					for each(var selNode: Node in editor.selectionManager.nodes){
						if(selNode is GanttTaskGroup && GanttTaskGroup(selNode).subFlowView == SubFlow.VIEW_EXPANDED){
							for each(var node: Node in GanttTaskGroup(selNode).subProcess.activities){
								node.dispatchEvent(new NodeChangeEvent(node, GanttTaskGroup.PROP_NODEBOUNDS));
							}
						}
					}
					performCompleted();
					
				} else {
					state = STATE_CANCELED;
					performCanceled();
				}
			}
			// drag & drop 이벤트 발생하는 부분이다. 1.mouseDown, 2.mouseMove, 3.mouseUp 중에 3번에 해당된다.
			// updateDisplayList가 실행되도록 invalidateDisplayList을 호출한다. 2009.02.04 sjyoon
			editor.invalidateDisplayList();
			event.updateAfterEvent();
		}
	}
}