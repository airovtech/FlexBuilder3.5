package com.maninsoft.smart.formeditor.view.format
{
	import com.maninsoft.smart.formeditor.model.type.FormatType;
	import com.maninsoft.smart.formeditor.model.type.FormatTypes;
	import com.maninsoft.smart.formeditor.view.AbstractFormatView;
	
	import mx.controls.ComboBox;

	public class ComboBoxView extends AbstractFormatView
	{
		private var combobox:ComboBox;
		public function ComboBoxView()
		{
			super();
			
			combobox = new ComboBox();
			combobox.percentWidth = 100;
			combobox.height = 22;
			combobox.setStyle("fontSize", 11);
			combobox.setStyle("fontFamily", "Tahoma");
			combobox.setStyle("cornerRadius", 0);
			addChild(combobox);
		}
		
		protected function set value(value:String):void {
			if (combobox != null)
				combobox.selectedItem = value;
		}
		
		protected function set comboBoxDataProvider(value:Object):void {
			combobox.dataProvider = value;
		}
		protected function set comboBoxEnabled(enabled:Boolean):void {
			combobox.enabled = enabled;
		}
		
		override public function refreshVisual():void{
			comboBoxDataProvider = fieldModel.format.staticListExamples;
			comboBoxEnabled = !fieldModel.readOnly;
		}
		
		override public function get formatType():FormatType {
			return FormatTypes.comboBox;
		}
	}
}