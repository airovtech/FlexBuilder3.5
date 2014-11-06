////////////////////////////////////////////////////////////////////////////////
//  LinkView.as
//  2007.12.26, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.view
{
	import com.maninsoft.smart.modeler.view.connection.IConnectionRouter;
	import com.maninsoft.smart.modeler.view.connection.ManhattanConnectionRouter;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	/**
	 * Link view
	 */
	public class LinkView extends Sprite implements IView {
		
		//----------------------------------------------------------------------
		// Class consts
		//----------------------------------------------------------------------

		protected const EMPTY_BOUNDS: Rectangle = new Rectangle(0, 0, 0, 0);
		protected const DEFAULT_TEXTPOS: Point = new Point(0, 0);
	

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _resourceManager:IResourceManager;

		protected var _bounds: Rectangle = EMPTY_BOUNDS;
		protected var _textPoint: Point;

		protected var _textField: TextField;
		protected var _textFormat: TextFormat;
		protected var _points: Array = [];
		protected var _textPos: Point = DEFAULT_TEXTPOS;		
		
		private var _lineWidth: Number = 1;
		private var _lineColor: uint = 0x276b83;
		private var _label: String;
		private var _backwardColor: uint = 0xff0000;
		
		public var effectData: Object;
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function LinkView(points: Array) {
			super();

			this._resourceManager = ResourceManager.getInstance();
			this.doubleClickEnabled = true;
			
			for each (var p: Point in points) {
				_points.push(p.clone());
			}
			
			_bounds = calcBounds();			
			_textPoint = calcTextPoint();
			draw();
		}
		

		//----------------------------------------------------------------------
		// IView
		//----------------------------------------------------------------------

		public function getDisplayObject(): DisplayObject {
			return this;
		}
		
		public function refresh(): void {
			draw();
		}
		
		public function doIconClick(icon: IViewIcon, data: Object): void {
			dispatchEvent(new ViewIconEvent("iconClick", icon, data));
		}
		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		public function get resourceManager():IResourceManager{
			if(_resourceManager==null)
				_resourceManager = ResourceManager.getInstance();
			return _resourceManager;
		}

		/**
		 * points
		 */
		public function get points(): Array {
			return _points;
		}
		
		public function set points(value: Array): void {
			_points = value;
			_bounds = calcBounds();
			_textPoint = calcTextPoint();
		}
		
		/**
		 * 선분 갯수
		 */
		public function get segmentCount(): uint {
			return _points.length - 1;
		}
		
		/**
		 * text를 표시할 상대 위치값
		 */
		public function get textPos(): Point {
			return _textPos.clone();
		}
		
		public function set textPos(value: Point): void {
			_textPos = value ? value.clone() : DEFAULT_TEXTPOS;
			_textPoint = calcTextPoint();
		}
		 
		/**
		 * lineWidth
		 */
		public function get lineWidth(): Number {
			return _lineWidth;
		}
		
		public function set lineWidth(value: Number): void {
			if (value != _lineWidth) {
				_lineWidth = value;
			}
		}
		
		/**
		 * lineColor
		 */
		public function get lineColor(): uint {
			return _lineColor;
		}
		
		public function set lineColor(value: uint): void {
			if (value != _lineColor) {
				_lineColor = value;
			}
		}
		
		/**
		 * backwardColor
		 */
		public function get backwardColor(): uint {
			return _backwardColor;
		}
		
		public function set backwardColor(value: uint): void {
			if (value != _backwardColor) {
				_backwardColor = value;
			}
		}
		
		/**
		 * label
		 */
		public function get label(): String {
			return _label;
		}
		
		public function set label(value: String): void {
			if (value != _label) {
				_label = value;
			}
		}
		
		/**
		 * isBackward
		 */
		private var _isBackward: Boolean = false;
		 
		public function get isBackward(): Boolean {
			return _isBackward;
		}
		
		public function set isBackward(value: Boolean): void {
			if (value != _isBackward) {
				_isBackward = value;
			}
		}
		
		
		//----------------------------------------------------------------------
		// Virtual methods
		//----------------------------------------------------------------------

		protected function createConnectionRouter(): IConnectionRouter {
			return new ManhattanConnectionRouter();
		}


		//----------------------------------------------------------------------
		// Internal properties
		//----------------------------------------------------------------------

		/**
		 * textField
		 */
		protected function get textField(): TextField {
			if (!_textField) {
				_textField = new TextField();
				_textField.mouseEnabled = false;
				_textField.defaultTextFormat = textFormat;
				addChild(_textField);
			}
			
			return _textField;
		}
		
		/**
		 * textFormat
		 */
		protected function get textFormat(): TextFormat {
			if (!_textFormat) {
				_textFormat = new TextFormat();
				_textFormat.font = "윤고딕340";
				_textFormat.color = 0x666666;
				_textFormat.size = 11;
				_textFormat.bold = false;
				_textFormat.italic = false;
				_textFormat.underline = false;
				_textFormat.align = "center";
			}
			
			return _textFormat;
		}
		
		protected function get bounds(): Rectangle {
			return _bounds;
		}


		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		protected function calcBounds(): Rectangle {
			var r: Rectangle = new Rectangle(int.MAX_VALUE, int.MAX_VALUE, 0, 0);

			if (_points) {
				for each (var p: Point in _points) {			
					r.x = Math.min(r.x, p.x);
					r.width = Math.max(r.width, p.x);
					r.y = Math.min(r.y, p.y);
					r.height = Math.max(r.height, p.y);
				}
			}

			r.width = r.width - r.x;
			r.height = r.height - r.y;

			return r;
		}
		
		protected function calcTextPoint(): Point {
			var p: Point = new Point(0, 0);
			
			if (_points) {
				var p1: Point = _points[0] as Point;
				var p2: Point = _points[1] as Point;
				
				// vertical segment
				if (p1.x == p2.x) {
					p.x = p1.x;
					p.y = Math.min(p1.y, p2.y) + Math.abs(p1.y - p2.y) / 2;			
				} 
				// horizontal segment
				else {
					p.y = p1.y;
					p.x = Math.min(p1.x, p2.x) + Math.abs(p1.x - p2.x) / 2;			
				}
			}
			
			p.x += _textPos.x;
			p.y += _textPos.y;
			
			return p;
		}

		protected function drawText(x: int, y: int, text: String, field: TextField = null, format: TextFormat = null): void {
			if (!text)
				return;
			
			if (!field)
				field = textField;
				
			if (!format)
				format = textFormat;
			
			if (_points) {
				var p1: Point = _points[0] as Point;
				var p2: Point = _points[1] as Point;				
				// vertical segment
				if (p1.x == p2.x) {
					field.x = x+2;
					field.y = y-field.textHeight/2;
				} 
				// horizontal segment
				else {
					field.x = x-field.textWidth/2; 
					field.y = y;
				}
			}
			field.autoSize = TextFieldAutoSize.LEFT;
			
			field.defaultTextFormat = format;
			field.embedFonts = true;
			field.wordWrap = false;
			
			field.text = text;
		}

		protected function draw(): void {
			var g: Graphics = this.graphics;
			
			g.clear();
			
			drawLines(g);
			drawArrow(g);			
			
			drawText(_textPoint.x, _textPoint.y, label);
		}

		protected function drawLine(g: Graphics, index: int, start: Point, end: Point): void {
			g.moveTo(start.x, start.y);
			g.lineTo(end.x, end.y);	
		}
		
		private function drawLines(g: Graphics): void {
			/**
			 * 마우스로 쉽게 접근할 수 있도록 실제 표시되는 선외에 
			 * 여분의 공간을 마련한다.
			 */
			g.beginFill(0xffffff, 0.2);


			if (!isEffecting()) {			
				g.lineStyle(3, 0xffffff, 0.2);
	
				for(var i: int = 1; i < _points.length; i++) {
					drawLine(g, i - 1, _points[i - 1], _points[i]);
				}
			}
			g.endFill();


			/**
			 * 실제 라인을 표시한다.
			 */
			g.beginFill(lineColor);

			for(i = 1; i < _points.length; i++) {
				var col: uint = isBackward ? backwardColor : lineColor;
				
				if (isEffecting()) {
					g.lineStyle(lineWidth, col, i <= _effectCount ? 1 : 0, true, "normal", "none");	
				}
				else {
					g.lineStyle(lineWidth, col, 1, true, "normal", "none");
				}
				if(i == _points.length-1){
					var endPoint:Point = new Point(_points[i].x, _points[i].y);
					var p1x:int = _points[i-1].x, p1y:int = _points[i-1].y, p2x:int = _points[i].x, p2y:int = _points[i].y;
					if (p1y == p2y && p1x <= p2x) // to Right
						endPoint.x -= 5;
					else if (p1y == p2y && p1x > p2x) // to Left
						endPoint.x += 5;
  					else if (p1x == p2x && p1y <= p2y) // to Bottom
						endPoint.y -= 5;
  					else if (p1x == p2x && p1y > p2y) // to Top
						endPoint.y += 5;	
					
					drawLine(g, i - 1, _points[i - 1], endPoint);
				}else{
					drawLine(g, i - 1, _points[i - 1], _points[i]);
				}					
			}			
			g.endFill();
		}
		
		private function drawArrow(g: Graphics): void {
			var p1: Point = _points[_points.length - 2];
			var p2: Point = _points[_points.length - 1];
			var p1x:int = p1.x, p1y:int = p1.y, p2x:int = p2.x, p2y:int = p2.y;
			
			var x: Number = p2.x;
			var y: Number = p2.y;
			var w: Number = 8;
			var h: Number = 8/2;
			
			if (isEffecting()) {
				var alpha: Number = _effectCount == segmentCount + 1 ? 1 : 0;
				g.beginFill(lineColor, alpha); 				
				g.lineStyle(0, lineColor, alpha);
			}
			else {
				g.beginFill(isBackward ? backwardColor : lineColor);
				g.lineStyle(0, isBackward ? backwardColor : lineColor);
			}
			
			if( p1x != p2x && p1y != p2y){
				if(Math.abs(p1x-p2x) < Math.abs(p1y-p2y))
					p1x=p2x;
				else
					p1y=p2y;
			}
			
			if (p1y == p2y && p1x <= p2x) { // to Right
  				x -= 2;
				g.moveTo(x, y);			
  				g.lineTo(x - w/2, y + h/3);
  				g.lineTo(x - w, y + h);
  				g.lineTo(x - w*2/3, y);
  				g.lineTo(x - w, y - h);
  				g.lineTo(x - w/2, y - h/3);
			} else if (p1y == p2y && p1x > p2x) { // to Left
  				x += 2;
				g.moveTo(x, y);			
  				g.lineTo(x + w/2, y - h/3);
  				g.lineTo(x + w, y - h);
  				g.lineTo(x + w*2/3, y);
  				g.lineTo(x + w, y + h);
  				g.lineTo(x + w/2, y + h/3);
  			} else if (p1x == p2x && p1y <= p2y) { // to Bottom
  				y -= 2;
				g.moveTo(x, y);			
  				g.lineTo(x - h/3, y - w/2);
  				g.lineTo(x - h, y - w);
  				g.lineTo(x, y - w*2/3);
  				g.lineTo(x + h, y - w);
  				g.lineTo(x + h/3, y - w/2);
  			} else if (p1x == p2x && p1y > p2y) { // to Top
  				y += 2;
				g.moveTo(x, y);			
  				g.lineTo(x + h/3, y + w/2);
  				g.lineTo(x + h, y + w);
  				g.lineTo(x, y + w*2/3);
  				g.lineTo(x - h, y + w);
  				g.lineTo(x - h/3, y + w/2);
  			}		
  			
  			g.endFill();
		}
	

		//----------------------------------------------------------------------
		// Effect methods
		//----------------------------------------------------------------------
		
		private var _effecting: Boolean = false;
		private var _effectCount: uint = 0;
		
		public function isEffecting(): Boolean {
			return _effecting;
		}
		
		public function startEffect(): void {
			_effecting = true;
			_effectCount = 0;
			refresh();	
		}
		
		public function playEffect(): Boolean {
			if (_effecting) {
				_effectCount++;
				
				if (_effectCount > segmentCount + 1) {
					_effecting = false;
				}
				
				refresh();
				return !_effecting;
			}
			else
				return true;
		}
		
		public function endEffect(): void {
			if (_effecting) {
				_effecting = false;
				_effectCount = 0;
				refresh();
			}
		}
	}
}