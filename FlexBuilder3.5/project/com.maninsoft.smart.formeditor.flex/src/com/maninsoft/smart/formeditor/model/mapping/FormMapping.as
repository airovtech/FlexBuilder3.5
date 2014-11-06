package com.maninsoft.smart.formeditor.model.mapping
{
	import com.maninsoft.smart.formeditor.model.FormDocument;
	import com.maninsoft.smart.formeditor.model.condition.FormCondition;
	
	import mx.collections.ArrayCollection;
	
	public class FormMapping
	{
		public static const PROCESS_TYPE:String = "process";
		public static const WORK_TYPE:String = "work";
		
		public var formDocument:FormDocument;
		
		public var id:String;
		public var type:String;
		
		public var targetFormId:String;
		public var targetFormVersion:int;
		public var targetFormName:String;
		
		public function FormMapping(formDocument:FormDocument){
			this.formDocument = formDocument;	
			
			this.id = this.formDocument.generateEntityId();
		}
		
		[Bindable]
		public var conditions:ArrayCollection = new ArrayCollection();
		
		public function addCondition(condition:FormCondition, index:int = -1):void{
			if(this.conditions == null || !(this.conditions.contains(condition))){
				if(index == -1)
					this.conditions.addItem(condition);
				else
					this.conditions.addItemAt(condition, index);
			}	
		}

		public function removeCondition(condition:FormCondition):void{
			if(this.conditions != null && this.conditions.contains(condition)){
				this.conditions.removeItemAt(this.conditions.getItemIndex(condition));
			}			
		}
		
		[Bindable]
		public var frags:ArrayCollection = new ArrayCollection();
		
		public function addFragment(frag:FormMappingFrag, index:int = -1):void{
			if(this.frags == null || !(this.frags.contains(frag))){
				if(index == -1)
					this.frags.addItem(frag);
				else
					this.frags.addItemAt(frag, index);
			}	
		}

		public function removeFragment(frag:FormMappingFrag):void{
			if(this.frags != null && this.frags.contains(frag)){
				this.frags.removeItemAt(this.frags.getItemIndex(frag));
			}			
		}
		
		/**
		 * XML로 바꾸기
		 */
		public function toXML():XML{
			var mappingXML:XML = 
				<mapping id="" type="">
					<target id="" version="">
					</target>
					<conditions></conditions>
					<fragments></fragments>
				</mapping>;
			
			mappingXML.@id = id;
			mappingXML.@type = type;
			
			mappingXML.target[0].@id = targetFormId;
			mappingXML.target[0].@version = targetFormVersion;
			mappingXML.target[0] = targetFormName;
			
			for each(var cond:FormCondition in this.conditions){
				mappingXML.conditions[0].appendChild(cond.toXML());
			}
			
			for each(var frag:FormMappingFrag in this.frags){
				mappingXML.fragments[0].appendChild(frag.toXML());
			}
			
			return mappingXML;
		}	
		/**
		 * XML을 객체로 파싱
		 */ 
		public static function parseXML(formDocument:FormDocument, mappingXML:XML):FormMapping{
			var mapping:FormMapping = new FormMapping(formDocument);

			mapping.id = mappingXML.@id;
			mapping.type = mappingXML.@type;
			
			mapping.targetFormId = mappingXML.target[0].@id;
			mapping.targetFormVersion = mappingXML.target[0].@version;
			mapping.targetFormName = mappingXML.target[0].toString();
			
			for each(var condXml:XML in mappingXML.conditions[0].cond)
			{
			    mapping.addCondition(FormCondition.parseXML(condXml));
			}

			for each(var fragXml:XML in mappingXML.fragments[0].frag)
			{
			    mapping.addFragment(FormMappingFrag.parseXML(fragXml));
			}
			return mapping;
		}	
	}
}