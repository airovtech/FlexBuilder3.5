////////////////////////////////////////////////////////////////////////////////
//  ComponentUtils.as
//  2007.12.14, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.common
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * Graphic Utilites
	 */
	public class GraphicUtils	{
		
		public static function drawRect(g: Graphics, 
		                                   x: int, y: int, width: int, height: int,
										   fillColor: uint = 0xffff00, 
										   lineWidth: int = 0, 
										   lineColor: uint = 0): void {
			g.lineStyle(lineWidth, lineColor);
			g.beginFill(fillColor);
			g.drawRect(x, y, width, height);
			g.endFill();
		}
		
		public static function drawCircle(g: Graphics, 
		                                    x: int, y: int, width: int, height: int,
											fillColor: uint = 0xffff00, 
											lineWidth: int = 0, 
											lineColor: uint = 0): void {
			var sz: int = Math.min(width, height) / 2;
			
			g.lineStyle(lineWidth, lineColor);
			g.beginFill(fillColor);
			g.drawCircle(x + sz, y + sz, sz);
			g.endFill();
		}
		
		public static function drawDiamond(g: Graphics,
									          x: int, y: int, width: int, height: int,
									          fillColor: uint = 0xffff00,
									          lineWidth: int = 0,
									          lineColor: uint = 0): void {
			g.lineStyle(lineWidth, lineColor);
			//g.beginGradientFill(GradientType.LINEAR, [0xffffff, model.fillColor], [100, 100], [0x00, 0xff]);
			g.beginFill(fillColor);

			g.moveTo(width / 2, 0);
			g.lineTo(width, height / 2);
			g.lineTo(width / 2, height);
			g.lineTo(0, height / 2);
			g.lineTo(width / 2, 0);
			
			g.endFill();
		}
		
		public static function drawRoundRect(g: Graphics, x: int, y: int, width: int, height: int, edge: int): void {
			g.moveTo(x, y + edge);
			g.lineTo(x + edge, y);
			g.lineTo(x + width - edge - 1, y);
			g.lineTo(x + width - 1, y + edge);
			g.lineTo(x + width - 1, y + height - edge - 1);
			g.lineTo(x + width - edge, y + height - 1);
			g.lineTo(x + edge, y + height - 1);
			g.lineTo(x, y + height - edge - 1);
			g.lineTo(x, y + edge);
		}

		
		public static function drawDashedRoundRect(g: Graphics, x: int, y: int, width: int, height: int, edge: int): void {
			drawDashedLine2(g, new Point(x, y + edge), new Point(x + edge, y));
			drawDashedLine2(g, new Point(x + edge, y), new Point(x + width - edge - 1, y));
			drawDashedLine2(g, new Point(x + width - edge - 1, y), new Point(x + width - 1, y + edge));
			drawDashedLine2(g, new Point(x + width - 1, y + edge), new Point(x + width - 1, y + height - edge - 1));
			drawDashedLine2(g, new Point(x + width - 1, y + height - edge - 1), new Point(x + width - edge - 1, y + height - 1));
			drawDashedLine2(g, new Point(x + width - edge - 1, y + height - 1), new Point(x + edge, y + height - 1));
			drawDashedLine2(g, new Point(x + edge, y + height - 1), new Point(x, y + height - edge - 1));
			drawDashedLine2(g, new Point(x, y + height - edge - 1), new Point(x, y + edge));
			
		}
		
		public static function drawDashedLine2(g: Graphics, start: Point, end: Point,	
			segSize: Number = 4, segGab: Number = 2): void {
			var segLen: Number;
			var deltax: Number;
			var deltay: Number;
			var delta: Number;
			var radians: Number;
			var segCount: Number;
			var cx: Number;
			var cy: Number;
			
			segLen = segSize + segGab;
			deltax = end.x - start.x;
			deltay = end.y - start.y;
			delta = Math.sqrt(deltax * deltax + deltay * deltay);
			segCount = Math.floor(Math.abs(delta / segLen));
			radians = Math.atan2(deltay, deltax);
			
			cx = start.x;
			cy = start.y;
			
			deltax = Math.cos(radians) * segLen;
			deltay = Math.sin(radians) * segLen;
			
			for (var n: int = 0; n < segCount; n++) 
			{
				g.moveTo(cx, cy);
				g.lineTo(cx + Math.cos(radians) * 5, cy + Math.sin(radians) * segSize);
				cx += deltax;
				cy += deltay;
			}
			
			g.moveTo(cx, cy);
			
			delta = Math.sqrt((end.x - cx) * (end.x - cx) + (end.y - cy) * (end.y - cy));
			
			if(delta > segSize) {
				g.lineTo(cx + Math.cos(radians) * segSize, cy + Math.sin(radians) * segSize);
			} else if(delta > 0) {
				g.lineTo(cx + Math.cos(radians) * delta, cy + Math.sin(radians) * delta);
			}
			
			g.moveTo(end.x, end.y);
		}

		public static function drawDashedLine(line: Sprite, start: Point, end: Point,	
			segSize: Number = 4, segGab: Number = 2): void {
			var segLen: Number;
			var deltax: Number;
			var deltay: Number;
			var delta: Number;
			var radians: Number;
			var segCount: Number;
			var cx: Number;
			var cy: Number;
			
			segLen = segSize + segGab;
			deltax = end.x - start.x;
			deltay = end.y - start.y;
			delta = Math.sqrt(deltax * deltax + deltay * deltay);
			segCount = Math.floor(Math.abs(delta / segLen));
			radians = Math.atan2(deltay, deltax);
			
			cx = start.x;
			cy = start.y;
			
			deltax = Math.cos(radians) * segLen;
			deltay = Math.sin(radians) * segLen;
			
			for (var n: int = 0; n < segCount; n++) 
			{
				line.graphics.moveTo(cx, cy);
				line.graphics.lineTo(cx + Math.cos(radians) * 5, cy + Math.sin(radians) * segSize);
				cx += deltax;
				cy += deltay;
			}
			
			line.graphics.moveTo(cx, cy);
			
			delta = Math.sqrt((end.x - cx) * (end.x - cx) + (end.y - cy) * (end.y - cy));
			
			if(delta > segSize) {
				line.graphics.lineTo(cx + Math.cos(radians) * segSize, cy + Math.sin(radians) * segSize);
			} else if(delta > 0) {
				line.graphics.lineTo(cx + Math.cos(radians) * delta, cy + Math.sin(radians) * delta);
			}
			
			line.graphics.moveTo(end.x, end.y);
		}

	}
}