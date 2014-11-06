////////////////////////////////////////////////////////////////////////////////
//  IView.as
//  2007.12.15, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.view
{
	import flash.display.DisplayObject;
	
	/**
	 * Diagram 모델의 각 개체를 나타내는 view
	 */
	public interface IView {
		
		function getDisplayObject(): DisplayObject;
		function refresh(): void;
		//function get selected(): Boolean;
		//function set selected(value: Boolean): void;
		
		function doIconClick(icon: IViewIcon, data: Object): void;
	}
}