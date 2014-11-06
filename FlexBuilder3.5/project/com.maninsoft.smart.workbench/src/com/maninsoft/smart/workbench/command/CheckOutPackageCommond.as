package com.maninsoft.smart.workbench.command
{
	import com.maninsoft.smart.workbench.common.command.model.Command;
	import com.maninsoft.smart.workbench.util.WorkbenchConfig;

	public class CheckOutPackageCommond extends Command{
		
		private var packId:String;
		private var packVer:int;
		public var resultHandler:Function;
		
		public function CheckOutPackageCommond(packId:String, packVer:int, resultHandler:Function){
			super("패키지 체크아웃");
			this.packId = packId;
			this.packVer = packVer;
			this.resultHandler = resultHandler;
		}
		
		public override function execute():void{
			WorkbenchConfig.repoService.checkOut(this.packId, this.packVer, this.resultHandler);
		}	
	}
}