package com.maninsoft.smart.workbench.common.preloader
{
	public interface IProgress
	{
		function progress(bytesLoaded:int,bytesTotal:int):void;
	}
}