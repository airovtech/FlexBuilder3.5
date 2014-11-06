/**
 * 
 *  Package: 		com.maninsoft.smart.ganttchart.editor
 *  Class: 			GanttChart
 *  Author:			Y.S. Jung
 *  Description:	GanttChartEditor에서 툴바와 속성을 제외한 순수 Gantt Chart부분만 다루는 View이다.
 * 					GanttChart 뷰안에는 DataTree와 ChartGrid로 구성 되어 있다.
 *  
 * 					GanttChartEdotor --> GanttChart --> ToolBox
 *  												--> DataTreeView
 * 													--> ChartGridView
 * 
 *  History:		2009.12.5 created by Y.S. Jung
 * 
 *  Copyright (C) 2007-2009 Maninsoft, Inc. All Rights Reserved.
 *  
 */

package com.maninsoft.smart.ganttchart.editor
{
	import com.maninsoft.smart.ganttchart.assets.GanttChartCSS;
	import com.maninsoft.smart.ganttchart.command.GanttLinkDeleteCommand;
	import com.maninsoft.smart.ganttchart.command.GanttNodeDeleteCommand;
	import com.maninsoft.smart.ganttchart.controller.GanttChartGridController;
	import com.maninsoft.smart.ganttchart.controller.GanttRootController;
	import com.maninsoft.smart.ganttchart.model.ConstraintLine;
	import com.maninsoft.smart.ganttchart.model.GanttChartGrid;
	import com.maninsoft.smart.ganttchart.model.GanttMilestone;
	import com.maninsoft.smart.ganttchart.model.GanttTask;
	import com.maninsoft.smart.ganttchart.model.GanttTaskGroup;
	import com.maninsoft.smart.ganttchart.server.WorkCalendar;
	import com.maninsoft.smart.ganttchart.tool.GanttConnectionTool;
	import com.maninsoft.smart.ganttchart.tool.GanttSelectionTool;
	import com.maninsoft.smart.ganttchart.util.CalendarUtil;
	import com.maninsoft.smart.modeler.command.GroupCommand;
	import com.maninsoft.smart.modeler.controller.Controller;
	import com.maninsoft.smart.modeler.controller.RootController;
	import com.maninsoft.smart.modeler.editor.IControllerFactory;
	import com.maninsoft.smart.modeler.editor.ILinkFactory;
	import com.maninsoft.smart.modeler.editor.INodeFactory;
	import com.maninsoft.smart.modeler.editor.ITool;
	import com.maninsoft.smart.modeler.editor.events.DiagramChangeEvent;
	import com.maninsoft.smart.modeler.editor.tool.ConnectionTool;
	import com.maninsoft.smart.modeler.model.DiagramObject;
	import com.maninsoft.smart.modeler.model.Link;
	import com.maninsoft.smart.modeler.model.Node;
	import com.maninsoft.smart.modeler.view.IView;
	import com.maninsoft.smart.modeler.xpdl.XPDLEditor;
	import com.maninsoft.smart.modeler.xpdl.model.Pool;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.workbench.common.event.MoveGanttStepEvent;
	
	import flash.events.MouseEvent;
	
	import mx.collections.XMLListCollection;
	import mx.containers.Canvas;
	
	public class GanttChart	extends XPDLEditor{
		
		/**
		 *  Instance Varibles
		 */
		private var ganttChartCSS:GanttChartCSS = new GanttChartCSS();

        public var gcItemColl:XMLListCollection = new XMLListCollection();

		public var workCalendar: WorkCalendar;
		
		[Bindable]
		public var editorWidth:Number;
		
		/**
		 * GanttChart 생성자
		 */
		public function GanttChart() {
			super();
			workCalendar = new WorkCalendar(this);	
		}
		
		public function get ganttChartGrid():GanttChartGrid{
			if(!diagram) return null;
			return this.diagram.root.children[0] as GanttChartGrid;
		}

		public function get numActivities(): int{
			return XPDLDiagram(this.diagram).activities.length;
		}

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
				
		override protected function createRootController(): RootController{
			return new GanttRootController(this);			
		}
		
		/**
		 * node factory
		 */
		override protected function createNodeFactory(): INodeFactory {
			return new GanttNodeFactory(this);
		}
		
		/**
		 * link factory
		 */
		override protected function createLinkFactory(): ILinkFactory {
			return new GanttLinkFactory(this);
		}
		
		/**
		 * controller factory
		 */
		override protected function createControllerFactory(): IControllerFactory {
			return new GanttControllerFactory(this);
		}

		override protected function createDefaultTool(): ITool {
			return new GanttSelectionTool(this);
		}

		override protected function doMouseOver(event: MouseEvent): void {
/*
			systemManager.stage.focus = this;
			activeTool.mouseOver(event);
			
			if (event.target is IView) {
				var ctrl: Controller = findControllerByView(event.target as IView); 
				var selectedEvent:DiagramChangeEvent = new DiagramChangeEvent("diagramSelected", ctrl.model, "", null);
				selectedEvent.model = ctrl.model;
				dispatchEvent(selectedEvent);
			}
*/
		}

		override protected function doMouseOut(event: MouseEvent): void {
			super.doMouseOut(event);
		}
		
		override protected function doClick(event: MouseEvent): void {
			if(activeTool is GanttSelectionTool){
				systemManager.stage.focus = this;
				var ganttSelectionTool: GanttSelectionTool = activeTool as GanttSelectionTool;
				ganttSelectionTool.click(event);			
				if (event.target is IView) {
					var ctrl: Controller = findControllerByView(event.target as IView); 
					var selectedEvent:DiagramChangeEvent = new DiagramChangeEvent("diagramSelected", ctrl.model, "", null);
					selectedEvent.model = ctrl.model;
					dispatchEvent(selectedEvent);
				}
			}
		}
		
		override public function undo(): void {
			super.undo();
			diagram.dispatchEvent(new DiagramChangeEvent(DiagramChangeEvent.CHART_REFRESHED, null));
		}
		
		override public function redo(): void {
			super.redo();
			diagram.dispatchEvent(new DiagramChangeEvent(DiagramChangeEvent.CHART_REFRESHED, null));
		}

		override public function moveSelection(dx: int, dy: int): void {
			var nodes: Array = selectionManager.nodes;
			if(nodes.length==0){
				if(dx>0)
					chartMoveToRightStep();
				else if(dx<0)
					chartMoveToLeftStep()
				return;
			}
			super.moveSelection(dx, dy);
		}
				
		public function chartLevelUp(): void{
			clearSelection();
			var ctrl:GanttChartGridController = findControllerByModel(ganttChartGrid) as GanttChartGridController;
			ctrl.levelUpViewScope();
		}
		
		public function chartLevelDown(): void{
			clearSelection();
			var ctrl:GanttChartGridController = findControllerByModel(ganttChartGrid) as GanttChartGridController;
			ctrl.levelDownViewScope();			
		}
		
		public function setChartLevel(level:int, startDate:String=null): void{
			clearSelection();
			var ctrl:GanttChartGridController = findControllerByModel(ganttChartGrid) as GanttChartGridController;
			if(startDate)
				ctrl.setViewScope(level, CalendarUtil.getTaskDate(startDate));
			else
				ctrl.setViewScope(level);
		}
		
		public function chartMoveToLeftPage(): void{
			clearSelection();
			var ctrl:GanttChartGridController = findControllerByModel(ganttChartGrid) as GanttChartGridController;
			ctrl.moveToLeftPage();
		}
		
		public function chartMoveToRightPage(): void{
			clearSelection();
			var ctrl:GanttChartGridController = findControllerByModel(ganttChartGrid) as GanttChartGridController;
			ctrl.moveToRightPage();			
		}

		public function chartMoveToLeftStep(): void{
			var ctrl:GanttChartGridController = findControllerByModel(ganttChartGrid) as GanttChartGridController;
			if(parentApplication.id == "GanttTaskListViewerApp")
				Canvas(parentDocument).dispatchEvent(new MoveGanttStepEvent(MoveGanttStepEvent.MOVE_GANTTSTEP, MoveGanttStepEvent.GANTT_MOVE_LEFT));
			else
				ctrl.moveToLeftStep();
		}
		
		public function chartMoveToRightStep(): void{
			var ctrl:GanttChartGridController = findControllerByModel(ganttChartGrid) as GanttChartGridController;
			if(parentApplication.id == "GanttTaskListViewerApp")
				Canvas(parentDocument).dispatchEvent(new MoveGanttStepEvent(MoveGanttStepEvent.MOVE_GANTTSTEP, MoveGanttStepEvent.GANTT_MOVE_RIGHT));
			else
				ctrl.moveToRightStep();			
		}
		
		override protected function canDelete(obj: DiagramObject):Boolean {
			if(obj is Pool) return false;
			if(obj is GanttTask){
				var task:GanttTask = obj as GanttTask;
				return (task.taskGroup ? task.taskGroup.isTaskGroupNodeDeletable : task.isNodeDeletable);
			}else if(obj is GanttTaskGroup){
				var taskGroup: GanttTaskGroup = obj as GanttTaskGroup;
				return (taskGroup.taskGroup ? taskGroup.taskGroup.isTaskGroupNodeDeletable : taskGroup.isNodeDeletable);
			}else if(obj is GanttMilestone){
				var milestone: GanttMilestone = obj as GanttMilestone;
				return (milestone.taskGroup ? milestone.taskGroup.isTaskGroupNodeDeletable : milestone.isNodeDeletable);
			}else if(obj is ConstraintLine){
				var constraintLine:ConstraintLine = obj as ConstraintLine;
				return (constraintLine.isNodeDeletable);
			}
			return true;
		}


		override public function deleteSelection(): void {
			var links: Array = selectionManager.soleLinks;
			var nodes: Array = selectionManager.nodes;

			clearSelection();

			var cmd: GroupCommand = new GroupCommand();

			// 혼자 선택된 링크들을 삭제한다.
			for each (var link: Link in links) {
				if (canDelete(link))
					cmd.add(new GanttLinkDeleteCommand(link));
			}
			
			// 노드들을 삭제한다.
			for each (var node: Node in nodes) {
				if (canDelete(node))
					cmd.add(new GanttNodeDeleteCommand(node, node["nodeIndex"]));
			}
			
			execute(cmd);

			diagram.dispatchEvent(new DiagramChangeEvent(DiagramChangeEvent.CHART_REFRESHED, nodes));
		}

		override protected function createConnectionTool(): ITool {
			return new GanttConnectionTool(this);
		}
		
		override protected function doMouseUp(event: MouseEvent): void {
			super.doMouseUp(event);
			var dfd: ConnectionTool;
			if(activeTool is GanttConnectionTool){
			 	if(GanttConnectionTool(activeTool).state == ConnectionTool.STATE_COMPLETED){
			 		this.resetTool();
			 	}
			}
		}

		override protected function updateDisplayList(unscaledWidth: Number, unscaledHeight: Number): void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			/*
			 * pool 하나로 채운다.
			 */
			if (xpdlDiagram && xpdlDiagram.pool) {
				var pool: Pool = xpdlDiagram.pool;
//				contentWidth = pool.width + pool.x;
//				contentHeight = pool.height + pool.y;
			}
		}
	}
}