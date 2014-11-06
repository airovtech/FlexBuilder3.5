package com.maninsoft.smart.formeditor.model.condition
{
	public class FormConditionOperatorTypes
	{
		public static const EQUAL:String = "=";
		public static const NOT_EQUAL:String = "!=";
		
		public static const CONTAIN:String = "contain";
		public static const NOT_CONTAIN:String = "not contain";

		public static const SMALL:String = "<";
		public static const SMALL_EQUAL:String = "<=";
		public static const BIG:String = ">";
		public static const BIG_EQUAL:String = ">=";
		
		public static const AND:String = "and";
		public static const OR:String = "or";
		
		public static var connectorOperators:Array = [
			AND,
			OR
		];
		
		public static var stringOperators:Array = [
			EQUAL,
			NOT_EQUAL,
			CONTAIN,
			NOT_CONTAIN
		];
		
		public static var numberOperators:Array = [
			EQUAL,
			NOT_EQUAL,
			SMALL,
			SMALL_EQUAL,
			BIG,
			BIG_EQUAL
		];
		
		public static var dateOperators:Array = [
			EQUAL,
			NOT_EQUAL,
			SMALL,
			SMALL_EQUAL,
			BIG,
			BIG_EQUAL
		];
		
		public static var generalOperators:Array = [
			EQUAL,
			NOT_EQUAL
		];
	}
}