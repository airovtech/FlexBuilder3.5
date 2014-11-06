package com.maninsoft.smart.workbench.common.util
{
	public class DateUtil
	{
		public static function parseDateString(dateStr:String):Date
		{
			dateStr = dateStr.replace(new RegExp(/[.]\d{1}/), "");
			dateStr = dateStr.replace(/-/g, "/");
			return new Date(dateStr);	
		}
	}
}