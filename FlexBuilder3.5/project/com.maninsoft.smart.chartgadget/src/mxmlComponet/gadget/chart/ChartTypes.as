package mxmlComponet.gadget.chart
{
	import mx.resources.ResourceManager;
	
	public class ChartTypes
	{
		public static const GRID_REPORT:String = "GRID";
		public static const MATRIX_REPORT:String = "MATRIX";
		
		public static var areaChartType:ChartType = new ChartType(ResourceManager.getInstance().getString("ChartGadgetETC", "AreaChartText"), "AREA_CHART"); 
		public static var barChartType:ChartType = new ChartType(ResourceManager.getInstance().getString("ChartGadgetETC", "BarChartText"), "BAR_CHART"); 
		public static var bubbleChartType:ChartType = new ChartType(ResourceManager.getInstance().getString("ChartGadgetETC", "BubbleChartText"), "BUBBLE_CHART"); 
		public static var columnChartType:ChartType = new ChartType(ResourceManager.getInstance().getString("ChartGadgetETC", "ColumnChartText"), "COLUMN_CHART"); 
		public static var lineChartType:ChartType = new ChartType(ResourceManager.getInstance().getString("ChartGadgetETC", "LineChartText"), "LINE_CHART"); 
		public static var pieChartType:ChartType = new ChartType(ResourceManager.getInstance().getString("ChartGadgetETC", "PieChartText"), "PIE_CHART"); 
		public static var plotChartType:ChartType = new ChartType(ResourceManager.getInstance().getString("ChartGadgetETC", "PlotChartText"), "PLOT_CHART"); 

		public static var chartTypeArray:Array = [ areaChartType, barChartType, bubbleChartType, columnChartType, lineChartType, pieChartType, plotChartType ];
		
		public static function getChartType(data:String):ChartType{
			for each(var chartType:ChartType in chartTypeArray){
				if(chartType.data == data){
					return chartType;
				}
			}
			return null;
		}
	}
}