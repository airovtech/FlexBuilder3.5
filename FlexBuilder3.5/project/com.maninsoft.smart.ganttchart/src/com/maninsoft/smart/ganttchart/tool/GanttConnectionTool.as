package com.maninsoft.smart.ganttchart.tool
{
	import com.maninsoft.smart.ganttchart.model.GanttChartGrid;
	import com.maninsoft.smart.ganttchart.model.GanttTaskGroup;
	import com.maninsoft.smart.ganttchart.request.GanttLinkCreationRequest;
	import com.maninsoft.smart.modeler.editor.DiagramEditor;
	import com.maninsoft.smart.modeler.editor.handle.ConnectHandle;
	import com.maninsoft.smart.modeler.editor.tool.ConnectionTool;
	import com.maninsoft.smart.modeler.model.Node;
	
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class GanttConnectionTool extends ConnectionTool
	{
		public function GanttConnectionTool(editor:DiagramEditor)
		{
			super(editor);
			lineWidth = 1;
		}

		override public function mouseDown(event: MouseEvent): void {
			super.mouseDown(event);
			event.updateAfterEvent();
			
			if (state == STATE_COMPLETED || state == STATE_CANCELED)
				state = STATE_STARTED;
			
			if (event.target is ConnectHandle) {
				var handle: ConnectHandle = event.target as ConnectHandle;
				
				switch (state) {
					case STATE_STARTED:
						if (startConnection(handle))
							state = STATE_SOURCE_ANCHORED;
						break;
				}
			} 
			else {
				// target을 찾눈 중에 노드 외의 영역을 클릭하면 초기화 한다. 
				if (state == STATE_SOURCE_ANCHORED) {
					endConnection(null);
					source = null;
					target = null;
					state = STATE_CANCELED;
				}
				else{
					current = null;
					state = STATE_CANCELED; 
				}
			}
		}

		override public function mouseUp(event: MouseEvent): void {
			event.updateAfterEvent();
			
			if (endConnection(event.target as ConnectHandle)) {
				state = STATE_COMPLETED;
							
				var src: Node = source.model as Node;
				var dst: Node = target.model as Node;

				source = null;
				target = null;
				
				var ganttChartGrid: GanttChartGrid = src.parent as GanttChartGrid;
				var srcGroupInfo: Object = ganttChartGrid.findTaskInSubProcess(src);
				var dstGroupInfo: Object = ganttChartGrid.findTaskInSubProcess(dst);
				var srcSubProcessId: String;
				var dstSubProcessId: String;
				if(srcGroupInfo) srcSubProcessId = GanttTaskGroup(srcGroupInfo.taskGroup).subProcessId; 
				if(dstGroupInfo) dstSubProcessId = GanttTaskGroup(dstGroupInfo.taskGroup).subProcessId; 
				
				if(srcSubProcessId == dstSubProcessId){				
					if(sourceAnchor==90 && targetAnchor==270) 
						editor.executeRequest(new GanttLinkCreationRequest("default", src, dst, sourceAnchor, targetAnchor, null, srcSubProcessId ));
					else if(sourceAnchor==270 && targetAnchor==90) 
						editor.executeRequest(new GanttLinkCreationRequest("default", dst, src, targetAnchor, sourceAnchor, null, dstSubProcessId));
					else
						state = STATE_CANCELED;
				}else {
					state = STATE_CANCELED;					
				}							
			} else {
				state = STATE_CANCELED;
			}
		}
		override protected function renderView(x: int, y: int, handle: ConnectHandle): void {
			if (view == null || router == null) return;
			
			var g: Graphics = view.graphics;
			
			g.clear();
			
			var pts: Array;
			
			if (handle != null) {
				pts = router.route(source.bounds, start, sourceAnchor, 
									handle.controller.bounds, new Point(handle.x, handle.y), handle.anchor);
			} else {
				var tempAnchor: Number = (sourceAnchor==90)?270:90;
				pts = router.route(source.bounds, start, sourceAnchor, new Rectangle(x, y, 0, 0), new Point(x, y), tempAnchor);
			}
			
			g.lineStyle(lineWidth, 0x000000);
			g.moveTo(start.x, start.y);
			for (var i: int = 1; i < pts.length; i++) {
				g.lineTo(pts[i].x, pts[i].y);
			}
		}
	}
}