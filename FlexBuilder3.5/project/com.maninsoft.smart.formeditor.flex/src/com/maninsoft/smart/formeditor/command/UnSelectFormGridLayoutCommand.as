package com.maninsoft.smart.formeditor.command
{
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridLayout;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class UnSelectFormGridLayoutCommand extends Command
	{
		public var gridLayout:FormGridLayout;
		
		public function UnSelectFormGridLayoutCommand(gridLayout:FormGridLayout)
		{
			this.gridLayout = gridLayout;
		}

		public override function execute():void{
			this.gridLayout.select(false);
		}

		public override function undo():void{
			this.gridLayout.select();
		}	
		public override function getLabel():String{
			return "UnSelect FormLayout(" + gridLayout + ")";
		}	
	}
}