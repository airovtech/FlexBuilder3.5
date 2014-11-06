package com.maninsoft.smart.ganttchart.editor.handle
{
	import com.maninsoft.smart.common.assets.Cursors;
	import com.maninsoft.smart.ganttchart.editor.GanttChart;
	import com.maninsoft.smart.ganttchart.model.GanttChartGrid;
	import com.maninsoft.smart.modeler.common.GraphicUtils;
	import com.maninsoft.smart.modeler.controller.Controller;
	import com.maninsoft.smart.modeler.editor.handle.SelectHandle;
	
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	
	import mx.managers.CursorManager;

	public class GanttSelectHandle extends SelectHandle
	{

		public function GanttSelectHandle(controller:Controller, anchorDir:int, size:int=8)
		{
			super(controller, anchorDir, size);
		}
		

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		private var _editor: GanttChart;
		public function set editor(value: GanttChart): void{
			_editor = value;
		} 
		
		public function get editor(): GanttChart{
			return _editor;
		}
		
		override protected function doMouseOver(event: MouseEvent): void {
			var cursor: Class;
			if(editor.readOnly || event.buttonDown) return;
						
			switch (anchorDir) {
				case DIR_LEFT:
				case DIR_RIGHT:
					cursor = Cursors.sizeWE;
					break;
			}
			
			CursorManager.setCursor(cursor, 2, -8, -8);
		}

		override protected function doMouseOut(event: MouseEvent): void {
			if(event.buttonDown) return;
			CursorManager.removeAllCursors();
		}


		override protected function draw(sz: int): void {
			var g: Graphics = graphics;
			g.clear();
			
			if (controller) {
				g.lineStyle(0,0,0);
				g.beginFill(0,0);
				g.drawRect(0,0,4,sz);
				g.endFill();
			}
		}		
	}
}