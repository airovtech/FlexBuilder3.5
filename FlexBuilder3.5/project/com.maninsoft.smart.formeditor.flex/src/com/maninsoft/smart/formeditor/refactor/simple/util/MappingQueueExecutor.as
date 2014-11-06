package com.maninsoft.smart.formeditor.refactor.simple.util
{
	import com.maninsoft.smart.formeditor.model.condition.FormCondition;
	import com.maninsoft.smart.formeditor.model.mapping.FormMapping;
	import com.maninsoft.smart.formeditor.refactor.util.ServiceClient;
	
	import mx.collections.ArrayCollection;
	
	public class MappingQueueExecutor
	{
		private var mappingQueue:ArrayCollection = new ArrayCollection();
		
		private var _serviceClient:ServiceClient;
		
		public function MappingQueueExecutor(serviceClient:ServiceClient){
			this._serviceClient = serviceClient;			
		}
		
		public function push(mapping:FormMapping):void
		{
			mappingQueue.addItem(mapping);
		}
		
		public function  canExecute():Boolean{
			return mappingQueue.length > 0;
		}
		
		public var currentMapping:FormMapping;
		
		public function  execute(valueXml:XML, callBack:Function, fault:Function):void{
			if(canExecute()){
				currentMapping = FormMapping(mappingQueue.removeItemAt(0));
				executeMapping(currentMapping, valueXml, callBack, fault);
			}
			
		}
		
		private function executeMapping(mapping:FormMapping, valueXml:XML, callBack:Function, fault:Function):void{
				
			var mappingParamXml:XML = 
				<DataRecord workItemId="" formId="" formVersion=""></DataRecord>;
			
			var fieldIdArray:ArrayCollection = new ArrayCollection();	
			for each(var cond:FormCondition in mapping.conditions){
				if(!(fieldIdArray.contains(cond.firstOperand))){
					fieldIdArray.addItem(cond.firstOperand);
				}
			}
			
			var valueArray:ArrayCollection = new ArrayCollection();
			for each(var fieldId:String in fieldIdArray){
				DataUtil.searchFieldDataXml(fieldId, valueXml, valueArray);						
			}
			
			for each(var fieldXml:XML in valueArray){
				mappingParamXml.appendChild(fieldXml);
			}
			// 맵핑 서비스 호출
			if(valueArray.length > 0){
				_serviceClient.worklistService.loadMappingData(mapping.formDocument.id, 1, mapping.id,
						mappingParamXml, callBack, fault);
			}
		}
		
	}
}