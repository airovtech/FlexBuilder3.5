////////////////////////////////////////////////////////////////////////////////
//  TransitionErrors.as
//  2008.03.24, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.syntax
{
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLLink;
	import com.maninsoft.smart.modeler.xpdl.syntax.base.DiagramProblem;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * XPDLLink에 관련된 에러들을 검사한다.
	 * 1. XorGateway에 연결된 출력 링크 중 기본연결이 아니면 조건식이 설정되어야 한다. (TransitionHasNoConditionError)
	 */
	public class TransitionErrors extends DiagramProblem {
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function TransitionErrors(diagram: XPDLDiagram) {
			super(diagram);
		}

		public static function checkIt(buff: ArrayCollection, diagram: XPDLDiagram): void {
			addCount(TransitionErrors);
			
			for each (var link: XPDLLink in diagram.links) {
				TransitionHasNoConditionError.checkIt(buff, link);
			}
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
	}
}