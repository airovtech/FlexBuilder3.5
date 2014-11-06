////////////////////////////////////////////////////////////////////////////////
//  DiagramTreeRoot.as
//  2008.02.27, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.navigator
{
	import com.maninsoft.smart.modeler.xpdl.model.Pool;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.model.pool.Lane;
	import com.maninsoft.smart.modeler.assets.DiagramNavigatorAssets;
	
	
	import mx.collections.ArrayCollection;
	
	/**
	 * DiagramTree의 root node. 다이어그램 자체를 나타낸다.
	 */
	public class DiagramTreeRoot extends DiagramTreeNode {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		protected var _diagram: XPDLDiagram;
		protected var _children: ArrayCollection;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function DiagramTreeRoot(diagram: XPDLDiagram)	{
			super();
			
			_diagram = diagram;
			_children = new ArrayCollection();
			refreshChildren();
		}


		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		
		public function getLaneItem(lane: Lane): DiagramTreeLane {
			for each (var item: DiagramTreeNode in _children) {
				if (item is DiagramTreeLane && DiagramTreeLane(item).lane == lane)
					return item as DiagramTreeLane;
			}
			
			return null;
		}
		
		public function getActivityItem(activity: Activity): DiagramTreeActivity {
			for each (var lane: DiagramTreeNode in _children) {
				if (lane is DiagramTreeLane) {
					var act: DiagramTreeActivity = DiagramTreeLane(lane).getActivityItem(activity);
					
					if (act)
						return act;
				}
			}
			
			return null;
		}

		
		//----------------------------------------------------------------------
		// Overriden properties
		//----------------------------------------------------------------------
		
		override public function get label(): String {
			var str: String = null;
			
			if (_diagram)
				str = _diagram.xpdlPackage.process.name;
			
			if (!str)
				str = "Process";
				
			return str;	
		}
		
		override public function get icon(): Class {
			return DiagramNavigatorAssets.processIcon;
		}
		
		override public function get children(): Array {
			return (_children.length > 0) ? _children.toArray() : null;
		}

		override public function get editable(): Boolean {
			return false;
		}
		
		override public function get removable(): Boolean {
			return false;
		}

		
		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function refreshChildren(): void {
			_children.removeAll();
			
			if (_diagram == null) 
				return;
			
			var pool: Pool = _diagram.pool;
			
			if (pool == null)
				return;
				
			for each (var lane: Lane in pool.lanes) {
				var laneNode: DiagramTreeLane = new DiagramTreeLane(lane);
				laneNode._parent = this;
				laneNode.refreshChildren();
				_children.addItem(laneNode);
			}			
			
			_children.addItem(new DiagramTreeProxy(DiagramTreeProxy.PROXY_LANE));			
		}
	}
}