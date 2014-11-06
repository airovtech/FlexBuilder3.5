////////////////////////////////////////////////////////////////////////////////
//  SaveDiagramService.as
//  2008.01.30, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.ganttchart.server.service
{
	import com.maninsoft.smart.modeler.xpdl.server.service.ServiceBase;
	
	import mx.rpc.events.ResultEvent;
	
	/**
	 * xml로 다이어그램을 서버에 저장하는 서비스
	 */
	public class DeployGanttDiagramService extends ServiceBase
	{
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		//------------------------------
		// Parameters
		//------------------------------
		public var compId: String;
		public var userId: String;
		public var packId: String;
		public var packVer: String;
		public var processContent: String;


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function DeployGanttDiagramService() {
			super("deployGanttProcessContent");
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override protected function get params(): Object {
			var obj: Object = new Object();
			
			obj.compId = compId;
			obj.userId = userId;
			obj.packId = packId;
			obj.packVer = packVer;
			obj.processContent = processContent;
			
			return obj;
		}
		
		override protected function doResult(event:ResultEvent): void {
			trace(event);
			super.doResult(event);
		}
	}
}