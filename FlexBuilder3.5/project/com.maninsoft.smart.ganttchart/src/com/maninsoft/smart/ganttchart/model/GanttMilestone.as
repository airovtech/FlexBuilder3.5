package com.maninsoft.smart.ganttchart.model
{
	import com.maninsoft.smart.ganttchart.editor.property.DateTimePropertyInfo;
	import com.maninsoft.smart.ganttchart.util.CalendarUtil;
	import com.maninsoft.smart.modeler.model.DiagramObject;
	import com.maninsoft.smart.modeler.model.events.NodeChangeEvent;
	import com.maninsoft.smart.modeler.xpdl.model.TaskManual;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.workbench.common.property.IPropertyInfo;
	import com.maninsoft.smart.workbench.common.property.MeanTimePropertyInfo;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class GanttMilestone extends TaskManual
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


		public static const PROP_SOURCEVIEWBOUNDS	: String = "prop.sourceViewBounds"
		public static const PROP_SOURCENODEBOUNDS	: String = "prop.sourceNodeBounds"
		public static const PROP_TASKGROUP			: String = "prop.taskGroup"
		public static const PROP_VIEWBOUNDS			: String = "prop.viewBounds"
		public static const PROP_NODEBOUNDS			: String = "prop.nodeBounds"
		public static const PROP_PLANDATE			: String = "prop.planDate"
		public static const PROP_EXECUTIONDATE		: String = "prop.executionDate"
		public static const PROP_NODEINDEX			: String = "prop.nodeIndex"	
		
		public static const MILESTONESYMBOL_HEIGHT 	: int = 16;
		public static const MILESTONESYMBOL_WIDTH 	: int = 16;
		public static const MILESTONESYMBOL_EXEGAP	: int = 2;

		private var _ganttBaseDateDiff:Number=0;
		private var _taskGroup: GanttTaskGroup;		
		private var _planDate: Date;
		private var _executionDate: Date;
		private var _exeBorderColor: uint;
		private var _exeFillColor: uint;
		private var _planMilestonePoint: Point = new Point(0,0);
		private var _executionMilestonePoint:Point = new Point(0,0);
		public var  taskNameTextColor:uint = 0x993A3A;

		public var parentViewBounds: Rectangle;

		public function GanttMilestone()
		{
			super();
		}
		
		override public function get activityType(): String {
			return GanttActivityTypes.GANTT_MILESTONE;	
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
		
		public function get planDate(): Date{
			return _planDate;
		}

		public function set planDate(value: Date): void{
			_planDate = value;
		}

		public function get executionDate(): Date{
			return _executionDate;
		}
		
		public function set executionDate(value: Date): void{
			_executionDate = value;
		}
		
		public function get planMilestonePoint(): Point{
			return _planMilestonePoint;
		}
		public function set planMilestonePoint(value: Point): void{
			_planMilestonePoint = value;
		}
		
		public function get executionMilestonePoint(): Point{
			return _executionMilestonePoint;
		}
		public function set executionMilestonePoint(value: Point): void{
			_executionMilestonePoint = value;
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

		public function get isNodeDeletable():Boolean{
			return true; // !(GanttChartGrid.DEPLOY_MODE);			
		}
		
		override protected function doRead(src: XML): void {
			var xml: XML = src._ns::Implementation._ns::Task._ns::TaskManual._ns::GanttMilestone[0];

			super.doRead(src);

			planDate 		= CalendarUtil.getTaskDate(xml.@PlanDate);
			if(planDate) planDate.time += _ganttBaseDateDiff;
			executionDate 	= CalendarUtil.getTaskDate(xml.@ExecutionDate);
			if(executionDate) executionDate.time += _ganttBaseDateDiff;
		}

		override protected function doWrite(dst: XML): void {
			dst._ns::Implementation._ns::Task._ns::TaskManual._ns::GanttMilestone = "";
			var xml: XML = dst._ns::Implementation._ns::Task._ns::TaskManual._ns::GanttMilestone[0];

			xml.@PlanDateString	= CalendarUtil.getTaskString(planDate);
			xml.@PlanDateString	= CalendarUtil.getTaskString(executionDate);
			
			super.doWrite(dst);
		}

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function get bounds(): Rectangle {
			return new Rectangle(x-MILESTONESYMBOL_WIDTH/2, y, width, height);
		}
		
		override public function assign(source: DiagramObject): void {
			super.assign(source);
			
			if(source is GanttMilestone){
				var tmpMilestone:GanttMilestone = source as GanttMilestone;
				this._taskGroup 	= tmpMilestone._taskGroup;
				this._planDate 		= tmpMilestone._planDate;
				this._executionDate	= tmpMilestone._executionDate;
			}else if(source is GanttTask){
				var tmpTask: GanttTask = source as GanttTask;
				this._taskGroup 	= tmpTask.taskGroup;
				this._planDate 		= tmpTask.planFrom;
				this._executionDate	= tmpTask.executionFrom;				
			}else if(source is GanttTaskGroup){
				var tmpTaskGroup:GanttTaskGroup = source as GanttTaskGroup;
				this._taskGroup 	= tmpTaskGroup.taskGroup;
				this._planDate 		= tmpTaskGroup.planFrom;
				this._executionDate	= null;
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
			
			return props.concat(
				new DateTimePropertyInfo(PROP_PLANDATE, resourceManager.getString("GanttChartETC", "planDateText"))
			);
		}
		
		/**
		 * id 에 해당하는 프로퍼티의 현재 값을 리턴
		 */
		override public function getPropertyValue(id: String): Object {
			switch (id) {
				case PROP_TASKGROUP:
					return taskGroup;

				case PROP_PLANDATE: 
					return planDate;

				case PROP_EXECUTIONDATE: 
					return executionDate;

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
					if(value is GanttMilestone) return;
					var ganttChartGrid: GanttChartGrid = XPDLDiagram(diagram).pool as GanttChartGrid;
					ganttChartGrid.changeActivityType(this, value.toString()); 
					break;
				
				case PROP_TASKGROUP: 
					if(_taskGroup == value) return;
					var oldTaskGroup: GanttTaskGroup = _taskGroup;
					_taskGroup = value as GanttTaskGroup;
					this.dispatchEvent(new NodeChangeEvent(this,GanttMilestone.PROP_TASKGROUP, oldTaskGroup));
					break;
					
				case PROP_PLANDATE: 
					var newPlanDate: Date = value as Date;
					if((!planDate && !newPlanDate) || (planDate && newPlanDate && planDate.time == newPlanDate.time)) return;
					planDate.time = (value as Date).time;
					this.dispatchEvent(new NodeChangeEvent(this,GanttMilestone.PROP_PLANDATE));
					break;
					
				case PROP_EXECUTIONDATE:
					var newExecutionDate: Date = value as Date;
					if((!executionDate && !newExecutionDate) || (executionDate && newExecutionDate && executionDate.time == newExecutionDate.time)) return; 
					executionDate.time = (value as Date).time;
					this.dispatchEvent(new NodeChangeEvent(this,GanttMilestone.PROP_EXECUTIONDATE));
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