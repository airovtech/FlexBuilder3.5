////////////////////////////////////////////////////////////////////////////////
//  XorHasManyDefaultTransitionsError.as
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
	 * XORGateway 에 하나 이상의 default transition 이 설정되어 있다.
	 */
	public class XorHasManyDefaultTransitionsError extends ActivityProblem {
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function XorHasManyDefaultTransitionsError(gateway: XorGateway) {
			super(gateway);

			label = resourceManager.getString("ProcessEditorMessages", "PEP013L");
			message = resourceManager.getString("ProcessEditorMessages", "PEP013M");
			description = resourceManager.getString("ProcessEditorMessages", "PEP013D");
		}

		public static function checkIt(buff: ArrayCollection, gateway: XorGateway): void {
			addCount(XorHasManyDefaultTransitionsError);
			
			if (gateway.defaultTransitionCount > 1) 
				buff.addItem(new XorHasManyDefaultTransitionsError(gateway));
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