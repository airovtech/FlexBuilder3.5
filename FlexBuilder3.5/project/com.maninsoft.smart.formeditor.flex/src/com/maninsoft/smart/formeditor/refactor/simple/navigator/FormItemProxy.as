package com.maninsoft.smart.formeditor.refactor.simple.navigator
{
	import com.maninsoft.smart.formeditor.model.FormDocument;
	import com.maninsoft.smart.formeditor.model.FormEntity;
	
	public class FormItemProxy extends FormEntity
	{
		public function FormItemProxy(root:FormDocument)
		{
			super(root);
			this.name = "새 항목";
		}
		
		public override function refreshChildren():void{
		}
	}
}