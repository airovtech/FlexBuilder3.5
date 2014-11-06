////////////////////////////////////////////////////////////////////////////////
//  SubFlowView.as
//  2007.12.21, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.view
{
	import com.maninsoft.smart.modeler.xpdl.syntax.Problem;
	import com.maninsoft.smart.modeler.xpdl.view.base.ActivityView;
	import com.maninsoft.smart.modeler.xpdl.view.viewicon.MeanTimeIcon;
	import com.maninsoft.smart.modeler.xpdl.view.viewicon.MultiInstanceIcon;
	import com.maninsoft.smart.modeler.xpdl.view.viewicon.SubTaskIcon;
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	/**
	 * SubFlow view
	 */
	public class SubFlowView extends ActivityView {
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function SubFlowView() {
			super();
		}

		private var _text: String;		
		private var _execution: String;
		private var _subFlowView: String;
		private var _subProcessName: String;
		private var _subTaskIcon: SubTaskIcon;
		private var _multiInstanceIcon: MultiInstanceIcon;
		private var _meanTimeIcon: MeanTimeIcon;
		private var _subProcessProblem: Problem;
		public var iconViewBoxHeight:Number = 19;
		public var iconViewDelta:Number=0;

		public function get execution(): String{
			return _execution;
		}
		public function set execution(value:String): void{
			_execution = value;
		}

		public function get subFlowView(): String{
			return _subFlowView;
		}
		public function set subFlowView(value:String): void{
			_subFlowView = value;
		}

		public function get text(): String {
			return _text;
		}
		
		public function set text(value: String): void {
			if (value != _text) {
				_text = value;
			}
		}

		private var _meanTimeInHours: Number=-1;

		public function get meanTimeInHours(): Number {
			return _meanTimeInHours;
		}

		public function set meanTimeInHours(value: Number): void {
			_meanTimeInHours = value;
		}

		private var _passedTimeInHours: Number=-1;

		public function get passedTimeInHours(): Number {
			return _passedTimeInHours;
		}

		public function set passedTimeInHours(value: Number): void {
			_passedTimeInHours = value;
		}

		public function get subProcessName(): String{
			return _subProcessName;
		}
		
		public function set subProcessName(value: String): void{
			_subProcessName = value;
		}
		
		public function get subProcessProblem(): Problem{
			return _subProcessProblem;
		}
		
		public function set subProcessProblem(value: Problem): void{
			_subProcessProblem = value;
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

			if(_subProcessName){
				if (!_subTaskIcon) {
					_subTaskIcon = new SubTaskIcon(this);
					addChild(_subTaskIcon);
				}
				_subTaskIcon.subProcessName = _subProcessName;
				_subTaskIcon.x = iconViewDelta;
				_subTaskIcon.y = nodeHeight-iconViewBoxHeight+4;				
				iconViewDelta += _subTaskIcon.width+2;
			}else if(_subTaskIcon && contains(_subTaskIcon))
				removeChild(_subTaskIcon);

			if (isMultiInstance) {
				if (!_multiInstanceIcon) {
					_multiInstanceIcon = new MultiInstanceIcon(this);
					addChild(_multiInstanceIcon);
				}
				
				_multiInstanceIcon.multiInstanceBehavior = this.multiInstanceBehavior;
				_multiInstanceIcon.x = iconViewDelta;
				_multiInstanceIcon.y = nodeHeight-iconViewBoxHeight+4;
				iconViewDelta += _multiInstanceIcon.width+2;
			}
			else if (_multiInstanceIcon && contains(_multiInstanceIcon)) {
				removeChild(_multiInstanceIcon);
				_multiInstanceIcon = null;
			}
			
			if(_meanTimeIcon && contains(_meanTimeIcon))
				removeChild(_meanTimeIcon);
			_meanTimeIcon = new MeanTimeIcon(this);
				
			_meanTimeIcon.meanTimeInHours = this.meanTimeInHours;
			_meanTimeIcon.passedTimeInHours = this.passedTimeInHours;
			_meanTimeIcon.x = nodeWidth-_meanTimeIcon.width-2;
			_meanTimeIcon.y = nodeHeight-iconViewBoxHeight+3;
			addChild(_meanTimeIcon);

			removeProblemIcon();
			
			if (problem) {
				problemIcon.problem = problem;
				problemIcon.x = 0.5;
				problemIcon.y = 0.5;
				
				addChild(problemIcon);
			}else if(subProcessProblem){
				problemIcon.problem = subProcessProblem;
				problemIcon.x = 0.5;
				problemIcon.y = 0.5;
				
				addChild(problemIcon);
			}
		}
	}
}