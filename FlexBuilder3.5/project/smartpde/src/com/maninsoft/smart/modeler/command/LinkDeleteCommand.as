////////////////////////////////////////////////////////////////////////////////
//  LinkDeleteCommand.as
//  2008.01.05, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.command
{
	import com.maninsoft.smart.modeler.model.Diagram;
	import com.maninsoft.smart.modeler.model.Link;
	
	/**
	 * 링크를 삭제하는 커맨드
	 */
	public class LinkDeleteCommand extends Command {

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _diagram: Diagram;
		private var _link: Link;

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function LinkDeleteCommand(link: Link) {
			super();
			
			_link = link;
			_diagram = link.diagram;
		}
		
		
		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function execute(): void {
			redo();
		}
		
		override public function redo(): void {
			_diagram.removeLink(_link);
		}
		
		override public function undo(): void  {
			_diagram.addLink(_link);
		}
	}
}