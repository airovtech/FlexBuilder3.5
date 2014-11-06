package com.maninsoft.smart.common.controls
{
	import com.maninsoft.smart.common.util.SmartUtil;
	
	import mx.controls.ComboBox;

	public class SimpleComboBox extends ComboBox
	{
		public function SimpleComboBox()
		{
			super();
			this.percentWidth = 100;
			this.setStyle("fillAlphas", [1,1]);
		}
		
		public function toIndex(value:String):int {
			if (SmartUtil.isEmpty(this.dataProvider))
				return -1;
			var i:int = 0;
			for each(var option:Object in this.dataProvider){
				if (option == null) {
					i++;
					continue;
				}
				
				if (option is String) {
					if (option != value) {
						i++;
						continue;
					}
					return i;
				}
				
				if (option["value"] != value) {
					i++;
					continue;
				}
				return i;
			}
			return -1;
		}
		public function selectItem(value:String):Boolean {
			var index:int = toIndex(value);
			if (index < 0)
				return false;
			selectedIndex = index;
			return true;
		}
		public function toLabel(value:String):String {
			var index:int = toIndex(value);
			if (index < 0)
				return "";
			var data:Object = this.dataProvider[index];
			if (data is String)
				return value;
			return data["label"];
		}
	}
}