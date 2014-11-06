////////////////////////////////////////////////////////////////////////////////
//  Pool.as
//  2007.12.31, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
//
//  Addio 2007 !! 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model
{
	import com.maninsoft.smart.modeler.common.ArrayCollectionUtils;
	import com.maninsoft.smart.modeler.common.Size;
	import com.maninsoft.smart.modeler.editor.DiagramEditor;
	import com.maninsoft.smart.modeler.model.Link;
	import com.maninsoft.smart.modeler.model.Node;
	import com.maninsoft.smart.modeler.model.utils.NodeUtils;
	import com.maninsoft.smart.modeler.xpdl.XPDLEditor;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLNode;
	import com.maninsoft.smart.modeler.xpdl.model.pool.Lane;
	import com.maninsoft.smart.modeler.xpdl.model.process.FormalParameter;
	import com.maninsoft.smart.modeler.xpdl.model.process.WorkflowProcess;
	import com.maninsoft.smart.modeler.xpdl.model.process.XPDLPackage;
	import com.maninsoft.smart.modeler.xpdl.property.ParameterPropertyInfo;
	import com.maninsoft.smart.modeler.xpdl.server.service.GetSubProcessDiagramService;
	import com.maninsoft.smart.modeler.xpdl.utils.XPDLNodeUtils;
	import com.maninsoft.smart.workbench.common.meta.impl.SWPackage;
	import com.maninsoft.smart.workbench.common.property.TextPropertyInfo;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * XPDL Pool 
	 * 1. loading할 때, lane의 id와 각 Activity의 laneId를 재설정한다.
	 */
	public class Pool extends XPDLNode {
		
		//----------------------------------------------------------------------
		// Class constants
		//----------------------------------------------------------------------
		
		public static const PROP_ORIENTATION: String = "prop.orientation";
		public static const PROP_HEADCOLOR	: String = "prop.headColor";
		
		public static const PROP_ADD_LANE	: String = "prop.addLane";
		public static const PROP_REMOVE_LANE: String = "prop.removeLane";
		public static const PROP_MOVE_LANE	: String = "prop.moveLane";
		public static const PROP_RESIZE_LANE: String = "prop.resizeLane";
		
		public static const PROP_PARAMETERS: String = "prop.formalParameters";

		public static const HORZ_LANES: String = "HORIZONTAL";
		public static const VERT_LANES: String = "VERTICAL";
		
		public static const EMPTY_LANES: Array = [];
		
		public static const INVALID_LANE_ID: int = -1;
		
		public static const DEF_POOL_HEAD_SIZE: Number = 21;
		public static const DEF_LANE_HEAD_SIZE: Number = 21;
		
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _lanes: ArrayCollection = new ArrayCollection();
		private var _headSize: Number = DEF_POOL_HEAD_SIZE;
		private var _laneHeadSize: Number = DEF_LANE_HEAD_SIZE;

		private var _owner: XPDLPackage;


		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Construtor */
		public function Pool(owner: XPDLPackage) {
			super();			
			_owner = owner;
			name = resourceManager.getString("WorkbenchETC", "processNameText");;
		}


		//----------------------------------------------------------------------
		// XPDL Properties
		//----------------------------------------------------------------------
		
		/**
		 * process
		 */
		private var _process: String;

		public function get process(): String {
			return _process;
		}
		
		public function set process(value: String): void {
			_process = value;
		}
		
		/**
		 * orientation
		 */
		private var _orientation: String = VERT_LANES;

		public function get orientation(): String {
			return _orientation;
		}
		
		public function set orientation(value: String): void {
			_orientation = value;
		}
		
		/**
		 * boundaryVisible
		 */
		private var _boundaryVisible: Boolean;

		public function get boundaryVisible(): Boolean {
			return _boundaryVisible;
		}
		
		public function set boundaryVisible(value: Boolean): void {
			_boundaryVisible = value;
		}
		
		/**
		 * headColor
		 */
		private var _headColor: uint = 0xececec;
		
		public function get headColor(): uint {
			return _headColor;
		}
		
		public function set headColor(value: uint): void {
			if (value != _headColor) {
				var oldValue: uint = _headColor;
				_headColor = value;
				fireChangeEvent(PROP_HEADCOLOR, oldValue);
			}
		}


		//----------------------------------------------------------------------
		// IXPDLElement
		//----------------------------------------------------------------------

		override protected function doRead(src: XML): void {
			super.doRead(src);

			orientation 	= src.@Orientation;
			process			= src.@Process;
			boundaryVisible = src.@BoundaryVisible == "true";
		
			/*
			 * read lanes
			 */
			if (_lanes) {
				_lanes.removeAll();
			}
			
			if (src._ns::Lanes._ns::Lane.length() > 0) {
				var id: uint = 0;
				
				for each (var xml: XML in src._ns::Lanes._ns::Lane) {
					var lane: Lane = new Lane(this);
					
					lane.id = id++;
					IXPDLElement(lane).read(xml);
					_lanes.addItem(lane);
				}
			}	
		}
		
		override protected function doWrite(dst: XML): void {
			dst.@Orientation		= orientation;
			dst.@Process			= process;
			dst.@BoundaryVisible	= boundaryVisible;
			
			/*
			 * write lanes
			 */
			dst._ns::Lanes = "";
			
			for (var i: int = 0; i < _lanes.length; i++) {
				dst._ns::Lanes._ns::Lane[i] = "";
				IXPDLElement(_lanes[i]).write(dst._ns::Lanes._ns::Lane[i]);
			}

			super.doWrite(dst);
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * owner
		 */
		public function get owner(): XPDLPackage {
			return _owner;
		}
		
		/**
		 * orientation
		 */
		public function get isVertical(): Boolean {
			return _orientation == VERT_LANES;
		}
		
		public function set isVertical(value: Boolean): void {
			if (value != isVertical) {
				var oldValue: Boolean = isVertical;
				_orientation = value ? VERT_LANES : HORZ_LANES;
				
				for each (var lane: Lane in _lanes)
					lane.isVertical = value;
					
				for each (var node: Node in children)
					node.changeXY();
					
				resize(height, width);
				laneSizeChanged();				
				fireChangeEvent(PROP_ORIENTATION, oldValue);
			}
		}
		
		/**
		 * lanes
		 */
		public function get lanes(): Array {
			return _lanes.toArray();
		}
		
		public function get lanesCollection(): ArrayCollection {
			return _lanes;
		}
		
		/**
		 * laneCount
		 */
		public function get laneCount(): int {
			return _lanes.length;
		}
		
		/**
		 * first lane
		 */
		public function get firstLane(): Lane {
			return (_lanes.length > 0) ? _lanes[0] : null;
		}
		
		/**
		 * last lane
		 */
		public function get lastLane(): Lane {
			return (_lanes.length > 0) ? _lanes[_lanes.length - 1] : null;
		}

		/**
		 * headSize
		 */
		public function get headSize(): Number {
			return _headSize;
		}
		
		public function set headSize(value: Number): void {
			_headSize = value;
		}

		/**
		 * laneHeadSize
		 */
		public function get laneHeadSize(): Number {
			return _laneHeadSize;
		}
		
		public function set laneHeadSize(value: Number): void {
			_laneHeadSize = value;
		}
		
		/**
		 * processName
		 */
		public function get processName(): String {
			return owner && owner.process ? owner.process.name : this.name;
		}
		
		public function set processName(value: String): void {
			if (owner && owner.process)
				owner.process.name = value;
			else
				this.name = value;
		}
		
		public function get formalParameters(): Array{
			return owner.process.formalParameters;
		}
		
		public function set formalParameters(value: Array): void{
			owner.process.formalParameters = value;
		}
		
		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		
		/**
		 * actType 타입의 Activity가 존재하는가?
		 */
		public function hasActivityOf(actType: Class): Boolean {
			for each (var node: Node in children) {
				if (node is actType) {
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * activityType을 갖는 액티비티들을 리턴한다.
		 */
		public function getActivities(actType: Class): Array /* of Activity */ {
			return NodeUtils.getNodesByType(children, actType);
		} 
		

		//------------------------------
		// Lane 관련 
		//------------------------------
		
		public function lane(index: int): Lane {
			return (_lanes.length > index) ? _lanes[index] : null;
		}
		
		public function addLaneAt(lane: Lane, index: int): void {
			if (!lane)	return;
			if (_lanes.contains(lane)) return;
			if (index < 0 || index > laneCount) return;

			if (index < laneCount)
				saveLanePosOfNodes();

			_lanes.addItemAt(lane, index);
			refreshLaneIds();

			if (index < laneCount - 1)
				updateLanePosOfNodes();

			laneSizeChanged();
			fireChangeEvent(PROP_ADD_LANE, lane);
		}
		
		public function addLane(lane: Lane): void {
			addLaneAt(lane, laneCount);
		}

		public function removeLaneAt(index: int): void {
			if (index < 0 || index >= laneCount)
				return;
			
			var lane: Lane = lane(index);

			saveLanePosOfNodes();
			_lanes.removeItemAt(index);
			refreshLaneIds();
			updateLanePosOfNodes();
				
			laneSizeChanged();
			fireChangeEvent(PROP_REMOVE_LANE, lane);
		}
				
		public function removeLane(lane: Lane): void {
			removeLaneAt(_lanes.getItemIndex(lane));
		}

		public function moveLane(lane: Lane, newId: int): void {
			saveLanePosOfNodes();
			
			if (ArrayCollectionUtils.moveItem(_lanes, lane, newId)) {
				refreshLaneIds();
				updateLanePosOfNodes();
				
				fireChangeEvent(PROP_MOVE_LANE, lane);
			}
		}

		private function saveLanePosOfNodes(): void {
			for each (var node: Node in this.children) {
				if (node is Activity)
					Activity(node).saveLanePos();
			}
		}

		private function updateLanePosOfNodes(): void {
			for each (var node: Node in this.children) {
				if (node is Activity)
					Activity(node).updateLanePos();
			}
		}
		
		private function refreshLaneIds(): void {
			for (var i: int = 0; i < laneCount; i++) {
				lane(i).id = i;
			}
		}
		
		/**
		 * lane의 크기를 변경한다.
		 * 현재 activity들의 좌표는 lane 기준이 아니라 pool 기준의 상대 좌표이므로,
		 * 변경되는 lane의 다음 lane들에 포함된 activity들의 위치를 변경해준다.
		 */
		public function resizeLaneBy(lane: Lane, delta: Number): void {
			if (lane == null || delta == 0)
				return;
			
			var v: Number = checkLaneSizeCapacity(lane, delta);
			
			if (v < 0) delta -= v;

			lane.size += delta;
			
			for each (var node: Node in children) {
				if (node is Activity && Activity(node).laneId > lane.id) {
					if (orientation == VERT_LANES) {
						node.x += delta;
					}
					else {
						node.y += delta;
					}
				}
			}
			
			laneSizeChanged();
			fireChangeEvent(PROP_RESIZE_LANE, lane);
		}

		/**
		 * index 번째 lane의 lane body 시작 위치를 리턴한다.
		 */
		public function getLaneBodyPos(index: int): Point {
			var x: Number = 0;
			var y: Number = 0;

			for (var i: int = 0; i < index; i++) {
				if (isVertical)
					x += lane(i).size;
				else
					y += lane(i).size;
			}							
			
			return new Point(x, y);	
		}
		
		public function getLaneBodyRect(index: int): Rectangle {
			var lane: Lane = lane(index);
			
			if (lane) {
				var p: Point = getLaneBodyPos(index);
				
				return isVertical ? new Rectangle(p.x, p.y, lane.size, this.height - headSize - laneHeadSize) : 
								     new Rectangle(p.x, p.y, this.width - headSize - laneHeadSize, lane.size);
			} 
			else
				return null;
		}

		public function getActivitiesInLane(laneId: int): Array /* of Activity */ {
			var acts: Array = [];
			
			for each (var node: Node in children) {
				if (node is Activity && Activity(node).laneId == laneId) {
					acts.push(node as Activity);
				}
			}
			
			return acts;
		}
		
		/**
		 * 노드 좌표 (pool/lane 헤더를 제외한 lane 상대좌표) (x, y)를 포함하는 lane 리턴
		 */
		public function getLaneAt(nodeX: Number, nodeY: Number): Lane {
			var h: Number = 0;
			var p: Number = 0;

			for each (var lane: Lane in _lanes) {
				var r: Rectangle;
				
				if (isVertical) {
					r = new Rectangle(p, h, lane.size, height - headSize - laneHeadSize);
				} 
				else {
					r = new Rectangle(h, p, width - headSize - laneHeadSize, lane.size);
				}
				
				if (r.contains(nodeX, nodeY))
					return lane;
				
				p += lane.size;
			}
			
			return null;
		}

		/**
		 * 주어진 lane 상에서 가장 마지막에 해당하는 액티비티
		 * 1. 같은 레인상의 다른 액티비티로 나가는 출력 연결이 없는 것들 중에서 가장 오른쪽/아래쪽에 있는 액티비티.
		 */ 
		public function getLastActivity(lane: Lane): Activity {
			var acts: Array = getActivitiesInLane(lane.id);
			if (acts.length < 1) return null;

			var act: Activity;
			var lasts: Array = [];
			
			for each (act in acts) {
				if (isLastActivity(act, acts))
					lasts.push(act);
			} 			
			
			if (lasts.length < 1)
				lasts = acts;
			
			var last: Activity = lasts[0] as Activity;
			
			for (var i: int = 1; i < lasts.length; i++) { 
				var n: Activity = lasts[i] as Activity;
			
				if (isVertical) {
					if (n.y > last.y || (n.y == last.y && n.x > last.x))
						last = n; 
				}
				else {
					if (n.x > last.x || (n.x == last.x && n.y > last.y))
						last = n; 
				}
			}
			
			return last;

			function isLastActivity(node: Node, siblings: Array): Boolean {
				var outs: Array = node.outgoingLinks;
				
				if (outs.length < 1)
					return true;
				
				for each (var link: Link in outs)
					if (siblings.indexOf(link.target) >= 0)
						return false;
				
				return false;
			}
		}
		
		/**
		 * lane에 새로 추가될 activity의 center 위치를 계산
		 */
		public function getNextActivityPos(lane: Lane, act: Activity): Point {
			var gap: Number = 100;
			var acts: Array = getActivitiesInLane(lane.id);
			var p: Point = getLaneBodyPos(lane.id);
			
			if (isVertical) {
				p.y += 25;
				p.x += lane.size / 2;
			}
			else {
				p.x += 25;
				p.y += lane.size / 2;
			}
			
			for each (var a: Activity in acts) {
				// EndEvent 다음으로는 놓지 않는다.
				//if (act is EndEvent)
				//	continue;
				
				if (isVertical) {
					if (a.bottom > p.y) {
						p.y = Math.min(a.bottom + gap, height - headSize - laneHeadSize - xpdlDiagram.lanePadding - act.height);
						p.x = a.center.x;
					}
				}
				else {
					if (a.right > p.x) {
						p.x = Math.min(a.right + gap, width - headSize - laneHeadSize - xpdlDiagram.lanePadding - act.width);
						p.y = a.center.y;
					}	
				}
			}
			
			
			// p가 act의 중앙이 되도록	
			if (isVertical) {
				p.y += act.height / 2;
			} 
			else {
				p.x += act.width / 2;
			}

			return p;
		}

		/**
		 * lane이 포함된 액티비티들을 담기에 크기가 모자라면 모자란 크기 값을,
		 * 다 담고도 남으면, 남는 크기를 리턴한다.
		 */
		public function checkLaneSizeCapacity(lane: Lane, inc: Number = 0): Number {
			var delta: Number = 0;
			var r: Rectangle = getLaneBodyRect(lane.id);
			var acts: Array = getActivitiesInLane(lane.id);
			
			if (isVertical)
				r.width += inc;
			else
				r.height += inc;
			
			for each (var act: Activity in acts) {
				if (isVertical && act.right > r.right - xpdlDiagram.lanePadding) {
					delta = Math.max(delta, act.right - r.right + xpdlDiagram.lanePadding + 1);
				}
				else if (!isVertical && act.bottom > r.bottom - xpdlDiagram.lanePadding) {
					delta = Math.max(delta, act.bottom - r.bottom + xpdlDiagram.lanePadding + 1);
				}
			}
			
			return -delta;
		}

		public function getMinimumSize(): Size {
			var sz: Size = new Size(0, 0);
			
			for each (var lane: Lane in lanes) {
				if (isVertical)
					sz.width += lane.size;
				else
					sz.height += lane.size;
			}
			
			for each (var node: Activity in getActivities(Activity)) {
				var v: Number = (node.lane ? laneHeadSize : 0) + xpdlDiagram.lanePadding * 2;
				
				if (isVertical)
					sz.height = Math.max(sz.height, node.bottom + v);
				else
					sz.width = Math.max(sz.width, node.right + v);
			}			

			if (isVertical)
				sz.height += headSize;
			else
				sz.width += headSize;

			
			return sz;
		}

		/**
		 * 시작태스크로 설정 가능한 TaskApplication들을 리턴한다.
		 */
		public function getFirstTasks(): Array {
			var tasks: Array = [];
			
			for each (var task: TaskApplication in getActivities(TaskApplication)) {
				if (task.isFirstTask())
					tasks.push(task);
			}
			
			return tasks;
		}
		
		/**
		 * 시작태스크로 설정 가능한 TaskApplication들 중 위치상 가장 앞선 것을 리턴한다.
		 */
		public function getFirstTask(): TaskApplication {
			var tasks: Array = getFirstTasks();
			
			if (tasks.length > 1) {
				XPDLNodeUtils.sortByLocation(tasks);
			}
			
			return tasks.length > 0 ? tasks[0] as TaskApplication : null;
		}
		

		//----------------------------------------------------------------------
		// Overriden properties
		//----------------------------------------------------------------------
		
		override public function get displayName(): String {
			return resourceManager.getString("WorkbenchETC", "processNameText");
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override protected function createPropertyInfos(): Array {
			return [
				new TextPropertyInfo(PROP_NAME, resourceManager.getString("WorkbenchETC", "nameText"), "", "", false),
				new ParameterPropertyInfo(PROP_PARAMETERS, resourceManager.getString("ProcessEditorETC", "formalParametersText"), "", "", false)			
			];
		}
				
		override public function getPropertyValue(id: String): Object {
			switch (id) {
				case PROP_NAME: 
					return processName;
					
				case PROP_HEADCOLOR:
					return this.headColor;

				case PROP_PARAMETERS:					
					if(formalParameters){
						var paramString:String = "";
						var first:Boolean = true;
						for each (var param: FormalParameter in formalParameters){
							paramString += (first ? "":", ") + param.id;
							first = false;				
						}
						return paramString;
					}
					return null;
					
				default:
					return super.getPropertyValue(id);
			}
		}
		
		override public function setPropertyValue(id: String, value: Object): void {
			switch (id) {
				case PROP_NAME: 
					processName = value.toString();
					break;

				case PROP_HEADCOLOR:
					this.headColor = uint(value);
					break;

				default:
					super.setPropertyValue(id, value);
					break;
			}
		}

		override public function addChild(node: Node): void {
			super.addChild(node);
			
			if (node is Activity) {
				Activity(node).lane = getLaneAt(node.x, node.y);
			}				
		}

		public function createSubProcess(xpdlPackage: XPDLPackage, subFlow: SubFlow): void{
			var subProcess:WorkflowProcess = new WorkflowProcess(xpdlPackage);
			subProcess.id = SWPackage.SUBPROCESS_ID_PREFIX + (new Date()).time.toString(16); 
			subProcess.name = subFlow.name;
			subProcess.parentId = subFlow.id.toString();
			subFlow.subProcess = subProcess;
			if(!subFlow.subProcessInfo)
				subFlow.subProcessId = subProcess.id;
		}

		public function changeSubProcess(editor: DiagramEditor, subFlow: SubFlow): void{
			createSubProcess(XPDLDiagram(subFlow.diagram).xpdlPackage, subFlow);
			if(!subFlow.subProcessInfo) return;
			subFlow.subProcessId = subFlow.subProcessInfo.processId;
			if(XPDLEditor(editor).server){
				XPDLEditor(editor).server.getSubProcessDiagram(subFlow.subProcessId, subFlow.subProcessInfo.version, getSubProcessDiagramResult);
			}else{
				var svcPrc:GetSubProcessDiagramService = new GetSubProcessDiagramService();
				svcPrc.serviceUrl = XPDLEditor(editor).builderServiceUrl;
				svcPrc.compId = XPDLEditor(editor).compId;
				svcPrc.userId = XPDLEditor(editor).userId;
				svcPrc.processId = subFlow.subProcessId;
				svcPrc.version = subFlow.subProcessInfo.version;
				svcPrc.data = svcPrc;			
				svcPrc.resultHandler = getSubProcessDiagramResult;
				svcPrc.send();
				
			}
			function getSubProcessDiagramResult(svc: GetSubProcessDiagramService):void{
				if(!svc.xpdlSource || (subFlow.subProcessInstId && subFlow.subProcessDiagram)) return
				subFlow.subProcessDiagram = svc.diagram;
				if(subFlow.subProcessDiagram.xpdlPackage.process && subFlow.subProcessDiagram.xpdlPackage.process is WorkflowProcess){
					subFlow.subProcessDiagram.xpdlPackage.process.id = subFlow.subProcessId
					subFlow.subProcessDiagram.xpdlPackage.process.parentId = subFlow.id.toString();
					subFlow.subProcess = subFlow.subProcessDiagram.xpdlPackage.process;
				}
			}
		}

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------

		public function laneSizeChanged(): void {
			var sz: Number = 0;
			
			for each (var lane: Lane in lanes) {
				sz += lane.size;
			} 				
			
			if (isVertical) {
				resize(sz, height);
			
			} else {
				resize(width, sz);
			}
		}
	}
}
		