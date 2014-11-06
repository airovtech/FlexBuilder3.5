package com.maninsoft.smart.modeler.xpdl.model.process
{
	import com.maninsoft.smart.modeler.xpdl.server.Server;
	
	/**
	 * XPDL Script
	 */
	public class ExternalReference extends XPDLElement {
				
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		public var _owner: Object;
		
		public var location: String;
		public var nameSpace: String;
		public var port: String;
		public var xref: String;


		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function ExternalReference(owner: Object) {
			super();
			_owner = owner;
		}

		public function get owner(): Object {
			return _owner;
		}

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function doRead(src: XML): void {
			location	= src.@Location;
			nameSpace	= src.@Namespace;
			port		= src.@Port;
			xref		= src.@Xref;
		}
		
		override protected function doWrite(dst: XML): void {
			dst.@Location	= location;	
			dst.@Namespace	= nameSpace;
			dst.@Port		= port; 
			dst.@Xref		= xref; 
		}
	}
}