package com.maninsoft.smart.workbench.command
{
	import com.maninsoft.smart.workbench.common.command.model.Command;
	import com.maninsoft.smart.workbench.util.WorkbenchConfig;

	public class CheckInPackageCommond extends Command{
		
		private var packId:String;
		private var packVer:int;
		public var resultHandler:Function;
		
		public function CheckInPackageCommond(packId:String, packVer:int, resultHandler:Function){
			super("패키지 체크인");
			this.packId = packId;
			this.packVer = packVer;
			this.resultHandler = resultHandler;
		}
		
		public override function execute():void{
			WorkbenchConfig.repoService.checkIn(this.packId, this.packVer, this.resultHandler);
		}	
	}
}