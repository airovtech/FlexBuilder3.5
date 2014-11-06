package com.maninsoft.smart.formeditor.refactor.command
{
	import com.maninsoft.smart.formeditor.model.FormEntity;
	
	public class ResizeFormEntityCommand extends FormEntityCommand
	{
		public var labelWidth:int;
		public var contentWidth:int;
		public var height:int;
		
		private var oldLabelWidth:int;		
		private var oldContentWidth:int;
		private var oldHeight:int;

		public function ResizeFormEntityCommand(formEntityModel:FormEntity, labelWidth:int, contentWidth:int, height:int, label:String = "") {
			super(label);
			
			this.formEntityModel = formEntityModel;
			
			this.labelWidth = labelWidth;
			this.contentWidth = contentWidth;
			this.height = height;
		}
	
		public override function execute():void{
			oldLabelWidth = formEntityModel.labelWidth;
			oldContentWidth = formEntityModel.contentWidth;
			oldHeight = formEntityModel.height;
			
			formEntityModel.labelWidth = labelWidth;
			formEntityModel.contentWidth = contentWidth;
			formEntityModel.height = height;
		}

		public override function undo():void{
			formEntityModel.labelWidth = oldLabelWidth;
			formEntityModel.contentWidth = oldContentWidth;
			formEntityModel.height = oldHeight;
		}
		
		public override function redo():void{
			formEntityModel.labelWidth = labelWidth;
			formEntityModel.contentWidth = contentWidth;
			formEntityModel.height = height;
		}
		public override function getLabel():String{
			return "Resize set labelSize, contentsSize, heightSize values (" + labelWidth + "," + contentWidth + "," + height + ") in FormEntity(" + formEntityModel.id + ")";
		}	
	}
}