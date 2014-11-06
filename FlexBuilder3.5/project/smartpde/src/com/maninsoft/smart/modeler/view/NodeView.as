////////////////////////////////////////////////////////////////////////////////
//  NodeView.as
//  2007.12.13, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.view
{
	import com.maninsoft.smart.modeler.common.ComponentUtils;
	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	/**
	 * NodeView
	 */
	public class NodeView extends Sprite implements IView {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _resourceManager:IResourceManager;
		
		/** Storage for property nodeWidth */
		private var _nodeWidth: int;
		/** Storage for property nodeHeiht */
		private var _nodeHeight: int;
		/** Storage for property selected */
		private var _selected: Boolean;
		
		/** Storage for property borderWidth */
		private var _borderWidth: Number = 1;
		/** Storage for property borderColor */
		private var _borderColor: uint = 0xa0c4ce;
		/** Storage for property fillColor */
		private var _fillColor: uint = 0xffffff;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function NodeView() {
			super();

			this._resourceManager = ResourceManager.getInstance();
			this.doubleClickEnabled = true;
			addEventListener(MouseEvent.MOUSE_DOWN, doMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, doMouseUp);
		}

		//----------------------------------------------------------------------
		// IView
		//----------------------------------------------------------------------

		public function getDisplayObject(): DisplayObject {
			return this;
		}
		
		public function get selected(): Boolean {
			return _selected;
		}
		
		public function set selected(value: Boolean): void {
			if (value != _selected) {
				_selected = value;
			}
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
		 * DisplayObject 의 크기는 width나 height 속성이 아니라,
		 * DisplayObject 의 내용물에 따라 결정된다.
		 * 외부에서 명시적으로 크기를 지정할 수 있도록 한다.
		 */
		public function get nodeWidth(): int {
			return _nodeWidth;
		}
		
		public function set nodeWidth(value: int): void {
			_nodeWidth = value;
		}

		/**
		 * nodeWidth 참조
		 */
		public function get nodeHeight(): int {
			return _nodeHeight;
		}
		
		public function set nodeHeight(value: int): void {
			_nodeHeight = value;
		}
		
		/**
		 * borderWidth
		 */
		public function get borderWidth(): Number {
			return _borderWidth;
		}
		
		public function set borderWidth(value: Number): void {
			_borderWidth = value;
		}
		
		/** 
		 * borderColor
		 */
		public function get borderColor(): uint {
			return _borderColor;
		}
		
		public function set borderColor(value: uint): void {
			_borderColor = value;
		}
		
		/**
		 * fillColor
		 */
		public function get fillColor(): uint {
			return _fillColor;
		}
		
		public function set fillColor(value: uint): void {
			_fillColor = value;
		}

		public function get bounds(): Rectangle{
			return(new Rectangle(this.x, this.y, this.nodeWidth, this.nodeHeight));
		}

		public function connectAnchorToPoint(anchor: Number): Point {
			var r: Rectangle = this.bounds; 
			
			switch (anchor) {
				case 0: 
					return new Point(r.x + r.width / 2, r.y);
				case 90: 
					return new Point(r.x + r.width, r.y + r.height / 2);
				case 180:
					return new Point(r.x + r.width / 2, r.y + r.height);
				case 270:
					return new Point(r.x, r.y + r.height / 2);
				default:
					throw new Error("Invalid link path point(" + anchor + ")");
			}
		}

		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		
		/**
		 * DisplayObject 의 크기는 DisplayObject 의 내용물에 따라 결정된다.
		 * 여기에 그려질 내용물의 정보는 이 개체 밖의 모델에 담겨져 있다.
		 */
		public function draw(): void {
			var g: Graphics = graphics;
			
			ComponentUtils.clearChildrenByType(this, TextField);			
			g.clear();
			
			g.lineStyle(borderWidth, borderColor);
			g.beginFill(fillColor);
			g.drawRect(0, 0, nodeWidth, nodeHeight);
			g.endFill();


			var text:TextField = new TextField();
			text.text = "sldjkfsldkmcvdslmmskf";
			text.width = 100;
			text.height = 100;
			
			addChild(text);


		}
		
		public function refresh(): void {
			draw();
		}


		//----------------------------------------------------------------------
		// Event handlers
		//----------------------------------------------------------------------
		
		private function doMouseDown(event: MouseEvent): void {
			//startDrag();
		}

		private function doMouseUp(event: MouseEvent): void {
			//stopDrag();
		}


		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		/*
		protected function drawText(text: String, offsetX: int, offsetY: int): void {
			drawString(text, offsetX, offsetY, nodeWidth, nodeHeight);
		}
		*/
		
		/*
		protected function drawString(text: String, x: int, y: int, w: int, h: int): void {
			if (text) {
				var field: TextField = new TextField();
				addChild(field);
				
				var fmt: TextFormat = new TextFormat();
				
				field.wordWrap = true;
				field.multiborder = true;
				field.text = text;
				//field.textColor = textColor;
				
				//label.embedFonts = true;
				//fmt.font = "emFont"
				fmt.align =  TextFormatAlign.CENTER;
				field.setTextFormat(fmt);
				
				field.autoSize = TextFieldAutoSize.CENTER;
				field.mouseEnabled = false;
				field.width = w - x * 2 + 4;
				field.x = x;
				field.y = y + h / 2 - field.textHeight / 2 - 5;
			}
		}
		*/

		protected function setFillMode(g: Graphics): void {
			//var matrix: Matrix = new Matrix();
			//matrix.createGradientBox(nodeWidth, nodeHeight, Math.PI * 3 / 2, 0, 0);
			g.beginGradientFill(GradientType.LINEAR, [0xffffff, fillColor], [0.5, 0.5], [0x00, 0xff]);//, matrix);
		}
	}
}