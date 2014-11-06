////////////////////////////////////////////////////////////////////////////////
//  FindUserByDeptServiceTest.as
//  2008.04.24, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.server.service.test
{
	import com.maninsoft.smart.modeler.common.TestCaseBase;
	import com.maninsoft.smart.modeler.xpdl.server.service.FindUserByDeptService;
	
	import mx.rpc.events.FaultEvent;
	
	/**
	 * FindUserByDeptServer test
	 */
	public class FindUserByDeptServiceTest extends TestCaseBase	{
		
		public function FindUserByDeptServiceTest() {
			super("FindUserByDeptTest");
		}

		public function testSend(): void {
			var svc: FindUserByDeptService = new FindUserByDeptService();
			
			svc.serviceUrl = "http://bpmqa:9090/smartserver/services/common/organizationService.jsp";
			svc.userId = "jhnam";
			svc.deptId = "dept_754a1cb7ce9a4673a8211a4c17b91ae7";
			
			svc.resultHandler = function (svc: FindUserByDeptService): void {
				traceXml(svc.resultXml);	
			}
			svc.faultHandler = function (svc: FindUserByDeptService, event: FaultEvent): void {
				traceError(event.message);
			}
			
			svc.send();			
		}
	}
}