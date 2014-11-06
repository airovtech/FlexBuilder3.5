package com.maninsoft.smart.formeditor.refactor.editor
{
	import com.maninsoft.smart.formeditor.refactor.util.ServiceClient;
	import com.maninsoft.smart.workbench.common.editor.EditDomain;
	
	public class FormEditDomain extends EditDomain
	{
		private var _serviceClient:ServiceClient;
		private var _serviceUrl:String;
		
		public function FormEditDomain(serviceUrl:String)
		{
			this._serviceUrl = serviceUrl;
		}

		public function get serviceClient():ServiceClient
		{
			if(_serviceClient == null){
				_serviceClient = new ServiceClient(_serviceUrl);
			}
			
			return _serviceClient;
		}
	}
}