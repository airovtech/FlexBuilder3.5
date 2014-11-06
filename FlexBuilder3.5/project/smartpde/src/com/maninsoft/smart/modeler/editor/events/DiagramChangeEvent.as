////////////////////////////////////////////////////////////////////////////////
//  DiagramChangeEvent.as
//  2008.02.27, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.editor.events
{
	import flash.events.Event;
	
	/**
	 * 다이어그램 내용이 변경되었을 때 에디터가 발생시키는 이벤트
	 */
	public dynamic class DiagramChangeEvent extends Event	{
		
		//----------------------------------------------------------------------
		// Event types
		//----------------------------------------------------------------------

		public static const NODE_ADDED		: String = "diagramNodeAdded";
		public static const NODE_REMOVED	: String = "diagramNodeRemoved";
		public static const NODE_REPLACED	: String = "diagramNodeReplaced";
		public static const LINK_ADDED		: String = "diagramLinkAdded";
		public static const LINK_REMOVED	: String = "diagramLinkRemoved";
		public static const PROP_CHANGED	: String = "diagramPropChanged";
		public static const SELECTED		: String = "diagramSelected";
		public static const CHART_REFRESHED	: String = "chartRefreshed";


		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _element: Object;
		private var _prop: String = "";
		private var _oldValue: Object;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function DiagramChangeEvent(type: String, element: Object, prop: String = "", oldValue: Object = null) {
			super(type);
			
			_element = element;
			_prop = prop;
			_oldValue = oldValue;
		}
		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * 변경된 다이어그램 요소
		 */
		public function get element(): Object {
			return _element;
		}
		
		/**
		 * 요소의 속성이 변경된 경우 속성 이름
		 */
		public function get prop(): String {
			return _prop;
		}

		/**
		 * 속성 변경시 변경 전의 값
		 */
		public function get oldValue(): Object {
			return _oldValue;
		}
		

		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		
		override public function clone(): Event {
			return new DiagramChangeEvent(type, element, prop, oldValue);
		}
	}
}