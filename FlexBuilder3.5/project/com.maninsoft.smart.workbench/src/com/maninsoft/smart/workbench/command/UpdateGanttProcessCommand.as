package com.maninsoft.smart.workbench.command
{
	import com.maninsoft.smart.workbench.common.command.model.Command;
	import com.maninsoft.smart.workbench.common.meta.impl.SWPackage;
	import com.maninsoft.smart.workbench.common.meta.impl.SWGanttProcess;
	import com.maninsoft.smart.workbench.util.WorkbenchConfig;
	
	public class UpdateGanttProcessCommand extends Command
	{
		public var pack:SWPackage;		
		public var swGPrc:SWGanttProcess;
		
		public var type:String;		
		public var newValue:Object;
		public var oldValue:Object;
		
		public var resultHandler:Function;		
		public var faultHandler:Function;
		public var undoHandler:Function;
	
		public function UpdateGanttProcessCommand(pack:SWPackage, swGPrc:SWGanttProcess, type:String, value:Object, resultHandler:Function, faultHandler:Function, undoHandler:Function) {
			super("프로세스 변경");
			
			this.pack = pack;
			this.swGPrc = swGPrc;
			
			this.type = type;
			this.newValue = value;
			
			this.resultHandler = resultHandler;
			this.faultHandler = faultHandler;
			this.undoHandler = undoHandler;
		}
	
		public override function execute():void{
			oldValue = swGPrc[this.type];
			swGPrc[this.type] = newValue;
			WorkbenchConfig.repoService.saveProcess(this.pack, swGPrc, resultHandler, faultHandler);			
		}

		public override function undo():void{		
			swGPrc[this.type] = oldValue;
			WorkbenchConfig.repoService.saveProcess(this.pack, swGPrc, resultHandler, faultHandler);	
		}		
		
		public override function redo():void{		
			swGPrc[this.type] = newValue;
			WorkbenchConfig.repoService.saveProcess(this.pack, swGPrc, resultHandler, faultHandler);			
		}	
	}
}