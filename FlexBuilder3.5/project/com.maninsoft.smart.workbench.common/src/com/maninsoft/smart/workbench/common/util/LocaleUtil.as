package com.maninsoft.smart.workbench.common.util
{
	import mx.collections.ArrayCollection;
	
	public class LocaleUtil
	{
		public static var locales:ArrayCollection = new ArrayCollection([{label:"English", loc:"en_US", lang:"en"}, {label:"한국어", loc:"ko_KR", lang:"ko"}]);
		public static var locale:String;
	}
}