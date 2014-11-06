package com.maninsoft.smart.ganttchart.model
{
	import com.maninsoft.smart.ganttchart.editor.property.DateTimePropertyInfo;
	import com.maninsoft.smart.ganttchart.editor.property.GanttTaskGroupIdPropertyInfo;
	import com.maninsoft.smart.ganttchart.model.process.GanttPackage;
	import com.maninsoft.smart.ganttchart.util.CalendarUtil;
	import com.maninsoft.smart.modeler.model.DiagramObject;
	import com.maninsoft.smart.modeler.model.Node;
	import com.maninsoft.smart.modeler.model.events.NodeChangeEvent;
	import com.maninsoft.smart.modeler.xpdl.model.SubFlow;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.model.process.WorkflowProcess;
	import com.maninsoft.smart.modeler.xpdl.property.ActualParametersPropertyInfo;
	import com.maninsoft.smart.modeler.xpdl.property.SubProcessIdPropertyInfo;
	import com.maninsoft.smart.modeler.xpdl.property.SubFlowViewPropertyInfo;
	import com.maninsoft.smart.workbench.common.property.IPropertyInfo;
	import com.maninsoft.smart.workbench.common.property.MeanTimePropertyInfo;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;


	public class GanttTaskGroup extends SubFlow
	{

		public static const PROP_VIEWBOUNDS			: String = "prop.viewBounds"
		public static const PROP_NODEBOUNDS			: String = "prop.nodeBounds"
		public static const PROP_SOURCEVIEWBOUNDS	: String = "prop.sourceViewBounds"
		public static const PROP_SOURCENODEBOUNDS	: String = "prop.sourceNodeBounds"
		public static const PROP_SUBVIEWBOUNDS		: String = "prop.subViewBounds";
		public static const PROP_SUBNODEBOUNDS		: String = "prop.subNodeBounds";
		
		public static const PROP_TASKGROUP			: String = "prop.taskGroup";
		public static const PROP_PLANFROM			: String = "prop.planFrom";
		public static const PROP_PLANTO				: String = "prop.planTo";
		public static const PROP_NODEINDEX			: String = "prop.nodeIndex";

		public var parentViewBounds: Rectangle;

		private var _ganttBaseDateDiff:Number=0;
		private var _taskGroup: GanttTaskGroup;
		private var _planFrom: Date;
		private var _planTo: Date;
		private var _taskRect:Rectangle = new Rectangle();
		public var  taskNameTextColor:uint = 0x686868;
		
		public function GanttTaskGroup()
		{
			super();
		}

		override public function get activityType(): String {
			return GanttActivityTypes.GANTT_TASKGROUP;	
		}

		override public function get defaultBorderColor():uint{
			return 0xdd7800;
		}
		
		override public function get defaultFillColor():uint{
			return 0xf4bf76;
		}
		
		public function set ganttBaseDateDiff(value:Number):void{
			_ganttBaseDateDiff = value;
		}

		public function get subTaskLeftDateDiff():Number{
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
		
		public function get groupBaseDateDiff():Number{
			return (this.planFrom.time - GanttPackage.GANTTCHART_DUEDATE.time);
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

		public function get taskRect(): Rectangle {
			return _taskRect;
		}
		public function set taskRect(value: Rectangle): void {
			_taskRect = value;
		}
		
		public function get groupRect(): Rectangle{
			var groupHeight: Number;
			if(!this.isTaskGroupViewExpanded){
				groupHeight = taskRect.height;	
			}else{
				groupHeight=GanttChartGrid.CHARTROW_HEIGHT-taskRect.y
							+ subProcess.activities.length*GanttChartGrid.CHARTROW_HEIGHT
							+ expandForSubProcess(subProcess);
				function expandForSubProcess(subProcess:WorkflowProcess):Number{
					var subHeight:Number = 0;
					for(var i:int=0; i<subProcess.activities.length; i++){
						if(subProcess.activities[i] is GanttTaskGroup){
							var taskGroup:GanttTaskGroup = subProcess.activities[i] as GanttTaskGroup;
							if(taskGroup.isTaskGroupViewExpanded){
								subHeight +=(taskGroup.subProcess.activities.length*GanttChartGrid.CHARTROW_HEIGHT 
											+ expandForSubProcess(taskGroup.subProcess));
							}
						}
					}
					return subHeight;
				}
			}
			return(new Rectangle(taskRect.x, taskRect.y, taskRect.width, groupHeight));
		}

		public function get isTaskGroupViewExpanded(): Boolean{
			return (this.subFlowView == VIEW_EXPANDED);
		}
		
		public function get isTaskGroupNodeEditable():Boolean{
			return ((subProcess && !subProcessInfo) || (GanttChartGrid.DEPLOY_MODE && !GanttChartGrid.readOnly));
		}
		
		public function get isTaskGroupNodeDeletable():Boolean{
			return !((subProcess && subProcessInfo) || GanttChartGrid.readOnly);
		}
		
		public function get isNodeDeletable():Boolean{
			return true; //!(GanttChartGrid.DEPLOY_MODE);			
		}
		
		public function get numSubNode():int{
			if(isTaskGroupViewExpanded) return (subProcess.activities.length+getNumSubNode());
			return 0;
			function getNumSubNode():int{
				var numSub:int=0;
				for(var i:int=0; i<subProcess.activities.length; i++){
					if(subProcess.activities[i] is GanttTaskGroup){
						numSub += GanttTaskGroup(subProcess.activities[i]).numSubNode;
					}
				}
				return numSub;
			}
		}
		
		//----------------------------------------------------------------------
		// IXPDLElement
		//----------------------------------------------------------------------

		override public function get bounds(): Rectangle {
			return new Rectangle(taskRect.x, y+taskRect.y, taskRect.width, taskRect.height/2);
		}
		
		
		override protected function doRead(src: XML): void {
			var xml: XML = src._ns::Implementation._ns::SubFlow[0];

			_planFrom 	= CalendarUtil.getTaskDate(xml.@PlanFrom);
			if(_planFrom) _planFrom.time += _ganttBaseDateDiff;
			_planTo 	= CalendarUtil.getTaskDate(xml.@PlanTo);
			if(_planTo) _planTo.time += _ganttBaseDateDiff;
			
			super.doRead(src);
		}

		override protected function doWrite(dst: XML): void {
			super.doWrite(dst);
			var xml: XML = dst._ns::Implementation._ns::SubFlow[0];
			
			xml.@PlanFrom 	= CalendarUtil.getTaskString(_planFrom);
			xml.@PlanTo 	= CalendarUtil.getTaskString(_planTo);
		}


		//----------------------------------------------------------------------
		// Overriden properties
		//----------------------------------------------------------------------


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function assign(source: DiagramObject): void {
			super.assign(source);
			
			if(source is GanttTaskGroup){
				var tmpTaskGroup:GanttTaskGroup = source as GanttTaskGroup;
				this._taskGroup 	= tmpTaskGroup._taskGroup;
				this._planFrom 		= tmpTaskGroup._planFrom;
				this._planTo 		= tmpTaskGroup._planTo;
			}else if(source is GanttTask){
				var tmpTask: GanttTask = source as GanttTask;
				this._taskGroup 	= tmpTask.taskGroup;
				this._planFrom 		= tmpTask.planFrom;
				this._planTo 		= tmpTask.planTo;				
			}else if(source is GanttMilestone){
				var tmpMilestone: GanttMilestone = source as GanttMilestone;
				this._taskGroup 	= tmpMilestone.taskGroup;
				this._planFrom 		= tmpMilestone.planDate;
				this._planTo 		= tmpMilestone.planDate;								
			}
		}

		/**
		 * 프로퍼티 소스가 제공하는 IPropertyInfo 목록
		 */
		override protected function createPropertyInfos(): Array {
			var props: Array = super.createPropertyInfos();
		
			for(var index:int=0; index<props.length; index++){
				if(IPropertyInfo(props[index]).id == Activity.PROP_STARTACTIVITY){
					props[index] == null;
					props.splice(index,1);
					break;
				}
			}
			for(index=0; index<props.length; index++){
				if(props[index] is SubProcessIdPropertyInfo){
					props[index] = new GanttTaskGroupIdPropertyInfo(PROP_SUBPROCESS_ID, resourceManager.getString("GanttChartETC", "taskGroupIdText"), "", "", false);
					break;
				}
			}
			
			for(index=0; index<props.length; index++){
				if(props[index] is ActualParametersPropertyInfo){
					props[index] = null;
					props.splice(index,1);
					break;
				}
			}

			for(index=0; index<props.length; index++){
				if(IPropertyInfo(props[index]).id == SubFlow.PROP_EXECUTION){
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
				new SubFlowViewPropertyInfo(SubFlow.PROP_VIEW, resourceManager.getString("GanttChartETC", "taskGroupViewText"), null, null, false),
				new DateTimePropertyInfo(PROP_PLANFROM, resourceManager.getString("GanttChartETC", "planFromTimeText"), null, null, false),
				new DateTimePropertyInfo(PROP_PLANTO, resourceManager.getString("GanttChartETC", "planToTimeText"), null, null, false)
			);
		}
		
		/**
		 * id 에 해당하는 프로퍼티의 현재 값을 리턴
		 */
		override public function getPropertyValue(id: String): Object {
			switch (id) {
				case PROP_TASKGROUP:
					return taskGroup;

				case PROP_PLANFROM: 
					return planFrom;

				case PROP_PLANTO: 
					return planTo;


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
					if(value is GanttTaskGroup) return;
					var ganttChartGrid: GanttChartGrid = XPDLDiagram(diagram).pool as GanttChartGrid;
					ganttChartGrid.changeActivityType(this, value.toString()); 
					break;
				
				case PROP_TASKGROUP: 
					if(_taskGroup == value) return;
					var oldTaskGroup: GanttTaskGroup = _taskGroup;
					_taskGroup = value as GanttTaskGroup;
					this.dispatchEvent(new NodeChangeEvent(this,GanttTaskGroup.PROP_TASKGROUP, oldTaskGroup));
					break;

				case PROP_PLANFROM:
					var newPlanFrom: Date = value as Date;
					if((!planFrom && !newPlanFrom) || (planFrom && newPlanFrom && planFrom.time == newPlanFrom.time)) return;
					if(newPlanFrom.time + GanttChartGrid.MINIMUM_TASK_TIMEOFFSET > planTo.time)
						planFrom.time = planTo.time - GanttChartGrid.MINIMUM_TASK_TIMEOFFSET;
					else
						planFrom.time = (value as Date).time;
					this.dispatchEvent(new NodeChangeEvent(this,GanttTaskGroup.PROP_PLANFROM));
					break;
					
				case PROP_PLANTO: 
					var newPlanTo: Date = value as Date;
					if((!planTo && !newPlanTo) || (planTo && newPlanTo && planTo.time == newPlanTo.time)) return;
					if(planFrom.time + GanttChartGrid.MINIMUM_TASK_TIMEOFFSET > newPlanTo.time)
						planTo.time = planFrom.time + GanttChartGrid.MINIMUM_TASK_TIMEOFFSET;
					else
						planTo.time = (value as Date).time;
					this.dispatchEvent(new NodeChangeEvent(this,GanttTaskGroup.PROP_PLANTO));
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