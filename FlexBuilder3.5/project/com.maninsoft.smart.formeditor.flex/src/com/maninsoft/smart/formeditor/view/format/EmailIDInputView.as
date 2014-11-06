/**
 * 
 *  Package: 		com.maninsoft.smart.formeditor.view.format
 *  Class: 			EmailIDInputView
 * 					extends TextInputView 
 * 					implements None
 *  Author:			Y.S. Jung
 *  Description:	Form Editor에서 이메일입력 항목 형식을 표현하기 위한 view 클래스
 * 				
 *  History:		Created by Y.S. Jung for SWV20004: 폼에디터에 이메일아이디를 입력하는 항목 추가
 * 
 *  Copyright (C) 2007-2010 Maninsoft, Inc. All Rights Reserved.
 *  
 */

package com.maninsoft.smart.formeditor.view.format
{
	import com.maninsoft.smart.formeditor.model.type.FormatType;
	import com.maninsoft.smart.formeditor.model.type.FormatTypes;

	public class EmailIDInputView extends TextInputView
	{
		public function EmailIDInputView()
		{
			super();
		}

		override public function get formatType():FormatType {
			return FormatTypes.emailIDInput;
		}
		
	}
}