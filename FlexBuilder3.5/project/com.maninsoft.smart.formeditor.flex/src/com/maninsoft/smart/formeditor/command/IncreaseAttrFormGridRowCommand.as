package com.maninsoft.smart.formeditor.command
{
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridRow;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class IncreaseAttrFormGridRowCommand extends Command
	{
		public var gridRow:FormGridRow;
		public var type:String;
		public var value:Number;
		
		public function IncreaseAttrFormGridItemCommand(gridRow:FormGridRow, type:String, value:Number)
		{
			this.gridRow = gridRow;
			this.type = type;
			this.value = value;
		}

		public override function execute():void{
			if(this.gridRow[type] as Number){
				this.gridRow[type] = (this.gridRow[type] as Number) + value;
			}
		}

		public override function undo():void{
			if(this.gridRow[type] as Number){
				this.gridRow[type] = (this.gridRow[type] as Number) - value;
			}
		}	
		
		public override function getLabel():String{
			return "Increase " + type + " values (" + value + ") in FormGridRow(" + gridRow + ")";
		}	

	}
}