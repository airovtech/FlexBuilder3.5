////////////////////////////////////////////////////////////////////////////////
//  SyntaxChecker.as
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
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLLink;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * 다이어그램에서 문법 에러들을 찾아 리스트로 반환한다.
	 */
	public class SyntaxChecker
	{

		//----------------------------------------------------------------------
		// Class consts
		//----------------------------------------------------------------------

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _problems: ArrayCollection;
		private var _checking: Boolean = false;
		

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function SyntaxChecker() {
			super();
			
			_problems = new ArrayCollection();
		}
		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * 가장 최근에 검사한 에러 목록을 리턴한다.
		 */
		public function get problems(): ArrayCollection /* of Problem */ {
			//return _problems.toArray();
			return _problems;
		}
		
		public function set problems(value: ArrayCollection): void{
			_problems = value;
		}
		

		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		
		public function check(diagram: XPDLDiagram): void {
			if (!diagram)
				return;
			
			/*
			 * 검사 중 재진입을 막는다.
			 * 검사 중 Activity에 문제가 설정되는데, 그러면 다시 check을 요구하게 된다.
			 */
			if (_checking)
				return;
			
			_checking = true;
			
			try {
				_problems.removeAll();
				Problem.clearCount();
								
				for each (var act: Activity in diagram.pool.getActivities(Activity))
					act.problem = null;
				
				for each (var link:XPDLLink in diagram.transitions)
					link.problem = null;
					
				checkDiagram(diagram);
			}
			finally {
				_checking = false;
			}
		}
		

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------

		protected function checkDiagram(dgm: XPDLDiagram): void {
			NoneExistStartEventError.checkIt(_problems, dgm);
			NoneExistEndEventError.checkIt(_problems, dgm);
			NoneExistTaskApplicationError.checkIt(_problems, dgm);
			NoneExistStartTaskError.checkIt(_problems, dgm);
			TaskApplicationErrors.checkIt(_problems, dgm);
			SubFlowErrors.checkIt(_problems, dgm);
			TaskServiceErrors.checkIt(_problems, dgm);
			StartEventErrors.checkIt(_problems, dgm);
			EndEventErrors.checkIt(_problems, dgm);
			IntermediateEventErrors.checkIt(_problems, dgm);
			XorGatewayErrors.checkIt(_problems, dgm);
			ConnectionErrors.checkIt(_problems, dgm);
			TransitionErrors.checkIt(_problems, dgm);
			//BackwardLinkError.checkIt(_problems, dgm);
		}
	}
}