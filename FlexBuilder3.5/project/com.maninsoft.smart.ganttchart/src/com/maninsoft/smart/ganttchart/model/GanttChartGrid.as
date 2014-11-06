package com.maninsoft.smart.ganttchart.model
{
	import com.maninsoft.smart.ganttchart.command.GanttNodeCreateCommand;
	import com.maninsoft.smart.ganttchart.command.GanttNodeDeleteCommand;
	import com.maninsoft.smart.ganttchart.model.process.GanttPackage;
	import com.maninsoft.smart.ganttchart.model.process.GanttProcess;
	import com.maninsoft.smart.ganttchart.parser.GanttReader;
	import com.maninsoft.smart.ganttchart.server.WorkCalendar;
	import com.maninsoft.smart.ganttchart.util.CalendarUtil;
	import com.maninsoft.smart.modeler.command.GroupCommand;
	import com.maninsoft.smart.modeler.editor.DiagramEditor;
	import com.maninsoft.smart.modeler.model.Node;
	import com.maninsoft.smart.modeler.model.events.NodeChangeEvent;
	import com.maninsoft.smart.modeler.xpdl.XPDLEditor;
	import com.maninsoft.smart.modeler.xpdl.model.Pool;
	import com.maninsoft.smart.modeler.xpdl.model.SubFlow;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.model.pool.Lane;
	import com.maninsoft.smart.modeler.xpdl.model.process.XPDLPackage;
	import com.maninsoft.smart.modeler.xpdl.server.ProcessInfo;
	import com.maninsoft.smart.modeler.xpdl.server.service.GetSubProcessDiagramService;
	import com.maninsoft.smart.workbench.common.meta.impl.SWPackage;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class GanttChartGrid extends Pool
	{

		/**
		 * 추가된 모델 프라퍼티들
		 * 
		 *  +++++ GraphicsInfo
		 *  	Width
		 *		Height
		 *		BorderColor
		 *		FillColor
		 *		TextColor
		 *		Sshadow
		 *		Gradient
		 *		XCoordinate
		 *		YCoordinate
  		 *  +++++ XPDLNode Model
		 * 		id
		 *		name
		 *  +++++ Pool Model
		 * 		Orientation
		 *		Process
		 *		BoundaryVisible
		 * 
		 * 
		 * 
		 * 
		 */
		public static const PROP_VIEWSCOPE			: String = "prop.viewScope";
		public static const PROP_BUFFERROWS			: String = "prop.bufferRows";
		public static const PROP_PIVOTDATE			: String = "prop.pivotDate";
		public static const PROP_STARTDATE			: String = "prop.startDate";
		public static const PROP_ENDDATE			: String = "prop.endDate";
		public static const PROP_NUMROWS			: String = "prop.numRows";

		/**
		 * 추가된 모델 이벤트들
		 */
		public static const PROP_CHANGE_VIEWCOPE			: String = "prop.changeViewScope";
		public static const PROP_CHANGE_PIVOTDATE			: String = "prop.changePivotDate";
		public static const PROP_CHANGE_STARTDATE			: String = "prop.changeStartDate";
		public static const PROP_CHANGE_ENDDATE				: String = "prop.changeEndDate";
		public static const PROP_CHANGE_NUMROWS				: String = "prop.changeNumRows";
				
		public static const MINIMUM_CHART_HEIGHT:int = CHARTHEADER_HEIGHT*2+CHARTROW_HEIGHT*16;
		public static const CHARTHEADER_HEIGHT:int = 18;
		public static const CHARTROW_HEIGHT:int = 25;
		public static const CHARTNODE_PLANTASK_HEIGHT:int = 14;
		public static const CHARTNODE_EXETASK_HEIGHT:int = 10;
		public static const CHARTMORE_WIDTH:int = 0;
		public static const CHARTMORE_ICON_X:int = 2;
		public static const CHARTMORE_ICON_Y:int = 10;
		public static const CHARTMORE_ICON_WIDTH:int = 3;
		public static const CHARTMORE_ICON_HEIGHT:int = 5;
		public static const CHARTMORE_ICON_SIZE:int = CHARTMORE_ICON_X+CHARTMORE_ICON_WIDTH+2;
		public static const VSCROLLBAR_WIDTH:int = 20;
		public static const DEFAULT_CHARTROW_BUFFER:int = 5;

		public static const VIEWSCOPE_DEFAULT:int = 0;
		public static const VIEWSCOPE_WORKHOURS:int = -1;
		public static const VIEWSCOPE_ONEDAY:int 	= 0;
		public static const VIEWSCOPE_ONEWEEK:int 	= 1;
		public static const VIEWSCOPE_ONEMONTH:int 	= 2;
		public static const VIEWSCOPE_ONEYEAR:int 	= 3;
		public static const VIEWSCOPE_THREEYEARS:int= -1;
		
		public static const VIEWSCOPE_COLUMNS:Array = [ 24, 7,  1,  12];

		public static var DEPLOY_MODE:Boolean = false;
		public static var readOnly:Boolean=false;
		public static var pageSize:int=-1;
		
		public static var MINIMUM_TASK_TIMEOFFSET:Number = 60*60*1000;// 60분
		    		
		private var _owner:GanttPackage;

		private var _workCalendar: WorkCalendar;
		
		private var _viewScope:int;    		
		private var _bufferRows:int;
		private var _chartBaseDate:Date;
		    		
		private var _pivotDate:Date;
		private var _startDate:Date;
		private var _endDate:Date;


		public function GanttChartGrid(owner:GanttPackage)
		{
			_owner = owner;
			super(owner);
			this.
			name = resourceManager.getString("GanttChartETC", "ganttChartText");
			
		}
		
		override protected function initDefaults(): void {

			/**
			 * 풀 모델에서 x와 y를 각각 10으로 설정하여 0으로 재설정함
			 */ 
			_x = 0;
			_y = 0;
			_borderColor = 0xe4e4e4;
			_fillColor = 0xFFFFFF;    		
			
			viewScope = VIEWSCOPE_DEFAULT;
			bufferRows = DEFAULT_CHARTROW_BUFFER;
			chartBaseDate = new Date(GanttPackage.GANTTCHART_DUEDATE.time);
			startDate = new Date(_chartBaseDate.time);
			endDate = new Date(_chartBaseDate.time);
		}

		override public function get x(): Number{
			return _x+CHARTMORE_WIDTH;
		}
		override public function get height():Number{
			return CHARTHEADER_HEIGHT*2+CHARTROW_HEIGHT*(numTasks+bufferRows)+1;			
		}
		
		override public function get width():Number{
			return _width;
		}
		
		public function set width(value: Number):void{
			_width = value;
		}
		
		public function get workCalendar(): WorkCalendar{
			return _workCalendar;
		}
		public function set workCalendar(value: WorkCalendar): void{
			_workCalendar = value;
		}
		
		public function get viewScope(): int{
			return _viewScope;
		}
		public function set viewScope(value: int): void{
			_viewScope = value;
		}
		
		public function get bufferRows(): int{
			if(pageSize>0)
				return (pageSize<=numTasks)? 0:pageSize-numTasks;
			else if(MINIMUM_CHART_HEIGHT>CHARTHEADER_HEIGHT*2+CHARTROW_HEIGHT*(numTasks+_bufferRows))
				return (MINIMUM_CHART_HEIGHT-CHARTHEADER_HEIGHT*2)/CHARTROW_HEIGHT-numTasks;
			else if(GanttChartGrid.readOnly) return 0;
			else return _bufferRows;
		}
		public function set bufferRows(value: int): void{
			_bufferRows = value;
		}
		
		public function get chartBaseDate(): Date{
			return _chartBaseDate;
		}
		public function set chartBaseDate(value: Date): void{
			_chartBaseDate = value;
		}
				
		public function get pivotDate(): Date{
			return _pivotDate;
		}
		public function set pivotDate(value: Date): void{
			_pivotDate = value;
		}
				
		public function get startDate(): Date{
			return _startDate;
		}
		public function set startDate(value: Date): void{
			_startDate = value;
		}
				
		public function get endDate(): Date{
			return _endDate;
		}
		public function set endDate(value: Date): void{
			_endDate = value;
		}
		
		public function get numTasks(): int{
			return XPDLDiagram(diagram).activities.length;
		}
	
		public function get nodeTop(): Number{
			return CHARTHEADER_HEIGHT*2;
		}			

		public function get nodeBottom(): Number{
			return CHARTHEADER_HEIGHT*2+CHARTROW_HEIGHT*numTasks;
		}			
		//----------------------------------------------------------------------
		// IXPDLElement
		//----------------------------------------------------------------------

		override protected function doRead(src: XML): void {
			super.doRead(src);

			var dateString:String; 

			dateString	= src.@ChartBaseDate;
			if(!chartBaseDate && dateString != null && dateString != "")
				chartBaseDate = CalendarUtil.getTaskDate(dateString);
			dateString	= src.@ChartStartDate;
			if(dateString != null && dateString != "")
				startDate = CalendarUtil.getTaskDate(dateString);
		}
		
		override protected function doWrite(dst: XML): void {
			
			dst.@ChartBaseDate	= CalendarUtil.getTaskString(chartBaseDate);
			if(DEPLOY_MODE)
				dst.@ChartStartDate	= CalendarUtil.getTaskString(GanttPackage.GANTTCHART_DUEDATE);

			super.doWrite(dst);
		}
		/**
		 * owner
		 */
		public function get ganttPackage(): GanttPackage {
			return _owner as GanttPackage;
		}
		
		override public function getLaneAt(nodeX: Number, nodeY: Number): Lane {
			for each (var lane: Lane in super.lanes) {
				return lane;
			}			
			return null;
		}
		
		override public function get displayName(): String {
			return resourceManager.getString("GanttChartETC", "ganttChartText");
		}		

		override public function getPropertyValue(id: String): Object {
			switch (id) {

				case PROP_VIEWSCOPE: 
					return viewScope;
					
				case PROP_BUFFERROWS: 
					return bufferRows;
					
				case PROP_PIVOTDATE:
					return pivotDate;
					
				case PROP_STARTDATE:
					return startDate;
					
				case PROP_ENDDATE:
					return endDate;
					
				default:
					return super.getPropertyValue(id);
			}
		}
		
		override public function setPropertyValue(id: String, value: Object): void {
			switch (id) {

				case PROP_VIEWSCOPE: 
					viewScope = value as int;
					break;

				case PROP_BUFFERROWS: 
					bufferRows = value as int;
					break;

				case PROP_PIVOTDATE:
					pivotDate = value as Date;
					break;
					
				case PROP_STARTDATE:
					startDate = value as Date;
					break;
					
				case PROP_ENDDATE:
					endDate = value as Date;
					break;
					
				default:
					super.setPropertyValue(id, value);
					break;
			}
		}
		
        public function getExeTaskRectangle(fromDate: Date, toDate: Date): Rectangle {
			var rect: Rectangle = new Rectangle(0, 0, 0, 0);

			if(fromDate != null){
				
				var exeFrom: Date = fromDate;
				var exeTo: Date;
				if(toDate==null){
					exeTo= fromDate;
				}else {
					exeTo = toDate;
				}
				rect = getTaskRectangle(exeFrom, exeTo);
				rect.y = (CHARTROW_HEIGHT-CHARTNODE_EXETASK_HEIGHT)/2;
				rect.height = CHARTNODE_EXETASK_HEIGHT;
				if( rect.width <0 ) rect.width = 0;;				
			}
			return rect;
        }
		
		public function get chartColumnWidth():Number{
			var w:Number = 0;
			switch (viewScope){
				case VIEWSCOPE_WORKHOURS:
					w = width/workCalendar.getWorkHour(startDate).workTimeInHour;
					break;					
				case VIEWSCOPE_ONEMONTH:
					w = width/CalendarUtil.getDaysInMonth(startDate.getFullYear(),startDate.getMonth()+1); 
					break;					
				case VIEWSCOPE_ONEDAY:
				case VIEWSCOPE_ONEWEEK:
				case VIEWSCOPE_ONEYEAR:
				case VIEWSCOPE_THREEYEARS:
					w = width/VIEWSCOPE_COLUMNS[viewScope];
					break;
			}            
			return w;
		}
        public function getTaskRectangle(fromDate: Date, toDate: Date): Rectangle {
 
			var rect: Rectangle = new Rectangle(0, 0, 0, 0);
			var w: Number = width/VIEWSCOPE_COLUMNS[viewScope];
			var duration: Number, position: Number;

			if(!fromDate || !toDate) return rect;
			
			switch (viewScope){
				case VIEWSCOPE_WORKHOURS:
					w = width/workCalendar.getWorkHour(startDate).workTimeInHour;
					duration = (toDate.time - fromDate.time)/60/60/1000;
   			        position = (fromDate.time - startDate.time)/60/60/1000;
					break;
					
				case VIEWSCOPE_ONEDAY:
					duration = (toDate.time - fromDate.time)/60/60/1000;
   			        position = (fromDate.time - startDate.time)/60/60/1000;
					break;
					
				case VIEWSCOPE_ONEMONTH:
					w = width/CalendarUtil.getDaysInMonth(startDate.getFullYear(),startDate.getMonth()+1); 
		            duration = (toDate.time - fromDate.time)/24/60/60/1000;
   			        position = (fromDate.time - startDate.time)/24/60/60/1000;
					break;
					
				case VIEWSCOPE_ONEWEEK:
		            duration = (toDate.time - fromDate.time)/24/60/60/1000;
   			        position = (fromDate.time - startDate.time)/24/60/60/1000;
					break;
					
				case VIEWSCOPE_ONEYEAR:
		            duration = CalendarUtil.getCntChangeMonth(fromDate, toDate);
   			        position = CalendarUtil.getCntChangeMonth(startDate, fromDate);
					break;
					
				case VIEWSCOPE_THREEYEARS:
		            duration = CalendarUtil.getCntChangeMonth(fromDate, toDate)/3;
   			        position = CalendarUtil.getCntChangeMonth(startDate, fromDate)/3;
					break;
					
			}            
   			rect.x = position*w;
       		rect.y = (CHARTROW_HEIGHT-CHARTNODE_PLANTASK_HEIGHT)/2;
       		rect.width = duration*w;
       		rect.height = CHARTNODE_PLANTASK_HEIGHT;
       		if(rect.width<0) rect.width = 0;
			return rect;
			
       	}
    
        public function getMilestonePoint(date: Date): Point {
			var point: Point = new Point(0,0);
			var h: Number = CHARTROW_HEIGHT, w: Number = width/VIEWSCOPE_COLUMNS[viewScope];
			var position: Number = 0;

			if(!date) return point;
			
			switch (viewScope){
				case VIEWSCOPE_WORKHOURS:
					w = width/workCalendar.getWorkHour(startDate).workTimeInHour; 
   			        position = (date.time - startDate.time)/60/60/1000;
					break;
				case VIEWSCOPE_ONEDAY:
   			        position = (date.time - startDate.time)/60/60/1000;
					break;
				case VIEWSCOPE_ONEMONTH:
					w = width/CalendarUtil.getDaysInMonth(startDate.getFullYear(),startDate.getMonth()+1); 
   			        position = (date.time - startDate.time)/24/60/60/1000;
					break;
				case VIEWSCOPE_ONEWEEK:
   			        position = (date.time - startDate.time)/24/60/60/1000;
					break;
				case VIEWSCOPE_ONEYEAR:
   			        position = CalendarUtil.getCntChangeMonth(startDate, date);
					break;
				case VIEWSCOPE_THREEYEARS:
   			        position = CalendarUtil.getCntChangeMonth(startDate, date)/3;
					break;
			}            
   			point.x = position*w;
       		point.y = CHARTROW_HEIGHT/2-GanttMilestone.MILESTONESYMBOL_HEIGHT/2;
			return point;
       	}

        public function getTaskFromTo(rect: Rectangle): Array {
 
       	    var fromDate:Date = new Date();
			var toDate:Date = new Date();
			var w: Number, position: Number, duration: Number;
			
			if(viewScope == VIEWSCOPE_ONEMONTH)
				w = width/CalendarUtil.getDaysInMonth(startDate.getFullYear(),startDate.getMonth()+1);
			else if(viewScope == VIEWSCOPE_WORKHOURS)
				w = width/workCalendar.getWorkHour(startDate).workTimeInHour;
			else if(viewScope == VIEWSCOPE_ONEYEAR)
				w = width/365;
			else if(viewScope == VIEWSCOPE_THREEYEARS)
				w = width/365/3;
			else 
				w = width/VIEWSCOPE_COLUMNS[viewScope];
   			position	= rect.x/w;
       		duration	= rect.width/w;

			switch (viewScope){
				case VIEWSCOPE_WORKHOURS:
				case VIEWSCOPE_ONEDAY:
					fromDate.time 	= position*60*60*1000 + startDate.time;
					toDate.time 	= duration*60*60*1000 + fromDate.time;
					break;
					
				case VIEWSCOPE_ONEMONTH:
				case VIEWSCOPE_ONEWEEK:
				case VIEWSCOPE_ONEYEAR:
				case VIEWSCOPE_THREEYEARS:
					fromDate.time 	= position*24*60*60*1000 + startDate.time;
					toDate.time 	= duration*24*60*60*1000 + fromDate.time;
					break;
				
				default:
					fromDate = toDate = null;
					break;
			}            

			return new Array(fromDate, toDate);
       	}

        public function getTaskDate(point: Point): Date {
 
       	    var date:Date = new Date();
			var w: Number, position: Number;
			
			if(viewScope == VIEWSCOPE_ONEMONTH)
				w = width/CalendarUtil.getDaysInMonth(startDate.getFullYear(),startDate.getMonth()+1);
			else if(viewScope == VIEWSCOPE_WORKHOURS)
				w = width/workCalendar.getWorkHour(startDate).workTimeInHour;
			else if(viewScope == VIEWSCOPE_ONEYEAR)
				w = width/365;
			else if(viewScope == VIEWSCOPE_THREEYEARS)
				w = width/365/3;
			else 
				w = width/VIEWSCOPE_COLUMNS[viewScope];
   			position	= point.x/w;

			switch (viewScope){
				case VIEWSCOPE_WORKHOURS:
				case VIEWSCOPE_ONEDAY:
					date.time 	= position*60*60*1000 + startDate.time;
					break;
					
				case VIEWSCOPE_ONEMONTH:
				case VIEWSCOPE_ONEWEEK:
				case VIEWSCOPE_ONEYEAR:
				case VIEWSCOPE_THREEYEARS:
					date.time 	= position*24*60*60*1000 + startDate.time;
					break;
					
				default:
					date = null;
			}            

			return date;
       	}

		public function getNumSubTasks(taskGroup: Array): int{
			var num: int = 0;
			var iTaskGroup: GanttTaskGroup = taskGroup[0] as GanttTaskGroup;
			var iTaskIndex: int = taskGroup[1] as int;

			if(iTaskGroup.subFlowView== SubFlow.VIEW_EXPANDED){				
				while(XPDLDiagram(this.diagram).activities[iTaskIndex+num]!=iTaskGroup.subProcess.activities[iTaskGroup.subProcess.activities.length-1]){
					if(++num==XPDLDiagram(this.diagram).activities.length){
						return 0;
					}
				} 
			}
			return num;
		}
		
		public function canMoveByTargetIndex(myNode: Node, myTaskGroup: GanttTaskGroup, targetIndex: int): Boolean{
			if(!myNode || targetIndex<0 || targetIndex>=XPDLDiagram(myNode.diagram).activities.length) return false;
			var act:Activity = XPDLDiagram(myNode.diagram).activities[targetIndex] as Activity;
			if(act is GanttTask){
				var ganttTask:GanttTask = act as GanttTask;
				if(ganttTask.taskGroup && ganttTask.taskGroup != myTaskGroup) return false;
			}else if(act is GanttTaskGroup){
				var ganttTaskGroup:GanttTaskGroup = act as GanttTaskGroup;
				if(ganttTaskGroup.isTaskGroupViewExpanded && ganttTaskGroup.subProcess.activities.length + ganttTaskGroup.nodeIndex == targetIndex && myNode["nodeIndex"] < targetIndex) return true;
				if(ganttTaskGroup.taskGroup && ganttTaskGroup.taskGroup != myTaskGroup) return false;
				if(ganttTaskGroup.nodeIndex == targetIndex && myNode["nodeIndex"] > targetIndex) return true;
				if(ganttTaskGroup.isTaskGroupViewExpanded && ganttTaskGroup.subProcess.activities.length) return false;
			}else if(act is GanttMilestone){
				var ganttMilestone:GanttMilestone = act as GanttMilestone;
				if(ganttMilestone.taskGroup && ganttMilestone.taskGroup != myTaskGroup) return false;
			}
			return true;
		}
		
		public function findTaskInSubProcess(model: Node): Object{
			var diagram: XPDLDiagram = this.diagram as XPDLDiagram;
			var processes: Array = diagram.xpdlPackage.processes;
			for(var i: int=0; i<processes.length-1; i++)
				for(var index: int=0; index<GanttProcess(processes[i]).activities.length; index++)
					if(GanttProcess(processes[i]).activities[index]==model)
						for each(var ganttTask: Activity in diagram.activities)
							if( ganttTask is GanttTaskGroup)
								if(GanttProcess(processes[i]).id == GanttTaskGroup(ganttTask).subProcess.id)
									return {"taskGroup":ganttTask, "posIndex":index};
			return null;
		}

		public function yToNodeIndex(y: Number): int{
			if(y<nodeTop || y>nodeBottom) return numTasks;
			else return (y-nodeTop)/CHARTROW_HEIGHT;
		}

		public function changeActivityType(activity: Activity, newType: String): void {
			if (activity == null)
				return;
			var dfd: GanttActivityTypes
			if (!GanttActivityTypes.isValidType(newType)) 
				throw new Error(resourceManager.getString("GanttChartMessages", "GCE002") + "(" + newType + ")");
				
			if (activity.activityType == newType)
				return;
				
			var newAct: Activity = null;
			
			switch (newType) {
				case GanttActivityTypes.GANTT_TASK:
					newAct = new GanttTask();
					break;
					
				case GanttActivityTypes.GANTT_TASKGROUP:
					newAct = new GanttTaskGroup();
					GanttTaskGroup(newAct).subProcess = new GanttProcess(owner as GanttPackage);
					GanttTaskGroup(newAct).subProcessInfo = new ProcessInfo();
					GanttTaskGroup(newAct).subProcessInfo.processId = GanttPackage(owner).createSubProcessId();
					
					break;
					
				case GanttActivityTypes.GANTT_MILESTONE:
					newAct = new GanttMilestone();
					break;
			}
								
			newAct.assign(activity);			
			newAct.center = activity.center;
			if(newAct.isPropertySet("planFrom") && newAct.isPropertySet("planTo")){
				if((newAct["planFrom"] as Date).time == (newAct["planTo"] as Date).time)
					(newAct["planTo"] as Date).time += MINIMUM_TASK_TIMEOFFSET;
			}
			this.replaceChild(activity, newAct);
		}
		
		public function changeTaskGroup(editor: DiagramEditor, activity: Activity, oldTaskGroup: GanttTaskGroup, newTaskGroup: GanttTaskGroup): void{
			var oldNodeIndex: int=activity.nodeIndex;
			var newNodeIndex: int = -1;
			var cmd: GroupCommand = new GroupCommand();
			cmd.add(new GanttNodeDeleteCommand(activity, oldNodeIndex));					

			if(oldTaskGroup){
				for(var i: int=0; i<oldTaskGroup.subProcess.activities.length; i++)
					if(oldTaskGroup.subProcess.activities[i]==activity)
						newNodeIndex = oldTaskGroup.isTaskGroupViewExpanded?oldTaskGroup.nodeIndex+oldTaskGroup.subProcess.activities.length:oldTaskGroup.nodeIndex+1
			}
									
			if(newTaskGroup){
				if(newTaskGroup.isTaskGroupViewExpanded){
					newNodeIndex = newTaskGroup.nodeIndex+newTaskGroup.subProcess.activities.length+1;					
					cmd.add(new GanttNodeCreateCommand(this, newNodeIndex, activity));
				}
			}else{
				cmd.add(new GanttNodeCreateCommand(this, newNodeIndex, activity));				
			}
			editor.execute(cmd);

			if(newTaskGroup){
				newTaskGroup.subProcess.activities.splice(newTaskGroup.subProcess.activities.length, 0, activity);
			}
			
			if(newNodeIndex == -1) newNodeIndex = oldNodeIndex;
			var start: int = oldNodeIndex<newNodeIndex?oldNodeIndex:newNodeIndex;
			var end: int = oldNodeIndex>newNodeIndex?oldNodeIndex:newNodeIndex;
			var nodeChangeEvent: NodeChangeEvent;
			var acts: Array = XPDLDiagram(activity.diagram).activities;
			for(var curNodeIndex: int=start; curNodeIndex < end+1; curNodeIndex++)
				Activity(acts[curNodeIndex]).dispatchEvent(new NodeChangeEvent(acts[curNodeIndex],GanttTask.PROP_NODEINDEX));
			
			if(oldTaskGroup)
				oldTaskGroup.dispatchEvent(new NodeChangeEvent(oldTaskGroup,GanttTask.PROP_NODEINDEX));						

			if(newTaskGroup)
				newTaskGroup.dispatchEvent(new NodeChangeEvent(newTaskGroup,GanttTask.PROP_NODEINDEX));						
		}
		
		override public function createSubProcess(xpdlPackage: XPDLPackage, subFlow:SubFlow): void{
			var subProcess:GanttProcess = new GanttProcess(xpdlPackage as GanttPackage);
			subProcess.id = SWPackage.SUBPROCESS_ID_PREFIX + (new Date()).time.toString(16); 
			subProcess.name = subFlow.name;
			subProcess.parentId = subFlow.id.toString();
			subFlow.subProcess = subProcess;
			if(!subFlow.subProcessInfo)
				subFlow.subProcessId = subProcess.id;
		}

		override public function changeSubProcess(editor: DiagramEditor, subFlow: SubFlow): void{
			var taskGroup:GanttTaskGroup = subFlow as GanttTaskGroup;
			if(taskGroup.isTaskGroupViewExpanded) return;
			createSubProcess(XPDLDiagram(taskGroup.diagram).xpdlPackage as GanttPackage, taskGroup);
			if(!taskGroup.subProcessInfo) return;
			taskGroup.subProcessId = taskGroup.subProcessInfo.processId;
			XPDLEditor(editor).server.getSubProcessDiagram(taskGroup.subProcessId, taskGroup.subProcessInfo.version, getSubProcessDiagramResult);
			function getSubProcessDiagramResult(svc: GetSubProcessDiagramService):void{
				if(!svc.xpdlSource) return;
				var newDiagram: XPDLDiagram = new GanttReader(GanttPackage.GANTTCHART_DUEDATE).parse(svc.xpdlSource) as XPDLDiagram;
				if(newDiagram.xpdlPackage.process && newDiagram.xpdlPackage.process is GanttProcess){
					newDiagram.xpdlPackage.process.id = taskGroup.subProcessId
					taskGroup.subProcess = newDiagram.xpdlPackage.process;
					var subDateDiff:Number = getSubTaskLeftDateDiff(newDiagram);
					for each(var activity:Activity in taskGroup.subProcess.activities){
						if(activity is GanttTask){
							var ganttTask:GanttTask = activity as GanttTask;
							ganttTask.taskGroup = taskGroup;
							ganttTask.planFrom.time += taskGroup.groupBaseDateDiff-subDateDiff; 
							ganttTask.planTo.time += taskGroup.groupBaseDateDiff-subDateDiff; 
						}else if(activity is GanttTaskGroup){
							var ganttTaskGroup:GanttTaskGroup = activity as GanttTaskGroup;
							ganttTaskGroup.taskGroup = taskGroup;
							ganttTaskGroup.planFrom.time += taskGroup.groupBaseDateDiff-subDateDiff; 
							ganttTaskGroup.planTo.time += taskGroup.groupBaseDateDiff-subDateDiff;
						}else if(activity is GanttMilestone){
							var ganttMilestone:GanttMilestone = activity as GanttMilestone;
							ganttMilestone.taskGroup = taskGroup;
							ganttMilestone.planDate.time += taskGroup.groupBaseDateDiff-subDateDiff;
						}
					}
				}
			}
		}

		private function getSubTaskLeftDateDiff(subProcessDiagram:XPDLDiagram):Number{
			var leftDate: Date;
			var first: Boolean = true;

			if(!subProcessDiagram) return 0;

			for each(var node: Node in subProcessDiagram.xpdlPackage.process.activities){
				if(first){
					if(node is GanttTask)
						leftDate = GanttTask(node).planFrom;
					else if(node is GanttTaskGroup)
						leftDate = GanttTaskGroup(node).planFrom;
					else if(node is GanttMilestone)
						leftDate = GanttMilestone(node).planDate;
					first=false;
				}else if(leftDate){
					if(node is GanttTask && GanttTask(node).planFrom && GanttTask(node).planTo)
						if(GanttTask(node).planFrom.time<leftDate.time)
							leftDate = GanttTask(node).planFrom;
					else if(node is GanttTaskGroup && GanttTaskGroup(node).planFrom && GanttTaskGroup(node).planTo)
						if(GanttTaskGroup(node).planFrom.time<leftDate.time)
							leftDate = GanttTaskGroup(node).planFrom;
					else if(node is GanttMilestone && GanttMilestone(node).planDate)
						if(GanttMilestone(node).planDate.time<leftDate.time)
							leftDate = GanttMilestone(node).planDate;
				}
			}
			if(!first && leftDate){
				return leftDate.time - GanttPackage.GANTTCHART_DUEDATE.time;
			}else{
				return 0;
			}
		}

		public function isUnderDueDate(x:Number, y:Number):Boolean{
			return getTaskDate(new Point(x, y)).time<GanttPackage.GANTTCHART_DUEDATE.time;
		}

		public function isUnderMinimumTimeOffset(left:Number, right:Number):Boolean{
			return getTaskDate(new Point(right, 0)).time-getTaskDate(new Point(left, 0)).time < MINIMUM_TASK_TIMEOFFSET;
		}
	}
}