////////////////////////////////////////////////////////////////////////////////
//  NodeEdit.as
//  2007.12.14, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.controller
{
	import com.maninsoft.smart.modeler.command.Command;
	import com.maninsoft.smart.modeler.command.NodeBoundsCommand;
	import com.maninsoft.smart.modeler.editor.handle.ConnectHandle;
	import com.maninsoft.smart.modeler.editor.handle.SelectHandle;
	import com.maninsoft.smart.modeler.model.Link;
	import com.maninsoft.smart.modeler.model.Node;
	import com.maninsoft.smart.modeler.model.events.NodeChangeEvent;
	import com.maninsoft.smart.modeler.model.events.NodeEvent;
	import com.maninsoft.smart.modeler.model.events.NodeValueEvent;
	import com.maninsoft.smart.modeler.view.IView;
	import com.maninsoft.smart.modeler.view.NodeView;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Node 모델의 컨트롤러
	 */
	public class NodeController extends Controller implements ITextEditable {
		
		//----------------------------------------------------------------------
		// Class constants
		//----------------------------------------------------------------------
		
		public static const EMPTY_LINKS: Array = new Array();


		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		/** Storage for selection handles */
		private var _selectHandles: Array;
		/** Storage for connection handles */
		private var _connectHandles: Array;

		private var selectBorderColor:uint = 0xda0000;
		private var currentBorderColor:uint;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function NodeController(model: Node) {
			super(model);
		}
		

		//----------------------------------------------------------------------
		// ITextEditable
		//----------------------------------------------------------------------
		
		/**
		 * 현재 편집 가능한 상태인가?
		 */
		public function canModifyText(): Boolean {
			return true;
		}
		
		/**
		 * 개체의 현재 text 값을 리턴
		 */
		public function getEditText(): String {
			return "Hello?";
		}
		
		/**
		 * 텍스트 편집기 내에서 변경된 값으로 호출
		 */
		public function setEditText(value: String): void {
		}
		
		/**
		 * 텍스트 편집기가 표시되어야 할 경계를 다이어그램 에디터 좌표로 리턴
		 */
		public function getTextEditBounds(): Rectangle {
			return controllerToEditorRect(nodeModel.bounds);
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/** 
		 * Property model
		 */
		public function get nodeModel(): Node {
			return super.model as Node;
		}
		
		public function get leftMargin(): Number {
			return 0;
		}
		
		public function get topMargin(): Number {
			return 0;
		}
		
		public function get selectHandles(): Array{
			return _selectHandles;
		}
		public function set selectHandles(value: Array): void{
			_selectHandles = value;
		}

		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------

		/**
		 * 이 컨트롤러 노드의 source link들에 대한 링크컨트롤러들을 리턴한다.
		 */
		public function getSourceLinks(): Array {
			var links: Array = nodeModel.sourceLinks;
			
			if (links.length > 0) {
				var ctrls: Array = new Array();
				
				for each (var link: Link in links) {
					ctrls.push(editor.findControllerByModel(link));
				}
				
				return ctrls;
				
			} else {
				return EMPTY_LINKS;
			}		
		}

		/**
		 * 이 컨트롤러 노드의 target link들에 대한 링크컨트롤러들을 리턴한다.
		 */
		public function getTargetLinks(): Array {
			var links: Array = nodeModel.targetLinks;
			
			if (links.length > 0) {
				var ctrls: Array = new Array();
				
				for each (var link: Link in links) {
					ctrls.push(editor.findControllerByModel(link));
				}
				
				return ctrls;
				
			} else {
				return EMPTY_LINKS;
			}		
		}

		/**
		 * 선택 핸들들의 방향값을 리턴한다.
		 */
		public function getSelectAnchorDirs(): Array {
			var dirs: Array = new Array();
			
			dirs.push(SelectHandle.DIR_TOPLEFT);
			dirs.push(SelectHandle.DIR_TOP);
			dirs.push(SelectHandle.DIR_TOPRIGHT);
			dirs.push(SelectHandle.DIR_RIGHT);
			dirs.push(SelectHandle.DIR_BOTTOMRIGHT);
			dirs.push(SelectHandle.DIR_BOTTOM);
			dirs.push(SelectHandle.DIR_BOTTOMLEFT);
			dirs.push(SelectHandle.DIR_LEFT);

			return dirs;			
		}
		
		/**
		 * 선택 핸들들의 위치값을 리턴한다.
		 */
		public function getSelectAnchorPoint(dir: int): Point {
			var node: Node = model as Node;
			
			var x: Number = node.x;
			var y: Number = node.y;
			var w: Number = node.width;
			var h: Number = node.height;

			switch (dir) {			
				case SelectHandle.DIR_TOPLEFT:
					return new Point(x-1, y-1);
					
				case SelectHandle.DIR_TOP:
					return new Point(x + w / 2, y-1);
					
				case SelectHandle.DIR_TOPRIGHT:
					return new Point(x + w + 1, y-1);
					
				case SelectHandle.DIR_RIGHT:
					return new Point(x + w + 1, y + h / 2);
					
				case SelectHandle.DIR_BOTTOMRIGHT:
					return new Point(x + w + 1, y + h + 1);
					
				case SelectHandle.DIR_BOTTOM:
					return new Point(x + w / 2, y + h + 1);
					
				case SelectHandle.DIR_BOTTOMLEFT:
					return new Point(x-1, y + h + 1);
					
				case SelectHandle.DIR_LEFT:			
					return new Point(x-1, y + h / 2);
					
				default:
					throw new Error("Invalid selectAnchorDir(" + dir + ")");
			}
		}
		
		/**
		 * dx, dy 만큼 크기 변경이 요청된 후의 선택 핸들들의 위치값을 리턴한다.
		 */ 
		public function getResizedPoint(sizeAnchor: int, dir: Number, dx: Number, dy: Number): Point {
			trace("sizeAnchor=" + sizeAnchor + ", dir=" + dir + ", dx=" + dx + ", dy=" + dy);
			
			var node: Node = model as Node;
			var pts: Array = new Array();
			
			var x: Number = node.x;
			var y: Number = node.y;
			var w: Number = node.width;
			var h: Number = node.height;
			var p: Point = getSelectAnchorPoint(dir);

			trace("oldPos: p.x=" + p.x + ", p.y=" + p.x);
			
			switch (sizeAnchor) {			
				case SelectHandle.DIR_TOPLEFT:
					switch (dir) {
						case SelectHandle.DIR_TOPLEFT:
							p.x += dx;
							p.y += dy;
							break;

						case SelectHandle.DIR_TOP:
							p.x += dx / 2;
							p.y += dy;
							break;
						
						case SelectHandle.DIR_TOPRIGHT:
							p.y += dy;
							break;

						case SelectHandle.DIR_RIGHT:
							p.y += dy / 2;
							break;
						
						case SelectHandle.DIR_BOTTOMRIGHT:
							break;
							
						case SelectHandle.DIR_BOTTOM:
							p.x += dx / 2;
							break;

						case SelectHandle.DIR_BOTTOMLEFT:
							p.x += dx;
							break;			

						case SelectHandle.DIR_LEFT:
							p.x += dx;
							p.y += dy / 2;
							break;
					}
					
					break;
					
				case SelectHandle.DIR_TOP:
					switch (dir) {
						case SelectHandle.DIR_TOPLEFT:
						case SelectHandle.DIR_TOP:
						case SelectHandle.DIR_TOPRIGHT:
							p.y += dy;
							break;

						case SelectHandle.DIR_RIGHT:
						case SelectHandle.DIR_LEFT:
							p.y += dy / 2;
							break;
					}
					
					break;
					
				case SelectHandle.DIR_TOPRIGHT:
					switch (dir) {
						case SelectHandle.DIR_TOPLEFT:
							p.y += dy;
							break;

						case SelectHandle.DIR_TOP:
							p.x += dx / 2;
							p.y += dy;
							break;
						
						case SelectHandle.DIR_TOPRIGHT:
							p.x += dx;
							p.y += dy;
							break;

						case SelectHandle.DIR_RIGHT:
							p.x += dx;
							p.y += dy / 2;
							break;
						
						case SelectHandle.DIR_BOTTOMRIGHT:
							p.x += dx;
							break;
							
						case SelectHandle.DIR_BOTTOM:
							p.x += dx / 2;
							break;

						case SelectHandle.DIR_BOTTOMLEFT:
							break;			

						case SelectHandle.DIR_LEFT:
							p.y += dy / 2;
							break;
					}

					break;
					
				case SelectHandle.DIR_RIGHT:
					switch (dir) {
						case SelectHandle.DIR_TOPRIGHT:
						case SelectHandle.DIR_RIGHT:
						case SelectHandle.DIR_BOTTOMRIGHT:
							p.x += dx;
							break;

						case SelectHandle.DIR_TOP:
						case SelectHandle.DIR_BOTTOM:
							p.x += dx / 2;
							break;
					}

					break;
					
				case SelectHandle.DIR_BOTTOMRIGHT:
					switch (dir) {
						case SelectHandle.DIR_TOPLEFT:
							break;

						case SelectHandle.DIR_TOP:
							p.x += dx / 2;
							break;
						
						case SelectHandle.DIR_TOPRIGHT:
							p.x += dx;
							break;

						case SelectHandle.DIR_RIGHT:
							p.x += dx;
							p.y += dy / 2;
							break;
						
						case SelectHandle.DIR_BOTTOMRIGHT:
							p.x += dx;
							p.y += dy;
							break;
							
						case SelectHandle.DIR_BOTTOM:
							p.x += dx / 2;
							p.y += dy;
							break;

						case SelectHandle.DIR_BOTTOMLEFT:
							p.y += dy;
							break;			

						case SelectHandle.DIR_LEFT:
							p.y += dy / 2;
							break;
					}

					break;
					
				case SelectHandle.DIR_BOTTOM:
					switch (dir) {
						case SelectHandle.DIR_BOTTOMLEFT:
						case SelectHandle.DIR_BOTTOM:
						case SelectHandle.DIR_BOTTOMRIGHT:
							p.y += dy;
							break;

						case SelectHandle.DIR_RIGHT:
						case SelectHandle.DIR_LEFT:
							p.y += dy / 2;
							break;
					}

					break;
					
				case SelectHandle.DIR_BOTTOMLEFT:
					switch (dir) {
						case SelectHandle.DIR_TOPLEFT:
							p.x += dx;
							break;

						case SelectHandle.DIR_TOP:
							p.x += dx / 2;
							break;
						
						case SelectHandle.DIR_TOPRIGHT:
							break;

						case SelectHandle.DIR_RIGHT:
							p.y += dy / 2;
							break;
						
						case SelectHandle.DIR_BOTTOMRIGHT:
							p.y += dy;
							break;
							
						case SelectHandle.DIR_BOTTOM:
							p.x += dx / 2;
							p.y += dy;
							break;

						case SelectHandle.DIR_BOTTOMLEFT:
							p.x += dx;
							p.y += dy;
							break;			

						case SelectHandle.DIR_LEFT:
							p.x += dx;
							p.y += dy / 2;
							break;
					}

					break;
					
				case SelectHandle.DIR_LEFT:			
					switch (dir) {
						case SelectHandle.DIR_TOPLEFT:
						case SelectHandle.DIR_LEFT:
						case SelectHandle.DIR_BOTTOMLEFT:
							p.x += dx;
							break;

						case SelectHandle.DIR_TOP:
						case SelectHandle.DIR_BOTTOM:
							p.x += dx / 2;
							break;
					}
					break;
					
				default:
					throw new Error("Invalid selectAnchorDir(" + dir + ")");
			}
			
			trace("newPos: p.x=" + p.x + ", p.y=" + p.x);

			return p;
		}
		
		/**
		 * dx, dy 만큼 위치 변경이 요청된 후의 선택 핸들들의 위치값을 리턴한다.
		 */ 
		public function getMovedPoint(dir: int, dx: Number, dy: Number): Point {
			var node: Node = model as Node;
			var pts: Array = new Array();
			
			var x: Number = node.x + dx;
			var y: Number = node.y + dy;
			var w: Number = node.width;
			var h: Number = node.height;
			
			switch (dir) {			
				case SelectHandle.DIR_TOPLEFT:
					return new Point(x, y);
					
				case SelectHandle.DIR_TOP:
					return new Point(x + w / 2, y);
					
				case SelectHandle.DIR_TOPRIGHT:
					return new Point(x + w - 1, y);
					
				case SelectHandle.DIR_RIGHT:
					return new Point(x + w - 1, y + h / 2);
					
				case SelectHandle.DIR_BOTTOMRIGHT:
					return new Point(x + w - 1, y + h - 1);
					
				case SelectHandle.DIR_BOTTOM:
					return new Point(x + w / 2, y + h - 1);
					
				case SelectHandle.DIR_BOTTOMLEFT:
					return new Point(x, y + h - 1);
					
				case SelectHandle.DIR_LEFT:			
					return new Point(x, y + h / 2);
					
				default:
					throw new Error("Invalid selectAnchorDir(" + dir + ")");
			}
		}
		
		//----------------------------------------------------------------------
		// Virtual methods
		//----------------------------------------------------------------------

		/**
		 * 부모 노드에 자식 노드가 추가되었다.
		 */
		protected function nodeAdded(event: NodeEvent): void {
			//trace("NodeController: nodeAdded");
			
			if (editor) {
				// event.node 의 children 들도 생성되도록 해야 할까?
				var ctrl: Controller = editor.createController(event.node);
				
				addChild(ctrl);
				ctrl.activate();
				
				editor.select(event.node);
			}
		}
		
		/**
		 * 부모 노드에서 자식 노드가 제거되었다.
		 */
		protected function nodeRemoved(event: NodeEvent): void {
			if (editor) {
				// event.node 의 children 들도 생성되도록 해야 할까?
				var ctrl: Controller = editor.findControllerByModel(event.node);

				ctrl.deactivate();
				removeChild(ctrl);
			}
		}
		
		/**
		 * 자식 노드가 다른 노드로 대체되었다.
		 */
		protected function nodeReplaced(event: NodeValueEvent): void {
			if (editor) {
				var ctrl: Controller = editor.findControllerByModel(event.node); 
				var idx: int = getChildIndex(ctrl);
				var sel: Boolean = ctrl.selected; 
				
				if (sel)
					editor.selectionManager.remove(ctrl);

				ctrl.deactivate();
				removeChildAt(idx);
				
				ctrl = editor.createController(event.value as Node);
				addChildAt(ctrl, idx);
				ctrl.activate();

				this.refreshView();
				changeLinksConstraint(ctrl as NodeController);

				if (sel)
					editor.select(event.value as Node);
			}
		}
		
		/**
		 * 노드의 속성이 변경되었다.
		 */
		protected function nodeChanged(event: NodeChangeEvent): void {
			var view: NodeView = this.view as NodeView;

			if (event.prop == Node.PROP_SIZE || 
			    event.prop == Node.PROP_X || event.prop == Node.PROP_Y || event.prop == Node.PROP_POSITION ||
			    event.prop == Node.PROP_BOUNDS) {
				refreshBounds();
				refreshView();
			}
			
			changeLinksConstraint(this);
		}
		
		protected function changeLinksConstraint(ctrl: NodeController): void {
			var link: LinkController;
			
			for each (link in ctrl.getSourceLinks()) {
				if(link)
					link.sourceConstraintChanged();
			}
			
			for each (link in ctrl.getTargetLinks()) {
				if(link)
					link.targetConstraintChanged();
			}
			
			for each (var child: NodeController in ctrl.children) {
				changeLinksConstraint(child);
			}
		}


		//----------------------------------------------------------------------
		// Overriden properties
		//----------------------------------------------------------------------

		//----------------------------------------------------------------------
		// Overriden Methods
		//----------------------------------------------------------------------
		
		/**
		 * 컨트롤러를 활성 시킨다.
		 */
		override public function activate(): void {
			super.activate();

			if (nodeModel) {
				nodeModel.addEventListener(NodeEvent.CREATE, nodeAdded);
				nodeModel.addEventListener(NodeEvent.REMOVE, nodeRemoved);
				nodeModel.addEventListener(NodeEvent.REPLACE, nodeReplaced);
				nodeModel.addEventListener(NodeEvent.CHANGE, nodeChanged);
			}
		}
		
		/**
		 * 컨트롤러를 비활성 시킨다.
		 */
		override public function deactivate(): void {
			
			if (nodeModel) {
				nodeModel.removeEventListener(NodeEvent.CREATE, nodeAdded);
				nodeModel.removeEventListener(NodeEvent.REMOVE, nodeRemoved);
				nodeModel.removeEventListener(NodeEvent.REPLACE, nodeReplaced);
				nodeModel.removeEventListener(NodeEvent.CHANGE, nodeChanged);
			}
			
			super.deactivate();
		}
		
		/**
		 * View가 생성된 후 바로 호출된다.
		 */
		override protected function afterViewCreation(view: IView): void {
			NodeView(view).x += NodeController(parent).leftMargin;
			NodeView(view).y += NodeController(parent).topMargin;
		}

		override protected function activateView(): void {
			if (view) {
				if (parent is RootNodeController) {
					editor.addView(view);
				} else {
					var d: DisplayObject = view.getDisplayObject();
					DisplayObjectContainer(parent.view.getDisplayObject()).addChild(d);
				}
			}
		}
		
		override protected function deactivateView(): void {
			if (view) {
				if (parent is RootNodeController) {
					editor.removeView(view);
				} else {
					var d: DisplayObject = view.getDisplayObject();
					DisplayObjectContainer(parent.view.getDisplayObject()).removeChild(d);
				}
			}
		}

		override protected function createView(): IView {
			if (model) {
				var view: NodeView = createNodeView();
				initNodeView(view);
				drawNodeView(view);
				
				return view;
				
			} else {
				return null;
			}
		}
		
		protected function createNodeView(): NodeView {
			return new NodeView();
		}
		
		protected function initNodeView(nodeView: NodeView): void {
			nodeView.x = nodeModel.x;
			nodeView.y = nodeModel.y;
			nodeView.nodeWidth = nodeModel.width;
			nodeView.nodeHeight = nodeModel.height;
		}
		
		protected function drawNodeView(nodeView: NodeView): void {
			nodeView.draw();
		}
		
		override public function refreshView(): void {
			if (view) {
				NodeView(view).refresh();
			}
		}

		public function refreshBounds(): void {
			var view: NodeView = this.view as NodeView;
			
			view.x = nodeModel.x + NodeController(parent).leftMargin;
			view.y = nodeModel.y + NodeController(parent).topMargin;

			view.nodeWidth = nodeModel.width;
			view.nodeHeight = nodeModel.height;

			refreshSelection();
		}

		override protected function showSelection(): Boolean {
			if (!_selectHandles) {
				_selectHandles = new Array();
				
				var dirs: Array = getSelectAnchorDirs();
	
				for (var i: int = 0; i < dirs.length; i++) {
					var handle: SelectHandle = new SelectHandle(this, dirs[i]);
					
					var p: Point = controllerToEditor(getSelectAnchorPoint(dirs[i]));
					
					handle.x = p.x - handle.width / 2;
					handle.y = p.y - handle.height / 2;
					
					_selectHandles.push(handle);
					editor.getSelectionLayer().addChild(handle);
				}

				var view: NodeView = this.view as NodeView;
				currentBorderColor = view.borderColor;
				view.borderColor = selectBorderColor;
				refreshView();
												
				return true;
				
			} else {
				return false;
			}
		}
		
		override protected function hideSelection(): Boolean {
			showPropertyView = false;
			if (_selectHandles) {
				for each (var handle: SelectHandle in _selectHandles) {
					if (editor.getSelectionLayer().contains(handle)) {
						editor.getSelectionLayer().removeChild(handle);	
					}
				}
				
				_selectHandles = null;		
				var view: NodeView = this.view as NodeView;
				view.borderColor = currentBorderColor;
				refreshView();
								
				return true;
			} else {
				return false;
			}
		}
		
		override public function refreshSelection(): void {
			if (_selectHandles) {
				var dirs: Array = getSelectAnchorDirs();
	
				for each (var handle: SelectHandle in _selectHandles) {
					var p: Point = controllerToEditor(getSelectAnchorPoint(handle.anchorDir));
					
					handle.x = p.x - handle.width / 2;
					handle.y = p.y - handle.height / 2;
				}
			}
		}

		/**
		 * dx, dy 만큼 크기 변경 가능한가?
		 */
		override public function canResizeBy(anchorDir: int, dx: Number, dy: Number): Boolean {
			return (nodeModel.width + dx) >= 4 && (nodeModel.width + dy) >= 4;
		} 
		
		override public function resizeBy(anchorDir: int, dx: Number, dy: Number): void {
			if (selected && _selectHandles) {
				for each (var handle: SelectHandle in _selectHandles) {
					var p: Point = controllerToEditor(getResizedPoint(anchorDir, handle.anchorDir, dx, dy));
					
					handle.x = p.x - handle.width / 2;
					handle.y = p.y - handle.height / 2;
				}
			}		
		}
		 
		/**
		 * dx, dy 만큼 이동 가능한가?
		 */
		override public function canMoveBy(dx: Number, dy: Number): Boolean {
			return (nodeModel.x + dx) >= 0 && (nodeModel.y + dy) >= 0; 
		}
		
		override public function moveBy(dx: Number, dy: Number): void {
			if (selected && _selectHandles) {
				for each (var handle: SelectHandle in _selectHandles) {
					var p: Point = controllerToEditor(getMovedPoint(handle.anchorDir, dx, dy));
					
					handle.x = p.x - handle.width / 2;
					handle.y = p.y - handle.height / 2;
				}
			}
		}
		
		public function showConnectFeedback(): void {
			hideConnectFeedback();
			_connectHandles = new Array();
			
			var pts: Array = nodeModel.getConnectAnchors();
			
			for (var i: int = 0; i < pts.length; i++) {
				var handle: ConnectHandle = new ConnectHandle(this, pts[i]);
				var pt: Point = controllerToEditor(nodeModel.connectAnchorToPoint(pts[i]));
				
				handle.x = pt.x;
				handle.y = pt.y;
				
				_connectHandles.push(handle);
				editor.getFeedbackLayer().addChild(handle);
			}

		}
		
		public function hideConnectFeedback(): void {
			if (_connectHandles) {
				for each (var handle: ConnectHandle in _connectHandles) {
					if (editor.getFeedbackLayer().contains(handle)) {
						editor.getFeedbackLayer().removeChild(handle);	
					}
				}
				
				_connectHandles = null;		
			}
		}
		
		/**
		 * 에디터 상의 좌표값을 컨트롤러의 상대 좌표로 바꿔 리턴한다.
		 */
		override public function editorToController(p: Point): Point {
			var p2: Point = p.clone();
			var nc: NodeController = this;
			
			while (!(nc is RootNodeController)) {
				p2.offset(-nc.nodeModel.x - nc.leftMargin, -nc.nodeModel.y - nc.topMargin);
				nc = nc.parent as NodeController;
			}
			
			return p2;
		}
		
		/**
		 * 컨트롤러의 상대 좌표를 에디터 상의 좌표값으로 바꿔 리턴한다.
		 */
		override public function controllerToEditor(p: Point): Point {
			var p2: Point = p.clone();
			var nc: NodeController = this;
			
			while (!(nc is RootNodeController)) {
				nc = nc.parent as NodeController;
				p2.offset(nc.nodeModel.x + nc.leftMargin, nc.nodeModel.y + nc.topMargin);
			}
			
			return p2;
		}
		
		private function getResizedRect(rect: Rectangle, sizeAnchor: int, dx: Number, dy: Number): Rectangle {
			var r: Rectangle = rect.clone();
			
			switch (sizeAnchor) {
				case SelectHandle.DIR_TOPLEFT:
					r.x += dx;
					r.y += dy;
					r.width -= dx;
					r.height -= dy;
					break;

				case SelectHandle.DIR_TOP:
					r.y += dy;
					r.height -= dy;
					break;
				
				case SelectHandle.DIR_TOPRIGHT:
					r.y += dy;
					r.height -= dy;
					r.width += dx;
					break;

				case SelectHandle.DIR_RIGHT:
					r.width += dx;
					break;
				
				case SelectHandle.DIR_BOTTOMRIGHT:
					r.width += dx;
					r.height += dy;
					break;
					
				case SelectHandle.DIR_BOTTOM:
					r.height += dy;
					break;

				case SelectHandle.DIR_BOTTOMLEFT:
					r.x += dx;
					r.width -= dx;
					r.height += dy;
					break;			

				case SelectHandle.DIR_LEFT:
					r.x += dx;
					r.width -= dx;
					break;
			}
			
			return r;
		}
		
		override public function getResizeCommand(resizeDir: int, deltaX: Number, deltaY: Number): Command {
			var r: Rectangle = getResizedRect(nodeModel.bounds, resizeDir, deltaX, deltaY);
			return new NodeBoundsCommand(nodeModel, r);
			//return new NodeResizeCommand(nodeModel, deltaX, deltaY);
		}

		/**
		 * 컨트롤러의 핸들들을 표시한다.
		 */
		override protected function showToolsInternal(): void {
			switch (toolsDir) {
				case TOOLS_TOP:
					showToolsOnTop();
					break;
					
				case TOOLS_RIGHT:
					showToolsOnRight();
					break;
					
				case TOOLS_BOTTOM:
					showToolsOnBottom();
					break;
					
				default:
					showToolsOnLeft();
					break;
			}
		}
		
		protected function showToolsOnTop(): void {
			var r: Rectangle = this.model.bounds;
			var x: Number = r.x + 2;
			var y: Number = r.y;

			for each (var tool: DisplayObject in tools) {
				if (IControllerTool(tool).enabled) {	
					var p: Point = new Point(x, y - tool.height - 4);
											 
					p = controllerToEditor(p);
					tool.x = p.x;
					tool.y = p.y;
					editor.getFeedbackLayer().addChild(tool);
					
					x += tool.width + 4;
				}
			}
		}
		
		protected function showToolsOnRight(): void {
			var r: Rectangle = this.model.bounds;
			var x: Number = r.x + r.width + 10;
			var y: Number = r.y + 2;

			for each (var tool: DisplayObject in tools) {
				if (IControllerTool(tool).enabled) {	
					var p: Point = new Point(x, y);
											 
					p = controllerToEditor(p);
					tool.x = p.x;
					tool.y = p.y;
					editor.getFeedbackLayer().addChild(tool);
					
					y += tool.height + 4;
				}
			}
		}
		
		protected function showToolsOnBottom(): void {
			showToolsOnRight();
		}
		
		protected function showToolsOnLeft(): void {
			showToolsOnRight();
		}
	}
}