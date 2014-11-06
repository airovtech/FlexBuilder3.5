package com.maninsoft.smart.formeditor.command
{
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridCell;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class RemoveFormGridItemCommand extends Command
	{
		
		public var gridItem:FormGridCell;
		private var oldGridItem:FormGridCell;
		private var oldIndex:int;
		
		public function RemoveFormGridItemCommand(gridItem:FormGridCell)
		{
			this.gridItem = gridItem;
		}

		public override function execute():void{
			this.oldGridItem = this.gridItem;
			this.oldIndex = this.gridItem.gridRow.getCellIndex(this.oldGridItem);
			
			this.gridItem.gridRow.removeCell(this.gridItem);
		}

		public override function undo():void{
			this.oldGridItem.gridRow.addCell(this.oldGridItem, this.oldIndex);
		}	
		
		public override function redo():void{
			this.gridItem.gridRow.removeCell(this.gridItem);
		}
		public override function getLabel():String{
			return "Remove FormGridItem(" + gridItem + ") in FormGridRow(" + gridItem.gridRow + ")";
		}	
	}
}