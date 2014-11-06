import com.maninsoft.smart.ganttchart.controller.GanttChartGridController;
import com.maninsoft.smart.ganttchart.model.GanttChartGrid;
import com.maninsoft.smart.ganttchart.model.process.GanttPackage;
import com.maninsoft.smart.ganttchart.parser.GanttReader;
import com.maninsoft.smart.ganttchart.util.CalendarUtil;
import com.maninsoft.smart.modeler.editor.events.SelectionEvent;
import com.maninsoft.smart.modeler.xpdl.model.Pool;
import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
import com.maninsoft.smart.workbench.common.event.PagingCallbackEvent;
import com.maninsoft.smart.workbench.common.event.SelectActivityCallbackEvent;
import com.maninsoft.smart.workbench.assets.WorkbenchAssets;

import flash.external.ExternalInterface;

import mx.controls.TextArea;
import mx.core.Application;
import mx.events.ResizeEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.mxml.HTTPService;
import mx.utils.StringUtil;

private static const GANTT_MOVE_LEFT:String = "MOVE_LEFT";
private static const GANTT_MOVE_RIGHT:String = "MOVE_RIGHT";
private static const GANTT_VIEW_SCOPE_DAY:String = "DAY";
private static const GANTT_VIEW_SCOPE_WEEK:String = "WEEK";
private static const GANTT_VIEW_SCOPE_MONTH:String = "MONTH";
private static const GANTT_VIEW_SCOPE_YEAR:String = "YEAR"; 

//------------------------------------------------------------------------------
// Variables
//------------------------------------------------------------------------------

private var _msgLabel: TextArea;

//------------------------------------------------------------------------------
// Properties
//------------------------------------------------------------------------------

public var serviceUrl: String;
public var builderServiceUrl: String;
public var compId: String;
public var userId: String;
public var fromDateString: String;
public var viewScope: String;
public var conditions: String;
public var pageSize:String;
public var fromDate:Date;
public var interestTaskId: String;

//------------------------------------------------------------------------------
// Methods
//------------------------------------------------------------------------------

/**
 * instance 다이어그램을 로드한다.
 */
public function load(): void {
	
	var svc: HTTPService = new HTTPService();
	if(!fromDate) return;
	
	var toDate:Date = new Date(fromDate.time);
	switch(viewScope){
		case GANTT_VIEW_SCOPE_DAY:
			CalendarUtil.changeDateByPlusDays(toDate, 1);
			break;
		case GANTT_VIEW_SCOPE_WEEK:
			CalendarUtil.changeDateByPlusDays(toDate, 7);
			break;
		case GANTT_VIEW_SCOPE_MONTH:
			CalendarUtil.changeDateByPlusMonths(toDate, 1);
			break;
		case GANTT_VIEW_SCOPE_YEAR:
			CalendarUtil.changeDateByPlusMonths(toDate, 12);
			break;
	}
	var toDateString:String = CalendarUtil.getTaskString(toDate);
	
	svc.url = serviceUrl  
	        + "?method=monitorGanttTaskList"
	        + "&compId=" + compId
	        + "&userId=" + userId
	        + "&fromDate=" + fromDateString
	        + "&toDate=" + toDateString
	        + "&conditions=" + conditions;

	svc.showBusyCursor = true;
	svc.addEventListener("result", loadDiagram_result);
	svc.addEventListener("falut", loadDiagram_fault);
	svc.send();
//	loadDiagram_result(new ResultEvent("test"));
}

/**
 * instance 다이어그램을 로드한다.
 */
public function loadRest(): void {
	var svc: HTTPService = new HTTPService();
	svc.url = serviceUrl;  
	svc.showBusyCursor = true;
	svc.addEventListener("result", loadDiagram_result);
	svc.addEventListener("falut", loadDiagram_fault);
	svc.send();
}

private function loadDiagram_result(event: ResultEvent): void {
	var reader: GanttReader = new GanttReader(GanttPackage.GANTTCHART_BASEDATE);
	var _xpdlSource: String = StringUtil.trim(event.message.body.toString());
	var xml: XML = new XML(_xpdlSource);
//	var xml: XML = testGanttXPDLSource;
	trace("[Load Diagram Service Result]");
	trace(xml.toXMLString());
		
	if (xml.@status == "Failed") {
		if (_msgLabel == null)
			_msgLabel = new TextArea();
			
		_msgLabel.percentHeight = 100;
		_msgLabel.percentWidth = 100;
		_msgLabel.text = xml.message + "\r\n" + xml.trace;
		
		if (!xpdlViewer.contains(_msgLabel))
			xpdlViewer.addChild(_msgLabel);
		
	} else {
		if (_msgLabel && xpdlViewer.contains(_msgLabel))
			xpdlViewer.removeChild(_msgLabel);
		
		if(pageSize)
			GanttChartGrid.pageSize = parseInt(pageSize);

		xpdlViewer.serviceUrl = serviceUrl;
		xpdlViewer.builderServiceUrl = builderServiceUrl;
		xpdlViewer.compId = compId;
		xpdlViewer.userId = userId;
		xpdlViewer.activate();
		
		var dgm: XPDLDiagram = reader.parse(xml) as XPDLDiagram;
		
		dgm.pool.x = 0;
		dgm.pool.y = 0;
		xpdlViewer.diagram = dgm;

		if(GanttPackage(dgm.xpdlPackage).totalPages && GanttPackage(dgm.xpdlPackage).currentPage){
			this.dispatchEvent(new PagingCallbackEvent(PagingCallbackEvent.PAGING_CALLBACK, GanttPackage(dgm.xpdlPackage).totalPages, GanttPackage(dgm.xpdlPackage).currentPage));
		}

		for each (var act: Activity in dgm.pool.getActivities(Activity)) {
			if(act.id+"" == interestTaskId){
				act.interestStatus = true;
			}
		}
		
		xpdlViewer.gripMode = false;
		changeGanttViewScope(viewScope, fromDateString);
	}
}

private function loadDiagram_fault(event: FaultEvent): void {
	//Alert.show(event.message.toString(), "Fault");
}

//------------------------------------------------------------------------------
// Internal methods
//------------------------------------------------------------------------------
public function resetExtents(): void {
	if(xpdlViewer.diagram){
		var ctrl: GanttChartGridController = xpdlViewer.findControllerByModel(XPDLDiagram(xpdlViewer.diagram).pool) as GanttChartGridController;
		ctrl.refreshWindowSize();
	}
}

private function xpdlViewer_selectionChanged(event: SelectionEvent): void {
	var obj:Object = event.selectedItem;
	
	if (obj is TaskApplication){
		this.dispatchEvent(new SelectActivityCallbackEvent(SelectActivityCallbackEvent.SELECT_ACTIVITY_CALLBACK, TaskApplication(obj).taskId));
	}
}

private function xpdlViewer_resize(event: ResizeEvent): void {
	resetExtents();
}

public function moveGanttPage(direction:String):void{
	switch(viewScope){
		case GANTT_VIEW_SCOPE_DAY:
			if(direction == GANTT_MOVE_LEFT)
				CalendarUtil.changeDateByMinusDays(fromDate, 1);
			else if(direction == GANTT_MOVE_RIGHT)
				CalendarUtil.changeDateByPlusDays(fromDate, 1);
			fromDateString = CalendarUtil.getTaskString(fromDate);
			break;
		case GANTT_VIEW_SCOPE_WEEK:
			if(direction == GANTT_MOVE_LEFT)
				CalendarUtil.changeDateByMinusDays(fromDate, 7);
			else if(direction == GANTT_MOVE_RIGHT)
				CalendarUtil.changeDateByPlusDays(fromDate, 7);
			fromDateString = CalendarUtil.getTaskString(fromDate);
			break;
		case GANTT_VIEW_SCOPE_MONTH:
			if(direction == GANTT_MOVE_LEFT)
				CalendarUtil.changeDateByMinusMonths(fromDate, 1);
			else if(direction == GANTT_MOVE_RIGHT)
				CalendarUtil.changeDateByPlusMonths(fromDate, 1);
			fromDateString = CalendarUtil.getTaskString(fromDate);
			break;
		case GANTT_VIEW_SCOPE_YEAR:
			if(direction == GANTT_MOVE_LEFT)
				CalendarUtil.changeDateByMinusMonths(fromDate, 12);
			else if(direction == GANTT_MOVE_RIGHT)
				CalendarUtil.changeDateByPlusMonths(fromDate, 12);
			fromDateString = CalendarUtil.getTaskString(fromDate);
			break;
	}
	Application.application.parameters.fromDate = fromDateString;
	parentApplication.reload();
}

public function moveGanttStep(direction:String):void{
	switch(viewScope){
		case GANTT_VIEW_SCOPE_DAY:
			if(direction == GANTT_MOVE_LEFT)
				CalendarUtil.changeDateByMinusHours(fromDate, 1);
			else if(direction == GANTT_MOVE_RIGHT)
				CalendarUtil.changeDateByPlusHours(fromDate, 1);
			fromDateString = CalendarUtil.getTaskString(fromDate);
			break;
		case GANTT_VIEW_SCOPE_WEEK:
			if(direction == GANTT_MOVE_LEFT)
				CalendarUtil.changeDateByMinusDays(fromDate, 1);
			else if(direction == GANTT_MOVE_RIGHT)
				CalendarUtil.changeDateByPlusDays(fromDate, 1);
			fromDateString = CalendarUtil.getTaskString(fromDate);
			break;
		case GANTT_VIEW_SCOPE_MONTH:
			if(direction == GANTT_MOVE_LEFT)
				CalendarUtil.changeDateByMinusDays(fromDate, 1);
			else if(direction == GANTT_MOVE_RIGHT)
				CalendarUtil.changeDateByPlusDays(fromDate, 1);
			fromDateString = CalendarUtil.getTaskString(fromDate);
			break;
		case GANTT_VIEW_SCOPE_YEAR:
			if(direction == GANTT_MOVE_LEFT)
				CalendarUtil.changeDateByMinusMonths(fromDate, 1);
			else if(direction == GANTT_MOVE_RIGHT)
				CalendarUtil.changeDateByPlusMonths(fromDate, 1);
			fromDateString = CalendarUtil.getTaskString(fromDate);
			break;
	}
	Application.application.parameters.fromDate = fromDateString;
	parentApplication.reload();
}
			
public function changeGanttViewScope(viewScope:String, startDate:String=null):void{
	if(viewScope == GANTT_VIEW_SCOPE_DAY)
		xpdlViewer.setChartLevel(GanttChartGrid.VIEWSCOPE_ONEDAY, startDate);
	else if(viewScope == GANTT_VIEW_SCOPE_WEEK)
		xpdlViewer.setChartLevel(GanttChartGrid.VIEWSCOPE_ONEWEEK, startDate);
	else if(viewScope == GANTT_VIEW_SCOPE_MONTH)
		xpdlViewer.setChartLevel(GanttChartGrid.VIEWSCOPE_ONEMONTH, startDate);
	else if(viewScope == GANTT_VIEW_SCOPE_YEAR)
		xpdlViewer.setChartLevel(GanttChartGrid.VIEWSCOPE_ONEYEAR, startDate);
}