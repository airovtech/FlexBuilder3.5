////////////////////////////////////////////////////////////////////////////////
//  UnexecutableCommand.as
//  2007.12.24, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.command
{
	/** 
	 * 실행 불가능한 command
	 */
	public class UnexecutableCommand extends Command {
		
		//----------------------------------------------------------------------
		// Class constants
		//----------------------------------------------------------------------
		
		/** Singleton */
		public static const SINGLETON: UnexecutableCommand = new UnexecutableCommand();
		
		
		//----------------------------------------------------------------------
		// Class methods
		//----------------------------------------------------------------------

		public static function getCommand(): Command {
			return SINGLETON;
		}
		

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function canExecute(): Boolean {
			return false;
		}
		
		override public function canUndo(): Boolean {
			return false;
		}
	}
}