package com.maninsoft.smart.formeditor.model
{
	import mx.collections.ArrayCollection;
	
	import com.maninsoft.smart.common.util.SmartUtil;
	
	public class FormLinks
	{
		public var form:FormDocument;
		
		public function FormLinks(form:FormDocument)
		{
			this.form = form;
		}
		
		[Bindable]
		public var formLinks:ArrayCollection = new ArrayCollection();
		
		public function addFormLink(formLink:FormLink, index:int = -1):void {
			if (formLinks == null) {
				formLinks = new ArrayCollection();
			} else if (this.formLinks.contains(formLink)) {
				return;
			}
			formLink.parent = this;
			if(index == -1) {
				this.formLinks.addItem(formLink);
			} else {
				this.formLinks.addItemAt(formLink, index);
			}
		}

		public function removeFormLink(formLink:FormLink):void {
			if (SmartUtil.isEmpty(this.formLinks) || !this.formLinks.contains(formLink))
				return;
			this.formLinks.removeItemAt(this.formLinks.getItemIndex(formLink));
		}
		
		/**
		 * XML로 바꾸기
		 */
		public function toXML():XML{
			var formLinksXML:XML = <mappingForms/>;
			for each (var formLink:FormLink in this.formLinks)
				formLinksXML.appendChild(formLink.toXML());
			return formLinksXML;
		}	
		/**
		 * XML을 객체로 파싱
		 */ 
		public static function parseXML(form:FormDocument, formLinksXML:XML):FormLinks{
			var formMappingForms:FormLinks = new FormLinks(form);
			for each (var formLinkXml:XML in formLinksXML.mappingForm)
			    formMappingForms.addFormLink(FormLink.parseXML(formMappingForms, formLinkXml));
			return formMappingForms;
		}	
	}
}