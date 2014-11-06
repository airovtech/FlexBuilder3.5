package com.maninsoft.smart.formeditor.view.format
{
	import com.maninsoft.smart.formeditor.model.FormEntity;
	import com.maninsoft.smart.formeditor.model.type.FormatType;
	import com.maninsoft.smart.formeditor.model.type.FormatTypes;
	import com.maninsoft.smart.formeditor.refactor.editor.FormEditDomain;
	import com.maninsoft.smart.formeditor.view.AbstractFormatView;
	import com.maninsoft.smart.formeditor.view.FieldView;
	import com.maninsoft.smart.formeditor.view.IFormatView;
	
	import flash.display.DisplayObject;
	
	import mx.containers.HBox;
	import mx.controls.TextInput;

	public class TextInputView extends AbstractFormatView implements IFormatView
	{
		private var _formEntityModel:FormEntity;
		private var _option:Object;
		private var _formFieldView:FieldView;
		private var _editDomain:FormEditDomain;
		
		private var hbox:HBox;
		private var textInput:TextInput;
		public function TextInputView()
		{
			super();
			
			hbox = new HBox();
			hbox.percentWidth = 100;
			hbox.percentHeight = 100;
			hbox.setStyle("verticalAlign", "middle");
			hbox.setStyle("horizontalGap", 2);
			addChild(hbox);
			
			textInput = new TextInput();
			textInput.percentWidth = 100;
			textInput.height = 22;
			addChild(this.textInput);
		}
		
		override public function setStyle(styleProp:String, newValue:*):void {
			if (styleProp == "verticalAlign") {
				if (hbox != null)
					hbox.setStyle(styleProp, newValue);
				return;
			}
			
			super.setStyle(styleProp, newValue);
		}
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject {
			if (child == hbox)
				return super.addChildAt(child, index);
			return hbox.addChildAt(child, index);
		}
		override public function addChild(child:DisplayObject):DisplayObject {
			if (child == hbox)
				return super.addChild(child);
			return hbox.addChild(child);
		}
		
		override public function get formatType():FormatType {
			return FormatTypes.textInput;
		}
	}
}