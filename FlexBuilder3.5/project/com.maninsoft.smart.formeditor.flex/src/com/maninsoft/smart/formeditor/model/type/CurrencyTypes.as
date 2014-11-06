/**
 * 
 *  Package: 		com.maninsoft.smart.formeditor.model.type
 *  Class: 			FormatTypes
 * 					extends None 
 * 					implements None
 *  Author:			Maninsoft, Inc.
 *  Description:	Form Editor에서 Form Grid의 표현될수 있는 Format항목들의 형식을 정의하는 클래스
 * 				
 *  History:		Created by Maninsoft, Inc.
 * 					2010.2.26 Modified by Y.S. Jung for SWV20003: 폼에디터에 이미지를 보여주는 항목 추가
 * 					2010.2.26 Modified by Y.S. Jung for SWV20004: 폼에디터에 이메일아이디를 입력하는 항목 추가
 * 
 *  Copyright (C) 2007-2010 Maninsoft, Inc. All Rights Reserved.
 *  
 */

package com.maninsoft.smart.formeditor.model.type
{
	import mx.resources.ResourceManager;
	
	public class CurrencyTypes
	{
		public static var koreaWon:CurrencyType = new CurrencyType(ResourceManager.getInstance().getString("FormEditorETC", "koreaWonText"), "￦", "￦"); 
		public static var usDollar:CurrencyType = new CurrencyType(ResourceManager.getInstance().getString("FormEditorETC", "usDollarText"), "$", "$");
		public static var currencyTypeArray:Array = [ koreaWon, usDollar ]
		
		public static function getCurrencyType(currencySymbol:String):CurrencyType{
			for each(var currencyType:CurrencyType in currencyTypeArray){
				if(currencyType.currencySymbol == currencySymbol){
					return currencyType;
				}
			}
			return null;
		}
	}
}