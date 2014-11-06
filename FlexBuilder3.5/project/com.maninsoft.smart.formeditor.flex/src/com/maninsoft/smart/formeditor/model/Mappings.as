package com.maninsoft.smart.formeditor.model
{
	import com.maninsoft.smart.formeditor.refactor.event.FormPropertyEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	public class Mappings
	{
		public var field:FormEntity;
		[Bindable]
		public var inMappings:ArrayCollection = new ArrayCollection();
		[Bindable]
		public var outMappings:ArrayCollection = new ArrayCollection();
		[Bindable]
		public var outConds:Conds = new Conds();
		
		public function Mappings(field:FormEntity){
			this.field = field;
		}
		
		public function addInMapping(mapping:Mapping, index:int = -1):void {
			if(this.inMappings == null || !(this.inMappings.contains(mapping))){
				if (index == -1)
					this.inMappings.addItem(mapping);
				else
					this.inMappings.addItemAt(mapping, index);
					
				if(this.field != null) this.field.dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
			}	
		}
		public function removeInMapping(mapping:Mapping):void {
			if (this.inMappings != null && this.inMappings.contains(mapping)) {
				this.inMappings.removeItemAt(this.inMappings.getItemIndex(mapping));
				
				if(this.field != null) this.field.dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
			}			
		}
		
		public function addOutMapping(mapping:Mapping, index:int = -1):void {
			if (this.outMappings == null || !(this.outMappings.contains(mapping))) {
				if(index == -1)
					this.outMappings.addItem(mapping);
				else
					this.outMappings.addItemAt(mapping, index);
					
				if (this.field != null)
					this.field.dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
			}	
		}
		public function removeOutMapping(mapping:Mapping):void {
			if (this.outMappings != null && this.outMappings.contains(mapping)) {
				this.outMappings.removeItemAt(this.outMappings.getItemIndex(mapping));
				
				if(this.field != null)
					this.field.dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
			}			
		}
		
		/**
		 * XML로 바꾸기
		 */
		public function toXML():XML{
			var mappingsXML:XML = 
				<mappings>
					<pre>
					</pre>
					<post>
					</post>
				</mappings>;
			
			for each(var mapping:Mapping in this.inMappings){
				mappingsXML.pre[0].appendChild(mapping.toXML());
			}
			
			for each(var _mapping:Mapping in this.outMappings){
				mappingsXML.post[0].appendChild(_mapping.toXML());
			}
			
			if(outConds.conds!=null && outConds.conds.length>0)
				mappingsXML.post[0].appendChild(outConds.toXML());
			
			return mappingsXML;
		}	
		/**
		 * XML을 객체로 파싱
		 */ 
		public static function parseXML(field:FormEntity, mappingsXML:XML, ns:Namespace=null):Mappings{
			var mappings:Mappings = new Mappings(field);

			if(ns==null){
				for each(var mappingXml:XML in mappingsXML.pre[0].mapping)
				{
					var formFieldMapping:Mapping = Mapping.parseXML(mappings, mappingXml);
					
				    mappings.addInMapping(formFieldMapping);
				}
				
				for each (var _mappingXml:XML in mappingsXML.post[0].mapping)
				{
					var _formFieldMapping:Mapping = Mapping.parseXML(mappings, _mappingXml);
					
				    mappings.addOutMapping(_formFieldMapping);
				}
	
				if(mappingsXML.post[0].conds != null && mappingsXML.post[0].conds[0] != null)
					mappings.outConds = Conds.parseXML(mappingsXML.post[0].conds[0]);
			}else{
				for each(var xml:XML in mappingsXML.ns::DataMapping)
				{
					var mapping:Mapping = Mapping.parseXML(mappings, xml);
					
				    mappings.addInMapping(mapping);
				}
			}
				
			return mappings;
		}
	}
}