package mxmlComponet.gadget.model{
	import portalAs.commonModel.GridDataProviderModel;
	

	public class GadgetContent extends GridDataProviderModel{
		[Bindable] 
		public var name:String;
		[Bindable] 
		public var description:String;
		[Bindable] 
		public var className:String;
		[Bindable] 
		public var columnName:String;
		[Bindable] 
		public var formId:String;
		
		public function GadgetContent(id:String, name:String, description:String, className:String, columnName:String, isChecked:Boolean, formId:String){
			this.id = id;
			this.name = name;
			this.description = description;
			this.className = className;
			this.columnName = columnName;
			this.isChecked = isChecked;
			this.formId = formId;
		}
	}
}