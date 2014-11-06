package com.maninsoft.smart.formeditor.command
{
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class UpdateFormInfoCommand extends Command
	{
		public var target:Object;
		public var type:String;
		public var value:Object;
		
		public var oldValue:Object;
		
		public function UpdateFormInfoCommand(target:Object, type:String, value:Object)
		{
			this.target = target;
			this.type = type;
			this.value = value;
		}

		public override function execute():void{
			this.oldValue = this.target[type];
			this.target[type] = this.value;
		}

		public override function undo():void{
			this.target[type] = this.oldValue;
		}	
		
		public override function redo():void{
			this.target[type] = this.value;
		}
		public override function getLabel():String{
			return "Update " + type + " values (" + value + ") in Target(" + target + ")";
		}	
	}
}