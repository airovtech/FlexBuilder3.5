package com.maninsoft.smart.formeditor.model.mapping
{
	public class FormMappingFrag
	{
		public static const IMPORT_ACTION:String = "import";
		public static const EXPORT_ACTION:String = "export";
		
		public var mapping:FormMapping;
		
		public var actionType:String;
		public var fromFieldId:String;
		public var fromFieldName:String;
		public var toFieldId:String;
		public var toFieldName:String;
		
//		public function FormMappingFrag(mapping:FormMapping){
//			this.mapping = mapping;
//		}
		
		/**
		 * XML로 바꾸기
		 */
		public function toXML():XML{
			var fragXML:XML = 
				<frag actionType="">
					<fromField id="">
					</fromField>
					<toField id="">
					</toField>
				</frag>;
			
			fragXML.@actionType = actionType;
			fragXML.fromField[0].@id = fromFieldId;
			fragXML.fromField[0] = fromFieldName;
			fragXML.toField[0].@id = toFieldId;
			fragXML.toField[0] = toFieldName;
			
			return fragXML;
		}	
		/**
		 * XML을 객체로 파싱
		 */ 
		public static function parseXML(fragXML:XML):FormMappingFrag{
			var frag:FormMappingFrag = new FormMappingFrag();

			frag.actionType = fragXML.@actionType;
			frag.fromFieldId = fragXML.fromField[0].@id;
			frag.fromFieldName = fragXML.fromField[0].toString();
			frag.toFieldId = fragXML.toField[0].@id;
			frag.toFieldName = fragXML.toField[0].toString();
			
			return frag;
		}
		
		public function getLabel():String{
			return actionType + fromFieldId + fromFieldName + toFieldId + toFieldName;
		}
	}
}