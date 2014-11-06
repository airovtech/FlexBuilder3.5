////////////////////////////////////////////////////////////////////////////////
//  DataObject.as
//  2007.12.20, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model
{
	import com.maninsoft.smart.modeler.xpdl.model.base.Artifact;
	import com.maninsoft.smart.modeler.xpdl.server.Server;
	
	/**
	 * XPDL DataObject artifact
	 */
	public class Block extends Artifact {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------


		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/**
		 * Construtor 
		 */
		public function Block() {
			super();
		}


		//----------------------------------------------------------------------
		// Overriend methods
		//----------------------------------------------------------------------

		override protected function doWrite(dst: XML): void {
			super.doWrite(dst);
			
			dst.@ArtifactType = "Block";
			
			dst._ns::Block = "";
			var xml: XML = dst._ns::Block[0];
			
			xml.@Id = id;
			xml.@Name = name;
		}

		override protected function doRead(src: XML): void {
			super.doRead(src);
		}
	}
}