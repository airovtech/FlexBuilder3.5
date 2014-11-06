////////////////////////////////////////////////////////////////////////////////
//  IControllerHandle.as
//  2007.12.31, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
//
//  Addio 2007 !! 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.controller
{
	import com.maninsoft.smart.modeler.command.Command;
	
	/**
	 * 개별 컨트롤러에 특별한 action을 수행하기 위한 컨트롤러
	 * 컨트롤러가 유일하게 선택되면 표시되고 그렇지 않으면 사라진다.
	 */ 
	public interface IControllerTool {
		
		function get controller(): Controller;
		function get enabled(): Boolean;
	}
}