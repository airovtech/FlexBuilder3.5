package com.maninsoft.smart.formeditor.model
{
	import com.maninsoft.smart.formeditor.model.type.FormatTypes;
	

	public class SystemServiceParameter{
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		public var serviceId: String;
		public var id: String;
		public var name: String;
		public var parentId: String;
		public var elementName: String;
		public var elementType: String;
		public var icon: Class = FormatTypes.getIcon(FormatTypes.textInput.type);


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function SystemServiceParameter() {
			super();
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		public function get label():String{
			return name;
		}
		
		public function get value():String{
			return id;
		}
	}
}