package com.maninsoft.smart.workbench.common.command.model
{
	/**
	 * 실행 불가능한 command 
	 **/
	public class UnexecutableCommand extends Command
	{
		/**
		 * The singleton instance
		 */
		public static const INSTANCE:UnexecutableCommand = new UnexecutableCommand();
				
		public override function canExecute():Boolean{
			return false;
		}
		
		public override function canUndo():Boolean{
			return false;
		}		
	}
}