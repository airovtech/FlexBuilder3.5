////////////////////////////////////////////////////////////////////////////////
//  CommandStack.as
//  2007.12.15, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.command
{
	import com.maninsoft.smart.modeler.editor.DiagramEditor;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * Command stack
	 */
	public class CommandStack	{

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		/** Storage for owner */
		private var _owner: DiagramEditor;
		
		/** Storage for stack */
		private var _stack: ArrayCollection;
		
		/** Storage for current */
		private var _current: int;


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function CommandStack(owner: DiagramEditor) {
			super();
			
			_owner = owner;
			_stack = new ArrayCollection();
			_current = -1;
		}
		
		
		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------

		/** 
		 * owner
		 */
		public function get owner(): DiagramEditor {
			return _owner;
		}


		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------

		public function execute(command: Command): void {
			if (command && command.canExecute()) {
				// current 상위의 것들은 모두 제거한다.
				flushRedo();			

				command.execute();

				push(command);	
				_current++;
			}
		}
		
		public function canUndo(): Boolean {
			return false;
		}
		
		public function canRedo(): Boolean {
			return false;
		}
		
		public function undo(): void {
			if (_current >= 0 && _current < _stack.length) {
				var cmd: Command = _stack[_current--] as Command;
				cmd.undo();
			}
		}
		
		public function redo(): void {
			if (_current < _stack.length - 1) {
				var cmd: Command = _stack[++_current] as Command;
				cmd.redo();
			}
		}

		/**
		 * stack pointer를 초기화 한다.
		 */		
		public function flush(): void {
			_current = -1;
			flushRedo();
		}



		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		/**
		 * 현재 스택포인터 상위의 것들 즉, reod 가능한 것들을 모두 제거한다.
		 */
		private function flushRedo(): void {
			while (_stack.length > _current + 1)
				pop();
		}
		
		private function push(command: Command): void {
			_stack.addItem(command);
		}
		
		private function pop(): Command {
			return _stack.removeItemAt(_stack.length - 1) as Command;
		}
	}
}