////////////////////////////////////////////////////////////////////////////////
//  ITool.as
//  2007.12.21, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.editor
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	/**
	 * Tool
	 */
	public interface ITool {
		
		function activate(): void;
		function deactivate(): void;
		
		function keyDown(event: KeyboardEvent): void;
		function keyUp(event: KeyboardEvent): void;
		
		function click(event: MouseEvent): void;
		function doubleClick(event: MouseEvent): void;
		function mouseDown(event: MouseEvent): void;
		function mouseMove(event: MouseEvent): void;
		function mouseUp(event: MouseEvent): void;
		function mouseOver(event: MouseEvent): void;
		function mouseOut(event: MouseEvent): void;
	}
}