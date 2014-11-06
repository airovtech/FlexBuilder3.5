package com.maninsoft.smart.formeditor.model
{
	public class ServiceLink
	{
		public var parent:ServiceLinks;
		
		public var id:String;
		public var name:String;
		public var targetServiceId:String;
		private var _actualParams:ActualParameters;
		
		public function ServiceLink(parent:ServiceLinks){
			super();
			this.parent = parent;
			this.id = this.parent.form.generateEntityId();
			this.actualParams = new ActualParameters();
		}
		
		public function get actualParams():ActualParameters {
			return _actualParams;
		}
		public function set actualParams(actualParams:ActualParameters):void {
			this._actualParams = actualParams;
			this._actualParams.serviceLink = this;
		}
		
		public function clone():ServiceLink {
			return ServiceLink(parseXML(parent, this.toXML()));
		}
		public function toXML():XML{
			var serviceLinkXML:XML = <mappingService/>;
			
			serviceLinkXML.@id = id;
			serviceLinkXML.@name = name;
			serviceLinkXML.@targetServiceId = targetServiceId;
			
			serviceLinkXML.appendChild(actualParams.toXML());
				
			return serviceLinkXML;
		}
		public static function parseXML(parent:ServiceLinks, serviceLinkXML:XML):ServiceLink{
			var serviceLink:ServiceLink = new ServiceLink(parent);

			serviceLink.id = serviceLinkXML.@id;
			serviceLink.name = serviceLinkXML.@name;
			serviceLink.targetServiceId = serviceLinkXML.@targetServiceId;
			
			serviceLink.actualParams = ActualParameters.parseXML(serviceLinkXML.ActualParameters[0]);
			
			return serviceLink;
		}	
	}
}