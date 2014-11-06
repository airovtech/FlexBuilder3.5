package smartWork.custormObj.event {
	import flash.events.Event;
	
	public dynamic class PanelEvent extends Event {
		public static var PANEL_CLOSE:String = "panelClose";
		public static var MAX_SIZE:String = "maxSize";
		
        public function PanelEvent(type:String) {
            super(type);
        }

        override public function clone() :Event {
            return new PanelEvent(type);
        }
	}
}