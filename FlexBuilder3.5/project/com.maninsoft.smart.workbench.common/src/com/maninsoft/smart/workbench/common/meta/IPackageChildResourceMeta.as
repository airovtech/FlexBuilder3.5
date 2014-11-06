package com.maninsoft.smart.workbench.common.meta
{
	public interface IPackageChildResourceMeta extends IResourceMetaModel
	{
		function get status():String;
		function set status(status:String):void;

		function getPackage():IPackageMetaModel;
		function setPackage(packageModel:IPackageMetaModel):void;
		
		function get version():int;
		function set version(version:int):void;

	}
}