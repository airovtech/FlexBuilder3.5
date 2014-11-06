package com.maninsoft.smart.formeditor.command
{
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridLayout;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridRow;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class AddFormGridRowCommand extends Command
	{
		public var gridLayout:FormGridLayout;
		public var gridRow:FormGridRow;
		public var index:int;
		
		public function AddFormGridRowCommand(gridLayout:FormGridLayout, gridRow:FormGridRow, index:int = -1)
		{
			this.gridLayout = gridLayout;
			this.gridRow = gridRow;
			this.index = index;
		}

		public override function execute():void{
			if(this.index == -1){
				this.gridLayout.addRow(this.gridRow);
			}else{
				this.gridLayout.addRow(this.gridRow, this.index);
			}
		}

		public override function undo():void{
			this.gridLayout.removeRow(this.gridRow);
		}	
		
		public override function getLabel():String{
			return "Add FormGridRow(" + gridRow + ") to FormGriLayout(" + gridLayout + ") at index(" + index + ")";
		}	
	}
}