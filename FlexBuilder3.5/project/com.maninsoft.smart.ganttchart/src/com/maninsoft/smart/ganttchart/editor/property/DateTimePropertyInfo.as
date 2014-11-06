////////////////////////////////////////////////////////////////////////////////
//  ActivityTypePropertyInfo.as
//  2008.02.25, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.ganttchart.editor.property
{
	import com.maninsoft.smart.workbench.common.property.IPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertySource;
	import com.maninsoft.smart.workbench.common.property.PropertyInfo;
	
	import mx.formatters.DateFormatter;
	
	/**
	 * Activity의 activityType 속성
	 */
	public class DateTimePropertyInfo extends PropertyInfo	{
		
		private var _editor: DateTimePropertyEditor;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function DateTimePropertyInfo(id: String, displayName: String, 
		                                      description: String = null,
		                                      category: String = null,
		                                      editable: Boolean = true,
		                                      helpId: String = null) {
			super(id, displayName, description, category, editable, helpId);
		}

		override public function getEditor(source: IPropertySource): IPropertyEditor {

			if (!_editor) {
				_editor = new DateTimePropertyEditor();
			}
			
			return _editor;
		}

		/**
		 * 프로퍼티 값 value를 문자열로 나타낸다.
		 */
		override public function getText(value: Object): String {
			if(value==null)
				return resourceManager.getString("GanttChartETC", "noDateText");

			var date: Date = value as Date;
			var dateFormatter: DateFormatter = new DateFormatter();
			dateFormatter.formatString = "YYYY-MM-DD     ";
			var text: String = dateFormatter.format(date);

			var hours: int = date.getHours();			
			if(hours==0) text += "  " + resourceManager.getString("GanttChartETC", "midNightText");
			else if(hours<12) text += "  " + resourceManager.getString("GanttChartETC", "beforeNoonText") + get99String(hours);
			else if(hours==12) text += "  " + resourceManager.getString("GanttChartETC", "noonText");
			else if(hours<24) text += "  " + resourceManager.getString("GanttChartETC", "afterNoonText") + get99String(hours-12);
			function get99String(value: int): String{
				var result: String;
				if(value<10)
					result = "0"+value.toString();
				else
					result = value.toString();
				return result;
			}

			return text; 
		}
	}
}