////////////////////////////////////////////////////////////////////////////////
//  FindChildDeptServiceTest.as
//  2008.04.24, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.server.service.test
{
	import com.maninsoft.smart.modeler.common.TestCaseBase;
	import com.maninsoft.smart.modeler.xpdl.server.service.FindChildDeptService;
	
	import mx.rpc.events.FaultEvent;
	
	/**
	 * FindChildDeptServer test
	 */
	public class FindChildDeptServiceTest extends TestCaseBase	{
		
		public function FindChildDeptServiceTest() {
			super("FindChildDeptTest");
		}

		public function testSend(): void {
			var svc: FindChildDeptService = new FindChildDeptService();
			
			svc.serviceUrl = "http://bpmqa:9090/smartserver/services/common/organizationService.jsp";
			svc.userId = "jhnam";
			svc.parentId = "dept_5ff7cf7d814545b9b6d4fc8d64fd00a2";
			
			svc.resultHandler = function (svc: FindChildDeptService): void {
				traceXml(svc.resultXml);	
			}
			svc.faultHandler = function (svc: FindChildDeptService, event: FaultEvent): void {
				traceError(event.message);
			}
			
			svc.send();			
		}
	}
}