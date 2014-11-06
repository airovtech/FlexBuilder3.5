package com.maninsoft.smart.formeditor.model.type
{
	public class CurrencyType
	{
		public var currencySymbol:String;
		public var label:String;
		public var data:String;

		public function CurrencyType(label:String, data:String, currencySymbol:String=null){
			super();
			this.label = label;
			this.data = data;
			this.currencySymbol = currencySymbol;
		}
		
		public function clone():CurrencyType{
			var currencyType:CurrencyType = new CurrencyType(label, data, currencySymbol);
			return currencyType;	
		}
	}
}