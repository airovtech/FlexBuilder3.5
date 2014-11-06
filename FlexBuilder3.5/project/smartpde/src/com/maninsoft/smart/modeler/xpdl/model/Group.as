////////////////////////////////////////////////////////////////////////////////
//  Group.as
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
	 * XPDL Group artifact
	 */
	public class Group extends Artifact {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------


		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/**
		 * Construtor 
		 */
		public function Group() {
			super();
			
			name = "Group";
		}


		//----------------------------------------------------------------------
		// Overriend methods
		//----------------------------------------------------------------------

		override protected function doWrite(dst: XML): void {
			super.doWrite(dst);
			
			dst.@ArtifactType = "Group";
		}

		override protected function doRead(src: XML): void {
			super.doRead(src);
		}
	}
}