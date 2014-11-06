////////////////////////////////////////////////////////////////////////////////
//  Task.as
//  2007.12.20, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model.base
{
	import com.maninsoft.smart.modeler.model.utils.NodeUtils;
	
	/**
	 * XPDL Task implementation
	 */
	public class Task extends Implementation {
		
		//----------------------------------------------------------------------
		// Property consts
		//----------------------------------------------------------------------

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/**
		 * Construtor 
		 */
		public function Task() {
			super();			
		}

		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		override protected function initDefaults():void{
			super.initDefaults();
			this.name = defaultName;
		}

		/**
		 * 다른 태스크들로 부터의 직간접적인 Incoming 링크가 없으면 true를 반환한다.
		 */ 
		public function isFirstTask(): Boolean {
			return NodeUtils.getNodesByType(getBackwardNodes(), Task).length < 1;
		}


		//----------------------------------------------------------------------
		// Overriden properties
		//----------------------------------------------------------------------
		

		override public function get defaultName(): String {
			return resourceManager.getString("ProcessEditorETC", "taskText");
		}

		override public function get defaultWidth(): Number {
			return 100;
		}
		
		override public function get defaultHeight(): Number {
			return 40;
		}
		
		override public function get defaultFillColor(): uint {
			return 0xeff8ff;
		}
		
		override public function get defaultTextColor(): uint {
			return 0x666666;
		}

		override public function get defaultBorderColor(): uint {
			return 0xa0c4ce;
		}
	}
}