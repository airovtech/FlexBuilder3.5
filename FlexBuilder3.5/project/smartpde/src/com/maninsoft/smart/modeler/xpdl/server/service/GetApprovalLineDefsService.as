package com.maninsoft.smart.modeler.xpdl.server.service
{
	import com.maninsoft.smart.modeler.xpdl.server.ApprovalLine;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.StringUtil;
	
	/**
	 * 모든 사용자를 가져오는 서비스
	 */
	public class GetApprovalLineDefsService extends ServiceBase {
		
		//----------------------------------------------------------------------
		// Service parameters
		//----------------------------------------------------------------------

		public var compId: String;
		public var userId: String;
		

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _approvalLines: Array /* of User */;


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function GetApprovalLineDefsService() {
			super("getApprovalLineDefs");
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * approvalLines
		 */
		public function get approvalLines(): Array /* of ApprovalLine */ {
			return _approvalLines;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override protected function get params(): Object {
			var obj: Object = new Object();
			
			obj.compId = compId;
			obj.userId = userId;
			
			return obj;
		}
		
		override protected function doResult(event:ResultEvent): void {
			trace(event);
			
			var xml: XML = new XML(StringUtil.trim(event.message.body.toString()));
			_approvalLines = [];
			
			for each (var x: XML in xml.approvalLineDefs.approvalLineDef) {
				var approvalLine: ApprovalLine = new ApprovalLine();

				approvalLine.id				= x.@objId;
				approvalLine.name			= x.aprLineName;
				approvalLine.description 	= x.aprDescription;
				approvalLine.approvalLevel	= x.aprLevel;
				_approvalLines.push(approvalLine);	
			}
			
			super.doResult(event);
		}
		
		override protected function doFault(event:FaultEvent): void {
			trace("GetApprovalLineDefsService: " + event);
			
			super.doFault(event);
		}
	}
}