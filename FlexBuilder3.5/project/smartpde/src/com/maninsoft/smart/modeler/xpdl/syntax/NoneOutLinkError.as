//  NoneOutLinkError.as
//  2008.03.18, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.syntax
{
	import com.maninsoft.smart.modeler.xpdl.XPDLEditor;
	import com.maninsoft.smart.modeler.xpdl.model.EndEvent;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.syntax.base.ActivityProblem;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * 노테이션에 출력 링크가 하나도 없는 에러
	 */
	public class NoneOutLinkError extends ActivityProblem {
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function NoneOutLinkError(activity: Activity)	{
			super(activity);

			level = LEVEL_ERROR;
			label = resourceManager.getString("ProcessEditorMessages", "PEP009L");
			message = resourceManager.getString("ProcessEditorMessages", "PEP009M");
			description = resourceManager.getString("ProcessEditorMessages", "PEP009D");
		}
		
		public static  function checkIt(buff: ArrayCollection, activity: Activity): void {
			addCount(NoneOutLinkError);
			
			if (!(activity is EndEvent) && !activity.hasOutgoing) {
				buff.addItem(new NoneOutLinkError(activity));
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