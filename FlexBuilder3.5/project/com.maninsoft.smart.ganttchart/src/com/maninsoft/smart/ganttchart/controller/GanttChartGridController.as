package com.maninsoft.smart.ganttchart.controller
{
	import com.maninsoft.smart.ganttchart.editor.GanttChart;
	import com.maninsoft.smart.ganttchart.model.GanttChartGrid;
	import com.maninsoft.smart.ganttchart.server.WorkCalendar;
	import com.maninsoft.smart.ganttchart.server.WorkHour;
	import com.maninsoft.smart.ganttchart.util.CalendarUtil;
	import com.maninsoft.smart.ganttchart.view.GanttChartGridView;
	import com.maninsoft.smart.modeler.editor.events.DiagramChangeEvent;
	import com.maninsoft.smart.modeler.view.NodeView;
	import com.maninsoft.smart.modeler.xpdl.controller.XPDLNodeController;
	import com.maninsoft.smart.workbench.common.event.DateCallbackEvent;
	import com.maninsoft.smart.workbench.common.event.LoadCallbackEvent;
	
	import flash.geom.Rectangle;

	public class GanttChartGridController extends XPDLNodeController
	{
		public function GanttChartGridController(model:GanttChartGrid)
		{
			super(model);
			
		}

		public function get ganttChartGrid(): GanttChartGrid {
			return model as GanttChartGrid;
		}

		public function get workCalendar(): WorkCalendar{
			return GanttChart(editor).workCalendar;
		}
		
		override protected function createNodeView(): NodeView {
			return new GanttChartGridView();
		}

		override protected function initNodeView(nodeView:NodeView): void {
			super.initNodeView(nodeView);

			var v: GanttChartGridView 	= nodeView as GanttChartGridView;
			var m: GanttChartGrid 		= ganttChartGrid;

			m.diagram.addEventListener(DiagramChangeEvent.NODE_ADDED, doDiagramChanged);
			m.diagram.addEventListener(DiagramChangeEvent.NODE_REMOVED, doDiagramChanged);

			resetWindowSize(m,v);
			resetPivotDates(m,v);

			v.workCalendar = m.workCalendar = workCalendar;
						
			v.title 	= m.processName;
			v.viewScope	= m.viewScope;
			v.bufferRows= m.bufferRows;
			v.startDate = m.startDate;
			v.endDate	= m.endDate;
			v.numTasks	= m.numTasks;
			
			var contentHeight:Number;
			if(editor.readOnly && smartWorkbench.id == "diagramViewer" ){
				contentHeight = smartWorkbench.editorHeaderToolBar.height+v.nodeHeight+11;
			}else{
				contentHeight = smartWorkbench.ganttChartEditor.editorHeaderToolBar.height+v.nodeHeight+15;
			}

			if(contentHeight != smartWorkbench.height)
				smartWorkbench.dispatchEvent(new LoadCallbackEvent(LoadCallbackEvent.LOAD_CALLBACK, LoadCallbackEvent.STAGENAME_GANTT, contentHeight));
			smartWorkbench.dispatchEvent(new DateCallbackEvent(DateCallbackEvent.DATE_CALLBACK,
															workCalendar.fullDayToStringShort(ganttChartGrid.startDate),
															workCalendar.fullDayToStringShort(new Date(ganttChartGrid.endDate.time-1))));
		}		

		public function getViewBounds(): Rectangle{
			return NodeView(this.view).bounds;
		}

		private function resetWindowSize(model: GanttChartGrid, view: GanttChartGridView): void{
			if(editor.readOnly)
				model.width = editor.parentApplication.width - GanttChartGrid.CHARTMORE_WIDTH*2 - 4;
			else
				model.width = editor.parentApplication.width - GanttChartGrid.CHARTMORE_WIDTH*2 - (smartWorkbench.ganttChartEditor.ganttToolBox.width+4+1+8);
			view.nodeHeight= model.height;
			view.nodeWidth	= model.width;
		}
		
		public function refreshWindowSize():void{
			var v: GanttChartGridView 	= view as GanttChartGridView;
			var m: GanttChartGrid 		= this.ganttChartGrid;
			resetWindowSize(m, v);
			resetPivotDates(m,v);
			v.refresh();
			m.diagram.dispatchEvent(new DiagramChangeEvent(DiagramChangeEvent.CHART_REFRESHED, m, "", null));
		}

		protected function doDiagramChanged(event:DiagramChangeEvent): void{
			var v: GanttChartGridView 	= view as GanttChartGridView;
			var m: GanttChartGrid 		= this.ganttChartGrid;
			resetWindowSize(m, v);
			v.numTasks 	= m.numTasks;			
			v.bufferRows= m.bufferRows;
			v.refresh();
			var contentHeight:Number;
			if(editor.readOnly && smartWorkbench.id == "diagramViewer" ){
				contentHeight = smartWorkbench.editorHeaderToolBar.height+v.nodeHeight+11;
			}else{
				contentHeight = smartWorkbench.ganttChartEditor.editorHeaderToolBar.height+v.nodeHeight+15;
			}
			if(contentHeight != smartWorkbench.height)
				smartWorkbench.dispatchEvent(new LoadCallbackEvent(LoadCallbackEvent.LOAD_CALLBACK, LoadCallbackEvent.STAGENAME_GANTT, contentHeight));
		}

		override public function canSelect(x: Number, y: Number): Boolean {
			return false;
		}
		
		override protected function showSelection(): Boolean {
			return false;
		}
		
		override protected function hideSelection(): Boolean {
			return false;
		}
		
		override public function refreshSelection(): void {
		}

		override public function canMoveBy(dx: Number, dy: Number): Boolean {
			return false;
		}
				 
		override public function moveBy(dx: Number, dy: Number): void {
		}

		private function canMoveToLeft(baseDate:Date):Boolean{
			var m:GanttChartGrid = model as GanttChartGrid;
			return baseDate.time>=m.chartBaseDate.time;
		}
		
		public function setViewScope(viewScope:int, startDate: Date=null): void{
			var m:GanttChartGrid = model as GanttChartGrid;
			var v:GanttChartGridView = view as GanttChartGridView;
			if(viewScope > -1 && viewScope < GanttChartGrid.VIEWSCOPE_COLUMNS.length){
				m.viewScope=viewScope;
				if(startDate){
					m.startDate.time = startDate.time;
					m.pivotDate = null;	
				}
				resetPivotDates(m,v);
				v.viewScope = m.viewScope;
				v.refresh();
				m.diagram.dispatchEvent(new DiagramChangeEvent(DiagramChangeEvent.CHART_REFRESHED, m, "", null));
				smartWorkbench.dispatchEvent(new DateCallbackEvent(DateCallbackEvent.DATE_CALLBACK,
															workCalendar.fullDayToStringShort(ganttChartGrid.startDate),
															workCalendar.fullDayToStringShort(new Date(ganttChartGrid.endDate.time-1))));
			}
		}

		public function levelUpViewScope(): void{
			var m:GanttChartGrid = model as GanttChartGrid;
			var v:GanttChartGridView = view as GanttChartGridView;
			if(m.viewScope < GanttChartGrid.VIEWSCOPE_COLUMNS.length-1){
				m.viewScope++;
				resetPivotDates(m,v);
				v.viewScope = m.viewScope;
				v.refresh();
				m.diagram.dispatchEvent(new DiagramChangeEvent(DiagramChangeEvent.CHART_REFRESHED, m, "", null));
				smartWorkbench.dispatchEvent(new DateCallbackEvent(DateCallbackEvent.DATE_CALLBACK,
															workCalendar.fullDayToStringShort(ganttChartGrid.startDate),
															workCalendar.fullDayToStringShort(new Date(ganttChartGrid.endDate.time-1))));
			}
		}

		public function levelDownViewScope(): void{
			var m:GanttChartGrid = model as GanttChartGrid;
			var v:GanttChartGridView = view as GanttChartGridView;
			if(m.viewScope > 0){
				m.viewScope--;
				resetPivotDates(m,v);
				v.viewScope = m.viewScope;
				v.refresh();
				m.diagram.dispatchEvent(new DiagramChangeEvent(DiagramChangeEvent.CHART_REFRESHED, m, "", null));
				smartWorkbench.dispatchEvent(new DateCallbackEvent(DateCallbackEvent.DATE_CALLBACK,
															workCalendar.fullDayToStringShort(ganttChartGrid.startDate),
															workCalendar.fullDayToStringShort(new Date(ganttChartGrid.endDate.time-1))));
			}			
		}
		
		public function moveToLeftPage(): void {
			var m:GanttChartGrid = model as GanttChartGrid;
			var v:GanttChartGridView = view as GanttChartGridView;
			var numCol:int = GanttChartGrid.VIEWSCOPE_COLUMNS[v.viewScope];
			switch(m.viewScope){
				case GanttChartGrid.VIEWSCOPE_WORKHOURS:
					CalendarUtil.changeDateByMinusHours(m.startDate, 24);
					if(!canMoveToLeft(m.startDate)) m.startDate.time = m.chartBaseDate.time;
					var workHour: WorkHour = workCalendar.getWorkHour(m.startDate);
					while(!workHour || workHour.workTime==0){
						CalendarUtil.changeDateByMinusHours(m.startDate, 24);
						workHour = workCalendar.getWorkHour(m.startDate);
					}     	 			           	 	
					break;
				case GanttChartGrid.VIEWSCOPE_ONEDAY:
					CalendarUtil.changeDateByMinusHours(m.startDate,numCol);
					if(!canMoveToLeft(m.startDate)) m.startDate.time = m.chartBaseDate.time;
					break;
				case GanttChartGrid.VIEWSCOPE_ONEWEEK:
					CalendarUtil.changeDateByMinusDays(m.startDate,numCol);     	 			           	 	
					if(!canMoveToLeft(m.startDate)) m.startDate.time = m.chartBaseDate.time;
					break;
				case GanttChartGrid.VIEWSCOPE_ONEMONTH:
					CalendarUtil.changeDateByMinusMonths(m.startDate,1);
					if(!canMoveToLeft(m.startDate)) m.startDate.time = m.chartBaseDate.time;
					break;
				case GanttChartGrid.VIEWSCOPE_ONEYEAR:
					CalendarUtil.changeDateByMinusMonths(m.startDate,numCol);     	 			           	 	
					if(!canMoveToLeft(m.startDate)) m.startDate.time = m.chartBaseDate.time;
					break;
				case GanttChartGrid.VIEWSCOPE_THREEYEARS:
					CalendarUtil.changeDateByMinusMonths(m.startDate,numCol/3);     	 			           	 	
					if(!canMoveToLeft(m.startDate)) m.startDate.time = m.chartBaseDate.time;
					break;
			}
			m.pivotDate = null;
			resetPivotDates(m,v);
			v.refresh();
			m.diagram.dispatchEvent(new DiagramChangeEvent(DiagramChangeEvent.CHART_REFRESHED, m, "", null));
			smartWorkbench.dispatchEvent(new DateCallbackEvent(DateCallbackEvent.DATE_CALLBACK,
															workCalendar.fullDayToStringShort(ganttChartGrid.startDate),
															workCalendar.fullDayToStringShort(new Date(ganttChartGrid.endDate.time-1))));
		}
		
		public function moveToRightPage(): void {
			var m:GanttChartGrid = model as GanttChartGrid;
			var v:GanttChartGridView = view as GanttChartGridView;
			var numCol:int = GanttChartGrid.VIEWSCOPE_COLUMNS[v.viewScope];
			switch(v.viewScope){
				case GanttChartGrid.VIEWSCOPE_WORKHOURS:
					CalendarUtil.changeDateByPlusHours(m.startDate, 24);
					var workHour: WorkHour = workCalendar.getWorkHour(m.startDate);
					while(!workHour || workHour.workTime==0){
						CalendarUtil.changeDateByPlusHours(m.startDate, 24);
						workHour = workCalendar.getWorkHour(m.startDate);
					}     	 			           	 	
					break;
				case GanttChartGrid.VIEWSCOPE_ONEDAY:
					CalendarUtil.changeDateByPlusHours(m.startDate, numCol);     	 			           	 	
					break;
				case GanttChartGrid.VIEWSCOPE_ONEWEEK:
					CalendarUtil.changeDateByPlusDays(m.startDate,numCol);     	 			           	 	
					break;
				case GanttChartGrid.VIEWSCOPE_ONEMONTH:
					CalendarUtil.changeDateByPlusMonths(m.startDate, 1);
					break;
				case GanttChartGrid.VIEWSCOPE_ONEYEAR:
					CalendarUtil.changeDateByPlusMonths(m.startDate,numCol);     	 			           	 	
					break;
				case GanttChartGrid.VIEWSCOPE_THREEYEARS:
					CalendarUtil.changeDateByPlusMonths(m.startDate,numCol/3);     	 			           	 	
					break;
			}
			m.pivotDate = null;
			resetPivotDates(m,v);
			v.refresh();
			m.diagram.dispatchEvent(new DiagramChangeEvent(DiagramChangeEvent.CHART_REFRESHED, m, "", null));
			smartWorkbench.dispatchEvent(new DateCallbackEvent(DateCallbackEvent.DATE_CALLBACK,
															workCalendar.fullDayToStringShort(ganttChartGrid.startDate),
															workCalendar.fullDayToStringShort(new Date(ganttChartGrid.endDate.time-1))));
		}		

		public function moveToLeftStep(): void {
			var m:GanttChartGrid = model as GanttChartGrid;
			var v:GanttChartGridView = view as GanttChartGridView;
			var numCol:int = GanttChartGrid.VIEWSCOPE_COLUMNS[v.viewScope];
			var baseDate:Date = new Date(m.startDate.time);
			switch(m.viewScope){
				case GanttChartGrid.VIEWSCOPE_WORKHOURS:
					CalendarUtil.changeDateByMinusHours(baseDate, 24);
					var workHour: WorkHour = workCalendar.getWorkHour(baseDate);
					while(!workHour || workHour.workTime==0){
						CalendarUtil.changeDateByMinusHours(baseDate, 24);
						workHour = workCalendar.getWorkHour(baseDate);
					}     	 			           	 	
					if(!canMoveToLeft(baseDate)) return;
					m.startDate = baseDate;
					break;
				case GanttChartGrid.VIEWSCOPE_ONEDAY:
					CalendarUtil.changeDateByMinusHours(baseDate,1);
					if(!canMoveToLeft(baseDate)) return;
					m.startDate = baseDate;
					break;
				case GanttChartGrid.VIEWSCOPE_ONEWEEK:
					CalendarUtil.changeDateByMinusDays(baseDate,1);     	 			           	 	
					if(!canMoveToLeft(baseDate)) return;
					m.startDate = baseDate;
					break;
				case GanttChartGrid.VIEWSCOPE_ONEMONTH:
					CalendarUtil.changeDateByMinusDays(baseDate,1);
					if(!canMoveToLeft(baseDate)) return;
					m.startDate = baseDate;
					break;
				case GanttChartGrid.VIEWSCOPE_ONEYEAR:
					CalendarUtil.changeDateByMinusMonths(baseDate,1);     	 			           	 	
					if(canMoveToLeft(baseDate))
						m.startDate = baseDate;
					else
						m.startDate.time = m.chartBaseDate.time;
					break;
				case GanttChartGrid.VIEWSCOPE_THREEYEARS:
					CalendarUtil.changeDateByMinusMonths(baseDate,3);     	 			           	 	
					if(canMoveToLeft(baseDate))
						m.startDate = baseDate;
					else
						m.startDate.time = m.chartBaseDate.time;
					break;
			}
			m.pivotDate = null;
			resetPivotDates(m,v);
			v.refresh();
			m.diagram.dispatchEvent(new DiagramChangeEvent(DiagramChangeEvent.CHART_REFRESHED, m, "", null));
			smartWorkbench.dispatchEvent(new DateCallbackEvent(DateCallbackEvent.DATE_CALLBACK,
															workCalendar.fullDayToStringShort(ganttChartGrid.startDate),
															workCalendar.fullDayToStringShort(new Date(ganttChartGrid.endDate.time-1))));
		}
		
		public function moveToRightStep(): void {
			var m:GanttChartGrid = model as GanttChartGrid;
			var v:GanttChartGridView = view as GanttChartGridView;
			var numCol:int = GanttChartGrid.VIEWSCOPE_COLUMNS[v.viewScope];
			switch(v.viewScope){
				case GanttChartGrid.VIEWSCOPE_WORKHOURS:
					CalendarUtil.changeDateByPlusHours(m.startDate, 24);
					var workHour: WorkHour = workCalendar.getWorkHour(m.startDate);
					while(!workHour || workHour.workTime==0){
						CalendarUtil.changeDateByPlusHours(m.startDate, 24);
						workHour = workCalendar.getWorkHour(m.startDate);
					}     	 			           	 	
					break;
				case GanttChartGrid.VIEWSCOPE_ONEDAY:
					CalendarUtil.changeDateByPlusHours(m.startDate, 1);     	 			           	 	
					break;
				case GanttChartGrid.VIEWSCOPE_ONEWEEK:
					CalendarUtil.changeDateByPlusDays(m.startDate,1);     	 			           	 	
					break;
				case GanttChartGrid.VIEWSCOPE_ONEMONTH:
					CalendarUtil.changeDateByPlusDays(m.startDate, 1);
					break;
				case GanttChartGrid.VIEWSCOPE_ONEYEAR:
					CalendarUtil.changeDateByPlusMonths(m.startDate,1);     	 			           	 	
					break;
				case GanttChartGrid.VIEWSCOPE_THREEYEARS:
					CalendarUtil.changeDateByPlusMonths(m.startDate,3);     	 			           	 	
					break;
			}
			m.pivotDate = null;	
			resetPivotDates(m,v);
			v.refresh();
			m.diagram.dispatchEvent(new DiagramChangeEvent(DiagramChangeEvent.CHART_REFRESHED, m, "", null));
			smartWorkbench.dispatchEvent(new DateCallbackEvent(DateCallbackEvent.DATE_CALLBACK,
															workCalendar.fullDayToStringShort(ganttChartGrid.startDate),
															workCalendar.fullDayToStringShort(new Date(ganttChartGrid.endDate.time-1))));
		}		

		public function moveToTheDate(startDate:Date, endDate:Date): void {
			var m:GanttChartGrid = model as GanttChartGrid;
			var v:GanttChartGridView = view as GanttChartGridView;
			if(!startDate && !endDate) return;
			if(!startDate){
				var numCol:int = GanttChartGrid.VIEWSCOPE_COLUMNS[v.viewScope];
				startDate = new Date(endDate.time);
				switch(v.viewScope){
					case GanttChartGrid.VIEWSCOPE_WORKHOURS:
						CalendarUtil.changeDateByMinusHours(startDate, 24-1);
						var workHour: WorkHour = workCalendar.getWorkHour(startDate);
						while(!workHour || workHour.workTime==0){
							CalendarUtil.changeDateByMinusHours(startDate, 24);
							workHour = workCalendar.getWorkHour(startDate);
						}     	 			           	 	
						break;
					case GanttChartGrid.VIEWSCOPE_ONEDAY:
						CalendarUtil.changeDateByMinusHours(startDate, numCol-1);     	 			           	 	
						break;
					case GanttChartGrid.VIEWSCOPE_ONEWEEK:
						CalendarUtil.changeDateByMinusDays(startDate,numCol-1);     	 			           	 	
						break;
					case GanttChartGrid.VIEWSCOPE_ONEMONTH:
						CalendarUtil.changeDateByMinusMonths(startDate,1);     	 			           	 	
						CalendarUtil.changeDateByPlusDays(startDate,1);     	 			           	 	
						break;
					case GanttChartGrid.VIEWSCOPE_ONEYEAR:
						CalendarUtil.changeDateByMinusMonths(startDate,numCol-1);     	 			           	 	
						break;
					case GanttChartGrid.VIEWSCOPE_THREEYEARS:
						CalendarUtil.changeDateByMinusMonths(startDate,numCol/3-1);     	 			           	 	
						break;
			}
				
			}
			m.startDate.time = startDate.time;
			m.pivotDate = null;	
			resetPivotDates(m,v);
			v.refresh();
			m.diagram.dispatchEvent(new DiagramChangeEvent(DiagramChangeEvent.CHART_REFRESHED, m, "", null));
			smartWorkbench.dispatchEvent(new DateCallbackEvent(DateCallbackEvent.DATE_CALLBACK,
															workCalendar.fullDayToStringShort(ganttChartGrid.startDate),
															workCalendar.fullDayToStringShort(new Date(ganttChartGrid.endDate.time-1))));
		}		

		private function resetPivotDates(m: GanttChartGrid, v: GanttChartGridView): void{
			var numCol:int = GanttChartGrid.VIEWSCOPE_COLUMNS[m.viewScope];
			
			if(m.pivotDate){
				m.startDate.time = m.endDate.time = m.pivotDate.time;	
				switch (m.viewScope){
					case GanttChartGrid.VIEWSCOPE_WORKHOURS:
						var workHour: WorkHour = workCalendar.getWorkHour(m.startDate);
						while(!workHour || workHour.workTime==0){
							CalendarUtil.changeDateByPlusHours(m.startDate, 24);
							workHour = workCalendar.getWorkHour(m.startDate);
						}
						m.startDate.setHours(workHour.startInHour,0,0);
						m.endDate.time = m.startDate.time;
						m.endDate.setHours(workHour.endInHour,0,0);
						break;
					case GanttChartGrid.VIEWSCOPE_ONEDAY:
						CalendarUtil.changeDateByMinusHours(m.startDate,numCol/2);
						m.startDate.setMinutes(0,0);
						if(!canMoveToLeft(m.startDate)) m.startDate.time = m.chartBaseDate.time;
						m.endDate.time = m.startDate.time;
						CalendarUtil.changeDateByPlusHours(m.endDate,numCol);					
						break;
					case GanttChartGrid.VIEWSCOPE_ONEWEEK:
						CalendarUtil.changeDateByMinusDays(m.startDate,numCol/2);
						m.startDate.setHours(0,0,0);
						if(!canMoveToLeft(m.startDate)) m.startDate.time = m.chartBaseDate.time;
						m.endDate.time = m.startDate.time;
						CalendarUtil.changeDateByPlusDays(m.endDate,numCol);					
						break;
					case GanttChartGrid.VIEWSCOPE_ONEMONTH:
						CalendarUtil.changeDateByMinusDays(m.startDate,15);
						m.startDate.setHours(0,0,0);
						if(!canMoveToLeft(m.startDate)) m.startDate.time = m.chartBaseDate.time;
						m.endDate.time = m.startDate.time;
						CalendarUtil.changeDateByPlusDays(m.endDate,CalendarUtil.getDaysInMonth(m.startDate.getFullYear(),m.startDate.getMonth()+1));					
						break;
					case GanttChartGrid.VIEWSCOPE_ONEYEAR:
						CalendarUtil.changeDateByMinusMonths(m.startDate,numCol/2);
						m.startDate.setDate(1);
						m.startDate.setHours(0,0,0);
						if(!canMoveToLeft(m.startDate)) m.startDate.time = m.chartBaseDate.time;
						m.endDate.time = m.startDate.time;
						CalendarUtil.changeDateByPlusMonths(m.endDate,numCol);					
						break;
					case GanttChartGrid.VIEWSCOPE_THREEYEARS:
						CalendarUtil.changeDateByMinusMonths(m.startDate,numCol/2);
						m.startDate.setDate(1);
						m.startDate.setHours(0,0,0);
						if(!canMoveToLeft(m.startDate)) m.startDate.time = m.chartBaseDate.time;
						m.endDate.time = m.startDate.time;
						CalendarUtil.changeDateByPlusMonths(m.endDate,numCol);					
						break;
				}
			}else{
				switch (m.viewScope){
					case GanttChartGrid.VIEWSCOPE_WORKHOURS:
						workHour = workCalendar.getWorkHour(m.startDate);
						while(!workHour || workHour.workTime==0 || !canMoveToLeft(m.startDate)){
							CalendarUtil.changeDateByPlusHours(m.startDate, 24);
							workHour = workCalendar.getWorkHour(m.startDate);
						}
						m.startDate.setHours(workHour.startInHour,0,0);
						m.endDate.time = m.startDate.time;
						m.endDate.setHours(workHour.endInHour,0,0);
						break;
					case GanttChartGrid.VIEWSCOPE_ONEDAY:
						m.startDate.setMinutes(0,0);
						m.endDate.time = m.startDate.time;
						CalendarUtil.changeDateByPlusHours(m.endDate,numCol);					
						break;
					case GanttChartGrid.VIEWSCOPE_ONEWEEK:
						m.startDate.setHours(0,0,0);
						m.endDate.time = m.startDate.time;
						CalendarUtil.changeDateByPlusDays(m.endDate,numCol);					
						break;
					case GanttChartGrid.VIEWSCOPE_ONEMONTH:
						m.startDate.setHours(0,0,0);
						m.endDate.time = m.startDate.time;
						CalendarUtil.changeDateByPlusDays(m.endDate,CalendarUtil.getDaysInMonth(m.startDate.getFullYear(),m.startDate.getMonth()+1));					
						break;
					case GanttChartGrid.VIEWSCOPE_ONEYEAR:
						m.startDate.setDate(1);
						if(!canMoveToLeft(m.startDate)) m.startDate.time = m.chartBaseDate.time;
						m.startDate.setHours(0,0,0);
						m.endDate.time = m.startDate.time;
						CalendarUtil.changeDateByPlusMonths(m.endDate,numCol);					
						break;
					case GanttChartGrid.VIEWSCOPE_THREEYEARS:
						m.startDate.setDate(1);
						if(!canMoveToLeft(m.startDate)) m.startDate.time = m.chartBaseDate.time;
						m.startDate.setHours(0,0,0);
						m.endDate.time = m.startDate.time;
						CalendarUtil.changeDateByPlusMonths(m.endDate,numCol);					
						break;
				}
				
			}
			v.startDate.time = m.startDate.time;
			v.endDate.time	= m.endDate.time;
			if(m.chartBaseDate && m.startDate.time<= m.chartBaseDate.time)
				v.showMoveLeftIcon = false;
			else
				v.showMoveLeftIcon = true;
		}

		override public function showConnectFeedback(): void {
			hideConnectFeedback();
		}
		
		override public function hideConnectFeedback():void{
		}

		override public function get leftMargin(): Number {
			return -GanttChartGrid.CHARTMORE_WIDTH;
		}		

		private function get smartWorkbench():Object{
			
			var ganttChartEditor:Object = this.editor.parentDocument as Object;
			if(editor.readOnly && ganttChartEditor.id == "diagramViewer")
				return ganttChartEditor;
			else
				return ganttChartEditor.parentDocument as Object;
		}
	}
}