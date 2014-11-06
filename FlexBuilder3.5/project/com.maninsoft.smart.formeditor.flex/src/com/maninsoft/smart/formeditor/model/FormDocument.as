package com.maninsoft.smart.formeditor.model
{
	import com.maninsoft.smart.common.util.SmartUtil;
	import com.maninsoft.smart.formeditor.Config;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridLayout;
	import com.maninsoft.smart.formeditor.layout.grid.util.FormGridUtil;
	import com.maninsoft.smart.formeditor.layout.model.FormLayout;
	import com.maninsoft.smart.formeditor.model.mapping.FormMapping;
	import com.maninsoft.smart.formeditor.refactor.event.FormPropertyEvent;
	import com.maninsoft.smart.formeditor.refactor.simple.navigator.FormItemProxy;
	import com.maninsoft.smart.workbench.common.meta.IFormMetaModel;
	import com.maninsoft.smart.workbench.common.meta.IResourceMetaModel;
	import com.maninsoft.smart.workbench.common.property.IPropertySource;
	import com.maninsoft.smart.workbench.common.property.TextPropertyInfo;
	
	import mx.collections.ArrayCollection;
	import mx.resources.ResourceManager;
	
	public class FormDocument extends AbstractContainerFormResource implements IPropertySource
	{
		public static var ITEM_NAME_PREFIX:String = ResourceManager.getInstance().getString("FormEditorETC", "itemText");
		
		public static const PROP_CELL_SIZE:String = "prop.cell.size";
		public static const PROP_NAME:String = "prop.name";
		public static const PROP_REFFORMID:String = "prop.ref.formId";
		public static const PROP_HEIGHT:String = "prop.height";
		public static const PROP_TITLE_TEXTSTYLE:String = "prop.title.textstyle";
		public static const PROP_CONTENTS_TEXTSTYLE:String = "prop.contents.textstyle";
		public static const PROP_COLOR_BACKGROUND:String = "prop.color.background";
		
		private var _width:Number = 760;
		private var _height:Number = 0;
		private var _widthVar:Number = -1;
		private var _leftSpace:int = 16;
		private var _rightSpace:int = 16;
		private var _topSpace:int = 16;
		private var _bottomSpace:int = (Config.DEFAULT_ROW_HEIGHT+2)* 4;
		private var _currentEntityNum:int = 0;
		private var _currentMappingNum:int = 0;
		[Bindable]
		public var mappings:ArrayCollection = new ArrayCollection();
		private var metaModel:IFormMetaModel;
		private var _formLinks:FormLinks;
		private var _serviceLinks:ServiceLinks;
		
		public function FormDocument() {
			super();
			this._formLinks = new FormLinks(this);
			this._serviceLinks = new ServiceLinks(this);
		}
		
		public function get width():Number{
			return this._width* this.variableRatio + (FormGridLayout(layout).columnLength-1)*2;
		}
		[Bindable] 
		public function set width(width:Number):void{
			this._width = width;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
		}
		public function get height():Number{
			if(this._height==0){
				this._height = FormGridUtil.getFormDocumentHeight(this);
			}
			return this._height;
		}
		[Bindable] 
		public function set height(height:Number):void{
			this._height = height;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
		}
		public function get widthVar():Number{
			return this._widthVar;
		}
		[Bindable] 
		public function set widthVar(widthVar:Number):void{
			this._widthVar = widthVar - rightSpace - leftSpace - (FormGridLayout(layout).columnLength-1)*2;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
		}

		public function get variableRatio():Number{
			if(this._widthVar == -1)
				return 1;
			return (this._widthVar)/this._width;
		}

		public function get leftSpace():int{
			return this._leftSpace;
		}
		[Bindable]
		public function set leftSpace(leftSpace:int):void{
			this._leftSpace = leftSpace;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
		}
		public function get rightSpace():int{
			return this._rightSpace;
		}
		[Bindable]
		public function set rightSpace(rightSpace:int):void{
			this._rightSpace = rightSpace;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
		}
		public function get topSpace():int{
			return this._topSpace;
		}
		[Bindable]
		public function set topSpace(topSpace:int):void{
			this._topSpace = topSpace;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
		}
		public function get bottomSpace():int{
			return this._bottomSpace;
		}
		[Bindable]
		public function set bottomSpace(bottomSpace:int):void{
			this._bottomSpace = bottomSpace;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
		}
		public function get currentEntityNum():int{
			return _currentEntityNum;
		}
		public function set currentEntityNum(currentEntityNum:int):void{
			this._currentEntityNum = currentEntityNum;
		}
		public function get currentMappingNum():int{
			return _currentMappingNum;
		}
		public function set currentMappingNum(currentMappingNum:int):void{
			this._currentMappingNum = currentMappingNum;
		}
		
		public override function get root():FormDocument{
			return this;
		}
		[Bindable]	
		public override function set root(root:FormDocument):void{
		}
		
		public function generateMappingId():String{
			return _currentMappingNum++ + "";
		}
		
		/**
		 * 맵핑
		 **/
		public function addFormMapping(mapping:FormMapping, index:int = -1):void{
			if(this.mappings == null || !(this.mappings.contains(mapping))){
				if(index == -1)
					this.mappings.addItem(mapping);
				else
					this.mappings.addItemAt(mapping, index);
				dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
			}
		}
		public function removeFormMapping(mapping:FormMapping):void{
			if(this.mappings != null && this.mappings.contains(mapping)){
				this.mappings.removeItemAt(this.mappings.getItemIndex(mapping));
				dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
			}
		}
		
		/**
		 * 메타모델 관련
		 */
		public function getResourceMetaModel():IResourceMetaModel {
			return this.metaModel;
		}
		public function setResourceMetaModel(metaModel:IResourceMetaModel):void {
			this.metaModel = IFormMetaModel(metaModel);
		}
		
		public function get formLinks():FormLinks {
			return this._formLinks;
		}
		public function set formLinks(formLinks:FormLinks):void {
			this._formLinks = formLinks;
			formLinks.form = this;
		}
		
		public function get serviceLinks():ServiceLinks {
			return this._serviceLinks;
		}
		public function set serviceLinks(serviceLinks:ServiceLinks):void {
			this._serviceLinks = serviceLinks;
			serviceLinks.form = this;
		}
		
		public function generateEntityId():String {
			return _currentEntityNum++ + "";
		}
		
		/**
		 * XML로 바꾸기
		 */
		public function toXML():XML{
			var xml:XML = 
				<form>
					<children/>
				</form>;
			
			if (!SmartUtil.isEmpty(id))
				xml.@id = id;
			xml.@version = 1;
			if (!SmartUtil.isEmpty(name))
				xml.@name = name;
			
			for each (var child:FormEntity in this.children) {
				if (child is FormItemProxy)
					continue;
				xml.children[0].appendChild(child.toXML());
			}
			
			xml.appendChild(formLinks.toXML());

			xml.appendChild(serviceLinks.toXML());

			xml.appendChild(layout.toXML());
			
			xml.appendChild(<graphic><space/></graphic>);
			
			xml.graphic[0].@width = width;
			xml.graphic[0].@height = height;
			xml.graphic[0].@currentEntityNum = currentEntityNum;
			xml.graphic[0].@currentMappingNum = currentMappingNum;
			return xml;
		}
		/**
		 * XML을 객체로 파싱
		 */ 
		public static function parseXML(xml:XML):FormDocument{
			var model:FormDocument = new FormDocument();
			
			if(xml.hasOwnProperty("@id")){
				model.id = xml.@id;
				model.name = xml.@name;
	
//				model.width = new int(xml.graphic[0].@width);
//				model.height = new int(xml.graphic[0].@height);
				model.currentEntityNum = new int(xml.graphic[0].@currentEntityNum);
				if(xml.graphic[0].attribute("currentMappingNum").toString() != "")
					model.currentMappingNum = new int(xml.graphic[0].@currentMappingNum);
				for each (var childXML:XML in xml.children[0].formEntity)
					model.addField(FormEntity.parseXML(childXML, model, null));
				
				if (xml.mappings[0] != null) {
					for each (var mappingXML:XML in xml.mappings[0].mapping) {
						model.addFormMapping(FormMapping.parseXML(model, mappingXML));
					}
				}
				
				if (xml.layout[0] != null) {
					if(FormLayout.ABSOLUTE == xml.layout[0].@type){
						model.layoutType = FormLayout.ABSOLUTE;
					}else if(FormLayout.AUTO == xml.layout[0].@type){
						model.layoutType = FormLayout.AUTO;
					}else{
						model.layoutType = FormLayout.GRID;
					}
					model.layout = FormLayout.parseXML(xml.layout[0]);
					
					model.layout.container = model;

					model.width = FormGridLayout(model.layout).layoutFixedWidth + 10;
				}
				
				if (xml.mappingForms[0] != null)
					model.formLinks = FormLinks.parseXML(model, xml.mappingForms[0]);

				if (xml.mappingServices[0] != null)
					model.serviceLinks = ServiceLinks.parseXML(model, xml.mappingServices[0]);
			}
			
			return model;
		}

		/**
		 *  IPropertySource Implements
		 */
		public function get displayName(): String{
			return this.name;
		}
		
		public function getPropertyInfos(): Array{
			var props: Array = [];
			return props.concat(new TextPropertyInfo(PROP_NAME, resourceManager.getString("FormEditorETC", "itemNameText")));
		}
		
		public function refreshPropertyInfos(): Array{
			return getPropertyInfos();
		}

		public function getPropertyValue(id: String): Object{			
			switch(id){
				case PROP_NAME:
					return this.name;					
				default:
					return null;				
			}
		}
		
		public function setPropertyValue(id: String, value: Object): void{
			switch(id){
				case PROP_NAME:
					this.name = value.toString();
					break;					
				default:
					break;
			}
			
		}
		
		public function isPropertySet(id: String): Boolean{
			if( PROP_NAME == id)
				return true;
			return false;
		}
		
		public function isPropertyResettable(id: String): Boolean{
			return false;
		}
		
		public function resetPropertyValue(id: Object): void{
			
		}
	}
}