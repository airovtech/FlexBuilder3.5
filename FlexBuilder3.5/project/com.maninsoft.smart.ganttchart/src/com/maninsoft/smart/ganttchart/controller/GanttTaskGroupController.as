package com.maninsoft.smart.ganttchart.controller
{
	import com.maninsoft.smart.ganttchart.assets.GanttIconLibrary;
	import com.maninsoft.smart.ganttchart.command.GanttLinkCreateCommand;
	import com.maninsoft.smart.ganttchart.command.GanttNodeCreateCommand;
	import com.maninsoft.smart.ganttchart.command.GanttNodeDeleteCommand;
	import com.maninsoft.smart.ganttchart.editor.GanttChart;
	import com.maninsoft.smart.ganttchart.model.GanttChartGrid;
	import com.maninsoft.smart.ganttchart.model.GanttMilestone;
	import com.maninsoft.smart.ganttchart.model.GanttTask;
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
	import com.maninsoft.smart.modeler.model.events.LinkChangeEvent;
	import com.maninsoft.smart.modeler.model.events.NodeChangeEvent;
	import com.maninsoft.smart.modeler.view.NodeView;
	import com.maninsoft.smart.modeler.view.ViewIconEvent;
	import com.maninsoft.smart.modeler.xpdl.XPDLEditor;
	import com.maninsoft.smart.modeler.xpdl.controller.SubFlowController;
	import com.maninsoft.smart.modeler.xpdl.model.SubFlow;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLNode;
	import com.maninsoft.smart.modeler.xpdl.server.Server;
	import com.maninsoft.smart.modeler.xpdl.server.service.GetProcessInfoByPackageService;
	import com.maninsoft.smart.modeler.xpdl.view.base.ActivityView;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;


	public class GanttTaskGroupController extends SubFlowController
	{

		private var defaultFillColor:uint 		= 0xf4bf76;
		private var externalGroupFillColor:int	= 0x808080;
		private var defaultSelBorderColor: uint = 0xda0000;


		public function GanttTaskGroupController(model:GanttTaskGroup)
		{
			super(model);
		}
		
		//----------------------------------------------------------------------
		// Overriden Methods
		//----------------------------------------------------------------------
		
		override protected function createNodeView(): NodeView {
			return new GanttTaskGroupView();
		}
		
		override protected function initNodeView(nodeView:NodeView): void {
			super.initNodeView(nodeView);

			var v: GanttTaskGroupView 			= nodeView as GanttTaskGroupView;
			var m: GanttTaskGroup 				= model as GanttTaskGroup;
			var ganttChartGrid: GanttChartGrid 	= m.parent as GanttChartGrid;

			m.taskRect = ganttChartGrid.getTaskRectangle(m.planFrom, m.planTo);

			var taskGroupInfo: Object = ganttChartGrid.findTaskInSubProcess(m);
			if(taskGroupInfo)
				m.taskGroup = taskGroupInfo.taskGroup as GanttTaskGroup;
			else m.taskGroup = null;
			
			adjustSourceConstraint();
			resetTaskGroupFromTo();
			resetViewBounds(m, v);
			resetNodeBounds(m, v);
							
			v.taskRect		= m.taskRect;
			v.groupRect		= m.groupRect;
			v.planFrom		= m.planFrom;
			v.planTo		= m.planTo;
			v.borderColor 	= m.borderColor;
			v.borderWidth 	= 1;
			v.fillColor 	= m.fillColor;
			v.taskNameTextColor = m.taskNameTextColor;
			v.name			= m.name;
			v.parentViewBounds=m.parentViewBounds=GanttChartGridController(parent).getViewBounds();
			
			m.diagram.addEventListener(DiagramChangeEvent.CHART_REFRESHED, doDiagramChanged);
			m.addEventListener(DiagramChangeEvent.LINK_ADDED, doLinkAdded);

			var groupInfo: Object = ganttChartGrid.findTaskInSubProcess(m);
			if(groupInfo){
				GanttTaskGroup(groupInfo.taskGroup).dispatchEvent(new NodeChangeEvent(m, GanttTaskGroup.PROP_NODEINDEX));				
			}
		}

		private function adjustSourceConstraint(): void{
			var m: GanttTaskGroup = model as GanttTaskGroup;
			var ganttChartGrid: GanttChartGrid 	= m.parent as GanttChartGrid;
			var taskDate: Date = new Date();
			var taskDateChanged: Boolean = false;
			
			if(!m.planFrom) return;
			taskDate.time = m.planFrom.time;

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
				m.taskRect.x = startPoint.x;
				var planFromTo: Array = ganttChartGrid.getTaskFromTo(m.taskRect);
				m.planFrom 	= planFromTo[0] as Date;
				m.planTo 	= planFromTo[1] as Date;
			}
		}
				
		private function changeTargetNodes(): void{
			var sourceLinks: Array = this.getSourceLinks()
			for each(var sourceLink: ConstraintLineController in sourceLinks){
				if(sourceLink && sourceLink.targetNode){
					sourceLink.targetNode.dispatchEvent(new NodeChangeEvent(nodeModel, GanttMilestone.PROP_SOURCENODEBOUNDS)) 
				}
			}
		}

		private function changeTargetViews(): void{
			var sourceLinks: Array = this.getSourceLinks()
			for each(var sourceLink: ConstraintLineController in sourceLinks){
				if(sourceLink && sourceLink.targetNode){
					sourceLink.targetNode.dispatchEvent(new NodeChangeEvent(nodeModel, GanttMilestone.PROP_SOURCEVIEWBOUNDS)) 
				}
			}
		}

		private function canMoveTargetNode(dx: Number, dy: Number): Boolean{
			var m: GanttTaskGroup = model as GanttTaskGroup;
			var targetLinks: Array = this.getTargetLinks()
			for each(var targetLink: ConstraintLineController in targetLinks){
				if(targetLink && targetLink.sourceNode){
					var sourceCtrl: NodeController = editor.findControllerByModel(targetLink.sourceNode) as NodeController;
					if(NodeView(sourceCtrl.view).bounds.right>m.x+dx) return false;  
				}
			}
			return true;		
		}

		private function resetTaskGroupFromTo(): void{
			var m: GanttTaskGroup = model as GanttTaskGroup;
			var ganttChartGrid: GanttChartGrid = m.parent as GanttChartGrid;
			var leftDate: Date;
			var rightDate: Date;
			var first: Boolean = true;

			if(!m.subProcess) return;			

			for each(var node: Node in m.subProcess.activities){
				if(first){
					if(node is GanttTask){
						leftDate = GanttTask(node).planFrom;
						rightDate = GanttTask(node).planTo;
					}else if(node is GanttTaskGroup){
						leftDate = GanttTaskGroup(node).planFrom;
						rightDate = GanttTaskGroup(node).planTo;
					}else if(node is GanttMilestone){
						leftDate = GanttMilestone(node).planDate;
						rightDate = GanttMilestone(node).planDate;
					}
					first=false;
				}else if(leftDate && rightDate){
					if(node is GanttTask && GanttTask(node).planFrom && GanttTask(node).planTo){
						if(GanttTask(node).planFrom.time<leftDate.time){
							leftDate = GanttTask(node).planFrom;
						}
						if(GanttTask(node).planTo.time>rightDate.time){
							rightDate = GanttTask(node).planTo;
						}
					}else if(node is GanttTaskGroup && GanttTaskGroup(node).planFrom && GanttTaskGroup(node).planTo){
						if(GanttTaskGroup(node).planFrom.time<leftDate.time){
							leftDate = GanttTaskGroup(node).planFrom;
						}
						if(GanttTaskGroup(node).planTo.time>rightDate.time){
							rightDate = GanttTaskGroup(node).planTo;
						}
					}else if(node is GanttMilestone && GanttMilestone(node).planDate){
						if(GanttMilestone(node).planDate.time<leftDate.time){
							leftDate = GanttMilestone(node).planDate;
						}
						if(GanttMilestone(node).planDate.time>rightDate.time){
							rightDate = GanttMilestone(node).planDate;
						}
					}
				}
			}
			if(!first && leftDate && rightDate){
//				m.subTaskLeftDateDiff = leftDate.time - GanttPackage.GANTTCHART_DUEDATE.time;
				m.planFrom 	= new Date(leftDate.time);
				m.planTo 	= new Date(rightDate.time);
				m.taskRect = ganttChartGrid.getTaskRectangle(m.planFrom, m.planTo);
			}				
		}
		
		public function resetNodeBounds(m: GanttTaskGroup, v: GanttTaskGroupView): void{
			var y: Number = GanttChartGrid.CHARTHEADER_HEIGHT*2 + GanttChartGrid.CHARTROW_HEIGHT*m.nodeIndex+m.taskRect.y;
			var bounds: Rectangle = new Rectangle(m.taskRect.x, y, m.taskRect.width, m.taskRect.height);
			m.bounds = bounds;
		}

		public function resetViewBounds(m:GanttTaskGroup, v:GanttTaskGroupView): void{
			v.x 				= m.taskRect.x;
			v.nodeWidth 		= m.taskRect.width;
			v.y 				= GanttChartGrid.CHARTHEADER_HEIGHT*2 + GanttChartGrid.CHARTROW_HEIGHT*m.nodeIndex;
			v.nodeHeight		= GanttChartGrid.CHARTROW_HEIGHT; 						
			v.actualNodeWidth 	= m.taskRect.width;
			v.groupRect 		= m.groupRect;
			v.taskRect			= m.taskRect;
			v.planFrom			= m.planFrom;
			v.planTo			= m.planTo;
		}

		public function resetViewYBounds(m:GanttTaskGroup, v:GanttTaskGroupView): void{
			v.x 				= m.taskRect.x;
			v.nodeWidth 		= m.taskRect.width;
			v.nodeHeight		= GanttChartGrid.CHARTROW_HEIGHT; 						
			v.actualNodeWidth 	= m.taskRect.width;
			v.groupRect			= m.groupRect;
			v.taskRect			= m.taskRect;
			v.planFrom			= m.planFrom;
			v.planTo			= m.planTo;
		}

		override public function refreshBounds(): void {
			var m: GanttTaskGroup = this.model as GanttTaskGroup;
			var v: GanttTaskGroupView = this.view as GanttTaskGroupView;			
			resetViewBounds(m, v);
			refreshSelection();
		}
		
		private function refreshNodeBounds(): void{
			var v: GanttTaskGroupView = view as GanttTaskGroupView;
			var m: GanttTaskGroup = model as GanttTaskGroup;
			adjustSourceConstraint();
			resetTaskGroupFromTo();
			resetViewBounds(m, v);
			resetNodeBounds(m, v);
			refreshView();
			changeLinksConstraint(this);
			changeTargetNodes();
		}
		
		private function refreshViewBounds(): void{
			var v: GanttTaskGroupView = view as GanttTaskGroupView;
			var m: GanttTaskGroup = model as GanttTaskGroup;
			adjustSourceConstraint();				
			resetTaskGroupFromTo();
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
			var v: GanttTaskGroupView = view as GanttTaskGroupView;
			var m: GanttTaskGroup = model as GanttTaskGroup;
			var ganttChartGrid: GanttChartGrid = m.parent as GanttChartGrid;
			
			switch (event.prop) {
				case XPDLNode.PROP_NAME:
					v.name = m.name;
					refreshView();
					break;
					
				case SubFlow.PROP_VIEW:
					if(event.oldValue.toString() == SubFlow.VIEW_COLLAPSED)
						expandTaskGroup();
					else if(event.oldValue.toString() == SubFlow.VIEW_EXPANDED)
						collapseTaskGroup();
					break;
					
				case GanttTaskGroup.PROP_PLANFROM:
				case GanttTaskGroup.PROP_PLANTO:
					m.taskRect = ganttChartGrid.getTaskRectangle(m.planFrom, m.planTo);
					refreshNodeBounds();
					break;
									
				case GanttTaskGroup.PROP_SUBVIEWBOUNDS:
				case GanttTaskGroup.PROP_VIEWBOUNDS:
				case GanttTaskGroup.PROP_SOURCEVIEWBOUNDS:
					refreshViewBounds();
					break;
				
				case GanttTaskGroup.PROP_NODEBOUNDS:				
				case GanttTaskGroup.PROP_SUBNODEBOUNDS:				
				case GanttTaskGroup.PROP_SOURCENODEBOUNDS:
				case GanttTaskGroup.PROP_NODEINDEX:
					refreshNodeBounds();
					break;
				
				case GanttTaskGroup.PROP_TASKGROUP:
					ganttChartGrid.changeTaskGroup(this.editor, m, event.oldValue as GanttTaskGroup, m.taskGroup);
					break;
					
				case SubFlow.PROP_SUBPROCESS_ID:
					if(m.subProcessInfo && m.subProcessInfo.packageId && m.subProcessInfo.version){
						var server: Server = XPDLEditor(editor).xpdlDiagram.server; 
						if(!server) server = XPDLEditor(editor).server;
						server.getProcessInfoByPackage(m.subProcessInfo.packageId, m.subProcessInfo.version, getProcessInfoCallback);
						function getProcessInfoCallback(svc: GetProcessInfoByPackageService):void{
							m.subProcessInfo.processId = svc.process.processId;
							m.subProcessId = m.subProcessInfo.processId;
							m.subProcessInfo.categoryPath =  svc.process.categoryPath;
							m.subProcessInfo.name = svc.process.name;
							collapseTaskGroup();
							ganttChartGrid.changeSubProcess(editor, m as GanttTaskGroup);
							if(m.isTaskGroupNodeEditable) v.fillColor = m.fillColor = defaultFillColor;
							else v.fillColor = m.fillColor = externalGroupFillColor;
							v.subProcessName = m.subProcessName;
							refreshView();
						}
					}else if(!m.subProcessInfo){
						m.subProcess = null;
						m.subProcessId = null;
						collapseTaskGroup();
						ganttChartGrid.changeSubProcess(editor, m as GanttTaskGroup);
						if(m.isTaskGroupNodeEditable) v.fillColor = m.fillColor = defaultFillColor;
						else v.fillColor = m.fillColor = externalGroupFillColor;
						refreshView();
					}					
					break;
				
				default:
					super.nodeChanged(event);
					break;
			}
			if (event.prop == Node.PROP_SIZE || 
			    event.prop == Node.PROP_X || event.prop == Node.PROP_Y || event.prop == Node.PROP_POSITION ||
			    event.prop == Node.PROP_BOUNDS ||
			    event.prop == GanttTaskGroup.PROP_NODEINDEX ) {
				var groupInfo: Object = ganttChartGrid.findTaskInSubProcess(m);
				if(groupInfo){
					m.taskGroup = groupInfo.taskGroup;
					GanttTaskGroup(groupInfo.taskGroup).dispatchEvent(new NodeChangeEvent(m, GanttTaskGroup.PROP_SUBNODEBOUNDS));				
				}else{
					m.taskGroup = null;
				}
				this.refreshPropertyPage();
		    }
		}
		
		//----------------------------------------------------------------------
		// Internal Methods
		//----------------------------------------------------------------------
		private function doViewIconClick(event: ViewIconEvent): void {
		}

		protected function doLinkAdded(event:DiagramChangeEvent): void{
			refreshNodeBounds();
		}

		protected function doDiagramChanged(event:DiagramChangeEvent): void{
			var v: GanttTaskGroupView = view as GanttTaskGroupView;
			var m: GanttTaskGroup = model as GanttTaskGroup;
			var ganttChartGrid: GanttChartGrid = m.parent as GanttChartGrid;

			if(!ganttChartGrid) return;

			m.taskRect = ganttChartGrid.getTaskRectangle(m.planFrom, m.planTo);

			var taskGroupInfo: Object = ganttChartGrid.findTaskInSubProcess(m);
			if(taskGroupInfo)
				m.taskGroup = taskGroupInfo.taskGroup as GanttTaskGroup;
			else m.taskGroup = null;

			adjustSourceConstraint();				
			resetTaskGroupFromTo();
			resetViewBounds(m, v);
			resetNodeBounds(m, v);

			v.taskRect	= m.taskRect;
			v.planFrom	= m.planFrom;
			v.planTo	= m.planTo;
			v.refresh();
			changeLinksConstraint(this);			
			changeTargetNodes();		
		}

		public function canExpand(): Boolean{
			var m: GanttTaskGroup = model as GanttTaskGroup;
			if(m.subFlowView == SubFlow.VIEW_COLLAPSED){
				return true
			}else{
				return false;
			}
		}
		
		public function canCollapse(): Boolean{
			var m: GanttTaskGroup = model as GanttTaskGroup;
			if(m.subFlowView == SubFlow.VIEW_EXPANDED){
				return true
			}else{
				return false;
			}			
		}
		
		public function expandTaskGroup(): void{
			var m: GanttTaskGroup = model as GanttTaskGroup;
			
			if( m.isTaskGroupViewExpanded) return;

			var diagram: XPDLDiagram = m.diagram as XPDLDiagram;
			var curNodeIndex: int = m.nodeIndex;

			if( diagram.activities.length<curNodeIndex || diagram.activities[curNodeIndex] != m){
				return;
			}
			
			for(var i:int=0; i<m.subProcess.activities.length; i++){
				Node(diagram.activities[curNodeIndex]).parent.addChildAt(m.subProcess.activities[i], ++curNodeIndex);
				if(m.subProcess.activities[i] is GanttTaskGroup){
					var ctrl:GanttTaskGroupController = editor.findControllerByModel(m.subProcess.activities[i] as GanttTaskGroup) as GanttTaskGroupController;
					if(ctrl){
						curNodeIndex = ctrl.addSubProcess(curNodeIndex);
					}
				}
			}
				
			if(m.subProcess.transitions.length>0){
				diagram.addLinks(m.subProcess.transitions);
			}

			var v: GanttTaskGroupView = view as GanttTaskGroupView;
			v.subFlowView 	= m.subFlowView = SubFlow.VIEW_EXPANDED;		
			v.groupRect		= m.groupRect;		

			editor.select(m);

			for(curNodeIndex; curNodeIndex < diagram.activities.length; curNodeIndex++){
				Node(diagram.activities[curNodeIndex]).dispatchEvent(new NodeChangeEvent(diagram.activities[curNodeIndex],GanttTaskGroup.PROP_NODEINDEX));
				var links: Array = Node(diagram.activities[curNodeIndex]).links;
				if(links){
					for each(var link:Link in links){
						link.dispatchEvent(new LinkChangeEvent(link));							
					}
				}
			}
		}

		public function addSubProcess(curNodeIndex: int): int{
			var m: GanttTaskGroup = model as GanttTaskGroup;
			if(!m.isTaskGroupViewExpanded) return curNodeIndex;

			var diagram: XPDLDiagram = m.diagram as XPDLDiagram;

			for(var i:int=0; i<m.subProcess.activities.length; i++){
				Node(diagram.activities[curNodeIndex]).parent.addChildAt(m.subProcess.activities[i], ++curNodeIndex);
				if(m.subProcess.activities[i] is GanttTaskGroup){
					var ctrl:GanttTaskGroupController = editor.findControllerByModel(m.subProcess.activities[i] as GanttTaskGroup) as GanttTaskGroupController;
					if(ctrl){
						curNodeIndex = ctrl.addSubProcess(curNodeIndex);
					}
				}
			}
				
			if(m.subProcess.transitions.length>0){
				diagram.addLinks(m.subProcess.transitions);
			}
			return curNodeIndex;
		}
		
		public function collapseTaskGroup(): void{
			var m: GanttTaskGroup = model as GanttTaskGroup;
			
			if(!m.isTaskGroupViewExpanded) return;

			var diagram: XPDLDiagram = m.diagram as XPDLDiagram;
			var curNodeIndex: int = m.nodeIndex;
			if( diagram.activities.length<curNodeIndex || diagram.activities[curNodeIndex] != m){
				return;
			}
			
			editor.selectionManager.clear();

			for(var i:int=0; i<m.subProcess.activities.length; i++){
				if(m.subProcess.activities[i] is GanttTaskGroup){
					var ctrl:GanttTaskGroupController = editor.findControllerByModel(m.subProcess.activities[i] as GanttTaskGroup) as GanttTaskGroupController;
					if(ctrl){
						ctrl.removeSubProcess();
					} 
				}
				Node(diagram.activities[curNodeIndex]).parent.removeChild(m.subProcess.activities[i]);
			}

			if(m.subProcess.transitions.length>0){
				diagram.removeLinks(m.subProcess.transitions);
			}
				
			var v: GanttTaskGroupView = view as GanttTaskGroupView;
			v.subFlowView = m.subFlowView = SubFlow.VIEW_COLLAPSED;
			v.groupRect		= m.groupRect;		
				
			editor.select(m);
				
			for(curNodeIndex; curNodeIndex < diagram.activities.length; curNodeIndex++){
				Node(diagram.activities[curNodeIndex]).dispatchEvent(new NodeChangeEvent(diagram.activities[curNodeIndex],GanttTaskGroup.PROP_NODEINDEX));
			}
		}

		public function removeSubProcess(): void{
			var m: GanttTaskGroup = model as GanttTaskGroup;
			
			if(!m.isTaskGroupViewExpanded) return;

			var diagram: XPDLDiagram = m.diagram as XPDLDiagram;
			var curNodeIndex: int = m.nodeIndex;

			for(var i:int=0; i<m.subProcess.activities.length; i++){
				if(m.subProcess.activities[i] is GanttTaskGroup){
					var ctrl:GanttTaskGroupController = editor.findControllerByModel(m.subProcess.activities[i] as GanttTaskGroup) as GanttTaskGroupController;
					if(ctrl){
						ctrl.removeSubProcess();
					} 
				}
				Node(diagram.activities[curNodeIndex]).parent.removeChild(m.subProcess.activities[i]);
			}
				
			if(m.subProcess.transitions.length>0){
				diagram.removeLinks(m.subProcess.transitions);
			}
		}

		override protected function showSelection(): Boolean {
			var v: GanttTaskGroupView = view as GanttTaskGroupView;

			v.borderColor = defaultSelBorderColor;
			v.taskNameTextColor = defaultSelBorderColor;
			v.refresh();
			return true;
		}
		
		override protected function hideSelection(): Boolean {
			var m: GanttTaskGroup = this.model as GanttTaskGroup;
			var v: GanttTaskGroupView = this.view as GanttTaskGroupView;

			showPropertyView = false;
			v.borderColor = m.borderColor;
			v.taskNameTextColor = m.taskNameTextColor;			
			v.refresh();
			return true;
		}
		
		override public function refreshSelection(): void {
		}

		override public function canMoveBy(dx: Number, dy: Number): Boolean {
			var m: GanttTaskGroup = model as GanttTaskGroup;
			var ganttChartGrid:GanttChartGrid = nodeModel.parent as GanttChartGrid;			
			var ctrl: NodeController = editor.findControllerByModel(m) as NodeController;
			var	groupHeight: Number = (m.subFlowView == SubFlow.VIEW_EXPANDED) ? GanttChartGrid.CHARTROW_HEIGHT*m.subProcess.activities.length:0;
			var right: Number= m.right+dx;
			var result: Object = ganttChartGrid.findTaskInSubProcess(this.nodeModel);
			if(result && !GanttTaskGroup(result.taskGroup).isTaskGroupNodeEditable) return false;
		
			return 	   (m.y + dy) >= GanttChartGrid(m.parent).nodeTop
					&& (m.y + dy + groupHeight)<= GanttChartGrid(m.parent).nodeBottom
					&& canMoveTargetNode(dx, dy)
					&& !ganttChartGrid.isUnderDueDate(nodeModel.x+dx, nodeModel.y+dy);
		}
				 
		override public function moveBy(dx: Number, dy: Number): void {
			if(!selected) return;

			var m: GanttTaskGroup 				= this.model as GanttTaskGroup;
			var v: GanttTaskGroupView 			= this.view as GanttTaskGroupView;				
			var editor: DiagramEditor 			= this.editor;
   			var ganttChartGrid:GanttChartGrid 	= m.parent as GanttChartGrid;
			var diagram: XPDLDiagram 			= m.diagram as XPDLDiagram;
			var cmd: GroupCommand 				= new GroupCommand();					
			var links: Array 					= new Array();
			var link: Link;
      			
			var p: Point			= controllerToEditor(getMovedPoint(SelectHandle.DIR_TOPLEFT, dx, dy));
			var oldPosition: Point 	= new Point(m.taskRect.x, m.taskRect.y);
				
			var di: int = (p.y-(v.y+v.taskRect.y))/GanttChartGrid.CHARTROW_HEIGHT;
			var acts: Array = XPDLDiagram(m.diagram).activities;
			var nodeIndex: int = m.nodeIndex;
			var deltaX: Number = p.x-v.x;
				
			for each (var handle: SelectHandle in selectHandles){		
				handle.x += deltaX;
				handle.y += di*GanttChartGrid.CHARTROW_HEIGHT;
			}

			m.taskRect.x 		+= deltaX;
			var planFromTo:Array= ganttChartGrid.getTaskFromTo(m.taskRect);
			m.planFrom			= planFromTo[0] as Date;
			m.planTo			= planFromTo[1] as Date;
			v.taskRect 			= m.taskRect;
			v.planFrom 			= m.planFrom;
			v.planTo 			= m.planTo;
			refreshBounds();
			changeTargetNodes();

			for each(var act: Node in m.subProcess.activities){
				if(act is GanttTask) moveByDeactivatedTask(act as GanttTask, deltaX);
				else if(act is GanttTaskGroup) moveByDeactivatedTaskGroup(act as GanttTaskGroup, deltaX);
				else if(act is GanttMilestone) moveByDeactivatedMilestone(act as GanttMilestone, deltaX);
			}
			function moveByDeactivatedTask(task: GanttTask, deltaX: Number): void{
				task.planTaskRect.x += deltaX;
				var planFromTo:Array= ganttChartGrid.getTaskFromTo(task.planTaskRect);
				task.planFrom 		= planFromTo[0] as Date;
				task.planTo 		= planFromTo[1] as Date;
			}
			function moveByDeactivatedTaskGroup(task: GanttTaskGroup, deltaX: Number): void{
				task.taskRect.x 	+= deltaX;
				var planFromTo:Array= ganttChartGrid.getTaskFromTo(task.taskRect);
				task.planFrom 		= planFromTo[0] as Date;
				task.planTo 		= planFromTo[1] as Date;
				for each(var subAct: Node in task.subProcess.activities){
					if(act is GanttTask) moveByDeactivatedTask(act as GanttTask, deltaX);
					else if(act is GanttTaskGroup) moveByDeactivatedTaskGroup(act as GanttTaskGroup, deltaX);
					else if(act is GanttMilestone) moveByDeactivatedMilestone(act as GanttMilestone, deltaX);
				}					
			}
			function moveByDeactivatedMilestone(task: GanttMilestone, deltaX: Number): void{
				task.planMilestonePoint.x += deltaX;
				task.planDate = ganttChartGrid.getTaskDate(task.planMilestonePoint);					
			}

			if(m.isTaskGroupViewExpanded){
				for each(var node: Node in m.subProcess.activities){
					node.dispatchEvent(new NodeChangeEvent(node,GanttTask.PROP_VIEWBOUNDS));
				}
			}

			if( (di) && (di+nodeIndex>=0) && di+nodeIndex<acts.length && acts[di+nodeIndex] && ganttChartGrid.canMoveByTargetIndex(m, m.taskGroup, di+nodeIndex)){
				var nodeChangeEvent: NodeChangeEvent;
				var curNodeIndex: int, nodeCnt: int;
				
				var result: Object = ganttChartGrid.findTaskInSubProcess(m);
				var myTaskGroup: GanttTaskGroup = (result)?result.taskGroup as GanttTaskGroup : null;

				if(di>0){
					for(nodeCnt=0; nodeCnt<di; nodeCnt++){
						var nextNodeIndex: int = nodeIndex+m.numSubNode+1+nodeCnt;
						var nextNode: Node = acts[nextNodeIndex];									

						editor.selectionManager.clear();

						for each(link in nextNode.sourceLinks)
							links.push(link)
						for each(link in nextNode.targetLinks)
							links.push(link)

						cmd.add(new GanttNodeDeleteCommand(nextNode, nextNodeIndex));					
						cmd.add(new GanttNodeCreateCommand(ganttChartGrid, nodeIndex+nodeCnt, nextNode));
						for each(link in links)
							cmd.add(new GanttLinkCreateCommand(link, null));
						editor.execute(cmd);

						for(curNodeIndex=nodeIndex; curNodeIndex < nextNodeIndex+1; curNodeIndex++){
							Node(acts[curNodeIndex]).dispatchEvent(new NodeChangeEvent(acts[curNodeIndex],GanttTaskGroup.PROP_NODEINDEX));
						}
						if(myTaskGroup){
							myTaskGroup.dispatchEvent(new NodeChangeEvent(myTaskGroup,GanttTaskGroup.PROP_NODEINDEX));						
						}
					}
				}else{
					for(nodeCnt=di; nodeCnt<0; nodeCnt++){
						var prevNodeIndex: int = nodeIndex+di;
						var prevNode: Node = acts[prevNodeIndex];									

						editor.selectionManager.clear();
							
						for each(link in prevNode.sourceLinks)
							links.push(link)
						for each(link in prevNode.targetLinks)
							links.push(link)
						cmd.add(new GanttNodeDeleteCommand(prevNode, prevNodeIndex));					
						cmd.add(new GanttNodeCreateCommand(ganttChartGrid, nodeIndex+m.numSubNode, prevNode));
						for each(link in links)
							cmd.add(new GanttLinkCreateCommand(link, null));
						editor.execute(cmd);

						for(curNodeIndex=prevNodeIndex; curNodeIndex < nodeIndex+m.numSubNode+1; curNodeIndex++){
							Node(acts[curNodeIndex]).dispatchEvent(new NodeChangeEvent(acts[curNodeIndex],GanttTaskGroup.PROP_NODEINDEX));
						}
						if(myTaskGroup){
							myTaskGroup.dispatchEvent(new NodeChangeEvent(myTaskGroup,GanttTaskGroup.PROP_NODEINDEX));						
						}
					}						
				}
				editor.selectionManager.clear();
				editor.selectionManager.clearOffset = true;
				editor.select(m);
			}else{
				m.dispatchEvent(new NodeChangeEvent(m, Node.PROP_POSITION));											
			}
		}

		override protected function checkStatus(status: String, view: ActivityView): void {

			view.showShadowed = false;
			view.showGrayed = false;
			view.showGradient = false;
			view.showGlowed = false;	
		}

		public function moveToTheDate(icon: Object):void{
			var m: GanttTaskGroup = this.model as GanttTaskGroup;
   			var ganttChartGrid:GanttChartGrid 	= m.parent as GanttChartGrid;
			var ganttChartGridCtrl:GanttChartGridController = editor.findControllerByModel( nodeModel.parent as GanttChartGrid) as GanttChartGridController;
			var startDate:Date, endDate:Date;
			if(icon is GanttIconLibrary.overLeftIcon){
				if(m.planFrom && m.planFrom.time < ganttChartGrid.startDate.time)
					startDate = new Date(m.planFrom.time);
			}else if(icon is GanttIconLibrary.overRightIcon){
				if(m.planTo && m.planTo.time > ganttChartGrid.endDate.time)
					endDate = new Date(m.planTo.time);
			}
			ganttChartGridCtrl.moveToTheDate(startDate, endDate);
		}
	}

}