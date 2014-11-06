package com.maninsoft.smart.formeditor.refactor.command
{
	import com.maninsoft.smart.formeditor.model.FormEntity;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class IncreaseAttrFormEntityCommand extends Command
	{
		public var formEntity:FormEntity;
		public var type:String;
		public var value:Number;
		
		public function IncreaseAttrFormEntityCommand(formEntity:FormEntity, type:String, value:Number)
		{
			this.formEntity = formEntity;
			this.type = type;
			this.value = value;
		}

		public override function execute():void{
			if(this.formEntity[type] as Number){
				this.formEntity[type] = (this.formEntity[type] as Number) + value;
			}
		}

		public override function undo():void{
			if(this.formEntity[type] as Number){
				this.formEntity[type] = (this.formEntity[type] as Number) - value;
			}
		}	
		
		public override function getLabel():String{
			return "Increase " + type + " values (" + value + ") in FormField(" + formEntity.id + ")";
		}	
	}
}