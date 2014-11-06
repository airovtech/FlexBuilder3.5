////////////////////////////////////////////////////////////////////////////////
//  EndEvent.as
//  2007.12.20, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model 
{
	import com.maninsoft.smart.modeler.xpdl.model.base.ActivityTypes;
	import com.maninsoft.smart.modeler.xpdl.model.base.Event;
	import com.maninsoft.smart.modeler.xpdl.server.Server;
	
	/**
	 * XPDL EndEvent Event
	 */
	public class EndEvent extends Event	{

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _result: String;
		

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/**
		 * Construtor 
		 */
		public function EndEvent() {
			super();
		}

		override protected function initDefaults():void{
			super.initDefaults();
			this.name = defaultName;
		}
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * XPDL Result
		 */
		public function get result(): String {
			return _result;
		}
		
		public function set result(value: String): void {
			_result = value;
		}
		
		

		//----------------------------------------------------------------------
		// IXPDLElement
		//----------------------------------------------------------------------
		
		override protected function doRead(src: XML): void {
			var xml: XML = src._ns::Event._ns::EndEvent[0];
			
			_result = xml.@Result;

			super.doRead(src);

			if(_width<defaultWidth) _width=defaultWidth;
			if(_height<defaultHeight) _height=defaultHeight;

		}

		override protected function doWrite(dst: XML): void {
			dst._ns::Event._ns::EndEvent = "";
			var xml: XML = dst._ns::Event._ns::EndEvent[0];
			
			xml.@Result = result;

			super.doWrite(dst);
		}



		//----------------------------------------------------------------------
		// Overriden properties
		//----------------------------------------------------------------------

		override public function get activityType(): String {
			return ActivityTypes.END_EVENT;
		}

		override public function get defaultName(): String {
			return resourceManager.getString("ProcessEditorETC", "endText");
		}
	}
}