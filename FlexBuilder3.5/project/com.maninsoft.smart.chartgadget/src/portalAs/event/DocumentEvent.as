package portalAs.event {
	import flash.events.Event;
	
	public class DocumentEvent extends Event {
		public static var Document_ITEM_CLICK:String = "documentItemClick";
		public static var Document_CREATE_COMPLETE:String = "documentCreateComplete";
		
		public var documentId:String; 
		
        public function DocumentEvent(type:String) {
            super(type);
        }

        override public function clone() :Event {
            return new DocumentEvent(type);
        }
	}
}