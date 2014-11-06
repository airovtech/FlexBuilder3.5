package com.maninsoft.smart.formeditor.model.property
{
	import mx.collections.ArrayCollection;
	
	public class FormDateType
	{
		public var localeLabel:String;
		public var localeType:String;
		
		[Bindable]
		public var dateFormatStrings:ArrayCollection = new ArrayCollection();
		[Bindable]
		public var timeFormatStrings:ArrayCollection = new ArrayCollection();		
		
		public var days:Array = new Array();
		public var dayShorts:Array = new Array();
		
		public var months:Array = new Array();
		public var monthShorts:Array = new Array();
		
		public var times:Array = new Array();
	}
}