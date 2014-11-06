package com.maninsoft.smart.workbench.common.command.model
{
	import mx.collections.ArrayCollection;
	
	public class CompoundCommand extends Command
	{
		private var commandList:ArrayCollection = new ArrayCollection();
		
		public function CompoundCommand(label:String = null) {
			super(label);
		}
		
		/**
		 * command를 compound command의 구성원으로 추가
		 */
		public function add(command:Command):void {
			if (command != null)
				commandList.addItem(command);
		}
		
		public override function canExecute():Boolean{
			// 구성원 command 중 하나라도 실행할 수 없으면 실행못함
			if (commandList.length == 0)
				return false;
			for each(var cmd:Command in commandList) {
				if (cmd == null)
					return false;
				if (!cmd.canExecute())
					return false;
			}
			return true;
		}
		
		public override function canUndo():Boolean{
			// 구성원 command 중 하나라도 되돌리기 할 수 없으면 되돌리기 못함
			if (commandList.length == 0)
				return false;
			for each(var cmd:Command in commandList) {
				if (cmd == null)
					return false;
				if (!cmd.canUndo())
					return false;
			}
			return true;
		}
		
		/**
		 * Disposes all contained Commands.
		 * @see org.eclipse.gef.commands.Command#dispose()
		 */
//		public void dispose() {
//			for (int i = 0; i < commandList.size(); i++)
//				((Command)getCommands().get(i))
//					.dispose();
//		}
		
		public override function execute():void{
			// 모든 구성원 command 다 실행
			for each(var cmd:Command in commandList) {
				cmd.execute();
			}
		}
		
		/**
		 * This is useful when implementing {@link
		 * org.eclipse.jface.viewers.ITreeContentProvider#getChildren(Object)} to display the
		 * Command's nested structure.
		 * @return returns the Commands as an array of Objects.
		 */
//		public Object [] getChildren() {
//			return commandList.toArray();
//		}
		
		/**
		 * 구성원 command array 반환
		 */
		public function getCommands():ArrayCollection{
			return commandList;
		}
		
		public override function getLabel():String{
//			var label:String = super.getLabel();
//			if (label == null)
//				if (commandList.length == 0)
//					return null;
//			if (label != null)
//				return label;
//			return (Command(commandList.getItemAt(0))).getLabel();
			var debugStr:String = "Compound(\n";
			
			var i:int = 0;
			for each(var cmd:Command in commandList) {
				if (cmd != null){
					debugStr += (i++ + " : ");
					debugStr += cmd.getLabel();
					debugStr += "\n";
				}
			}
			
			debugStr += ")";
			return debugStr;
		}
		
		/**
		 * 구성원 command가 없는 지
		 */
		public function isEmpty():Boolean{
			return commandList.length == 0;
		}

		public override function redo():void{
			for each(var cmd:Command in commandList) {
				cmd.redo();
			}
		}
		
		public function get length():int{
			return commandList.length;
		}
		
		public override function undo():void{
			for(var i:int = commandList.length ; i > 0 ; i--) {
				var cmd:Command = commandList.getItemAt(i - 1) as Command
				cmd.undo();
			}
		}
		
		/**
		 * command를 unwrap 함. (구성 command가 없는 경우는 실행할 수 없는 command, 하나인 경우에는 하나의 command 반환, 그 이상인 경우는 그대로)
		 */
		public function unwrap():Command{
			switch (commandList.length) {
				case 0 :
					return UnexecutableCommand.INSTANCE;
				case 1 :
					return Command(commandList.getItemAt(0));
				default :
					return this;
			}
		}		
	}
}