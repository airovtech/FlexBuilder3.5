////////////////////////////////////////////////////////////////////////////////
//  Participant.as
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
	 * Participant
	 */
	public class Participant extends XPDLElement {
		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		public var id: String;
		public var name: String;
		public var participantType: String;
		public var description: String;		


		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function Participant() {
			super();
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function doRead(src: XML): void {
			id		= src.@Id;
			name	= src.@Name;
			
			participantType = src._ns::ParticipantType.@Type;
			description		= src._ns::Description;
		}
		
		override protected function doWrite(dst: XML): void {
			dst.@Id		= id;
			dst.@Name	= name;
			
			dst._ns::ParticipantType.@Type 	= participantType;
			dst._ns::Description 			= description
		}
	}
}