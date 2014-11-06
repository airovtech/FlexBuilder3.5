package com.maninsoft.smart.formeditor.command
{
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridColumn;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class RemoveFormGridColumnCommand extends Command
	{
		
		public var gridCol:FormGridColumn;
		private var oldGridCol:FormGridColumn;
		private var oldIndex:int;
		
		public function RemoveFormGridColumnCommand(gridCol:FormGridColumn)
		{
			this.gridCol = gridCol;
		}

		public override function execute():void{
			this.oldGridCol = this.gridCol;
			this.oldIndex = this.gridCol.gridLayout.getColumnIndex(this.gridCol);
			
			this.gridCol.gridLayout.removeColumn(this.gridCol);
		}

		public override function undo():void{
			this.oldGridCol.gridLayout.addColumn(this.oldGridCol, this.oldIndex);
		}	
		
		public override function redo():void{
			this.oldGridCol.gridLayout.removeColumn(this.gridCol);
		}
		public override function getLabel():String{
			return "Remove FormGridColumn(" + gridCol + ") in FormGridLayout(" + gridCol.gridLayout + ")";
		}
	}
}