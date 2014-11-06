package com.maninsoft.smart.ganttchart.util
{
	import flash.display.Graphics;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	import mx.controls.Alert;

    public class GraphicsUtil
    {       
		public static function TriangleBox(pentagonBox:Canvas, g:Graphics):void{
			
			pentagonBox.height=7;
			pentagonBox.width=10;

   			g.clear();
			g.lineStyle(1, 0x66A0E5, 1);
           	g.beginFill(0);
			g.moveTo(0, 0);
			g.lineTo(5, 7);
			g.lineTo(10, 0);
			g.lineTo(0, 0);
			g.endFill();

		}	
			    
		public static function DiamondBox(diamondBox:Canvas, g:Graphics):void{
			
           	g = diamondBox.graphics;     

			diamondBox.height=20;
			diamondBox.width=20;
						
   			g.clear();
			g.lineStyle(1, 0x66A0E5, 1);
           	g.beginFill(0x66A0E5);
			g.moveTo(10, 0);
			g.lineTo(0, 10);
			g.lineTo(10, 20);
			g.lineTo(20, 10);
			g.lineTo(10, 0);
			g.endFill();

		}		    
    }
}