package mxmlComponet.gadget.model{
	import portalAs.commonModel.GridDataProviderModel;
	
	public class GadgetColumn extends GridDataProviderModel{
		[Bindable]
		public var name:String;
		[Bindable] 
		public var description:String;
		
		public function GadgetColumn(id:String, name:String, description:String, isChecked:Boolean){
			this.id = id;
			this.name = name;
			this.description = description;
			this.isChecked = isChecked;
		}
	}
}