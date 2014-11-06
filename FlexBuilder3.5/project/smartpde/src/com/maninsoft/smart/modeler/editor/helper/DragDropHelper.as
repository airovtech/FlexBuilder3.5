////////////////////////////////////////////////////////////////////////////////
//  DragDropHelper.as
//  2007.12.15, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.editor.helper
{
	import com.maninsoft.smart.modeler.editor.DiagramEditor;
	import com.maninsoft.smart.modeler.request.NodeCreationRequest;
	
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	/**
	 * Drag and Drop helper
	 */
	public class DragDropHelper {

		//----------------------------------------------------------------------
		// Internal variables
		//----------------------------------------------------------------------
		
		private var _editor: DiagramEditor;
		
		private var _startX: int;
		private var _startY: int;
		private var _offsetX: int;
		private var _offsetY: int;

		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function DragDropHelper(editor: DiagramEditor) {
			super();
			
			_editor = editor;
			
			// for dropTarget
			editor.addEventListener(DragEvent.DRAG_ENTER, doDragEnter);
			editor.addEventListener(DragEvent.DRAG_DROP, doDragDrop);
		}
		

		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		
		public function start(x: int, y: int): void {
			_startX = x;
			_startY = y;
			_offsetX = 0;
			_offsetY = 0;
			
			//_editor.stage.addEventListener(MouseEvent.MOUSE_MOVE, 
		}
		
		public function move(x: int, y: int): void {
			_offsetX = x - _startX;
			_offsetY = y = _startY;
		}

		public function stop(x: int, y: int): void{
			_offsetX = x - _startX;
			_offsetY = y = _startY;
		}		
		

		//----------------------------------------------------------------------
		// Event handlers
		//----------------------------------------------------------------------
		
		protected function doDragEnter(event: DragEvent): void {
			trace("DragDropHelper: " + event.toString());
			
			if (event.dragSource.hasFormat("paletteItem")) {
				DragManager.acceptDragDrop(_editor);
			}
		}
		
		protected function doDragDrop(event: DragEvent): void {
			if (event.dragSource.hasFormat("paletteItem")) {
				
				/*
				var node: Node = new Node();
				node.x = event.localX;
				node.y = event.localY;
				node.width = 100;
				node.height = 100;

				_editor.execute(new NodeCreateCommand(_editor.diagram.root, node));
				*/
				var type: String = String(event.dragSource.dataForFormat("paletteItem"));
				var req: NodeCreationRequest = new NodeCreationRequest(type, event.localX, event.localY);
				_editor.executeRequest(req);
			}		
		}
	}
}