package com.maninsoft.smart.formeditor.model
{
	import com.maninsoft.smart.common.util.SmartUtil;
	
	import mx.collections.ArrayCollection;
	
	public class ServiceLinks
	{
		public var form:FormDocument;
		
		public function ServiceLinks(form:FormDocument)
		{
			this.form = form;
		}
		
		[Bindable]
		public var serviceLinks:ArrayCollection = new ArrayCollection();
		
		public function addServiceLink(serviceLink: ServiceLink, index:int = -1):void {
			if (serviceLinks == null) {
				serviceLinks = new ArrayCollection();
			} else if (this.serviceLinks.contains(serviceLink)) {
				return;
			}
			serviceLink.parent = this;
			if(index == -1) {
				this.serviceLinks.addItem(serviceLink);
			} else {
				this.serviceLinks.addItemAt(serviceLink, index);
			}
		}

		public function removeServiceLink(serviceLink:ServiceLink):void {
			if (SmartUtil.isEmpty(this.serviceLinks) || !this.serviceLinks.contains(serviceLink))
				return;
			this.serviceLinks.removeItemAt(this.serviceLinks.getItemIndex(serviceLink));
		}
		
		/**
		 * XML로 바꾸기
		 */
		public function toXML():XML{
			var serviceLinksXML:XML = <mappingServices/>;
			for each (var serviceLink:ServiceLink in this.serviceLinks)
				serviceLinksXML.appendChild(serviceLink.toXML());
			return serviceLinksXML;
		}	
		/**
		 * XML을 객체로 파싱
		 */ 
		public static function parseXML(form:FormDocument, serviceLinksXML:XML):ServiceLinks{
			var serviceMappings:ServiceLinks = new ServiceLinks(form);
			for each (var serviceLinkXml:XML in serviceLinksXML.mappingService)
			    serviceMappings.addServiceLink(ServiceLink.parseXML(serviceMappings, serviceLinkXml));
			return serviceMappings;
		}	
	}
}