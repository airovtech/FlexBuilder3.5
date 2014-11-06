////////////////////////////////////////////////////////////////////////////////
//  ProcessHeader.as
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
	 * XPDL ProcessHeader
	 */
	public class ProcessHeader	extends XPDLElement {
		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		public var durationUnit: String;
		public var created: String;
		public var description: String;


		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function ProcessHeader() {
			super();
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function doRead(src: XML): void {
			durationUnit	= src.@DurationUnit;
			
			created			= src._ns::Created;
			description		= src._ns::Desription;			
		}
		
		override protected function doWrite(dst: XML): void {
			dst.@DurationUnit 		= durationUnit;
			
			dst._ns::Created 		= created;
			dst._ns::Description 	= description;	
		}
	}
}