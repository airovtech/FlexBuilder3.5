////////////////////////////////////////////////////////////////////////////////
//  ViewIcon.as
//  2008.01.15, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.view
{
	import com.maninsoft.smart.modeler.editor.DiagramEditor;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.controls.ToolTip;
	import mx.managers.ToolTipManager;
	
	/**
	 * Sprite로 구현되는 IViewIcon base
	 */
	public class ViewIcon extends Sprite implements IViewIcon {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _view: IView;
		private var _tip: ToolTip;
		private var _viewBoolean:Boolean = true;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function ViewIcon(view: IView) {
			super();
			
			_view = view;
			
			addEventListener(MouseEvent.CLICK, doClick);
			addEventListener(MouseEvent.MOUSE_OVER, doMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, doMouseOut);
			
			draw(this.graphics);
		}


		//----------------------------------------------------------------------
		// IViewIcon
		//----------------------------------------------------------------------
		
		public function get view(): IView {
			return _view;
		}
		
		public function get toolTip(): String {
			return "toolTip?";		
		}
		
		//----------------------------------------------------------------------
		// _viewBoolean
		//----------------------------------------------------------------------
		
		public function get viewBoolean():Boolean{
			return _viewBoolean;
		}
		
		public function set viewBoolean(bool:Boolean):void{
			 _viewBoolean = bool;
		}


		//----------------------------------------------------------------------
		// Virtual methods
		//----------------------------------------------------------------------
		
		protected function draw(g: Graphics): void {
			g.clear();
			g.lineStyle(1, 0);
			g.beginFill(0x000000);
			g.drawCircle(5, 5, 5);
			g.endFill();
		}

		/**
		 * 이 Icon이 클릭됐을 때 실행
		 */
		protected function execute(): void {
		}
		
		/**
		 * parent인 view의 doIconClick을 호출할 때 넘겨줄 추가 정보
		 */
		protected function getClickData(event: MouseEvent): Object {
			return null;
		}


		//----------------------------------------------------------------------
		// Internal properties
		//----------------------------------------------------------------------
		
		protected function get editor(): DiagramEditor {
			var p: DisplayObject = this.parent;
			
			while (p && !(p is DiagramEditor)) {
				p = p.parent;
			}
			
			return p as DiagramEditor;
		}


		//----------------------------------------------------------------------
		// Event handlers
		//----------------------------------------------------------------------
		
		protected function doClick(event: MouseEvent): void {
			if(_viewBoolean){
				execute();
				if (_view)
					_view.doIconClick(this, getClickData(event));
			}
		}

		protected function doMouseOver(event: MouseEvent): void {
			if(_viewBoolean){
				_tip = ToolTipManager.createToolTip(toolTip, event.stageX + 10, event.stageY) as ToolTip;
			}	
		}

		protected function doMouseOut(event: MouseEvent): void {
			if(_viewBoolean){
				ToolTipManager.destroyToolTip(_tip);
				_tip = null;
			}
		}
	}
}