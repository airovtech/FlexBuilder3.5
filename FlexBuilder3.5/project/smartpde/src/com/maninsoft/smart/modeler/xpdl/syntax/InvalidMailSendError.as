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
	import com.maninsoft.smart.modeler.xpdl.model.TaskService;
	import com.maninsoft.smart.modeler.xpdl.syntax.base.ActivityProblem;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * 종료이벤트에는 출력 트랜지션이 없어야 한다.
	 */
	public class InvalidMailSendError extends ActivityProblem {
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function InvalidMailSendError(task: TaskService) {
			super(task);

			level = LEVEL_ERROR;
			label = resourceManager.getString("ProcessEditorMessages", "PEP019L");
			message = resourceManager.getString("ProcessEditorMessages", "PEP019M");
			description = resourceManager.getString("ProcessEditorMessages", "PEP019D");
		}
		
		public static function checkIt(buff: ArrayCollection, task: TaskService): void {
			addCount(InvalidMailSendError);
			
			if (task.serviceType == TaskService.SERVICE_TYPE_MAIL){
				if(   (task.mailReceivers == null
					&&task.mailBccReceivers == null
					&&task.mailCcReceivers == null)
					||task.mailSubject == null
					||task.mailContent == null) {
					buff.addItem(new InvalidMailSendError(task));
				}
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