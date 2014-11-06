////////////////////////////////////////////////////////////////////////////////
//  StartEventView.as
//  2007.12.21, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.view
{
	import com.maninsoft.smart.modeler.xpdl.model.IntermediateEvent;
	import com.maninsoft.smart.modeler.xpdl.view.base.EventView;
	import com.maninsoft.smart.modeler.xpdl.view.viewicon.TimerEventIcon;
	
	import flash.display.GradientType;
	import flash.display.Graphics;
		
	/**
	 * IntermediateEvent view
	 */
	public class IntermediateEventView extends EventView {
		

		public var _eventType:String;
		private var _timerEventIcon: TimerEventIcon;
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function IntermediateEventView() {
			super();
		}
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		public function get eventType():String {
			return _eventType;
		}
		public function set eventType(value:String):void {
			_eventType = value;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function draw(): void {
			var g: Graphics = graphics;
			g.clear();

			var sz: int = Math.min(nodeWidth, nodeHeight) / 2;
			
			g.lineStyle(borderWidth, borderColor);
			
			if (!showGrayed)
				setFillMode(g);
			else
				g.beginFill(grayedColor);
			g.drawCircle(sz - 1, sz - 1, sz);
			g.drawCircle(sz - 1, sz - 1, sz-2);
			g.endFill();

			g.lineStyle(borderWidth, borderColor);
			g.beginGradientFill(GradientType.LINEAR, [0xffffff, 0x000000], [0.07, 0.07], [0, 255]);
			g.drawCircle(sz - 1, sz - 1, sz);
			g.endFill();
//
//			drawText(new Rectangle(0, 0, nodeWidth, nodeHeight), resourceManager.getString("ProcessEditorETC", "startText"));

			if(_eventType == IntermediateEvent.EVENT_TYPE_TIMER){
				if (!_timerEventIcon) {
					_timerEventIcon = new TimerEventIcon(this);
					addChild(_timerEventIcon);
				}
				
				_timerEventIcon.x = nodeWidth/4;
				_timerEventIcon.y = 0-_timerEventIcon.height/4;				
			}
			
			removeProblemIcon();
			
			if (problem) {
				problemIcon.problem = problem;
				problemIcon.x = 0.5;
				problemIcon.y = 0.5;
				
				addChild(problemIcon);
			}

			
			super.draw();
		}
	}
}