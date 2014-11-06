////////////////////////////////////////////////////////////////////////////////
//  HandGripTool.as
//  2008.04.01, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////


package com.maninsoft.smart.modeler.editor.tool
{
	import com.maninsoft.smart.modeler.controller.Controller;
	import com.maninsoft.smart.modeler.editor.DiagramEditor;
	import com.maninsoft.smart.modeler.view.IView;
	import com.maninsoft.smart.modeler.xpdl.view.PoolView;
	import com.maninsoft.smart.modeler.xpdl.view.TaskApplicationView;
	import com.maninsoft.smart.modeler.assets.HandGripToolAssets;
	
	import flash.events.MouseEvent;
	
	/**
	 * 손바닥을 이용 다이어그램을 스클롤링 하는 툴
	 */
	public class HandGripTool extends AbstractTool {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _handGripCursor: Class = HandGripToolAssets.handGripCursor;
		
		private var _handOpenCursor: Class = HandGripToolAssets.handOpenCursor;
		
		private var _handCursor: Number = 0;
		
		private var _dragging: Boolean = false;
		private var _currentX: Number;
		private var _currentY: Number;


		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function HandGripTool(editor: DiagramEditor) {
			super(editor);
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function activate(): void {
			super.activate();

			//_handCursor = CursorManager.setCursor(_handOpenCursor);
		}

		override public function deactivate(): void {
			super.deactivate();

			//CursorManager.removeCursor(_handCursor);
			//_handCursor = 0;
			editor.selectionManager.clear();
		}

		override public function mouseDown(event: MouseEvent): void {
			super.mouseDown(event);
			
			if(event.target is TaskApplicationView || event.target is PoolView){
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
						} 
						else {
							selManager.clear();
						}
					} 
				}else{
					_currentX = editor.zoomedX;
					_currentY = editor.zoomedY;
					_dragging = true;
				} 
			}else{
				//CursorManager.removeCursor(_handCursor);
				//_handCursor = CursorManager.setCursor(_handGripCursor);
				_currentX = editor.zoomedX;
				_currentY = editor.zoomedY;
				_dragging = true;
			}
		}
		
		override public function mouseMove(event: MouseEvent): void {
			super.mouseMove(event);

			if (_dragging) {
				editor.scrollBy((editor.zoomedX - _currentX) / 2, (editor.zoomedY - _currentY) / 2);
	
				_currentX = editor.zoomedX;
				_currentY = editor.zoomedY;
			}
		}

		override public function mouseUp(event: MouseEvent): void {
			_dragging = false;			
			//CursorManager.removeCursor(_handCursor);
			//_handCursor = CursorManager.setCursor(_handOpenCursor);

			super.mouseUp(event);
		}
	}
}