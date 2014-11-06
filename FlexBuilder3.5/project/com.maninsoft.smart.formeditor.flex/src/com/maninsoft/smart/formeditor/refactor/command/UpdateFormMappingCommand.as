package com.maninsoft.smart.formeditor.refactor.command
{
	import com.maninsoft.smart.formeditor.model.mapping.FormMapping;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class UpdateFormMappingCommand extends Command
	{
		public var mapping:FormMapping;
		
		public var newValue:Object;
		private var oldValue:Object;
		
		public var type:String;
		
		public function UpdateFormMappingCommand(mapping:FormMapping, newValue:Object, type:String, label:String) {
			super(label);
			
			this.mapping = mapping;
			
			this.newValue = newValue;
			this.type = type;
		}
		
		public override function execute():void{
			oldValue = this.mapping[type];				
			this.mapping[type] = newValue;
		}

		public override function undo():void{			
			this.mapping[type] = oldValue;
		}
		
		public override function redo():void{	
			this.mapping[type] = newValue;
		}
		public override function getLabel():String{
			return "Update " + type + " values (" + newValue + ") in FormMapping(" + mapping.id + ")";
		}
	}
}