////////////////////////////////////////////////////////////////////////////////
//  XPDLNode.as
//  2007.12.20, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model.base
{
	import com.maninsoft.smart.modeler.common.XsdUtils;
	import com.maninsoft.smart.modeler.model.DiagramObject;
	import com.maninsoft.smart.modeler.model.Node;
	import com.maninsoft.smart.workbench.common.property.BooleanPropertyInfo;
	import com.maninsoft.smart.workbench.common.property.TextPropertyInfo;
	import com.maninsoft.smart.modeler.xpdl.model.IXPDLElement;
	import com.maninsoft.smart.modeler.xpdl.model.Pool;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.model.process.XPDLElement;
	
	/**
	 * XPDL node base
	 */
	public class XPDLNode extends Node implements IXPDLElement {
		
		//----------------------------------------------------------------------
		// Property consts
		//----------------------------------------------------------------------
		
		public static const PROP_ID			: String = "prop.id";
		public static const PROP_NAME			: String = "prop.name";
		public static const PROP_BORDERCOLOR	: String = "prop.borderColor";
		public static const PROP_FILLCOLOR	: String = "prop.fillColor";
		public static const PROP_TEXTCOLOR	: String = "prop.textColor";
		public static const PROP_SHADOW		: String = "prop.shadow";
		public static const PROP_GRADIENT		: String = "prop.gradient";
		

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		/**
		 * load/save 처리에 필요할 수 있는 임시 저장소 등으로 사용
		 */
		public var tempData: Object = new Object();
		
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Construtor */
		public function XPDLNode() {
			super();

			initDefaults();
		}

		protected function initDefaults(): void {
			_name = "";
			_width = defaultWidth;
			_height = defaultHeight;
			_borderColor = defaultBorderColor;
			_fillColor = defaultFillColor;
			_textColor = defaultTextColor;
			_shadow = defaultShadow;
			_gradient = defaultGradient;
		}


		//----------------------------------------------------------------------
		// XPDLProperty
		//----------------------------------------------------------------------
		
		/**
		 * id
		 */
		protected var _id: int;

		public function get id(): int {
			return _id;
		}
		
		public function set id(value: int): void {
			_id = value;
		}
		
		/**
		 * name
		 */
		protected var _name: String;

		public function get name(): String {
			return _name ? _name : "";
		}
		
		public function set name(value: String): void {
			if (value != _name) {
				var oldValue: String = name;
				_name = value;
				
				fireChangeEvent(PROP_NAME, oldValue);
			} 
		}
		
		/**
		 * borderColor
		 */
		protected var _borderColor: uint;

		public function get borderColor(): uint {
			return _borderColor;
		}
		
		public function set borderColor(value: uint): void {
			if (value != _borderColor) {
				var oldValue: uint = _borderColor;
				_borderColor = value;
				
				fireChangeEvent(PROP_BORDERCOLOR, oldValue);
			}
		}
		
		/**
		 * fillColor
		 */
		protected var _fillColor: uint;

		public function get fillColor(): uint {
			return _fillColor;
		}
		
		public function set fillColor(value: uint): void {
			if (value != _fillColor) {
				var oldValue: uint = _fillColor;
				_fillColor = value;
				
				fireChangeEvent(PROP_FILLCOLOR, oldValue);
			}
		}
		
		/**
		 * textColor
		 */
		protected var _textColor: uint;

		public function get textColor(): uint {
			return _textColor;
		}
		
		public function set textColor(value: uint): void {
			if (value != _textColor) {
				var oldValue: uint = _textColor;
				_textColor = value;
				
				fireChangeEvent(PROP_TEXTCOLOR, oldValue);
			}
		}
		
		/**
		 * gradient
		 */
		protected var _gradient: Boolean;

		public function get gradient(): Boolean {
			return _gradient;
		}
		
		public function set gradient(value: Boolean): void {
			if (value != _gradient) {
				var oldValue: Boolean = _gradient;
				_gradient = value;
				
				fireChangeEvent(PROP_GRADIENT, oldValue);
			}
		}

		/**
		 * shadow
		 */
		protected var _shadow: Boolean;

		public function get shadow(): Boolean {
			return _shadow;
		}
		
		public function set shadow(value: Boolean): void {
			if (value != _shadow) {
				var oldValue: Boolean = _shadow;
				_shadow = value;
				
				fireChangeEvent(PROP_SHADOW, oldValue);
			}
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * default name
		 */
		public function get defaultName(): String {
			return "XPDL Node";
		}
		
		/**
		 * default width
		 */
		public function get defaultWidth(): Number {
			return 100;
		}
		
		/**
		 * default height
		 */
		public function get defaultHeight(): Number {
			return 35;
		}
		
		/**
		 * default border color
		 */
		public function get defaultBorderColor(): uint {
			return 0x000000;
		}
		
		/**
		 * default fill color
		 */
		public function get defaultFillColor(): uint {
			return 0xffffff;
		}

		/**
		 * default text color
		 */
		public function get defaultTextColor(): uint {
			return 0x666666;
		}		
		
		/**
		 * default shadow
		 */
		public function get defaultShadow(): Boolean {
			return false;
		}
		
		/**
		 * default gradient
		 */
		public function get defaultGradient(): Boolean {
			return false;
		}
		
		/**
		 * pool
		 */
		public function get pool(): Pool {
			if (!(parent is XPDLNode)) {
				return null;
			}
			
			if (this is Pool) {
				return this as Pool;
			}
			
			var p: Node = parent;
			
			while (!(parent is Pool)) {
				p = p.parent;
			}
			
			return p as Pool;
		}

		/**
		 * xpdlDiagram
		 */
		public function get xpdlDiagram(): XPDLDiagram {
			return super.diagram as XPDLDiagram;
		}

		//----------------------------------------------------------------------
		// IXPDLElement
		//----------------------------------------------------------------------
		
		protected function get _ns(): Namespace {
			return XPDLElement._ns;
		}
		
		public function read(xml: XML): void {
			doRead(xml);
		}
		
		public function write(xml: XML): void {
			doWrite(xml);
		}	

		protected function doRead(src: XML): void {
			id 		= src.@Id;
			name	= src.@Name;

			if(src._ns::NodeGraphicsInfos._ns::NodeGraphicsInfo.length() > 0){
				var xml: XML = src._ns::NodeGraphicsInfos._ns::NodeGraphicsInfo[0];
				doReadGraphics(xml);
			}
		}

		protected function doWrite(dst: XML): void {
			dst.@Id 	= id;
			dst.@Name 	= name;
			
			dst._ns::NodeGraphicsInfos._ns::NodeGraphicsInfo = "";
			doWriteGraphics(dst._ns::NodeGraphicsInfos._ns::NodeGraphicsInfo[0]);
		}
		
		protected function doReadGraphics(src: XML): void {
			_width 			= src.@Width;
			_height 		= src.@Height;
			_borderColor	= src.@BorderColor;
			_fillColor		= src.@FillColor;
			_textColor		= src.@TextColor;
			_shadow			= XsdUtils.isTrue(src.@Shadow);
			_gradient		= XsdUtils.isTrue(src.@Gradient);
			
			_x = src._ns::Coordinates.@XCoordinate;
			_y = src._ns::Coordinates.@YCoordinate;
		}
		
		protected function doWriteGraphics(dst: XML): void {
			dst.@Width			= _width; 		
			dst.@Height			= _height;   
			dst.@BorderColor	= _borderColor;	
			dst.@FillColor		= _fillColor;
			dst.@TextColor		= _textColor;
			dst.@Shadow			= _shadow;
			dst.@Gradient		= _gradient;
			
			dst._ns::Coordinates.@XCoordinate = _x;
			dst._ns::Coordinates.@YCoordinate = _y;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function assign(source: DiagramObject): void {
			super.assign(source);
			
			var node: XPDLNode = source as XPDLNode;
			
			_id				= node._id;
			_name			= node._name;
			_borderColor	= node._borderColor;
			_fillColor		= node._fillColor;
			_textColor		= node._textColor;
			_shadow			= node._shadow;
			_gradient		= node._gradient;
		}

		/**
		 * 프로퍼티 소스가 제공하는 IPropertyInfo 목록
		 */
		override protected function createPropertyInfos(): Array {
			var props: Array = super.createPropertyInfos();
			
			return props.concat(
				new TextPropertyInfo(PROP_ID, "Id", "", "", false),
				new TextPropertyInfo(PROP_NAME, resourceManager.getString("WorkbenchETC", "nameText"), "", "")
			);
		}
		
		/**
		 * id 에 해당하는 프로퍼티의 현재 값을 리턴
		 */
		override public function getPropertyValue(id: String): Object {
			switch (id) {
				case PROP_ID: 
					return this.id;
					
				case PROP_NAME: 
					return name;
					
				case PROP_BORDERCOLOR:
					return borderColor;
					
				case PROP_FILLCOLOR:
					return fillColor;
					
				case PROP_TEXTCOLOR:
					return textColor;
					
				case PROP_SHADOW:
					return shadow;
					
				case PROP_GRADIENT:
					return gradient;
					
				default:
					return super.getPropertyValue(id);
			}
		}
		
		/**
		 * id 에 해당하는 프로퍼티의 값을 설정
		 */
		override public function setPropertyValue(id: String, value: Object): void {
			switch (id) {
				case PROP_NAME:
					name = value.toString();
					break;
					
				case PROP_BORDERCOLOR:
					borderColor = uint(value);
					break;
					
				case PROP_FILLCOLOR:
					fillColor = uint(value);
					break;
					
				case PROP_TEXTCOLOR:
					textColor = uint(value);
					break;
					
				case PROP_SHADOW:
					shadow = value;
					break;
					
				case PROP_GRADIENT:
					gradient = value;
					break;
					
				default:
					super.setPropertyValue(id, value);
					break;
			}
		}
	}
}