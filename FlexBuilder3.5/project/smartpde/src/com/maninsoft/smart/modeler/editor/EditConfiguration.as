////////////////////////////////////////////////////////////////////////////////
//  EditConfiguration.as
//  2008.01.02, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.editor
{
	import com.maninsoft.smart.modeler.common.ObjectBase;
	
	/**
	 * 에디터의 편집 및 뷰 환경 설정을 관리한다.
	 */
	public class EditConfiguration extends ObjectBase	{
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _owner: DiagramEditor;

		private var _gridSizeX: int = 8;
		private var _gridSizeY: int = 8;
		

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		public function EditConfiguration(owner: DiagramEditor) {
			super();
			
			_owner = owner;
		}

		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * owner
		 */		
		public function get owner(): DiagramEditor {
			return _owner;
		}
		
		/**
		 * 다이어그램 영역 바탕에 격자를 표시할 때 수평 격자간의 간격.
		 * 또한, 키보드를 이용 선택된 개체들을 이동시킬 때 기본 이동 단위가 된다.
		 */
		public function get gridSizeX(): int {
			return _gridSizeX;
		}
		
		public function set gridSizeX(value: int): void {
			_gridSizeX = value;
		}

		/**
		 * 다이어그램 영역 바탕에 격자를 표시할 때 수직 격자간의 간격.
		 * 또한, 키보드를 이용 선택된 개체들을 이동시킬 때 기본 이동 단위가 된다.
		 */
		public function get gridSizeY(): int {
			return _gridSizeY;
		}
		
		public function set gridSizeY(value: int): void {
			_gridSizeY = value;
		}
	}
}