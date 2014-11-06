////////////////////////////////////////////////////////////////////////////////
//  TaskView.as
//  2008.01.14, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.view.base
{
	import com.maninsoft.smart.modeler.xpdl.view.viewicon.PerformerIcon;
	import com.maninsoft.smart.modeler.xpdl.view.viewicon.StartActivityIcon;
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	
	/**
	 * XPDL Task view
	 */
	public class TaskView extends ActivityView {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _startActivityIcon: StartActivityIcon;
		private var _performerIcon: PerformerIcon;

		/** Storage for property text */
		private var _text: String = "Task";
		/** Storage for property startActivity */
		private var _startActivity: Boolean;
		/** Storage for property performer */
		private var _performer: Object;
		
		public var iconViewBoxHeight:Number = 19;
		public var iconViewDelta:Number=0;


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function TaskView() {
			super();
		}
		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * text
		 */
		public function get text(): String {
			return _text;
		}
		
		public function set text(value: String): void {
			if (value != _text) {
				_text = value;
			}
		}

		/**
		 * startActivity
		 */
		public function get startActivity(): Boolean {
			return _startActivity;
		}
		
		public function set startActivity(value: Boolean): void {
			if (value != _startActivity) {
				_startActivity = value;
			}
		}
		
		/**
		 * performer
		 */
		public function get performer(): Object {
			return _performer;
		}
		
		public function set performer(value: Object): void {
			if (value != _performer) {
				_performer = value;
			}
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------


		override public function draw(): void {
			var g: Graphics = graphics;
			var xi: int = 5;
			var yi: int = 5;
			var radious:Number = 2.5;
			iconViewDelta = 5;
			
			g.clear();
			
			g.lineStyle(1, 0xc2c2c2, 1, true);
			g.beginGradientFill(GradientType.LINEAR, [0xffffff, 0xf5f5f5], [1, 1], [0, 255]);
			g.drawRoundRect(0, 0, nodeWidth, nodeHeight, 5);
			g.endFill();

			g.lineStyle(borderWidth, borderColor, 1, true);
			if (!showGrayed)
				setFillMode(g);
			else
				g.beginFill(grayedColor,1);
			g.moveTo(0+radious, 0);
			g.lineTo(nodeWidth-radious, 0);
			g.curveTo(nodeWidth, 0, nodeWidth, 0+radious);
			g.lineTo(nodeWidth, nodeHeight-iconViewBoxHeight);
			g.lineTo(0, nodeHeight-iconViewBoxHeight);
			g.lineTo(0, 0+radious);
			g.curveTo(0, 0, 0+radious, 0);
			g.endFill();
			
			g.lineStyle(borderWidth, borderColor, 1, true);
			g.beginGradientFill(GradientType.LINEAR, [0xffffff, 0x000000], [0.07, 0.07], [0, 255]);
			g.drawRoundRect(0, 0, nodeWidth, nodeHeight-iconViewBoxHeight, 5);
			g.endFill();
						
			// text
			drawText(new Rectangle(0, 0, nodeWidth, nodeHeight-iconViewBoxHeight), text);

			// performer
			if (performer) {
				if (!_performerIcon) {
					_performerIcon = new PerformerIcon(this);
					addChild(_performerIcon);
				}
				
				_performerIcon.performer = performer;
				
				_performerIcon.x = iconViewDelta;
				_performerIcon.y = nodeHeight-iconViewBoxHeight+4;				
				iconViewDelta += _performerIcon.width+2;
			}
			else if (_performerIcon) {
				removeChild(_performerIcon);
				_performerIcon = null;
			}
		}
	}
}