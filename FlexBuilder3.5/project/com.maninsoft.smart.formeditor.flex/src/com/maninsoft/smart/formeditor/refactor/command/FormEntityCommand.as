package com.maninsoft.smart.formeditor.refactor.command
{
	import com.maninsoft.smart.formeditor.model.FormEntity;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class FormEntityCommand extends Command
	{
		public var formEntityModel:FormEntity;
		
		public function FormEntityCommand(label:String) {
			super(label);
		}
	
		public override function execute():void{
		}

		public override function undo():void{
		}
		
		public override function redo():void{
		}
	}
}