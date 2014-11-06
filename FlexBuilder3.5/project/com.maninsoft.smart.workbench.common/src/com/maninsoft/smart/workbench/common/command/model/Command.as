package com.maninsoft.smart.workbench.common.command.model
{
	/**
	 * command 패턴의 command이며 자체적으로 행위를 할 수 있는 모든 정보를 담고 있음
	 **/ 
	public class Command
	{

		private var label:String;
		
		private var debugLabel:String;
		
		public function Command(label:String = null){
			if(label != null) setLabel(label);
		}
		
		/**
		 * 실행가능한 지 확인
		 */
		public function canExecute():Boolean{
			return true;
		}
		
		/**
		 * undo가 가능한 지 확인
		 */
		public function canUndo():Boolean{
			return true;
		}
		
		/**
		 * 현재 command와 주어진 command를 순서대로 엮어서 chain command(여러개의 command를 합쳐서)를 생성해서 준다.
		 */
		public function chain(command:Command):Command{
			if (command == null)
				return this;
			
			var result:CompoundCommand = new ChainedCompoundCommand();
			result.add(this);
			result.add(command);
			return result;
		}
		
		/**
		 * This is called to indicate that the <code>Command</code> will not be used again. The
		 * Command may be in any state (executed, undone or redone) when dispose is called. The
		 * Command should not be referenced in any way after it has been disposed.
		 */
//		public function dispose():void{ }
		
		/**
		 * command 실행
		 */
		public function execute():void{ }
		
		/**
		 * @return an untranslated String used for debug purposes only
		 */
//		public function getDebugLabel():String {
//			return debugLabel + ' ' + getLabel();
//		}
		
		/**
		 * command label
		 */
		public function getLabel():String{
			return label;
		}
		
		/**
		 * 재실행
		 */
		public function redo():void{
			execute();
		}
		
		/**
		 * Sets the debug label for this command
		 * @param label a description used for debugging only
		 */
//		public function setDebugLabel(label:String):void{
//			debugLabel = label;
//		}
		
		/**
		 * 라벨 설정
		 */
		public function setLabel(label:String):void{
			this.label = label;
		}
		
		/**
		 * 되돌리기
		 */
		public function undo():void { }
	}
}