package com.maninsoft.smart.formeditor.refactor.simple.navigator
{
	import flash.display.Graphics;
	import flash.text.TextFormat;
	
	import mx.controls.treeClasses.TreeItemRenderer;
	
	public class FormSchemaTreeItemRenderer extends TreeItemRenderer
	{
		private static var _proxyFormat: TextFormat = new TextFormat(null, null, 0xbbbbbb, false);
		
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
		
			if (data is FormItemProxy) {
				label.setTextFormat(_proxyFormat);
			}	
		}
	}
}