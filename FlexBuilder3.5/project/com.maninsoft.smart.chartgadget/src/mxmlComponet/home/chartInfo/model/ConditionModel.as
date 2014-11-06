package mxmlComponet.home.chartInfo.model{
	import portalAs.commonModel.GridDataProviderModel;
	
	public class ConditionModel extends GridDataProviderModel{
		[Bindable]
		public var name:String="";
		[Bindable]
		public var columnId:String="";
		[Bindable]
		public var columnName:String="";
		[Bindable]
		public var conditionValue:String="";
		[Bindable]
		public var comparison:String="";
		public function ConditionModel(){
		}
	}
}