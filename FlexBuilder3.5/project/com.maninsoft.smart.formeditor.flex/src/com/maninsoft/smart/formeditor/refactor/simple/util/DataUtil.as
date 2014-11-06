package com.maninsoft.smart.formeditor.refactor.simple.util
{
	import com.maninsoft.smart.formeditor.model.FormEntity;
	
	import mx.collections.ArrayCollection;
	
	public class DataUtil
	{
		public static function searchFieldDataXml(fieldId:String, valueXml:XML, valueArray:ArrayCollection):void{
			for each(var dataField:XML in valueXml.DataField){
				if(dataField.@id == fieldId && dataField.toString() != ""){
					valueArray.addItem(dataField);
				}
				if(dataField.DataField.toString() != ""){
					searchFieldData(fieldId, dataField, valueArray);
				}
			}				
		}
		
		public static function searchFieldData(fieldId:String, valueXml:XML, valueArray:ArrayCollection):void{
			for each(var dataField:XML in valueXml.DataField){
				if(dataField.@id == fieldId && dataField.toString() != ""){
					valueArray.addItem(dataField.toString());
				}
				if(dataField.DataField.toString() != ""){
					searchFieldData(fieldId, dataField, valueArray);
				}
			}				
		}
		
		public static function replaceXml(formField:FormEntity, valueXml:XML, newFormFieldXmlArray:ArrayCollection):void{
			if(formField.parent == null){
				for(var k:int = 0 ; k < XMLList(valueXml.DataField).length() ; k++){
					if(valueXml.DataField[k].@id == formField.id)
						delete valueXml.DataField[k];
				}
				
				for each(var newFormFieldXml:XML in newFormFieldXmlArray){
					valueXml.appendChild(newFormFieldXml);
				}
			}else{
				for(var i:int = 0 ; i < XMLList(valueXml.DataField).length() ; i++){
					for(var j:int = 0 ; j < XMLList(valueXml.DataField).length() ; j++){
						if(valueXml.DataField[i].@id == formField.parent.id)
							if(valueXml.DataField[i].DataField[j].@id == formField.id)
								delete valueXml.DataField[i].DataField[j];
					}
				}
				
				for each(var _newFormFieldXml:XML in newFormFieldXmlArray){
					valueXml.DataField.(@id=formField.parent.id).appendChild(_newFormFieldXml);
				}
			}
		}

	}
}