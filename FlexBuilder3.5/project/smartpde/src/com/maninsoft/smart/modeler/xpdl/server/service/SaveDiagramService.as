////////////////////////////////////////////////////////////////////////////////
//  SaveDiagramService.as
//  2008.01.30, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.server.service
{
	import mx.rpc.events.ResultEvent;
	
	/**
	 * xml로 다이어그램을 서버에 저장하는 서비스
	 */
	public class SaveDiagramService extends ServiceBase
	{
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		//------------------------------
		// Parameters
		//------------------------------
		public var compId: String;
		public var userId: String;
		public var processId: String;
		public var version: String;
		public var processContent: String;
		public var saveType:String;


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function SaveDiagramService() {
			super("saveProcessContent");
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
			obj.processId = processId;
			obj.version = version;
			obj.processContent = processContent;
			
			return obj;
		}
		
		override protected function doResult(event:ResultEvent): void {
			trace(event);
			if(saveType=="save"){
				//checkResultAndShow(event, "저장", "프로세스 다이어그램이 저장되었습니다.");	
			}		
			super.doResult(event);
		}
	}
}