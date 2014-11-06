package com.maninsoft.smart.workbench.common
{
	public interface IWorkbenchEditor
	{
		
		/**
		 * 환경을 설정하는 메소드
		 * @compId:String : 컴퍼니 아이디
		 * @userId:String : 유저 아이디
		 * @serviceUrl : 서버에서 모델러와 관련된 서비스를 하는 url
		 * 
		 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
		 * 	2010.3.2 Added by Y.S. Jung
		 */
		function config(compId:String, userId:String, serviceUrl:String):void;
			
    	/**
    	 * 패키지를 로드하는 메소드
    	 * @packId : 패키지 아이디
    	 * @packVer : 패키지 버전
    	 **/
        function load(packId:String, packVer:int):void;
	}
}