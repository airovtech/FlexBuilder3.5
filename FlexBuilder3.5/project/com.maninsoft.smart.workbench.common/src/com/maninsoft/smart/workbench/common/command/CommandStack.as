package com.maninsoft.smart.workbench.common.command
{
	import com.maninsoft.smart.workbench.common.command.model.Command;
	import com.maninsoft.smart.workbench.common.event.CommandEvent;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * Command Stack을 관리하며 
	 **/
	public class CommandStack extends EventDispatcher
	{
		private var undoLimit:int = 0;
		private var saveLocation:int = 0;
		private var undoable:Array = new Array();
		private var redoable:Array = new Array();
		
		/**
		 * Constructs a new command stack. By default, there is no undo limit, and isDirty() will
		 * return <code>false</code>.
		 */
		public function CommandStack() { }
		
		public function canRedo():Boolean{
			return redoable.length != 0;
		}
		
		public function canUndo():Boolean{
			if (undoable.length == 0)
				return false;
			return (Command(undoable[undoable.length - 1])).canUndo();
		}
		
		public function execute(command:Command):void{
			if (command == null || !command.canExecute())
				return;
			flushRedo();
		
			command.execute();
			if (undoLimit > 0) {
				while (undoable.length >= undoLimit) {
					undoable.shift();
					if (saveLocation > -1)
						saveLocation--;
				}
			}
			if (saveLocation > undoable.length)
				saveLocation = -1; //The save point was somewhere in the redo stack
			undoable.push(command);	
			dispatchEvent(new CommandEvent(CommandEvent.EXECUTE_COMMAND, command.getLabel()));	
		}
		
		public function dispose():void{
			flushUndo();
			flushRedo();
		}
		
		public function flush():void{
			flushRedo();
			flushUndo();
			saveLocation = 0;
		}
		
		private function flushRedo():void{
			while (!(redoable.length == 0))
				redoable.pop();
		}
		
		private function flushUndo():void{
			while (!(undoable.length == 0))
				undoable.pop();
		}
		
		public function getCommands():Array{			
			var commands:ArrayCollection = new ArrayCollection(undoable);
			for each(var command:Command in redoable) {
				commands.addItem(command);
			}
			return commands.toArray();
		}

		public function getRedoCommand():Command{
			return redoable.length == 0 ? null : Command(redoable[redoable.length - 1]);
		}
		
		public function getUndoCommand():Command{
			return undoable.length == 0 ? null : Command(undoable[undoable.length - 1]);
		}
		
		/**
		 * 변경사항이 있는 지 여부를 보여줌
		 **/
		public function isDirty():Boolean{
			return undoable.length != saveLocation;
		}
		
		/**
		 * save를  했다는 표시
		 */
		public function markSaveLocation():void{
			saveLocation = undoable.length;
		}
		
		/**
		 * redo
		 */
		public function redo():void{
			if (!canRedo())
				return;
			var command:Command = Command(redoable.pop());
			
			command.redo();
			undoable.push(command);
			dispatchEvent(new CommandEvent(CommandEvent.REDO_COMMAND, command.getLabel()));
		}
		
		/**
		 * Undo
		 */
		public function undo():void{
			if(canUndo()){
				var command:Command = Command(undoable.pop());
				command.undo();
				redoable.push(command);
				dispatchEvent(new CommandEvent(CommandEvent.UNDO_COMMAND, command.getLabel()));
			}
		}		
	}
}