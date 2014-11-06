package com.maninsoft.smart.ganttchart.view
{
	import com.maninsoft.smart.ganttchart.model.GanttChartGrid;
	import com.maninsoft.smart.modeler.view.NodeView;
	import com.maninsoft.smart.modeler.xpdl.view.base.XPDLLinkView;
	
	import flash.display.Graphics;
	import flash.geom.Point;

	public class ConstraintLineView extends XPDLLinkView
	{
		public function ConstraintLineView(points:Array)
		{
			super(points);
		}

		override protected function draw(): void {
			var g: Graphics = this.graphics;
			var chartMore: int = GanttChartGrid.CHARTMORE_WIDTH
			
			g.clear();

			if(!parent) return;
			
			if(!parent.parent) return;
						
			if(points && points.length>0){
				var pointStart: Number = Point(points[0]).x;
				var pointEnd: Number = Point(points[points.length-1]).x;

				if(	(pointStart>chartMore && pointStart<parent.parent.width) ||
					(pointEnd>chartMore && pointEnd<parent.parent.width)){
					super.draw();
				}
			}
		}
	}
}