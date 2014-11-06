package com.maninsoft.smart.ganttchart.controller
{
	import com.maninsoft.smart.ganttchart.assets.GanttIconLibrary;
	import com.maninsoft.smart.ganttchart.command.GanttLinkCreateCommand;
	import com.maninsoft.smart.ganttchart.command.GanttNodeCreateCommand;
	import com.maninsoft.smart.ganttchart.command.GanttNodeDeleteCommand;
	import com.maninsoft.smart.ganttchart.editor.GanttChart;
	import com.maninsoft.smart.ganttchart.model.GanttChartGrid;
	import com.maninsoft.smart.ganttchart.model.GanttMilestone;
	import com.maninsoft.smart.ganttchart.model.GanttTaskGroup;
	import com.maninsoft.smart.ganttchart.view.GanttMilestoneView;
	import com.maninsoft.smart.ganttchart.view.GanttTaskGroupView;
	import com.maninsoft.smart.ganttchart.view.GanttTaskView;
	import com.maninsoft.smart.modeler.command.GroupCommand;
	import com.maninsoft.smart.modeler.controller.NodeController;
	import com.maninsoft.smart.modeler.editor.DiagramEditor;
	import com.maninsoft.smart.modeler.editor.events.DiagramChangeEvent;
	import com.maninsoft.smart.modeler.editor.handle.SelectHandle;
	import com.maninsoft.smart.modeler.model.Link;
	import com.maninsoft.smart.modeler.model.Node;
	import com.maninsoft.smart.modeler.model.events.NodeChangeEvent;
	import com.maninsoft.smart.modeler.view.NodeView;
	import com.maninsoft.smart.modeler.xpdl.controller.TaskManualController;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLNode;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class GanttMilestoneController extends TaskManualController
	{

		private var defaultBorderColor: uint 	= 0x4394b1;
		private var defaultFillColor: uint 		= 0x8000FF;
		private var defaultExeBorderColor: uint = 0xFF0000;
		private var defaultExeFillColor: uint 	= 0xFF0000;			
		private var defaultSelBorderColor: uint = 0xda0000;

		public function GanttMilestoneController(model:GanttMilestone)
		{
			super(model);
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		public function get ganttMilestone(): GanttMilestone {
			return taskModel as GanttMilestone;
		}


		//----------------------------------------------------------------------
		// Overriden Methods
		//----------------------------------------------------------------------
		
		override protected function createNodeView(): NodeView {
			return new GanttMilestoneView();
		}

		override protected function initNodeView(nodeView:NodeView): void {
			super.initNodeView(nodeView);
			var v: GanttMilestoneView = nodeView as GanttMilestoneView;
			var m: GanttMilestone = model as GanttMilestone;
			var ganttChartGrid: GanttChartGrid = GanttChartGrid(m.parent);
			
			m.planMilestonePoint = ganttChartGrid.getMilestonePoint(m.planDate);
			if(m.executionDate != null){
				m.executionMilestonePoint = ganttChartGrid.getMilestonePoint(m.executionDate);
			}

			var taskGroupInfo: Object = ganttChartGrid.findTaskInSubProcess(m);
			if(taskGroupInfo)
				m.taskGroup = taskGroupInfo.taskGroup as GanttTaskGroup;
			else m.taskGroup = null;
			
			adjustSourceConstraint();
			resetViewBounds(m, v);
			resetNodeBounds(m, v);

			v.planDate					= m.planDate;
			v.planMilestonePoint		= m.planMilestonePoint;
			v.executionDate 			= m.executionDate;
			v.executionMilestonePoint 	= m.executionMilestonePoint;

			v.borderColor 				= m.borderColor = defaultBorderColor;
			v.borderWidth 				= 1;
			v.fillColor 				= m.fillColor = defaultFillColor;
			v.exeBorderColor 			= m.exeBorderColor = defaultExeBorderColor;
			v.exeFillColor 				= m.exeFillColor = defaultExeFillColor;			
			v.taskNameTextColor 		= m.taskNameTextColor;
			v.name						= m.name;
			v.parentViewBounds			= m.parentViewBounds =	GanttChartGridController(parent).getViewBounds();
			
			m.diagram.addEventListener(DiagramChangeEvent.CHART_REFRESHED, doDiagramChanged);			
			m.addEventListener(DiagramChangeEvent.LINK_ADDED, doLinkAdded);			

			var groupInfo: Object = ganttChartGrid.findTaskInSubProcess(m);
			if(groupInfo){
				GanttTaskGroup(groupInfo.taskGroup).dispatchEvent(new NodeChangeEvent(m, GanttTaskGroup.PROP_NODEINDEX));				
			}
		}

		private function adjustSourceConstraint(): void{
			var m: GanttMilestone = model as GanttMilestone;
			var ganttChartGrid: GanttChartGrid 	= m.parent as GanttChartGrid;
			var taskDate: Date = new Date();
			var taskDateChanged: Boolean = false;
			
			if(!m.planDate) return;
			taskDate.time = m.planDate.time;
			
			var targetLinks: Array = this.getTargetLinks()
			for each(var targetLink: ConstraintLineController in targetLinks){
				if(targetLink && targetLink.sourceNode){
					var sourceCtrl: NodeController = editor.findControllerByModel(targetLink.sourceNode) as NodeController;
					if(sourceCtrl.view is GanttTaskView){
						if(GanttTaskView(sourceCtrl.view).planTo.time>taskDate.time){
							taskDate.time = GanttTaskView(sourceCtrl.view).planTo.time;
							taskDateChanged=true;
						}
					}else if(sourceCtrl.view is GanttTaskGroupView){
						if(GanttTaskGroupView(sourceCtrl.view).planTo.time>taskDate.time){
							taskDate.time = GanttTaskGroupView(sourceCtrl.view).planTo.time;
							taskDateChanged=true;
						}
					
					}else if(sourceCtrl.view is GanttMilestoneView){
						if(GanttMilestoneView(sourceCtrl.view).planDate.time>taskDate.time){
							taskDate.time = GanttMilestoneView(sourceCtrl.view).planDate.time;
							taskDateChanged=true;
						}						
					}
				}
			}
			if(taskDateChanged){
				var startPoint: Point = ganttChartGrid.getMilestonePoint(taskDate);
				m.planMilestonePoint.x = startPoint.x;
				m.planDate = ganttChartGrid.getTaskDate(m.planMilestonePoint);
			}
		}
		
		private function changeTargetNodes(): void{
			var sourceLinks: Array = this.getSourceLinks()
			for each(var sourceLink: ConstraintLineController in sourceLinks){
				if(sourceLink && sourceLink.targetNode){
					sourceLink.targetNode.dispatchEvent(new NodeChangeEvent(nodeModel, GanttTaskGroup.PROP_SOURCENODEBOUNDS)) 
				}
			}
		}

		private function changeTargetViews(): void{
			var sourceLinks: Array = this.getSourceLinks()
			for each(var sourceLink: ConstraintLineController in sourceLinks){
				if(sourceLink && sourceLink.targetNode){
					sourceLink.targetNode.dispatchEvent(new NodeChangeEvent(nodeModel, GanttTaskGroup.PROP_SOURCEVIEWBOUNDS)) 
				}
			}
		}

		private function canMoveTargetNode(dx: Number, dy: Number): Boolean{
			var m: GanttMilestone = model as GanttMilestone;
			var targetLinks: Array = this.getTargetLinks()
			for each(var targetLink: ConstraintLineController in targetLinks){
				if(targetLink && targetLink.sourceNode){
					var sourceCtrl: NodeController = editor.findControllerByModel(targetLink.sourceNode) as NodeController;
					if(NodeView(sourceCtrl.view).bounds.right>m.x+dx) return false;  
				}
			}
			return true;		
		}

		public function resetNodeBounds(m: GanttMilestone, v: GanttMilestoneView): void{
			var milestoneSymbolWidth: int = GanttMilestone.MILESTONESYMBOL_WIDTH;
			var milestoneSymbolHeight: int = GanttMilestone.MILESTONESYMBOL_HEIGHT;
			var y: Number = GanttChartGrid.CHARTHEADER_HEIGHT*2 + GanttChartGrid.CHARTROW_HEIGHT*m.nodeIndex+m.planMilestonePoint.y;
			var bounds: Rectangle = new Rectangle(m.planMilestonePoint.x, y, milestoneSymbolWidth, milestoneSymbolHeight);
			m.bounds = bounds;
		}

		public function resetViewBounds(m: GanttMilestone, v: GanttMilestoneView): void{
			var milestoneSymbolWidth: int = GanttMilestone.MILESTONESYMBOL_WIDTH;
			var milestoneSymbolHeight: int = GanttMilestone.MILESTONESYMBOL_HEIGHT;

			v.x 						= m.planMilestonePoint.x;
			v.nodeWidth 				= milestoneSymbolWidth;
			v.y 						= GanttChartGrid.CHARTHEADER_HEIGHT*2 + GanttChartGrid.CHARTROW_HEIGHT*m.nodeIndex;
			v.nodeHeight 				= GanttChartGrid.CHARTROW_HEIGHT; 
			v.planMilestonePoint		= m.planMilestonePoint;
			v.planDate					= m.planDate;
			v.executionMilestonePoint	= m.executionMilestonePoint;
			v.executionDate				= m.executionDate;
					
			if( m.executionMilestonePoint.x ==0 ){
				v.actualNodeWidth = milestoneSymbolWidth;
			}else{
				v.actualNodeWidth =   m.planMilestonePoint.x<m.executionMilestonePoint.x
							   		? m.executionMilestonePoint.x+milestoneSymbolWidth-m.planMilestonePoint.x
									: milestoneSymbolWidth;
			}
		}
		public function resetViewYBounds(m: GanttMilestone, v: GanttMilestoneView): void{
			var milestoneSymbolWidth: int = GanttMilestone.MILESTONESYMBOL_WIDTH;
			var milestoneSymbolHeight: int = GanttMilestone.MILESTONESYMBOL_HEIGHT;

			v.x 						= m.planMilestonePoint.x;
			v.nodeWidth 				= milestoneSymbolWidth;
			v.nodeHeight 				= GanttChartGrid.CHARTROW_HEIGHT; 
			v.planMilestonePoint		= m.planMilestonePoint;
			v.planDate					= m.planDate;
			v.executionMilestonePoint	= m.executionMilestonePoint;
			v.executionDate				= m.executionDate;
					
			if( m.executionMilestonePoint.x ==0){
				v.actualNodeWidth = milestoneSymbolWidth;
			}else{
				v.actualNodeWidth =   m.planMilestonePoint.x<m.executionMilestonePoint.x
							   		? m.executionMilestonePoint.x+milestoneSymbolWidth-m.planMilestonePoint.x
									: milestoneSymbolWidth;
			}
		}

		override public function refreshBounds(): void {
			var m: GanttMilestone = this.model as GanttMilestone;
			var v: GanttMilestoneView = this.view as GanttMilestoneView;
			
			resetViewBounds(m, v);
			refreshSelection();
		}

		private function refreshNodeBounds(): void{
			var v: GanttMilestoneView = view as GanttMilestoneView;
			var m: GanttMilestone = model as GanttMilestone;
			adjustSourceConstraint();
			resetViewBounds(m, v);
			resetNodeBounds(m, v);
			refreshView();
			changeLinksConstraint(this);
			changeTargetNodes();						
		}
		
		private function refreshViewBounds(): void{
			var v: GanttMilestoneView = view as GanttMilestoneView;
			var m: GanttMilestone = model as GanttMilestone;
			adjustSourceConstraint();
			resetViewBounds(m, v);
			refreshView();
			changeLinksConstraint(this);
			changeTargetViews();						
		}

		public function refreshPropertyPage():void{
			if(GanttChart(editor).selectionManager.contains(this))
				GanttChart(editor).select(model);
		}
				
		override protected function nodeChanged(event: NodeChangeEvent): void {
			var v: GanttMilestoneView = view as GanttMilestoneView;
			var m: GanttMilestone = model as GanttMilestone;
			var ganttChartGrid: GanttChartGrid = m.parent as GanttChartGrid;

			switch (event.prop) {
				case XPDLNode.PROP_NAME:
					v.name = m.name;
					refreshView();
					break;
					
				case GanttMilestone.PROP_PLANDATE:
					m.planMilestonePoint = ganttChartGrid.getMilestonePoint(m.planDate);
					refreshNodeBounds();
					break;
									
				case GanttMilestone.PROP_EXECUTIONDATE:
					m.executionMilestonePoint = ganttChartGrid.getMilestonePoint(m.executionDate);
					refreshNodeBounds();
					break;
									
				case GanttMilestone.PROP_SOURCEVIEWBOUNDS:
				case GanttMilestone.PROP_VIEWBOUNDS:
					refreshViewBounds();
					break;
				
				case GanttMilestone.PROP_SOURCENODEBOUNDS:
				case GanttMilestone.PROP_NODEBOUNDS:
				case GanttMilestone.PROP_NODEINDEX:
					refreshNodeBounds();
					break;
				
				case GanttMilestone.PROP_TASKGROUP:
					ganttChartGrid.changeTaskGroup(this.editor, m, event.oldValue as GanttTaskGroup, m.taskGroup);
					break;
					
				default:
					super.nodeChanged(event);
					break;
			}
			if (event.prop == Node.PROP_SIZE || 
			    event.prop == Node.PROP_X || event.prop == Node.PROP_Y || event.prop == Node.PROP_POSITION ||
			    event.prop == Node.PROP_BOUNDS ||
			    event.prop == GanttMilestone.PROP_NODEINDEX ) {
				var groupInfo: Object = ganttChartGrid.findTaskInSubProcess(m);
				if(groupInfo){
					m.taskGroup = groupInfo.taskGroup;
					GanttTaskGroup(groupInfo.taskGroup).dispatchEvent(new NodeChangeEvent(m, GanttTaskGroup.PROP_SUBNODEBOUNDS));				
				}else{
					m.taskGroup = null
				}
				this.refreshPropertyPage();
		    }
		}		
		
		protected function doLinkAdded(event:DiagramChangeEvent): void{
			refreshNodeBounds();
		}

		protected function doDiagramChanged(event:DiagramChangeEvent): void{
			var v: GanttMilestoneView = view as GanttMilestoneView;
			var m: GanttMilestone = model as GanttMilestone;
			var ganttChartGrid: GanttChartGrid = GanttChartGrid(m.parent);
			
			if(!ganttChartGrid) return;

			m.planMilestonePoint = ganttChartGrid.getMilestonePoint(m.planDate);
			if(m.executionDate != null){
				m.executionMilestonePoint = ganttChartGrid.getMilestonePoint(m.executionDate);
			}

			var taskGroupInfo: Object = ganttChartGrid.findTaskInSubProcess(m);
			if(taskGroupInfo)
				m.taskGroup = taskGroupInfo.taskGroup as GanttTaskGroup;
			else m.taskGroup = null;
			
			adjustSourceConstraint();
			resetViewBounds(m, v);
			resetNodeBounds(m, v);

			v.planDate					= m.planDate;
			v.planMilestonePoint		= m.planMilestonePoint;
			v.executionDate 			= m.executionDate;
			v.executionMilestonePoint 	= m.executionMilestonePoint;
			
			refreshView();

			changeLinksConstraint(this);
			changeTargetNodes();			
		}
		
		override protected function showSelection(): Boolean {
			var v: GanttMilestoneView = view as GanttMilestoneView;

			v.borderColor = defaultSelBorderColor;
			v.taskNameTextColor = defaultSelBorderColor;
			v.refresh();
			return true;
		}
		
		override protected function hideSelection(): Boolean {
			var m: GanttMilestone = this.model as GanttMilestone;
			var v: GanttMilestoneView = view as GanttMilestoneView;
			
			showPropertyView = false;
			v.borderColor = m.borderColor;
			v.taskNameTextColor = m.taskNameTextColor;
			v.refresh();
			return true;
		}
		
		override public function refreshSelection(): void {
		}

		override public function canMoveBy(dx: Number, dy: Number): Boolean {
			var ganttChartGrid:GanttChartGrid = nodeModel.parent as GanttChartGrid;			
			var result: Object = ganttChartGrid.findTaskInSubProcess(this.nodeModel);
			if(result && !GanttTaskGroup(result.taskGroup).isTaskGroupNodeEditable) return false;
			return 	   (nodeModel.y + dy) >= GanttChartGrid(nodeModel.parent).nodeTop
					&& (nodeModel.y + dy)<= GanttChartGrid(nodeModel.parent).nodeBottom
					&& this.canMoveTargetNode(dx, dy)
					&& !ganttChartGrid.isUnderDueDate(nodeModel.x+dx, nodeModel.y+dy); 
		}
				 
		override public function moveBy(dx: Number, dy: Number): void {
			if (selected) {
				var m: GanttMilestone = this.model as GanttMilestone;
				var v: GanttMilestoneView = this.view as GanttMilestoneView;
 				var editor: DiagramEditor 			= this.editor;
      			var ganttChartGrid:GanttChartGrid 	= m.parent as GanttChartGrid;
				var diagram: XPDLDiagram 			= m.diagram as XPDLDiagram;
				var cmd: GroupCommand 				= new GroupCommand();					
				var links: Array 					= new Array();
				var link: Link;

				var p: Point = controllerToEditor(getMovedPoint(SelectHandle.DIR_TOPLEFT, dx, dy));
				var oldPosition: Point = new Point(m.planMilestonePoint.x, m.planMilestonePoint.y);				

				var di: int = (p.y-(v.y+v.planMilestonePoint.y))/GanttChartGrid.CHARTROW_HEIGHT;
				var acts: Array = XPDLDiagram(m.diagram).activities;
				var nodeIndex: int = m.nodeIndex;
				
				m.planMilestonePoint.x	+= p.x-v.x;
				m.planDate 			= ganttChartGrid.getTaskDate(m.planMilestonePoint);
				v.planMilestonePoint= m.planMilestonePoint;
				v.planDate 			= m.planDate;
				refreshBounds();
				changeTargetNodes();

				if( (di) && (di+nodeIndex>=0) && di+nodeIndex<acts.length){
					for each(link in m.sourceLinks)
						links.push(link)
					for each(link in m.targetLinks)
						links.push(link)
						
					var result: Object = ganttChartGrid.findTaskInSubProcess(m);
					var subProcessId: String = (result)?GanttTaskGroup(result.taskGroup).subProcessId : null;
					var myTaskGroup: GanttTaskGroup = (result)?result.taskGroup as GanttTaskGroup : null;

					editor.selectionManager.clear();
					editor.selectionManager.clearOffset = true;
										
					cmd.add(new GanttNodeDeleteCommand(m, nodeIndex));					
					cmd.add(new GanttNodeCreateCommand(ganttChartGrid, nodeIndex+di, m));
					for each(link in links)
						cmd.add(new GanttLinkCreateCommand(link, subProcessId));
					editor.execute(cmd);
					
					var start: int = nodeIndex<nodeIndex+di?nodeIndex:nodeIndex+di;
					var end: int = nodeIndex>nodeIndex+di?nodeIndex:nodeIndex+di;
					var nodeChangeEvent: NodeChangeEvent;
					for(var curNodeIndex: int=start; curNodeIndex < end+1; curNodeIndex++){
						Node(acts[curNodeIndex]).dispatchEvent(new NodeChangeEvent(acts[curNodeIndex],GanttMilestone.PROP_NODEINDEX));
					}
					if(myTaskGroup){
						myTaskGroup.dispatchEvent(new NodeChangeEvent(myTaskGroup,GanttMilestone.PROP_NODEINDEX));						
					}

					var groupInfo: Object = ganttChartGrid.findTaskInSubProcess(m);
					if(groupInfo){
						Node(groupInfo.taskGroup).dispatchEvent(new NodeChangeEvent(groupInfo.taskGroup,GanttMilestone.PROP_NODEINDEX));						
					}
				}else{
					m.dispatchEvent(new NodeChangeEvent(m, Node.PROP_POSITION));									
				}
			}
		}

		public function moveToTheDate(icon: Object):void{
			var m: GanttMilestone = this.model as GanttMilestone;
   			var ganttChartGrid:GanttChartGrid 	= m.parent as GanttChartGrid;
			var ganttChartGridCtrl:GanttChartGridController = editor.findControllerByModel( nodeModel.parent as GanttChartGrid) as GanttChartGridController;
			var startDate:Date, endDate:Date;
			if(icon is GanttIconLibrary.overLeftIcon){
				if(m.planDate && m.planDate.time < ganttChartGrid.startDate.time)
					startDate = new Date(m.planDate.time);
			}else if(icon is GanttIconLibrary.overRightIcon){
				if(m.planDate && m.planDate.time > ganttChartGrid.endDate.time)
					endDate = new Date(m.planDate.time);
			}
			ganttChartGridCtrl.moveToTheDate(startDate, endDate);
		}
	}
}