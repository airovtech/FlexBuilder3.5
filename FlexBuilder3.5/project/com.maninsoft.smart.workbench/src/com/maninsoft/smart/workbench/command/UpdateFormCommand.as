package com.maninsoft.smart.workbench.command
{
	import com.maninsoft.smart.workbench.common.command.model.Command;
	import com.maninsoft.smart.workbench.common.meta.impl.SWForm;
	import com.maninsoft.smart.workbench.common.meta.impl.SWPackage;
	import com.maninsoft.smart.workbench.event.MISPackageEvent;
	import com.maninsoft.smart.workbench.util.WorkbenchConfig;
	
	public class UpdateFormCommand  extends Command
	{
		public var pack:SWPackage;		
		public var swForm:SWForm;
		
		public var type:String;		
		public var newValue:Object;
		public var oldValue:Object;
		
		public var resultHandler:Function;		
		public var faultHandler:Function;
		public var undoHandler:Function;
	
		public function UpdateFormCommand(pack:SWPackage, swForm:SWForm, type:String, value:Object, resultHandler:Function, faultHandler:Function, undoHandler:Function) {
			super("화면속성 변경");
			
			this.pack = pack;
			this.swForm = swForm;
			
			this.type = type;
			this.newValue = value;
			
			this.resultHandler = resultHandler;
			this.faultHandler = faultHandler;
			this.undoHandler = undoHandler;
		}
	
		public override function execute():void{
			oldValue = swForm[this.type];
			swForm[this.type] = newValue;
			WorkbenchConfig.repoService.saveForm(this.pack, swForm, executeHandler, faultHandler);			
		}
		
		public function executeHandler(event:MISPackageEvent):void{
			event.swForm = swForm;
			this.resultHandler(event);
		}

		public override function undo():void{		
			swForm[this.type] = oldValue;
			WorkbenchConfig.repoService.saveForm(this.pack, swForm, resultHandler, faultHandler);	
		}		
		
		public override function redo():void{		
			swForm[this.type] = newValue;
			WorkbenchConfig.repoService.saveForm(this.pack, swForm, resultHandler, faultHandler);			
		}	
	}
}