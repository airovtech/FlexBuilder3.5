package mxmlComponet.home.chartInfo.model{
	import portalAs.commonModel.GridDataProviderModel;
	
	public class ColumnModel extends GridDataProviderModel{
		
		public var columnId:String="";
		[Bindable]
		public var columnName:String="";
		public function ColumnModel(){
		}
	}
}