////////////////////////////////////////////////////////////////////////////////
//  LoadInstanceService.as
//  2008.04.08, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.server.service
{
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.parser.XPDLReader;
	
	import mx.core.Application;
	import mx.rpc.events.ResultEvent;
	import mx.utils.StringUtil;
	
	/**
	 * xml로 Instance 다이어그램을 내려받는 서비스
	 */
	public class LoadInstanceService extends ServiceBase
	{
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		//------------------------------
		// Parameters
		//------------------------------
		public var compId: String;
		public var userId: String;
		public var prcInstId: String;
		
		public var _xpdlSource: XML;
		public var _diagram: XPDLDiagram;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function LoadInstanceService() {
			super("monitorPrcInst");
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * xpdlSource
		 */
		public function get xpdlSource(): XML {
			return _xpdlSource;
		}
		
		/**
		 * diagram
		 */
		public function get diagram(): XPDLDiagram {
			return _diagram;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override protected function get params(): Object {
			var obj: Object = new Object();
			
			obj.compId = compId;
			obj.userId = userId;
			obj.prcInstId = prcInstId;
			
			return obj;
		}
		
		override protected function doResult(event:ResultEvent): void {
			trace(event);
			_xpdlSource = new XML(StringUtil.trim(event.message.body.toString()));
			_diagram = new XPDLReader().parse(_xpdlSource) as XPDLDiagram;
			
			super.doResult(event);
		}
	}
}