package com.maninsoft.smart.formeditor.command.mapping
{
	import com.maninsoft.smart.formeditor.model.ActualParameter;
	import com.maninsoft.smart.formeditor.model.ActualParameters;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class AddMappingFormParamCommand extends Command
	{
		
		public var params:ActualParameters;
		public var param:ActualParameter;
		public var index:int;
		
		public function AddMappingFormParamCommand(params:ActualParameters, param:ActualParameter, index:int = -1)
		{
			this.params = params;
			this.param = param;
			this.index = index;
		}

		public override function execute():void{
			if(this.index == -1){
				this.params.addActualParameter(this.param);
			}else{
				this.params.addActualParameter(this.param, this.index);
			}
		}

		public override function undo():void{
			this.params.removeActualParameter(this.param);
		}	
		
		public override function getLabel():String{
			return "Add FormMappingParam(" + param.toString() + ") to Params at index(" + index + ")";
		}	
	}
}