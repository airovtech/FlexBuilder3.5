////////////////////////////////////////////////////////////////////////////////
//  IControllerFactory.as
//  2007.12.13, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.editor
{
	import com.maninsoft.smart.modeler.controller.Controller;
	import com.maninsoft.smart.modeler.model.DiagramObject;
	
	/**
	 * Controller factory
	 */
	public interface IControllerFactory {
		
		function createController(model: DiagramObject): Controller;
	}
}