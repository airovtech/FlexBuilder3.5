////////////////////////////////////////////////////////////////////////////////
//  PackageTreeFormRoot.as
//  2008.04.25, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.packages
{
	import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.assets.DiagramNavigatorAssets;
	import com.maninsoft.smart.modeler.xpdl.navigator.DiagramTreeNode;
	import com.maninsoft.smart.modeler.xpdl.server.Server;
	import com.maninsoft.smart.modeler.xpdl.server.TaskForm;
	
	
	import mx.collections.ArrayCollection;
	
	/**
	 * 단위 업무 목록 root
	 */
	public class PackageTreeFormRoot extends DiagramTreeNode {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _server: Server;
		private var _diagram: XPDLDiagram;
		private var _children: ArrayCollection;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function PackageTreeFormRoot(server: Server, diagram: XPDLDiagram) {
			super();
			
			_server = server;
			_diagram = diagram;
		}

		
		//----------------------------------------------------------------------
		// Overriden properties
		//----------------------------------------------------------------------
		
		override public function get label(): String {
			return "단위 업무";	
		}
		
		override public function get icon(): Class {
			return DiagramNavigatorAssets.unitWorkIcon;
		}
		
		override public function get children(): Array {
			return (_children.length > 0) ? _children.toArray() : null;
		}

		override public function get editable(): Boolean {
			return false;
		}


		
		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function refreshChildren(): void {
			if (!_children)
				_children = new ArrayCollection();
			
			_children.removeAll();
			
			for each (var form: TaskForm in _server.taskForms) {
				if (isSingle(form))
					_children.addItem(new PackageTreeForm(form));
			}
			
			function isSingle(form: TaskForm): Boolean {
				if (_diagram) {
					for each (var task: TaskApplication in _diagram.pool.getActivities(TaskApplication))
						if (task.formId == form.formId)
							return false;
				}
						
				return true;
			}
		}
	}
}