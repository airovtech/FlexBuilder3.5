package com.maninsoft.smart.formeditor.command.mapping
{
	import com.maninsoft.smart.formeditor.model.FormLink;
	import com.maninsoft.smart.formeditor.model.FormLinks;
	import com.maninsoft.smart.formeditor.model.ServiceLink;
	import com.maninsoft.smart.formeditor.model.ServiceLinks;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class AddServiceMappingFormCommand extends Command
	{
		public var serviceMappingForms:ServiceLinks;
		public var serviceMappingForm:ServiceLink;
		public var index:int;
		
		public function AddServiceMappingFormCommand(serviceMappingForms:ServiceLinks, serviceMappingForm:ServiceLink, index:int = -1)
		{
			this.serviceMappingForms = serviceMappingForms;
			this.serviceMappingForm = serviceMappingForm;
			this.index = index;
		}

		public override function execute():void{
			if(this.index == -1){
				this.serviceMappingForms.addServiceLink(this.serviceMappingForm);
			}else{
				this.serviceMappingForms.addServiceLink(this.serviceMappingForm, this.index);
			}
		}

		public override function undo():void{
			this.serviceMappingForms.removeServiceLink(this.serviceMappingForm);
		}	
		
		public override function getLabel():String{
			return "Add ServiceLink(" + serviceMappingForm.id + " : " + serviceMappingForm.name + ") to ServiceLinks at index(" + index + ")";
		}	
	}
}