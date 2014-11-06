/**
 * 
 *  Package: 		com.maninsoft.smart.formeditor.layout.grid
 *  Interface: 		ISelectableContainerView
 * 					extends ISelectableView 
 * 					implements None
 *  Author:			Maninsoft, Inc.
 *  Description:	Form Editor에서 Form Grid에서 선택가능하는 Container View의 인터페이스
 * 				
 *  History:		Created by Maninsoft, Inc.
 * 					2010.2.26 Modified by Y.S. Jung for 스펠링수정 *childern* --> *children*
 * 
 *  Copyright (C) 2007-2010 Maninsoft, Inc. All Rights Reserved.
 *  
 */

package com.maninsoft.smart.formeditor.layout.grid
{
	import com.maninsoft.smart.formeditor.view.ISelectableView;
	
	import flash.geom.Rectangle;
	
	public interface ISelectableContainerView extends ISelectableView
	{
		function selectChildByBound(bound:Rectangle):void;
		
		function getSelectChildren():Array;
		
		function unSelectChild():void;
	}
}