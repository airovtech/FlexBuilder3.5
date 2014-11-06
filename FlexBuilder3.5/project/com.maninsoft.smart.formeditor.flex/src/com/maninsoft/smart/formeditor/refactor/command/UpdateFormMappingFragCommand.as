package com.maninsoft.smart.formeditor.refactor.command
{
	import com.maninsoft.smart.formeditor.model.mapping.FormMappingFrag;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class UpdateFormMappingFragCommand extends Command
	{
		public var mappingFrag:FormMappingFrag;
		
		public var newValue:Object;
		private var oldValue:Object;
		
		public var type:String;
		
		public function UpdateFormMappingFragCommand(mappingFrag:FormMappingFrag, newValue:Object, type:String, label:String) {
			super(label);
			
			this.mappingFrag = mappingFrag;
			
			this.newValue = newValue;
			this.type = type;
		}
		
		public override function execute():void{
			oldValue = this.mappingFrag[type];				
			this.mappingFrag[type] = newValue;
		}

		public override function undo():void{			
			this.mappingFrag[type] = oldValue;
		}
		
		public override function redo():void{	
			this.mappingFrag[type] = newValue;
		}
		public override function getLabel():String{
			return "Update " + type + " values (" + newValue + ") in FormMappingFra(" + mappingFrag.getLabel() + ")";
		}
	}
}