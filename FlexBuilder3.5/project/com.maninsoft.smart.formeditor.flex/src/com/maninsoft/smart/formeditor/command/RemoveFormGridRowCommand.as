package com.maninsoft.smart.formeditor.command
{
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridRow;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class RemoveFormGridRowCommand extends Command
	{
		
		public var gridRow:FormGridRow;
		private var oldGridRow:FormGridRow;
		private var oldIndex:int;
		
		public function RemoveFormGridRowCommand(gridRow:FormGridRow)
		{
			this.gridRow = gridRow;
		}

		public override function execute():void{
			this.oldGridRow = this.gridRow;
			this.oldIndex = this.gridRow.gridLayout.getRowIndex(this.gridRow);
			
			this.gridRow.gridLayout.removeRow(this.gridRow);
		}

		public override function undo():void{
			this.oldGridRow.gridLayout.addRow(this.oldGridRow, this.oldIndex);
		}	
		
		public override function redo():void{
			this.oldGridRow.gridLayout.removeRow(this.gridRow);
		}
		public override function getLabel():String{
			return "Remove FormGridRow(" + gridRow + ") in FormGridLayout(" + gridRow.gridLayout + ")";
		}
	}
}