package com.maninsoft.smart.workbench.service
{
	import com.maninsoft.smart.workbench.common.meta.impl.SWForm;
	import com.maninsoft.smart.workbench.common.meta.impl.SWPackage;
	import com.maninsoft.smart.workbench.common.meta.impl.SWProcess;
	
	public interface IRepositoryService
	{			

		// 패키지를 로드 
		function retrievePackage(packId:String, packVer:int, resultHandler:Function, faultHandler:Function):void;
		// 구조까지 포함한 모든 패키지 정보를 저장

		function savePackage(pack:SWPackage, resultHandler:Function, faultHandler:Function):void;
		
		// 프로세스 추가
		function addProcess(pack:SWPackage, processName:String, resultHandler:Function, faultHandler:Function):void;
		// 폼 추가
		function addForm(pack:SWPackage, formName:String, resultHandler:Function, faultHandler:Function):void;
		
		// 프로세스 삭제
		function removeProcess(pack:SWPackage, swProcess:SWProcess, resultHandler:Function, faultHandler:Function):void;
		// 폼 삭제
		function removeForm(pack:SWPackage, swForm:SWForm, resultHandler:Function, faultHandler:Function):void;
		
		// 프로세스 삭제
		function saveProcess(pack:SWPackage, swProcess:SWProcess, resultHandler:Function, faultHandler:Function):void;
		
		// 프로세스 이름변경
		function renameProcess(pack:SWPackage, swProcess:SWProcess, resultHandler:Function, faultHandler:Function):void;
		
		// 폼 저장
		function saveForm(pack:SWPackage, swForm:SWForm, resultHandler:Function, faultHandler:Function):void;		
		
		function renameForm(swForm:SWForm, formName:String, resultHandler:Function, faultHandler:Function):void;
		
		function cloneForm(pack:SWPackage, swForm:SWForm, newFormName:String, resultHandler:Function, faultHandler:Function):void;
		
		//폼타입변경
		function formTypeChange(formId:String, version:String, type:String, resultHandler:Function, faultHandler:Function):void;	
		
		function deploy(pack:SWPackage, resultHandler:Function, faultHandler:Function):void;
		
		function checkIn(packId:String, packVer:int, resultHandler:Function):void;
		
		function checkOut(packId:String, packVer:int, resultHandler:Function):void;
//		// 패키지 정보만 로드
//		function retrievePackageInfo(packId:String, packVer:int, resultHandler:Function, faultHandler:Function):void;
//		// 패키지 정보를 저장
//		function savePackageInfo(pack:SWPackage, resultHandler:Function, faultHandler:Function):void;
//		
//		function addProcess(packId:String, packVer:int, prc:SWProcess, resultHandler:Function, faultHandler:Function):void;
//		function addForm(packId:String, packVer:int, form:SWForm, resultHandler:Function, faultHandler:Function):void;
//
//		function saveProcess(packId:String, packVer:int, prc:SWProcess, resultHandler:Function, faultHandler:Function):void;
//		function saveForm(packId:String, packVer:int, form:SWForm, resultHandler:Function, faultHandler:Function):void;
//
//		function retrieveProcess(packId:String, packVer:int, prcId:String, resultHandler:Function, faultHandler:Function):void;
//		function retrieveForm(packId:String, packVer:int, formId:String, resultHandler:Function, faultHandler:Function):void;
//		
//		function deleteProcess(packId:String, packVer:int, prcId:String, resultHandler:Function, faultHandler:Function):void;
//		function deleteForm(packId:String, packVer:int, formId:String, resultHandler:Function, faultHandler:Function):void;
	}
}