////////////////////////////////////////////////////////////////////////////////
//  XPDLNodeView.as
//  2007.12.13, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.view.base
{
	import com.maninsoft.smart.modeler.view.NodeView;
	
	import flash.display.Graphics;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * XPDL Node view base
	 */
	public class XPDLNodeView extends NodeView {
		
		private static var _shadowFilter: DropShadowFilter = new DropShadowFilter(4, 45, 0, 0.3);
		private static var _blurFilter: BlurFilter = new BlurFilter(1, 2, 1);
		private static var _glowFilter: GlowFilter = new GlowFilter(0x0000ff);

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		protected var _textField: TextField;
		protected var _textFormat: TextFormat;
		private var _showShadowed: Boolean;
		private var _showGlowed: Boolean;
		/*
		 * grayed는 각 view가 알아서...
		 */
		protected var _showGrayed: Boolean;
		private var _grayedColor: uint = 0xdddddd;
		private var _showGradient: Boolean;
		
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function XPDLNodeView() {
			super();
			
			_textFormat = createTextFormat();
			resetFilters();
		}

		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * fontFamily
		 */
		public function get fontFamily(): String {
			return _textFormat.font;
		}
		
		public function set fontFamily(value: String): void {
			if (value != fontFamily) {
				_textFormat.font = value;
			}
		}
		
		/**
		 * textColor
		 */
		public function get textColor(): uint {
			return uint(_textFormat.color);
		}
		
		public function set textColor(value: uint): void {
			_textFormat.color = value;
		}
		
		/**
		 * fontSize
		 */
		public function get fontSize(): Number {
			return Number(_textFormat.size);
		}
		
		public function set fontSize(value: Number): void {
			if (value != fontSize) {
				_textFormat.size = value;
			}
		}
		
		/**
		 * fontStyle
		 */
		public function get fontStyle(): String {
			return _textFormat.italic ? "italic" : "normal";
		}
		
		public function set fontStyle(value: String): void {
			if (value != fontStyle) {
				_textFormat.italic = value == "italic";
			}
		}
		
		/**
		 * fontWeight
		 */
		public function get fontWeight(): String {
			return _textFormat.bold ? "bold" : "normal";
		}
		
		public function set fontWeight(value: String): void {
			if (value != fontWeight) {
				_textFormat.bold = value == "bold";
			}
		}

		/**
		 * textDecoration
		 */
		public function get textDecoration(): String {
			return _textFormat.underline ? "underline" : "none";
		}
		
		public function set textDecoration(value: String): void {
			if (value != textDecoration) {
				_textFormat.underline = value == "underline";
			}
		}
		
		/**
		 * textAlign
		 */
		public function get textAlign(): String {
			return _textFormat.align;
		}
		
		public function set textAlign(value: String): void {
			if (value != textAlign) {
				_textFormat.align = value;
			}
		}
		
		/**
		 * showShadowed
		 */
		public function get showShadowed(): Boolean {
			return _showShadowed;
		}
		
		public function set showShadowed(value: Boolean): void {
			if (value != _showShadowed) {
				_showShadowed = value;
				resetFilters();
			}
		}
		
		/**
		 * showGlowed
		 */
		public function get showGlowed(): Boolean {
			return _showGlowed;
		}
		
		public function set showGlowed(value: Boolean): void {
			if (value != _showGlowed) {
				_showGlowed = value;
				resetFilters();
			}
		}
		
		/**
		 * showGrayed
		 */
		public function get showGrayed(): Boolean {
			return _showGrayed;
		}
		
		public function set showGrayed(value: Boolean): void {
			if (value != _showGrayed) {
				_showGrayed = value;
			}
		}
		
		/**
		 * grayedColor
		 */
		public function get grayedColor(): uint {
			return _grayedColor;
		}
		
		public function set grayedColor(value: uint): void {
			if (value != _grayedColor) {
				_grayedColor = value;
			}
		}

		/**
		 * showGradient
		 */
		public function get showGradient(): Boolean {
			return _showGradient;
		}
		
		public function set showGradient(value: Boolean): void {
			if (value != _showGradient) {
				_showGradient = value;
			}
		}

		
		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override public function draw(): void {
			super.draw();
			resetFilters();

		}		

		override protected function setFillMode(g: Graphics): void {
//			if (showGradient)
//				super.setFillMode(g);
//			else
				g.beginFill(fillColor, 1);
		}
		
		
		//----------------------------------------------------------------------
		// Internal properties
		//----------------------------------------------------------------------

		/**
		 * textField
		 */
		protected function get textField(): TextField {
			if (!_textField) {
				_textField = createTextField();
				addChild(_textField);
			}
			
			return _textField;
		}

		
		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------

		public function resetFilters(): void {
			_glowFilter.strength = 6;
			var arr: Array = [];
			
			if (showShadowed)
//				arr.push(_shadowFilter);
				
			if (showGlowed)
//				arr.push(_glowFilter);
				
			this.filters = arr;
		}
		
		protected function createTextField(): TextField {
			var fld: TextField = new TextField();
			fld.mouseEnabled = false;
			fld.embedFonts = true;
			fld.wordWrap = true;
			fld.defaultTextFormat = _textFormat;
			
			return fld;
		}

		protected function createTextFormat(): TextFormat {
			var fmt: TextFormat = new TextFormat();
			
			fmt.font = "윤고딕350";
			fmt.color = 0x666666;
			fmt.size = 11;
			fmt.bold = false;
			fmt.italic = false;
			fmt.underline = false;
			fmt.align = "center";
			
			return fmt;
		}

		protected function drawText(r: Rectangle, text: String, field: TextField = null, format: TextFormat = null): void {
			if (!text)
				return;
			
			if (!field)
				field = textField;
				
			if (!format)
				format = _textFormat;
			
			field.defaultTextFormat = format;
			field.x = r.x + 2;
			field.y = r.y + 2;
			field.width = r.width - 4;
			field.height = r.height - 4;
			field.text = text;

			// field.textHeight 에 4를 더한다. TextLineMetrics 의 2-pixel gutter 참조.
			field.height = Math.min(field.textHeight + 4, r.height - 4);
			field.y = Math.max(r.y, r.y + (r.height - field.textHeight - 4) / 2);
			
			field.rotation = 0;
		}

		protected function drawVertText(r: Rectangle, text: String, field: TextField = null, format: TextFormat = null): void {
			if (!text)
				return;
			
			if (!field)
				field = textField;
				
			if (!format)
				format = _textFormat;
				
			r = new Rectangle(r.x, r.bottom, r.height, r.width);
			trace(r);
			
			field.defaultTextFormat = format;
			field.x = r.x + 2;
			field.y = r.y + 2;
			field.width = r.width - 4;
			field.height = r.height - 4;
			field.text = text;

			// field.textHeight 에 4를 더한다. TextLineMetrics 의 2-pixel gutter 참조.
			field.height = Math.min(field.textHeight + 4, r.height - 4);
			field.y = Math.max(r.y, r.y + (r.height - field.textHeight - 4) / 2);
			
			field.rotation = -90;
		}

		protected function drawTextTop(r: Rectangle, text: String, field: TextField = null, format: TextFormat = null): void {
			if (!text)
				return;
			
			if (!field)
				field = textField;
				
			if (!format)
				format = _textFormat;
			
			field.defaultTextFormat = format;
			field.x = r.x + 2;
			field.y = r.y + 2;
			field.width = r.width - 4;
			field.height = r.height - 4;
			field.text = text;

			// field.textHeight 에 4를 더한다. TextLineMetrics 의 2-pixel gutter 참조.
			field.height = Math.min(field.textHeight + 4, r.height - 4);
			
			field.rotation = 0;
		}
	}
}