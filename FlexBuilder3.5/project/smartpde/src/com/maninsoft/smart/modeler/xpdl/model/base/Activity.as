////////////////////////////////////////////////////////////////////////////////
//  Activity.as
//  2007.12.20, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model.base
{
	import com.maninsoft.smart.modeler.common.ArrayUtils;
	import com.maninsoft.smart.modeler.common.XsdUtils;
	import com.maninsoft.smart.modeler.mapper.IMappingItem;
	import com.maninsoft.smart.modeler.mapper.IMappingLink;
	import com.maninsoft.smart.modeler.mapper.IMappingSource;
	import com.maninsoft.smart.modeler.model.DiagramObject;
	import com.maninsoft.smart.modeler.xpdl.model.SubFlow;
	import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
	import com.maninsoft.smart.modeler.xpdl.model.TaskService;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.model.pool.Lane;
	import com.maninsoft.smart.modeler.xpdl.model.process.Assignment;
	import com.maninsoft.smart.modeler.xpdl.model.process.DataField;
	import com.maninsoft.smart.modeler.xpdl.model.process.TransitionRestriction;
	import com.maninsoft.smart.modeler.xpdl.property.MultiInstanceBehaviorPropertyInfo;
	import com.maninsoft.smart.modeler.xpdl.syntax.Problem;
	import com.maninsoft.smart.workbench.common.property.BooleanPropertyInfo;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * XPDL Activity
	 */
	public class Activity extends XPDLNode {
		
		//----------------------------------------------------------------------
		// Property consts
		//----------------------------------------------------------------------
		
		public static const PROP_ACTIVITYTYPE	: String = "prop.activityType";
		public static const PROP_LANEID			: String = "prop.laneId";
		public static const PROP_STARTACTIVITY	: String = "prop.startActivity";
		public static const PROP_PERFORMER		: String = "prop.performer";
		public static const PROP_STATUS			: String = "prop.status";
		public static const PROP_PROBLEM  		: String = "prop.problem";
		public static const PROP_MULTI_INSTANCE 	: String = "prop.multiInstance";
		public static const PROP_MAX_INSTANCES		: String = "prop.maxInstances";
		public static const PROP_MULTI_INSTANCE_BEHAVIOR : String = "prop.multiInstanceBehavior";


		//----------------------------------------------------------------------
		// Clsss consts
		//----------------------------------------------------------------------
		
		//------------------------------
		// status
		//------------------------------
		
		public static const STATUS_NONE     	: String = "NONE";
		public static const STATUS_CREATED  	: String = "CREATED";
		public static const STATUS_READY    	: String = "READY";
		public static const STATUS_PROCESSING	: String = "PROCESSING";
		public static const STATUS_COMPLETED	: String = "COMPLETED";
		public static const STATUS_SUSPENDED	: String = "SUSPENDED";
		public static const STATUS_RETURNED		: String = "RETURNED";
		public static const STATUS_DELAYED		: String = "DELAYED";
		
		//------------------------------
		// Multi-Instance Behaviors
		//------------------------------
		public static const BEHAVIOR_ALL			: String = "All";
		public static const BEHAVIOR_NONE			: String = "None";
		public static const BEHAVIOR_ONE			: String = "One";

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/**
		 * Construtor 
		 */
		public function Activity() {
			super();
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * 사용자가 구분할 수 있는 Activity의 타입
		 */
		public function get activityType(): String {
			return ActivityTypes.ACTIVITY;	
		}
		
		/**
		 * XPDL LaneId
		 */
		private var _lane: Lane;

		public function get lane(): Lane {
			return _lane;
		}
		
		public function set lane(value: Lane): void {
			if (value != _lane) {
				var oldValue: Lane = _lane;
				_lane = value;
				fireChangeEvent(PROP_LANEID, oldValue);
			}
		}
		
		public function get laneId(): int {
			return _lane ? _lane.id : -1;
		}
		
		/**
		 * XPDL Performers
		 * WorkflowProcess 에 있는 Participant들 중 이 액티비티 참여자를 나타낸다.
		 * 우선 Participant 객체 참조 대신 Participant id 들의 컬렉션으로 유지한다.
		 */ 
		private var _performers: Array;

		public function get performers(): Array {
			return _performers;
		}
		
		public function set performers(value: Array): void {
			_performers = value;
		}
		
		/**
		 * performer를 하나로 생각할 때 사용한다.
		 */
		public function get performer(): String {
			return (_performers && _performers.length > 0) ? _performers[0] : ""; 
		}
		
		public function set performer(value: String): void {
			var old: String = performer;
			
			//if (value != old) {
				_performers = [value];
				fireChangeEvent(PROP_PERFORMER, old);
			//}
		}
		
		private var _performerName: String;

		public function get performerName(): String {
			return _performerName ? _performerName : performer;
		}
		
		public function set performerName(value: String): void {
			_performerName = value;
		}
		
		/**
		 * XPDL DataFields
		 */
		private var _dataFields: Array;

		public function get dataFields(): Array {
			return _dataFields;
		}
		
		public function set dataFields(value: Array): void {
			_dataFields = value;
			validateAssignments();
		}
		
		/**
		 * XPDL Assignments
		 */
		private var _assignments: Array;
		
		public function get assignments(): Array {
			//validateAssignments();
			return _assignments;
		}
		
		/**
		 * XPDL TransitionRefs
		 */
		private var _transitionRestrictions: Array;

		public function get transitionRestrictions(): Array {
			return _transitionRestrictions;
		}
		
		/**
		 * startActivity
		 */
		private var _startActivity: Boolean;

		public function get startActivity(): Boolean {
			return _startActivity;
		}
		
		public function set startActivity(value: Boolean): void {
			if (value != _startActivity) {
				_startActivity = value;
				fireChangeEvent(PROP_STARTACTIVITY, !value);
			}
		}
		
		/**
		 * status
		 */
		private var _status: String = STATUS_NONE;
		
		public function get status(): String {
			return _status ? _status : STATUS_NONE;
		}
		
		public function set status(value: String): void {
			if (value != _status) {
				var oldValue: String = _status;
				_status = value;
				fireChangeEvent(PROP_STATUS, null);
			}
		}
		
		/**
		 * interestStatus
		 */
		private var _interestStatus: Boolean = false;
		
		public function get interestStatus(): Boolean {
			return _interestStatus ? _interestStatus : false;
		}
		
		public function set interestStatus(value: Boolean): void {
			if (value != _interestStatus) {
				_interestStatus = value;
				fireChangeEvent(PROP_STATUS, null);
			}
		}
		

		public  var effectStatus: String = STATUS_NONE;

		/**
		 * problem
		 */
		private var _problem: Problem;
		
		public function get problem(): Problem {
			return _problem;
		}
		
		public function set problem(value: Problem): void {
			if (value != _problem) {
				var oldValue: Problem = _problem;
				_problem = value;
				fireChangeEvent(PROP_PROBLEM, oldValue);
			}
		}
		
		public function get nodeIndex(): int{
			var acts: Array = XPDLDiagram(diagram).activities;
			for(var i: int = 0; i < acts.length; i++){
				if(acts[i] == this)
					return i;
			}
			return -1;
		}		
		private var _isMultiInstance:Boolean = false;
		public function get isMultiInstance():Boolean{
			return _isMultiInstance;
		}
		public function set isMultiInstance(value:Boolean):void{
			_isMultiInstance = value;
			fireChangeEvent(PROP_MULTI_INSTANCE, !value);
		}
		
		private var _maxInstances:Number = 1;
		public function get maxInstances():Number{
			return _maxInstances;
		}
		public function set maxInstances(value:Number):void{
			_maxInstances = value;
		}
		
		private var _multiInstanceBehavior:String = BEHAVIOR_NONE;
		public function get multiInstanceBehavior():String{
			return _multiInstanceBehavior;
		}
		public function set multiInstanceBehavior(value:String):void{
			_multiInstanceBehavior = value;
			fireChangeEvent(PROP_MULTI_INSTANCE_BEHAVIOR, !value);
		}
		
		private var _numberOfInstance:Number = -1;
		public function get numberOfInstance():Number{
			return _numberOfInstance;
		}
		public function set numberOfInstance(value:Number):void{
			_numberOfInstance = value;
		}
		
		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		
		/**
		 * 다른 Activity 들로 부터 값들을 가져온다.
		 */
		override public function assign(source: DiagramObject): void {
			super.assign(source);
			initDefaults();
			
			var act: Activity = source as Activity;
			
			this._lane = act._lane;
			
			this.name = act.name;
			this.startActivity = act.startActivity;
			this._assignments = act._assignments;
			this._dataFields = act._dataFields;
			this._performerName = act._performerName;
			this._performers = act._performers;
			this._isMultiInstance = act._isMultiInstance;
			this._maxInstances = act._maxInstances;
			this._multiInstanceBehavior = act._multiInstanceBehavior;
			this._numberOfInstance = act._numberOfInstance;
		}

		/**
		 * 이름으로 DataField를 찾아 리턴한다.
		 */
		public function findDataField(fldName: String): DataField {
			for each (var fld: DataField in _dataFields) {
				if (fld.name == fldName) {
					return fld;
				}
			}
			
			return null;
		}

		/**
		 * 이미 같은 이름의 DataField를 가지고 있는 지 검사한다.
		 */
		public function checkUniqueDataField(fldName: String): Boolean {
			if (_dataFields) {
				for each (var f: DataField in _dataFields)
					if (f.name == fldName)
						return false;
			}
			
			return true;			
		}
		
		/**
		 * lane 기준의 상대 좌표를 기록한다.
		 */
		public function saveLanePos(): void {
			if (lane) {
				var p: Point = pool.getLaneBodyPos(lane.id);
				
				tempData["laneX"] = this.x - p.x;
				tempData["laneY"] = this.y - p.y;
			}
		}
		
		/**
		 * saveLanePos()에 기록된 값으로 lane 기준으로 위치를 재설정한다.
		 */
		public function updateLanePos(): void {
			if (lane) {
				var p: Point = pool.getLaneBodyPos(lane.id);
				position = new Point(tempData["laneX"] + p.x, y = tempData["laneY"] + p.y);
			}
		}

		//----------------------------------------------------------------------
		// IXPDLElement
		//----------------------------------------------------------------------
		
		override protected function doRead(src: XML): void {
			super.doRead(src);
			
			var xml: XML;
			
			/*
			 * performers
			 */
			_performers = [];
			
			for each (xml in src._ns::Performers._ns::Performer) {
				_performers.push(xml);	
			}

			/*
			 * dataFields
			 */
			_dataFields = [];
			
			for each (xml in src._ns::DataFields._ns::DataField) {
				var fld: DataField = new DataField(this);
				fld.read(xml);
				_dataFields.push(fld);			
			}
			
			/*
			 * assignments
			 */
			_assignments = [];
			
			for each (xml in src._ns::Assignments._ns::Assignment) {
				var assign: Assignment = new Assignment(this);
				assign.read(xml);
				_assignments.push(assign);			
			}
			
			/*
			 * transtionRestrictions
			 */
			_transitionRestrictions = [];
			
			for each (xml in src._ns::TransitionRestrictions._ns::TransitionRestriction) {
				var res: TransitionRestriction = new TransitionRestriction(this);
				res.read(xml);
				_transitionRestrictions.push(res);
			}
			
			/*
			 * Attributes
			 */
			startActivity = XsdUtils.isTrue(src.@StartActivity);
			_status = src.@Status;
			_performerName = src.@PerformerName;
			
			var valueStr:String=src.@IsMultiInstance;
			_isMultiInstance = (valueStr && valueStr=="true") ? true:false;
			
			if(_isMultiInstance == true){
				valueStr = src.@MaxInstances;
				if(valueStr && valueStr != "null") _maxInstances = Number(valueStr); 
				_multiInstanceBehavior = src.@MultiInstanceBehavior;
	
				valueStr = src.@NumberOfInstance;
				if(valueStr && valueStr != "null") _numberOfInstance = Number(valueStr);
			}

		}

		override protected function doWrite(dst: XML): void {
			var i: int;
			
			/*
			 * performers
			 */
			dst._ns::Performers = "";
			
			if (_performers) {
				for (i = 0; i < _performers.length; i++) {
					dst._ns::Performers._ns::Performer[i] = _performers[i];	
				}
			}
			
			/*
			 * dataFields
			 */
			dst._ns::DataFields = "";
			
			if (_dataFields) {
				for (i = 0; i < _dataFields.length; i++) {
					dst._ns::DataFields._ns::DataField[i] = "";
					DataField(_dataFields[i]).write(dst._ns::DataFields._ns::DataField[i]);
				}
			}

			/*
			 * assignments
			 */
			validateAssignments();
			dst._ns::Assignments = "";
			
			if (_assignments) {
				for (i = 0; i < _assignments.length; i++) {
					dst._ns::Assignments._ns::Assignment[i] = "";
					Assignment(_assignments[i]).write(dst._ns::Assignments._ns::Assignment[i]);
				}
			}
			
			/*
			 * Activity를 계스한 하위 클래스들에서 transitionRestrictions get 속성을 override 한다.
			 */
			// 새로 생성되는 다이어그램의 경우 _transitionRestrictions이 null이다.
			if (!_transitionRestrictions)
				_transitionRestrictions = [];
			 
			_transitionRestrictions = makeTransitionRestrictions(_transitionRestrictions);
			
			if (_transitionRestrictions && _transitionRestrictions.length > 0) {
				dst._ns::TransitionRestrictions = "";
				
				for (i = 0; i < _transitionRestrictions.length; i++) {
					dst._ns::TransitionRestrictions._ns::TransitionRestriction[i] = "";
					TransitionRestriction(_transitionRestrictions[i]).write(dst._ns::TransitionRestrictions._ns::TransitionRestriction[i]);
				}
			}

			/*
			 * Attributes
			 */
			dst.@StartActivity = startActivity;
			dst.@PerformerName = performerName;

			dst.@IsMultiInstance = _isMultiInstance;
			if(_isMultiInstance == true){
				dst.@MaxInstances = _maxInstances;
				dst.@MultiInstanceBehavior = _multiInstanceBehavior;
				dst.@NumberOfInstance = _numberOfInstance;
			}

			super.doWrite(dst);
		}

		override protected function doReadGraphics(src: XML): void {
			super.doReadGraphics(src);
		}
		
		override protected function doWriteGraphics(dst: XML): void {
			super.doWriteGraphics(dst);
			
			if(_lane)
				dst.@LaneId = _lane.id;
		}

		//------------------------------
		// mappingItems
		//------------------------------
		
		/**
		 * 다른 태스크들과 매핑할 수 있는 XPDLMapperItem 컬렉션을 리턴한다.
		 */
		public function get mappingItems(): Array {
			return _dataFields;
		}

		/**
		 * 이 소스로 부터 target 으로 연결된 IMappingLink 들의 컬렉션
		 */
		public function getMappingLinks(source: IMappingSource): Array {
			return ArrayUtils.copy(_assignments);
		}
		
		public function addMappingLink(source: IMappingItem, target: IMappingItem): IMappingLink {
			var assign: Assignment = new Assignment(this);
			assign.connect(source, target);
			
			if (!_assignments) {
				_assignments = [];
			}
			
			_assignments.push(assign);
			return assign;
		}
		
		public function removeMappingLink(link: IMappingLink): void {
			ArrayUtils.removeItem(_assignments, link);
		}
		
		/**
		 * Assignment 의 target과 expression 에 포함된 dataField가 
		 * 존재하는 지 검사. 존재하지 않으면 해당 assignment 제거
		 */
		private function validateAssignments(): void {
			if (!_assignments)
				return;
			
			for (var i: int = _assignments.length - 1; i >= 0; i--) {
				var assign: Assignment = _assignments[i] as Assignment;
				
				if (!assign.isValid()) {
					ArrayUtils.removeItem(_assignments, assign);
				}		
			} 
		}


		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------

		//----------------------------------------------------------------------
		// Overriden properties
		//----------------------------------------------------------------------
		
		override public function get defaultName(): String {
			return "Activity";
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		/**
		 * 프로퍼티 소스가 제공하는 IPropertyInfo 목록
		 */
		override protected function createPropertyInfos(): Array {
			var props: Array = super.createPropertyInfos();

			if(this is TaskApplication || this is SubFlow)
				if(_isMultiInstance == true){
					return props.concat(
						new BooleanPropertyInfo(PROP_STARTACTIVITY, resourceManager.getString("ProcessEditorETC", "startActivityText"), "", "", false),
						new BooleanPropertyInfo(PROP_MULTI_INSTANCE, resourceManager.getString("ProcessEditorETC", "multiInstanceText"), "", "", false),
						new MultiInstanceBehaviorPropertyInfo(PROP_MULTI_INSTANCE_BEHAVIOR, resourceManager.getString("ProcessEditorETC", "multiInstanceBehaviorText"), "", "", false)
					);					
				}else{
					return props.concat(
						new BooleanPropertyInfo(PROP_STARTACTIVITY, resourceManager.getString("ProcessEditorETC", "startActivityText"), "", "", false),
						new BooleanPropertyInfo(PROP_MULTI_INSTANCE, resourceManager.getString("ProcessEditorETC", "multiInstanceText"), "", "", false)
					);
				}
			return props;
		}
		
		/**
		 * id 에 해당하는 프로퍼티의 현재 값을 리턴
		 */
		override public function getPropertyValue(id: String): Object {
			switch (id) {
				case PROP_ACTIVITYTYPE:
					return activityType;
				
				case PROP_LANEID:
					return laneId;
				
				case PROP_STARTACTIVITY: 
					return startActivity;

				case PROP_MULTI_INSTANCE: 
					return isMultiInstance;

				case PROP_MULTI_INSTANCE_BEHAVIOR: 
					return multiInstanceBehavior;

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
					XPDLDiagram(diagram).changeActivityType(this, value.toString()); 
					return;
				
				case PROP_STARTACTIVITY:
					startActivity = XsdUtils.isTrue(value.toString());
					break;
					
				case PROP_MULTI_INSTANCE:
					isMultiInstance = XsdUtils.isTrue(value.toString());
					break;
					
				case PROP_MULTI_INSTANCE_BEHAVIOR:
					if(value && value != "null")
						multiInstanceBehavior = value.toString();
					break;
					
				default:
					super.setPropertyValue(id, value);
					break;
			}
		}
		
		override public function checkNewPosition(newPos: Point): Boolean {
			if (lane && pool) {
				var newLane: Lane = pool.getLaneAt(newPos.x, newPos.y);
				
				// 반드시 레인에 속해야 한다.
				if (newLane == null)
					return false;
					
				// 레인 밖으로 나가면 안된다.
				var rAct: Rectangle = new Rectangle(newPos.x, newPos.y, width, height);
				var rLane: Rectangle = pool.getLaneBodyRect(newLane.id);
				var padding: Number = xpdlDiagram.lanePadding;
				
				if (rAct.x < rLane.x + padding)
					rAct.x = rLane.x + padding;
				
				if (rAct.x + rAct.width >= rLane.x + rLane.width - padding)
					rAct.x = Math.max(rLane.x + padding, rLane.x + rLane.width - padding - rAct.width);
					
				if (rAct.y < rLane.y + padding)
					rAct.y = rLane.y + padding;
					
				if (rAct.y + rAct.height >= rLane.y + rLane.height - padding)
					rAct.y = Math.max(rLane.y + padding, rLane.y + rLane.height - padding - rAct.height);		
					
				newPos.x = rAct.x;
				newPos.y = rAct.y;
			} 
			
			return true;
		}
		
		/**
		 * 노드이 크기가 위치가 변경되었다.
		 */
		override protected function boundsChanged(): void {
			super.boundsChanged();
			
			if (pool)
				this.lane = pool.getLaneAt(this.x, this.y);	
		}

		override protected function isDiagramProp(prop: String): Boolean {
			return prop != PROP_PROBLEM && super.isDiagramProp(prop);
		}

		
		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------

		protected function makeTransitionRestrictions(restrictions: Array): Array {
			return restrictions;
		}
	}
}