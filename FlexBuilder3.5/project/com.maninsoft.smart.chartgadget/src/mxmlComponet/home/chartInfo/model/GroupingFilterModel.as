package mxmlComponet.home.chartInfo.model{
	public class GroupingFilterModel{
		[Bindable]
		public var elements:String=""; //구분자를 ',' 한다.
		[Bindable]
		public var inclusion:String=""; //in, notin
		public function GroupingFilterModel(){
		}
	}
}