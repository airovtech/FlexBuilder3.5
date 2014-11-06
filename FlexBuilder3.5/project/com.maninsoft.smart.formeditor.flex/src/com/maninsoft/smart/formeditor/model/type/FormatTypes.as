/**
 * 
 *  Package: 		com.maninsoft.smart.formeditor.model.format
 *  Class: 			FormatTypes
 * 					extends None 
 * 					implements None
 *  Author:			Maninsoft, Inc.
 *  Description:	Form Editor에서 Form Grid의 표현될수 있는 Format항목들의 형식을 정의하는 클래스
 * 				
 *  History:		Created by Maninsoft, Inc.
 * 					2010.2.26 Modified by Y.S. Jung for SWV20003: 폼에디터에 이미지를 보여주는 항목 추가
 * 					2010.2.26 Modified by Y.S. Jung for SWV20004: 폼에디터에 이메일아이디를 입력하는 항목 추가
 * 
 *  Copyright (C) 2007-2010 Maninsoft, Inc. All Rights Reserved.
 *  
 */

package com.maninsoft.smart.formeditor.model.type
{
	import com.maninsoft.smart.formeditor.assets.FormEditorAssets;
	import com.maninsoft.smart.formeditor.model.FormEntity;
	import com.maninsoft.smart.formeditor.view.format.CheckBoxView;
	import com.maninsoft.smart.formeditor.view.format.ComboBoxView;
	import com.maninsoft.smart.formeditor.view.format.CurrencyInputView;
	import com.maninsoft.smart.formeditor.view.format.DateChooserView;
	import com.maninsoft.smart.formeditor.view.format.EmailIDInputView;
	import com.maninsoft.smart.formeditor.view.format.FileListView;
	import com.maninsoft.smart.formeditor.view.format.FormRefView;
	import com.maninsoft.smart.formeditor.view.format.ListView;
	import com.maninsoft.smart.formeditor.view.format.NumberInputView;
	import com.maninsoft.smart.formeditor.view.format.NumericStepperView;
	import com.maninsoft.smart.formeditor.view.format.PercentInputView;
	import com.maninsoft.smart.formeditor.view.format.RadioButtonView;
	import com.maninsoft.smart.formeditor.view.format.RichTextEditorView;
	import com.maninsoft.smart.formeditor.view.format.TableView;
	import com.maninsoft.smart.formeditor.view.format.TextAreaView;
	import com.maninsoft.smart.formeditor.view.format.TextInputView;
	import com.maninsoft.smart.formeditor.view.format.TimeComboBoxView;
	import com.maninsoft.smart.formeditor.view.format.UserRefView;
	import com.maninsoft.smart.formeditor.view.format.DepartmentFieldView;
	
	import mx.resources.ResourceManager;
	
	public class FormatTypes
	{
		public static var textInput:FormatType = new FormatType(FormEditorAssets.textInputIcon, ResourceManager.getInstance().getString("FormEditorETC", "textInputText"), "textInput", 4, com.maninsoft.smart.formeditor.view.format.TextInputView, "string", 80, 190, 25);
		public static var numberInput:FormatType = new FormatType(FormEditorAssets.numberInputIcon, ResourceManager.getInstance().getString("FormEditorETC", "numberInputText"), "numberInput", 14, com.maninsoft.smart.formeditor.view.format.NumberInputView, "number", 80, 190, 25);
		public static var label:FormatType = new FormatType(FormEditorAssets.labelIcon, ResourceManager.getInstance().getString("FormEditorETC", "labelText"), "label", 14, com.maninsoft.smart.formeditor.view.format.LabelView, "string", 80, 190, 25);
		/**
		 * SWV20003: 폼에디터에 이미지를 보여주는 항목 추가
		 * SWV20004: 폼에디터에 이메일아이디를 입력하는 항목 추가
		 * 2010.2.26 Added by Y.S. Jung
		 */
		public static var emailIDInput:FormatType = new FormatType(FormEditorAssets.emailIDInputIcon, ResourceManager.getInstance().getString("FormEditorETC", "emailIDInputText"), "emailIDInput", 17, com.maninsoft.smart.formeditor.view.format.EmailIDInputView, "string", 80, 190, 25);
		public static var imageBox:FormatType = new FormatType(FormEditorAssets.imageBoxIcon, ResourceManager.getInstance().getString("FormEditorETC", "imageBoxText"), "imageBox", 18, com.maninsoft.smart.formeditor.view.format.ImageBoxView, "string", 80, 190, 125);
		public static var richEditor:FormatType = new FormatType(FormEditorAssets.richTextEditorIcon, ResourceManager.getInstance().getString("FormEditorETC", "richEditorText"), "richEditor", 13, com.maninsoft.smart.formeditor.view.format.RichTextEditorView, "text", 80, 500, 250);
		public static var comboBox:FormatType = new FormatType(FormEditorAssets.comboBoxIcon, ResourceManager.getInstance().getString("FormEditorETC", "comboBoxText"), "comboBox", 1, com.maninsoft.smart.formeditor.view.format.ComboBoxView, "string", 80, 190, 25);
		public static var dateChooser:FormatType = new FormatType(FormEditorAssets.dateChooserIcon, ResourceManager.getInstance().getString("FormEditorETC", "dateChooserText"), "dateChooser", 2, com.maninsoft.smart.formeditor.view.format.DateChooserView, "datetime", 80, 130, 25);
		public static var dateTimeChooser:FormatType = new FormatType(FormEditorAssets.dateTimeChooserIcon, ResourceManager.getInstance().getString("FormEditorETC", "dateTimeChooserText"), "dateTimeChooser", 19, com.maninsoft.smart.formeditor.view.format.DateTimeChooserView, "datetime", 80, 130, 25);
		public static var timeField:FormatType = new FormatType(FormEditorAssets.timeComboBoxIcon, ResourceManager.getInstance().getString("FormEditorETC", "timeFieldText"), "timeField", 12, com.maninsoft.smart.formeditor.view.format.TimeComboBoxView, "time", 80, 130, 25);
		public static var userField:FormatType = new FormatType(FormEditorAssets.userRefIcon, ResourceManager.getInstance().getString("FormEditorETC", "userFieldText"), "userField", 9, com.maninsoft.smart.formeditor.view.format.UserRefView, "string", 80, 130, 25);
		public static var fileField:FormatType = new FormatType(FormEditorAssets.fileListIcon, ResourceManager.getInstance().getString("FormEditorETC", "fileFieldText"), "fileField", 10, com.maninsoft.smart.formeditor.view.format.FileListView, "string", 80, 275, 110);
		public static var refFormField:FormatType = new FormatType(FormEditorAssets.formRefIcon, ResourceManager.getInstance().getString("FormEditorETC", "refFormFieldText"), "refFormField", 11, com.maninsoft.smart.formeditor.view.format.FormRefView, "string", 80, 190, 25);
		public static var currencyInput:FormatType = new FormatType(FormEditorAssets.currencyInputIcon, ResourceManager.getInstance().getString("FormEditorETC", "currencyInputText"), "currencyInput", 15, com.maninsoft.smart.formeditor.view.format.CurrencyInputView, "number", 80, 190, 25);
		public static var percentInput:FormatType = new FormatType(FormEditorAssets.percentInputIcon, ResourceManager.getInstance().getString("FormEditorETC", "percentInputText"), "percentInput", 16, com.maninsoft.smart.formeditor.view.format.PercentInputView, "number", 80, 100, 25);
		public static var checkBox:FormatType = new FormatType(FormEditorAssets.checkBoxIcon, ResourceManager.getInstance().getString("FormEditorETC", "checkBoxText"), "checkBox", 8, com.maninsoft.smart.formeditor.view.format.CheckBoxView, "boolean", 80, 65, 25);
		public static var radioButton:FormatType = new FormatType(FormEditorAssets.radioButtonIcon, ResourceManager.getInstance().getString("FormEditorETC", "radioButtonText"), "radioButton", 0, com.maninsoft.smart.formeditor.view.format.RadioButtonView, "string", 80, 220, 25, 2);
		public static var dataGrid:FormatType = new FormatType(FormEditorAssets.tableIcon, ResourceManager.getInstance().getString("FormEditorETC", "dataGridText"), "dataGrid", 6, com.maninsoft.smart.formeditor.view.format.TableView, "string", 80, 440, 110, 2);
		public static var autoIndex:FormatType = new FormatType(FormEditorAssets.autoIndexIcon, ResourceManager.getInstance().getString("FormEditorETC", "autoIndexText"), "autoIndex", 20, com.maninsoft.smart.formeditor.view.format.AutoIndexView, "string", 80, 190, 25);
		public static var departmentField:FormatType = new FormatType(FormEditorAssets.departmentFieldIcon, ResourceManager.getInstance().getString("FormEditorETC", "departmentFieldText"), "departmentField", 20, com.maninsoft.smart.formeditor.view.format.DepartmentFieldView, "string", 80, 190, 25);
		// deprecated
		public static var numericStepper:FormatType = new FormatType(FormEditorAssets.textInputIcon, ResourceManager.getInstance().getString("FormEditorETC", "numericStepperText"), "numericStepper", 3, com.maninsoft.smart.formeditor.view.format.NumericStepperView, "number", 80, 65, 25);
		public static var textArea:FormatType = new FormatType(FormEditorAssets.textInputIcon, ResourceManager.getInstance().getString("FormEditorETC", "textAreaText"), "textArea", 7, com.maninsoft.smart.formeditor.view.format.TextAreaView, "string", 80, 440, 110);
		public static var list:FormatType = new FormatType(FormEditorAssets.textInputIcon, ResourceManager.getInstance().getString("FormEditorETC", "listText"), "list", 5, com.maninsoft.smart.formeditor.view.format.ListView, "string", 80, 155, 110, 2);
				
		/**
		 * SWV20003: 폼에디터에 이미지를 보여주는 항목 추가
		 * SWV20004: 폼에디터에 이메일아이디를 입력하는 항목 추가
		 * emailIDInput, imageBox format을 추가합니다.
		 * 2010.2.26 Modified by Y.S. Jung
		 */
		public static var formatTypeArray:Array = [
			textInput,
			numberInput,
			label,
			emailIDInput,
			currencyInput,
			percentInput,
			autoIndex,
			imageBox,
			comboBox,
			checkBox,
			radioButton,
			dateChooser,
			dateTimeChooser,
			timeField,
			userField,
			departmentField,
			fileField,
			refFormField,
			dataGrid,
			richEditor
		];
		
		/**
		 * SWV20003: 폼에디터에 이미지를 보여주는 항목 추가
		 * SWV20004: 폼에디터에 이메일아이디를 입력하는 항목 추가
		 * emailIDInput, imageBox format을 추가합니다.
		 * 2010.2.26 Modified by Y.S. Jung
		 */
		public static var lightFormatTypeArray:Array = [
			textInput,
			numberInput,
			label,
			emailIDInput,
			currencyInput,
			percentInput,
			autoIndex,
			imageBox,
			comboBox,
			checkBox,
			radioButton,
			dateChooser,
			dateTimeChooser,
			timeField,
			userField,
			departmentField,
			refFormField
		];
		
		public static var basicFormatTypeArray:Array = [
			textInput,
			numberInput,
			currencyInput,
			percentInput,
			autoIndex,
			dateChooser,
			dateTimeChooser,
			timeField,
			userField,
			departmentField,
			refFormField
		];
				
		/**
		 * SWV20003: 폼에디터에 이미지를 보여주는 항목 추가
		 * SWV20004: 폼에디터에 이메일아이디를 입력하는 항목 추가
		 * emailIDInput format을 추가합니다.
		 * 2010.2.26 Modified by Y.S. Jung
		 */
		private static var dataGirdFormatTypeArray:Array = [
			textInput,
			numberInput,
			emailIDInput,
			currencyInput,
			percentInput,
			autoIndex,
			comboBox,
			checkBox,
			radioButton,
			dateChooser,
			dateTimeChooser,
			timeField,
			userField,
			departmentField,
			fileField,
			refFormField,
			richEditor,
		];
		
		public static function getIcon(type:String):Class{
			return getFormatType(type, false).icon;
		}
		public static function getFormatType(type:String, array:Boolean):FormatType{
			if (type != dataGrid.type && array) {
				return list;
			}
			
			for each (var format:FormatType in formatTypeArray) {
				if (format.type == type)
					return format;
			}
			return textInput;
		}
		
		public static function getFormatTypeIndex(label:String): int{
			for(var i:int=0; i<formatTypeArray.length; i++) {
				if (formatTypeArray[i].label == label)
					return i;
			}
			return -1;
		}
		
		public static function getFormatTypeName(label:String): String{
			for(var i:int=0; i<formatTypeArray.length; i++) {
				if (formatTypeArray[i].label == label)
					return formatTypeArray[i].type;
			}
			return textInput.type;
		}
		
		public static function getEnableFormatTypeArray(formEntity:FormEntity):Array{
			if(formEntity.depth > 0)
				return FormatTypes.lightFormatTypeArray;
			else
				return FormatTypes.formatTypeArray;
		}
		
		public static function getDataGridFormatTypeArray():Array{
				return FormatTypes.dataGirdFormatTypeArray;
		}
		
	}
}