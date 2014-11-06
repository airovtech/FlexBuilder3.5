/**
 * 
 *  Package: 		com.maninsoft.smart.formeditor.model
 *  Interface: 		FormEntity
 * 					extends AbstractContainerFormResource 
 * 					implements None
 *  Author:			Maninsoft, Inc.
 *  Description:	Form Editor에서 Form Grid에서 하나의 항목을 표현하는 FormEntity에 관한 모델 클래
 * 				
 *  History:		Created by Maninsoft, Inc.
 * 					2010.2.26 Modified by Y.S. Jung for 스펠링수정 *childern* --> *children*
 * 					2010.2.26 Modified by Y.S. Jung for SWV20003: 폼에디터에 이미지를 보여주는 항목 추가
 * 
 *  Copyright (C) 2007-2010 Maninsoft, Inc. All Rights Reserved.
 *  
 */

package com.maninsoft.smart.formeditor.model
{
	import com.maninsoft.smart.common.util.SmartUtil;
	import com.maninsoft.smart.formeditor.model.property.AutoIndexPropertyInfo;
	import com.maninsoft.smart.formeditor.model.property.CheckBoxConditionPropertyInfo;
	import com.maninsoft.smart.formeditor.model.property.CurrencyPropertyInfo;
	import com.maninsoft.smart.formeditor.model.property.FormFormatInfo;
	import com.maninsoft.smart.formeditor.model.property.FormFormatPropertyInfo;
	import com.maninsoft.smart.formeditor.model.property.FormItemType;
	import com.maninsoft.smart.formeditor.model.property.FormatListPropertyInfo;
	import com.maninsoft.smart.formeditor.model.property.RefFormFieldIdPropertyInfo;
	import com.maninsoft.smart.formeditor.model.property.RefFormIdPropertyInfo;
	import com.maninsoft.smart.formeditor.model.type.CurrencyType;
	import com.maninsoft.smart.formeditor.model.type.CurrencyTypes;
	import com.maninsoft.smart.formeditor.model.type.FormatType;
	import com.maninsoft.smart.formeditor.model.type.FormatTypes;
	import com.maninsoft.smart.formeditor.refactor.event.FormPropertyEvent;
	import com.maninsoft.smart.formeditor.util.FormEditorService;
	import com.maninsoft.smart.workbench.common.property.CheckBoxPropertyInfo;
	import com.maninsoft.smart.workbench.common.property.ColorPropertyInfo;
	import com.maninsoft.smart.workbench.common.property.FontSizePropertyInfo;
	import com.maninsoft.smart.workbench.common.property.FontWeightPropertyInfo;
	import com.maninsoft.smart.workbench.common.property.IPropertySource;
	import com.maninsoft.smart.workbench.common.property.ListDataPropertyInfo;
	import com.maninsoft.smart.workbench.common.property.TextAlignPropertyInfo;
	import com.maninsoft.smart.workbench.common.property.TextPropertyInfo;
	import com.maninsoft.smart.workbench.common.util.StringUtils;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	
	public class FormEntity extends AbstractContainerFormResource implements IPropertySource
	{
		public static const PROP_NAME:String = "prop.name";
		public static const PROP_TEXTALIGN:String = "prop.textalign";
		
		public static const PROP_HIDDEN_USE:String = "prop.hidden.use";
		public static const PROP_READONLY_USE:String = "prop.readonly.use";
		public static const PROP_REQUIRED_USE:String = "prop.required.use";

		public static const PROP_HIDDEN_USE_CONDITION:String = "prop.hidden.use.condition";
		public static const PROP_READONLY_USE_CONDITION:String = "prop.readonly.use.condition";
		public static const PROP_REQUIRED_USE_CONDITION:String = "prop.required.use.condition";
		
		public static const PROP_LABEL_USE:String = "prop.label.use";
		public static const PROP_LABEL_LOC:String = "prop.label.loc";
		
		public static const PROP_FORMAT:String = "prop.format";
		public static const PROP_REFFORM_FIELDID:String = "prop.refForm.fieldId";
		
		public static const PROP_CELL_SIZE:String = "prop.cell.size";
		
		public static const PROP_LABEL_WIDTH:String = "prop.label.width";
		public static const PROP_CONTENT_WIDTH:String = "prop.contents.width";
		public static const PROP_HEIGHT:String = "prop.height";
		
		public static const PROP_FITWIDTH:String = "prop.fitWidth";
		public static const PROP_VERTICALSCROLLPOLICY:String = "prop.verticalScrollPolicy";
		
		public static const PROP_TOOLTIP:String = "prop.toolTip";
		public static const PROP_MULTIPLE_USERS:String = "prop.multipleUsers";
		public static const PROP_LIST_EDITABLE:String = "prop.listEditable";
		public static const PROP_AUTOINDEX:String = "prop.autoIndex";
		
		public static const PROP_FONTWEIGHT:String = "prop.fontWeight";
		public static const PROP_FONTSIZE:String = "prop.fontSize";
		public static const PROP_TEXTCOLOR:String = "prop.textColor";
		

		/**
		 * 2010.2.26 Added by Y.S. Jung for SWV20003: 폼에디터에 이미지를 보여주는 항목 추가
		 * 이미지박스에만 필요한 속성인 화면에맞게 이미지를 늘리기에대한 변수를 추가합니다.
		 */
		public static const PROP_FIT_TO_SCREEN:String = "prop.fitToScreen";

		public static const PROP_EXPRESSION:String = "prop.expr";
		public static const PROP_TYPE:String = "prop.type";
		
		public static const PROP_TITLE_TEXTSTYLE:String = "prop.title.textstyle";
		public static const PROP_CONTENTS_TEXTSTYLE:String = "prop.contents.textstyle";
		
		public static const PROP_COLOR_BACKGROUND:String = "prop.color.background";
		
		public static const EMPTY_FORMID: String = "EmptyForm";
		public static var EMPTY_FORMNAME: String = ResourceManager.getInstance().getString("FormEditorETC", "emptyFormText");
		public static const EMPTY_FORM_FIELDID: String = "EmptyFormField";
		public static var EMPTY_FORM_FIELDNAME: String = ResourceManager.getInstance().getString("FormEditorETC", "emptyFormFieldNameText");
		

		private var _hidden:Boolean = false;
		private var _readOnly:Boolean = false;
		private var _required:Boolean = false;
		// 시스템 필드 여부 
		private var _system:Boolean = false;
		private var _format:FormFormatInfo = new FormFormatInfo();
		// 아이템이 텍스트등으로 표시될때 나타내는 서식
		private var _type:FormItemType = new FormItemType();
		private var _labelVisible:Boolean = true;
		// 아이템의 값 표현식
		private var _expression:String = "";
		
		private var _cellSize:int = 1;
		private var _labelWidth:int = -1;
		private var _contentWidth:int = -1;
		private var _height:int = -1;
		private var _fitWidth:Boolean = false;
		private var _verticalScroll:Boolean = true;
		private var _textAlign:String = "left";
		private var _fontWeight:String = "bold";
		private var _textColor:String = "23579e";
		private var _fontSize:String = "12";
		/**
		 * 2010.2.26 Added by Y.S. Jung for SWV20003: 폼에디터에 이미지를 보여주는 항목 추가
		 * 이미지박스에만 필요한 속성인 화면에맞게 이미지를 늘리기에대한 변수를 추가합니다.
		 */
		private var _fitToScreen:Boolean = false;
		private var _toolTip:String = "";
		private var _multipleUsers:Boolean = false;
		private var _listEditable:Boolean = false;

		// null 아이템 표시
		private var _isNull:Boolean;
		private var _mappings:Mappings;
		
		private var _hiddenConditions:Conds = new Conds();
		private var _readOnlyConditions:Conds = new Conds();
		private var _requiredConditions:Conds = new Conds();
										
		public function FormEntity(root:FormDocument, id:String = null){
			this.root = root;
			
			super();
			
			if(id == null)
				this.id = this.root.generateEntityId();
			else 
				this.id = id;
			
			this.titleTextStyle.size = "14";
			this.titleTextStyle.font = "Tahoma";
			
			this.contentsTextStyle.size = "12";
			this.contentsTextStyle.font = "Tahoma";
			
			this.mappings = new Mappings(this);
		}
		
		public function get hidden():Boolean {
			return this._hidden;
		}
		[Bindable]	
		public function set hidden(hidden:Boolean):void {
			this._hidden = hidden;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
		}
		public function get readOnly():Boolean {
			return this._readOnly;
		}
		[Bindable]	
		public function set readOnly(readOnly:Boolean):void {
			this._readOnly = readOnly;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
		}
		public function get format():FormFormatInfo {
			return this._format;
		}
		[Bindable]	
		public function set format(format:FormFormatInfo):void {
			this._format = format;
			if(this._format.type == FormatTypes.dataGrid.type)
				refreshChildren();
			if(format.refFormId && !format.formRef){
				FormEditorService.getFormRef(format.refFormId, formRefCallback);
				if(format.refFormFieldId && !format.refFormFieldName){
					FormEditorService.getFieldNameByFieldId(format.refFormId, format.refFormFieldId, formFieldNameCallback);
				}
			}else{	
				dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_STRUCTURE));
			}
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
		}
		
		private function formRefCallback(formRef:FormRef):void{
			this._format.formRef = formRef;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_STRUCTURE));
		}
		
		private function formFieldNameCallback(refFormFieldName:String):void{
			this._format.refFormFieldName = refFormFieldName;
		}
		
		public function get type():FormItemType {
			return this._type;
		}
		[Bindable]	
		public function set type(type:FormItemType):void {
			this._type = type;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
		}
		public function get labelVisible():Boolean {
			return this._labelVisible;
		}
		[Bindable]	
		public function set labelVisible(labelVisible:Boolean):void {
			this._labelVisible = labelVisible;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
		}
		public function get expression():String {
			return this._expression;
		}
		[Bindable]	
		public function set expression(expression:String):void {
			this._expression = expression;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
		}
		public function get cellSize():int {
			return this._cellSize;
		}
		[Bindable]	
		public function set cellSize(_cellSize:int):void {
			this._cellSize = _cellSize;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_STRUCTURE));
		}
		public function get labelWidth():int {
			if(this._labelWidth == -1) return FormatTypes.getFormatType(this.format.type, false).labelWidth*root.variableRatio;
			return this._labelWidth*root.variableRatio;
		}
		[Bindable]
		public function set labelWidth(labelWidth:int):void {
			this._labelWidth = labelWidth/root.variableRatio;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_STRUCTURE));
		}
		public function get contentWidth():int {
			if(this._contentWidth == -1) 
				return FormatTypes.getFormatType(this.format.type, false).contentWidth*root.variableRatio;
			return this._contentWidth*root.variableRatio;
		}
		[Bindable]	
		public function set contentWidth(contentWidth:int):void {
			this._contentWidth = contentWidth/root.variableRatio;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_STRUCTURE));
		}
		public function get height():int {
			if(this._height == -1) return FormatTypes.getFormatType(this.format.type, false).height;
			return this._height;
		}
		[Bindable]	
		public function set height(height:int):void {
			this._height = height;
//			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_STRUCTURE));
		}
		public function get textAlign():String {
			return _textAlign;
		}
		[Bindable]
		public function set textAlign(value:String):void {
			_textAlign = value;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
		}
		public function get fontWeight():String {
			return _fontWeight;
		}
		[Bindable]
		public function set fontWeight(value:String):void {
			_fontWeight = value;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
		}
		public function get textColor():String {
			return _textColor;
		}
		[Bindable]
		public function set textColor(value:String):void {
			_textColor = value;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
		}
		public function get fontSize():String {
			return _fontSize;
		}
		[Bindable]
		public function set fontSize(value:String):void {
			_fontSize = value;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
		}
		public function get required():Boolean {
			return this._required;
		}
		[Bindable]	
		public function set required(required:Boolean):void {
			this._required = required;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
		}
		public function get system():Boolean {
			return this._system;
		}
		[Bindable]	
		public function set system(system:Boolean):void {
			this._system = system;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
		}
		public function get systemType():String {
			if(this.children != null && this.children.length > 0){
				return "complex";
			}
			return FormatTypes.getFormatType(this.format.type, false).systemType;
		}
		public function get fitWidth():Boolean {
			return _fitWidth;
		}
		[Bindable]
		public function set fitWidth(fitWidth:Boolean):void {
			this._fitWidth = fitWidth;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
		}
		public function get verticalScroll():Boolean {
			return _verticalScroll;
		}
		[Bindable]
		public function set verticalScroll(verticalScroll:Boolean):void {
			this._verticalScroll = verticalScroll;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
		}

		/**
		 * 2010.2.26 Added by Y.S. Jung for SWV20003: 폼에디터에 이미지를 보여주는 항목 추가
		 * 이미지박스에만 필요한 속성인 화면에맞게 이미지를 늘리기에대한 변수를 추가합니다.
		 */
		public function get fitToScreen():Boolean {
			return _fitToScreen;
		}
		[Bindable]
		public function set fitToScreen(fitToScreen:Boolean):void {
			this._fitToScreen = fitToScreen;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
		}

		public function get toolTip():String {
			return _toolTip;
		}
		[Bindable]
		public function set toolTip(toolTip: String):void {
			this._toolTip = toolTip;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
		}

		public function get multipleUsers():Boolean {
			return _multipleUsers;
		}
		[Bindable]
		public function set multipleUsers(multipleUsers: Boolean):void {
			this._multipleUsers = multipleUsers;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
		}

		public function get listEditable():Boolean {
			return _listEditable;
		}
		[Bindable]
		public function set listEditable(listEditable: Boolean):void {
			this._listEditable = listEditable;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
		}

		public function get isNull():Boolean {
			return this._isNull;
		}
		[Bindable]	
		public function set isNull(isNull:Boolean):void {
			this._isNull = isNull;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_INFO));
		}
		public function get mappings():Mappings {
		    return this._mappings;
		}
		[Bindable]
		public function set mappings(mappings:Mappings):void {
		    this._mappings = mappings;
		    mappings.field = this;
		}
		public override function get children():ArrayCollection {
			if(this.format.type == FormatTypes.dataGrid.type){
				return super.children;
			}else{
				return new ArrayCollection();
			}
			
		}
		public override function set children(children:ArrayCollection):void{
			super.children = children;
			dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_STRUCTURE));
		}
		
		public function get hiddenConditions():Conds {
		    return this._hiddenConditions;
		}
		[Bindable]
		public function set hiddenConditions(hiddenConditions:Conds):void {
		    this._hiddenConditions = hiddenConditions;
		}
		
		public function get readOnlyConditions():Conds {
		    return this._readOnlyConditions;
		}
		[Bindable]
		public function set readOnlyConditions(readOnlyConditions:Conds):void {
		    this._readOnlyConditions = readOnlyConditions;
		}
		
		public function get requiredConditions():Conds {
		    return this._requiredConditions;
		}
		[Bindable]
		public function set requiredConditions(requiredConditions:Conds):void {
		    this._requiredConditions = requiredConditions;
		}
		
		/**
		 * 현재 아이템까지 경로를 문자열로 반환(구분자는 /))
		 **/
		public function getPath():String{
			if(this.parent == null){
				return "/" + this.name;
			}else{
				return parent.getPath() + "/" + this.name; 	
			}		
		}	
		/**
		 * 아이콘 이미지 반환
		 */
		public override function get icon():Class {
			return FormatTypes.getIcon(this.format.type);
		}
		
		/**
		 * XML로 변환
		 */
		public function toXML():XML{
			var xml:XML = 
				<formEntity>
					<children/>
				</formEntity>;
			
			if (!SmartUtil.isEmpty(id))
				xml.@id = id;
			if (!SmartUtil.isEmpty(name))
				xml.@name = name;
			if (!SmartUtil.isEmpty(systemType))
				xml.@systemType = systemType;	
			xml.@required = (required)? "true":"false";
			xml.@system = (system)? "true":"false";
			if (!SmartUtil.isEmpty(systemName))
				xml.@systemName = systemName;

			if(!SmartUtil.isEmpty(toolTip))
				xml.@toolTip = toolTip;
			
			if (!SmartUtil.isEmpty(children)) {
				for each (var child:FormEntity in this.children)
					xml.children[0].appendChild(child.toXML());
			}
			
			if (!SmartUtil.isEmpty(expression))
				xml.expression = expression;
			
			if (mappings != null && (!SmartUtil.isEmpty(mappings.inMappings) || !SmartUtil.isEmpty(mappings.outMappings)))
				xml.appendChild(mappings.toXML());
			
			xml.appendChild(format.toXML());

			xml.appendChild(<graphic/>);
			xml.graphic[0].@hidden = hidden;
			xml.graphic[0].@readOnly = readOnly;
			if (labelWidth > 0)
				xml.graphic[0].@labelWidth = labelWidth;
			if (contentWidth > 0)
				xml.graphic[0].@contentWidth = contentWidth;
			if (height > 0)
				xml.graphic[0].@height = height;
			if (cellSize > 0)
				xml.graphic[0].@cellSize = cellSize;
			
			xml.graphic[0].@fitWidth = fitWidth;
			xml.graphic[0].@verticalScroll = verticalScroll;
			xml.graphic[0].@textAlign = textAlign;
			xml.graphic[0].@fitToScreen = fitToScreen;
			xml.graphic[0].@listEditable = listEditable;
			xml.graphic[0].@multipleUsers = multipleUsers;
			xml.graphic[0].@textAlign = textAlign;
			xml.graphic[0].@fontWeight = fontWeight;
			xml.graphic[0].@textColor = textColor;
			xml.graphic[0].@fontSize = fontSize;
			
			
			if(hiddenConditions != null && !SmartUtil.isEmpty(hiddenConditions.conds)){
				xml.appendChild(<hiddenConditions/>);
				xml.hiddenConditions[0].appendChild(hiddenConditions.toXML());
			}
			if(readOnlyConditions != null && !SmartUtil.isEmpty(readOnlyConditions.conds)){
				xml.appendChild(<readOnlyConditions/>);
				xml.readOnlyConditions[0].appendChild(readOnlyConditions.toXML());
			}
			if(requiredConditions != null && !SmartUtil.isEmpty(requiredConditions.conds)){
				xml.appendChild(<requiredConditions/>);
				xml.requiredConditions[0].appendChild(requiredConditions.toXML());
			}
			
			return xml;
		}	
		/**
		 * XML을 객체로 생성
		 */
		public static function parseXML(xml:XML, root:FormDocument, parent:FormEntity = null):FormEntity{
			var model:FormEntity = new FormEntity(root, xml.@id);
			
			model.parent = parent;
			
			model.name = xml.@name;
			model.required = xml.@required == "true";
			model.system = xml.@system == "true";
			model.systemName = xml.@systemName;
			model.toolTip = xml.@toolTip;
			
			var graphic:Object = xml.graphic[0];
			if (graphic != null) {
				model.hidden = graphic.@hidden == "true";
				model.readOnly = graphic.@readOnly == "true";
				
				if (graphic.label[0] == null) {
					model.labelVisible = SmartUtil.toBoolean(graphic.@labelVisible, model.labelVisible);
					model.labelWidth = SmartUtil.toNumber(graphic.@labelWidth, model.labelWidth);
				} else {
					var label:Object = graphic.label[0];
					model.labelVisible = SmartUtil.toBoolean(label.@visible, model.labelVisible);
					model.labelWidth = SmartUtil.toNumber(label.@size, model.labelWidth);
				}
				if (!SmartUtil.isEmpty(graphic.@contentWidth) && graphic.@contentWidth > 0) {
					model.contentWidth = graphic.@contentWidth
				} else if (!SmartUtil.isEmpty(graphic.@contentsSize) && graphic.@contentsSize > 0) {
					model.contentWidth = graphic.@contentsSize
				}
				if (!SmartUtil.isEmpty(graphic.@height) && graphic.@height > 0)	
					model.height = graphic.@height;
				if (!SmartUtil.isEmpty(graphic.@cellSize) && graphic.@cellSize > 0)
					model.cellSize = graphic.@cellSize;
				
				model.fitWidth = graphic.@fitWidth == "true";
				model.verticalScroll = graphic.@verticalScroll == "true";
				if (!SmartUtil.isEmpty(graphic.@textAlign))
					model.textAlign = graphic.@textAlign;
				if (!SmartUtil.isEmpty(graphic.@fontWeight))
					model.fontWeight = graphic.@fontWeight;
				if (!SmartUtil.isEmpty(graphic.@textColor))
					model.textColor = graphic.@textColor;
				if (!SmartUtil.isEmpty(graphic.@fontSize))
					model.fontSize = graphic.@fontSize;
				model.fitToScreen = graphic.@fitToScreen == "true";
				model.listEditable = graphic.@listEditable == "true";
				model.multipleUsers = graphic.@multipleUsers == "true";
			}
			if (xml.expression != null)
				model.expression = xml.expression.toString();

			if(xml.format[0] != null)
				model.format = FormFormatInfo.parseXML(xml.format[0]);
			
			
			for each (var childXML:XML in xml.children.formEntity)
			    model.addField(FormEntity.parseXML(childXML, root, model));
			
			try{
				if(xml.mappings != null)
					model.mappings = Mappings.parseXML(model, xml.mappings[0]);	
			}catch(e:Error){}
			
			try{
				if(xml.hiddenConditions[0] != null)
					model.hiddenConditions = Conds.parseXML(xml.hiddenConditions[0].conds[0]);
			}catch(e:Error){}
			try{
				if(xml.readOnlyConditions[0] != null)
					model.readOnlyConditions = Conds.parseXML(xml.readOnlyConditions[0].conds[0]);	
			}catch(e:Error){}
			try{
				if(xml.requiredConditions[0] != null)
					model.requiredConditions = Conds.parseXML(xml.requiredConditions[0].conds[0]);	
			}catch(e:Error){
				
			}
			
			return model;
		}
		
		/**
		 *  IPropertySource Implements
		 */
		public function get displayName(): String{
			return this.format.type;
		}
		
		public function getPropertyInfos(): Array{
			var props: Array;
			if(this.format.type == FormatTypes.label.type){
				props=[new TextPropertyInfo(PROP_NAME, resourceManager.getString("FormEditorETC", "itemNameText")),
					 new FormFormatPropertyInfo(PROP_TYPE, resourceManager.getString("FormEditorETC", "formatTypeText"),
					 							null, null, false, null, FormatTypes.getEnableFormatTypeArray(this)),
					 new CheckBoxConditionPropertyInfo(PROP_HIDDEN_USE, resourceManager.getString("FormEditorETC", "hiddenItemText"))];
			}else if(!this.parent){
				if(this.format.type == FormatTypes.dataGrid.type){			
					props=[new TextPropertyInfo(PROP_NAME, resourceManager.getString("FormEditorETC", "itemNameText")),
						 new FormFormatPropertyInfo(PROP_TYPE, resourceManager.getString("FormEditorETC", "formatTypeText"),
						 							null, null, false, null, FormatTypes.getEnableFormatTypeArray(this)),
						 new CheckBoxConditionPropertyInfo(PROP_HIDDEN_USE, resourceManager.getString("FormEditorETC", "hiddenItemText")),
						 new CheckBoxConditionPropertyInfo(PROP_READONLY_USE, resourceManager.getString("FormEditorETC", "readOnlyItemText")),
						 new CheckBoxConditionPropertyInfo(PROP_REQUIRED_USE, resourceManager.getString("FormEditorETC", "requiredItemText"))];
				}else{
					props=[new TextPropertyInfo(PROP_NAME, resourceManager.getString("FormEditorETC", "itemNameText")),
						 new TextPropertyInfo(PROP_TOOLTIP, resourceManager.getString("FormEditorETC", "itemToolTipText")),	
						 new FormFormatPropertyInfo(PROP_TYPE, resourceManager.getString("FormEditorETC", "formatTypeText"),
						 							null, null, false, null, FormatTypes.getEnableFormatTypeArray(this)),
						 new CheckBoxConditionPropertyInfo(PROP_HIDDEN_USE, resourceManager.getString("FormEditorETC", "hiddenItemText")),
						 new CheckBoxConditionPropertyInfo(PROP_READONLY_USE, resourceManager.getString("FormEditorETC", "readOnlyItemText")),
						 new CheckBoxConditionPropertyInfo(PROP_REQUIRED_USE, resourceManager.getString("FormEditorETC", "requiredItemText"))];					
				}
			}else{
				props=[new TextPropertyInfo(PROP_NAME, resourceManager.getString("FormEditorETC", "itemNameText")),
					 new TextPropertyInfo(PROP_TOOLTIP, resourceManager.getString("FormEditorETC", "itemToolTipText")),
					 new FormFormatPropertyInfo(PROP_TYPE, resourceManager.getString("FormEditorETC", "formatTypeText"),
					 							null, null, false, null, FormatTypes.getDataGridFormatTypeArray()),
					 new CheckBoxConditionPropertyInfo(PROP_HIDDEN_USE, resourceManager.getString("FormEditorETC", "hiddenItemText")),
					 new CheckBoxConditionPropertyInfo(PROP_READONLY_USE, resourceManager.getString("FormEditorETC", "readOnlyItemText")),
					 new CheckBoxConditionPropertyInfo(PROP_REQUIRED_USE, resourceManager.getString("FormEditorETC", "requiredItemText"))];
			}
			
			switch(this.format.type){
				case FormatTypes.currencyInput.type:
					return props.concat(new CurrencyPropertyInfo(PROP_FORMAT, resourceManager.getString("FormEditorETC", "currencyMarkText"), null, null, false));

				case FormatTypes.imageBox.type:
					return props.concat(new CheckBoxPropertyInfo(PROP_FIT_TO_SCREEN, resourceManager.getString("FormEditorETC", "fitToScreenText")));

				case FormatTypes.comboBox.type:
					return props.concat(
						new CheckBoxPropertyInfo(PROP_LIST_EDITABLE, resourceManager.getString("FormEditorETC", "listEditableText")),
						new ListDataPropertyInfo(PROP_FORMAT, resourceManager.getString("FormEditorETC", "comboListText"), null, null, true));
				case FormatTypes.radioButton.type:
					return props.concat(new ListDataPropertyInfo(PROP_FORMAT, resourceManager.getString("FormEditorETC", "comboListText"), null, null, true));
					
				case FormatTypes.refFormField.type:
					return props.concat(
						new RefFormIdPropertyInfo(PROP_FORMAT, resourceManager.getString("FormEditorETC", "refWorkNameText"), null, null, false),
						new RefFormFieldIdPropertyInfo(PROP_REFFORM_FIELDID, resourceManager.getString("FormEditorETC", "refWorkFieldIdText"), null, null, false));

				case FormatTypes.dataGrid.type:
					return props.concat(
						new CheckBoxPropertyInfo(PROP_FITWIDTH, resourceManager.getString("FormEditorETC", "fitToWidthText")),
						new CheckBoxPropertyInfo(PROP_VERTICALSCROLLPOLICY, resourceManager.getString("FormEditorETC", "verticalScrollText")),
						new FormatListPropertyInfo(PROP_FORMAT, resourceManager.getString("FormEditorETC", "comboListText"), null, null, true));
				case FormatTypes.userField.type:
					return props.concat(
						new CheckBoxPropertyInfo(PROP_MULTIPLE_USERS, resourceManager.getString("FormEditorETC", "multipleUsersText")));
				case FormatTypes.autoIndex.type:
					return props.concat(
						new AutoIndexPropertyInfo(PROP_AUTOINDEX, resourceManager.getString("FormEditorETC", "autoIndexRuleText"), null, null, true));
				case FormatTypes.label.type:
					return props.concat(
						new TextAlignPropertyInfo(PROP_TEXTALIGN, resourceManager.getString("FormEditorETC", "textAlignText")),
						new FontWeightPropertyInfo(PROP_FONTWEIGHT, resourceManager.getString("FormEditorETC", "fontWeightText")),
						new FontSizePropertyInfo(PROP_FONTSIZE, resourceManager.getString("FormEditorETC", "fontSizeText")),
						new ColorPropertyInfo(PROP_TEXTCOLOR, resourceManager.getString("FormEditorETC", "textColorText"), null, null, false));
				default:
					return props;
			}
		}

		public function refreshPropertyInfos(): Array{
			return getPropertyInfos();
		}
		
		public function getPropertyValue(id: String): Object{			
			switch(id){
				case PROP_NAME:
					return this.name;					
				case PROP_TOOLTIP:
					return this.toolTip;					
				case PROP_HIDDEN_USE:
					return this.hidden;
				case PROP_READONLY_USE:
					return this.readOnly;
				case PROP_REQUIRED_USE:
					return this.required;
				case PROP_HIDDEN_USE_CONDITION:
					return this.hiddenConditions;
				case PROP_READONLY_USE_CONDITION:
					return this.readOnlyConditions;
				case PROP_REQUIRED_USE_CONDITION:
					return this.requiredConditions;
				case PROP_TYPE:
					return getFormatType(this.format.type);
				case PROP_FITWIDTH:
					return this.fitWidth;
				case PROP_VERTICALSCROLLPOLICY:
					return this.verticalScroll;
				case PROP_FIT_TO_SCREEN:
					return this.fitToScreen;
				case PROP_LIST_EDITABLE:
					return this.listEditable;
				case PROP_MULTIPLE_USERS:
					return this.multipleUsers;
				case PROP_EXPRESSION:
					return this.expression;
				case PROP_FORMAT:
					if(format.type == FormatTypes.currencyInput.type){
						return CurrencyTypes.getCurrencyType(this.format.currencyCode);
					}else if(format.type == FormatTypes.refFormField.type){
						return format.refFormId ? format.formRef.label : EMPTY_FORMNAME;
					}else if(format.type == FormatTypes.comboBox.type || format.type == FormatTypes.radioButton.type){
						return format.staticListExamples;
					}else if(format.type == FormatTypes.dataGrid.type){
						return children;
					}
					return null;
				case PROP_REFFORM_FIELDID:
					if(format.type == FormatTypes.refFormField.type){
						return  format.refFormFieldId ? format.refFormFieldName : EMPTY_FORM_FIELDNAME;
					}
				case PROP_CELL_SIZE:
					return this.cellSize;
				case PROP_AUTOINDEX:
					return format.autoIndexRuleList;
				case PROP_FONTWEIGHT:
					return this.fontWeight;
				case PROP_FONTSIZE:
					return this.fontSize;
				case PROP_TEXTALIGN:
					return this.textAlign;
				case PROP_TEXTCOLOR:
					return StringUtils.colorToNumber(this.textColor);
				default:
					return null;				
			}
		}
		
		private function getFormatType(type:String):FormatType{
			if(type==null) return null;
			var formatTypes:Array = FormatTypes.getEnableFormatTypeArray(this);
			for each(var formatType:FormatType in formatTypes){
				if(formatType.type == type)
					return formatType;
			}
			return null;
		}
		
		public function setPropertyValue(id: String, value: Object): void{
			switch(id){
				case PROP_NAME:
					this.name = value.toString();
					break;					
				case PROP_TOOLTIP:
					this.toolTip = value.toString();
					break;					
				case PROP_HIDDEN_USE:
					this.hidden = value as Boolean;
					break;
				case PROP_READONLY_USE:
					this.readOnly = value as Boolean;
					break;
				case PROP_REQUIRED_USE:
					this.required = value as Boolean;
					break;
				case PROP_HIDDEN_USE_CONDITION:
					this.hiddenConditions = value as Conds;
					break;
				case PROP_READONLY_USE_CONDITION:
					this.readOnlyConditions = value as Conds;
					break;
				case PROP_REQUIRED_USE_CONDITION:
					this.requiredConditions = value as Conds;
					break;
				case PROP_TYPE:
					var newFormat:FormFormatInfo = format.clone();
					newFormat.type = value.type;
					this.format = newFormat;
					break;
				case PROP_FITWIDTH:
					this.fitWidth = value as Boolean;
					break;
				case PROP_VERTICALSCROLLPOLICY:
					this.verticalScroll = value as Boolean;
					break;
				case PROP_FIT_TO_SCREEN:
					this.fitToScreen = value as Boolean;
					break;
				case PROP_LIST_EDITABLE:
					this.listEditable = value as Boolean;
					break;
				case PROP_MULTIPLE_USERS:
					this.multipleUsers = value as Boolean;
					break;
				case PROP_EXPRESSION:
					this.expression = value.toString();
					break;
				case PROP_FORMAT:
					var _newFormat:FormFormatInfo = format.clone();
					if(format.type == FormatTypes.currencyInput.type){
						_newFormat.currencyCode = CurrencyType(value).data;
						this.format = _newFormat;
					}else if(format.type == FormatTypes.comboBox.type || format.type == FormatTypes.radioButton.type){
						_newFormat.staticListExamples = value as ArrayCollection; 
						this.format = _newFormat;
					}else if(format.type == FormatTypes.dataGrid.type){
						this.children = value as ArrayCollection;
					}
					break;
				case PROP_CELL_SIZE:
					this.cellSize = value as int;
					break;
				case PROP_AUTOINDEX:
					format.autoIndexRuleList = value as ArrayCollection;
					break;
				case PROP_FONTWEIGHT:
					this.fontWeight = value as String;
					break;
				case PROP_FONTSIZE:
					this.fontSize = value as String;
					break;
				case PROP_TEXTALIGN:
					this.textAlign = value as String;
					break;
				case PROP_TEXTCOLOR:
					this.textColor = Number(value).toString(16);
					break;
				default:
					break;
			}
			
		}
		
		public function isPropertySet(id: String): Boolean{
			for each(var formatType:FormatType in FormatTypes.formatTypeArray)
				if( formatType.type == id)
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