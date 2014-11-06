////////////////////////////////////////////////////////////////////////////////
//  EndEventErrors.as
//  2008.03.21, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.syntax
{
	import com.maninsoft.smart.modeler.xpdl.model.EndEvent;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.syntax.base.DiagramProblem;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * 종료이벤트들에 관한 에러들을 검사한다.
	 * 1. 종료이벤트에는 출력 트랜지션이 없어야 한다.(EndEventHasOutputError)
	 */
	public class EndEventErrors extends DiagramProblem {
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function EndEventErrors(diagram: XPDLDiagram) {
			super(diagram);
		}
		
		public static function checkIt(buff: ArrayCollection, diagram: XPDLDiagram): void {
			addCount(EndEventErrors);
			
			for each (var event: EndEvent in diagram.pool.getActivities(EndEvent)) {
				EndEventHasOutputError.checkIt(buff, event);
			}
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
	}
}