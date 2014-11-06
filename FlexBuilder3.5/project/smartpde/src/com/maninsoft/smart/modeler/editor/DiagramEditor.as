////////////////////////////////////////////////////////////////////////////////
//  DiagramEditor.as
//  2007.12.13, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.editor
{
	import com.maninsoft.smart.modeler.assets.smartpdeCSS;
	import com.maninsoft.smart.modeler.command.Command;
	import com.maninsoft.smart.modeler.command.CommandStack;
	import com.maninsoft.smart.modeler.command.GroupCommand;
	import com.maninsoft.smart.modeler.command.LinkDeleteCommand;
	import com.maninsoft.smart.modeler.command.NodeDeleteCommand;
	import com.maninsoft.smart.modeler.command.NodeMoveCommand;
	import com.maninsoft.smart.modeler.controller.Controller;
	import com.maninsoft.smart.modeler.controller.LinkController;
	import com.maninsoft.smart.modeler.controller.RootController;
	import com.maninsoft.smart.modeler.editor.events.DiagramChangeEvent;
	import com.maninsoft.smart.modeler.editor.events.SelectionEvent;
	import com.maninsoft.smart.modeler.editor.helper.AlignmentHelper;
	import com.maninsoft.smart.modeler.editor.helper.DragDropHelper;
	import com.maninsoft.smart.modeler.editor.impl.ControllerFactory;
	import com.maninsoft.smart.modeler.editor.impl.LinkFactory;
	import com.maninsoft.smart.modeler.editor.impl.NodeFactory;
	import com.maninsoft.smart.modeler.editor.tool.ConnectionTool;
	import com.maninsoft.smart.modeler.editor.tool.CreationTool;
	import com.maninsoft.smart.modeler.editor.tool.HandGripTool;
	import com.maninsoft.smart.modeler.editor.tool.SelectionTool;
	import com.maninsoft.smart.modeler.model.Diagram;
	import com.maninsoft.smart.modeler.model.DiagramObject;
	import com.maninsoft.smart.modeler.model.Link;
	import com.maninsoft.smart.modeler.model.Node;
	import com.maninsoft.smart.modeler.request.Request;
	import com.maninsoft.smart.modeler.view.IView;
	import com.maninsoft.smart.modeler.view.LinkView;
	import com.maninsoft.smart.modeler.view.connection.IConnectionRouter;
	import com.maninsoft.smart.modeler.view.connection.ManhattanConnectionRouter;
	import com.maninsoft.smart.modeler.xpdl.XPDLEditor;
	import com.maninsoft.smart.modeler.xpdl.tool.XPDLSelectionTool;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import mx.controls.scrollClasses.ScrollBar;
	import mx.core.ScrollControlBase;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	import mx.events.ScrollEvent;
	import mx.events.ScrollEventDirection;
	import mx.managers.IFocusManagerComponent;
		
	/**
	 * CreationTool에 의해 노드 생성 요구가 발생했을 때
	 */
	[Event(name="createNodeRequest", type="com.maninsoft.smart.modeler.editor.events.CreateNodeRequestEvent")]
	/**
	 * 선택 요소가 변경되었을 때
	 */
	[Event(name="selectionChanged", type="com.maninsoft.smart.modeler.editor.events.SelectionEvent")]
	/**
	 * Tool이 초기화 되었을 때
	 */
	[Event(name="toolInitialized", type="flash.events.Event")]
	/**
	 * 다이어그램이 변경 되었을 때
	 */
	[Event(name="diagramNodeAdded", type="com.maninsoft.smart.modeler.editor.events.DiagramChangeEvent")]
	[Event(name="diagramNodeRemoved", type="com.maninsoft.smart.modeler.editor.events.DiagramChangeEvent")]
	[Event(name="diagramNodeReplaced", type="com.maninsoft.smart.modeler.editor.events.DiagramChangeEvent")]
	[Event(name="diagramLinkAdded", type="com.maninsoft.smart.modeler.editor.events.DiagramChangeEvent")]
	[Event(name="diagramLinkRemoved", type="com.maninsoft.smart.modeler.editor.events.DiagramChangeEvent")]
	[Event(name="diagramPropChanged", type="com.maninsoft.smart.modeler.editor.events.DiagramChangeEvent")]
	[Event(name="diagramSelected", type="com.maninsoft.smart.modeler.editor.events.DiagramChangeEvent")]

	/**
	 * 1. 설정된 다이어그램 모델을 설정된 노테이션 셋으로 표시한다.
	 * 2. 외부 요청에 따라 발생된 편집 command를 실행 시켜 모델의 값을 변경 시키고,
	 *    모델이 변경된 통지를 받아 View를 다시 그린다.
	 */
	public class DiagramEditor	extends ScrollControlBase
		implements IFocusManagerComponent {

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		private var _smartpdeCSS:smartpdeCSS = new smartpdeCSS();
				
		private var _diagram: Diagram;
		private var _nodeFactory: INodeFactory;
		private var _linkFactory: ILinkFactory;
		private var _controllerFactory: IControllerFactory;
		private var _rootController: RootController;
		private var _commands: CommandStack;
		private var _selectionManager: SelectionManager;
		
		private var _zoomLayer: UIComponent;
		private var _primaryLayer: Sprite;
		private var _selectionLayer: Sprite;
		private var _feedbackLayer: Sprite;
		private var _mappingLayer: Sprite;
		
		private var _defaultTool: ITool;
		private var _activeTool: ITool;
		private var _handGripTool: ITool;
		private var _creationTool: CreationTool;
		private var _connectionTool: ITool;
		
		private var _dndHelper: DragDropHelper;
		
		private var _editConfig: EditConfiguration;
		
		/** Storage for property readOny */
		private var _readOnly: Boolean = false;
		/** Storage for property multiSelectable */
		private var _multiSelectable: Boolean = true;
		/** Storage for property zoom */
		protected var _zoom: Number = 100.0;

		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */		
		public function DiagramEditor() {
			super();

			_nodeFactory = createNodeFactory();
			_linkFactory = createLinkFactory();
			_controllerFactory = createControllerFactory();
			_commands = new CommandStack(this);
			_selectionManager = createSelectionManager();
			_defaultTool = createDefaultTool();
			_handGripTool = new HandGripTool(this);
			_creationTool = new CreationTool(this);
			
			_dndHelper = new DragDropHelper(this);
			
			_editConfig = new EditConfiguration(this);
			
			horizontalScrollPolicy = ScrollPolicy.ON;
			verticalScrollPolicy = ScrollPolicy.ON;
        }
		
		override protected function createChildren(): void {
			super.createChildren();
			
			_zoomLayer = new UIComponent();
			_zoomLayer.setActualSize(10, 10); //updateDisplay될때 pool사이즈를 게산해서 설정함. 10은 의미 없는 작은값이다.
			addChild(_zoomLayer);

			_primaryLayer = new Sprite();
			_zoomLayer.addChild(_primaryLayer);
			
			_selectionLayer = new Sprite();
			_zoomLayer.addChild(_selectionLayer);
			
			_feedbackLayer = new Sprite();
			_zoomLayer.addChild(_feedbackLayer);
			
			_mappingLayer = new Sprite();
			_zoomLayer.addChild(_mappingLayer);
			_zoomLayer.setStyle("borderStyle", "solid");
			_zoomLayer.setStyle("borderColor", 0x000000);
			_zoomLayer.setStyle("borderThickness", 3);
		}

		public function activate(): void {
			if (!_rootController) {
				_rootController = createRootController();
			}

			resetTool();
			addEventHandlers();
		}
		
		public function deactivate(): void {
			removeEventHandlers();			
			_rootController = null;
		}
		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * property diagram
		 */
		public function get diagram(): Diagram {
			return _diagram;
		}
		
		public function set diagram(value: Diagram): void {
			if (!_rootController)
				return;
				
			if (_diagram)
				disconnectDiagram();
				
			if (value)
				connectDiagram(value);
		}
		
		protected function disconnectDiagram(): void {
			clearSelection();
			resetTool();
			
			if (_rootController)
				_rootController.deactivate();
				
			diagramDisconnected();
			_diagram = null;
		}
		
		protected function diagramDisconnected(): void {
			_diagram.removeEventListener(DiagramChangeEvent.NODE_ADDED, doDiagramChanged);
			_diagram.removeEventListener(DiagramChangeEvent.NODE_REMOVED, doDiagramChanged);
			_diagram.removeEventListener(DiagramChangeEvent.NODE_REPLACED, doDiagramChanged);
			_diagram.removeEventListener(DiagramChangeEvent.LINK_ADDED, doDiagramChanged);
			_diagram.removeEventListener(DiagramChangeEvent.LINK_REMOVED, doDiagramChanged);
			_diagram.removeEventListener(DiagramChangeEvent.PROP_CHANGED, doDiagramChanged);

			dispatchEvent(new Event("diagramDisconnected"));
		}
		
		protected function connectDiagram(value: Diagram): void {
			_diagram = value;
		
			// value로 넘어온 노드와 링크들의 컨트롤러와 뷰를 생성시킨다.		
			_rootController.activate();

			invalidateProperties();			
			invalidateSize();
			invalidateDisplayList();
			
			diagramConnected();
		}
		
		protected function diagramConnected(): void {
			_diagram.addEventListener(DiagramChangeEvent.NODE_ADDED, doDiagramChanged);
			_diagram.addEventListener(DiagramChangeEvent.NODE_REMOVED, doDiagramChanged);
			_diagram.addEventListener(DiagramChangeEvent.NODE_REPLACED, doDiagramChanged);
			_diagram.addEventListener(DiagramChangeEvent.LINK_ADDED, doDiagramChanged);
			_diagram.addEventListener(DiagramChangeEvent.LINK_REMOVED, doDiagramChanged);
			_diagram.addEventListener(DiagramChangeEvent.PROP_CHANGED, doDiagramChanged);
			
			dispatchEvent(new Event("diagramConnected"));
		}
		
		public function get rootController(): RootController {
			return _rootController;
		}
		
		public function get editConfig(): EditConfiguration {
			return _editConfig;
		}
		
		public function get mainView(): Sprite {
			return rootController.findByModel(diagram.root.children[0]).view as Sprite;	
		}
		
		public function get primaryLayer():Sprite {
			return _primaryLayer;
		}
		
		public function get zoomLayer():UIComponent {
			return _zoomLayer;
		}
		
		/**
		 * readOnly
		 */
		public function get readOnly(): Boolean {
			return _readOnly;
		}
		
		public function set readOnly(value: Boolean): void {
			_readOnly = value;
		}
		
		/**
		 * 개체들의 복수 선택이 가능한가?
		 */
		public function get multiSelecatble(): Boolean {
			return _multiSelectable;
		}
		
		public function set multiSelectable(value: Boolean): void {
			_multiSelectable = value;
		}

		/**
		 * Active tool
		 */
		public function get activeTool(): ITool {
			return _activeTool;
		}
		
		public function set activeTool(value: ITool): void {
			if (activeTool)
				activeTool.deactivate();
				
			_activeTool = value;
			
			if (activeTool) 
				activeTool.activate();
		}
		
		/**
		 * gripMode
		 */
		public function get gripMode(): Boolean {
			return _activeTool == _handGripTool;
		}
		
		public function set gripMode(value: Boolean): void {
			if (value != gripMode) {
				activeTool = value ? _handGripTool : defaultTool;
			}
		}

		
		/**
		 * contentWidth
		 */
		public function get contentWidth(): Number {
			return _zoomLayer.width;
		}
		
		public function set contentWidth(value: Number): void {
			_zoomLayer.width = value;
		}
		
		/**
		 * contentHeight
		 */
		public function get contentHeight(): Number {
			return _zoomLayer.height;
		}
		
		public function set contentHeight(value: Number): void {
			_zoomLayer.height = value;
		}

		/**
		 * zoom 0 ~ 100
		 */
		public function get zoom(): Number {
			return _zoom;
		}
		
		public function set zoom(value: Number): void {
			if (value != zoom) {
				_zoom = value;
				_zoomLayer.scaleX = _zoom / 100;
				_zoomLayer.scaleY = _zoom / 100;
			}
		}
		
		public function get zoomedX(): Number {
			return _zoomLayer.mouseX;
		}
		
		public function get zoomedY(): Number {
			return _zoomLayer.mouseY;
		}
		
		/**
		 * checkBackward
		 */
		private var _checkBackward: Boolean;
		
		public function get checkBackward(): Boolean {
			return _checkBackward;
		}
		
		public function set checkBackward(value: Boolean): void {
			if (value != _checkBackward) {
				_checkBackward = value;
			}
		}
		

		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		
		public function execute(command: Command): void {
			if (!readOnly && command)
				commands.execute(command);
		}
		
		public function executeRequest(request: Request): void {
			execute(rootController.getCommand(request));
		}
		
		public function select(model: DiagramObject): void {
			var ctrl: Controller = rootController.findByModel(model);
			
			selectionManager.clear();
			
			if (ctrl) {
				selectionManager.add(ctrl);
			}	
		}
		
		public function selectAtMouse(): void {
			var ctrl: Controller = rootController.findController(mouseX, mouseY);
			
			if (ctrl) {
				trace("selectAtMouse(): " + ctrl);
				selectionManager.clear();
				selectionManager.add(ctrl);
			}	
		}
		
		public function resetTool(): void {
			activeTool = defaultTool;
			dispatchEvent(new Event("toolInitialized"));
		}
		
		public function beginConnection(): void {
			activeTool = connectionTool;
		}
		
		public function beginCreation(creationType: String): void {
			_creationTool.creationType = creationType;
			activeTool = _creationTool;
		}
		
		public function findControllerByModel(model: DiagramObject): Controller {
			return rootController.findByModel(model);
		}
		
		public function findControllerByView(view: IView): Controller {
			return rootController.findByView(view);
		}
		
		public function getCurrentConnectionRouter(): IConnectionRouter {
			return new ManhattanConnectionRouter();
		}
		
		public function addView(view: IView): void {
			_primaryLayer.addChild(view.getDisplayObject());
		}
		
		public function removeView(view: IView): void {
			_primaryLayer.removeChild(view.getDisplayObject());
		}
		
		public function getSelectionLayer(): Sprite {
			return _selectionLayer;
		}
		
		public function getFeedbackLayer(): Sprite {
			return _feedbackLayer;
		}
		
		public function getMappingLayer(): Sprite {
			return _mappingLayer;
		}
		
		public function findControllersByRect(rect: Rectangle): Array {
			return rootController.findControllersByRect(rect);
		}
		
		public function clearSelection(): void {
			selectionManager.clear();
		}
		
		public function deleteSelection(): void {
			var links: Array = selectionManager.soleLinks;
			var nodes: Array = selectionManager.nodes;

			clearSelection();

			var cmd: GroupCommand = new GroupCommand();

			// 혼자 선택된 링크들을 삭제한다.
			for each (var link: Link in links) {
				if (canDelete(link))
					cmd.add(new LinkDeleteCommand(link));
			}
			
			// 노드들을 삭제한다.
			for each (var node: Node in nodes) {
				if (canDelete(node))
					cmd.add(new NodeDeleteCommand(node));
			}
			
			execute(cmd);
		}
		
		public function moveSelection(dx: int, dy: int): void {
			var nodes: Array = selectionManager.nodes;
			var cmd: GroupCommand = new GroupCommand();

			for each (var node: Node in nodes) {
				cmd.add(new NodeMoveCommand(node, dx, dy));	
			}	

			selectionManager.moveBy(dx, dy);
			execute(cmd);
			selectionManager.refreshSelection();
		}
		
		public function alignSelection(alignType: String, value: Number = 0): void {
			var cmd: Command = new AlignmentHelper(this).getCommand(alignType, value);
			execute(cmd);
		}

		public function undo(): void {
			clearSelection();
			commands.undo();
		}
		
		public function redo(): void {
			commands.redo();
		}
		
		/**
		 * editor의 자손 개체 child의 상대 좌표 p를 
		 * editor를 기준으로 하는 상대좌표 값으로 변경한다.
		 */
		public function offsetPoint(child: DisplayObject, p: Point): void {
			var parent: DisplayObject = child.parent;
			
			while (parent != this) {
				p.offset(parent.x, parent.y);
				parent = parent.parent;
			}
		}
		
		
		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function createBorder(): void {
			
		}

		/**
		 * updateDisplayList
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number): void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var g: Graphics = this.graphics;
			
			g.clear();
			
			g.lineStyle(1, 0xffffff);
			g.beginFill(0xffffff);
			g.drawRect(0, 0, unscaledWidth, unscaledHeight);
			g.endFill();
			
			this.scrollRect = new Rectangle(0, 0, unscaledWidth, unscaledHeight);
			setScrollBarProperties(contentWidth, this.width, contentHeight, this.height);

			if (horizontalScrollBar) {
				horizontalScrollBar.lineScrollSize = 8;
				horizontalScrollBar.pageScrollSize = Math.min(100, this.width);
				maxHorizontalScrollPosition = contentWidth - this.width;
			}

			if (verticalScrollBar) {
				verticalScrollBar.lineScrollSize = 8;
				verticalScrollBar.pageScrollSize = Math.min(100, this.height);
				maxVerticalScrollPosition = contentHeight - this.height;
			}
		}
		
		override protected function mouseWheelHandler(event: MouseEvent):void {
			//super.mouseWheelHandler(event);
		}
		
		override protected function scrollHandler(event: Event):void {
			super.scrollHandler(event);
			
			trace(event);

			var ev: ScrollEvent = event as ScrollEvent;
			if (!ev) return;
			
			var bar: ScrollBar = ev.target as ScrollBar;
			
			if (ev.direction == ScrollEventDirection.HORIZONTAL) {
				_zoomLayer.x = -bar.scrollPosition;
			}
			else {
				_zoomLayer.y = -bar.scrollPosition;
			}
		}
		
		public function scrollBy(dx: Number, dy: Number): void {
			_zoomLayer.x = _zoomLayer.x + dx;
			_zoomLayer.y = _zoomLayer.y + dy;
		}
		
		public function scrollTo(x: Number, y: Number): void {
			_zoomLayer.x = x;
			_zoomLayer.y = y;
		}
		
		public function get scrollX(): Number {
			return _zoomLayer.x;
		}
		
		public function get scrollY(): Number {
			return _zoomLayer.y;
		}
		
		public function getScrollX(): Number {
			return _zoomLayer.x;
		}
		
		public function getScrollY(): Number {
			return _zoomLayer.y;
		}
		
		public function setScrollX(value:Number): void {
			_zoomLayer.x = value;
		}
		
		public function setScrollY(value:Number): void {
			_zoomLayer.y = value;
		}
		
		//----------------------------------------------------------------------
		// Virtual methods
		//----------------------------------------------------------------------

		protected function createNodeFactory(): INodeFactory {
			return new NodeFactory(this);
		}

		public function createNode(nodeType: String): Node {
			if (nodeFactory)
				return nodeFactory.createNode(nodeType);
			else
				return null;
		}
		
		protected function createLinkFactory(): ILinkFactory {
			return new LinkFactory(this);
		}
		
		public function createLink(linkType: String, source: Node, target: Node, path: String = null, connectType: String = null): Link {
			if (linkFactory)
				return linkFactory.createLink(linkType, source, target, path, connectType);
			else
				return null;
		}

		protected function createControllerFactory(): IControllerFactory {
			return new ControllerFactory(this);
		}

		/**
		 * Root 컨트롤러를 생성한다.
		 * 계승하는 에디터에서 오버라이드해야 한다.
		 */
		protected function createRootController(): RootController {
			return new RootController(this);			
		}
		
		/**
		 * 모델에 대한 컨트롤러를 생성한다.
		 * 오버라이드해야 한다.
		 */
		public function createController(model: DiagramObject): Controller {
			if (controllerFactory)
				return controllerFactory.createController(model);
			else
				return null;
		}

		protected function createDefaultTool(): ITool {
			return new SelectionTool(this);
		}
		
		protected function createConnectionTool(): ITool {
			return new ConnectionTool(this);
		}
		
		protected function createSelectionManager(): SelectionManager {
			return new SelectionManager();
		}
		
		protected function canDelete(obj: DiagramObject): Boolean {
			return true;
		}
		

		//----------------------------------------------------------------------
		// Event handlers
		//----------------------------------------------------------------------
		
		protected function addEventHandlers(): void {
			// mouse
			doubleClickEnabled = true;
			addEventListener(MouseEvent.CLICK, doClick);
			addEventListener(MouseEvent.MOUSE_DOWN, doMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, doMouseUp);
			addEventListener(MouseEvent.MOUSE_MOVE, doMouseMove);
			addEventListener(MouseEvent.MOUSE_OVER, doMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, doMouseOut);
			addEventListener(MouseEvent.DOUBLE_CLICK, doDoubleClick);
			
			// keyboard
			addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			
			//Application.application.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			
			if (selectionManager)
				selectionManager.addEventListener(SelectionEvent.SELECTION_CHANGED, selectionChanged);
		}
		
		protected function removeEventHandlers(): void {
			// mouse
			removeEventListener(MouseEvent.CLICK, doClick);
			removeEventListener(MouseEvent.MOUSE_DOWN, doMouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, doMouseUp);
			removeEventListener(MouseEvent.MOUSE_MOVE, doMouseMove);
			removeEventListener(MouseEvent.MOUSE_OVER, doMouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT, doMouseOut);
			removeEventListener(MouseEvent.DOUBLE_CLICK, doDoubleClick);
			
			// keyboard
			removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			
			//Application.application.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);

			if (selectionManager)
				selectionManager.removeEventListener(SelectionEvent.SELECTION_CHANGED, selectionChanged);
		}

		override protected function keyDownHandler(event: KeyboardEvent): void {
			trace(event);

			if (activeTool) {
				activeTool.keyDown(event);
			} else {
				super.keyDownHandler(event);
			}
		}
		
		override protected function keyUpHandler(event: KeyboardEvent): void {
			trace(event);

			if (activeTool) {
				activeTool.keyUp(event);
			} else {
				super.keyUpHandler(event);
			}
		}
		
		public function ieKeyDownHandler(keyCode: int, ctrlKey: Boolean, altKey: Boolean, shiftKey: Boolean): void {
			trace("ieKeyDownHandler (keyCode: " + keyCode + ")");
			switch (keyCode) {
				case 90:
					if (ctrlKey) {
						this.undo();
					}
					break;
					
				case 89:
					if (ctrlKey) {
						this.redo();
					}
			}
		}
		
		
		protected function doClick(event: MouseEvent): void {
			activeTool.click(event);
		}

		protected function doDoubleClick(event: MouseEvent): void {
			activeTool.doubleClick(event);
		}

		protected function doMouseDown(event: MouseEvent): void {
			//trace(event.target + ": " + event.toString());
			systemManager.stage.focus = this;
			activeTool.mouseDown(event);
			
			if (event.target is IView) {
				var ctrl: Controller = findControllerByView(event.target as IView); 
				var selectedEvent:DiagramChangeEvent = new DiagramChangeEvent("diagramSelected", ctrl.model, "", null);
				selectedEvent.model = ctrl.model;
				dispatchEvent(selectedEvent);
			}
			
		}

		/**
		 * 연결선을 그릴때 풀을 벗어나면 잔상이 남아 있는 문제가 있음.
		 * target이 IView가 아닐때 즉 PoolView를 벗어나면
		 * XPDLEditor영역이 잡히므로 이때 연결선을 해제하는 로직을 작성한다.
		 * modified by sjyoon 2009.02.27
		 */ 
		protected function doMouseMove(event: MouseEvent): void {
			if (event.target is XPDLEditor) {
				if (activeTool is ConnectionTool) {
					var connTool: ConnectionTool = activeTool as ConnectionTool;
					if (connTool.isState(ConnectionTool.STATE_SOURCE_ANCHORED)) {
						connTool.reset();
						beginConnection();
					}
				} else if(activeTool is XPDLSelectionTool){
					activeTool.mouseMove(event);					
				}
			} else{
				activeTool.mouseMove(event);
			}
		}

		protected function doMouseUp(event: MouseEvent): void {
			activeTool.mouseUp(event);
		}

		protected function doMouseOver(event: MouseEvent): void {
			activeTool.mouseOver(event);
		}

		protected function doMouseOut(event: MouseEvent): void {
			activeTool.mouseOut(event);
		}
		
		protected function selectionChanged(event: SelectionEvent): void {
			/*
			 * dispatchEvent(event) 하면 예외, 공부할 것!
			 */
			var ev: SelectionEvent = new SelectionEvent(event.type, event.selection);
			dispatchEvent(ev);
			
		}
		
		//----------------------------------------------------------------------
		// Internal properties
		//----------------------------------------------------------------------
		
		/**
		 * node factory
		 */
		protected function get nodeFactory(): INodeFactory {
			return _nodeFactory;
		}
		
		/**
		 * link factory
		 */
		protected function get linkFactory(): ILinkFactory {
			return _linkFactory;
		}
		
		/**
		 * controller factory
		 */
		protected function get controllerFactory(): IControllerFactory {
			return _controllerFactory;
		}
		
		/**
		 * command stack
		 */
		protected function get commands(): CommandStack {
			return _commands;
		}
		
		/**
		 * selection manager
		 */
		public function get selectionManager(): SelectionManager {
			return _selectionManager;
		}
		
		protected function get defaultTool(): ITool {
			return _defaultTool;
		}
		
		protected function get connectionTool(): ITool {
			if (!_connectionTool)
				_connectionTool = createConnectionTool();
				
			return _connectionTool;
		}


		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------


		//----------------------------------------------------------------------
		// Event handlers
		//----------------------------------------------------------------------
		
		//------------------------------
		// diagram
		//------------------------------

		protected function doDiagramChanged(event:DiagramChangeEvent): void {
			trace("DiagramEditor.doDiagramChanged(" + event.type + ", " + event.prop + ")");
			dispatchEvent(event.clone());
		}

		//----------------------------------------------------------------------
		// Effect methods
		//----------------------------------------------------------------------
		
		private var _linkViews: Array /* of LinkView */;
		private var _currentLinking: int = -1;
		
		public function get linkViews():Array {
			return _linkViews;
		}

		public function playLinkingEffect(sortedNodes: Array, repeatDelay: Number = 20): void {
			_linkViews = [];
			
			for each (var node: Node in sortedNodes) {
				for each (var link: Link in node.sortedOutgoingLinks) {
					var ctrl: LinkController = rootController.findByModel(link) as LinkController;
					
					if (_linkViews.indexOf(ctrl.view) < 0)
						_linkViews.push(ctrl.view);
				}
			}

			for each (var view: LinkView in _linkViews) {
				view.startEffect();
			}
			
			_currentLinking = 0;

			var timer: Timer = new Timer(repeatDelay, 0);
			timer.addEventListener(TimerEvent.TIMER, doLinkingEffectTimer);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, doLinkingEffectTimerComplete);
			timer.start();
		}
		
		private function doLinkingEffectTimer(event: TimerEvent): void {
			if (_currentLinking >= _linkViews.length) {
				Timer(event.target).reset();
			}
			else {
				var view: LinkView = _linkViews[_currentLinking] as LinkView;
				
				if (view.playEffect()) 
					_currentLinking++;
			}
				
			event.updateAfterEvent();
		}
		
		private function doLinkingEffectTimerComplete(event: TimerEvent): void {
			for each (var view: LinkView in _linkViews)
				view.endEffect();
		}
	}
}