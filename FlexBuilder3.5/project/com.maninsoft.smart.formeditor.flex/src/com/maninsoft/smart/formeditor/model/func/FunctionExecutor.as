package com.maninsoft.smart.formeditor.model.func
{
	import com.maninsoft.smart.formeditor.util.FormEditorConfig;
	
	import mx.controls.DateField;
	
	public class FunctionExecutor
	{
		public static function getCurrentUser():String
		{
			return FormEditorConfig.userId;
		}

		public static function getCurrentDate():String
		{
			var date:Date = new Date();
			return DateField.dateToString(date, "YYYY-MM-DD");
		}
	}
}