////////////////////////////////////////////////////////////////////////////////
//  Script.as
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
	 * XPDL Script
	 */
	public class Script extends XPDLElement {
		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		public var type: String;
		public var version: String;
		public var grammar: String;


		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function Script() {
			super();
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function doRead(src: XML): void {
			type	= src.@Type;
			version	= src.@Version;
			grammar	= src.@Grammar;
		}
		
		override protected function doWrite(dst: XML): void {
			dst.@Type		= type;	
			dst.@Version	= version; 
			dst.@Grammar	= grammar; 
		}
	}
}