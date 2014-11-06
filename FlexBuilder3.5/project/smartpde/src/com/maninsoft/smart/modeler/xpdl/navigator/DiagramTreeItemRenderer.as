////////////////////////////////////////////////////////////////////////////////
//  DiagramTreeItemRenderer.as
//  2008.03.04, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.navigator
{
	import flash.display.Graphics;
	import flash.text.TextFormat;
	
	import mx.controls.treeClasses.TreeItemRenderer;
	
	/**
	 * DiagramTree를 위한 ItemRenderer
	 * ContextMenu click 시 클릭된 renderer를 찾아내기 위해.
	 * 기본 TreeItemRenderer는 Indent된 왼쪽 부분을 채우지 않는다. 
	 */
	public class DiagramTreeItemRenderer extends TreeItemRenderer {
		
		private static var _newActFormat: TextFormat = new TextFormat(null, null, 0xffffff, false);
		private static var _newLaneFormat: TextFormat = new TextFormat(null, null, 0xbbbbbb, false);
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function DiagramTreeItemRenderer()	{
			super();
		}

		
		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			/*
			 * renderer 전체를 채운다.
			 */
			var g: Graphics = this.graphics;
			g.clear();
			
			g.beginFill(0, 0);
			g.drawRect(0, 0, width, height);
			g.endFill();

			super.updateDisplayList(unscaledWidth, unscaledHeight);
		
			if (data is DiagramTreeProxy) {
				label.setTextFormat(DiagramTreeProxy(data).isLaneProxy ? _newLaneFormat : _newActFormat);
				label.x += 10;
			}	
		}
	}
}