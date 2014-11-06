package com.maninsoft.smart.formeditor.refactor.service
{
	public interface IWorklistService
	{
		function execute(workitemId:String, contents:XML, nextDuration:String, nextPerformer:String, callBack:Function, fault:Function):void;
		
		function saveWork(workitemId:String, contents:XML, callBack:Function, fault:Function):void;
		
		function entrustWork(workitemId:String, contents:XML, entruster:String, callBack:Function, fault:Function):void;
		
		function returnWork(workitemId:String, contents:XML, callBack:Function, fault:Function):void;
		
		function terminateWork(workitemId:String, contents:XML, callBack:Function, fault:Function):void;
		
		function load(workitemId:String, callBack:Function, fault:Function):void;
		
		function loadRef(workitemId:String, formId:String, callBack:Function, fault:Function):void;
		
		function loadList(callBack:Function, fault:Function):void;
		
		function loadFormByWorkItemId(workitemId:String, callBack:Function, fault:Function):void;
		
		function loadForm(formId:String, version:int, callBack:Function, fault:Function):void;
		
		function executeStart(formId:String, prcId:String, version:int, prcTitle:String, keyword:String, description:String, nextPerformer:String, contents:XML, callBack:Function, fault:Function):void;
		
		function creteRecord(contents:XML, callBack:Function, fault:Function):void;
		
		function loadMappingData(formId:String, version:int, mappingId:String, parameterXml:XML, callBack:Function, fault:Function):void;
	
		function loadRecord(recordId:String, formId:String, callBack:Function, fault:Function):void;
		
		function assign(formId:String, version:int, title:String, assignee:String, relatedWorkItemId:String, contents:XML, nextDuration:String, callBack:Function, fault:Function):void;
		
	}
}