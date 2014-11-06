package com.maninsoft.smart.common.event {
	import flash.events.Event;
	
	public dynamic class CustormEvent extends Event {
		public static var CUSTORM_ITEM_CLICK:String = "custormItemClick";
		public static var CUSTORM_ITEM_DOUBLE_CLICK:String = "custormItemDoubleClick";
		public static var CUSTORM_ITEM_LOAD:String = "custormItemLoad";
		public static var CUSTORM_ITEM_CHANGE:String = "custormItemChange";
		
		public static var CLICK_NEW_ITEM:String = "clickNewItem";
		public static var CLICK_PAGE_ITEM:String = "clickPageItem";
		
		public static var CUSTORM_ITEM_ADD:String = "custormItemAdd";
		public static var CUSTORM_ITEM_MODIFY:String = "custormItemModify";
		public static var CUSTORM_CLOSE:String = "custormClose";
		
		public static var REFRESH:String = "refresh";
		
		public var prcInstId:String; // Process Instace Id ( for InstanceList -> InstanceDetail)
		public var deptId:String; 
		public var workId:String;
		
        public function CustormEvent(type:String) {
            super(type);
        }

        override public function clone() :Event {
            return new CustormEvent(type);
        }
	}
}