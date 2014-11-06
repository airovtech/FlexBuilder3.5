package com.maninsoft.smart.formeditor.model.property
{
	import com.maninsoft.smart.formeditor.model.type.LocaleType;
	
	import flash.events.EventDispatcher;
	
	public class FormItemType extends EventDispatcher
	{
		public static const TEXT:String = "text";
		public static const PERCENT:String = "percent";
		public static const NUMBER:String = "number";
		public static const MONEY:String = "money";
		public static const DATE:String = "date";
		public static const TIME:String = "time";
		public static const ETC:String = "etc";
		
		private var _type:String = TEXT;
		
		[Bindable]
		public function set type(type:String):void{
			this._type = type;
			
			if(this._type == MONEY){
				this.thousandsSeparator = true;
			}
		}
		
		public function get type():String{
			return this._type;
		}
		
		public function get baseType():String{
			switch(this.type){
				case TEXT:
					return "string";
					break;
				case PERCENT:
					return "float";
					break;
				case NUMBER:
					return "float";
					break;
				case MONEY:
					return "float";
					break;
				case DATE:
					return "datetime";
					break;
				case TIME:
					return "datetime";
					break;
				default:
					return "string";
			}			
		}
		
		[Bindable]
		public var precision:int = 0;
		[Bindable]
		public var data:Number;
		[Bindable]
		public var minus:Boolean;
		[Bindable]
		public var thousandsSeparator:Boolean = false;
		[Bindable]
		public var plus:Boolean;
		[Bindable]
		public var red:Boolean;
		[Bindable]
		public var locale:LocaleType;
		[Bindable]
		public var formatString:String;
		
		public function clone():FormItemType{
			var typeModel:FormItemType = new FormItemType();
			typeModel.type = type;
			typeModel.data = data;
			typeModel.minus = minus;
			typeModel.plus = plus;
			typeModel.red = red;
			typeModel.precision = precision;
			typeModel.thousandsSeparator = thousandsSeparator;
			typeModel.locale = locale;
			typeModel.formatString = formatString;
			return FormItemType(typeModel);
		}
		
	}
}