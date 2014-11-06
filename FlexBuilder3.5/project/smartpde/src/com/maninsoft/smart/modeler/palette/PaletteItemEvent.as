////////////////////////////////////////////////////////////////////////////////
//  PaletteEvent.as
//  2007.12.14, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.palette
{
	import flash.events.Event;
	
	/**
	 * PaletteItem event
	 */
	public class PaletteItemEvent extends Event {
		
		//----------------------------------------------------------------------
		// Consts
		//----------------------------------------------------------------------
		
		public static const CLICK: String = "itemClick";
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		/** Storage for property item */
		private var _item: PaletteItem;
		
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** 
		 * Constructor 
		 * 
		 * @param type String 이벤트 종류
		 * @param item PaletteItem 이벤트와 관련된 팔레트 아이템
		 */
		public function PaletteItemEvent(type: String, item: PaletteItem = null) {
			super(type);
			
			_item = item;
		}
		
		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * Property item
		 */
		public function get item(): PaletteItem {
			return _item;
		}
		
		public function set item(value: PaletteItem): void {
			_item = value;
		}
	}
}