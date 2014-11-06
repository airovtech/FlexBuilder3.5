////////////////////////////////////////////////////////////////////////////////
//  LinkEndHandle.as
//  2007.12.29, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.editor.handle
{
	import com.maninsoft.smart.modeler.common.GraphicUtils;
	import com.maninsoft.smart.modeler.controller.LinkController;
	import com.maninsoft.smart.modeler.controller.NodeController;
	import com.maninsoft.smart.modeler.editor.tool.DragTracker;
	import com.maninsoft.smart.modeler.editor.tool.LinkEndTracker;
	import com.maninsoft.smart.modeler.model.Link;
	import com.maninsoft.smart.modeler.model.Node;
	
	import flash.display.Graphics;
	
	/**
	 * 링크 양 끝점 핸들
	 */
	public class LinkEndHandle extends LinkHandle implements IDraggableHandle {

		//----------------------------------------------------------------------
		// Class constants
		//----------------------------------------------------------------------
		
		public static const SOURCE_EDGE: int = 0;
		public static const TARGET_EDGE: int = 1;
		
		/** 기본 크기 */
		public static const DEF_SIZE: int = 6;
		
		

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _edge: int;
		private var _opposite: LinkEndHandle;
		

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function LinkEndHandle(controller: LinkController, edge: int, size: int = DEF_SIZE) {
			super(controller);
			
			_edge = edge;
			
			draw(size);
		}
		
		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * edge
		 */
		public function get edge(): int {
			return _edge;
		}
		
		public function set edge(value: int): void {
			_edge = value;
		}
		
		public function get isSourceEdge(): Boolean {
			return _edge == SOURCE_EDGE;
		}
		
		/**
		 * 반대쪽 핸들
		 */
		public function get opposite(): LinkEndHandle {
			return _opposite;
		}
		
		public function set opposite(value: LinkEndHandle): void {
			_opposite = value;
		}
		
		/**
		 * 이 끝이 속한 노드의 컨트롤러
		 */
		public function get nodeController(): NodeController {
			var link: Link = controller.model as Link;
			var node: Node = (edge == SOURCE_EDGE) ? link.source : link.target;
			
			return controller.editor.findControllerByModel(node) as NodeController;
		}
		
		public function get linkAnchor(): Number {
			var link: Link = controller.model as Link;
			return isSourceEdge ? link.sourceAnchor : link.targetAnchor;
		}
		

		//----------------------------------------------------------------------
		// methods
		//----------------------------------------------------------------------
		
		public function getDragTracker(): DragTracker {
			return new LinkEndTracker(this);
		}

	

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		protected function draw(sz: int): void {
			var g: Graphics = graphics;
			g.clear();
			
			if (controller) {
				//var p: Point = controller.getViewLocation();
			
				//if (p) {
					//GraphicUtils.drawCircle(g, -sz / 2, -sz / 2, sz, sz, fillColor);
					GraphicUtils.drawRect(g, -sz / 2, -sz / 2, sz, sz, fillColor);
				//}
			}
		}
	}
}