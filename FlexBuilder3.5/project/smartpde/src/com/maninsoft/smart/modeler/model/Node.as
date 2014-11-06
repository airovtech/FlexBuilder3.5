////////////////////////////////////////////////////////////////////////////////
//  Node.as
//  2007.12.13, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.model
{
	import com.maninsoft.smart.modeler.common.ArrayCollectionUtils;
	import com.maninsoft.smart.modeler.common.Size;
	import com.maninsoft.smart.modeler.model.events.NodeChangeEvent;
	import com.maninsoft.smart.modeler.model.events.NodeEvent;
	import com.maninsoft.smart.modeler.model.events.NodeValueEvent;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * Node
	 */
	public class Node extends DiagramObject {
		
		//----------------------------------------------------------------------
		// Class consts
		//----------------------------------------------------------------------

		public static const PROP_X		: String = "prop.x";
		public static const PROP_Y		: String = "prop.y";
		public static const PROP_POSITION	: String = "prop.position";
		public static const PROP_SIZE	    : String = "prop.size";
		public static const PROP_BOUNDS	: String = "prop.bounds";

		public static const EMPTY_LINKS: Array = new Array();


		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		/** Storage for parent */
		private var _parent: Node;
		/** Storage for children */
		private var _children: ArrayCollection;
		
		/** Storage for source links */
		protected var _sourceLinks: ArrayCollection;
		/** Storage for target links */
		protected var _targetLinks: ArrayCollection;
		
		/** 
		 * Storage for property x
		 * int 에서 Number로 바꿨더니 에러가 몇개 발생했다. 
		 * 이유는 int 는 기본값이 0 이지만, Number는 기본값이 NaN 이기 때문이었다.
		 * Number 필드는 대부분 초기화가 필요할 것이다. 
		 */
		protected var _x: Number = 0;
		/** Storage for property y */
		protected var _y: Number = 0;
		/** Storage for property width */
		protected var _width: Number = 50;
		/** Storage for property height */
		protected var _height: Number = 50;
		
		public var sortWeight: Number = 0;
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/**
		 * Constructor
		 */
		public function Node() {
			super();
		}
		
		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * proeprty parent
		 */
		public function get parent(): Node {
			return _parent;
		}
		
		/**
		 * diagram
		 */
		override public function get diagram(): Diagram {
			var p: Node = parent;
			
			while ((p != null) && !(p is RootNode)) {
				p = p.parent;
			}
			
			if (p is RootNode) {
				return RootNode(p).owner;				
			} else {
				return null;
			}	
		}
		
		/**
		 * children
		 */
		public function get children(): Array {
			return _children ? _children.toArray() : null;
		}
		
		/**
		 * 이 노드가 source 인 링크들의 컬렉션
		 */
		public function get sourceLinks(): Array {
			return _sourceLinks ? _sourceLinks.toArray() : EMPTY_LINKS;
		}
		
		public function get outgoingLinks(): Array {
			return sourceLinks;
		}
		
		public function get hasOutgoing(): Boolean {
			return _sourceLinks && _sourceLinks.length > 0;
		}
		
		public function get sortedOutgoingLinks(): Array {
			var links: Array = sourceLinks;
			
			links.sort(function compare(link1: Link, link2: Link): Number {
				return link1.target.sortWeight - link2.target.sortWeight;
			});
			
			return links;
		}
		
		/**
		 * 이 노드가 target 인 링크들의 컬렉션
		 */
		public function get targetLinks(): Array {
			return _targetLinks ? _targetLinks.toArray() : EMPTY_LINKS;
		}
		
		public function get incomingLinks(): Array {
			return targetLinks;
		}
		
		public function get hasIncoming(): Boolean {
			return _targetLinks && _targetLinks.length > 0;
		}
		
		/**
		 * sourceLinks + targetLinks
		 */
		public function get links(): Array {
			return sourceLinks.concat(targetLinks);
		}
		
		/**
		 * position
		 */
		public function get position(): Point {
			return new Point(_x, _y);
		}
		
		public function set position(value: Point): void {
			/*
			 * 변경 가능한 위치인 지 검토한다.
			 * 함수 내에서 적당한 값으로 조정할 수 있다.
			 * 애초에 설정 불가능한 위치이면 false를 리턴한다.
			 */
			//if (checkNewPosition(value) && (value.x != _x || value.y != y)) {
			if (checkNewPosition(value)) {
				var oldValue: Point = position;
				_x = value.x;
				_y = value.y;
				boundsChanged();
				fireChangeEvent(PROP_POSITION, oldValue);
			}
		}

		/**
		 * property x
		 */
		public function get x(): Number {
			return _x;
		}
		
		public function set x(value: Number): void {
			position = new Point(value, _y);
			trace(position.x);
		}
		
		/**
		 * property y
		 */
		public function get y(): Number {
			return _y;
		}
		
		public function set y(value: Number): void {
			position = new Point(_x, value);
		}
		
		/**
		 * property center
		 */
		public function get center(): Point {
			return new Point(x + width / 2, y + height / 2);
		}
		
		public function set center(value: Point): void {
			position = new Point(value.x - width / 2, value.y - height / 2);
		}
		
		/**
		 * bottom
		 */
		public function get bottom(): Number {
			return _y + _height;
		}
		
		public function set bottom(value: Number): void {
			y = value - _height;
		}
		
		/**
		 * right
		 */
		public function get right(): Number {
			return _x + _width;
		}
		
		public function set right(value: Number): void {
			x = value - _width;
		}
		
		
		/**
		 * property width
		 */
		public function get width(): Number {
			return _width;
		}
		
		/*
		public function set width(value: int): void {
			if (value != _width) {
				var oldValue: int = _width;
				_width = value;
				fireChangeEvent(PROP_WIDTH, oldValue);
			}
		}
		*/
		
		/**
		 * property height
		 */
		public function get height(): Number{
			return _height;
		}
		
		/*
		public function set height(value: int): void {
			if (value != _height) {
				var oldValue: int = _height;
				_height = value;
				fireChangeEvent(PROP_HEIGHT, oldValue);
			}
		}
		*/
		
		/**
		 * size
		 */
		public function get size(): Size {
			return new Size(_width, _height);
		}
		
		public function set size(value: Size): void {
			resize(value.width, value.height);
		}
		
		/**
		 * bounds
		 * 위의 size 및 position을 여기 bounds로 모두 통일해야 할 듯 !!!
		 */
		override public function get bounds(): Rectangle {
			return new Rectangle(x, y, width, height);
		}
		
		public function set bounds(r: Rectangle): void {
			//var old: Rectangle = bounds;
			
			size = new Size(r.width, r.height);
			position = r.topLeft;

			/*
			if (!r.equals(old)) {
				
				_x = r.x;
				_y = r.y;
				_width = r.width;
				_height = r.height;
				
				boundsChanged();
				fireChangeEvent(PROP_BOUNDS, old);
			}
			*/
		}
		

		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------

		public function hasChild(): Boolean {
			return _children && (_children.length > 0);
		}
		
		public function addChild(node: Node): void {
			if (!contains(node)) {
				if (!_children)
					_children = new ArrayCollection();
				
				_children.addItem(node);
				node._parent = this;
				dispatchEvent(new NodeEvent(NodeEvent.CREATE, node));
				
				if (diagram)
					diagram.nodeAdded(node);
			}
		}
		
		public function addChildAt(node: Node, index: int): void {
			if (!contains(node)) {
				if (!_children)
					_children = new ArrayCollection();

				_children.addItemAt(node, index);
				node._parent = this;
				dispatchEvent(new NodeEvent(NodeEvent.CREATE, node));
				
				if (diagram)
					diagram.nodeAdded(node);
			}
		}
		
		public function removeChild(node: Node): void {
			if (ArrayCollectionUtils.removeItem(_children, node)) {
				node._parent = null;
				dispatchEvent(new NodeEvent(NodeEvent.REMOVE, node));
				
				if (diagram)
					diagram.nodeRemoved(node);
			}
		}
		
		public function replaceChild(node: Node, newNode: Node): void {
			if (_children) {
				var idx: int = _children.getItemIndex(node);
				
				if (idx >= 0) {
					_children.removeItemAt(idx);
					node._parent = null;
					
					_children.addItemAt(newNode, idx);
					newNode._parent = this;					
					
					dispatchEvent(new NodeValueEvent(NodeEvent.REPLACE, node, newNode));
					
					if (diagram)
						diagram.nodeReplaced(newNode, node);
				}
			}
		}
		
		public function getChildAt(index: int): Node {
			return (_children && _children.length >= index) ? _children[index] : null;
		}
		
		/**
		 * 링크로 연결 가능한 지점들을 Number 배열로 리턴한다.
		 * 하나의 elment가 하나의 지점이 된다.
		 * 몇 개의 지점을 리턴하고, 각 값이 view 상에서 어떤 위치가 되는 지는
		 * 각각의 모델과 view 에 달려 있다.
		 */
		public function getConnectAnchors(): Array {
			var pts: Array = new Array();
			
			pts.push(0);
			pts.push(90);
			pts.push(180);
			pts.push(270);

			return pts;
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
					throw new Error(resourceManager.getString("ProcessEditorMessages", "PEE002") + "(" + anchor + ")");
			}
		}
		
		public function resize(newWidth: int, newHeight: int): void {
			if (newWidth != width || newHeight != height) { 
				var oldSize: Size = size;
				_width = newWidth;
				_height = newHeight;
				boundsChanged();
				fireChangeEvent(PROP_SIZE, oldSize);
			}
		}
		
		public function resizeBy(deltaX: int, deltaY: int): void {
			resize(width + deltaX, height + deltaY);
		}

		/**
		 * 경로상 이미 지난 링크들을 리턴한다.
		 */
		public function getBackwardLinks(): Array /* of Link */ {
			var links: Array = [];
			findBackwardLinks(links, this);
			return links;
		}

		/**
		 * 경로상 앞으로 다가올 링크들을 리턴한다.
		 */
		public function getForwardLinks(): Array /* of Link */ {
			var links: Array = [];
			findForwardLinks(links, this);
			return links;
		}
		
		/**
		 * 경로상 이미 지난 노드들을 리턴한다.
		 */
		public function getBackwardNodes(): Array /* of Node */ {
			var nodes: Array = [];
			findBackwardNodes(nodes, this);
			return nodes;
		}
		
		/**
		 * 경로상 앞으로 다가올 노드들을 리턴한다.
		 */
		public function getForwardNodes(): Array /* of Node */ {
			var nodes: Array = [];
			findForwardNodes(nodes, this);
			return nodes;
		}

		/**
		 * nodeType 노드로 부터 들어오는 링크가 존재하는가?
		 */
		public function isTransitedFrom(nodeType: Class): Boolean {
			for each (var link: Link in _targetLinks) {
				if (link.source is nodeType)
					return true;
			}
			
			return false;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function assign(source: DiagramObject): void {
			super.assign(source);
			
			var node: Node = source as Node;
			
 			_x		= node._x;
 			_y		= node._y;
 			_width	= node._width;
 			_height = node._height;
 			
 			var link: Link;
 			
 			if (node._sourceLinks) {
 				_sourceLinks = new ArrayCollection(node.sourceLinks);
 				
 				for each (link in _sourceLinks) {
 					link.source = this;
 				}
 			}
 			
 			if (node._targetLinks) {
 				_targetLinks = new ArrayCollection(node.targetLinks);
 				
 				for each (link in _targetLinks) {
 					link.target = this;
 				}
 			}
		}

		/**
		 * 프로퍼티 소스가 제공하는 IPropertyInfo 목록
		 */
		override protected function createPropertyInfos(): Array {
			var props: Array = super.createPropertyInfos();
			
			/*
			return props.concat(
				new TextPropertyInfo(PROP_X, "X"),
				new TextPropertyInfo(PROP_Y, "Y"),
				new SizePropertyInfo(PROP_SIZE, "Size")
			);
			*/
			return props;
		}
		
		/**
		 * id 에 해당하는 프로퍼티의 현재 값을 리턴
		 */
		override public function getPropertyValue(id: String): Object {
			switch (id) {
				case PROP_X: 
					return x;
					
				case PROP_Y:
					return y;
					
				case PROP_SIZE:
					return size;
			}
			
			return null;
		}
		
		/**
		 * id 에 해당하는 프로퍼티의 값을 설정
		 */
		override public function setPropertyValue(id: String, value: Object): void {
			switch (id) {
				case PROP_X:
					x = int(value);
					break;
					
				case PROP_Y:
					y = int(value);
					break;
					
				case PROP_SIZE:
					size = Size(value);
					break;
			}
		}
		
		/**
		 * 현재 프로퍼티의 값이 기본값과 다른 값으로 설정되어 있는가?
		 * 의미있는 기본값이 존재하지 않는 프로퍼티라면 true를 리턴한다.
		 */
		override public function isPropertySet(id: String): Boolean {
			return true;
		}
		
		/**
		 * 기본값으로 reset 가능한 프로퍼티인가?
		 */
		override public function isPropertyResettable(id: String): Boolean {
			return false;
		}
		
		/**
		 * 프로퍼티의 값을 기본값으로 변경
		 */
		override public function resetPropertyValue(id: Object): void {
		}

		/**
		 * center(x, y) ==> (y, x);
		 */
		override public function changeXY(): void {
			var c: Point = center;
			
			var t: Number = c.x;
			c.x = c.y;
			c.y = t;
			
			_x = c.x - width / 2;
			_y = c.y - height / 2
		}


		//----------------------------------------------------------------------
		// Internal properties
		//----------------------------------------------------------------------
		

		//----------------------------------------------------------------------
		// Internal Methods
		//----------------------------------------------------------------------
		
		/**
		 * Link가 생성될 때 Diagram 개체에서 호출한다.
		 * 이 링크의 소스 노드에 연결 정보를 추가한다.
		 */
		internal function addSourceLink(link: Link): void {
			if (!_sourceLinks)
				_sourceLinks = new ArrayCollection();
				
			_sourceLinks.addItem(link);
		}
		
		/**
		 * Link가 생성될 때 Diagram 개체에서 호출한다.
		 * 이 링크의 타겟 노드에 연결 정보를 추가한다.
		 */
		internal function removeSourceLink(link: Link): void {
			ArrayCollectionUtils.removeItem(_sourceLinks, link);
		} 

		/**
		 * Link가 삭제될 때 Diagram 개체에서 호출한다.
		 * 이 링크의 소스 노드에 연결 정보를 추가한다.
		 */
		internal function addTargetLink(link: Link): void {
			if (!_targetLinks)
				_targetLinks = new ArrayCollection();
				
			_targetLinks.addItem(link);
		}
		
		/**
		 * Link가 삭제될 때 Diagram 개체에서 호출한다.
		 * 이 링크의 타겟 노드에 연결 정보를 추가한다.
		 */
		internal function removeTargetLink(link: Link): void {
			ArrayCollectionUtils.removeItem(_targetLinks, link);
		} 
	
		/**
		 * 기존에 자식으로 가지고 있던 노드인가?
		 */
		protected function contains(node: Node): Boolean {
			return _children && _children.contains(node);
		}

		/**
		 * 새로 변경 가능한 위치인 지 검토한다.
		 * 함수 내에서 적당한 값으로 조정할 수 있다.
		 * 애초에 설정 불가능한 위치이면 false를 리턴한다.
		 */
		public function checkNewPosition(newPos: Point): Boolean {
			return true;
		}

		/**
		 * 위치타 크기가 변경되었을 때 호출됨.
		 */		
		protected function boundsChanged(): void {
		}
		
		protected function isDiagramProp(prop: String): Boolean {
			return true;
		}
		
		protected function fireChangeEvent(prop: String, oldValue: Object): void {
			trace("Node.fireChangeEvent(" + prop + ", " + oldValue + ")");
			dispatchEvent(new NodeChangeEvent(this, prop, oldValue));

			if (diagram && isDiagramProp(prop)) {
				diagram.nodeChanged(this, prop, oldValue);
			}
		}
		
		private function findBackwardLinks(links: Array, node: Node): void {
			for each (var link: Link in node.incomingLinks) {
				if (links.indexOf(link) < 1) {
					links.push(link);
					findBackwardLinks(links, link.source);
				}
			}
		}

		private function findForwardLinks(links: Array, node: Node): void {
			for each (var link: Link in node.outgoingLinks) {
				if (links.indexOf(link) < 1) {
					links.push(link);
					findForwardLinks(links, link.target);
				}
			}
		}
		
		private function findBackwardNodes(nodes: Array, node: Node): void {
			for each (var link: Link in node.incomingLinks) {
				var t: Node = link.source;
				
				if (nodes.indexOf(t) < 1) {
					nodes.push(t);
					findBackwardNodes(nodes, t);
				}
			}
		}
		
		private function findForwardNodes(nodes: Array, node: Node): void {
			for each (var link: Link in node.outgoingLinks) {
				var t: Node = link.target;
				
				if (nodes.indexOf(t) < 1) {
					nodes.push(t);
					findForwardNodes(nodes, t);
				}
			}
		}
	}
}