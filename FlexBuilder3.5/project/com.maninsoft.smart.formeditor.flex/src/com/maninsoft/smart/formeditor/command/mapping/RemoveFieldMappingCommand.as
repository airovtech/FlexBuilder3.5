package com.maninsoft.smart.formeditor.command.mapping
{
	import com.maninsoft.smart.formeditor.model.Mapping;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class RemoveFieldMappingCommand extends Command
	{
		
		public var target:Mapping;
		private var oldTarget:Mapping;
		private var oldIndex:int;
		private var isIn:Boolean;
		
		public function RemoveFieldMappingCommand(target:Mapping, isIn:Boolean)
		{
			this.target = target;
			this.isIn = isIn;
		}

		public override function execute():void{
			this.oldTarget = this.target;
			if(this.isIn){
				this.oldIndex = this.oldTarget.parent.inMappings.getItemIndex(this.oldTarget);
				this.target.parent.removeInMapping(this.target);
			}else{
				this.oldIndex = this.oldTarget.parent.outMappings.getItemIndex(this.oldTarget);
				this.target.parent.removeOutMapping(this.target);				
			}
		}

		public override function undo():void{
			if(this.isIn){
				this.target.parent.addInMapping(this.oldTarget, this.oldIndex);
			}else{
				this.target.parent.addOutMapping(this.oldTarget, this.oldIndex);				
			}
		}	
		
		public override function redo():void{
			if(this.isIn){
				this.target.parent.removeInMapping(this.target);
			}else{
				this.target.parent.removeOutMapping(this.target);
			}
		}
		public override function getLabel():String{
			return "Remove mapping item(" + target.name + ")";
		}	
	}
}