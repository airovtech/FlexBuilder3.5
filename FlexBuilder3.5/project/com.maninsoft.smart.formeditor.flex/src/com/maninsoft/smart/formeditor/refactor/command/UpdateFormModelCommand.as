package com.maninsoft.smart.formeditor.refactor.command
{
	import com.maninsoft.smart.formeditor.refactor.component.model.TextStyleModel;
	import com.maninsoft.smart.formeditor.model.FormDocument;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class UpdateFormModelCommand extends Command
	{
		public var formModel:FormDocument;
		
		public var newValue:Object;
		private var oldValue:Object;
		
		public var type:String;
		
		public function UpdateFormModelCommand(label:String) {
			super(label);
		}
	
		public override function execute():void{
			if (type == FormDocument.PROP_NAME) {
				oldValue = formModel.name;				
				this.formModel.name = String(newValue);
			}else if (type == FormDocument.PROP_HEIGHT) {
				oldValue = formModel.height;				
				this.formModel.height = int(newValue);
			}else if (type == FormDocument.PROP_CONTENTS_TEXTSTYLE) {
				oldValue = formModel.contentsTextStyle;				
				this.formModel.contentsTextStyle = TextStyleModel(newValue);
			}else if (type == FormDocument.PROP_COLOR_BACKGROUND) {
				oldValue = formModel.bgColor;				
				this.formModel.bgColor = Number(newValue);
			}
		}

		public override function undo():void{
			if (type == FormDocument.PROP_HEIGHT) {		
				this.formModel.height = int(oldValue);
			}else if (type == FormDocument.PROP_CONTENTS_TEXTSTYLE) {			
				this.formModel.contentsTextStyle = TextStyleModel(oldValue);
			}else if (type == FormDocument.PROP_COLOR_BACKGROUND) {
				this.formModel.bgColor = Number(oldValue);
			}
//			else if (type == FormDocument.PROP_REFFORMID) {
//				this.formModel.refFormId = String(oldValue);
//			} 
		}
		
		public override function redo():void{
			if (type == FormDocument.PROP_HEIGHT) {	
				this.formModel.height = int(newValue);
			}else if (type == FormDocument.PROP_CONTENTS_TEXTSTYLE) {			
				this.formModel.contentsTextStyle = TextStyleModel(newValue);
			}else if (type == FormDocument.PROP_COLOR_BACKGROUND) {
				this.formModel.bgColor = Number(newValue);
			}
//			else if (type == FormDocument.PROP_REFFORMID) {
//				this.formModel.refFormId = String(newValue);
//			}  
		}
		public override function getLabel():String{
			return "Update " + type + " values (" + newValue + ") in FormDocument";
		}

	}
}