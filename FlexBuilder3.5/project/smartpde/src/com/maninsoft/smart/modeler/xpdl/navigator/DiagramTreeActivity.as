////////////////////////////////////////////////////////////////////////////////
//  DiagramTreeActivity.as
//  2008.02.27, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.navigator
{
	import com.maninsoft.smart.modeler.xpdl.model.AndGateway;
	import com.maninsoft.smart.modeler.xpdl.model.EndEvent;
	import com.maninsoft.smart.modeler.xpdl.model.StartEvent;
	import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
	import com.maninsoft.smart.modeler.xpdl.model.XorGateway;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.assets.DiagramNavigatorAssets;
	
	/**
	 * DiagramTree의 activity node. activity를 나타낸다.
	 */
	public class DiagramTreeActivity extends DiagramTreeNode {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _activity: Activity;
		private var _formNode: DiagramTreeForm;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function DiagramTreeActivity(activity: Activity) {
			super();
			
			_activity = activity;
		}

		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		public function get activity(): Activity {
			return _activity;
		}

		
		//----------------------------------------------------------------------
		// Overriden properties
		//----------------------------------------------------------------------
		
		override public function get label(): String {
			return _activity.name;
		}
		
		override public function get icon(): Class {
			if (_activity is StartEvent)
				return DiagramNavigatorAssets.startIcon;
				
			if (_activity is EndEvent)
				return DiagramNavigatorAssets.endIcon;
				
			if (_activity is AndGateway)
				return DiagramNavigatorAssets.andIcon;
				
			if (_activity is XorGateway)
				return DiagramNavigatorAssets.xorIcon;

			return DiagramNavigatorAssets.taskIcon;
		}

		override public function get children(): Array {
			return _formNode ? [_formNode] : null;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function refreshChildren(): void {
			if (_activity is TaskApplication && TaskApplication(_activity).formId) {
				_formNode = new DiagramTreeForm(_activity as TaskApplication);
				_formNode._parent = this;
			}
			else {
				_formNode = null;
			}
		}
	}
}