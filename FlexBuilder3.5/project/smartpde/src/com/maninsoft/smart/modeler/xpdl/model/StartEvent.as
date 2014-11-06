////////////////////////////////////////////////////////////////////////////////
//  StartEvent.as
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
	 * XPDL StartEvent Event
	 */
	public class StartEvent extends Event	{

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _trigger: String = "None";
		

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/**
		 * Construtor 
		 */
		public function StartEvent() {
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
		 * XPDL Trigger
		 */
		public function get trigger(): String {
			return _trigger;
		}
		
		public function set trigger(value: String): void {
			_trigger = value;
		}
		

		//----------------------------------------------------------------------
		// IXPDLElement
		//----------------------------------------------------------------------
		
		override protected function doRead(src: XML): void {
			var xml: XML = src._ns::Event._ns::StartEvent[0];
			
			_trigger = xml.@Trigger;

			super.doRead(src);
			
			if(_width<defaultWidth) _width=defaultWidth;
			if(_height<defaultHeight) _height=defaultHeight;
		}

		override protected function doWrite(dst: XML): void {
			dst._ns::Event._ns::StartEvent = "";
			var xml: XML = dst._ns::Event._ns::StartEvent[0];
			
			xml.@Trigger = trigger;

			super.doWrite(dst);
		}


		//----------------------------------------------------------------------
		// Overriden properties
		//----------------------------------------------------------------------

		override public function get activityType(): String {
			return ActivityTypes.START_EVENT;
		}

		override public function get defaultName(): String {
			return resourceManager.getString("ProcessEditorETC", "startText");
		}
	}
}