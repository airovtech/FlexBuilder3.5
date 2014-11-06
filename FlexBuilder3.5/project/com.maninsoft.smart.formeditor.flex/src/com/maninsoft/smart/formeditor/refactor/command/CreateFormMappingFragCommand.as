package com.maninsoft.smart.formeditor.refactor.command
{
	import com.maninsoft.smart.formeditor.model.mapping.FormMapping;
	import com.maninsoft.smart.formeditor.model.mapping.FormMappingFrag;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class CreateFormMappingFragCommand extends Command
	{
		public var mapping:FormMapping;
		
		public var mappingFrag:FormMappingFrag;
		
		public var index:int = -1;
	
		public function CreateFormMappingFragCommand(mapping:FormMapping, mappingFrag:FormMappingFrag, index:int = -1, label:String = "") {
			super(label);
			
			this.mapping = mapping;
			this.mappingFrag = mappingFrag;
			
			this.mappingFrag.mapping = this.mapping;
			
			this.index = index;
		}
	
		public override function execute():void{			
			mapping.addFragment(this.mappingFrag, this.index);
		}

		public override function undo():void{
			mapping.removeFragment(this.mappingFrag);
		}	
		public override function getLabel():String{
			return "Create FormMappingFrag(" + mappingFrag.getLabel() + ") in FormMapping(" + mapping.id + ")";
		}	
	}
}