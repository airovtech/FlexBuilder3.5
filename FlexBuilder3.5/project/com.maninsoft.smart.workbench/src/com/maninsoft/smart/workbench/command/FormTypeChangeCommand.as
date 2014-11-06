package com.maninsoft.smart.workbench.command
{
	import com.maninsoft.smart.workbench.common.command.model.Command;
	import com.maninsoft.smart.workbench.event.MISPackageEvent;
	import com.maninsoft.smart.workbench.util.WorkbenchConfig;
	
	public class FormTypeChangeCommand extends Command
	{
		public var formId:String;	
		public var version:String;
		public var type:String;	
		
		public var resultHandler:Function;		
		public var faultHandler:Function;
		public var undoHandler:Function;
	
		public function FormTypeChangeCommand(formId:String, version:String, type:String, resultHandler:Function, faultHandler:Function) {
			super("폼  타입변경");
			
			this.formId = formId;
			this.version = version;
			this.type = type;
			this.resultHandler = resultHandler;
			this.faultHandler = faultHandler;
			this.undoHandler = undoHandler;
		}
	
		/**
		 * 실행가능한 지 확인
		 */
		public override function canExecute():Boolean{
			// 패키지에  프로세스가 없는 경우에만
			return true;
		}
		
		/**
		 * undo가 가능한 지 확인
		 */
		public override function canUndo():Boolean{
			// 해당 패키지에 프로세스가 있는 경우에만 true
			// 프로세스 정보가 있는 경우에만 true
			return true;
		}
		
		public override function execute():void{
			WorkbenchConfig.repoService.formTypeChange(this.formId, this.version, this.type, resultHandler, faultHandler);
		}
		
		public function executeHandler(event:MISPackageEvent):void{
			this.resultHandler(event);
		}

		public override function undo():void{
		}		
	}
}