package mxmlComponet.gadget.chart
{
	public class ChartType
	{
		public var label:String;
		public var data:String;

		public function ChartType(label:String, data:String){
			super();
			this.label = label;
			this.data = data;
		}
		
		public function clone():ChartType{
			var chartType:ChartType = new ChartType(label, data);
			return chartType;	
		}
	}
}