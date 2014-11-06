////////////////////////////////////////////////////////////////////////////////
//  XPDLReader.as
//  2008.01.09, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.parser
{
	import com.maninsoft.smart.modeler.model.Diagram;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.model.process.XPDLElement;
	import com.maninsoft.smart.modeler.xpdl.model.process.XPDLPackage;
	
	/**
	 * xpdl parser
	 */
	public class XPDLReader {
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		public function XPDLReader() {
			super();
		}


		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		
		public function parse(source: XML): Diagram {
			XPDLElement._ns = source.namespace("xpdl");

			var xpdlPackage: XPDLPackage = new XPDLPackage();
			xpdlPackage.read(source);
			
			//trace("parse...\r\n" + xpdlPackage.toString());
			
			var dgm: XPDLDiagram = new XPDLDiagram();
			dgm.xpdlPackage = xpdlPackage;
			
			return dgm;
		}
	}
}

