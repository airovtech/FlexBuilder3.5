package com.maninsoft.smart.workbench.command
{
	import com.maninsoft.smart.workbench.common.command.model.Command;
	import com.maninsoft.smart.workbench.common.meta.impl.SWPackage;
	import com.maninsoft.smart.workbench.common.meta.impl.SWProcess;
	import com.maninsoft.smart.workbench.util.WorkbenchConfig;
	
	public class UpdateProcessCommand extends Command
	{
		public var pack:SWPackage;		
		public var swPrc:SWProcess;
		
		public var type:String;		
		public var newValue:Object;
		public var oldValue:Object;
		
		public var resultHandler:Function;		
		public var faultHandler:Function;
		public var undoHandler:Function;
	
		public function UpdateProcessCommand(pack:SWPackage, swPrc:SWProcess, type:String, value:Object, resultHandler:Function, faultHandler:Function, undoHandler:Function) {
			super("프로세스 변경");
			
			this.pack = pack;
			this.swPrc = swPrc;
			
			this.type = type;
			this.newValue = value;
			
			this.resultHandler = resultHandler;
			this.faultHandler = faultHandler;
			this.undoHandler = undoHandler;
		}
	
		public override function execute():void{
			oldValue = swPrc[this.type];
			swPrc[this.type] = newValue;
			WorkbenchConfig.repoService.saveProcess(this.pack, swPrc, resultHandler, faultHandler);			
		}

		public override function undo():void{		
			swPrc[this.type] = oldValue;
			WorkbenchConfig.repoService.saveProcess(this.pack, swPrc, resultHandler, faultHandler);	
		}		
		
		public override function redo():void{		
			swPrc[this.type] = newValue;
			WorkbenchConfig.repoService.saveProcess(this.pack, swPrc, resultHandler, faultHandler);			
		}	
	}
}