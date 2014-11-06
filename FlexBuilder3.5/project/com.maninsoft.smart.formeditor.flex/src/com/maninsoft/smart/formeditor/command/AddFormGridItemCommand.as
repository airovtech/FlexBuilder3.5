package com.maninsoft.smart.formeditor.command
{
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridCell;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridRow;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class AddFormGridItemCommand extends Command
	{
		public var gridRow:FormGridRow;
		public var gridItem:FormGridCell;
		public var index:int;
		
		public function AddFormGridItemCommand(gridRow:FormGridRow, gridItem:FormGridCell, index:int = -1)
		{
			this.gridRow = gridRow;
			this.gridItem = gridItem;
			this.index = index;
		}

		public override function execute():void{
			this.gridRow.addCell(this.gridItem, this.index);
		}

		public override function undo():void{
			this.gridRow.removeCell(this.gridItem);
		}
		
		public override function getLabel():String{
			return "Add FormGridItem(" + gridItem + ") to FormGridRow(" + gridRow + ") at index(" + index + ")";
		}	
	}
}