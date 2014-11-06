////////////////////////////////////////////////////////////////////////////////
//  DiagramTreeNode.as
//  2008.02.27, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.navigator
{

	import com.maninsoft.smart.modeler.assets.DiagramNavigatorAssets;
	
	/**
	 * DiagramNavigator 트리를 구성하는 노드들의 base class
	 */
	public class DiagramTreeNode	{
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function DiagramTreeNode() {
			super();
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * label
		 */
		public function get label(): String {
			return "node";
		}
		
		/**
		 * icon
		 */
		public function get icon(): Class {
			return DiagramNavigatorAssets.nodeIcon;
		}
		
		/**
		 * parent
		 */
		internal var _parent: DiagramTreeNode;
		
		public function get parent(): DiagramTreeNode {
			return _parent;
		}
		
		/**
		 * children
		 */
		public function get children(): Array /* of DiagramNavigatorNode */ {
			return null;
		}

		public function get editable(): Boolean {
			return true;
		}
		
		public function get removable(): Boolean {
			return true;
		}

		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------

		/**
		 * 기존의 자식 노드들을 모두 삭제하고, 새로 구성한다.
		 */
		public function refreshChildren(): void {
		}
		
	}
}