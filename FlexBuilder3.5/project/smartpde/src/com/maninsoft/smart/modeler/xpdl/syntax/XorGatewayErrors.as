////////////////////////////////////////////////////////////////////////////////
//  XorGatewayErrors.as
//  2008.03.24, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.syntax
{
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.model.XorGateway;
	import com.maninsoft.smart.modeler.xpdl.syntax.base.DiagramProblem;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * XorGateway에 관한 에러들을 검사한다.
	 * 1. 하나의 기본 출력 Transition이 존재해야 한다. (HasNoDefaultTransitionError)
	 * 2. 오로지 하나의 기본 출력 Transition이 존재해야 한다. (HasManyDefaultTransitionsError)
	 */
	public class XorGatewayErrors extends DiagramProblem {
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function XorGatewayErrors(diagram: XPDLDiagram)	 {
			super(diagram);
		}
		
		public static function checkIt(buff: ArrayCollection, diagram: XPDLDiagram): void {
			addCount(XorGatewayErrors);
			
			for each (var gate: XorGateway in diagram.pool.getActivities(XorGateway)) {
				XorHasNoDefaultTransitionError.checkIt(buff, gate);
				XorHasManyDefaultTransitionsError.checkIt(buff, gate);
			}
		}

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

	}
}