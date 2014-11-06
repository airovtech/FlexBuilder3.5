////////////////////////////////////////////////////////////////////////////////
//  Department.as
//  2008.04.08, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.server
{
	/**
	 * 그룹 모델
	 */
	public class Group {

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _children: Array = [];


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function Group() {
			super();
		}
		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * loaded
		 */
		public var loaded: Boolean;
		
		/**
		 * id
		 */
		public var id: String;
		
		/**
		 * name
		 */
		public var name: String;
		
		/**
		 * label
		 */
		public function get label(): String {
			return name;
		}
		
		/**
		 * children
		 */
		public function get children(): Array {
			return _children;
		}

		
		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		
		public function clearChildren(): void {
			_children = [];
		}
		
		public function addItems(items: Array): void {
			_children = _children.concat(items);
		}
	}
}