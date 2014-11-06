////////////////////////////////////////////////////////////////////////////////
//  PoolView.as
//  2007.12.31, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
//
//  Addio 2007 !! 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.view
{
	import com.maninsoft.smart.modeler.common.InstancePool;
	import com.maninsoft.smart.modeler.xpdl.model.pool.Lane;
	import com.maninsoft.smart.modeler.xpdl.view.base.XPDLNodeView;
	import com.maninsoft.smart.modeler.xpdl.view.tool.LaneView;
	
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * Pool view
	 */
	public class PoolView extends XPDLNodeView {

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _laneViews: InstancePool;

		private var _laneTextFields: Array;
		private var _laneTextFormats: Array;
		
		private var _isVertical: Boolean;
		private var _lanes: Array;
		private var _poolHeadSize: Number = 21;
		private var _laneHeadSize: Number = 21;



		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function PoolView() {
			super();
			
			_laneViews = new InstancePool(this, LaneView);
			
			showShadowed = false;
			textColor = 0x666666;
		}
		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * lanesDir
		 */
		public function set isVertical(value: Boolean): void {
			_isVertical = value;
		}
		
		/**
		 * lanes
		 */
		public function get lanes(): Array /* of Lane */ {
			return _lanes;
		}
		 
		public function set lanes(value: Array): void {
			_lanes = value;
		}
		
		/**
		 * headSize
		 */
		public function get headSize(): Number {
			return _poolHeadSize + _laneHeadSize;
		}
		 
		/**
		 * poolHeadSize
		 */
		public function get poolHeadSize(): Number {
			return _poolHeadSize;
		}
		
		public function set poolHeadSize(value: Number): void {
			_poolHeadSize = value;
		}
		
		public function get poolHeadRect(): Rectangle {
			if (_isVertical)
				return new Rectangle(0, 0, nodeWidth, poolHeadSize);
			else
				return new Rectangle(0, 0, poolHeadSize, nodeHeight);
		}
		
		/**
		 * laneHeadSize
		 */
		public function get laneHeadSize(): Number {
			return _laneHeadSize;
		}
		
		public function set laneHeadSize(value: Number): void {
			_laneHeadSize = value;
		}
		
		/**
		 * title
		 */
		private var _title: String;

		public function get title(): String {
			return _title;
		}
		
		public function set title(value: String): void {
			_title = value ? value : resourceManager.getString("ProcessEditorETC", "processText");
		}
		
		/**
		 * headColor
		 */
		private var _headColor: uint = 0xececec;

		public function get headColor(): uint {
			return _headColor = 0xeaeaea;
		}
		
		public function set headColor(value: uint): void {
			if (value != _headColor) {
				_headColor = value;
				refresh();
			}
		}
		
		private var _lineColor: uint = 0x999999;
		
		public function get lineColor():uint {
			return _lineColor;
		}
		
		public function set lineColor(value: uint): void{
			if(value != _lineColor){
				_lineColor = value;
				refresh();
			}
		}

		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		

		public function findLaneView(lane: Lane): LaneView {
			for (var i: int = 0; i < _laneViews.count; i++)
				if (LaneView(_laneViews.getInstance(i)).lane == lane)
					return LaneView(_laneViews.getInstance(i));
					
			return null;
		}

		public function ptInHead(x: Number, y: Number): Boolean {
			return poolHeadRect.contains(x, y);
		}
		
		/**
		 * (x, y)를 포함하는 lane index 리턴
		 */
		public function ptInLane(x: Number, y: Number): Lane {
			if (_lanes && _lanes.length > 0) {
				var r: Rectangle = new Rectangle();
				
				for each (var lane: Lane in _lanes) {
					if (_isVertical) {
						r.width = lane.size;
						r.height = laneHeadSize;

						r.x += lane.size;
					}
					else {
						r.height = lane.size;
						r.width = laneHeadSize;
						
						r.y += lane.size;						
					}
					
					if (r.contains(x, y))
						return lane;
				}
			}
		
			return null;	
		}

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override protected function createTextField(): TextField {
			var fld: TextField = super.createTextField();
			fld.embedFonts = true;
			return fld;
		}

		override protected function createTextFormat(): TextFormat {
			var fmt: TextFormat = new TextFormat();
			
			fmt.font = "윤고딕350";
			fmt.color = 0x666666;
			fmt.size = 12;
			fmt.bold = false;
			fmt.italic = false;
			fmt.underline = false;
			fmt.align = "center";
			
			return fmt;
		}

		override public function draw(): void {
			var g: Graphics = graphics;
			
			g.clear();
			
			g.lineStyle(0, 0xffffff, 0);
			g.beginFill(0xffffff);
			g.drawRect(0, 0, nodeWidth, nodeHeight);
			g.endFill();
			
			drawPoolHead(g);
			drawLanes(g);
			
			g.lineStyle(1, lineColor);
			g.moveTo(nodeWidth, 0);
			g.lineTo(nodeWidth, nodeHeight);
			g.lineTo(0, nodeHeight);
			g.lineTo(0, 0);
			g.lineTo(nodeWidth, 0);

		}

		
		//----------------------------------------------------------------------
		// Internal properties
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		//------------------------------
		// drawing
		//------------------------------

		private function getLanesExtent(): Number {
			var ext: Number = 0;
			
			for each (var lane: Lane in lanes) {
				ext += lane.size;
			}
			
			return ext;
		}

		private function drawPoolHead(g: Graphics): void {
			_isVertical ? drawVertPoolHead(g) : drawHorzPoolHead(g);
		}
		
		private function drawVertPoolHead(g: Graphics): void {
			//g.beginGradientFill(GradientType.LINEAR, [0xffffff, headColor], [1, 1], [0x00, 0xff]);
			g.beginFill(headColor);
			
			g.lineStyle(1, lineColor, 0);
			g.drawRect(0, 0, nodeWidth, poolHeadSize);

/*
			g.lineStyle(1, lineColor, 1);
			g.moveTo(0, poolHeadSize);
			g.lineTo(nodeWidth, poolHeadSize);
*/
			g.endFill();
			
			drawText(new Rectangle(0, 0, getLanesExtent(), poolHeadSize), title); 
		}
		
		private function drawHorzPoolHead(g: Graphics): void {
			//g.beginGradientFill(GradientType.LINEAR, [0xffffff, headColor], [1, 1], [0x00, 0xff]);
			g.beginFill(headColor);
			
			g.lineStyle(1, lineColor, 0);
			g.drawRect(0, 0, poolHeadSize, nodeHeight);
/*
			g.lineStyle(1, lineColor, 1);
			g.moveTo(poolHeadSize, 0);
			g.lineTo(poolHeadSize, nodeHeight);
*/
			g.endFill();
			
			drawVertText(new Rectangle(0, 0, poolHeadSize, getLanesExtent()), title); 
		}

		private function drawLanes(g: Graphics): void {
			_isVertical ? drawVertLanes(g) : drawHorzLanes(g);
		}
		
		private function drawVertLanes(g: Graphics): void {
			_laneViews.hide();
			
			if (_lanes) {
				_laneViews.count = _lanes.length;
				
				var x: Number = 0;
				
				for (var i: int = 0; i < _lanes.length; i++) {
					var lane: Lane = _lanes[i] as Lane;
					var view: LaneView = _laneViews.getInstance(i) as LaneView;
	
					lane.height = laneHeadSize;
					view.lane = lane;				
					view.x = x;
					view.y = poolHeadSize; 
					
					if( i==_lanes.length-1 && selected)
						view.poolSelected = true;
					else
						view.poolSelected = false;
					view.render(this.nodeHeight - poolHeadSize);
					
					g.beginFill(lane.fillColor, 0.5);
					g.lineStyle(0, 0, 0);
					g.drawRect(x, view.y + laneHeadSize, lane.size, this.nodeHeight - poolHeadSize - laneHeadSize);
					g.endFill();

					x += lane.size;
				}
			}
			
			_laneViews.show();
		}

		private function drawHorzLanes(g: Graphics): void {
			_laneViews.hide();
			
			if (_lanes) {
				_laneViews.count = _lanes.length;
				
				var y: Number = 0;
				
				for (var i: int = 0; i < _lanes.length; i++) {
					var lane: Lane = _lanes[i] as Lane;
					var view: LaneView = _laneViews.getInstance(i) as LaneView;
	
					lane.width = laneHeadSize;
					view.lane = lane;				
					view.x = poolHeadSize;
					view.y = y; 
					
					if( i==_lanes.length-1 && selected)
						view.poolSelected = true;
					else
						view.poolSelected = false;
					view.render(this.nodeWidth - poolHeadSize);
					
					g.beginFill(lane.fillColor, 0.5);
					g.lineStyle(0, 0, 0);
					g.drawRect(view.x + laneHeadSize, y, this.nodeWidth - poolHeadSize - laneHeadSize, lane.size);
					g.endFill();
					
					y += lane.size;
				}
			}
			
			_laneViews.show();
		}
	}
}