////////////////////////////////////////////////////////////////////////////////
//  GetProcessInfoByPackageServiceTest.as
//  2008.04.26, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.server.service.test
{
	import com.maninsoft.smart.modeler.common.TestCaseBase;
	import com.maninsoft.smart.modeler.xpdl.server.service.GetProcessInfoByPackageService;
	
	import mx.rpc.events.FaultEvent;
	
	public class GetProcessInfoByPackageServiceTest extends TestCaseBase {
		
		public function GetProcessInfoByPackageServiceTest() {
			super("GetProcessInfoByPackageServiceTest");
		}

		public function testSend(): void {
			var svc: GetProcessInfoByPackageService = new GetProcessInfoByPackageService();
			
			svc.serviceUrl = "http://bpmqa:9090/smartserver/services/builder/builderService.jsp";
			svc.userId = "jhnam";
			//svc.packageId = "pkg_3aec58c37f5b40cca354a1a266503a78";
			//svc.version = "3";
			svc.packageId = "pkg_1fba93aad7574065b10e034ad0737bd6";
			svc.version = "2";
			
			svc.resultHandler = function (svc: GetProcessInfoByPackageService): void {
				traceXml(svc.resultXml);	
			}
			
			svc.faultHandler = function (svc: GetProcessInfoByPackageService, event: FaultEvent): void {
				traceError(event.message);
			}
			
			svc.send();			
		}
	}
}