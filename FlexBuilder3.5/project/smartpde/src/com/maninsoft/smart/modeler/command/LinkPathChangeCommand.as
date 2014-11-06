////////////////////////////////////////////////////////////////////////////////
//  LinkPathChangeCommand.as
//  2007.12.31, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
//
//  Addio 2007 !! 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.command
{
	import com.maninsoft.smart.modeler.model.Link;
	
	
	/**
	 * 링크의 앵커포인트 혹은 선분 위치 등 경로를 변경하는 커맨드
	 */
	public class LinkPathChangeCommand extends Command {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _link: Link;
		private var _path: String;
		
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function LinkPathChangeCommand(link: Link, path: String) {
			super();
			
			_link = link;
			_path = path;
		}
		
		
		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function execute(): void {
			redo();
		}
		
		override public function undo(): void  {
			_link.path = _path;
		}
		
		override public function redo(): void {
			var oldPath: String = _link.path;
			_link.path = _path;
			_path = oldPath;
		}
	}
}