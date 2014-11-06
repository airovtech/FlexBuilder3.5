////////////////////////////////////////////////////////////////////////////////
//  SelectionTool.as
//  2007.12.22, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.editor.tool
{
	import com.maninsoft.smart.modeler.controller.Controller;
	import com.maninsoft.smart.modeler.controller.IControllerTool;
	import com.maninsoft.smart.modeler.controller.ITextEditable;
	import com.maninsoft.smart.modeler.editor.DiagramEditor;
	import com.maninsoft.smart.modeler.editor.handle.IDraggableHandle;
	import com.maninsoft.smart.modeler.editor.handle.SelectionMenuHandle;
	import com.maninsoft.smart.modeler.view.IView;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	import mx.controls.scrollClasses.ScrollBar;
	import mx.managers.CursorManager;
	
	/**
	 * 1. 마우스 드래깅을 통한 복수 선택
	 * 2. 개별 개체의 클릭 선택을 통한 복수 선택
	 * 3. 선택된 복수 개체들의 마우스 드래깅을 이용한 이동
	 * 4. 선택된 개체(들)의 handle 선택시 DragTracker를 통한 핸들링 
	 */
	public class SelectionTool extends AbstractTool {
		
		//----------------------------------------------------------------------
		// Class constans
		//----------------------------------------------------------------------
	
		public static const DRAG_THRESHOLD: int = 3;
		
		public static const STATE_READY	: int = 0;
		public static const STATE_DRAGGING: int = 1;
		

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		/** Storage for dragHandle */
		private var _dragTracker: DragTracker;
		/** Storage for inlineEditor */
		private var _inlineEditor: InlineEditor;
		/** Menu handle */
		private var _menuHandle: SelectionMenuHandle;
		/** Storage for state */
		private var _state: int = STATE_READY;				
		

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function SelectionTool(editor: DiagramEditor) {
			super(editor);
			
			_menuHandle = new SelectionMenuHandle();
		}
		
		public function get dragTracker(): DragTracker{
			return _dragTracker;
		}
		public function set dragTracker(value: DragTracker): void{
			_dragTracker = value;
		}

		//----------------------------------------------------------------------
		// ITool
		//----------------------------------------------------------------------


		override public function activate(): void {
			super.activate();

			_menuHandle.visible = false;
			editor.getFeedbackLayer().addChild(_menuHandle);
		}
		
		override public function deactivate(): void {
			super.deactivate();
			
			if (dragTracker)
				dragTracker.deactivate();
				
			editor.selectionManager.clear();
			editor.getFeedbackLayer().removeChild(_menuHandle);
		}
		
		override public function click(event: MouseEvent): void {
			super.click(event);
		}
		
		override public function doubleClick(event: MouseEvent): void {
			super.doubleClick(event);
			if (event.target == inlineEditor || event.target.parent == inlineEditor)
				return;
			
			if (event.target != _menuHandle)
				_menuHandle.controller = null;
			
			_dragTracker = null;

			hideEditor();
			
			handleDoubleClick(event);

		}
		
		override public function mouseDown(event: MouseEvent): void {
			super.mouseDown(event);
			
			if (event.target == inlineEditor || event.target.parent == inlineEditor)
				return;
			
			if (event.target != _menuHandle)
				_menuHandle.controller = null;
			
			_dragTracker = null;

			hideEditor();
			
			handleMouseDown(event);
		}

		protected function handleDoubleClick(event: MouseEvent): void {
			if (event.target is TextField)
				return;
				
			if (event.target.parent is ScrollBar || event.target is ScrollBar)
				return;

			if (event.target is IView) {
				var ctrl: Controller = editor.findControllerByView(event.target as IView);
				if (ctrl) {
					if (!editor.multiSelecatble || !(event.shiftKey || event.ctrlKey))
						selManager.clear();
					ctrl.showPropertyView = true;
					selManager.add(ctrl);
						
					if (!editor.readOnly)
						_dragTracker = new MoveTracker(ctrl);
				} 
				else {
					selManager.clear();
				}
			} 
			else {
				selManager.clear();
				_dragTracker = new SelectTracker(editor.rootController);
			}
		}
		
		protected function handleMouseDown(event: MouseEvent): void {
			if (event.target is TextField)
				return;
				
			if (event.target.parent is ScrollBar || event.target is ScrollBar)
				return;

			if (event.target is IDraggable) {
				if (!editor.readOnly)
					_dragTracker = IDraggable(event.target).getDragTracker(event);				
			} 
			else if (event.target is IControllerTool) {
			} 
			else if (event.target == _menuHandle) {
				_menuHandle.showMenu();
			} 
			else if (event.target is IView) {
				var ctrl: Controller = editor.findControllerByView(event.target as IView);
				
				/**
				 * 선택 가능한 위치일 경우에만 선택되도록
				 */
				if (ctrl.canSelect(event.localX, event.localY)) {
					// 메뉴핸들을 표시한다.
					//if (!editor.readOnly)
					//	_menuHandle.controller = ctrl.canPopUp ? ctrl : null;
						
					
					/*
					 * 기존에 선택된 개체가 아니면 선택 처리를 한다.
					 */
					if (!editor.selectionManager.contains(ctrl)) {
						if (ctrl) {
							// 에디터가 복수선택 가능하고, 쉬프트나 컨트롤키가 눌린 상태여야 복수 선택 가능하다.
							if (!editor.multiSelecatble || !(event.shiftKey || event.ctrlKey))
								selManager.clear();
								
							selManager.add(ctrl);
							
							if (!editor.readOnly)
								_dragTracker = new MoveTracker(ctrl);
						} 
						else {
							selManager.clear();
						}
					} 
					/**
					 * 이미 선택된 상태라면
					 * 1. 텍스트 편집 상태로 진입해야 할 위치를 클릭한 경우라면 편집 시작
					 * 2. 이동 트래킹 시작
					 */
					else {
						/* 일단 막는다.
						if (selManager.uniqueSelected == ctrl && !editor.readOnly &&
						    ctrl is ITextEditable && ITextEditable(ctrl).canModifyText()) {
							showEditor(ctrl);
							
						} else*/ {
							if (!editor.readOnly)
								_dragTracker = new MoveTracker(ctrl);
						}
					}
				} else {
					selManager.clear();
					
					// 자식들 선택
					_dragTracker = ctrl.getSelectTracker(event.localX, event.localY);
				}
				
			} 
			else if (event.target is IDraggableHandle) {
				if (!editor.readOnly) {
					var handle: IDraggableHandle = event.target as IDraggableHandle;
					_dragTracker = handle.getDragTracker();
				}
								
			} 
			else {
				selManager.clear();
				_dragTracker = new SelectTracker(editor.rootController);
			}
			
			// 하위 클래스에서 tracker를 생성할 기회를 준다.
			if (_dragTracker == null) {
				_dragTracker = getDragTracker(event);
			}
			
			if (_dragTracker) {
				_dragTracker.activate();
				_dragTracker.mouseDown(event);
			}
		}
		
		protected function getDragTracker(event: MouseEvent): DragTracker {
			return null;
		}
		
		override public function mouseMove(event: MouseEvent): void {
			super.mouseMove(event);
			handleMouseMove(event);
		}
		
		protected function handleMouseMove(event: MouseEvent): void {
			if (dragTracker) {
				dragTracker.mouseMove(event);
				_menuHandle.controller = null;
			} 
		}

		override public function mouseUp(event: MouseEvent): void {
			super.mouseUp(event);
			handleMouseUp(event);
			CursorManager.removeAllCursors();
		}

		protected function handleMouseUp(event: MouseEvent): void {
			if (dragTracker) {
				dragTracker.mouseUp(event);
				dragTracker.deactivate();
				_dragTracker = null;
			}
		}
		
		override public function mouseOver(event: MouseEvent): void {
			super.mouseOver(event);
			handleMouseOver(event);
		}
		
		protected function handleMouseOver(event: MouseEvent): void {
		}
		
		override public function mouseOut(event: MouseEvent): void {
			super.mouseOut(event);
			handleMouseOut(event);
		}

		protected function handleMouseOut(event: MouseEvent): void {
		}

		override protected function acceptAbort(): Boolean {
			if (hideEditor(false))
				return false;
				
			return true;
		}

		override public function keyDown(event: KeyboardEvent): void {
			super.keyDown(event);
			handleKeyDown(event);
		}
		
		protected function handleKeyDown(event: KeyboardEvent): void {
			
			var shift: Boolean = event.ctrlKey;
			
			switch (event.keyCode) {
				case Keyboard.DELETE:
					if (!editor.readOnly && event.target != inlineEditor && event.target.parent != inlineEditor) {
						deleteSelection();
					}
					break; 
				
				case Keyboard.RIGHT:
					if (!editor.readOnly)
						moveSelection(shift ? 1 : editor.editConfig.gridSizeX, 0);						
					break;

				case Keyboard.LEFT:
					if (!editor.readOnly)
						moveSelection(shift ? -1 : -editor.editConfig.gridSizeX, 0);						
					break;

				case Keyboard.DOWN:
					if (!editor.readOnly)
						moveSelection(0, shift ? 1 : editor.editConfig.gridSizeY);						
					break;

				case Keyboard.UP:
					if (!editor.readOnly)
						moveSelection(0, shift ? -1 : -editor.editConfig.gridSizeY);						
					break;
					
				case Keyboard.ENTER:
					if (event.target == inlineEditor || event.target.parent == inlineEditor) {
						hideEditor(true);
					}
					break;
					
				case Keyboard.F2:
					if (!editor.readOnly && selManager.count == 1 && selManager.getItemAt(0) is ITextEditable) {
						/*if (inlineEditor.visible) {
							hideEditor(true);
						} else*/ if (ITextEditable(selManager.getItemAt(0)).canModifyText()) {
							showEditor(selManager.getItemAt(0));
						}
					}
					break;
			}
		}
		
		override public function keyUp(event: KeyboardEvent): void {
			super.keyUp(event);
			handleKeyUp(event);	
		}
		
		protected function handleKeyUp(event: KeyboardEvent): void {
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		

		public function get menuHandle(): SelectionMenuHandle {
			return _menuHandle;
		}

		//----------------------------------------------------------------------
		// Internal properties
		//----------------------------------------------------------------------

		protected function get inlineEditor(): InlineEditor {
			if (!_inlineEditor) {
				_inlineEditor = new InlineEditor(editor);
				_inlineEditor.visible = false;
				editor.addChild(_inlineEditor);
			}
			
			return _inlineEditor;
		}


		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
	
		protected function clearSelection(): void {
			_menuHandle.controller = null;
			editor.clearSelection();
		}
		
		protected function deleteSelection(): void {
			_menuHandle.controller = null;
			editor.deleteSelection();			
		}
		
		protected function moveSelection(dx: int, dy: int): void {
			editor.moveSelection(dx, dy);
		}
		
		protected function showEditor(source: Object): Boolean {
			if (source is ITextEditable) {
				return inlineEditor.show(source as ITextEditable);
			}
			
			return true;
		}
		
		protected function hideEditor(accept: Boolean = true): Boolean {
			return inlineEditor.hide(accept);		
		}
	}
}