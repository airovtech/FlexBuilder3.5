package com.maninsoft.smart.ganttchart.view
{
	import com.maninsoft.smart.ganttchart.assets.GanttIconLibrary;
	import com.maninsoft.smart.ganttchart.model.GanttChartGrid;
	import com.maninsoft.smart.ganttchart.server.WorkCalendar;
	import com.maninsoft.smart.ganttchart.server.WorkHour;
	import com.maninsoft.smart.ganttchart.util.CalendarUtil;
	import com.maninsoft.smart.modeler.xpdl.view.base.XPDLNodeView;
	
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mx.core.SpriteAsset;

	public class GanttChartGridView extends XPDLNodeView
	{
		
		private var moveLeftIcon:SpriteAsset;
		private var moveRightIcon:SpriteAsset;
		public var showMoveLeftIcon:Boolean=true;

		public function GanttChartGridView()
		{
			super();		
		}

		private var _workCalendar: WorkCalendar;
		public function get workCalendar(): WorkCalendar{
			return _workCalendar;
		}
		
		public function set workCalendar(value: WorkCalendar): void{
			_workCalendar = value;
		}
		
		private var _bufferRows:int;
		public function get bufferRows(): int{
			return _bufferRows;
		}
		public function set bufferRows(value: int): void{
			_bufferRows = value;
		}

		public function get headerHeight(): Number{
			return GanttChartGrid.CHARTHEADER_HEIGHT;
		}
		
		public function get rowHeight(): Number{
			return GanttChartGrid.CHARTROW_HEIGHT;
		}

		private var _numTasks: int;
		public function get numTasks(): int{
			return _numTasks;
		}		
		public function set numTasks(value:int): void{
			_numTasks = value;
		}

		private var _viewScope:int;
		public function get viewScope():int{
			return _viewScope;
		}
    	public function set viewScope(value:int): void{
    		_viewScope = value;
   		}
    		
		private var _pivotDate:Date;
		public function get pivotDate(): Date{
			return _pivotDate;
		}
    	public function set pivotDate(value: Date): void{
    		_pivotDate = value;
   		}

		private var _startDate:Date=new Date();
		public function get startDate(): Date{
			return _startDate;
		}
    	public function set startDate(value: Date): void{
    		_startDate = value;
    	}

		private var _endDate:Date = new Date();
		public function get endDate(): Date{
			return _endDate;
		}
    	public function set endDate(value: Date): void{
    		_endDate = value;
    	}

		private var _title: String;
		public function get title(): String {
			return _title;
		}
		
		public function set title(value: String): void {
			_title = value ? value : resourceManager.getString("GanttChartETC", "GanttChartText");
		}

		protected function drawGroupHeaderText(r: Rectangle, text: String, field: TextField = null, format: TextFormat = null): void {
			
			if(format==null){
				_textFormat.align = TextFormatAlign.CENTER ;
				_textFormat.bold = false;
				_textFormat.font = "flexDefaultFontThin";
				_textFormat.size = 14;
				_textFormat.color = 0x2c2c2c;
				format = _textFormat;
			}else{
				format.align = TextFormatAlign.CENTER ;
				format.bold = false;
				format.font = "flexDefaultFontThin";
				format.size = 14;
				format.color = 0x2c2c2c;
				
			}
			drawHeaderText(r, text, true, field, format);
		}

		protected function drawHeaderText(r: Rectangle, text: String, isWorkTime:Boolean=true, field: TextField = null, format: TextFormat = null): void {
			if (!text)
				return;
			
			if (!field){
				field = new TextField();
				addChild(field);
			}

			if (!format){
				format = _textFormat;
				format.font = "flexDefaultFontThin";
				if(!isWorkTime)
					format.color = headerTextWorkOffColor;
				else
					format.color = 0x2c2c2c;
				format.size = 11;
				format.align = TextFormatAlign.LEFT ;
				format.bold = false;
			}
			field.defaultTextFormat = format;
			field.x = r.x;
			field.y = r.y;
			field.width = r.width;
			field.height = r.height;
			field.text = text;
			field.embedFonts = true;
			field.selectable = false;
		}

		private static const colorWhite:uint = 0xFFFFFF;
		private static const colorBlack:uint = 0x000000;
		
		private var headerTextWorkOffColor:uint = 0xb54d4d;
		private var headerFillColor:uint = colorWhite;
		private var headerBorderColor:uint = 0xe4e4e4;
		private var headerFocusFillColor:uint = colorWhite;
		private var gridFillColor:uint = colorWhite;
		private var gridOddFillColor:uint = colorWhite;
		private var gridEvenFillColor:uint = 0xF0F0F0;
		private var gridColumnBorderColor:uint = 0xE3EFFF;
		private var gridWorkOffFillColor:uint = 0xf4f4f4;

		private function clearChartView(g: Graphics): void{
			g.clear();
			var numChildren: int = this.numChildren;
			for(var num: int = 0, cnt: int =0; num < numChildren; num++){
				if(this.getChildAt(cnt) is TextField){
					this.removeChildAt(cnt);
				}else{
					cnt++;
				}
			}
		}

		private function drawChartOutline(g: Graphics): void{

			g.lineStyle(1, headerBorderColor, 1);
			g.beginFill(headerFillColor, 1)
			g.drawRect(0, 0, nodeWidth, nodeHeight-1);
			g.endFill();

			g.lineStyle(1, headerBorderColor, 1);
			g.beginFill(headerFillColor, 1)
			g.drawRect(0, headerHeight, nodeWidth, headerHeight-1);
			g.endFill();

		}
		private function drawChartRows(g: Graphics): void{
			var h:int = headerHeight*2;
			var odd:Boolean = true;
			var rowCnt:int = numTasks+bufferRows;
			for(var i:int=0; i<rowCnt; i++){
				g.lineStyle(1, headerBorderColor, 1);
				g.moveTo(0, h+i*rowHeight);
				g.lineTo(nodeWidth, h+i*rowHeight);
			}
		}

		private function drawColumnGroupLine(g: Graphics, fx: Number, colWidth: Number, isWorkTime: Boolean, last: Boolean=false): void{
			if(last){
				if(!isWorkTime){
					g.lineStyle(1, headerBorderColor, 1);
					g.beginFill(gridWorkOffFillColor, 1);
					g.drawRect(fx-colWidth, headerHeight, colWidth, nodeHeight-headerHeight);
				}else{
					g.lineStyle(1, headerBorderColor, 1);
					g.beginFill(gridFillColor, 1);
					g.drawRect(fx-colWidth, headerHeight, colWidth, nodeHeight-headerHeight);				
				}
			}
			g.lineStyle(1, gridColumnBorderColor, 1);
			g.moveTo(fx, 0);
			g.lineTo(fx, nodeHeight);									
		}

		private function drawColumnLine(g: Graphics, fx: Number, colWidth: Number, isWorkTime: Boolean ): void{
			if(!isWorkTime){
				g.lineStyle(1, headerBorderColor, 1);
				g.beginFill(gridWorkOffFillColor, 1);
				g.drawRect(fx-colWidth, headerHeight, colWidth, nodeHeight-headerHeight);
			}else{
				g.lineStyle(1, headerBorderColor, 1);
				g.beginFill(gridFillColor, 1);
				g.drawRect(fx-colWidth, headerHeight, colWidth, nodeHeight-headerHeight);				
			}
			g.lineStyle(1, gridColumnBorderColor, 1);
			g.moveTo(fx, headerHeight);
			g.lineTo(fx, nodeHeight);
		}
		
		private function addMoveButtons():void{

			if(moveLeftIcon){
				removeChild(moveLeftIcon);
				moveLeftIcon=null;
			}
			if(showMoveLeftIcon){
				moveLeftIcon = SpriteAsset(new GanttIconLibrary.moveLeftIcon());
				moveLeftIcon.x = 2;
				moveLeftIcon.y = 3;
				addChild(moveLeftIcon);
			}

			if(moveRightIcon){
				removeChild(moveRightIcon);
				moveRightIcon = null;
			}
			moveRightIcon = SpriteAsset(new GanttIconLibrary.moveRightIcon());			
			moveRightIcon.x = nodeWidth-moveRightIcon.width-2;
			moveRightIcon.y = 3;
			addChild(moveRightIcon);
		}
										
		override public function draw(): void {
			var g: Graphics = graphics;

			clearChartView(g);			
			drawChartOutline(g);
						
			var lastYear:int=-1,lastQuarter:int=-1,lastMonth:int=-1,lastDate:int=-1,lastDay:int=-1,lastHour:int=-1;
			var curYear:int,curQuarter:int,curMonth:int,curDate:int,curDay:int,curHour:int;
			var grpCnt:int=-1, colCnt:int=-1;
			var curYMH:String, isWorkTime: Boolean=true;
			var curDateTime:Date = new Date(startDate.time);
			var colGrpWidth:Number=0, curX:Number=0, lastX:Number=0;
			var	colWidth:Number = nodeWidth/GanttChartGrid.VIEWSCOPE_COLUMNS[viewScope];
			var numCol:int = GanttChartGrid.VIEWSCOPE_COLUMNS[viewScope];

			switch (viewScope){
				case GanttChartGrid.VIEWSCOPE_WORKHOURS:
					var workHour: WorkHour = workCalendar.getWorkHour(curDateTime);
					colWidth = nodeWidth/workHour.workTimeInHour;
					curDateTime.setHours(workHour.startInHour, 0, 0);					
					for(var cnt:int=workHour.startInHour; cnt<workHour.endInHour; cnt++){
						curYear=curDateTime.getFullYear();
						curMonth=curDateTime.getMonth()+1;
						curDate=curDateTime.getDate();
						curHour=curDateTime.getHours();
						isWorkTime=workCalendar.isWorkHour(curDateTime);
						if(lastYear!=curYear || lastMonth!=curMonth || lastDate!=curDate){
							if(curX!=0 && colGrpWidth>colWidth && curYMH!=null){
								drawGroupHeaderText(new Rectangle(lastX, 0, colGrpWidth, headerHeight), curYMH);
								lastX=curX;
								colGrpWidth=0;
								drawColumnGroupLine(g, curX, colWidth, isWorkTime);
							}
							curYMH= workCalendar.fullDayToString(curDateTime);
						}
						drawHeaderText(new Rectangle(curX, headerHeight, colWidth, headerHeight), workCalendar.hourToString(curHour), isWorkTime);
						curX+=colWidth;
						colGrpWidth+=colWidth;
						if(cnt+1<workHour.endInHour)
							drawColumnLine(g, curX, colWidth, isWorkTime );

						lastYear=curYear;lastMonth=curMonth;lastDate=curDate;lastHour=curHour;
						CalendarUtil.changeDateByPlusHours(curDateTime,1)+ workCalendar.getCalendarDay(curDateTime);
					}
					break;
					
				case GanttChartGrid.VIEWSCOPE_ONEDAY:
					for(var hourCnt:int=0; hourCnt<numCol; hourCnt++){
						curYear=curDateTime.getFullYear();
						curMonth=curDateTime.getMonth()+1;
						curDate=curDateTime.getDate();
						curHour=curDateTime.getHours();
						isWorkTime=workCalendar.isWorkHour(curDateTime);
						if(lastYear!=curYear || lastMonth!=curMonth || lastDate!=curDate){
							if(curX!=0 && colGrpWidth>colWidth && curYMH!=null){
								drawGroupHeaderText(new Rectangle(lastX, 0, colGrpWidth, headerHeight), curYMH);
								lastX=curX;
								colGrpWidth=0;
								drawColumnGroupLine(g, curX, colWidth, isWorkTime);
							}
							curYMH= workCalendar.fullDayToString(curDateTime) + workCalendar.getCalendarDay(curDateTime);
						}
						drawHeaderText(	new Rectangle(curX, headerHeight, colWidth, headerHeight), workCalendar.hourToStringShort(curHour), isWorkTime);
						curX+=colWidth;
						colGrpWidth+=colWidth;
						if(hourCnt+1<numCol)
							drawColumnLine(g, curX, colWidth, isWorkTime );

						lastYear=curYear;lastMonth=curMonth;lastDate=curDate;lastHour=curHour;
						CalendarUtil.changeDateByPlusHours(curDateTime,1);
					}				
					break;
					
				case GanttChartGrid.VIEWSCOPE_ONEWEEK:
					var endOfThisGroup: Date;
					for(var weekCnt:int=0; weekCnt<numCol; weekCnt++){
						curYear=curDateTime.getFullYear();
						curMonth=curDateTime.getMonth()+1;
						curDate=curDateTime.getDate();
						curDay=curDateTime.getDay();
						isWorkTime=workCalendar.isWorkDay(curDateTime);
//						if(lastDay==-1 || curDay==0){
						if(lastYear!=curYear || lastMonth!=curMonth){
							if(curX!=0 && colGrpWidth>colWidth && curYMH!=null){
								endOfThisGroup = new Date(curDateTime.time);
								CalendarUtil.changeDateByMinusDays(endOfThisGroup, 1);
								drawGroupHeaderText(new Rectangle(lastX, 0, colGrpWidth, headerHeight), curYMH); 
//														+"-" + workCalendar.fullDayToStringShort(endOfThisGroup));
								lastX=curX; 
								colGrpWidth=0;
								drawColumnGroupLine(g, curX, colWidth, isWorkTime);
							}
							curYMH=workCalendar.fullMonthToString(curDateTime);
						}
						drawHeaderText(new Rectangle(curX, headerHeight, colWidth, headerHeight), workCalendar.dateDayToString(curDateTime), isWorkTime); 
						curX+=colWidth;
						colGrpWidth+=colWidth;
						if(weekCnt+1<numCol)
							drawColumnLine(g, curX, colWidth, isWorkTime);
										
						lastYear=curYear;lastMonth=curMonth;lastDay=curDay;
						CalendarUtil.changeDateByPlusDays(curDateTime,1);
					}				
					endOfThisGroup = new Date(curDateTime.time);
					CalendarUtil.changeDateByMinusDays(endOfThisGroup, 1);
//					curYMH += "-" + workCalendar.fullDayToStringShort(endOfThisGroup);
					break;

				case GanttChartGrid.VIEWSCOPE_ONEMONTH:
					var daysInMonth:int = CalendarUtil.getDaysInMonth(curDateTime.getFullYear(), curDateTime.getMonth()+1);
					colWidth = nodeWidth/daysInMonth;					 
					for(var dayCnt:int=0; dayCnt<daysInMonth; dayCnt++){
						curYear=curDateTime.getFullYear();
						curMonth=curDateTime.getMonth()+1;
						curDate=curDateTime.getDate();
						isWorkTime=workCalendar.isWorkDay(curDateTime);
						if(lastYear!=curYear || lastMonth!=curMonth){
							if(curX!=0 && colGrpWidth>colWidth && curYMH!=null){
								drawGroupHeaderText(new Rectangle(lastX, 0, colGrpWidth, headerHeight), curYMH);
								lastX=curX; 
								colGrpWidth=0;
								drawColumnGroupLine(g, curX, colWidth, isWorkTime);
							}
							curYMH=workCalendar.fullMonthToString(curDateTime);
						}
						drawHeaderText(new Rectangle(curX, headerHeight, colWidth, headerHeight), workCalendar.dateToStringShort(curDate), isWorkTime); 
						curX+=colWidth;
						colGrpWidth+=colWidth;
						if(dayCnt+1<daysInMonth)
							drawColumnLine(g, curX, colWidth, isWorkTime);
									
						lastYear=curYear;lastMonth=curMonth;
						CalendarUtil.changeDateByPlusDays(curDateTime,1);
					}				
					break;
					
				case GanttChartGrid.VIEWSCOPE_ONEYEAR:
					for(var monthCnt:int=0; monthCnt<numCol; monthCnt++){
						curYear=curDateTime.getFullYear();
						curMonth=curDateTime.getMonth()+1;
						if(lastYear!=curYear){
							if(curX!=0 && colGrpWidth>colWidth && curYMH!=null){
								drawGroupHeaderText(new Rectangle(lastX, 0, colGrpWidth, headerHeight), curYMH);
								lastX=curX; 
								colGrpWidth=0;
								drawColumnGroupLine(g, curX, colWidth, isWorkTime);
							}
							curYMH=workCalendar.fullYearToString(curDateTime);
						}
						drawHeaderText(new Rectangle(curX, headerHeight, colWidth, headerHeight), workCalendar.monthToString(curMonth), isWorkTime); 
						curX+=colWidth;
						colGrpWidth+=colWidth;
						if(monthCnt+1<numCol)
							drawColumnLine(g, curX, colWidth, isWorkTime);
									
						lastYear=curYear;
						CalendarUtil.changeDateByPlusMonths(curDateTime,1);
					}				
					break;

				case GanttChartGrid.VIEWSCOPE_THREEYEARS:
					curQuarter = 0;
					lastQuarter=-1;
					for(var quarterCnt:int=0; quarterCnt<numCol; quarterCnt++){
						curYear=curDateTime.getFullYear();
						curQuarter=curDateTime.getMonth()/3;
						if(lastYear!=curYear ){
							if(curX!=0 && colGrpWidth>colWidth && curYMH!=null){
								drawGroupHeaderText(new Rectangle(lastX, 0, colGrpWidth, headerHeight), curYMH);
								lastX=curX; 
								colGrpWidth=0;
								drawColumnGroupLine(g, curX, colWidth, isWorkTime);
							}
							curYMH=workCalendar.fullYearToString(curDateTime);
						}
						if(curQuarter!=lastQuarter){
							drawHeaderText(new Rectangle(curX, headerHeight, colWidth, headerHeight), workCalendar.quarterToStringShort(curQuarter+1), isWorkTime); 
							curX+=colWidth;
							colGrpWidth+=colWidth;
							if(quarterCnt+1<numCol)
								drawColumnLine(g, curX, colWidth, isWorkTime);
						}			
						lastYear=curYear;lastQuarter=curQuarter;
						CalendarUtil.changeDateByPlusMonths(curDateTime,3);
					}				
					break;
			}
			drawColumnGroupLine(g, curX, colWidth, isWorkTime, true);
			drawGroupHeaderText(new Rectangle(lastX, 0, colGrpWidth, headerHeight), curYMH);
			drawChartRows(g);
			addMoveButtons();

		}		
	}
}