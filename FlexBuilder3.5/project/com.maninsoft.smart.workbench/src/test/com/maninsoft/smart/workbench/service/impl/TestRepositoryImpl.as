package test.com.maninsoft.smart.workbench.service.impl
{
	import com.maninsoft.smart.workbench.common.meta.impl.SWForm;
	import com.maninsoft.smart.workbench.common.meta.impl.SWPackage;
	import com.maninsoft.smart.workbench.common.meta.impl.SWProcess;
	import com.maninsoft.smart.workbench.event.service.RepositoryServiceEvent;
	import com.maninsoft.smart.workbench.service.IRepositoryService;
	
	public class TestRepositoryImpl implements IRepositoryService
	{
		public function TestRepositoryImpl()
		{
		}

		private var retrieveResultHandler:Function;
		private var saveResultHandler:Function;
		private var faultHandler:Function;
		
		private var _packId:String;
		private var _pack:SWPackage;
		
		// 패키지를 로드 
		public function retrievePackage(packId:String, resultHandler:Function, faultHandler:Function):void{
			this._packId = packId;
			
			this.retrieveResultHandler = resultHandler;
			this.faultHandler = faultHandler;
			
			this.retrieveResult();
		}
		// 구조까지 포함한 모든 패키지 정보를 저장
		public function savePackage(pack:SWPackage, resultHandler:Function, faultHandler:Function):void{
			this._pack = pack;
			
			this.saveResultHandler = resultHandler;
			this.faultHandler = faultHandler;
			
			this.saveResult();
		}
		
		private function retrieveResult():void{
			var event:RepositoryServiceEvent = new RepositoryServiceEvent(RepositoryServiceEvent.RETRIEVE);
			
			var retrievePack:SWPackage = new SWPackage();
			retrievePack.setId("pack1");
			
			var retrieveProcess:SWProcess = new SWProcess();
			retrieveProcess.setId("process1");
			retrieveProcess.setVersion(1);
			retrieveProcess.checkout = true;
			retrievePack.setProcessResource(retrieveProcess);
			
			var retrieveForm:SWForm = new SWForm();
			retrieveForm.setId("form1");
			retrieveForm.setVersion(1);
			retrieveForm.checkout = false;
			retrievePack.addFormResource(retrieveForm);
			
			event.swPack = retrievePack;
			
			this.retrieveResultHandler(event);
		}
		
		private function saveResult():void{
			var event:RepositoryServiceEvent = new RepositoryServiceEvent(RepositoryServiceEvent.SAVE);
			
			this.saveResultHandler(event);
		}
		
		private function fault():void{
			var event:RepositoryServiceEvent = new RepositoryServiceEvent(RepositoryServiceEvent.FAIL);
			
			this.faultHandler(event);
		}
	}
}