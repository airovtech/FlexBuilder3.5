////////////////////////////////////////////////////////////////////////////////
//  ConnectionErrors.as
//  2008.03.18, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.syntax
{
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.syntax.base.DiagramProblem;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * 각 노테이션들의 입출력 연결 상태를 점검해서,
	 * 문제가 있는 경우마다 Problem을 하나씩 생성한다.
	 */
	public class ConnectionErrors extends DiagramProblem {
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function ConnectionErrors(diagram: XPDLDiagram)	{
			super(diagram);
		}
		
		public static function checkIt(buff: ArrayCollection, diagram: XPDLDiagram): void {
			addCount(ConnectionErrors);
			
			for each (var act: Activity in diagram.activities) {
				NoneOutLinkError.checkIt(buff, act);
				NoneInLinkError.checkIt(buff, act);
			}
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
	}
}