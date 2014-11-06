////////////////////////////////////////////////////////////////////////////////
//  DiagramTreeLane.as
//  2008.02.27, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.navigator
{
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.model.pool.Lane;
	import com.maninsoft.smart.modeler.assets.DiagramNavigatorAssets;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * DiagramTree의 lane node. lane을 나타낸다.
	 */
	public class DiagramTreeLane extends DiagramTreeNode {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _lane: Lane;
		private var _children: ArrayCollection;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function DiagramTreeLane(lane: Lane) {
			super();
			
			_lane = lane;
			_children = new ArrayCollection();
		}

		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		public function get lane(): Lane {
			return _lane;
		}

		
		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------

		public function getActivityItem(activity: Activity): DiagramTreeActivity {
			for each (var act: DiagramTreeNode in _children) {
				if (act is DiagramTreeActivity && DiagramTreeActivity(act).activity == activity)
					return act as DiagramTreeActivity;
			}
			
			return null;
		}
				
		
		//----------------------------------------------------------------------
		// Overriden properties
		//----------------------------------------------------------------------
		
		override public function get label(): String {
			return _lane.name;
		}
		
		override public function get icon(): Class {
			return DiagramNavigatorAssets.laneIcon;
		}

		override public function get children(): Array {
			return (_children.length > 0) ? _children.toArray() : null;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function refreshChildren(): void {
			_children.removeAll();
			
			for each (var act: Activity in _lane.owner.getActivitiesInLane(_lane.id)) {
				var n: DiagramTreeActivity = new DiagramTreeActivity(act);
				n._parent = this;
				n.refreshChildren();
				_children.addItem(n);
			}
			
			var p: DiagramTreeProxy = new DiagramTreeProxy(DiagramTreeProxy.PROXY_ACTIVITY);
			p._parent = this;
			_children.addItem(p);
		}
	}
}