package com.maninsoft.smart.workbench.command
{
	import com.maninsoft.smart.workbench.common.command.model.Command;
	import com.maninsoft.smart.workbench.common.meta.impl.SWForm;
	import com.maninsoft.smart.workbench.common.meta.impl.SWPackage;
	import com.maninsoft.smart.workbench.event.MISPackageEvent;
	import com.maninsoft.smart.workbench.util.WorkbenchConfig;
	
	public class AddFormCommand extends Command
	{
		public var pack:SWPackage;		
		public var formName:String;
		
		private var swForm:SWForm;
		
		public var resultHandler:Function;		
		public var faultHandler:Function;
		public var undoHandler:Function;
	
		public function AddFormCommand(pack:SWPackage, formName:String, resultHandler:Function, faultHandler:Function, undoHandler:Function) {
			super("화면추가");
			
			this.pack = pack;
			this.formName = formName;
			this.resultHandler = resultHandler;
			this.faultHandler = faultHandler;
			this.undoHandler = undoHandler;
		}
		
		/**
		 * undo가 가능한 지 확인
		 */
		public override function canUndo():Boolean{
			// 해당 패키지에 현재 폼이 있는 경우에만 true
			// 프로세스 정보가 있는 경우에만 true
			return true;
		}
		
		public override function execute():void{
			WorkbenchConfig.repoService.addForm(this.pack, formName, executeHandler, faultHandler);
		}
		
		public function executeHandler(event:MISPackageEvent):void{
			swForm = event.swForm; 
			this.resultHandler(event);
		}

		public override function undo():void{
			WorkbenchConfig.repoService.removeForm(this.pack, swForm, (undoHandler == null)?resultHandler:undoHandler, faultHandler);
		}		
	}
}