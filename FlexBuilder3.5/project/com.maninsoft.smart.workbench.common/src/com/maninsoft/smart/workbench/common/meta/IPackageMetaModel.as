package com.maninsoft.smart.workbench.common.meta
{
	import mx.collections.ArrayCollection;
	
	public interface IPackageMetaModel extends IResourceMetaModel
	{
		function getProcessResource():IProcessMetaModel;
		function setProcessResource(processResource:IProcessMetaModel):void;
		function addFormResource(formResource:IFormMetaModel, num:int = -1):void;
		function removeFormResource(formResource:IFormMetaModel):void;
		function removeFormResourceByNum(num:int):void;
		function getFormResource(num:int):IFormMetaModel;
		function getFormResources():ArrayCollection;
		
		function get children():ArrayCollection;
		
	}
}