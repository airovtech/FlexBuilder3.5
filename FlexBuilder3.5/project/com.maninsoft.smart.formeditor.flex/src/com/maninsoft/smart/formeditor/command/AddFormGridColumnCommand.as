package com.maninsoft.smart.formeditor.command
{
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridColumn;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridLayout;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class AddFormGridColumnCommand extends Command
	{
		public var gridLayout:FormGridLayout;
		public var gridCol:FormGridColumn;
		public var index:int;
		
		public function AddFormGridColumnCommand(gridLayout:FormGridLayout, gridCol:FormGridColumn, index:int = -1)
		{
			this.gridLayout = gridLayout;
			this.gridCol = gridCol;
			this.index = index;
		}

		public override function execute():void{
			if(this.index == -1){
				this.gridLayout.addColumn(this.gridCol);
			}else{
				this.gridLayout.addColumn(this.gridCol, this.index);
			}
		}

		public override function undo():void{
			this.gridLayout.removeColumn(this.gridCol);
		}	
		
		public override function getLabel():String{
			return "Add FormGridColumn(" + gridCol + ") to FormGriLayout(" + gridLayout + ") at index(" + index + ")";
		}	
	}
}