////////////////////////////////////////////////////////////////////////////////
//  CreateNodeRequestEvent.as
//  2008.01.02, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.editor.events
{
	import com.maninsoft.smart.modeler.controller.NodeController;
	
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**
	 * CreationTool에 의해 발생되는 노드 생성 요청 이벤트
	 */
	public class CreateNodeRequestEvent extends Event {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _parent: Object;
		private var _creationType: String;
		private var _creationController: NodeController;
		private var _creationRect: Rectangle;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function CreateNodeRequestEvent(parent: Object, creationType: String, creationController: NodeController, creationRect: Rectangle) {
			super("createNodeRequest");
			
			_parent = parent;
			_creationType = creationType;
			_creationController = creationController;
			_creationRect = creationRect.clone();
		}
		
		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * parent
		 */
		public function get parent(): Object {
			return _parent;
		}
		
		public function set parent(value: Object): void {
			_parent = value;
		}
		
		/**
		 * creationType
		 */
		public function get creationType(): String {
			return _creationType;
		}
		
		public function set creationType(value: String): void {
			_creationType = value;
		}
		
		public function get creationController(): NodeController {
			return _creationController;
		}
		
		public function set creationController(value: NodeController): void {
			_creationController = value;
		}
		
		/**
		 * rect
		 */
		public function get creationRect(): Rectangle {
			return _creationRect;
		}
		
		public function set rect(value: Rectangle): void {
			_creationRect = value.clone();
		}
	}
}