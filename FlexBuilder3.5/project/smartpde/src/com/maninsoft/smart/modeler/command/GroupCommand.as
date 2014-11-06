////////////////////////////////////////////////////////////////////////////////
//  GroupCommand.as
//  2007.12.24, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.command
{
	import mx.collections.ArrayCollection;
	
	/**
	 * 복수 개의 command를  처리하는 command
	 * undo는 execute의 반대 순서로 처리된다.
	 */
	public class GroupCommand extends Command	{
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _commands: ArrayCollection;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//--------------------------------------------ssxzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz--------------------------
		
		/** Constructor */
		public function GroupCommand(label: String = null) {
			super(label);
			
			_commands = new ArrayCollection();
		}		
		

		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		
		/**
		 * null이 아니면 추가한다.
		 */
		public function add(command: Command): void {
			if (command)
				_commands.addItem(command);
		}		
		
		/**
		 * 이 command와 동일할 가장 단순한 형태의 command 객체를 리턴한다.
		 */
		public function unwrap(): Command {
			switch (_commands.length) {
				case 0: 
					return UnexecutableCommand.SINGLETON;
					
				case 1:
					return _commands.getItemAt(0) as Command;
					
				default:
					return this;
			}
		}
		
		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		/**
		 * 포함된 커맨드가 모두 null이 아니고, 
		 * 반드시 하나 이상의 커맨드가 존재하고,
		 * 모든 커맨드가 실행 가능할 때 true를 리턴한다.
		 */
		override public function canExecute(): Boolean {
			if (_commands.length == 0)
				return false;
				
			for (var i: int = 0; i < _commands.length; i++) {
				var cmd: Command = _commands.getItemAt(i) as Command;
				
				if (!cmd || !cmd.canExecute())
					return false;
			}
			
			return true;
		}
		
		override public function canUndo(): Boolean {
			if (_commands.length == 0)
				return false;
				
			for (var i: int = 0; i < _commands.length; i++) {
				var cmd: Command = _commands.getItemAt(i) as Command;
				
				if (!cmd || !cmd.canUndo())
					return false;
			}
			
			return true;
		}
		
		override public function execute(): void {
			for each (var cmd: Command in _commands)
				cmd.execute();
		}
		
		/**
		 * 역순으로...
		 */
		override public function undo(): void {
			for (var i: int = _commands.length - 1; i >=0; i--)
				Command(_commands.getItemAt(i)).undo();
		}
		
		override public function redo(): void {
			for each (var cmd: Command in _commands)
				cmd.redo();
		}				
	}
}