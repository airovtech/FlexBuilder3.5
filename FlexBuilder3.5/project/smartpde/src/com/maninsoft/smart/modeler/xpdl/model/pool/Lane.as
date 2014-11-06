////////////////////////////////////////////////////////////////////////////////
//  Lane.as
//  2007.12.31, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
//
//  Addio 2007 !! 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model.pool
{
	import com.maninsoft.smart.modeler.xpdl.model.Pool;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.model.process.XPDLElement;
	import com.maninsoft.smart.modeler.xpdl.property.DepartmentPropertyInfo;
	import com.maninsoft.smart.workbench.common.property.IPropertySource;
	import com.maninsoft.smart.workbench.common.property.TextPropertyInfo;
	
	/**
	 * Pool lane 모델
	 */
	public class Lane	extends XPDLElement implements IPropertySource {

		//----------------------------------------------------------------------
		// Class constants
		//----------------------------------------------------------------------
		
		public static const DEF_HEIGHT	: Number = 130;
		public static const DEF_WIDTH	: Number = 170;

		//------------------------------
		// Property names
		//------------------------------
		
		public static const PROP_NAME			: String = "prop.name";
		public static const PROP_HEADCOLOR	: String = "prop.headColor";
		public static const PROP_FILLCOLOR	: String = "prop.fillColor";
		public static const PROP_DEPARTMENT	: String = "prop.department";


		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		public var tempData: Object = new Object();
		private var _propInfos: Array;
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		public function Lane(owner: Pool) {
			super();
			
			_owner = owner;	
			_width = DEF_WIDTH;
			_height = DEF_HEIGHT;
		}
		
		
		//----------------------------------------------------------------------
		// IPropertySource
		//----------------------------------------------------------------------

		public function get displayName(): String {
			return resourceManager.getString("WorkbenchETC", "departmentText");
		}

		/**
		 * 프로퍼티 소스가 제공하는 IPropertyInfo 목록
		 */
		public function getPropertyInfos(): Array /* of IPropertyInfo */ {
			if (!_propInfos) {
				_propInfos = createPropertyInfos();
			}
			
			return _propInfos;
		}

		public function refreshPropertyInfos(): Array{
			return getPropertyInfos();
		}
		
		protected function createPropertyInfos(): Array /* of IPropertyInfo */ {
			return [
				new TextPropertyInfo(PROP_NAME, resourceManager.getString("WorkbenchETC", "nameText"), "", ""),
//				new DepartmentPropertyInfo(PROP_DEPARTMENT, resourceManager.getString("WorkbenchETC", "departmentText"), "", "")
			];
		}
		
		/**
		 * id 에 해당하는 프로퍼티의 현재 값을 리턴
		 */
		public function getPropertyValue(id: String): Object {
			switch (id) {
				case PROP_NAME:
					return this.name;
					
				case PROP_HEADCOLOR:
					return this.headColor;
					
				case PROP_FILLCOLOR:
					return this.fillColor;
					
				case PROP_DEPARTMENT:
					return this.deptName ? this.deptName : this.deptId;
					
				default:
					return null;
			}
		}
		
		/**
		 * id 에 해당하는 프로퍼티의 값을 설정
		 */
		public function setPropertyValue(id: String, value: Object): void {
			switch (id) {
				case PROP_NAME:
					name = value.toString();
					break;
					
				case PROP_HEADCOLOR:
					headColor = uint(value);
					break;
					
				case PROP_FILLCOLOR:
					fillColor = uint(value);
					break;
					
				default:
					break;
			}
		}
		
		/**
		 * 현재 프로퍼티의 값이 기본값과 다른 값으로 설정되어 있는가?
		 * 의미있는 기본값이 존재하지 않는 프로퍼티라면 true를 리턴한다.
		 */
		public function isPropertySet(id: String): Boolean {
			return true;
		}
		
		/**
		 * 기본값으로 reset 가능한 프로퍼티인가?
		 */
		public function isPropertyResettable(id: String): Boolean {
			return false;
		}
		
		/**
		 * 프로퍼티의 값을 기본값으로 변경
		 */
		public function resetPropertyValue(id: Object): void {
		}


		//----------------------------------------------------------------------
		// XPDL Properties
		//----------------------------------------------------------------------
		
		/**
		 * id
		 */
		private var _id: int;

		public function get id(): int {
			return _id;
		}
		
		public function set id(value: int): void {
			_id = value;
		}
		
		/**
		 * name
		 */
		private var _name: String = resourceManager.getString("WorkbenchETC", "departmentText");

		public function get name(): String {
			return _name;
		}
		
		public function set name(value: String): void {
			if (value != _name) {
				var oldValue: Object = _name;
				_name = value;
				firePropChanged(PROP_NAME, oldValue);
			}
		}
		
		/**
		 * parentLane
		 */
		private var _parentLane: int;		

		public function get parentLane(): int {
			return _parentLane;
		}
		
		public function set parentLane(value: int): void {
			_parentLane = value;
		}

		/**
		 * page
		 */		
		private var _page: int;

		public function get page(): int {
			return _page;
		}
		
		public function set page(value: int): void {
			_page = value;
		}
		
		/**
		 * height
		 */
		private var _height: Number;

		public function get height(): Number {
			return _height;
		}
		
		public function set height(value: Number): void {
			_height = value;
		}
		
		/**
		 * width
		 */
		private var _width: Number;

		public function get width(): Number {
			return _width;
		}
		
		public function set width(value: Number): void {
			_width = value;
		}
		
		/**
		 * borderColor
		 */
		private var _borderColor: uint;

		public function get borderColor(): uint {
			return _borderColor;
		}
		
		public function set borderColor(value: uint): void {
			_borderColor = value;
		}

		/**
		 * headColor
		 */
		private var _headColor: uint = 0xcccccc;

		public function get headColor(): uint {
			return _headColor;
		}
		
		public function set headColor(value: uint): void {
			if (value != _headColor) {
				var oldValue: uint = _headColor;
				_headColor = value;
				firePropChanged(PROP_HEADCOLOR, oldValue);
			}
		}
		
		/**
		 * fillColor
		 */
		private var _fillColor: uint = 0xffffff;

		public function get fillColor(): uint {
			return _fillColor;
		}
		
		public function set fillColor(value: uint): void {
			if (value != _fillColor) {
				var oldValue: uint = _fillColor;
				_fillColor = value;
				firePropChanged(PROP_FILLCOLOR, oldValue);
			}
		}
		
		/**
		 * 부서 아이디
		 */
		private var _deptId: String;
		
		public function get deptId(): String {
			return _deptId;
		}
		
		public function set deptId(value: String): void {
			if (value != _deptId) {
				var oldValue: String = _deptId;
				_deptId = value;
				firePropChanged(PROP_DEPARTMENT, oldValue);
			}
		}
		
		/**
		 * 부서명
		 */
		private var _deptName: String;
		
		public function get deptName(): String {
			return _deptName;
		}
		
		public function set deptName(value: String): void {
			if (value != _deptName) {
				//var oldValue: String = _deptName;
				_deptName = value;
				//firePropChanged(PROP_DEPARTMENT, oldValue);
			}
		}
		

		//----------------------------------------------------------------------
		// IXPDLElement
		//----------------------------------------------------------------------

		override protected function doRead(src: XML): void {
			//id 				= src.@Id;
			name			= src.@Name;
			parentLane		= src.@ParentLane;
			
			readGraphicsInfo(src._ns::NodeGraphicsInfos._ns::NodeGraphicsInfo[0]);
		}
		
		override protected function doWrite(dst: XML): void {
			dst.@Id			= id;
			dst.@Name		= name;
			dst.@ParentLane = parentLane;
			
			dst._ns::NodeGraphicsInfos._ns::NodeGraphicsInfo = "";
			writeGraphicsInfo(dst._ns::NodeGraphicsInfos._ns::NodeGraphicsInfo[0]);
		}
		
		private function readGraphicsInfo(xml: XML): void {
			_page			= xml.@Page;
			_height			= xml.@Height;
			_width			= xml.@Width;
	
			if (xml.attribute("BorderColor").length() > 0)
				_borderColor	= xml.@BorderColor;

			if (xml.attribute("FillColor").length() > 0)
				_fillColor		= xml.@FillColor;
			
			if (xml.attribute("HeadColor").length() > 0)
				_headColor		= xml.@HeadColor;
		}
		
		private function writeGraphicsInfo(xml: XML): void {
			xml.@Page			= _page; 
			xml.@Height			= _height; 
			xml.@Width			= _width; 
			xml.@BorderColor	= _borderColor; 
			xml.@FillColor		= _fillColor;
			xml.@HeadColor		= _headColor; 
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * owner
		 */		
		private var _owner: Pool;

		public function get owner(): Pool {
			return _owner;
		}
		
		public function set owner(pool:Pool): void {
			_owner = pool;
		}
		
		/**
		 * isVertical
		 */
		public function get isVertical(): Boolean {
			return _owner.isVertical;
		}
		
		public function set isVertical(value: Boolean): void {
			var t: Number = width;
			_width = _height;
			_height = t;
		}
		
		/**
		 * size
		 */
		public function get size(): Number {
			return isVertical ? width : height;
		}
		
		public function set size(value: Number): void {
			if (isVertical)
				width = value;
			else
				height = value;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override protected function isHiddenProperty(property: String): Boolean {
			return property == "firstLane" ||
			        property == "lastLane" || 
			        property == "owner";
		}
		

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		private function firePropChanged(prop: String, oldValue: Object): void {
			dispatchEvent(new LaneChangeEvent(LaneChangeEvent.CHANGE, this, prop, oldValue));
			
			if (owner.diagram)
				XPDLDiagram(owner.diagram).laneChanged(this, prop, oldValue);
		}
	}
}