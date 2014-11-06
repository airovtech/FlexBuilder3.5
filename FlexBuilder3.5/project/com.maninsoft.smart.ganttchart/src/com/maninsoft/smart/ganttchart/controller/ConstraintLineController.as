package com.maninsoft.smart.ganttchart.controller
{

	import com.maninsoft.smart.ganttchart.model.ConstraintLine;
	import com.maninsoft.smart.ganttchart.view.ConstraintLineView;
	import com.maninsoft.smart.ganttchart.view.GanttMilestoneView;
	import com.maninsoft.smart.ganttchart.view.GanttTaskView;
	import com.maninsoft.smart.modeler.controller.NodeController;
	import com.maninsoft.smart.modeler.editor.events.DiagramChangeEvent;
	import com.maninsoft.smart.modeler.view.IView;
	import com.maninsoft.smart.modeler.view.NodeView;
	import com.maninsoft.smart.modeler.view.connection.IConnectionRouter;
	import com.maninsoft.smart.modeler.xpdl.controller.XPDLLinkController;
	
	import flash.geom.Point;

	public class ConstraintLineController extends XPDLLinkController
	{
		public function ConstraintLineController(model:ConstraintLine)
		{
			super(model);
		}

		override protected function createView(): IView {
			var view: ConstraintLineView = new ConstraintLineView(calcConnectPoints());
			var m: ConstraintLine = model as ConstraintLine;
			if (view) {
				view.label = m.name;
				view.isDefault = m.isDefault; 

				view.lineColor = m.lineColor = 0x276b83; 
				view.lineWidth = m.lineWidth = 1;
				view.isBackward = m.isBackward;
			}
			return view;
		}		

		override public function activate(): void {
			super.activate();

			if(sourceNode)
				sourceNode.dispatchEvent(new DiagramChangeEvent(DiagramChangeEvent.LINK_ADDED, this));
			if(targetNode)
				targetNode.dispatchEvent(new DiagramChangeEvent(DiagramChangeEvent.LINK_ADDED, this));
		}
		
		override protected function calcConnectPoints(): Array {
			var paths: Array = linkModel.path.split(",");
			var cr: IConnectionRouter = createConnectionRouter();
			
			var sourceCtrl: NodeController = editor.findControllerByModel(linkModel.source) as NodeController;
			var targetCtrl: NodeController = editor.findControllerByModel(linkModel.target) as NodeController;
				
			var sourceView: NodeView = sourceCtrl.view as NodeView;
			var targetView: NodeView = targetCtrl.view as NodeView;
			
			var sourceAnchor: Point = sourceView.connectAnchorToPoint(paths[0]); 
			var targetAnchor: Point = targetView.connectAnchorToPoint(paths[paths.length - 1]); 
			if(sourceView is GanttTaskView) sourceAnchor.x = GanttTaskView(sourceView).connectBounds.x + GanttTaskView(sourceView).connectBounds.width;
			else if(sourceView is GanttMilestoneView) sourceAnchor.x = GanttMilestoneView(sourceView).connectBounds.x + GanttMilestoneView(sourceView).connectBounds.width;
			if(targetView is GanttTaskView) targetAnchor.x = GanttTaskView(targetView).connectBounds.x;
			else if(targetView is GanttMilestoneView) targetAnchor.x = GanttMilestoneView(targetView).connectBounds.x;
			
			var pts: Array = cr.route(sourceView.bounds,
									  sourceAnchor, 
									  linkModel.sourceAnchor,
									  targetView.bounds,
									  targetAnchor,
									  linkModel.targetAnchor);
									  
			return pts;
		}

		override protected function showSelection(): Boolean {
			var v: ConstraintLineView = view as ConstraintLineView;

var selLineColor: uint = 0xda0000;
			v.lineColor = selLineColor;
			v.lineWidth = 1.2;
			v.refresh();
			return true;
		}
		
		override protected function hideSelection(): Boolean {
			var m: ConstraintLine = model as ConstraintLine;
			var v: ConstraintLineView = view as ConstraintLineView;

			showPropertyView = false;
			selectHandles = null;		
			v.lineColor = m.lineColor;
			v.lineWidth = m.lineWidth;
			v.refresh();
			return true;
		}
		
		override public function refreshSelection(): void {
		}
	}
}