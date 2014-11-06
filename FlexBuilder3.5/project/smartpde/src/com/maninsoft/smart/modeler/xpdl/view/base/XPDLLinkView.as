////////////////////////////////////////////////////////////////////////////////
//  LinkXPDLLinkViewView.as
//  2008.03.24, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.view.base
{
	import com.maninsoft.smart.modeler.view.LinkView;
	import com.maninsoft.smart.modeler.xpdl.syntax.Problem;
	import com.maninsoft.smart.modeler.xpdl.view.viewicon.ProblemIcon;
	
	import flash.display.Graphics;
	import flash.geom.Point;
	
	/**
	 * XPDLLink view
	 */
	public class XPDLLinkView extends LinkView {
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function XPDLLinkView(points: Array) {
			super(points);
		}

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * isDefault
		 */
		private var _isDefault: Boolean;
		 
		public function get isDefault(): Boolean {
			return _isDefault;
		}
		
		public function set isDefault(value: Boolean): void {
			if (value != _isDefault) {
				_isDefault = value;
			}
		}
		
		private var _problem: Problem;
		 
		public function get problem(): Problem {
			return _problem;
		}
		
		public function set problem(value: Problem): void {
			if (value != _problem) {
				_problem = value;
			}
		}

		private var _problemIcon: ProblemIcon;
		
		protected function get problemIcon(): ProblemIcon {
			if (!_problemIcon) {
				_problemIcon = new ProblemIcon(this);
			}
		
			return _problemIcon;
		}

		protected function removeProblemIcon(): void {
			if (_problemIcon && contains(_problemIcon)) {
				removeChild(_problemIcon);
			}
		}
		
		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function draw(): void {
			removeProblemIcon();
			super.draw();			
		}

		override protected function drawLine(g:Graphics, index: int, start:Point, end:Point):void {
			super.drawLine(g, index, start, end);
						
			// default 표시
			if ((isDefault || problem) && index == 0) {
				var len: Number = 4;
				var x1: Number;
				var y1: Number;
				var x2: Number;
				var y2: Number;
				var x3: Number;
				var y3: Number;
				
				if (start.y == end.y) { // 수평선
					if (start.x <= end.x) {
						x1 = Math.min(start.x + len * 2, start.x + (end.x - start.x) / 2);
						y1 = start.y - len;
						x2 = x1 + len * 2;
						y2 = y1 + len * 2;

						x3 = (x2+x1)/2;
						y3 = (y2+y1)/2-problemIcon.height;
					}
					else {
						x1 = Math.max(start.x - len * 2, start.x - (start.x - end.x) / 2);
						y1 = start.y - len;
						x2 = x1 - len * 2;
						y2 = y1 + len * 2;

						x3 = (x1+x2)/2-problemIcon.width;
						y3 = (y2+y1)/2-problemIcon.height;
					}					
				}
				else {	// 수직선
					if (start.y <= end.y) {
						x1 = start.x - len;
						y1 = Math.min(start.y + len * 2, start.y + (end.y - start.y) / 2);
						x2 = x1 + len * 2;
						y2 = y1 + len * 2;

						x3 = (x2+x1)/2-problemIcon.width;
						y3 = (y2+y1)/2+problemIcon.height;
					}
					else {
						x1 = start.x - len;
						y1 = Math.max(start.y - len * 2, start.y - (start.y - end.y) / 2);
						x2 = x1 + len * 2;
						y2 = y1 - len * 2;

						x3 = (x2+x1)/2-problemIcon.width;
						y3 = (y1+y2)/2-problemIcon.height;
					}
				}
				if(isDefault){
					g.moveTo(x1, y1);
					g.lineTo(x2, y2);
				}

				if(problem){
					problemIcon.problem = problem;
					problemIcon.x = x3;
					problemIcon.y = y3;
					addChild(problemIcon);
				}				
			}
		}
	}
}