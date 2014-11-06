package com.maninsoft.smart.formeditor.command
{
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridRow;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class UpdateFormGridRowCommand extends Command
	{
		public var gridRow:FormGridRow;
		public var type:String;
		public var value:Object;
		
		public var oldValue:Object;
		
		public function UpdateFormGridRowCommand(gridRow:FormGridRow, type:String, value:Object)
		{
			this.gridRow = gridRow;
			this.type = type;
			this.value = value;
		}

		public override function execute():void{
			this.oldValue = this.gridRow[type];
			this.gridRow[type] = this.value;
		}

		public override function undo():void{
			this.gridRow[type] = this.oldValue;
		}	
		
		public override function redo():void{
			this.gridRow[type] = this.value;
		}
		public override function getLabel():String{
			return "Update " + type + " values (" + value + ") in FormGridRow(" + gridRow + ")";
		}	
	}
}