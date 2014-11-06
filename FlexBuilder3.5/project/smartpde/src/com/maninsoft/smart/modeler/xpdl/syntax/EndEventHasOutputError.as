////////////////////////////////////////////////////////////////////////////////
//  EndEventHasOutputError.as
//  2008.03.21, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.syntax
{
	import com.maninsoft.smart.modeler.command.GroupCommand;
	import com.maninsoft.smart.modeler.command.LinkDeleteCommand;
	import com.maninsoft.smart.modeler.model.Link;
	import com.maninsoft.smart.modeler.xpdl.XPDLEditor;
	import com.maninsoft.smart.modeler.xpdl.model.EndEvent;
	import com.maninsoft.smart.modeler.xpdl.syntax.base.ActivityProblem;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * 종료이벤트에는 출력 트랜지션이 없어야 한다.
	 */
	public class EndEventHasOutputError extends ActivityProblem {
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function EndEventHasOutputError(event: EndEvent) {
			super(event);

			level = LEVEL_ERROR;
			label = resourceManager.getString("ProcessEditorMessages", "PEP002L");
			message = resourceManager.getString("ProcessEditorMessages", "PEP002M");
			description = resourceManager.getString("ProcessEditorMessages", "PEP002D");
		}
		
		public static function checkIt(buff: ArrayCollection, event: EndEvent): void {
			addCount(EndEventHasOutputError);
			
			if (event.outgoingLinks.length > 0) {
				buff.addItem(new EndEventHasOutputError(event));
			}
		}


		//----------------------------------------------------------------------
		// Overriden properties
		//----------------------------------------------------------------------
		
		override public function get canFixUp(): Boolean {
			return true;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		/**
		 * 입력 링크들을 제거한다.
		 */
		override public function fixUp(editor: XPDLEditor): void {
			var gcmd: GroupCommand = new GroupCommand();
			
			for each (var link: Link in EndEvent(source).outgoingLinks) {
				gcmd.add(new LinkDeleteCommand(link));
			}
			
			editor.execute(gcmd);
		}
	}
}