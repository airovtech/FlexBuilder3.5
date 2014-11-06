////////////////////////////////////////////////////////////////////////////////
//  Command.as
//  2007.12.15, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.command
{
	/**
	 * Command base 
	 * 에디터 상에서 모델의 변경은 Command 를 통해서 이루어지도록 한다.
	 * Command는 모델만 다루도록 해야 한다. 컨트롤러나 뷰는 참조하지 않아야 한다. 
	 */
	public class Command {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _label: String;
		//private var _chain: Array;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function Command(label: String = null) {
			super();
			
			_label = label;
		}		
		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/** 
		 * label 
		 */
		public function get label(): String {
			return _label;
		}
		
		public function set label(value: String): void {
			_label = label;
		}


		//----------------------------------------------------------------------
		// Virtual Methods
		//----------------------------------------------------------------------
		
		/**
		 * 실행 가능한 상태인가?
		 */
		public function canExecute(): Boolean {
			return true;
		}
		
		/**
		 * Undo 가능한 command인가?
		 * 실행되지 않았다면 이 메쏘드가 리턴하는 것은 의미가 없다.
		 */
		public function canUndo(): Boolean {
			return true;
		}
		
		public function execute(): void {
		}
		
		public function undo(): void {
		}
		
		public function redo(): void {
		}				
		
	}
}