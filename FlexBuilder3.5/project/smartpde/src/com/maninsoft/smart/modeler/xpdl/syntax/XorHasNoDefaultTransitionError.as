////////////////////////////////////////////////////////////////////////////////
//  XorHasNoDefaultTransitionError.as
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
	import com.maninsoft.smart.modeler.xpdl.syntax.base.ActivityProblem;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * XOR Gateway 에 default transition이 설정되지 않았다.
	 * 현재 "경고" 수준 - 스펙에서 반드시 존재해야 한다는 문장을 찾지 못했음.
	 */
	public class XorHasNoDefaultTransitionError extends ActivityProblem {
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function XorHasNoDefaultTransitionError(gateway: XorGateway) {
			super(gateway);

			label = resourceManager.getString("ProcessEditorMessages", "PEP014L");
			message = resourceManager.getString("ProcessEditorMessages", "PEP014M");
			description = resourceManager.getString("ProcessEditorMessages", "PEP014D");
		}

		public static function checkIt(buff: ArrayCollection, gateway: XorGateway): void {
			addCount(XorHasNoDefaultTransitionError);
			
			if (gateway.defaultTransition == null) 
				buff.addItem(new XorHasNoDefaultTransitionError(gateway));
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