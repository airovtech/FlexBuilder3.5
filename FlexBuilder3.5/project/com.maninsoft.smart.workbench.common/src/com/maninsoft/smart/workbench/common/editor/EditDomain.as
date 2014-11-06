package com.maninsoft.smart.workbench.common.editor
{
	import com.maninsoft.smart.workbench.common.command.CommandStack;
	
	public class EditDomain
	{
//		public var rootViewer:FormEditPartViewer;
				
		private var commandStack:CommandStack = new CommandStack();
		
		public function getCommandStack():CommandStack{
			return this.commandStack;
		}
		
		public function EditDomain(){
		}
		
		// default tool 로드
		public function loadDefaultTool():void{
		}

	}
}