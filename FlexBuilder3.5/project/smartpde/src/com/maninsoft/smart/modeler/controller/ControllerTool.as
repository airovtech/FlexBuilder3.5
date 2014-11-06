////////////////////////////////////////////////////////////////////////////////
//  ControllerHandler.as
//  2007.12.31, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
//
//  Addio 2007 !! 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.controller
{
	import com.maninsoft.smart.modeler.command.Command;
	import com.maninsoft.smart.modeler.command.UnexecutableCommand;
	import com.maninsoft.smart.modeler.editor.DiagramEditor;
	import com.maninsoft.smart.modeler.editor.SelectionManager;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.controls.ToolTip;
	import mx.managers.ToolTipManager;
	
	/**
	 * Abstract IControllerHandler
	 */
	public class ControllerTool extends Sprite implements IControllerTool {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _controller: Controller;
		private var _toolTip: String;
		
		private var _tip: ToolTip;
		

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Construtor */
		public function ControllerTool(controller: Controller, toolTip: String = null) {
			super();
			
			_controller = controller;
			_toolTip = toolTip;
			
			addEventListener(MouseEvent.CLICK, doClick);
			addEventListener(MouseEvent.MOUSE_OVER, doMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, doMouseOut);
			
			draw();
		}


		//----------------------------------------------------------------------
		// IControllerHandle
		//----------------------------------------------------------------------

		public function get controller(): Controller {
			return _controller;
		}

		public function get enabled(): Boolean {
			return true;
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		public function get editor(): DiagramEditor {
			return controller.editor;
		}
		
		public function get selManager(): SelectionManager {
			return editor.selectionManager;
		}
		
		public function get toolTip(): String {
			return _toolTip;
		}


		//----------------------------------------------------------------------
		// Virtual properties
		//----------------------------------------------------------------------

		/**
		 * 이 핸들이 실행하는 커맨드
		 */
		protected function getCommand(): Command {
			return null;
		}


		//----------------------------------------------------------------------
		// Virtual methods
		//----------------------------------------------------------------------

		/**
		 * 이 버튼이 클릭됐을 때 getCommand()가 null을 리턴하면 이 함수를 call
		 */
		protected function execute(): void {
		}


		//----------------------------------------------------------------------
		// Internal properties
		//----------------------------------------------------------------------

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------

		protected function draw(): void {
		}


		//----------------------------------------------------------------------
		// Event handlers
		//----------------------------------------------------------------------
		
		protected function doClick(event: MouseEvent): void {
			execute();

			var cmd: Command = getCommand();
			
			if (cmd)
				editor.execute(cmd);
		}

		protected function doMouseOver(event: MouseEvent): void {
			//_tip = ToolTipManager.createToolTip(toolTip, event.target.x + event.target.width + 10,
			//									event.target.y) as ToolTip;	
			
			
			_tip = ToolTipManager.createToolTip(toolTip, event.stageX + 20, event.stageY + 5) as ToolTip;	
			_tip.setStyle("fontWeight", "bold");		
		}

		protected function doMouseOut(event: MouseEvent): void {
			ToolTipManager.destroyToolTip(_tip);
			_tip = null;
		}
	}
}