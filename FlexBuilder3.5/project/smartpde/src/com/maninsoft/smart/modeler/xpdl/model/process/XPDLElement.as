////////////////////////////////////////////////////////////////////////////////
//  XPDLPackage.as
//  2008.01.09, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model.process
{
	import com.maninsoft.smart.modeler.common.ObjectBase;
	import com.maninsoft.smart.modeler.xpdl.model.IXPDLElement;
	
	/**
	 * base XPDLElement
	 */
	public class XPDLElement extends ObjectBase implements IXPDLElement	{
		
		//----------------------------------------------------------------------
		// Class Constants
		//----------------------------------------------------------------------
		
		protected static const EMPTY_STRING: String = "";
		
		
		//----------------------------------------------------------------------
		// Class variables
		//----------------------------------------------------------------------

		public static var _ns: Namespace = new Namespace("xpdl");


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		public function XPDLElement() {
			super();
		}


		//----------------------------------------------------------------------
		// IXPDLElement
		//----------------------------------------------------------------------
		
		public function read(xml: XML): void {
			doRead(xml);
		}
		
		public function write(xml: XML): void {
			doWrite(xml);
		}	


		//----------------------------------------------------------------------
		// Virtual methods
		//----------------------------------------------------------------------

		protected function doRead(src: XML): void {
		}

		protected function doWrite(dst: XML): void {
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------


	}
}