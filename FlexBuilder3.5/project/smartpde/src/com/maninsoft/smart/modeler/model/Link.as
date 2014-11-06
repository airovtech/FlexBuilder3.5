////////////////////////////////////////////////////////////////////////////////
//  Link.as
//  2007.12.13, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.model
{
	import com.maninsoft.smart.modeler.model.events.LinkChangeEvent;
	import com.maninsoft.smart.workbench.common.property.TextPropertyInfo;
	
	import flash.geom.Point;
	
	/**
	 * Link
	 */
	public class Link extends DiagramObject {
		
		//----------------------------------------------------------------------
		// Class consts
		//----------------------------------------------------------------------

		//------------------------------
		// Properties
		//------------------------------
		public static const PROP_SOURCE		: String = "prop.source";
		public static const PROP_TARGET		: String = "prop.target";
		public static const PROP_CONNECT_TYPE	: String = "prop.connectType"; 
		public static const PROP_PATH 		: String = "prop.path";
		public static const PROP_TEXTPOS  	: String = "prop.textPos";
		public static const PROP_LINECOLOR  	: String = "prop.lineColor";
		public static const PROP_LINEWIDTH  	: String = "prop.lineWidth";
		public static const PROP_ISBACKWARD  	: String = "prop.isBackward";
		
		

		//------------------------------
		// Connect types
		//------------------------------

		public static const CONNECT_DEFAULT: String = "default";


		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function Link(source: Node, target: Node, path: String = null, connectType: String = null) {
			super();
			
			_source = source;
			_target = target;
			_path   = (path && path.length > 0) ? path : calcDefaultPath();
			_textPos = "0,0";
			_connectType = connectType ? connectType : CONNECT_DEFAULT;
		}
		
		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		override public function get diagram(): Diagram {
			return _source.diagram;
		}
		
		/**
		 * source
		 */
		private var _source: Node;

		public function get source(): Node {
			return _source;
		}
		
		public function set source(value: Node): void {
			_source = value;
		}
		
		/**
		 * target
		 */
		private var _target: Node;

		public function get target(): Node {
			return _target;
		}
		
		public function set target(value: Node): void {
			_target = value;
		}
		
		/** 
		 * connect type
		 */
		private var _connectType: String = CONNECT_DEFAULT;

		public function get connectType(): String {
			return _connectType;
		}
		
		public function set connectType(value: String): void {
			if (value != _connectType) {
				var oldType: String = _connectType;
				_connectType = value;
				fireChangeEvent(PROP_CONNECT_TYPE, oldType);
			}
		}
		
		/**
		 * "source Anchor,선분offset값들,targetAnchor" 로 관리된다.
		 * sourceAnchor, targetAnchor는 각 노드의 사각형 경계를 기준으로
		 * 위쪽 중앙 지점을 0으로 시작해서 360도 방향값으로 표현된다.
		 * 예를들어 오른쪽 경계선 중앙은 90 아래쪽 중앙은 180이다.
		 * 이 값을 어떻게 표현할지는 라우터와 view에 따라 달라질 수 있을 것이다. 
		 * sourceAnchor와 targetAnchor 사이에는 기본으로 계산된 
		 * 경로를 기준으로 위치 변경 가능한 선분의 offset 값이다.
		 * 이 선분 offset값의 해석은 각 router에 따라 달라 질수 있을 것이다.
		 * 기본 라우터인 맨하탄라우터의 경우를 예로 들면,
		 * sourceAnchor가 90이고, targetAnchor가 270이고 양끝의 y좌표가 다르면
		 * 링크는 세개의 선분으로 구성되는 연결선으로 표시될 것이다.
		 * 이 때 두번째 선분의 위치를 좌우로 이동 가능할 것인데,
		 * 기본 계산된 위치에서 왼쪽으로 이동했다면 마이너스값, 오른쪽으로 이동했다면 플러스값을 가지게 될 것이다.
		 */
		private var _path: String;

		public function get path(): String {
			return _path;
		}
		
		public function set path(value: String): void {
			if (value != _path) {
				var oldPath: String = _path;
				_path = value;
				fireChangeEvent(PROP_PATH, oldPath);
			}
		}
		
		/**
		 * sourceAnchor
		 */
		public function get sourceAnchor(): Number {
			return _path.split(",")[0];
		}
		
		/**
		 * targetAnchor
		 */
		public function get targetAnchor(): Number {
			var paths: Array = _path.split(",");
			return paths[paths.length - 1];
		}
		
		/**
		 * 링크뷰에 표시될 텍스트의 위치를 지정
		 * 위치값의 해석은 라우터와 링크뷰에 따라 결정될 것이다.
		 * 기본 맨하탄 라우터에서는 "0,0" 위치는 시작점에서 출발하는 첫 선분의 중앙에 텍스트가 
		 * 표시되는 지점이 될 것이다.
		 */
		private var _textPos: String;

		public function get textPos(): String {
			return _textPos ? _textPos : "0,0";
		}
		
		public function set textPos(value: String): void {
			if (value != _textPos) {
				var oldPos: String = _textPos;
				_textPos = value;
				fireChangeEvent(PROP_TEXTPOS, oldPos);
			}
		}
		
		/**
		 * textPos로 부터 Point 개체를 리턴한다.
		 */
		public function get textPoint(): Point {
			var arr: Array = textPos.split(",");
			var p: Point;
			
			try {
				p = new Point(Number(arr[0]), Number(arr[1]));
				
			} catch (e: Error) {
				p = new Point();
			}
			
			return p;
		}
		
		/**
		 * lineColor
		 */
		private var _lineColor: uint = 0x276b83 /* gray */; 
		 
		public function get lineColor(): uint {
			return _lineColor;
		}
		
		public function set lineColor(value: uint): void {
			if (value != _lineColor) {
				var oldColor: uint = _lineColor;
				_lineColor = value;
				fireChangeEvent(PROP_LINECOLOR, oldColor);
			}
		}
		
		/**
		 * lineWidth
		 */
		private var _lineWidth: Number = 1;
		
		public function get lineWidth(): Number {
			return _lineWidth;
		}
		
		public function set lineWidth(value: Number): void {
			if (value != _lineWidth) {
				var oldValue: Number = _lineWidth;
				_lineWidth = value;
				fireChangeEvent(PROP_LINEWIDTH, oldValue);
			}
		}
		
		/**
		 * isBackaward
		 */
		private var _isBackward: Boolean;
		
		public function get isBackward(): Boolean {
			return _isBackward;
		}
		
		public function set isBackward(value: Boolean): void {
			if (value != _isBackward) {
				var oldValue: Boolean = _isBackward;
				_isBackward = value;
				fireChangeEvent(PROP_ISBACKWARD, oldValue);
			}
		}
		

		//----------------------------------------------------------------------
		// Overriden properties
		//----------------------------------------------------------------------

		
		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override public function changeXY(): void {
			var paths: Array = _path.split(",");
			var newPaths: Array = [];
			
			// 일단 paths에는 두 점만 있다고 가정한다.
			for each (var p: Number in paths) {
				var np: Number = 0;
				
				switch (p) {
					case 0: np = 270; break;
					case 90: np = 180; break;
					case 180: np = 90; break;
					case 270: np = 0; break;
				}
				
				newPaths.push(np);
			}
			
			this.path = newPaths[0] + "," + newPaths[1];
		}

		
		//----------------------------------------------------------------------
		// Internal properties
		//----------------------------------------------------------------------

		/**
		 * 프로퍼티 소스가 제공하는 IPropertyInfo 목록
		 */
		override protected function createPropertyInfos(): Array {
			var props: Array = super.createPropertyInfos();
			
			return props.concat(
				new TextPropertyInfo(PROP_SOURCE, "source"),
				new TextPropertyInfo(PROP_TARGET, "target"),
				new TextPropertyInfo(PROP_PATH, "path")
			);
		}
		
		/**
		 * id 에 해당하는 프로퍼티의 현재 값을 리턴
		 */
		override public function getPropertyValue(id: String): Object {
			switch (id) {
				case PROP_PATH:
					return path;
			}
			
			return null;
		}
		
		/**
		 * id 에 해당하는 프로퍼티의 값을 설정
		 */
		override public function setPropertyValue(id: String, value: Object): void {
		}
		

		//----------------------------------------------------------------------
		// Internal Methods
		//----------------------------------------------------------------------

		protected function isDiagramProp(prop: String): Boolean {
			return prop != PROP_ISBACKWARD;
		}

		protected function fireChangeEvent(prop: String, oldValue: Object): void {
			trace("Link.fireChangeEvent(" + prop + ", " + oldValue + ")");
			dispatchEvent(new LinkChangeEvent(this, prop, oldValue));
			
			if (diagram && isDiagramProp(prop)) {
				diagram.linkChanged(this, prop, oldValue);
			}
		}
		
		protected function calcDefaultPath(): String {
			return "90,270";
		}
	}
}