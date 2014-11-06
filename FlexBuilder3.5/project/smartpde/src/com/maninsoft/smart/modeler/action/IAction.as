////////////////////////////////////////////////////////////////////////////////
//  IAction.as
//  2008.01.14, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.action
{
	/**
	 * action
	 */
	public interface IAction {
		
		function get label(): String;
		function get icon(): Class;
		function get enabled(): Boolean;
		function get toggled(): Boolean;
		function get type(): String;
		function get groupName(): String;
		
		function execute(): void;
	}
}