package com.maninsoft.smart.formeditor.model.type
{
	import flash.events.EventDispatcher;
	
	public class LocaleType extends EventDispatcher
	{
		[Bindable]
		public var currencySymbol:String;
		[Bindable]
		public var label:String;
		[Bindable]
		public var type:String;
		
		public function clone():LocaleType{
			var localeType:LocaleType = new LocaleType();
			localeType.currencySymbol = currencySymbol;
			localeType.label = label;
			localeType.type = type;
			return localeType;	
		}
	}
}