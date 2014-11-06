////////////////////////////////////////////////////////////////////////////////
//  LinkEvent.as
//  2007.12.26, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.model.events
{
	import com.maninsoft.smart.modeler.model.Link;
	
	import flash.events.Event;
	
	public class LinkEvent extends Event {
		
		//----------------------------------------------------------------------
		// Class consts
		//----------------------------------------------------------------------

		/** 링크 추가 이벤트 */
		public static const CREATE: String = "linkCreated";
		/** 링크 삭제 이벤트 */
		public static const REMOVE: String = "linkRemoved";
		/** 링크 속성 변경 이벤트 */
		public static const CHANGE: String = "linkChanged";


		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _link: Link;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function LinkEvent(type: String, link: Link = null) {
			super(type);
			
			_link = link;
		}
		
		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * link
		 */
		public function get link(): Link {
			return _link;
		}
		
		public function set link(value: Link): void {
			_link = value;
		}
	}
}