package com.maninsoft.smart.workbench.common.command.model
{
	public class ChainedCompoundCommand extends CompoundCommand
	{
		public override function chain(c:Command):Command{
			add(c);
			return this;
		}
	}
}