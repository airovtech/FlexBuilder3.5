package com.maninsoft.smart.workbench.command
{
	import com.maninsoft.smart.workbench.common.command.model.Command;
	import com.maninsoft.smart.workbench.common.meta.impl.SWForm;
	import com.maninsoft.smart.workbench.common.meta.impl.SWPackage;
	import com.maninsoft.smart.workbench.util.WorkbenchConfig;
	
	public class RenameFormCommand  extends Command
	{
		public var pack:SWPackage;		
		public var swForm:SWForm;
		
		public var newName:String;
		public var oldName:String;
		
		public var resultHandler:Function;		
		public var faultHandler:Function;
		public var undoHandler:Function;
	
		public function RenameFormCommand(pack:SWPackage, swForm:SWForm, name:String, resultHandler:Function, faultHandler:Function, undoHandler:Function) {
			super("화면속성 변경");
			
			this.pack = pack;
			this.swForm = swForm;
			
			this.newName = name;
			
			this.resultHandler = resultHandler;
			this.faultHandler = faultHandler;
			this.undoHandler = undoHandler;
		}
	
		public override function execute():void{
			oldName = swForm.name;
			WorkbenchConfig.repoService.renameForm(swForm, newName, resultHandler, faultHandler);			
		}

		public override function undo():void{		
			WorkbenchConfig.repoService.renameForm(swForm, oldName, resultHandler, faultHandler);
		}		
		
		public override function redo():void{		
			WorkbenchConfig.repoService.renameForm(swForm, newName, resultHandler, faultHandler);		
		}	
	}
}