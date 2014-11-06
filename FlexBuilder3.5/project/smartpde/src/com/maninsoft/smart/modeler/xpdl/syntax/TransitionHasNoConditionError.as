////////////////////////////////////////////////////////////////////////////////
//  TransitionHasNoConditionError.as
//  2008.03.24, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.syntax
{
	import com.maninsoft.smart.modeler.xpdl.XPDLEditor;
	import com.maninsoft.smart.modeler.xpdl.model.XorGateway;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLLink;
	import com.maninsoft.smart.modeler.xpdl.syntax.base.TransitionProblem;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * Default가 아닌 Transtion에 Condition이 설정되지 않았다.
	 */
	public class TransitionHasNoConditionError extends TransitionProblem {
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function TransitionHasNoConditionError(link: XPDLLink) {
			super(link);

			label = resourceManager.getString("ProcessEditorMessages", "PEP012L");
			message = resourceManager.getString("ProcessEditorMessages", "PEP012M");
			description = resourceManager.getString("ProcessEditorMessages", "PEP012D");
		}
		
		public static function checkIt(buff: ArrayCollection, link: XPDLLink): void {
			addCount(TransitionHasNoConditionError);
			
			if (link.source is XorGateway && !link.isDefault && !link.condition) {
				buff.addItem(new TransitionHasNoConditionError(link));
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