package com.maninsoft.smart.formeditor.command
{
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridCell;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class UpdateFormGridItemCommand extends Command
	{
		public var gridItem:FormGridCell;
		public var type:String;
		public var value:Object;
		
		public var oldValue:Object;
		
		public function UpdateFormGridItemCommand(gridItem:FormGridCell, type:String, value:Object)
		{
			this.gridItem = gridItem;
			this.type = type;
			this.value = value;
		}

		public override function execute():void{
			this.oldValue = this.gridItem[type];
			this.gridItem[type] = this.value;
		}

		public override function undo():void{
			this.gridItem[type] = this.oldValue;
		}	
		
		public override function redo():void{
			this.gridItem[type] = this.value;
		}
		public override function getLabel():String{
			return "Update " + type + " values (" + value + ") in FormGridItem(" + gridItem + ")";
		}	
	}
}