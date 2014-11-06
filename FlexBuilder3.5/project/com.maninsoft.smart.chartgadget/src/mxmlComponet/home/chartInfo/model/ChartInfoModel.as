package mxmlComponet.home.chartInfo.model{
	import mx.collections.ArrayCollection;
	
	public class ChartInfoModel{
		[Bindable]
		public var formId:String="";
		[Bindable]
		public var chartName:String="";
		[Bindable]
		public var chartType:String="";
		[Bindable]
		public var remarkId:String="";
		[Bindable]
		public var reamrkName:String="";
		[Bindable]
		public var valueInfoId:String="";
		[Bindable]
		public var valueInfoName:String="";
		[Bindable]
		public var valueFilterModel:ValueFilterModel = new ValueFilterModel();
		[Bindable]
		public var groupingId:String="";
		[Bindable]
		public var groupingName:String="";
		[Bindable]
		public var groupingFilterModel:GroupingFilterModel = new GroupingFilterModel();
		[Bindable]
		public var columns:ArrayCollection = new ArrayCollection();
		[Bindable]
		public var conditions:ArrayCollection =  new ArrayCollection();
		[Bindable]
		public var conditionsRelation:String=""; //and, or
		public function ChartInfoModel(){
		}
	}
}