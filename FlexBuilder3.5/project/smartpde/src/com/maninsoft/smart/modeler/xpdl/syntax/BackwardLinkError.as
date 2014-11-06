////////////////////////////////////////////////////////////////////////////////
//  BackwardLinkError.as
//  2008.04.15, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.syntax
{
	import com.maninsoft.smart.modeler.model.Link;
	import com.maninsoft.smart.modeler.xpdl.XPDLEditor;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * 링크가 뒤로가는 것인지 체크해서 알려줌
	 */
	public class BackwardLinkError extends Problem {
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function BackwardLinkError(link: Link) {
			super(source);

			level = LEVEL_INFO;
			label = resourceManager.getString("ProcessEditorMessages", "PEP001L");
			message = resourceManager.getString("ProcessEditorMessages", "PEP001M");
			description = resourceManager.getString("ProcessEditorMessages", "PEP001D"); 
		}
		
		public static function checkIt(buff: ArrayCollection, diagram: XPDLDiagram): void {
			addCount(BackwardLinkError);
			
			var links: Array = []; //DiagramUtils.getBackwardLinks(diagram.pool.children);
			
			for each (var link: Link in links) {
				buff.addItem(new BackwardLinkError(link));
			}
		}


		//----------------------------------------------------------------------
		// Overriden properties
		//----------------------------------------------------------------------
		
		override public function get canFixUp(): Boolean {
			return false;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override public function fixUp(editor: XPDLEditor): void {
		}
	}
}