package com.maninsoft.smart.formeditor.view.format
{
	import com.maninsoft.smart.formeditor.model.type.FormatType;
	import com.maninsoft.smart.formeditor.model.type.FormatTypes;
	import com.maninsoft.smart.formeditor.view.AbstractFormatView;
	
	import flash.display.DisplayObject;
	
	import mx.containers.HBox;
	import mx.controls.RadioButton;

	public class RadioButtonView extends AbstractFormatView
	{
		private var hbox:HBox;
		public function RadioButtonView()
		{
			super();
			
			hbox = new HBox();
			hbox.percentWidth = 100;
			hbox.percentHeight = 100;
			this.addChild(hbox);
		}
		
		override public function refreshVisual():void{
			if (this.initialized || this.hbox != null) {
				for each(var child:DisplayObject in this.hbox.getChildren()){
					if (child is RadioButton)
						this.hbox.removeChild(child);
				}
				for each (var staticExample:String in fieldModel.format.staticListExamples) {
					var radiobutton:RadioButton = new RadioButton();
					radiobutton.label = staticExample;
					radiobutton.value = staticExample;
					radiobutton.setStyle("fontSize", 11);
					radiobutton.setStyle("fontFamily", "Tahoma");
					this.hbox.addChild(radiobutton);
				}	
			}
		}
		
		override public function get formatType():FormatType {
			return FormatTypes.radioButton;
		}
	}
}