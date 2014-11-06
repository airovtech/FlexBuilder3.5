
package com.maninsoft.smart.modeler.xpdl.model.process
{
	
	/**
	 * XPDL Application
	 */
	public class ExtApplication	extends XPDLElement{
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		//----------------------------------------------------------------------
		// XPDL Properties
		//----------------------------------------------------------------------
		
		public var id: String;
		public var name: String;
		public var url: String;
		public var editMethod: String;
		public var viewMethod: String;
		public var description: String;
		public var formalParameters: Array = [];
		public var externalReference: ExternalReference = new ExternalReference(this);
		public var owners:Array = [];

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function ExtApplication() {
			super();
		}

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function doRead(src: XML): void {
			id			= src.@Id;
			name		= src.@Name;
			url			= src.@Url;
			editMethod	= src.@EditMethod;
			viewMethod	= src.@ViewMethod;
			description	= src.@Description;

			for each (var f: XML in src._ns::FormalParameters._ns::FormalParameter) {
				var param: FormalParameter = new FormalParameter(this);
				param.read(f);
				formalParameters.push(param);
			}
			
			if (src._ns::ExternalReference.length() > 0)
				externalReference.read(src._ns::ExternalReference[0]);
			
		}
		
		override protected function doWrite(dst: XML): void {
			dst.@Id			= id;
			dst.@Name		= name;
			dst.@Url		= url;
			dst.@EditMethod	= editMethod;
			dst.@ViewMethod	= viewMethod;
			dst.@Description= description;
			
			for (var i:int = 0; i < formalParameters.length; i++) {
				dst._ns::FormalParameters._ns::FormalParameter[i] = "";
				FormalParameter(formalParameters[i]).write(dst._ns::FormalParameters._ns::FormalParameter[i]);
			}			
			if(formalParameters.length==0){
				dst._ns::ExternalReference = "";
				externalReference.write(dst._ns::ExternalReference[0]);
			}
		}
	}
}