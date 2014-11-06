////////////////////////////////////////////////////////////////////////////////
//  ActivityView.as
//  2008.04.18, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.view.base
{
	import com.maninsoft.smart.modeler.xpdl.syntax.Problem;
	import com.maninsoft.smart.modeler.xpdl.view.viewicon.ProblemIcon;
	
	/**
	 * Activity view
	 */
	public class ActivityView extends XPDLNodeView {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function ActivityView() {
			super();
		}

		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * problem
		 */
		private var _problem: Problem;
		
		public function get problem(): Problem {
			return _problem;
		}
		
		public function set problem(value: Problem): void {
			_problem = value;
		}

		private var _isMultiInstance:Boolean;
	
		public function get isMultiInstance(): Boolean{
			return _isMultiInstance;
		}
		
		public function set isMultiInstance(value:Boolean): void{
			_isMultiInstance = value;
		}

		private var _multiInstanceBehavior:String;
	
		public function get multiInstanceBehavior(): String{
			return _multiInstanceBehavior;
		}
		
		public function set multiInstanceBehavior(value:String): void{
			_multiInstanceBehavior = value;
		}
		
		//----------------------------------------------------------------------
		// Internal properties
		//----------------------------------------------------------------------

		/**
		 * problemIcon
		 */
		private var _problemIcon: ProblemIcon;
		
		protected function get problemIcon(): ProblemIcon {
			if (!_problemIcon) {
				_problemIcon = new ProblemIcon(this);
			}
		
			return _problemIcon;
		}


		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		protected function removeProblemIcon(): void {
			if (_problemIcon && contains(_problemIcon)) {
				removeChild(_problemIcon);
			}
		}
	}
}