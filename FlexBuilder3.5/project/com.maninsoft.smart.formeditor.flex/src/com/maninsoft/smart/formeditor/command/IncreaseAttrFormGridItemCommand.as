package com.maninsoft.smart.formeditor.command
{
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridCell;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class IncreaseAttrFormGridItemCommand extends Command
	{
		public var gridItem:FormGridCell;
		public var type:String;
		public var value:Number;
		
		public function IncreaseAttrFormGridItemCommand(gridItem:FormGridCell, type:String, value:Number)
		{
			this.gridItem = gridItem;
			this.type = type;
			this.value = value;
		}

		public override function execute():void{
			if(this.gridItem[type] as Number){
				this.gridItem[type] = (this.gridItem[type] as Number) + value;
			}
		}

		public override function undo():void{
			if(this.gridItem[type] as Number){
				this.gridItem[type] = (this.gridItem[type] as Number) - value;
			}
		}	
		
		public override function getLabel():String{
			return "Increase " + type + " values (" + value + ") in FormGridItem(" + gridItem + ")";
		}	

	}
}