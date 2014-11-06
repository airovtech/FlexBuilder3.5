////////////////////////////////////////////////////////////////////////////////
//  DragTracker.as
//  2007.12.22, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.editor.tool
{
	import com.maninsoft.smart.modeler.command.Command;
	import com.maninsoft.smart.modeler.editor.DiagramEditor;
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import mx.managers.CursorManager;
	
	/**
	 * 에디터 배경 영역이나, 선택된 개체들, 선택핸들 등을 마우스로 
	 * 드래깅하는 Life-cycle을 처리하는 기본 클래스.
	 * 각 경우에 따라 override 되야 한다.
	 */
	public class DragTracker extends AbstractTool {
		
		//----------------------------------------------------------------------
		// Class constants
		//----------------------------------------------------------------------
		
		public static const DRAG_THRESHOLD: int = 3;
		
		public static const STATE_READY		: int = 0;
		public static const STATE_DRAGGING	: int = 1;
		public static const STATE_COMPLETED	: int = 2;
		public static const STATE_CANCELED	: int = 3;
		
		// startDrag에서 false가 리턴되어 다시 마우스를 클릭할 때 까지는 트래킹하지 않음
		public static const STATE_INVALID		: int = 4;
		
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _state: int = STATE_READY;
		
		private var _startX: int;
		private var _startY: int;
		private var _currentX: int;
		private var _currentY: int;
		protected var _abnormalDrag:Boolean=false;
		

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function DragTracker(editor: DiagramEditor) {
			super(editor);
		}
		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		// ITool
		//----------------------------------------------------------------------
		
		override public function activate(): void {
			super.activate();
		}
		
		override public function deactivate(): void {
			super.deactivate();
		}
		
		override public function mouseDown(event: MouseEvent): void {
			super.mouseDown(event);
			
			_state = STATE_READY;
			
			_startX = editor.zoomedX; 
			_startY = editor.zoomedY; 
			_currentX = editor.zoomedX;
			_currentY = editor.zoomedY;
			_abnormalDrag = false;
									
			event.updateAfterEvent();
		}
		
		override public function mouseMove(event: MouseEvent): void {
			super.mouseMove(event);

			if(!event.buttonDown && (state == STATE_READY || state == STATE_DRAGGING)){
				_abnormalDrag = true;
				mouseUp(event);
				return;
			}
			
			_currentX = editor.zoomedX;
			_currentY = editor.zoomedY;

			if (state == STATE_READY && event.buttonDown) {
				if (movedThreshold(editor.zoomedX, editor.zoomedY)) {
					if (startDrag(event.target)) {
						_state = STATE_DRAGGING;
					} else {
						_state = STATE_INVALID;
					}	
				}
			} else if (state == STATE_DRAGGING) {
				drag(event.target);
			}
			
			event.updateAfterEvent();
		}

		override public function mouseUp(event: MouseEvent): void {
			super.mouseUp(event);
			
			if(!_abnormalDrag){
				_currentX = editor.zoomedX;
				_currentY = editor.zoomedY;
			}else{
				CursorManager.removeAllCursors();				
			}

			// 상태 기계로서 반드시 이전 상태를 체크한다.
			if (_state == STATE_DRAGGING) { 
				if (endDrag(event.target)) {
					_state = STATE_COMPLETED;
					
					var cmd: Command = getCommand();
					
					if (cmd)
						executeCommand(cmd);
					
					performCompleted();
					
				} else {
					_state = STATE_CANCELED;
					performCanceled();
				}
			}
			// drag & drop 이벤트 발생하는 부분이다. 1.mouseDown, 2.mouseMove, 3.mouseUp 중에 3번에 해당된다.
			// updateDisplayList가 실행되도록 invalidateDisplayList을 호출한다. 2009.02.04 sjyoon
			editor.invalidateDisplayList();
			event.updateAfterEvent();
		}

		override public function mouseOut(event: MouseEvent): void {
			super.mouseOut(event);
			if(event.buttonDown) mouseUp(event);
		}

		override public function keyDown(event: KeyboardEvent): void {
			super.keyDown(event);
		}
		
		override public function keyUp(event: KeyboardEvent): void {
			super.keyUp(event);
		}
		
		
		//----------------------------------------------------------------------
		// Abstract methods
		//----------------------------------------------------------------------
		
		/**
		 * 드래깅을 시작한다.
		 */
		protected function startDrag(target: Object): Boolean {
			return false;
		}
		
		/**
		 * 드래깅한다.
		 */
		protected function drag(target: Object): Boolean {
			return true;
		}

		/**
		 * 드래깅한다.
		 */
		protected function endDrag(target: Object): Boolean {
			return true;
		}

		/**
		 * 드래그가 정상적으로 종료된 후 처리
		 */		
		protected function performCompleted(): void {
		}

		/**
		 * 드래그가 취소된 후 처리
		 */		
		protected function performCanceled(): void {
		}
		
		/**
		 * 드래그 완료 후 실행할 커맨드를 리턴한다.
		 */
		protected function getCommand(): Command {
			return null;
		}

		//----------------------------------------------------------------------
		// Internal properties
		//----------------------------------------------------------------------
		
		protected function get state(): int {
			return _state;
		}
		
		protected function set state(value: int): void {
			_state = value;
		}
		
		protected function get startX(): int {
			return _startX;
		}
		
		protected function set startX(value: int): void {
			_startX = value;
		}
		
		protected function get startY(): int {
			return _startY;
		}
		
		protected function set startY(value: int): void{
			_startY = value;
		}
		
		protected function get currentX(): int {
			return _currentX;
		}
		
		protected function set currentX(value: int): void {
			_currentX = value;
		}
		
		protected function get currentY(): int {
			return _currentY;
		}
		
		protected function set currentY(value: int): void {
			_currentY = value;
		}
		
		protected function get offsetX(): int {
			return currentX - startX;
		}
		
		protected function get offsetY(): int {
			return currentY - startY;
		}
		

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		protected function movedThreshold(x: int, y: int): Boolean {
			return Math.abs(startX - x) > DRAG_THRESHOLD ||
			        Math.abs(startY - y) > DRAG_THRESHOLD;
		}
		
		protected function getFeedbackLayer(): Sprite {
			return editor.getFeedbackLayer();
		}
	}
}