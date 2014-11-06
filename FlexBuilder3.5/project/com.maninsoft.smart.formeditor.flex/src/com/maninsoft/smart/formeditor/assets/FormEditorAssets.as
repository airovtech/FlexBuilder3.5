/**
 * 
 *  Package: 		com.maninsoft.smart.formeditor.util
 *  Class: 			FormEditorAssets
 * 					extends None 
 * 					implements None
 *  Author:			Maninsoft, Inc.
 *  Description:	Form Editor에서 사용하는 Asset들을 정의하기 위한 클래스
 * 				
 *  History:		Created by Maninsoft, Inc.
 * 					2010.2.26 Modified by Y.S. Jung for SWV20003: 폼에디터에 이미지를 보여주는 항목 추가
 * 					2010.2.26 Modified by Y.S. Jung for SWV20004: 폼에디터에 이메일아이디를 입력하는 항목 추가
 * 
 *  Copyright (C) 2007-2010 Maninsoft, Inc. All Rights Reserved.
 *  
 */

package com.maninsoft.smart.formeditor.assets
{
	import com.maninsoft.smart.common.assets.DialogAssets;
	import com.maninsoft.smart.common.assets.locale.Icons;
	
	public class FormEditorAssets
	{
		[Embed(source="assets/icon/form.png")]
		public static const formIcon:Class;
		
		public static const connectOtherWorkIcon:Class = Icons.connectWorksIcon;
		
		public static const connectSystemServiceIcon:Class = Icons.connectServicesIcon;
		
		[Embed(source="assets/icon/formLink.png")]
		public static const formLinkIcon:Class;

		[Embed(source="assets/icon/serviceLink.png")]
		public static const serviceLinkIcon:Class;
				
		[Embed(source="assets/icon/tbtn_save.png")]
		public static const saveIcon:Class;
		
		[Embed(source="assets/icon/tbtn_undo.png")]
		public static const undoIcon:Class;
		
		[Embed(source="assets/icon/tbtn_redo.png")]
		public static const redoIcon:Class;
				
		[Embed(source="assets/icon/import.gif")]
		public static const importIcon:Class;
		
		[Embed(source="assets/icon/export.gif")]
		public static const exportIcon:Class;
		
		[Embed(source="assets/icon/btn_property.png")]
		public static const detailConditionIcon:Class;
		
		[Embed(source="assets/icon/hasImport.gif")]
		public static const hasImportIcon:Class;
		
		[Embed(source="assets/icon/hasExport.gif")]
		public static const hasExportIcon:Class;
		
		[Embed(source="assets/icon/prevPageGroup.gif")]
		public static const prevPageGroupIcon:Class;
		
		[Embed(source="assets/icon/nextPageGroup.gif")]
		public static const nextPageGroupIcon:Class;
		
		[Embed(source="assets/icon/format/tbtn_ab.png")]
		public static const textInputIcon:Class;
		
		[Embed(source="assets/icon/format/tbtn_12.png")]
		public static const numberInputIcon:Class;
		
		[Embed(source="assets/icon/format/tbtn_label.png")]
		public static const labelIcon:Class;
		
		/**
		 * SWV20003: 폼에디터에 이미지를 보여주는 항목 추가
		 * SWV20004: 폼에디터에 이메일아이디를 입력하는 항목 추가
		 * emailIDInput.gif와 imageBox.gif를 추가합니다.
		 * 2010.2.26 Added by Y.S. Jung
		 */
		[Embed(source="assets/icon/format/tbtn_mail.png")]
		public static const emailIDInputIcon:Class;
		
		[Embed(source="assets/icon/format/tbtn_image.png")]
		public static const imageBoxIcon:Class;
		
		[Embed(source="assets/icon/format/tbtn_textarea.png")]
		public static const richTextEditorIcon:Class;
		
		[Embed(source="assets/icon/format/tbtn_combo.png")]
		public static const comboBoxIcon:Class;
		
		[Embed(source="assets/icon/format/tbtn_date.png")]
		public static const dateChooserIcon:Class;
		
		[Embed(source="assets/icon/format/tbtn_datetime.png")]
		public static const dateTimeChooserIcon:Class;
		
		[Embed(source="assets/icon/format/tbtn_time.png")]
		public static const timeComboBoxIcon:Class;
		
		[Embed(source="assets/icon/format/tbtn_member.png")]
		public static const userRefIcon:Class;
		
		[Embed(source="assets/icon/format/tbtn_file.png")]
		public static const fileListIcon:Class;
		
		[Embed(source="assets/icon/format/tbtn_referwork.png")]
		public static const formRefIcon:Class;
		
		[Embed(source="assets/icon/format/tbtn_currency.png")]
		public static const currencyInputIcon:Class;
		
		[Embed(source="assets/icon/format/tbtn_percent.png")]
		public static const percentInputIcon:Class;
		
		[Embed(source="assets/icon/format/tbtn_check.png")]
		public static const checkBoxIcon:Class;
		
		[Embed(source="assets/icon/format/tbtn_radio.png")]
		public static const radioButtonIcon:Class;
		
		[Embed(source="assets/icon/format/tbtn_table.png")]
		public static const tableIcon:Class;
		
		[Embed(source="assets/icon/format/tbtn_autoindex.png")]
		public static const autoIndexIcon:Class;
		
		[Embed(source="assets/icon/format/tbtn_department.png")]
		public static const departmentFieldIcon:Class;
		
		[Embed(source="assets/icon/tbtn_celmerge.png")]
		public static const sellMergeIcon:Class;
		
		[Embed(source="assets/icon/tbtn_divid.png")]
		public static const dividerIcon:Class;
		
		[Embed(source="assets/icon/tbtn_drag.png")]
		public static const defaultDragerIcon:Class;
		
		[Embed(source="assets/icon/tbtn_drag2.png")]
		public static const expandedDragerIcon:Class;
		
		[Embed(source="assets/icon/tbtn_close.png")]
		public static const collapseToolBoxIcon:Class;
		
		[Embed(source="assets/icon/tbtn_open.png")]
		public static const expandToolBoxIcon:Class;
		
		[Embed(source="assets/icon/process.gif")]
		public static const processIcon:Class;
		
		[Embed(source="assets/icon/expression.png")]
		public static const expressionIcon:Class;
		
		[Embed(source="assets/icon/system.gif")]
		public static const systemIcon:Class;
		
		[Embed(source="assets/icon/bracket.png")]
		public static const bracketIcon:Class;
	}
}