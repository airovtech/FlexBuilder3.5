/**
 * 
 *  Package: 		com.maninsoft.smart.formeditor.refactor.command
 *  Class: 			UpdateFormEntityCommand
 * 					extends FormEntityCommand 
 * 					implements None
 *  Author:			Maninsoft, Inc.
 *  Description:	Form Editor에서 Form Entity를 업데이트하는 command 클래스
 * 				
 *  History:		Created by Maninsoft, Inc.
 * 					2010.2.26 Modified by Y.S. Jung for SWV20003: 폼에디터에 이미지를 보여주는 항목 추가
 * 
 *  Copyright (C) 2007-2010 Maninsoft, Inc. All Rights Reserved.
 *  
 */

package com.maninsoft.smart.formeditor.refactor.command
{
	import com.maninsoft.smart.formeditor.refactor.component.model.TextStyleModel;
	import com.maninsoft.smart.formeditor.model.FormEntity;
	import com.maninsoft.smart.formeditor.model.property.FormArrayInfo;
	import com.maninsoft.smart.formeditor.model.property.FormFormatInfo;
	import com.maninsoft.smart.formeditor.model.property.FormItemType;
	
	public class UpdateFormEntityCommand extends FormEntityCommand
	{
		public var newValue:Object;
		private var oldValue:Object;
		
		public var type:String;
		
		public function UpdateFormEntityCommand(label:String) {
			super(label);
		}
	
		public override function execute():void{
			if (type == FormEntity.PROP_CELL_SIZE) {
				oldValue = formEntityModel.cellSize;				
				this.formEntityModel.cellSize = int(newValue);
			} else if (type == FormEntity.PROP_EXPRESSION) {
				oldValue = formEntityModel.expression;				
				this.formEntityModel.expression = String(newValue);
			} else if (type == FormEntity.PROP_TYPE) {
				oldValue = formEntityModel.type;				
				this.formEntityModel.type = FormItemType(newValue);
			} else if (type == FormEntity.PROP_NAME) {
				oldValue = formEntityModel.name;				
				this.formEntityModel.name = String(newValue);
			} else if (type == FormEntity.PROP_TEXTALIGN) {
				oldValue = formEntityModel.textAlign;				
				this.formEntityModel.textAlign = String(newValue);
			} else if (type == FormEntity.PROP_LABEL_USE) {
				oldValue = formEntityModel.labelVisible;				
				this.formEntityModel.labelVisible = Boolean(newValue);
			} else if (type == FormEntity.PROP_HIDDEN_USE) {
				oldValue = formEntityModel.hidden;				
				this.formEntityModel.hidden = Boolean(newValue);
			} else if (type == FormEntity.PROP_READONLY_USE) {
				oldValue = formEntityModel.readOnly;				
				this.formEntityModel.readOnly = Boolean(newValue);
			} else if (type == FormEntity.PROP_FORMAT) {
				oldValue = formEntityModel.format;				
				this.formEntityModel.format = FormFormatInfo(newValue);
			} else if (type == FormEntity.PROP_LABEL_WIDTH) {
				oldValue = formEntityModel.labelWidth;				
				this.formEntityModel.labelWidth = int(newValue);
			} else if (type == FormEntity.PROP_CONTENT_WIDTH) {
				oldValue = formEntityModel.contentWidth;				
				this.formEntityModel.contentWidth = int(newValue);
			} else if (type == FormEntity.PROP_HEIGHT) {
				oldValue = formEntityModel.height;				
				this.formEntityModel.height = int(newValue);
			} else if (type == FormEntity.PROP_CONTENTS_TEXTSTYLE) {
				oldValue = formEntityModel.contentsTextStyle;				
				this.formEntityModel.contentsTextStyle = TextStyleModel(newValue);
			} else if (type == FormEntity.PROP_COLOR_BACKGROUND) {
				oldValue = formEntityModel.bgColor;				
				this.formEntityModel.bgColor = Number(newValue);
			} else if (type == FormEntity.PROP_REQUIRED_USE) {
				oldValue = formEntityModel.required;				
				this.formEntityModel.required = Boolean(newValue);
			} else if (type == FormEntity.PROP_FITWIDTH) {
				oldValue = formEntityModel.fitWidth;				
				this.formEntityModel.fitWidth = Boolean(newValue);
			} else if (type == FormEntity.PROP_VERTICALSCROLLPOLICY) {
				oldValue = formEntityModel.verticalScroll;				
				this.formEntityModel.verticalScroll = Boolean(newValue);
			/**
			 * SWV20003: 폼에디터에 이미지를 보여주는 항목 추가
			 * 이미지박스에만 필요한 속성인 화면에맞게 이미지를 늘리기에대한 변수를 추가합니다.
			 * 2010.2.26 Added by Y.S. Jung
			 */
			} else if (type == FormEntity.PROP_FIT_TO_SCREEN) {
				oldValue = formEntityModel.fitToScreen;				
				this.formEntityModel.fitToScreen = Boolean(newValue);
			} else {
				oldValue = formEntityModel[type];				
				this.formEntityModel[type] = newValue;
			}
		}

		public override function undo():void{
			if (type == FormEntity.PROP_CELL_SIZE) {
				this.formEntityModel.cellSize = int(oldValue);
			} else if (type == FormEntity.PROP_EXPRESSION) {
				this.formEntityModel.expression = String(oldValue);
			} else if (type == FormEntity.PROP_TYPE) {
				this.formEntityModel.type = FormItemType(oldValue);
			} else if (type == FormEntity.PROP_NAME) {
				this.formEntityModel.name = String(oldValue);
			} else if (type == FormEntity.PROP_TEXTALIGN) {
				this.formEntityModel.textAlign = String(oldValue);
			} else if (type == FormEntity.PROP_LABEL_USE) {
				this.formEntityModel.labelVisible = Boolean(oldValue);
			} else if (type == FormEntity.PROP_HIDDEN_USE) {
				this.formEntityModel.hidden = Boolean(oldValue);
			} else if (type == FormEntity.PROP_READONLY_USE) {
				this.formEntityModel.readOnly = Boolean(oldValue);
			} else if (type == FormEntity.PROP_FORMAT) {
				this.formEntityModel.format = FormFormatInfo(oldValue);
			} else if (type == FormEntity.PROP_LABEL_WIDTH) {
				this.formEntityModel.labelWidth = int(oldValue);
			} else if (type == FormEntity.PROP_CONTENT_WIDTH) {
				this.formEntityModel.contentWidth = int(oldValue);
			} else if (type == FormEntity.PROP_HEIGHT) {
				this.formEntityModel.height = int(oldValue);
			} else if (type == FormEntity.PROP_CONTENTS_TEXTSTYLE) {			
				this.formEntityModel.contentsTextStyle = TextStyleModel(oldValue);
			} else if (type == FormEntity.PROP_COLOR_BACKGROUND) {	
				this.formEntityModel.bgColor = Number(oldValue);
			} else if (type == FormEntity.PROP_REQUIRED_USE) {
				this.formEntityModel.required = Boolean(oldValue);
			} else if (type == FormEntity.PROP_FITWIDTH) {
				this.formEntityModel.fitWidth = Boolean(oldValue);
			} else if (type == FormEntity.PROP_VERTICALSCROLLPOLICY) {	
				this.formEntityModel.verticalScroll = Boolean(oldValue);
			/**
			 * SWV20003: 폼에디터에 이미지를 보여주는 항목 추가
			 * 이미지박스에만 필요한 속성인 화면에맞게 이미지를 늘리기에대한 변수를 추가합니다.
			 * 2010.2.26 Added by Y.S. Jung
			 */
			} else if (type == FormEntity.PROP_FIT_TO_SCREEN) {
				this.formEntityModel.fitToScreen = Boolean(oldValue);
			} else {
				this.formEntityModel[type] = oldValue;
			}
		}
		
		public override function redo():void{
			if (type == FormEntity.PROP_CELL_SIZE) {
				this.formEntityModel.cellSize = int(newValue);
			} else if (type == FormEntity.PROP_EXPRESSION) {
				this.formEntityModel.expression = String(newValue);
			} else if (type == FormEntity.PROP_TYPE) {
				this.formEntityModel.type = FormItemType(newValue);
			} else if (type == FormEntity.PROP_NAME) {
				this.formEntityModel.name = String(newValue);
			} else if (type == FormEntity.PROP_TEXTALIGN) {
				this.formEntityModel.textAlign = String(newValue);
			} else if (type == FormEntity.PROP_LABEL_USE) {
				this.formEntityModel.labelVisible = Boolean(newValue);
			} else if (type == FormEntity.PROP_HIDDEN_USE) {
				this.formEntityModel.hidden = Boolean(newValue);
			} else if (type == FormEntity.PROP_READONLY_USE) {
				this.formEntityModel.readOnly = Boolean(newValue);
			} else if (type == FormEntity.PROP_FORMAT) {
				this.formEntityModel.format = FormFormatInfo(newValue);
			} else if (type == FormEntity.PROP_LABEL_WIDTH) {
				this.formEntityModel.labelWidth = int(newValue);
			} else if (type == FormEntity.PROP_CONTENT_WIDTH) {
				this.formEntityModel.contentWidth = int(newValue);
			} else if (type == FormEntity.PROP_HEIGHT) {
				this.formEntityModel.height = int(newValue);
			} else if (type == FormEntity.PROP_CONTENTS_TEXTSTYLE) {			
				this.formEntityModel.contentsTextStyle = TextStyleModel(newValue);
			} else if (type == FormEntity.PROP_COLOR_BACKGROUND) {		
				this.formEntityModel.bgColor = Number(newValue);
			} else if (type == FormEntity.PROP_REQUIRED_USE) {			
				this.formEntityModel.required = Boolean(newValue);
			} else if (type == FormEntity.PROP_FITWIDTH) {
				this.formEntityModel.fitWidth = Boolean(newValue);
			} else if (type == FormEntity.PROP_VERTICALSCROLLPOLICY) {	
				this.formEntityModel.verticalScroll = Boolean(newValue);
			/**
			 * SWV20003: 폼에디터에 이미지를 보여주는 항목 추가
			 * 이미지박스에만 필요한 속성인 화면에맞게 이미지를 늘리기에대한 변수를 추가합니다.
			 * 2010.2.26 Added by Y.S. Jung
			 */
			} else if (type == FormEntity.PROP_FIT_TO_SCREEN) {
				this.formEntityModel.fitToScreen = Boolean(newValue);
			} else {
				this.formEntityModel[type] = newValue;
			}
		}
		public override function getLabel():String{
			return "Update " + type + " values (" + newValue + ") in FormField(" + formEntityModel.id + ")";
		}
	}
}