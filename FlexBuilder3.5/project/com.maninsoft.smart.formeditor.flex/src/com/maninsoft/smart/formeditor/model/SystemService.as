
package com.maninsoft.smart.formeditor.model
{
	import mx.resources.ResourceManager;
	

	public class SystemService{
		
		//----------------------------------------------------------------------
		// Class consts
		//----------------------------------------------------------------------
		
		public static const EMPTY_SYSTEM_SERVICE: String = "EMPTYSERVICE";
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		public var id: String;
		public var name: String;
		public var wsdlUli: String;
		public var port: String;
		public var operation: String;
		public var messageIn: Array;
		public var messageOut: Array;
		public var description: String;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function SystemService() {
			super();
		}

		
		
		//----------------------------------------------------------------------
		// IPropertySource
		//----------------------------------------------------------------------

		public function get displayName(): String {
			return ResourceManager.getInstance().getString("ProcessEditorETC", "systemServiceText");
		}

		public function get label(): String {
			return name;
		}
		
		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		public function clone():SystemService{
			var systemService:SystemService = new SystemService();
			systemService.id = this.id;			
			systemService.name = this.name;			
			systemService.wsdlUli = this.wsdlUli;			
			systemService.port = this.port;			
			systemService.operation = this.operation;			
			systemService.messageIn = this.messageIn;			
			systemService.messageOut = this.messageOut;			
			systemService.description = this.description;			
			return systemService;
		}
	}
}