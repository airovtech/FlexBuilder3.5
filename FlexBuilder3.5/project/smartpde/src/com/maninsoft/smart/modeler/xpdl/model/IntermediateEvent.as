////////////////////////////////////////////////////////////////////////////////
//  IntermediateEvent.as
//  2007.12.20, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model 
{
	import com.maninsoft.smart.formeditor.model.Mapping;
	import com.maninsoft.smart.modeler.model.DiagramObject;
	import com.maninsoft.smart.modeler.xpdl.model.base.ActivityTypes;
	import com.maninsoft.smart.modeler.xpdl.model.base.Event;
	import com.maninsoft.smart.modeler.xpdl.property.EventTypePropertyInfo;
	import com.maninsoft.smart.workbench.common.property.MeanTimePropertyInfo;
	
	import mx.controls.Alert;
//	import com.maninsoft.smart.modeler.xpdl.property.FormMappingPropertyInfo;
	
	/**
	 * XPDL IntermediateEvent Event
	 */
	public class IntermediateEvent extends Event	{

		//----------------------------------------------------------------------
		// Property consts
		//----------------------------------------------------------------------
		public static const PROP_EVENT_TYPE			: String = "prop.eventType";
		public static const PROP_TIMER_DELAY_TIME	: String = "prop.timerDelayTime";
		
		public static const EVENT_TYPE_TIMER : String = "timer";
		public static const EVENT_TYPE_MAIL:String = "mail";
		public static const TIMER_DEFAULT_DELAY_TIME:String = "30";
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _eventType: String=EVENT_TYPE_TIMER;
		public function get eventType():String {
			return _eventType;
		}
		public function set eventType(value:String):void {
			var oldVal:String = _eventType;
			_eventType = value;
			fireChangeEvent(PROP_EVENT_TYPE, oldVal);
		}

		private var _timerDelayTime:String=TIMER_DEFAULT_DELAY_TIME;
		public function get timerDelayTime():String {
			return _timerDelayTime;
		}
		public function set timerDelayTime(value:String):void {
			_timerDelayTime = value;
		}


		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/**
		 * Construtor 
		 */
		public function IntermediateEvent() {
			super();
		}
		override protected function initDefaults():void{
			super.initDefaults();
			this.name = defaultName;
		}

		
		//----------------------------------------------------------------------
		// IXPDLElement
		//----------------------------------------------------------------------
		
		override protected function doRead(src: XML): void {
			var xml: XML = src._ns::Event._ns::IntermediateEvent[0];
			_eventType = xml.@EventType;
			_timerDelayTime = xml.@TimerDelayTime;
			if(!_timerDelayTime || _timerDelayTime == "null" ) _timerDelayTime = TIMER_DEFAULT_DELAY_TIME;
			super.doRead(src);			
		}

		override protected function doWrite(dst: XML): void {
			dst._ns::Event._ns::IntermediateEvent = "";
			var xml: XML = dst._ns::Event._ns::IntermediateEvent[0];
			
			xml.@EventType = _eventType;
			
			xml.@TimerDelayTime = _timerDelayTime;
			super.doWrite(dst);
		}

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function assign(source: DiagramObject): void {
			super.assign(source);
			
			if (source is IntermediateEvent) {
				var tmp:IntermediateEvent = source as IntermediateEvent;
				this._eventType = tmp._eventType;
				this._timerDelayTime = tmp._timerDelayTime;
			}
		}

		/**
		 * 프로퍼티 소스가 제공하는 IPropertyInfo 목록
		 */
		override protected function createPropertyInfos(): Array {
			var props: Array = super.createPropertyInfos();
			
			if(eventType == IntermediateEvent.EVENT_TYPE_TIMER){
				return props.concat(
					new EventTypePropertyInfo (PROP_EVENT_TYPE, resourceManager.getString("ProcessEditorETC", "eventTypeText"), null, null, false),
					new MeanTimePropertyInfo(PROP_TIMER_DELAY_TIME, resourceManager.getString("ProcessEditorETC", "timerDelayTimeText"))
				);
			}
			return props
		}
		
		/**
		 * id 에 해당하는 프로퍼티의 현재 값을 리턴
		 */
		override public function getPropertyValue(id: String): Object {
			switch (id) {
				case PROP_EVENT_TYPE:
					return eventType;
				
				case PROP_TIMER_DELAY_TIME:
					return timerDelayTime;
					
				default:
					return super.getPropertyValue(id);
			}
		}
		
		/**
		 * id 에 해당하는 프로퍼티의 값을 설정
		 */
		override public function setPropertyValue(id: String, value: Object): void {
			switch (id) {
				case PROP_EVENT_TYPE:
					eventType = value.toString();
					break;
					
				default:
					super.setPropertyValue(id, value);
					break;
			}
		}
		
		//----------------------------------------------------------------------
		// Overriden properties
		//----------------------------------------------------------------------

		override public function get activityType(): String {
			return ActivityTypes.INTERMEDIATE_EVENT;
		}

		override public function get defaultName(): String {
			return resourceManager.getString("ProcessEditorETC", "intermediateEventText");
		}
	}
}