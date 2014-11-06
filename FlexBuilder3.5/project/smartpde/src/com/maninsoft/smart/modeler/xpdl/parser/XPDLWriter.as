////////////////////////////////////////////////////////////////////////////////
//  XPDLWriter.as
//  2008.01.09, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.parser
{
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.model.process.XPDLElement;
	import com.maninsoft.smart.modeler.xpdl.model.process.XPDLPackage;
	
	/**
	 * XPDL serializer
	 */
	public class XPDLWriter {
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		public function XPDLWriter() {
			super();
		}


		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		
		public function serialize(dgm: XPDLDiagram): XML {
			var pack: XPDLPackage = dgm.xpdlPackage;
			var xml: XML = <xpdl:Package xmlns:xpdl="http://www.wfmc.org/2004/XPDL2.0alpha"/>;
						
			pack.process.activities = dgm.activities;
			pack.process.transitions = dgm.transitions;
			pack.artifacts = dgm.artifacts;
			
			XPDLElement._ns = xml.namespace();
			pack.write(xml);
			
			trace("serialize...\r\n" + xml.toXMLString());
			
			return xml;
		}
	}
}