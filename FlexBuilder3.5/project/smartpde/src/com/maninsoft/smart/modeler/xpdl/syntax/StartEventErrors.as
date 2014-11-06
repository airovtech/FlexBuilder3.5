////////////////////////////////////////////////////////////////////////////////
//  StartEventErrors.as
//  2008.03.21, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.syntax
{
	import com.maninsoft.smart.modeler.xpdl.model.StartEvent;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.syntax.base.DiagramProblem;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * 시작이벤트들에 관한 에러들을 검사한다.
	 * 1. 시작이벤트는 입력 트랜지션이 없어야 한다.(StartEventHasInputError)
	 */
	public class StartEventErrors extends DiagramProblem {
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function StartEventErrors(diagram: XPDLDiagram) {
			super(diagram);
		}
		
		public static function checkIt(buff: ArrayCollection, diagram: XPDLDiagram): void {
			addCount(StartEventErrors);
			
			for each (var event: StartEvent in diagram.pool.getActivities(StartEvent)) {
				StartEventHasInputError.checkIt(buff, event);
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
	}
}