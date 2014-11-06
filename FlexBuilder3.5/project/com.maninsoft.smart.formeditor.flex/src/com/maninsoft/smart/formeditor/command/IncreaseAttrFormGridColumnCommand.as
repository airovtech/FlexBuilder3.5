package com.maninsoft.smart.formeditor.command
{
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridColumn;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class IncreaseAttrFormGridColumnCommand extends Command
	{
		public var gridCol:FormGridColumn;
		public var type:String;
		public var value:Number;
		
		public function IncreaseAttrFormGridColumnCommand(gridCol:FormGridColumn, type:String, value:Number)
		{
			this.gridCol = gridCol;
			this.type = type;
			this.value = value;
		}

		public override function execute():void{
			if(this.gridCol[type] as Number){
				this.gridCol[type] = (this.gridCol[type] as Number) + value;
			}
		}

		public override function undo():void{
			if(this.gridCol[type] as Number){
				this.gridCol[type] = (this.gridCol[type] as Number) - value;
			}
		}	
		
		public override function getLabel():String{
			return "Increase " + type + " values (" + value + ") in FormGridColumn(" + gridCol + ")";
		}	

	}
}