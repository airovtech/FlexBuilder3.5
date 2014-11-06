package com.maninsoft.smart.workbench.common.meta
{
	import flash.events.IEventDispatcher;
	
	public interface IMetaModelOwner extends IEventDispatcher
	{
		function setResourceMetaModel(metaModel:IResourceMetaModel):void;
		function getResourceMetaModel():IResourceMetaModel;
	}
}