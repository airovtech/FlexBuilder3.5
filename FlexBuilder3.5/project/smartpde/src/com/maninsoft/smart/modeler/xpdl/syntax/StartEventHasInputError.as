////////////////////////////////////////////////////////////////////////////////
//  StartEventHasInputError.as
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
	import com.maninsoft.smart.modeler.xpdl.model.StartEvent;
	import com.maninsoft.smart.modeler.xpdl.syntax.base.ActivityProblem;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * 시작이벤트는 입력 트랜지션이 없어야 한다.
	 */
	public class StartEventHasInputError extends ActivityProblem {
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function StartEventHasInputError(event: StartEvent)	{
			super(event);

			level = LEVEL_ERROR;
			label = resourceManager.getString("ProcessEditorMessages", "PEP010L");
			message = resourceManager.getString("ProcessEditorMessages", "PEP010M");
			description = resourceManager.getString("ProcessEditorMessages", "PEP010D");
		}

		public static function checkIt(buff: ArrayCollection, event: StartEvent): void {
			addCount(StartEventHasInputError);
			
			if (event.hasIncoming) {
				buff.addItem(new StartEventHasInputError(event));
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
			
			for each (var link: Link in StartEvent(source).targetLinks) {
				gcmd.add(new LinkDeleteCommand(link));
			}
			
			editor.execute(gcmd);
		}
	}
}