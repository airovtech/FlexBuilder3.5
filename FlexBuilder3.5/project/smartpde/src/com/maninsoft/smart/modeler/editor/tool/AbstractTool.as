////////////////////////////////////////////////////////////////////////////////
//  AbstractTool.as
//  2007.12.24, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.editor.tool
{
	import com.maninsoft.smart.modeler.command.Command;
	import com.maninsoft.smart.modeler.editor.DiagramEditor;
	import com.maninsoft.smart.modeler.editor.ITool;
	import com.maninsoft.smart.modeler.editor.SelectionManager;
	
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	/**
	 * Base ITool
	 */
	public class AbstractTool extends EventDispatcher implements ITool {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _editor: DiagramEditor;


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function AbstractTool(editor: DiagramEditor) {
			super();
			
			_editor = editor;
		}
		
		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		public function get editor(): DiagramEditor {
			return _editor;
		}
		
		
		//----------------------------------------------------------------------
		// ITool
		//----------------------------------------------------------------------

		public function activate(): void {
			
		}
		
		public function deactivate(): void {
			
		}
		
		public function keyDown(event: KeyboardEvent): void {
			if (event.keyCode == Keyboard.ESCAPE) {
				if (acceptAbort()) {
					editor.resetTool();
				}
			}
		}
		
		public function keyUp(event: KeyboardEvent): void {
			
		}
		
		public function click(event: MouseEvent): void {
			
		}
		
		public function doubleClick(event: MouseEvent): void {
			
		}
		
		public function mouseDown(event: MouseEvent): void {
			
		}
		
		public function mouseMove(event: MouseEvent): void {
			
		}
		
		public function mouseUp(event: MouseEvent): void {
		}
		
		public function mouseOver(event: MouseEvent): void {
			
		}
		
		public function mouseOut(event: MouseEvent): void {
		}
		
		
		//----------------------------------------------------------------------
		// Virtual methods
		//----------------------------------------------------------------------
		
		protected function acceptAbort(): Boolean {
			return true;
		}


		//----------------------------------------------------------------------
		// Internal properties
		//----------------------------------------------------------------------
		
		protected function get selManager(): SelectionManager {
			return _editor.selectionManager;
		}
		
		protected function get selectedItems(): Array {
			return _editor.selectionManager.items;
		}
		
		protected function get feedbackLayer(): Sprite {
			return _editor.getFeedbackLayer();
		}
		
		
		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		protected function executeCommand(cmd: Command): void{
			_editor.execute(cmd);
		}
		
	}
}