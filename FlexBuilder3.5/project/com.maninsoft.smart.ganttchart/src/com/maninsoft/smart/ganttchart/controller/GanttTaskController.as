package com.maninsoft.smart.ganttchart.controller
{
	import com.maninsoft.smart.ganttchart.assets.GanttIconLibrary;
	import com.maninsoft.smart.ganttchart.command.GanttLinkCreateCommand;
	import com.maninsoft.smart.ganttchart.command.GanttNodeCreateCommand;
	import com.maninsoft.smart.ganttchart.command.GanttNodeDeleteCommand;
	import com.maninsoft.smart.ganttchart.editor.GanttChart;
	import com.maninsoft.smart.ganttchart.editor.handle.GanttSelectHandle;
	import com.maninsoft.smart.ganttchart.model.GanttChartGrid;
	import com.maninsoft.smart.ganttchart.model.GanttTask;
	import com.maninsoft.smart.ganttchart.model.GanttTaskGroup;
	import com.maninsoft.smart.ganttchart.view.GanttMilestoneView;
	import com.maninsoft.smart.ganttchart.view.GanttTaskGroupView;
	import com.maninsoft.smart.ganttchart.view.GanttTaskView;
	import com.maninsoft.smart.modeler.command.GroupCommand;
	import com.maninsoft.smart.modeler.common.Size;
	import com.maninsoft.smart.modeler.controller.NodeController;
	import com.maninsoft.smart.modeler.editor.DiagramEditor;
	import com.maninsoft.smart.modeler.editor.events.DiagramChangeEvent;
	import com.maninsoft.smart.modeler.editor.handle.SelectHandle;
	import com.maninsoft.smart.modeler.model.Link;
	import com.maninsoft.smart.modeler.model.Node;
	import com.maninsoft.smart.modeler.model.events.NodeChangeEvent;
	import com.maninsoft.smart.modeler.view.NodeView;
	import com.maninsoft.smart.modeler.xpdl.XPDLEditor;
	import com.maninsoft.smart.modeler.xpdl.controller.TaskApplicationController;
	import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLNode;
	import com.maninsoft.smart.modeler.xpdl.server.Server;
	import com.maninsoft.smart.modeler.xpdl.server.service.GetProcessInfoByPackageService;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class GanttTaskController extends TaskApplicationController
	{

		private var defaultBorderColor: uint 		= 0x4394b1;
		private var defaultFillColor: uint 			= 0xeff8ff;
		private var defaultExeBorderColor: uint 	= 0x686b6d;
		private var defaultExeFillColor: uint 		= 0x686b6d;			
		private var defaultSelBorderColor: uint 	= 0xda0000;
		
		public function GanttTaskController(model:GanttTask)
		{
			super(model);
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		public function get ganttTask(): GanttTask {
			return taskModel as GanttTask;
		}


		//----------------------------------------------------------------------
		// Overriden Methods
		//----------------------------------------------------------------------
		
		override protected function createNodeView(): NodeView {
			return new GanttTaskView();
		}

		override protected function initNodeView(nodeView:NodeView): void {
			super.initNodeView(nodeView);

			var v: GanttTaskView 				= nodeView as GanttTaskView;
			var m: GanttTask 					= model as GanttTask;
       		var ganttChartGrid:GanttChartGrid 	= m.parent as GanttChartGrid;

			m.planTaskRect 		= ganttChartGrid.getTaskRectangle(m.planFrom, m.planTo);
			if(m.executionFrom && !m.executionTo)
				if(m.executionFrom.time<(new Date()).time)
					m.executionTo = new Date();
				else
					m.executionTo = new Date(m.executionFrom.time);
			else if(m.executionFrom == null)
				m.executionTo = null;
			m.executionTaskRect = ganttChartGrid.getExeTaskRectangle(m.executionFrom, m.executionTo);
			var taskGroupInfo: Object = ganttChartGrid.findTaskInSubProcess(m);
			if(taskGroupInfo)
				m.taskGroup = taskGroupInfo.taskGroup as GanttTaskGroup;
			else m.taskGroup = null;

			checkGanttStatus(m.status, m);
			adjustSourceConstraint();
			resetViewBounds(m, v);
			resetNodeBounds(m, v);
			
			v.planTaskRect		= m.planTaskRect;
			v.planFrom 			= m.planFrom;
			v.planTo 			= m.planTo;
			v.executionTaskRect = m.executionTaskRect;
			v.executionFrom 	= m.executionFrom;
			v.executionTo 		= m.executionTo;
			v.borderColor 		= m.borderColor;
			v.borderWidth 		= 1;
			v.fillColor 		= m.fillColor;
			v.exeBorderColor 	= m.exeBorderColor;
			v.exeBorderWidth 	= 1;
			v.exeFillColor 		= m.exeFillColor;
			v.taskNameTextColor = m.taskNameTextColor;
			v.name				= m.name;
			v.parentViewBounds	= m.parentViewBounds = GanttChartGridController(parent).getViewBounds();

			m.diagram.addEventListener(DiagramChangeEvent.CHART_REFRESHED, doDiagramChanged);
			m.addEventListener(DiagramChangeEvent.LINK_ADDED, doLinkAdded);

			var groupInfo: Object = ganttChartGrid.findTaskInSubProcess(m);
			if(groupInfo){
				GanttTaskGroup(groupInfo.taskGroup).dispatchEvent(new NodeChangeEvent(m, GanttTaskGroup.PROP_NODEINDEX));				
			}
		}

		private function adjustSourceConstraint(): void{
			var m: GanttTask = model as GanttTask;
			var ganttChartGrid: GanttChartGrid 	= m.parent as GanttChartGrid;
			var taskDate: Date = new Date();
			var taskDateString: String;
			var taskDateChanged: Boolean = false;
			
			if(!m.planFrom) return;
			
			taskDate.time = m.planFrom.time;
			var targetLinks: Array = this.getTargetLinks();
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
				m.planTaskRect.x = startPoint.x;
				var planFromTo:Array = ganttChartGrid.getTaskFromTo(m.planTaskRect);
				m.planFrom 	= planFromTo[0] as Date;
				m.planTo	= planFromTo[1] as Date;	
			}
		}
		
		private function changeTargetNodes(): void{
			var sourceLinks: Array = this.getSourceLinks()
			for each(var sourceLink: ConstraintLineController in sourceLinks){
				if(sourceLink && sourceLink.targetNode){
					sourceLink.targetNode.dispatchEvent(new NodeChangeEvent(nodeModel, GanttTask.PROP_SOURCENODEBOUNDS)) 
				}
			}
		}
		
		private function changeTargetViews(): void{
			var sourceLinks: Array = this.getSourceLinks()
			for each(var sourceLink: ConstraintLineController in sourceLinks){
				if(sourceLink && sourceLink.targetNode){
					sourceLink.targetNode.dispatchEvent(new NodeChangeEvent(nodeModel, GanttTask.PROP_SOURCEVIEWBOUNDS)) 
				}
			}
		}
		
		private function canMoveTargetNode(dx: Number, dy: Number): Boolean{
			var m: GanttTask = model as GanttTask;
			var targetLinks: Array = this.getTargetLinks()
			for each(var targetLink: ConstraintLineController in targetLinks){
				if(targetLink && targetLink.sourceNode){
					var sourceCtrl: NodeController = editor.findControllerByModel(targetLink.sourceNode) as NodeController;
					if(NodeView(sourceCtrl.view).bounds.right>m.x+dx) return false;  
				}
			}
			return true;		
		}

		public function resetNodeBounds(m: GanttTask, v: GanttTaskView): void{
			var y: Number = GanttChartGrid.CHARTHEADER_HEIGHT*2 + GanttChartGrid.CHARTROW_HEIGHT*m.nodeIndex+m.planTaskRect.y;
			var bounds: Rectangle = new Rectangle(m.planTaskRect.x, y, m.planTaskRect.width, m.planTaskRect.height);
			m.bounds = bounds;
			if(parent)
				m.parentViewBounds = GanttChartGridController(parent).getViewBounds();
		}

		public function resetViewBounds(m:GanttTask, v:GanttTaskView): void{
			v.x 				= m.planTaskRect.x;
			v.nodeWidth 		= m.planTaskRect.width;
			v.y 				= GanttChartGrid.CHARTHEADER_HEIGHT*2 + GanttChartGrid.CHARTROW_HEIGHT*m.nodeIndex;
			v.nodeHeight		= GanttChartGrid.CHARTROW_HEIGHT; 						
			v.planTaskRect		= m.planTaskRect;	
			v.planFrom 			= m.planFrom;
			v.planTo 			= m.planTo;
			v.executionTaskRect	= m.executionTaskRect;	
			v.executionFrom		= m.executionFrom;
			v.executionTo		= m.executionTo;
			v.parentViewBounds	= m.parentViewBounds;

			if( m.executionTaskRect.width ==0 ){
				v.actualNodeWidth = m.planTaskRect.width;
			}else{
				v.actualNodeWidth=     m.planTaskRect.x+m.planTaskRect.width
									>  m.executionTaskRect.x+m.executionTaskRect.width
									?  m.planTaskRect.width
									:  m.executionTaskRect.x+m.executionTaskRect.width-m.planTaskRect.x;
			}
		}
		
		public function resetViewYBounds(m:GanttTask, v:GanttTaskView): void{
			v.x 				= m.planTaskRect.x;
			v.nodeWidth 		= m.planTaskRect.width;
			v.nodeHeight		= GanttChartGrid.CHARTROW_HEIGHT; 
			v.planTaskRect		= m.planTaskRect;	
			v.planFrom			= m.planFrom;
			v.planTo			= m.planTo;
			v.executionTaskRect	= m.executionTaskRect;	
			v.executionFrom		= m.executionFrom;
			v.executionTo		= m.executionTo;
					
			if( m.executionTaskRect.width ==0 ){
				v.actualNodeWidth = m.planTaskRect.width;
			}else{
				v.actualNodeWidth=     m.planTaskRect.x+m.planTaskRect.width
									>  m.executionTaskRect.x+m.executionTaskRect.width
									?  m.planTaskRect.width
									:  m.executionTaskRect.x+m.executionTaskRect.width-m.planTaskRect.x;
			}
		}

		override public function refreshBounds(): void {
			var m: GanttTask 	= this.model as GanttTask;
			var v: GanttTaskView= this.view as GanttTaskView;
			
			resetViewBounds(m, v);
		}

		private function refreshNodeBounds(): void{
			var m: GanttTask 					= model as GanttTask;
			var v: GanttTaskView 				= view as GanttTaskView;
			adjustSourceConstraint();
			resetNodeBounds(m, v);
			resetViewBounds(m, v);
			refreshView();
			changeLinksConstraint(this);			
			changeTargetNodes()			
		}
		
		private function refreshViewBounds(): void{
			var m: GanttTask 					= model as GanttTask;
			var v: GanttTaskView 				= view as GanttTaskView;
			adjustSourceConstraint();
			resetViewBounds(m, v);
			refreshView();
			changeLinksConstraint(this);
			changeTargetViews()			
		}
		
		public function refreshPropertyPage():void{
			if(GanttChart(editor).selectionManager.contains(this) && GanttChart(editor).selectionManager.items.length==1)
				GanttChart(editor).select(model);
		}
		
		protected function checkGanttStatus(status: String, view: GanttTask): void {
			//if (xpdlEditor.isRunning) {

			switch (status) {
				case Activity.STATUS_READY:
					view.fillColor = defaultFillColor;
					view.borderColor = defaultBorderColor;
					view.exeFillColor = 0xbdda7d;
					view.exeBorderColor = 0x767676;
					break;
	
				case Activity.STATUS_COMPLETED:
					view.fillColor = defaultFillColor;
					view.borderColor = defaultBorderColor;
					view.exeFillColor = 0xbbbbbb;
					view.exeBorderColor = 0x767676;
					break;
	
				case Activity.STATUS_PROCESSING:
					view.fillColor = defaultFillColor;
					view.borderColor = defaultBorderColor;
					view.exeFillColor = 0xffa970;
					view.exeBorderColor = 0x767676;
					break;
	
				case Activity.STATUS_SUSPENDED:
					view.fillColor = 0xffa970;
					view.borderColor = 0x767676;
					break;
	
				case Activity.STATUS_RETURNED:
					view.fillColor = 0x8ae0d9;
					view.borderColor = 0x767676;
					break;
	
				case Activity.STATUS_DELAYED:
					view.fillColor = 0xfa8487;
					view.borderColor = 0x767676;
					break;

				case Activity.STATUS_NONE:
				default:
					view.fillColor = defaultFillColor;
					view.borderColor = defaultBorderColor;
					view.exeFillColor = defaultExeFillColor;
					view.exeBorderColor = defaultExeBorderColor;
					break;
			}
		}

		override protected function nodeChanged(event: NodeChangeEvent): void {
			var m: GanttTask 					= model as GanttTask;
			var v: GanttTaskView 				= view as GanttTaskView;
			var ganttChartGrid: GanttChartGrid 	= m.parent as GanttChartGrid;
			
			switch (event.prop) {
				case XPDLNode.PROP_NAME:
					v.name = m.name;
					refreshView();
					break;

				case TaskApplication.PROP_FORMID:
					if(m.formId){
						m.workInfo = null;
						m.appId = TaskApplication.SYSTEM_APPLICATION_ID;						
						refreshPropertyPage();
					}
					super.nodeChanged(event);
					break;
					
				case GanttTask.PROP_WORKID:
					if(m.workInfo && m.workInfo.packageId && m.workInfo.version){
						if(m.workInfo.name){
							m.workId = m.workInfo.packageId;
							m.formId = null;
							refreshPropertyPage();
							refreshView();
						}else{
							var server:Server = XPDLEditor(editor).xpdlDiagram.server;
							if(!server) server = XPDLEditor(editor).server;
							if(server) server.getProcessInfoByPackage(m.workInfo.packageId, m.workInfo.version, getProcessInfoCallback);
							function getProcessInfoCallback(svc: GetProcessInfoByPackageService):void{
								m.workInfo.categoryPath =  svc.process.categoryPath;
								m.workInfo.name = svc.process.name;

								m.workId = m.workInfo.packageId;
								m.formId = null;
								refreshPropertyPage();
								refreshView();
							}
						}
						m.appId = GanttTask.SYSTEM_WORK_ID;
					}else if(!m.workInfo){
						m.workId = null;
						m.appId = TaskApplication.SYSTEM_APPLICATION_ID;
						refreshPropertyPage();
						refreshView();
					}					
					break;
					
				case GanttTask.PROP_PLANFROM:
				case GanttTask.PROP_PLANTO:
					m.planTaskRect = ganttChartGrid.getTaskRectangle(m.planFrom, m.planTo);
					refreshNodeBounds();
					break;
									
				case GanttTask.PROP_EXECUTIONFROM:
				case GanttTask.PROP_EXECUTIONTO:
					if(m.executionFrom && !m.executionTo)
						m.executionTo = new Date(m.executionFrom.time);
					else if(m.executionFrom == null)
						m.executionTo = null;
					m.executionTaskRect = ganttChartGrid.getExeTaskRectangle(m.executionFrom, m.executionTo);
					refreshNodeBounds();
					break;
									
				case GanttTask.PROP_SOURCEVIEWBOUNDS:
				case GanttTask.PROP_VIEWBOUNDS:
					refreshViewBounds();
					break;

				case GanttTask.PROP_SOURCENODEBOUNDS:
				case GanttTask.PROP_NODEBOUNDS:
				case GanttTask.PROP_NODEINDEX:
					refreshNodeBounds();
					break;
				
				case GanttTask.PROP_TASKGROUP:
					ganttChartGrid.changeTaskGroup(this.editor, m, event.oldValue as GanttTaskGroup, m.taskGroup);
					break;
					
				default:
					super.nodeChanged(event);
					break;
			}
			if (event.prop == Node.PROP_SIZE || 
			    event.prop == Node.PROP_X || event.prop == Node.PROP_Y || event.prop == Node.PROP_POSITION ||
			    event.prop == Node.PROP_BOUNDS ||
			    event.prop == GanttTask.PROP_NODEINDEX ) {
				var groupInfo: Object = ganttChartGrid.findTaskInSubProcess(m);
				if(groupInfo){
					m.taskGroup = groupInfo.taskGroup;
					GanttTaskGroup(groupInfo.taskGroup).dispatchEvent(new NodeChangeEvent(m, GanttTaskGroup.PROP_SUBNODEBOUNDS));				
				}else{
					m.taskGroup = null;
				}
		   		refreshPropertyPage();
		    }		    
		}		
		
		protected function doLinkAdded(event:DiagramChangeEvent): void{
			refreshNodeBounds();
		}

		protected function doDiagramChanged(event:DiagramChangeEvent): void{
			var v: GanttTaskView 				= view as GanttTaskView;
			var m: GanttTask 					= model as GanttTask;
       		var ganttChartGrid:GanttChartGrid 	= m.parent as GanttChartGrid;

			if(!ganttChartGrid) return;
			
			m.planTaskRect 		= ganttChartGrid.getTaskRectangle(m.planFrom, m.planTo);

			if(m.executionFrom && !m.executionTo)
				m.executionTo = new Date(m.executionFrom.time);	
			else if(m.executionFrom == null)
				m.executionTo = null;
			m.executionTaskRect = ganttChartGrid.getExeTaskRectangle(m.executionFrom, m.executionTo);
			var taskGroupInfo: Object = ganttChartGrid.findTaskInSubProcess(m);
			if(taskGroupInfo)
				m.taskGroup = taskGroupInfo.taskGroup as GanttTaskGroup;
			else m.taskGroup = null;
			
			adjustSourceConstraint();
			resetNodeBounds(m, v);
			resetViewBounds(m, v);
			
			v.planTaskRect		= m.planTaskRect;
			v.planFrom 			= m.planFrom;
			v.planTo 			= m.planTo;
			v.executionTaskRect = m.executionTaskRect;
			v.executionFrom 	= m.executionFrom;
			v.executionTo 		= m.executionTo;

			refreshView();

			changeLinksConstraint(this);	
			changeTargetNodes();		
		}
		
		override protected function showSelection(): Boolean {
			var m: GanttTask = model as GanttTask;
			var v: GanttTaskView = view as GanttTaskView;
			
			if (!selectHandles) {
				var dirs: Array = getSelectAnchorDirs();	
				selectHandles = new Array();				
				for (var i: int = 0; i < dirs.length; i++) {
					var handle: GanttSelectHandle = new GanttSelectHandle(this, dirs[i], v.height);					
					var p: Point = controllerToEditor(getSelectAnchorPoint(dirs[i]));
					
					if(dirs[i] == SelectHandle.DIR_LEFT)
						handle.x = p.x-handle.width/2+GanttChartGrid.CHARTMORE_WIDTH;
					else
						handle.x = p.x-handle.width/2+GanttChartGrid.CHARTMORE_WIDTH;						
					handle.y = p.y - handle.height/2;
					
					selectHandles.push(handle);
					editor.getSelectionLayer().addChild(handle);
					handle.editor = editor as GanttChart;
				}
				v.borderColor 	= defaultSelBorderColor;
				v.taskNameTextColor = defaultSelBorderColor;
				refreshView();
				return true;
			}else{
				return false;
			}
		}
		
		override public function getSelectAnchorDirs(): Array {
			var dirs: Array = new Array();
			
			dirs.push(SelectHandle.DIR_RIGHT);
			dirs.push(SelectHandle.DIR_LEFT);
			return dirs;			
		}

		/**
		 * 선택 핸들들의 위치값을 리턴한다.
		 */
		override public function getSelectAnchorPoint(dir: int): Point {
			var node: GanttTask = model as GanttTask;			
			var x: Number = node.x;
			var y: Number = node.y;
			var w: Number = node.width;
			var h: Number = node.height;

			switch (dir) {			
				case SelectHandle.DIR_RIGHT:
					return new Point(x + w, y + h / 2);
					
				case SelectHandle.DIR_LEFT:			
					return new Point(x, y + h / 2);
					
				default:
					throw new Error("Invalid selectAnchorDir(" + dir + ")");
			}
		}
		
		override protected function hideSelection(): Boolean {
			var m: GanttTask 	= this.model as GanttTask;
			var v: GanttTaskView= view as GanttTaskView;

			showPropertyView = false;
			
			if (selectHandles) {
				for each (var handle: GanttSelectHandle in selectHandles) {
					if (handle.editor.getSelectionLayer().contains(handle)) {
						handle.editor.getSelectionLayer().removeChild(handle);
					}
				}				
				selectHandles = null;
				v.borderColor = m.borderColor;
				v.taskNameTextColor = m.taskNameTextColor;
				refreshView();
				return true;
			}else{
				return false;
			}	
		}
		
		override public function refreshSelection(): void {
		}

		override public function canResizeBy(anchorDir: int, dx: Number, dy: Number): Boolean {
			var ganttChartGrid:GanttChartGrid = nodeModel.parent as GanttChartGrid;			
			var result: Object = ganttChartGrid.findTaskInSubProcess(this.nodeModel);
			if(result && !GanttTaskGroup(result.taskGroup).isTaskGroupNodeEditable) return false;

			if(anchorDir == SelectHandle.DIR_LEFT){
				if(!this.canMoveTargetNode(dx, dy) || (nodeModel.x + dx) >= nodeModel.right 
					|| ganttChartGrid.isUnderDueDate(nodeModel.x+dx, nodeModel.y+dy)
					|| ganttChartGrid.isUnderMinimumTimeOffset(nodeModel.x+dx, nodeModel.right))
					return false;
				else
					return true;
			}else if( anchorDir == SelectHandle.DIR_RIGHT){
				if((nodeModel.right + dx) <= nodeModel.x || ganttChartGrid.isUnderMinimumTimeOffset(nodeModel.x, nodeModel.right + dx))
					return false;
				else
					return true;
			}else{ 
				return false;
			}
		} 
		
		override public function resizeBy(anchorDir: int, dx: Number, dy: Number): void {
			if (selected && selectHandles) {
				var m: GanttTask 					= this.model as GanttTask;
				var v: GanttTaskView 				= this.view as GanttTaskView;
       			var ganttChartGrid:GanttChartGrid 	= m.parent as GanttChartGrid;
				var oldSize: Size, oldPosition: Point;
				var p: Point = controllerToEditor(getResizedPoint(anchorDir, anchorDir, dx, dy));

				for each (var handle: SelectHandle in selectHandles)
					if(anchorDir == handle.anchorDir)
						handle.x = p.x-handle.width/2+GanttChartGrid.CHARTMORE_WIDTH;

				if(anchorDir == SelectHandle.DIR_LEFT){
					oldPosition = new Point(m.planTaskRect.x, m.planTaskRect.y);
					oldSize 	= new Size(m.planTaskRect.width, m.planTaskRect.height);
					m.planTaskRect.x -= v.x-p.x;
					m.planTaskRect.width += v.x-p.x;
				}else if(anchorDir == SelectHandle.DIR_RIGHT){
					oldSize = new Size(m.planTaskRect.width, m.planTaskRect.height);
					m.planTaskRect.width = p.x-v.x;
				}

				var planFromTo: Array = ganttChartGrid.getTaskFromTo(m.planTaskRect);
				m.planFrom	= planFromTo[0] as Date;
				m.planTo	= planFromTo[1] as Date;
				
				v.planTaskRect 	= m.planTaskRect;
				v.planFrom 		= m.planFrom;
				v.planTo 		= m.planTo;

				refreshBounds();
				refreshView();
				changeTargetNodes();
				m.dispatchEvent(new NodeChangeEvent(m, Node.PROP_SIZE, oldSize));
				if(oldPosition)						
					m.dispatchEvent(new NodeChangeEvent(m, Node.PROP_POSITION, oldPosition));
			}		
		}

		/**
		 * dx, dy 만큼 크기 변경이 요청된 후의 선택 핸들들의 위치값을 리턴한다.
		 */ 
		override public function getResizedPoint(sizeAnchor: int, dir: Number, dx: Number, dy: Number): Point {			
			var p: Point = getSelectAnchorPoint(dir);
			
			switch (sizeAnchor){			
				case SelectHandle.DIR_RIGHT:
				case SelectHandle.DIR_LEFT:			
					p.x += dx;
					break;
					
				default:
					throw new Error("Invalid selectAnchorDir(" + dir + ")");
			}

			return p;
		}
		 
		override public function canMoveBy(dx: Number, dy: Number): Boolean {
			var ganttChartGrid:GanttChartGrid = nodeModel.parent as GanttChartGrid;			
			var result: Object = ganttChartGrid.findTaskInSubProcess(this.nodeModel);
			if(result && !GanttTaskGroup(result.taskGroup).isTaskGroupNodeEditable)
				return false;
			return 	   (nodeModel.y + dy) >= GanttChartGrid(nodeModel.parent).nodeTop
					&& (nodeModel.y + dy)<= GanttChartGrid(nodeModel.parent).nodeBottom
					&& this.canMoveTargetNode(dx, dy) 
					&& !ganttChartGrid.isUnderDueDate(nodeModel.x+dx, nodeModel.y+dy);
		}
		
		override public function moveBy(dx: Number, dy: Number): void {
			if (selected && selectHandles) {
				var m: GanttTask 					= this.model as GanttTask;
				var v: GanttTaskView 				= this.view as GanttTaskView;				
 				var editor: DiagramEditor 			= this.editor;
      			var ganttChartGrid:GanttChartGrid 	= m.parent as GanttChartGrid;
				var diagram: XPDLDiagram 			= m.diagram as XPDLDiagram;
				var cmd: GroupCommand 				= new GroupCommand();					
				var links: Array 					= new Array();
				var link: Link;
      			
				var p: Point			= controllerToEditor(getMovedPoint(SelectHandle.DIR_TOPLEFT, dx, dy));
				var oldPosition: Point 	= new Point(m.planTaskRect.x, m.planTaskRect.y);
				
				var di: int = (p.y-(v.y+v.planTaskRect.y))/GanttChartGrid.CHARTROW_HEIGHT;
				var acts: Array = XPDLDiagram(m.diagram).activities;
				var nodeIndex: int = m.nodeIndex;
				
				for each (var handle: SelectHandle in selectHandles){		
					handle.x += p.x-v.x;
					handle.y += di*GanttChartGrid.CHARTROW_HEIGHT;
				}

				m.planTaskRect.x 	+= p.x-v.x;
				var planFromTo:Array= ganttChartGrid.getTaskFromTo(m.planTaskRect);
				m.planFrom			= planFromTo[0] as Date;
				m.planTo			= planFromTo[1] as Date;
				v.planTaskRect 		= m.planTaskRect;
				v.planFrom 			= m.planFrom;
				v.planTo 			= m.planTo;
				refreshBounds();
				changeTargetNodes();

				if( (di) && (di+nodeIndex>=0) && di+nodeIndex<acts.length && acts[di+nodeIndex] && ganttChartGrid.canMoveByTargetIndex(m, m.taskGroup, di+nodeIndex)){
					for each(link in m.sourceLinks)
						links.push(link)
					for each(link in m.targetLinks)
						links.push(link)
						
					var result: Object = ganttChartGrid.findTaskInSubProcess(m);
					var myTaskGroup: GanttTaskGroup = (result)?result.taskGroup as GanttTaskGroup : null;

					editor.selectionManager.clear();
					editor.selectionManager.clearOffset = true;
										
					cmd.add(new GanttNodeDeleteCommand(m, nodeIndex));					
					cmd.add(new GanttNodeCreateCommand(ganttChartGrid, nodeIndex+di, m));
					for each(link in links)
						cmd.add(new GanttLinkCreateCommand(link, null));
					editor.execute(cmd);
					
					var start: int = nodeIndex<nodeIndex+di?nodeIndex:nodeIndex+di;
					var end: int = nodeIndex>nodeIndex+di?nodeIndex:nodeIndex+di;
					var nodeChangeEvent: NodeChangeEvent;
					for(var curNodeIndex: int=start; curNodeIndex < end+1; curNodeIndex++){
						Node(acts[curNodeIndex]).dispatchEvent(new NodeChangeEvent(acts[curNodeIndex],GanttTask.PROP_NODEINDEX));
					}
					if(myTaskGroup){
						myTaskGroup.dispatchEvent(new NodeChangeEvent(myTaskGroup,GanttTask.PROP_NODEINDEX));						
					}

					var groupInfo: Object = ganttChartGrid.findTaskInSubProcess(m);
					if(groupInfo){
						Node(groupInfo.taskGroup).dispatchEvent(new NodeChangeEvent(groupInfo.taskGroup,GanttTask.PROP_NODEINDEX));						
					}
				}else{
					m.dispatchEvent(new NodeChangeEvent(m, Node.PROP_POSITION));											
				}
				refreshView();
			}
		}

		public function moveToTheDate(icon: Object):void{
			var m: GanttTask = this.model as GanttTask;
   			var ganttChartGrid:GanttChartGrid 	= m.parent as GanttChartGrid;
			var ganttChartGridCtrl:GanttChartGridController = editor.findControllerByModel( nodeModel.parent as GanttChartGrid) as GanttChartGridController;
			var startDate:Date, endDate:Date;			
			if(icon is GanttIconLibrary.overLeftIcon){
				if(m.planFrom && m.planFrom.time < ganttChartGrid.startDate.time)
					startDate = new Date(m.planFrom.time);
				else if(m.executionFrom && m.executionFrom.time < ganttChartGrid.startDate.time)
					startDate = new Date(m.executionFrom.time);
			}else if(icon is GanttIconLibrary.overRightIcon){
				if(m.planTo && m.planTo.time > ganttChartGrid.endDate.time)
					endDate = new Date(m.planTo.time);
				else if(m.executionTo && m.executionTo.time > ganttChartGrid.endDate.time)
					endDate = new Date(m.executionTo.time);				
			}
			ganttChartGridCtrl.moveToTheDate(startDate, endDate);
		}
	}
}