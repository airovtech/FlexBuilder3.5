////////////////////////////////////////////////////////////////////////////////
//  LinkCreationRequest.as
//  2007.12.26, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.request
{
	import com.maninsoft.smart.modeler.model.Node;
	
	/**
	 * 링크 생성 요청
	 */
	public class LinkCreationRequest extends Request {

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _linkType: String;
		private var _source: Node;
		private var _target: Node;
		private var _sourceAnchor: Number;
		private var _targetAnchor: Number;
		private var _connectType: String;


		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function LinkCreationRequest(linkType: String, source: Node, target: Node, 
											  sourceAnchor: Number, targetAnchor: Number, connectType: String) {
			super("CREATE_LINK_REQUEST");
			
			_linkType = linkType;
			_source = source;
			_target = target;
			_sourceAnchor = sourceAnchor;
			_targetAnchor = targetAnchor;
			_connectType = connectType;
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * linkType
		 */
		public function get linkType(): String {
			return _linkType;
		}
		
		public function set linkType(value: String): void {
			_linkType = value;
		}

		/**
		 * source
		 */
		public function get source(): Node {
			return _source;
		}
		
		public function set source(value: Node): void {
			_source = value;
		}
		
		/**
		 * target
		 */
		public function get target(): Node {
			return _target;
		}
		
		public function set target(value: Node): void {
			_target = value;
		}
		
		/**
		 * sourceAnchor
		 */
		public function get sourceAnchor(): Number {
			return _sourceAnchor;
		}
		
		public function set sourceAnchor(value: Number): void {
			_sourceAnchor = value;
		}
		
		/**
		 * targetAnchor
		 */
		public function get targetAnchor(): Number {
			return _targetAnchor;
		}
		
		public function set targetAnchor(value: Number): void {
			_targetAnchor = value;
		}

		/**
		 * connectType
		 */
		public function get connectType(): String {
			return _connectType;
		}
		
		public function set connectType(value: String): void {
			_connectType = value;
		}
	}
}