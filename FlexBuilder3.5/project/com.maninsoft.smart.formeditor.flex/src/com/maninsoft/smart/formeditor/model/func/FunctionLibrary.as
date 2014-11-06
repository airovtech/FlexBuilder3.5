package com.maninsoft.smart.formeditor.model.func
{
	public class FunctionLibrary
	{
		[Bindable]
		public static var library:XML = 
			<funcLibrary>
				<general>
					<func value="func:"></func>
					<func value="func:getCurrentUser">현재 사용자</func>
					<func value="func:getCurrentDate">현재 날짜</func>
				</general>
			</funcLibrary>;
			
//		public static function getGeneralLirary():XML
//		{
//			return library.general[0];
//		}

	}
}