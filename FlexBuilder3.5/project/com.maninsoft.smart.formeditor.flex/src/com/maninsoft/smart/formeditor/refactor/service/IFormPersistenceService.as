package com.maninsoft.smart.formeditor.refactor.service
{
	public interface IFormPersistenceService
	{
		/**
		 * 폼 내용을 저장 
		 **/
		function save(id:String, version:int, contents:XML, callBack:Function, fault:Function):void;
		/**
		 * 폼 내용을 로드 
		 **/
		function load(id:String, version:int, callBack:Function, fault:Function):void;
		/**
		 * 폼 리스트를 로드 
		 **/
		function loadList(callBack:Function, fault:Function):void;
		/**
		 * 프로세스 내의 폼 리스트를 로드 
		 **/		
		function loadListByProcess(processId:String, version:int, callBack:Function, fault:Function):void;
		/**
		 * 프로세스 내의 폼 리스트를 로드 
		 **/		
		function loadListByForm(formId:String, version:int, callBack:Function, fault:Function):void;
		/**
		 * 워크타입과 연결된  폼 컨텐츠 리스트를 로드 
		 **/
		function loadByWorkType(workTypeId:String, callBack:Function, fault:Function):void;
		/**
		 * 폼 내용을 저장 
		 **/
		function saveInstance(instanceId:String, contents:XML, callBack:Function, fault:Function):void;
		/**
		 * 폼 데이타를 로드 
		 **/		
		function loadInstance(instanceId:String, callBack:Function, fault:Function):void;
		/**
		 * 폼을 키로 하여 폼 데이타 리스트를 로드 
		 **/
		function loadInstanceListByForm(id:String, version:int, callBack:Function, fault:Function):void;
		/**
		 * 모든 단위 폼을 로드
		 **/
		function loadAllSingleList(callBack:Function, fault:Function):void;
		/**
		 * 단위 폼의 필드 리스트을 로드
		 **/
		function loadSingleFormFieldList(formId:String, callBack:Function, fault:Function):void;
		
		function getRootCategory(resultHandler:Function):void;
		
		function getParentCategory(categoryId:String, resultHandler:Function):void;
		
		function getCategoryById(categoryId:String, resultHandler:Function):void;
		
		function getChildrenByCategoryId(categoryId:String, resultHandler:Function):void;

		function getPackagesByCategoryId(categoryId:String, resultHandler:Function):void;
		
	}
}