package com.maninsoft.smart.formeditor.command.mapping
{
	import com.maninsoft.smart.formeditor.model.FormLink;
	import com.maninsoft.smart.formeditor.model.FormLinks;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class AddFormMappingFormCommand extends Command
	{
		public var formMappingForms:FormLinks;
		public var formMappingForm:FormLink;
		public var index:int;
		
		public function AddFormMappingFormCommand(formMappingForms:FormLinks, formMappingForm:FormLink, index:int = -1)
		{
			this.formMappingForms = formMappingForms;
			this.formMappingForm = formMappingForm;
			this.index = index;
		}

		public override function execute():void{
			if(this.index == -1){
				this.formMappingForms.addFormLink(this.formMappingForm);
			}else{
				this.formMappingForms.addFormLink(this.formMappingForm, this.index);
			}
		}

		public override function undo():void{
			this.formMappingForms.removeFormLink(this.formMappingForm);
		}	
		
		public override function getLabel():String{
			return "Add FormLink(" + formMappingForm.id + " : " + formMappingForm.name + ") to FormLinks at index(" + index + ")";
		}	
	}
}