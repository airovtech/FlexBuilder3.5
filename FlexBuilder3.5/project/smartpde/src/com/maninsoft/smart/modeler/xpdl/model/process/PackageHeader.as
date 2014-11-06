////////////////////////////////////////////////////////////////////////////////
//  PackageHeader.as
//  2008.01.09, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model.process
{
	import com.maninsoft.smart.modeler.xpdl.server.Server;
	
	/**
	 * XPDL PackageHeader
	 */
	public class PackageHeader	extends XPDLElement {
		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		public var xpdlVersion: String;
		public var vendor: String;
		public var created: String;
		public var description: String;


		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function PackageHeader() {
			super();
		}
	

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function doRead(src: XML): void {
			xpdlVersion = src._ns::XPDLVersion;
			vendor 		= src._ns::Vendor;
			created 	= src._ns::Created;
			description	= src._ns::Description;
		}
		
		override protected function doWrite(dst: XML): void {
			dst._ns::XPDLVersion 	= xpdlVersion;
			dst._ns::Vendor 		= vendor;
			dst._ns::Created		= created;
			dst._ns::Description	= description;	 
		}
	}
}