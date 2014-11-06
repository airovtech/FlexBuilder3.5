package com.maninsoft.smart.formeditor.model.property
{
	public class FormArrayInfo
	{
		[Bindable]
		public var maxArrayUse:Boolean = false;
		[Bindable]
		public var maxArraySize:int = 10;
		[Bindable]
		public var presentArrayUse:Boolean = false;
		[Bindable]
		public var presentArraySize:int = 1;
		
		public function FormArrayInfo(maxArrayUse:Boolean = false, maxArraySize:int = 10, presentArrayUse:Boolean = false, presentArraySize:int = 1){
			this.maxArrayUse = maxArrayUse;
			this.maxArraySize = maxArraySize;
			this.presentArrayUse = presentArrayUse;
			this.presentArraySize = presentArraySize;
		}
	}
}