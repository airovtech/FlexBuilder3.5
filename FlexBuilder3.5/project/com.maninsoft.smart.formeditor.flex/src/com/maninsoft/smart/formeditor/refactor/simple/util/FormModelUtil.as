package com.maninsoft.smart.formeditor.refactor.simple.util
{
	import com.maninsoft.smart.formeditor.model.FormEntity;
	import com.maninsoft.smart.formeditor.model.IFormContainer;
	
	import mx.collections.ArrayCollection;
	
	public class FormModelUtil
	{
		public static function getFormField(id:String, childern:ArrayCollection):FormEntity{
			for each(var formField:FormEntity in childern){
				if(formField.id == id){
					return formField;
				}
				if(formField.children != null && formField.children.length > 0){
					var subFormField:FormEntity = getFormField(id, formField.children);
					if(subFormField != null)
						return subFormField;
				}
			}
			return null;
		}
		
		public static function generateField(value:String, formField:FormEntity):XML{
			var formFieldXml:XML = <DataField id="" name="">{value}</DataField>;
			formFieldXml.@id = formField.id;
			formFieldXml.@name = formField.name;
			
			return formFieldXml;
		}

		public static function generateFields(valueArray:ArrayCollection, formField:FormEntity):ArrayCollection{
			var xmlArrayCollection:ArrayCollection = new ArrayCollection();
			
			for each(var value:String in valueArray){
				xmlArrayCollection.addItem(generateField(value, formField));
			}
			
			return xmlArrayCollection;
		}
		
		public static function getFormFieldById(id:String, formContainer:IFormContainer):FormEntity{
			for(var i:int = 0 ; i < formContainer.length ; i++){
				var child:FormEntity = formContainer.getFieldAt(i) as FormEntity;
				if(child.id == id){
					return child;
				}else if(child is IFormContainer){
					var result:FormEntity = getFormFieldById(id, child);
					if(result != null){
						return result;
					}
				}
			}
			return null;
		}
	}
}