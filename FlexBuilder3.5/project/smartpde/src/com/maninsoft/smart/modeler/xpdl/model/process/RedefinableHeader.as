////////////////////////////////////////////////////////////////////////////////
//  RedefinableHeader.as
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
	 * XPDL RedefinableHeader
	 */
	public class RedefinableHeader	extends XPDLElement {
		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		public var author: String;
		public var version: String;
		public var codepage: String;
		public var countrykey: String;


		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function RedefinableHeader() {
			super();
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function doRead(src: XML): void {
			author 		= src._ns::Author;
			version		= src._ns::Version;
			codepage	= src._ns::Codepage;
			countrykey	= src._ns::Countrykey;
		}
		
		override protected function doWrite(dst: XML): void {
			dst._ns::Author 	= author;
			dst._ns::Version 	= version;
			dst._ns::Codepage 	= codepage;
			dst._ns::Countrykey = countrykey;
		}
	}
}