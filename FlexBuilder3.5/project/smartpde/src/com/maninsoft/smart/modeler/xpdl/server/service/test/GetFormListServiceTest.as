////////////////////////////////////////////////////////////////////////////////
//  GetFormListServiceTest.as
//  2008.02.01, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.server.service.test
{
	import com.maninsoft.smart.modeler.common.TestCaseBase;
	import com.maninsoft.smart.modeler.xpdl.server.service.GetFormListService;
	
	import mx.rpc.events.FaultEvent;
	
	/**
	 * GetFormListServer test
	 */
	public class GetFormListServiceTest extends TestCaseBase	{
		
		public function GetFormListServiceTest() {
			super("getFormListTest");
		}

		public function testSend(): void {
			var svc: GetFormListService = new GetFormListService();
			
			svc.serviceUrl = "http://10.0.0.2:8080/smartserver/services//modeler.jsp";
			svc.userId = "jhnam";
			
			svc.resultHandler = function (svc: GetFormListService): void {
				traceXml(svc.resultXml);	
			}
			svc.faultHandler = function (svc: GetFormListService, event: FaultEvent): void {
				traceError(event.message);
			}
			
			svc.send();			
		}
	}
}