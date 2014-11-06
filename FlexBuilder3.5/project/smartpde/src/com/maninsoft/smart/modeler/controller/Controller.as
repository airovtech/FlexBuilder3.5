////////////////////////////////////////////////////////////////////////////////
//  Controller.as
//  2007.12.15, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.controller
{
	import com.maninsoft.smart.modeler.command.Command;
	import com.maninsoft.smart.modeler.common.ObjectBase;
	import com.maninsoft.smart.modeler.editor.DiagramEditor;
	import com.maninsoft.smart.modeler.editor.tool.DragTracker;
	import com.maninsoft.smart.modeler.editor.tool.SelectTracker;
	import com.maninsoft.smart.modeler.model.DiagramObject;
	import com.maninsoft.smart.modeler.model.Node;
	import com.maninsoft.smart.modeler.request.Request;
	import com.maninsoft.smart.modeler.view.IView;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * DiagramObject 와 View를 연결한다.
	 * Request를 해석하여 실행 Command 를 생성한다.
	 */
	public class Controller extends ObjectBase {
		
		//----------------------------------------------------------------------
		// Class constants
		//----------------------------------------------------------------------

		public static const EMPTY_TOOLS: Array = [];
		
		public static const TOOLS_TOP		: int = 0;
		public static const TOOLS_RIGHT 	: int = 1;
		public static const TOOLS_BOTTOM	: int = 2;
		public static const TOOLS_LEFT	: int = 3;

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _parent: Controller;
		/** Storage for property model */
		private var _model: DiagramObject;
		/** Storage for property view */
		private var _view: IView;
		/** Storage for child controllers */
		private var _children: ArrayCollection;
		
		private var _selected: Boolean;
		private var _tools: Array;
		private var _toolsVisible: Boolean;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function Controller(model: DiagramObject) {
			super();
			
			_model = model;
		}
		
		/**
		 * 컨트롤러를 활성 시킨다.
		 */
		public function activate(): void {
			activateView();
			
			if (_children) {
				for each (var child: Controller in _children) {
					Controller(child).activate();
				} 
			}
		}
		
		/**
		 * 컨트롤러를 비활성 시킨다.
		 */
		public function deactivate(): void {
			if (_children) {
				for each (var child: Controller in _children) {
					Controller(child).deactivate();
				} 
			}
			
			deactivateView();
		}
		
		protected function activateView(): void {
		}
		
		protected function deactivateView(): void {
		}
		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
				
		/**
		 * editor
		 */
		private var _editor: DiagramEditor;
		public function get editor(): DiagramEditor {
			if(_editor) return _editor;
			
			var p: Controller = parent;
			
			while ((p != null) && !(p is RootController))
				p = p.parent;
				
			_editor = p ? RootController(p).owner : null;
			return _editor;
		}				
/*		public function get editor(): DiagramEditor {
			var p: Controller = parent;
			
			while ((p != null) && !(p is RootController))
				p = p.parent;
				
			return p ? RootController(p).owner : null;
		}				
*/				
		/**
		 * parent
		 */
		public function get parent(): Controller {
			return _parent;
		}
		
		
		internal function setParent(value: Controller): void {
			_parent = value;
		}
		
		/**
		 * children
		 */
		public function get children(): Array {
			return _children ? _children.toArray() : null;
		}
		
		/**
		 * children count
		 */
		public function get count(): uint {
			return _children ? _children.length : 0;
		}
				
		/**
		 * model
		 */
		public function get model(): DiagramObject {
			return _model;
		}
		
		/**
		 * 컨트롤러가 생성한 view를 리턴한다. 현재, view가 생성되지 않은 상태라면 생성한다.
		 */
		public function get view(): IView {
			if (!_view) {
				_view = createView();
				
				if (_view)
					afterViewCreation(_view);
			}
			
			return _view;
		}
		
		public function get bounds(): Rectangle {
			if (model is Node) {
				return Node(model).bounds;
			}
			
			return null;
		}
		
		public function get canPopUp(): Boolean {
			return false;
		}
		
		public function get popUpPosition(): Point {
			var r: Rectangle = bounds;
			
			return new Point(r.x + r.width - 4, r.y + 4);
		}
		
		public function get actions(): Array {
			return null;
		}

		/**
		 * selected
		 */
		public function get selected(): Boolean {
			return _selected;
		}
		
		public function set selected(value: Boolean): void {
			if (value != selected) {
				_selected = value;
				
				if (value) {
					showSelection();
				} else {
					hideSelection();
				}
			}
		}
		
		public function get tools(): Array {
			if (!_tools) {
				_tools = createTools();
			}
			
			return _tools ? _tools : EMPTY_TOOLS;
		}
		
		protected function get toolsDir(): int {
			return TOOLS_RIGHT;
		}
		
		private var _showPropertyView:Boolean=false;
		public function get showPropertyView():Boolean{
			return _showPropertyView;
		}
		
		public function set showPropertyView(value: Boolean):void{
			_showPropertyView = value;
		}
		
		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		
		/**
		 * 자식 컨트롤러 중 해당 view 의 컨트롤러를 리턴한다.
		 */
		public function findByView(view: IView): Controller {
			for each (var ctrl: Controller in _children) {
				if (ctrl.view == view) {
					return ctrl;
				}
				
				var child: Controller = ctrl.findByView(view);
				
				if (child)
					return child;
			}
			
			return null;
		}
		
		/**
		 * 자식 컨트롤러 중 해당 model 의 컨트롤러를 리턴한다.
		 */
		public function findByModel(model: DiagramObject): Controller {
			for each (var ctrl: Controller in _children) {
				if (ctrl.model == model) {
					return ctrl;
				}
				
				var child: Controller = ctrl.findByModel(model);
				
				if (child)
					return child;
			}
			
			return null;
		} 
		
		/**
		 * (x, y) 위치를 포함하는 자식 컨트롤러를 리턴한다.
		 */
		public function findController(x: Number, y: Number): Controller {
			for each (var ctrl: Controller in _children) {
				if (ctrl.view) {
					var d: DisplayObject = ctrl.view.getDisplayObject();
					
					if (d) {
						var r: Rectangle = d.getBounds(editor);
						
						if (r.contains(x, y)) {
							return ctrl;
						}
					}
				}
				
				var child: Controller = ctrl.findController(x, y);
				
				if (child)
					return child;
			}
			
			return null;
		}

		public function findControllersByRect(rect: Rectangle): Array {
			var list: Array = [];

			for each (var ctrl: Controller in _children) {
				if (ctrl.view) {
					var d: DisplayObject = ctrl.view.getDisplayObject();
					
					if (d) {
						var r: Rectangle = d.getBounds(editor);
						
						if (rect.containsRect(r))
							list.push(ctrl);
					}
				}
			}
			
			return list;
		}

		/**
		 * 선택된 개체의 위치등이 변경되어서 선택 표시를 다시 그린다.
		 */ 
		public function refreshSelection(): void {
			if (hideSelection())
				showSelection();
		}
		
		/**
		 * 컨트롤러의 핸들들을 표시한다.
		 */
		public function showTools(): Boolean {
			if (!_toolsVisible) {
				showToolsInternal();
				_toolsVisible = true;
				return true;
			}
			
			return false;
		}
		
		protected function showToolsInternal(): void {
		}
		
		/**
		 * 컨트롤러의 핸들들을 감춘다.
		 */
		public function hideTools(): Boolean {
			if (_toolsVisible) {
				for each (var tool: DisplayObject in tools) {
					if (editor.getFeedbackLayer().contains(tool))
						editor.getFeedbackLayer().removeChild(tool);
				}
				
				_toolsVisible = false;
				return true;
			}
			
			return false;
		}
		
		/**
		 * 컨트롤러의 핸들들을 이동시킨다.
		 */
		public function moveControllerHandles(dx: Number, dy: Number): void {
			if (_toolsVisible) {
				for each (var tool: DisplayObject in tools) {
					tool.x += dx;
					tool.y += dy;
				}
			}
		}
		
		/**
		 * 선택 클릭이 가능한 위치인가?
		 */
		public function canSelect(x: Number, y: Number): Boolean {
			return true;
		}
		
		/**
		 * 선택 클릭이 가능한 위치인가?
		 */
		 
		/**
		 * dx, dy 만큼 크기 변경 가능한가?
		 */
		public function canResizeBy(anchorDir: int, dx: Number, dy: Number): Boolean {
			return true;
		} 
		 
		/**
		 * dx, dy 만큼 이동 가능한가?
		 */
		public function canMoveBy(dx: Number, dy: Number): Boolean {
			return true;
		}
		
		/**
		 * 링크 소스가 될 수 있는가?
		 */
		public function canConnect(): Boolean {
			return false;
		}
		
		/**
		 * source 컨트롤러와 연결 가능한가?
		 */
		public function canConnectWith(source: Controller): Boolean {
			return false;
		}

		/**
		 * 자식들을 선택하는 드래그트래커
		 */
		public function getSelectTracker(localX: Number, localY: Number): DragTracker {
			return new SelectTracker(this);
		}
		
		/**
		 * 에디터 상의 좌표값을 컨트롤러의 상대 좌표로 바꿔 리턴한다.
		 */
		public function editorToController(p: Point): Point {
			return p.clone();
		}
		
		public function editorToControllerRect(r: Rectangle): Rectangle {
			var p: Point = new Point(r.x, r.y);
			p = editorToController(p);
			return new Rectangle(p.x, p.y, r.width, r.height);
		}
		
		/**
		 * 컨트롤러의 상대 좌표를 에디터 상의 좌표값으로 바꿔 리턴한다.
		 */
		public function controllerToEditor(p: Point): Point {
			return p.clone();
		}
		
		public function controllerToEditorRect(r: Rectangle): Rectangle {
			var p: Point = new Point(r.x, r.y);
			p = controllerToEditor(p);
			return new Rectangle(p.x, p.y, r.width, r.height);
		}
		
		//----------------------------------------------------------------------
		// Virtual Methods
		//----------------------------------------------------------------------

		/**
		 * 모델에 대한 view를 생성한다.
		 */
		protected function createView(): IView {
			return null;		
		}

		/**
		 * createView()가 호출된 후 바로 호출된다.
		 */		
		protected function afterViewCreation(view: IView): void {
		}
		
		public function refreshView(): void {
		}
		
		/**
		 * 수행 가능한 요청인가?
		 */
		public function understandRequest(request: Request): Boolean {
			return false;
		}
		
		/**
		 * 요청을 해석해서 커맨드를 생성 리턴한다.
		 * GEF의 경우 컨트롤러에 등록된 EditPolicy들에게 역할을 이관시킨다.
		 */
		public function getCommand(request: Request): Command {
			return null;
		}
		
		/**
		 * Reisze request를 받아서 명령을 내보내는 것으로 바꿀 것 !!!
		 */
		public function getResizeCommand(resizeDir: int, deltaX: Number, delta: Number): Command {
			return null;
		}

		/**
		 * 선택된 상태임을 표시한다.
		 */		
		protected function showSelection(): Boolean {
			return false;
		}
		
		/**
		 * 선택 상태를 지운다.
		 */
		protected function hideSelection(): Boolean {
			showPropertyView = false;
			return false;
		}

		/**
		 * UI에 의해 크기를 변경한다.
		 */
		public function resizeBy(anchorDir: int, dx: Number, dy: Number): void {
		}
		
		/**
		 * UI에 의해 위치를 변경한다.
		 */
		public function moveBy(dx: Number, dy: Number): void {
		}
		
		/**
		 * 컨트롤러 Tool 들을 생성한다. handle getter에서 호출된다.
		 */
		protected function createTools(): Array {
			return null;
		}
		
		//----------------------------------------------------------------------
		// Internal Methods
		//----------------------------------------------------------------------
		
		/**
		 * 자식 컨트롤러가 있는가?
		 */
		public function hasChild(): Boolean {
			return _children && (_children.length > 0);
		}
		
		public function contains(child: Controller): Boolean {
			return _children && _children.contains(child);
		}

		public function getChildIndex(child: Controller): int {
			return _children ? _children.getItemIndex(child) : -1;
		}
		
		public function addChildAt(child: Controller, idx: int): void {
			if (!contains(child)) {
				if (!_children)
					_children = new ArrayCollection();

				_children.addItemAt(child, idx);
				child._parent = this;				
			}
		}
		
		public function addChild(child: Controller): void {
			addChildAt(child, count);
		}

		public function removeChildAt(idx: int): Controller {
			if (_children) {
				if (idx >= 0) {
					var child: Controller = _children.removeItemAt(idx) as Controller;
					child._parent = null;
				}
			}
	
			return null;			
		}
		
		public function removeChild(child: Controller): void {
			removeChildAt(getChildIndex(child));
		}
	}
}