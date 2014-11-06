////////////////////////////////////////////////////////////////////////////////
//  IViewIcon.as
//  2008.01.15, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.view
{
	/**
	 * IView의 특성을 나타내기 위해 IView의 child로 표시되는 작은 아이콘
	 */
	public interface IViewIcon {
		
		/**
		 * viewIcon이 표시되는 parent view를 리턴한다.
		 */
		function get view(): IView;
		
		/**
		 * Tooltip에 표시될 내용
		 */
		function get toolTip(): String;
	}
}