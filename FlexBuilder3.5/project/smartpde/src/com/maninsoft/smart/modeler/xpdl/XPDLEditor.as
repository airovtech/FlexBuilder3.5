////////////////////////////////////////////////////////////////////////////////
//  XPDLEditor.as
//  2007.12.14, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl
{
	import com.maninsoft.smart.modeler.command.Command;
	import com.maninsoft.smart.modeler.command.GroupCommand;
	import com.maninsoft.smart.modeler.command.NodeDeleteCommand;
	import com.maninsoft.smart.modeler.command.NodeMoveCommand;
	import com.maninsoft.smart.modeler.editor.DiagramEditor;
	import com.maninsoft.smart.modeler.editor.IControllerFactory;
	import com.maninsoft.smart.modeler.editor.ILinkFactory;
	import com.maninsoft.smart.modeler.editor.INodeFactory;
	import com.maninsoft.smart.modeler.editor.ITool;
	import com.maninsoft.smart.modeler.editor.events.DiagramChangeEvent;
	import com.maninsoft.smart.modeler.model.DiagramObject;
	import com.maninsoft.smart.modeler.model.Link;
	import com.maninsoft.smart.modeler.model.Node;
	import com.maninsoft.smart.modeler.model.utils.DiagramUtils;
	import com.maninsoft.smart.modeler.xpdl.model.Pool;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.model.command.LaneDeleteCommand;
	import com.maninsoft.smart.modeler.xpdl.model.command.LaneResizeCommand;
	import com.maninsoft.smart.modeler.xpdl.model.pool.Lane;
	import com.maninsoft.smart.modeler.xpdl.server.Server;
	import com.maninsoft.smart.modeler.xpdl.tool.LaneSelectionEvent;
	import com.maninsoft.smart.modeler.xpdl.tool.LaneSelectionManager;
	import com.maninsoft.smart.modeler.xpdl.tool.XPDLSelectionTool;
	
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	
	
	/**
	 * Lane 선택 요소가 변경되었을 때
	 */
	[Event(name="laneSelectionChanged", type="com.maninsoft.smart.modeler.xpdl.tool.LaneSelectionEvent")]

	/**
	 * XPDLEditor
	 */
	public class XPDLEditor extends DiagramEditor	{
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		public var serviceUrl: String;
		public var builderServiceUrl: String;
		public var compId: String;
		public var userId: String;
		
		private var _laneSelManager: LaneSelectionManager;

		private var _monitorMode: Boolean;

		private var _loading: Boolean;
		private var _saving: Boolean;
		protected var _running: Boolean;
		
		private var _titleField: TextField;
		private var _title: String = "";
		

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function XPDLEditor() {
			super();

			_laneSelManager = new LaneSelectionManager(this);
			_laneSelManager.addEventListener(LaneSelectionEvent.CHANGED, doLaneSelectionChanged);
		}

		override protected function createChildren(): void {
			super.createChildren();

			_titleField = new TextField();
			_titleField.x = 10;
			_titleField.y = 3;
			addChild(_titleField);
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * server
		 */
		private var _server: Server;
		
		public function get server(): Server {
			return _server;
		}
		
		public function set server(value: Server): void {
			_server = value;
		}
		
		/**
		 * lane selection manager
		 */
		public function get laneSelectionManager(): LaneSelectionManager {
			return _laneSelManager;
		}

		/**
		 * isLoading
		 */
		public function get isLoading(): Boolean {
			return _loading;
		}

		public function get isSaving(): Boolean {
			return _saving;
		}
		
		/**
		 * isRunning
		 */
		public function get isRunning(): Boolean {
			return _running;
		}
		
		/**
		 * title
		 */
		public function get title(): String {
			return _titleField.text;
		}
		
		public function set title(value: String): void {
			_titleField.text = value;
			_titleField.autoSize = TextFieldAutoSize.LEFT;
		}
		
		/**
		 * xpdlDiagram
		 */
		public function get xpdlDiagram(): XPDLDiagram {
			return diagram as XPDLDiagram;
		}

		public function get scrollMargin():Number{
			return Lane.DEF_HEIGHT;
		}
		
		public function get minimumContentHeight():Number{
//			return Lane.DEF_HEIGHT*3;
			return 600;
		}

		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------

		public function beginLoading(): Boolean {
			if (!_loading) {
				_loading = true;
				return true;
			}
			
			return false;
		}
		
		public function endLoading(): Boolean {
			if (_loading) {
				_loading = false;
				return true;
			}
			
			return false;
		}

		public function beginSaving(): Boolean {
			this.server.currentLoadTaskForms();
			this.server.currentLoadTaskFormFields();
			if (!_saving) {
				_saving = true;
				return true;
			}
			
			return false;
		}
		
		public function endSaving(): Boolean {
			if (_saving) {
				_saving = false;
				return true;
			}
			
			return false;
		}

		public function deleteLane(lane: Lane): void {
			if (lane == null || lane.owner == null)
				return;
			
			var nodes: Array = lane.owner.getActivitiesInLane(lane.id);
			
			clearSelection();
			
			var cmd: GroupCommand = new GroupCommand();
			
			for each (var node: Node in nodes) {
				cmd.add(new NodeDeleteCommand(node));
			}
			
			cmd.add(new LaneDeleteCommand(lane));
			
			execute(cmd);
		}
		
		public function selectLane(lane: Lane): void {
			selectionManager.clear();
			laneSelectionManager.clear();
			laneSelectionManager.addLane(lane);			
		}
		
		public function changeOrientation(): void {
			xpdlDiagram.pool.isVertical = !xpdlDiagram.pool.isVertical;
			
			for each (var link: Link in diagram.links) {
				link.changeXY();
			}
			
			invalidateDisplayList();
		}
		
		override public function alignSelection(alignType: String, value: Number=0): void {
			if (alignType == "laneCenter") {
				var nodes: Array = selectionManager.nodes;
				if (nodes.length < 1) return;
				
				var grcmd: GroupCommand = new GroupCommand();
				
				for each (var node: Node in nodes) {
					if (node is Activity) {
						var act: Activity = node as Activity;
						var lane: Lane = act.lane;
						
						if (!lane) continue;
						
						var cmd: Command = null;
						var r: Rectangle = lane.owner.getLaneBodyRect(lane.id);
						
						if (lane.isVertical) {
							cmd = new NodeMoveCommand(act, r.x + r.width / 2 - act.center.x, 0);	
						}
						else {
							cmd = new NodeMoveCommand(act, 0, r.y + r.height / 2 - act.center.y);	
						}
						
						if (cmd)
							grcmd.add(cmd);
					}
				}
				
				execute(grcmd);
				
			}
			else
				super.alignSelection(alignType, value);
		}
		
		/**
		 * 선택된 노테이션들을 자동으로 연결한다.
		 * 1. 링크가 하나도 없는 노드만 처리한다.
		 */
		public function connectSelection(): void {
		}
		

		//----------------------------------------------------------------------
		// Overriden properties
		//----------------------------------------------------------------------

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function diagramConnected(): void {
			super.diagramConnected();

			this.title = "";//XPDLDiagram(value).xpdlPackage.name;

			xpdlDiagram.server = this.server;

			if (checkBackward) {
				DiagramUtils.checkBackwardLinks(xpdlDiagram.pool.children);
				xpdlDiagram.checkBackward = true;
			}
			else {
				xpdlDiagram.checkBackward = false;
			}
		}
		
		override protected function diagramDisconnected(): void {
			super.diagramDisconnected();
		}
		
		override protected function updateDisplayList(unscaledWidth: Number, unscaledHeight: Number): void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			/*
			 * pool 하나로 채운다.
			 */
			if (xpdlDiagram && xpdlDiagram.pool) {
				var pool: Pool = xpdlDiagram.pool;
				
				/*
				* 1. editor영역의 스크롤바 생성 로직
				* editor영역를 전체영역로 보고 editor영역에 포함되는 Pool영역이 있다.
				* 로직은 editor영역과 pool영역의 넓이, 높이를 비교하여 editor영역을 벗어나면 editor영역상의 스크롤바를 생성시킨다.
				* 비교할 속성은 editor의 width, height와 pool에 해당하는 contentWidth, contentHeight이다.
				*
				* 2. 다이어그램 위치 설정
				* 스크롤바가 삭제 될 때 다이어그램의 위치를 재설정한다.
				* 1번의 로직에서 반대로 pool의 크기가 editor보다 작을 때에 해당된다. 
				* 
				* 2008.02.04 sjyoon
				*/

				contentWidth = pool.width + pool.x;
				contentHeight = pool.height + pool.y;
				contentWidth = (contentWidth + scrollMargin > super.width ? contentWidth + scrollMargin : contentWidth) * (_zoom / 100);
				contentHeight = (contentHeight + scrollMargin > super.height ? contentHeight + scrollMargin : contentHeight) * (_zoom / 100);
			}
		}
		
		/**
		 * node factory
		 */
		override protected function createNodeFactory(): INodeFactory {
			return new XPDLNodeFactory(this);
		}
		
		/**
		 * link factory
		 */
		override protected function createLinkFactory(): ILinkFactory {
			return new XPDLLinkFactory(this);
		}
		
		/**
		 * controller factory
		 */
		override protected function createControllerFactory(): IControllerFactory {
			return new XPDLControllerFactory(this);
		}

		override protected function createDefaultTool(): ITool {
			var tool: XPDLSelectionTool = new XPDLSelectionTool(this);
			tool.addEventListener("laneSelectionChanged", doLaneSelectionChanged);
			return tool;
		}
/*		
		override public function select(model: DiagramObject): void {
			laneSelectionManager.clear();
			super.select(model);
		}
*/
		override protected function canDelete(obj:DiagramObject):Boolean {
			return !(obj is Pool);
		}


		//----------------------------------------------------------------------
		// Event handlers
		//----------------------------------------------------------------------

		//------------------------------
		// diagram
		//------------------------------
		
		override protected function doDiagramChanged(event: DiagramChangeEvent): void {
			/**
			 * Activity 위치 변경시 activity가 속한 레인의 크기가 모자라게 되면 키운다.
			 */
			if (event.type == DiagramChangeEvent.PROP_CHANGED &&
			    event.element is Activity && event.prop == Node.PROP_POSITION) {
				var act: Activity = event.element as Activity;
				
				if (act.lane) {
					// lane의 크기가 lane에 속한 액티비티들을 다 담기에 모자라는가/남는가?
					var delta: Number = act.pool.checkLaneSizeCapacity(act.lane);
					
					// 모자라면 키운다.
					if (delta < 0) {
						execute(new LaneResizeCommand(act.lane, -delta));
					}
				}
			}

			super.doDiagramChanged(event);
		}

		//------------------------------
		// laneSelManager
		//------------------------------
		
		private function doLaneSelectionChanged(event: LaneSelectionEvent): void {
			var ev: LaneSelectionEvent = new LaneSelectionEvent(event.type, event.selection);
			dispatchEvent(ev);
		}
		
		override public function deleteSelection(): void {
			var lane:Lane = laneSelectionManager.currentLane;
			if(lane){
				deleteLane(lane);
			}
			super.deleteSelection();
		}
	}
}