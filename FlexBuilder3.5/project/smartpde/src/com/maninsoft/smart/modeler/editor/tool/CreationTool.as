////////////////////////////////////////////////////////////////////////////////
//  CreationTool.as
//  2008.01.01, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
//
//  Welcome 2008 !!
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.editor.tool
{
	import com.maninsoft.smart.modeler.controller.NodeController;
	import com.maninsoft.smart.modeler.editor.DiagramEditor;
	import com.maninsoft.smart.modeler.editor.events.CreateNodeRequestEvent;
	import com.maninsoft.smart.modeler.model.Node;
	import com.maninsoft.smart.modeler.view.IView;
	import com.maninsoft.smart.modeler.view.NodeView;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 에디터나 부모 노드이 바탕을 드래깅하여 자식 노드를 생성하는 툴
	 */
	public class CreationTool extends AbstractTool {

		//----------------------------------------------------------------------
		// Class constans
		//----------------------------------------------------------------------
		
		private static const STATE_READY		: int = 0;
		private static const STATE_DRAGGING 	: int = 1;
		private static const STATE_COMPLETED 	: int = 2;
		private static const STATE_CANCELED 	: int = 3;
		

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _state: int;
		
		private var _startX: int;
		private var _startY: int;
		private var _currentX: int;
		private var _currentY: int;
		private var _view: Sprite;
		
		private var _creationController: NodeController;
		private var _creationType: String;


		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function CreationTool(editor: DiagramEditor) {
			super(editor);
		}		
		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		public function get creationType(): String {
			return _creationType;
		}
		
		public function set creationType(value: String): void {
			_creationType = value;
		}
		

		//----------------------------------------------------------------------
		// Overriden methods
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
			_creationController = null;

			if (event.target is NodeView) {
				_creationController = editor.findControllerByView(event.target as IView) as NodeController;				
			} else {
				_creationController = editor.rootController.nodeController as NodeController;
			}
			
			if (_creationController) {
				_startX = editor.zoomedX; 
				_startY = editor.zoomedY; 
				_currentX = editor.zoomedX;
				_currentY = editor.zoomedY;
				
				if (!_view) {
					_view = new Sprite();
				}
				
				renderView();
				editor.addChild(_view);
				
				_state = STATE_DRAGGING;
			}
		}

		override public function mouseMove(event: MouseEvent): void {
			super.mouseMove(event);

			if (_state == STATE_DRAGGING) {
				_currentX = editor.zoomedX;
				_currentY = editor.zoomedY;
				
				renderView();
			}
		}

		override public function mouseUp(event: MouseEvent): void {
			super.mouseUp(event);

			if (_state == STATE_DRAGGING) {
				_currentX = editor.zoomedX;
				_currentY = editor.zoomedY;
			
				editor.removeChild(_view);
				
				var p: Point = new Point(startX, startY);
				p = _creationController.editorToController(p);
				
				editor.dispatchEvent(new CreateNodeRequestEvent(_creationController.model as Node, _creationType, _creationController, 
														 new Rectangle(p.x, p.y, offsetX, offsetY))); 
			}
		}

		override public function keyDown(event: KeyboardEvent): void {
			super.keyDown(event);
		}
		
		override public function keyUp(event: KeyboardEvent): void {
			super.keyUp(event);	
		}

		//----------------------------------------------------------------------
		// Internal properties
		//----------------------------------------------------------------------
		
		protected function get startX(): int {
			return _startX;
		}
		
		protected function get startY(): int {
			return _startY;
		}
		
		protected function get currentX(): int {
			return _currentX;
		}
		
		protected function get currentY(): int {
			return _currentY;
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
		
		protected function getFeedbackLayer(): Sprite {
			return editor.getFeedbackLayer();
		}
		
		private function renderView(): void {
			var g: Graphics = _view.graphics;
			
			g.clear();
			
			g.beginFill(0xffffff, 0);
			g.lineStyle(2, 0x000000, 0.5);
			g.drawRect(startX, startY, offsetX, offsetY);
			g.endFill();
		}
	}
}