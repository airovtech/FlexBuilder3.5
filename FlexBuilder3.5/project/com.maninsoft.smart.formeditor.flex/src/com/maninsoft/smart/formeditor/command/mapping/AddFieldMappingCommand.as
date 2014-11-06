package com.maninsoft.smart.formeditor.command.mapping
{
	import com.maninsoft.smart.formeditor.model.Mapping;
	import com.maninsoft.smart.formeditor.model.Mappings;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class AddFieldMappingCommand extends Command
	{
		public var fieldMappings:Mappings;
		public var fieldMapping:Mapping;
		public var isIn:Boolean;
		public var index:int;
		
		public function AddFieldMappingCommand(fieldMappings:Mappings,  fieldMapping:Mapping, isIn:Boolean, index:int = -1)
		{
			this.fieldMappings = fieldMappings;
			this.fieldMapping = fieldMapping;
			this.isIn = isIn;
			this.index = index;
		}

		public override function execute():void{
			if(this.isIn){
				if(this.index == -1){
					this.fieldMappings.addInMapping(this.fieldMapping);
				}else{
					this.fieldMappings.addInMapping(this.fieldMapping, this.index);
				}
			}else{
				if(this.index == -1){
					this.fieldMappings.addOutMapping(this.fieldMapping);
				}else{
					this.fieldMappings.addOutMapping(this.fieldMapping, this.index);
				}
			}
		}

		public override function undo():void{
			if(this.isIn){
				this.fieldMappings.removeInMapping(this.fieldMapping);
			}else{
				this.fieldMappings.removeOutMapping(this.fieldMapping);
			}
			
		}	
		
		public override function getLabel():String{
			return "Add FieldMapping(" + fieldMapping.name + ") to FieldMappings at index(" + index + ")";
		}	
	}
}