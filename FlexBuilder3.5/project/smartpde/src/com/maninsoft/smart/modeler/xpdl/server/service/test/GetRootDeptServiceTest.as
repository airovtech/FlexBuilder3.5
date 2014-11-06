////////////////////////////////////////////////////////////////////////////////
//  GetRootDeptServiceTest.as
//  2008.04.24, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.server.service.test
{
	import com.maninsoft.smart.modeler.common.TestCaseBase;
	import com.maninsoft.smart.modeler.xpdl.server.service.GetRootDeptService;
	
	import mx.rpc.events.FaultEvent;
	
	/**
	 * GetRootDeptServer test
	 */
	public class GetRootDeptServiceTest extends TestCaseBase	{
		
		public function GetRootDeptServiceTest() {
			super("GetRootDeptTest");
		}

		public function testSend(): void {
			var svc: GetRootDeptService = new GetRootDeptService();
			
			svc.serviceUrl = "http://bpmqa:9090/smartserver/services/common/organizationService.jsp";
			svc.userId = "jhnam";
			
			svc.resultHandler = function (svc: GetRootDeptService): void {
				traceXml(svc.resultXml);	
			}
			svc.faultHandler = function (svc: GetRootDeptService, event: FaultEvent): void {
				traceError(event.message);
			}
			
			svc.send();			
		}
	}
}