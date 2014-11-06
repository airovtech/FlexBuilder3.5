////////////////////////////////////////////////////////////////////////////////
//  IEditable.as
//  2008.01.07, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.controller
{
	import flash.geom.Rectangle;
	
	/**
	 * 다이어그램 에디터 상에서 바로 개체의 텍스트 변경할 수 있는 개체가 구현해야 할 스펙
	 */
	public interface ITextEditable {
		
		/**
		 * 현재 편집 가능한 상태인가?
		 */
		function canModifyText(): Boolean;
		
		//function canEditInEvent(event: MouseEvent): Boolean;
		
		/**
		 * 개체의 현재 text 값을 리턴
		 */
		function getEditText(): String;
		/**
		 * 텍스트 편집기 내에서 변경된 값으로 호출
		 */
		function setEditText(value: String): void;
		/**
		 * 텍스트 편집기가 표시되어야 할 경계를 다이어그램 에디터 좌표로 리턴
		 */
		function getTextEditBounds(): Rectangle;
	}
}