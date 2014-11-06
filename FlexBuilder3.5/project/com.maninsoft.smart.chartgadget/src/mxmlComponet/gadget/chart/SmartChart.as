package mxmlComponet.gadget.chart{
	import mx.charts.LinearAxis;
	import mx.containers.Box;
	import mx.formatters.NumberFormatter;

	public class SmartChart extends Box{
		[Bindable]
		public var tranceXml:XML =<chartInfo></chartInfo>;
		[Bindable]
		public var tranceResArray:Array;
		[Bindable]
		public var _chartXml:XML;
		public var numForm:NumberFormatter;
		
		public var chartType:ChartType;
		[Bindable]
		public var chartTypes:Array = ChartTypes.chartTypeArray;

		public function SmartChart(){
			super();
			numForm = new NumberFormatter();
			numForm.useThousandsSeparator = true;
			numForm.useNegativeSign = true;
		}
		
		public function set chartXml(xml:XML):void{}

		public function get chartXml():XML{
			return _chartXml;
		}
		
		public function defineAxisLabel(cat:Object, pcat:Object,ax:LinearAxis):String {
			var labelString:String;
			var value:Number = Number(cat);
			labelString = numForm.format(value);
			if(value>0 && value <1 )
				labelString = "0" + labelString;
			else if(value<0 && value >-1)
				labelString = "-0" + numForm.format(-value);
        	return labelString;
  		}
  		
  		public function set chartViewType(viewType:String):void{}

  		public function set displayStackedData(acumData:Boolean):void{}
  		
  		public var fillColor:uint = 0;
	}
}