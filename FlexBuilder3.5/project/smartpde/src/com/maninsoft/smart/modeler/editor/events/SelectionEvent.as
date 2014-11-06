////////////////////////////////////////////////////////////////////////////////
//  SelectionEvent.as
//  2008.01.25, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.editor.events
{
	import com.maninsoft.smart.workbench.common.property.IPropertySource;
	
	import flash.events.Event;
	
	/**
	 * 다이어그램 에디터 등 ISelectionProvider에서 선택 상태가 변경되었을 때 등
	 * 선택과 관련된 이벤트에서 사용된다.
	 */
	public class SelectionEvent extends Event {
		
		//----------------------------------------------------------------------
		// Event types
		//----------------------------------------------------------------------
		
		public static const SELECTION_CHANGED: String = "selectionChanged";
		
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _selection: Array;


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function SelectionEvent(type: String, selection: Array) {
			super(type);
			
			_selection = selection;
		}

		
		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * selection
		 */
		public function get selection(): Array {
			return _selection;
		}
		
		/**
		 * selectedItem
		 */
		public function get selectedItem(): Object {
			if (_selection && _selection.length > 0)
				return _selection[0];
			else
				return null;
		}
		
		/**
		 * selectedSource
		 */
		public function get selectedSource(): IPropertySource {
			return selectedItem as IPropertySource;
		}
	}
}