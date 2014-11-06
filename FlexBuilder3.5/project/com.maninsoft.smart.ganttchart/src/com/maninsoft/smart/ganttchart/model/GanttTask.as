package com.maninsoft.smart.ganttchart.model
{
	import com.maninsoft.smart.ganttchart.editor.property.DateTimePropertyInfo;
	import com.maninsoft.smart.ganttchart.editor.property.WorkIdPropertyInfo;
	import com.maninsoft.smart.ganttchart.util.CalendarUtil;
	import com.maninsoft.smart.modeler.model.DiagramObject;
	import com.maninsoft.smart.modeler.model.events.NodeChangeEvent;
	import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.property.ApprovalLinePropertyInfo;
	import com.maninsoft.smart.modeler.xpdl.server.ProcessInfo;
	import com.maninsoft.smart.workbench.common.model.WorkPackage;
	import com.maninsoft.smart.workbench.common.property.IPropertyInfo;
	import com.maninsoft.smart.workbench.common.property.MeanTimePropertyInfo;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class GanttTask extends TaskApplication
	{


		
		/**
		 * 추가된 모델 프라퍼티  
		 * 	+++++ Activity Model
		 * 		ActivityType
		 * 		LandId
		 * 		StartActivity
		 * 		Performer
		 * 		Status
		 * 		Problem
		 *  +++++ TaskApplication Model
		 * 		Id(appId)
		 * 		Name(fomdId)
		 * 		FormName(formName)
		 *		Verstion(formVersion)
		 * 		UserTaskType(userTaskType)
		 * 		ApprovalRequired(approvalRequired)
		 * 
		 */


		public static const PROP_SOURCEVIEWBOUNDS	: String = "prop.sourceViewBounds";
		public static const PROP_SOURCENODEBOUNDS	: String = "prop.sourceNodeBounds";
		public static const PROP_VIEWBOUNDS		: String = "prop.viewBounds";
		public static const PROP_NODEBOUNDS		: String = "prop.nodeBounds";
		public static const PROP_TASKGROUP		: String = "prop.taskGroup";
		public static const PROP_PLANFROM		: String = "prop.planFrom";
		public static const PROP_PLANTO			: String = "prop.planTo";
		public static const PROP_EXECUTIONFROM	: String = "prop.executionFrom";
		public static const PROP_EXECUTIONTO	: String = "prop.executionTo";
		public static const PROP_NODEINDEX		: String = "prop.nodeIndex";
		public static const PROP_WORKID			: String = "prop.workId";

		public static const SYSTEM_WORK_ID		: String = "WorkPackage";	
		
		private var _ganttBaseDateDiff:Number=0;
		
		private var _taskGroup: GanttTaskGroup;

		private var _planFrom: Date;
		private var _planTo: Date;
		private var _executionFrom: Date;
		private var _executionTo: Date;
		private var _planTaskRect:Rectangle = new Rectangle();
		private var _executionTaskRect:Rectangle = new Rectangle();
		private var _nodeWidth:Number =0;
		private var _workInfo:ProcessInfo = null;
		private var _workId:String = "";

		private var _exeBorderColor:uint = 0x66A0E5;
		private var _exeFillColor:uint = 0xE5A066;
		public var  taskNameTextColor:uint = 0x686868;

		public var parentViewBounds: Rectangle;
				
		public function GanttTask()
		{
			super();
		}
						
		override public function get activityType(): String {
			return GanttActivityTypes.GANTT_TASK;	
		}

		public function set ganttBaseDateDiff(value:Number):void{
			_ganttBaseDateDiff = value;
		}
		
		public function get taskGroup(): GanttTaskGroup{
			return _taskGroup;
		}
		public function set taskGroup(value: GanttTaskGroup): void{
			_taskGroup = value;
		}
		
		public function get planFrom(): Date{
			return _planFrom;
		}

		public function set planFrom(value: Date): void{
			_planFrom = value;
		}

		public function get planTo(): Date{
			return _planTo;
		}

		public function set planTo(value: Date): void{
			_planTo = value;
		}

		public function get executionFrom(): Date{
			return _executionFrom;
		}

		public function set executionFrom(value: Date): void{
			_executionFrom = value;
		}

		public function get executionTo(): Date{
			return _executionTo;
		}

		public function set executionTo(value: Date): void{
			_executionTo = value;
		}

		public function get planTaskRect(): Rectangle{
			return _planTaskRect;
		}
		public function set planTaskRect(value: Rectangle): void{
			_planTaskRect = value;
		}
		
		public function get executionTaskRect(): Rectangle{
			return _executionTaskRect;
		}
		public function set executionTaskRect(value: Rectangle): void{
			_executionTaskRect = value;
		}
		
		public function get nodeWidth(): Number{
			return _nodeWidth;
		}
		public function set nodeWidth(value: Number): void{
			_nodeWidth = value;
		}
		
		public function get exeBorderColor(): uint{
			return _exeBorderColor;
		}
		public function set exeBorderColor(value: uint): void{
			_exeBorderColor = value;
		}
		
		public function get exeFillColor(): uint{
			return _exeFillColor;
		}
		public function set exeFillColor(value: uint): void{
			_exeFillColor = value;
		}

		public function get workInfo(): ProcessInfo{
			return _workInfo;
		}
		
		public function set workInfo(value: ProcessInfo): void{
			if(_workInfo == value) return
			var oldValue:ProcessInfo = _workInfo;
			_workInfo = value;
			fireChangeEvent(PROP_WORKID, oldValue);			
		}
		
		public function get workId(): String{
			return _workId;
		}
		
		public function set workId(value: String): void{
			_workId = value;
		}
		
		public function get workName(): String{
			if(workInfo) return workInfo.label;
			return null;
		}
		
		public function get workVersion(): String{
			if(workInfo) return workInfo.version;
			return null;
		}
		
		public function get isNodeDeletable():Boolean{
			return true; //!(GanttChartGrid.DEPLOY_MODE);			
		}
		
		override protected function doRead(src: XML): void {
			var xml: XML = src._ns::Implementation._ns::Task._ns::TaskApplication[0];

			planFrom 		= CalendarUtil.getTaskDate(xml.@PlanFrom);
			if(planFrom) planFrom.time += _ganttBaseDateDiff;
			planTo 			= CalendarUtil.getTaskDate(xml.@PlanTo);
			if(planTo) planTo.time += _ganttBaseDateDiff;
			executionFrom 	= CalendarUtil.getTaskDate(xml.@ExecutionFrom);
			if(executionFrom) executionFrom.time += _ganttBaseDateDiff;
			executionTo 	= CalendarUtil.getTaskDate(xml.@ExecutionTo);
			if(executionTo) executionTo.time += _ganttBaseDateDiff;

			super.doRead(src);
			
			if(this.appId == SYSTEM_WORK_ID){
				_workId = formId;
				if(workId && formVersion){
					var processInfo:ProcessInfo = new ProcessInfo();
					processInfo.packageId = workId;
					processInfo.version = formVersion;
					processInfo.categoryPath = xml.@WorkName;
					_workInfo = processInfo;
				}
				formId = null;
				formVersion = null;
			}
		}

		override protected function doWrite(dst: XML): void {
			super.doWrite(dst);
			var xml: XML = dst._ns::Implementation._ns::Task._ns::TaskApplication[0];

			xml.@PlanFrom 		= CalendarUtil.getTaskString(planFrom);
			xml.@PlanTo 		= CalendarUtil.getTaskString(planTo);
			xml.@ExecutionFrom 	= CalendarUtil.getTaskString(executionFrom);
			xml.@ExecutionTo 	= CalendarUtil.getTaskString(executionTo);
			if(workInfo && workId){
				xml.@Id = SYSTEM_WORK_ID;
				xml.@Name = workId;
				xml.@WorkName = workName;
				xml.@Version = workInfo.version;
			}			
		}

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function assign(source: DiagramObject): void {
			super.assign(source);
			
			if(source is GanttTask){
				var tmpTask:GanttTask = source as GanttTask;
				this._taskGroup 	= tmpTask._taskGroup;
				this._workId 		= tmpTask._workId;
				this._workInfo 		= tmpTask._workInfo;
				this._planFrom 		= tmpTask._planFrom;
				this._planTo 		= tmpTask._planTo;
				this._executionFrom = tmpTask._executionFrom;
				this._executionTo	= tmpTask._executionTo;
			}else if(source is GanttTaskGroup){
				var tmpTaskGroup: GanttTaskGroup = source as GanttTaskGroup;
				this._taskGroup 	= tmpTaskGroup.taskGroup;
				this._planFrom 		= tmpTaskGroup.planFrom;
				this._planTo 		= tmpTaskGroup.planTo;
				this._executionFrom = null;
				this._executionTo 	= null;
			}else if(source is GanttMilestone){
				var tmpMilestone: GanttMilestone = source as GanttMilestone;
				this._taskGroup 	= tmpMilestone.taskGroup;
				this._planFrom 		= tmpMilestone.planDate;
				this._planTo 		= tmpMilestone.planDate;
				this._executionFrom = tmpMilestone.executionDate;
				this._executionTo 	= tmpMilestone.executionDate;
			}
		}

		/**
		 * 프로퍼티 소스가 제공하는 IPropertyInfo 목록
		 */
		override protected function createPropertyInfos(): Array {
			var props: Array = super.createPropertyInfos();
			var index:int;
			for(index=0; index<props.length; index++){
				if(IPropertyInfo(props[index]).id == Activity.PROP_STARTACTIVITY){
					props[index] == null;
					props.splice(index,1);
					break;
				}
			}
			for(index=0; index<props.length; index++){
				if(props[index] is MeanTimePropertyInfo){
					props[index] == null;
					props.splice(index,1);
					break;
				}
			}
			for(index=0; index<props.length; index++){
				if(props[index] is ApprovalLinePropertyInfo){
					props[index] == null;
					props.splice(index,1);
					break;
				}
			}
			return props.concat(
				new WorkIdPropertyInfo(PROP_WORKID, resourceManager.getString("ProcessEditorETC", "workIdText"), null, null, false),
				new ApprovalLinePropertyInfo(PROP_APPROVALLINE, resourceManager.getString("ProcessEditorETC", "approvalLineText"), null, null, false),
				new DateTimePropertyInfo(PROP_PLANFROM, resourceManager.getString("GanttChartETC", "planFromTimeText")),
				new DateTimePropertyInfo(PROP_PLANTO, resourceManager.getString("GanttChartETC", "planToTimeText"))
			);
		}
		
		/**
		 * id 에 해당하는 프로퍼티의 현재 값을 리턴
		 */
		override public function getPropertyValue(id: String): Object {
			switch (id) {
				case PROP_TASKGROUP: 
					return taskGroup;

				case PROP_WORKID:
					return (workName&&workName!="null")?workName:WorkPackage.EMPTY_WORK_NAME;

				case PROP_PLANFROM: 
					return planFrom;

				case PROP_PLANTO: 
					return planTo;

				case PROP_EXECUTIONFROM: 
					return executionFrom;

				case PROP_EXECUTIONTO: 
					return executionTo;

				default:
					return super.getPropertyValue(id);
			}
		}
		
		/**
		 * id 에 해당하는 프로퍼티의 값을 설정
		 */
		override public function setPropertyValue(id: String, value: Object): void {
			switch (id) {
				case PROP_ACTIVITYTYPE:
					if(value is GanttTask) return;
					var ganttChartGrid:GanttChartGrid = XPDLDiagram(diagram).pool as GanttChartGrid;
					ganttChartGrid.changeActivityType(this, value.toString()); 
					break;

				case PROP_TASKGROUP: 
					if(_taskGroup == value) return;
					var oldTaskGroup: GanttTaskGroup = _taskGroup;
					_taskGroup = value as GanttTaskGroup;
					this.dispatchEvent(new NodeChangeEvent(this,GanttTask.PROP_TASKGROUP, oldTaskGroup));
					break;
					
				case PROP_PLANFROM:
					var newPlanFrom: Date = value as Date;
					if((!planFrom && !newPlanFrom) || (planFrom && newPlanFrom && planFrom.time == newPlanFrom.time)) return;
					if(newPlanFrom.time + GanttChartGrid.MINIMUM_TASK_TIMEOFFSET > planTo.time)
						planFrom.time = planTo.time - GanttChartGrid.MINIMUM_TASK_TIMEOFFSET;
					else
						planFrom.time = (value as Date).time;
					this.dispatchEvent(new NodeChangeEvent(this,GanttTask.PROP_PLANFROM));
					break;
					
				case PROP_PLANTO: 
					var newPlanTo: Date = value as Date;
					if((!planTo && !newPlanTo) || (planTo && newPlanTo && planTo.time == newPlanTo.time)) return;
					if(planFrom.time + GanttChartGrid.MINIMUM_TASK_TIMEOFFSET > newPlanTo.time)
						planTo.time = planFrom.time + GanttChartGrid.MINIMUM_TASK_TIMEOFFSET;
					else
						planTo.time = (value as Date).time;
					this.dispatchEvent(new NodeChangeEvent(this,GanttTask.PROP_PLANTO));
					break;
					
				case PROP_EXECUTIONFROM:
					var newExecutionFrom: Date = value as Date;
					if((!executionFrom && !newExecutionFrom) || (executionFrom && newExecutionFrom && executionFrom.time == newExecutionFrom.time)) return;
					executionFrom.time = (value as Date).time;
					this.dispatchEvent(new NodeChangeEvent(this,GanttTask.PROP_EXECUTIONFROM));
					break;
					
				case PROP_EXECUTIONTO:
					var newExecutionTo: Date = value as Date;
					if((!executionTo && !newExecutionTo) || (executionTo && newExecutionTo && executionTo.time == newExecutionTo.time)) return; 
					executionTo.time = (value as Date).time;
					this.dispatchEvent(new NodeChangeEvent(this,GanttTask.PROP_EXECUTIONTO));
					break;
					
				default:
					super.setPropertyValue(id, value);
					break;
			}
		}
		override public function getConnectAnchors(): Array {
			var pts: Array = new Array();
			
			pts.push(90);
			pts.push(270);

			return pts;
		}
		
		override public function checkNewPosition(newPos: Point): Boolean {
			return true;
		}
	}
}