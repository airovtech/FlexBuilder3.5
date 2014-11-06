////////////////////////////////////////////////////////////////////////////////
//  LinkEndChangeCommand.as
//  2007.12.26, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.command
{
	import com.maninsoft.smart.modeler.model.Link;
	
	/**
	 * 링크 끝을 다른 노드로 변경시키는 커맨드
	 */
	public class LinkEndChangeCommand extends Command	{
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _link: Link;
		private var _end: int;
		private var _oldAnchor: Number;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function LinkEndChangeCommand(link: Link, end: int) {
			super();
			
			_link = link;
			_end = end;
		}		
		

		
		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function execute(): void {
			redo();
		}
		
		override public function redo(): void {
			_link.source.diagram.addLink(_link);	
		}
		
		override public function undo(): void {
		}
	}
}