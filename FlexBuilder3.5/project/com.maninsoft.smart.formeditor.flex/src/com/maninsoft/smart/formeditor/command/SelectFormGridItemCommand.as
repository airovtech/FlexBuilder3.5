package com.maninsoft.smart.formeditor.command
{
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridCell;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class SelectFormGridItemCommand extends Command
	{
		public var gridItem:FormGridCell;
		
		public function SelectFormGridItemCommand(gridItem:FormGridCell)
		{
			this.gridItem = gridItem;
		}

		public override function execute():void{
			this.gridItem.select();
		}

		public override function undo():void{
			this.gridItem.select(false);
		}	
		public override function getLabel():String{
			return "Select FormGridItem(" + gridItem + ")";
		}
	}
}