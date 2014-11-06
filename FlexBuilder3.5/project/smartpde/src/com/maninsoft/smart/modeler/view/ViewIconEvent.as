////////////////////////////////////////////////////////////////////////////////
//  ViewIconEvent.as
//  2008.01.15, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.view
{
	import flash.events.Event;
	
	/**
	 * IViewIcon 관련 이벤트
	 */
	public class ViewIconEvent extends Event	{
		
		//----------------------------------------------------------------------
		// Class consts
		//----------------------------------------------------------------------
		
		public static const ICON_CLICK: String = "iconClick";
		
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _icon: IViewIcon;
		private var _data: Object;


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function ViewIconEvent(type: String, icon: IViewIcon, data: Object = null) {
			super(type);
			
			_icon = icon;
			_data = data;
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		public function get icon(): IViewIcon {
			return _icon;
		}
		
		public function get data(): Object {
			return _data;
		}
	}
}