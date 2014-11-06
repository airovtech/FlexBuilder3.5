////////////////////////////////////////////////////////////////////////////////
//  SelectTracker.as
//  2007.12.31, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
//
//  Addio 2007 !! 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.editor.tool
{
	import com.maninsoft.smart.modeler.command.Command;
	import com.maninsoft.smart.modeler.controller.Controller;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * editor 바탕과 하위 개체 선택이 가능한 개체에서 
	 * 마우스를 드래깅하여 복수 개체를 선택하는 tracker
	 */
	public class SelectTracker extends ControllerDragTracker {

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _view: Sprite;
		private var _rect: Rectangle;
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function SelectTracker(controller: Controller) {
			super(controller);
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override protected function startDrag(target: Object): Boolean {
			_view = new Sprite();
			renderView();
			editor.addChild(_view);
			
			return true;
		}
		
		override protected function drag(target: Object): Boolean {
			renderView();
			
			return true;
		}

		override protected function endDrag(target: Object): Boolean {
			_rect = _view.getBounds(editor);
			editor.removeChild(_view);
			_view = null;
			
			return true;
		}
		
		override protected function performCompleted(): void {
			_rect = controller.controllerToEditorRect(_rect);
			var list: Array = controller.findControllersByRect(_rect);
			editor.selectionManager.addList(list);
		}
		
		override protected function performCanceled(): void {
		}

		override protected function getCommand(): Command {
			return null;
		}

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		private function renderView(): void {
			var g: Graphics = _view.graphics;
			
			g.clear();
			
			g.beginFill(0xffffff, 0);
			g.lineStyle(2, 0x000000, 0.5);
			g.drawRect(startX*editor.zoom/100, startY*editor.zoom/100, offsetX*editor.zoom/100, offsetY*editor.zoom/100);
			g.endFill();
		}
	}
}