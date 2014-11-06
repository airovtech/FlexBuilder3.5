/**
 * 
 *  Package: 		com.maninsoft.smart.formeditor.util
 *  Class: 			FormEditorConfig
 * 					extends None 
 * 					implements None
 *  Author:			Maninsoft, Inc.
 *  Description:	Form Editor에서 서버에 서비스를 호출하기 위해 필요한 설정을 위한 클래스
 * 				
 *  History:		Created by Maninsoft, Inc.
 * 					2010.3.2 Modified by Y.S. Jung for SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
 * 
 *  Copyright (C) 2007-2010 Maninsoft, Inc. All Rights Reserved.
 *  
 */

package com.maninsoft.smart.formeditor.util
{
	import com.maninsoft.smart.formeditor.refactor.Constants;
	
	public class FormEditorConfig
	{
		public static var userId:String;
		/**
		 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
		 * 	2010.3.2 Added by Y.S. Jung
		 */
		public static var compId:String;
		private static var _baseUrl:String;
		public static var basePath:String;
		public static var serviceUrl:String;
		
		public static function get baseUrl():String {
			return _baseUrl;
		}
		public static function set baseUrl(baseUrl:String):void {
			_baseUrl = baseUrl;
			basePath = baseUrl + "smartworksV3";
			serviceUrl = basePath + "/services/builder/builderService.jsp";
		}
		
		public static function get orgServiceUrl():String{
			return basePath + "/services/common/organizationService.jsp";
		}
		
		// 파라미터를 받아서 config 생성
		public static function config(parameter:Object):void
		{
			userId = parameter.sessionUserId;
			/**
			 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
			 * 	2010.3.2 Added by Y.S. Jung
			 */
			compId = parameter.sessionCompId;
			baseUrl = parameter.serviceUrl;
		}
	}
}