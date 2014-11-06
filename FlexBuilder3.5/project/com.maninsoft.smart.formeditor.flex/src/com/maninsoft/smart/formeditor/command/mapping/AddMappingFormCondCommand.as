package com.maninsoft.smart.formeditor.command.mapping
{
	import com.maninsoft.smart.formeditor.model.Cond;
	import com.maninsoft.smart.formeditor.model.Conds;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class AddMappingFormCondCommand extends Command
	{
		
		public var conds:Conds;
		public var cond:Cond;
		public var index:int;
		
		public function AddMappingFormCondCommand(conds:Conds, cond:Cond, index:int = -1)
		{
			this.conds = conds;
			this.cond = cond;
			this.index = index;
		}

		public override function execute():void{
			if(this.index == -1){
				this.conds.addCond(this.cond);
			}else{
				this.conds.addCond(this.cond, this.index);
			}
		}

		public override function undo():void{
			this.conds.removeCond(this.cond);
		}	
		
		public override function getLabel():String{
			return "Add FormMappingCond(" + cond.toString() + ") to Conds at index(" + index + ")";
		}	
	}
}