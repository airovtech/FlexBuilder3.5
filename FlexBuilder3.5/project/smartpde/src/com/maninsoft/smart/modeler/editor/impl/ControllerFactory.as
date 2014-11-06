////////////////////////////////////////////////////////////////////////////////
//  ControllerFactory.as
//  2007.12.13, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.editor.impl
{
	import com.maninsoft.smart.modeler.controller.Controller;
	import com.maninsoft.smart.modeler.controller.LinkController;
	import com.maninsoft.smart.modeler.controller.NodeController;
	import com.maninsoft.smart.modeler.editor.DiagramEditor;
	import com.maninsoft.smart.modeler.editor.IControllerFactory;
	import com.maninsoft.smart.modeler.model.DiagramObject;
	import com.maninsoft.smart.modeler.model.Link;
	import com.maninsoft.smart.modeler.model.Node;
	
	/**
	 * Abstract controller factory
	 * 반드시 상속해야 한다.
	 */
	public class ControllerFactory implements IControllerFactory 	{
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		/** Storage for property owner */
		private var _owner: DiagramEditor;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function ControllerFactory(owner: DiagramEditor) {
			super();
			
			_owner = owner;
		}	
		

		//----------------------------------------------------------------------
		// IControllerFactory
		//----------------------------------------------------------------------
		
		public function createController(model: DiagramObject): Controller {
			if (model is Node) {
				return new NodeController(model as Node);
			} else if (model is Link) {
				return new LinkController(model as Link);
			}
			
			return null;
		}
		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		public function get owner(): DiagramEditor {
			return _owner;
		}
	}
}