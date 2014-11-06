////////////////////////////////////////////////////////////////////////////////
//  ConnectionTool.as
//  2007.12.24, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.editor.tool
{
	import com.maninsoft.smart.modeler.controller.NodeController;
	import com.maninsoft.smart.modeler.editor.DiagramEditor;
	import com.maninsoft.smart.modeler.editor.handle.ConnectHandle;
	import com.maninsoft.smart.modeler.model.Node;
	import com.maninsoft.smart.modeler.request.LinkCreationRequest;
	import com.maninsoft.smart.modeler.view.NodeView;
	import com.maninsoft.smart.modeler.view.connection.IConnectionRouter;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * 노드 양쪽을 Link로 연결하는 tool
	 */
	public class ConnectionTool extends AbstractTool	{

		//----------------------------------------------------------------------
		// Class constants
		//----------------------------------------------------------------------
		
		public static const STATE_STARTED 		: int = 0;
		public static const STATE_SOURCE_ANCHORED	: int = 1;
		public static const STATE_TARGET_ANCHORED	: int = 2;
		public static const STATE_COMPLETED		: int = 3;
		public static const STATE_CANCELED		: int = 4;


		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _state: int;
		
		private var _current: NodeController;
		private var _source: NodeController;
		private var _target: NodeController;
		private var _sourceAnchor: Number;
		private var _targetAnchor: Number;
		
		private var _start: Point;
		private var _router: IConnectionRouter;
		private var _view: Sprite;
		
		private var _lineWidth: int = 2;


		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function ConnectionTool(editor: DiagramEditor) {
			super(editor);
		}

		public function get lineWidth(): int{
			return _lineWidth;
		}
		
		public function set lineWidth(value: int): void{
			_lineWidth = value;
		}

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override public function activate(): void {
			super.activate();
			
			_current = null;
			_source = null;
			_target = null;
			_router = editor.getCurrentConnectionRouter();

			state = STATE_STARTED;
		}
		
		override public function deactivate(): void {
			if (_current)
				_current.hideConnectFeedback();
			
			_current = null;
			_source = null;
			_target = null;
			_router = null;
			
			super.deactivate();
		}

		override public function mouseDown(event: MouseEvent): void {
			super.mouseDown(event);
			event.updateAfterEvent();
			
			if (state == STATE_COMPLETED || state == STATE_CANCELED)
				state = STATE_STARTED;
			
			if (event.target is ConnectHandle) {
				var handle: ConnectHandle = event.target as ConnectHandle;
				
				switch (state) {
					case STATE_STARTED:
						if (startConnection(handle))
							state = STATE_SOURCE_ANCHORED;
						break;
						
					case STATE_SOURCE_ANCHORED:
						endConnection(handle);
						state = STATE_CANCELED;
						editor.resetTool();
						break;
				}
			} 
			else if (event.target is NodeView) {
				var ctrl: NodeController = editor.rootController.findByView(event.target as NodeView) as NodeController;

				// target을 찾는 중에 노드를 클릭하면
				// 가장 가까운 연결 포인트로 연결을 종료한다.
				if (state == STATE_SOURCE_ANCHORED) {
					// 임시로
					endConnection(null);
					
					// 다시 시작
					state = STATE_STARTED;
				}
				
			} 
			else {
				// target을 찾눈 중에 노드 외의 영역을 클릭하면 초기화 한다. 
				if (state == STATE_SOURCE_ANCHORED) {
					endConnection(null);
					state = STATE_STARTED;
				}
			}
		}
		
		override public function mouseMove(event: MouseEvent): void {
			super.mouseMove(event);
			event.updateAfterEvent();
			if (event.target is NodeView) {
				var ctrl: NodeController = editor.findControllerByView(event.target as NodeView) as NodeController;
				
				if (ctrl) {
					if (state == STATE_STARTED && ctrl.canConnect()) {
						current = ctrl;
					} else if (state == STATE_SOURCE_ANCHORED && ctrl.canConnectWith(_source)) {
						current = ctrl;
					}
				}
			}

			if (state == STATE_SOURCE_ANCHORED) {
				doConnect(editor.zoomedX, editor.zoomedY, event.target as ConnectHandle);
			} 
		}

		override public function mouseUp(event: MouseEvent): void {
			super.mouseUp(event);
			event.updateAfterEvent();
			if (event.target is ConnectHandle) {
				var handle: ConnectHandle = event.target as ConnectHandle;
				
				switch (state) {
					case STATE_STARTED:
						endConnection(handle);
						state = STATE_CANCELED;
						break;
						
					case STATE_SOURCE_ANCHORED:
						if (endConnection(handle)) {
							state = STATE_COMPLETED;
							
							var src: Node = _source.model as Node;
							var dst: Node = _target.model as Node;

							_source = null;
							_target = null;
							
							editor.executeRequest(new LinkCreationRequest("default", src, dst, _sourceAnchor, _targetAnchor, null));
							
						} else {
							state = STATE_CANCELED;
						}
						editor.resetTool();
						break;
				}
			}else{
				endConnection(null);
				if(state == STATE_SOURCE_ANCHORED){
					editor.resetTool();
				}
				state = STATE_CANCELED;
			}
		}

		override public function keyDown(event: KeyboardEvent): void {
			super.keyDown(event);
			event.updateAfterEvent();
		}
		
		override public function keyUp(event: KeyboardEvent): void {
			super.keyUp(event);	
		}

		override protected function acceptAbort():Boolean {
			return _state == STATE_STARTED || STATE_CANCELED || STATE_COMPLETED;
		}


		//----------------------------------------------------------------------
		// Internal properties
		//----------------------------------------------------------------------
		
		public function get state(): int {
			return _state;
		}
		
		public function set state(value: int): void {
			_state = value;
		}

		public function get source(): NodeController{
			return _source;
		} 
		
		public function set source(value: NodeController): void{
			_source = value;
		}

		public function get target(): NodeController{
			return _target;
		} 
		
		public function set target(value: NodeController): void{
			_target = value;
		}

		public function get sourceAnchor(): Number{
			return _sourceAnchor;
		}
		
		public function set sourceAnchor(value: Number): void{
			_sourceAnchor = value;
		}
		
		public function get targetAnchor(): Number{
			return _targetAnchor;
		}
		
		public function set targetAnchor(value: Number): void{
			_targetAnchor = value;
		}
		
		public function get start(): Point{
			return _start;
		}
		
		public function set start(value: Point): void{
			_start = value;
		}
		
		public function get router(): IConnectionRouter{
			return _router;
		}
		public function set router(value: IConnectionRouter): void{
			_router = value;
		}

		public function get view(): Sprite{
			return _view;
		}
		
		public function set view(value: Sprite): void{
			_view = value;
		}
		
		/**
		 * Current controller
		 */
		public function get current(): NodeController {
			return _current;
		}
		
		public function set current(value: NodeController): void {
			if (value != _current) {
				if (_current && (_current != _source))
					_current.hideConnectFeedback();
					
				_current = value;
				
				if (_current && (_current != _source))
					_current.showConnectFeedback();
			}
		}

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		public function startConnection(handle: ConnectHandle): Boolean {
			_source = handle.controller;
			_sourceAnchor = handle.anchor;
			_target = null;
			
			_start = new Point(handle.x, handle.y);
			
			_view = new Sprite();
			renderView(handle.x, handle.y, null);
			editor.getFeedbackLayer().addChild(_view);
			
			return true;
		}
		
		public function doConnect(x: int, y: int, handle: ConnectHandle): void {
			//trace("doConnect(" + x + ", " + y + ") : " + handle);
			renderView(x, y, handle);
		}
		
		public function endConnection(handle: ConnectHandle): Boolean {
			if (_view) {
				editor.getFeedbackLayer().removeChild(_view);
				_view = null;
			}

			if(_source)
				_source.hideConnectFeedback();

			if(handle)
				handle.controller.hideConnectFeedback();

			_current = null;

			if (handle) {
				_target = handle.controller;
				_targetAnchor = handle.anchor;
			}
			
			return _target != null;
		}
		
		protected function renderView(x: int, y: int, handle: ConnectHandle): void {
			if (_view == null || _router == null) return;
			
			var g: Graphics = _view.graphics;
			
			g.clear();
			
			var pts: Array;
			
			if (handle != null) {
				pts = _router.route(_source.bounds, _start, _sourceAnchor, 
									handle.controller.bounds, new Point(handle.x, handle.y), handle.anchor);
			} else {
				pts = _router.route(null, _start, 0, null, new Point(x, y), 0);
			}
			
			for (var i: int = 1; i < pts.length; i++) {
				g.lineStyle(lineWidth, 0x000000);
				g.moveTo(pts[i - 1].x, pts[i - 1].y);
				g.lineTo(pts[i].x, pts[i].y);
			}
		}
		
		/**
		 * 상태 체크 
		 * added by sjyoon 2009.02.27
		 */
		public function isState(state: int): Boolean {
			return _state == state; 
		}
		
		/**
		 * 연결선을 그릴때 풀을 벗어나면 연결선을 삭제
		 * added by sjyoon 2009.02.27
		 */
		public function reset(): void {
			if (_view) {
				editor.getFeedbackLayer().removeChild(_view);
				_view = null;
			}
			
//			_current = null;
//			_source = null;
//			_target = null;
//			
//			_state = STATE_STARTED;
		}
	}
}