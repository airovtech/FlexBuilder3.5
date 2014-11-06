////////////////////////////////////////////////////////////////////////////////
//  Problem.as
//  2008.03.18, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.syntax
{
	import com.maninsoft.smart.modeler.xpdl.XPDLEditor;
	
	import mx.controls.Alert;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	/**
	 * 다이어그램에 존재하는 하나의 문법 에러
	 */
	public class Problem {
		
		//----------------------------------------------------------------------
		// Static Consts
		//----------------------------------------------------------------------
		
		public static var checkCount: uint = 0;
				
		
		//------------------------------
		// Error Level
		//------------------------------
		
		public static const LEVEL_CRITICAL	: String = "critical";
		public static const LEVEL_ERROR		: String = "error";
		public static const LEVEL_WARNING		: String = "warning";
		public static const LEVEL_INFO		: String = "info";
		

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		private var _resourceManager:IResourceManager;
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function Problem(source: Object, level: String = LEVEL_ERROR) {
			trace("new Problem");
			super();

			this._resourceManager = ResourceManager.getInstance();
			
			this.source = source;
			this.level = level;
		}
		

		//----------------------------------------------------------------------
		// Static methods
		//----------------------------------------------------------------------
		
		public static function clearCount(): void {
			checkCount = 0;
		}
		
		public static function addCount(clazz: Class): void {
			checkCount++;
			trace("checked[" + checkCount + "] " + clazz);
		}
		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		public function get resourceManager():IResourceManager{
			if(_resourceManager==null)
				_resourceManager = ResourceManager.getInstance();
			return _resourceManager;
		}

		/**
		 * 문제를 야기한 개체. notation이나 diagram 자체일 수도 있다.
		 */
		public var source: Object;
		
		/**
		 * 심각성 level
		 */
		public var level: String;
		
		/**
		 * label
		 */
		public var label: String;
		
		/**
		 * 메시지
		 */
		public var message: String;
		
		/**
		 * 설명
		 */
		public var description: String;
		
		/**
		 * 자동 처리 가능한가?
		 */
		public function get canFixUp(): Boolean {
			return false;
		}
		
		/**
		 * Hint를 가지고 있는가?
		 */
		public function get hasHint(): Boolean {
			return true;
		}

		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		
		/**
		 * 문제를 해결하다.
		 */		
		public function fixUp(editor: XPDLEditor): void {
		}


		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		private function isValidLevel(level: String): Boolean {
			return (level == LEVEL_CRITICAL) || (level == LEVEL_ERROR) || 
			        (level == LEVEL_WARNING) || (level == LEVEL_INFO);
		}
		
		protected function showMessage(msg: String): void {
			Alert.show(msg, this.label);
		}
	}
}