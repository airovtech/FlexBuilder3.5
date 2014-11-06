////////////////////////////////////////////////////////////////////////////////
//  TransitionRestriction.as
//  2008.01.12, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model.process
{
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLLink;
	import com.maninsoft.smart.modeler.xpdl.server.Server;
	
	/**
	 * XPDL TransitionRestriction
	 */
	public class TransitionRestriction extends XPDLElement {

		//----------------------------------------------------------------------
		// Class consts
		//----------------------------------------------------------------------
		
		protected const EMPTY_ARRAY: Array = [];
		

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _owner: Activity;
		
		//------------------------------
		// XPDL Properties
		//------------------------------
		
		/** Join.Type */
		public var joinType: String;
		/** Join.IncomingCondition */
		public var incomingCondition: String;
		
		/** Split.Type */
		public var splitType: String;
		/** Split.OutgoingCondition */
		public var outgoingCondition: String;
		/** Split.TransitionRefs */
		public var transitionRefs: Array = EMPTY_ARRAY;


		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function TransitionRestriction(owner: Activity) {
			super();
			
			_owner = owner;
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		public function get owner(): Activity {
			return _owner;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function doRead(src: XML): void {
			if (src._ns::Join.length() > 0)
				readJoin(src._ns::Join[0]);

			if (src._ns::Split.length() > 0)
				readSplit(src._ns::Split[0]);
		}
		
		override protected function doWrite(dst: XML): void {
			if (joinType) {
				dst._ns::Join = "";
				writeJoin(dst._ns::Join[0]);
			}

			if (splitType) {
				dst._ns::Split = "";
				writeSplit(dst._ns::Split[0]);
			}
		}
		
		private function readJoin(xml: XML): void {
			joinType = xml.@Type;
			incomingCondition = xml.@IncomingCondition;
		}
		
		private function writeJoin(xml: XML): void {
			xml.@Type = joinType;
			xml.@IncomingCondition = incomingCondition;
		}
		
		private function readSplit(xml: XML): void {
			splitType = xml.@Type;
			outgoingCondition = xml.@OutgoingCondition;
		}
		
		private function writeSplit(xml: XML): void {
			xml.@Type = splitType;
			xml.@OutgoingCondition = outgoingCondition;
			
			var refs: Array = transitionRefs;
			
			if (refs && refs.length > 0) {
				xml._ns::TransitionRefs = "";
				xml = xml._ns::TransitionRefs[0];
				
				for (var i: int = 0; i < refs.length; i++) {
					var ref: XPDLLink = refs[i] as XPDLLink;
					xml._ns::TransitionRef[i] = "";
					xml._ns::TransitionRef[i].@Id = ref.id;
					xml._ns::TransitionRef[i].@Name = ref.name;	
				}
			}
		}
	}
}