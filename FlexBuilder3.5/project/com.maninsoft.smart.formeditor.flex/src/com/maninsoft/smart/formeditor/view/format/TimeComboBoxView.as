package com.maninsoft.smart.formeditor.view.format
{
	import com.maninsoft.smart.formeditor.model.type.FormatType;
	import com.maninsoft.smart.formeditor.model.type.FormatTypes;
	
	import mx.collections.ArrayCollection;
	import mx.resources.ResourceManager;

	public class TimeComboBoxView extends ComboBoxView
	{
		private static var _times:ArrayCollection = null;
		private static var startVal:String = null;
		public function TimeComboBoxView()
		{
			super();
			comboBoxDataProvider = times;
			value = startVal;
		}
		
		private static function get times():ArrayCollection {
			if (_times != null)
				return _times;
			
			_times = new ArrayCollection();
			for (var i:int=0; i<24 ; i++) {
				var viewHour:int;
				var viewHourStr:String;
				var realHourStr:String;
				
				if (i > 12) {
					viewHour = i-12;
				} else {
					viewHour = i;
				}
				if (viewHour < 10) {
					viewHourStr = "0" + viewHour;
				} else {
					viewHourStr = "" + viewHour;
				}
				if (i < 10) {
					realHourStr = "0" + i;
				} else {
					realHourStr = "" + i;
				}
				var timeVal:String;
				for (var j:int=0; j<2; j++) {
					timeVal = ((i > 11)?ResourceManager.getInstance().getString("FormEditorETC", "afternoonText")
										:ResourceManager.getInstance().getString("FormEditorETC", "beforenoonText")) + viewHourStr + ":" + ((j==0)?"00":"30");
					if (i == 9 && j == 0)
						startVal =  timeVal;
					_times.addItem(timeVal);
				}
			}
			
			return _times;
		}
		
		override public function refreshVisual():void{
			comboBoxEnabled = !fieldModel.readOnly;
		}
		
		override public function get formatType():FormatType {
			return FormatTypes.timeField;
		}
	}
}