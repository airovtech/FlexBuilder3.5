////////////////////////////////////////////////////////////////////////////////
//  DiagramViewer_mxml.as
//  2008.03.27, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////
import com.maninsoft.smart.ganttchart.controller.GanttChartGridController;
import com.maninsoft.smart.ganttchart.model.GanttChartGrid;
import com.maninsoft.smart.ganttchart.server.service.LoadGanttDiagramService;
import com.maninsoft.smart.ganttchart.util.CalendarUtil;
import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
import com.maninsoft.smart.workbench.common.event.SelectActivityCallbackEvent;
import com.maninsoft.smart.workbench.util.WorkbenchConfig;

import mx.events.ResizeEvent;

private static const GANTT_MOVE_LEFT:String = "MOVE_LEFT";
private static const GANTT_MOVE_RIGHT:String = "MOVE_RIGHT";
private static const GANTT_VIEW_SCOPE_DAY:String = "DAY";
private static const GANTT_VIEW_SCOPE_WEEK:String = "WEEK";
private static const GANTT_VIEW_SCOPE_MONTH:String = "MONTH";
private static const GANTT_VIEW_SCOPE_YEAR:String = "YEAR"; 

//------------------------------------------------------------------------------
// Properties
//------------------------------------------------------------------------------

public var serviceUrl: String;
public var builderServiceUrl: String;
public var compId: String;
public var userId: String;
public var processId: String;
public var version: String;

//------------------------------------------------------------------------------
// Methods
//------------------------------------------------------------------------------

/**
 * diagram을 로드한다.
 */
public function load(): void {
	var dueDate: Date = CalendarUtil.getTaskDate(WorkbenchConfig.dueDate);
	var svc: LoadGanttDiagramService = new LoadGanttDiagramService(dueDate);
	svc.serviceUrl = serviceUrl;
	svc.compId = compId;
	svc.userId = userId;
	svc.processId = processId;
	svc.version = version;
	svc.resultHandler = loadDiagram_result;
	svc.send();
}

private function loadDiagram_result(svc: LoadGanttDiagramService): void {
	try {
		xpdlViewer.serviceUrl = serviceUrl;
		xpdlViewer.builderServiceUrl = builderServiceUrl;
		xpdlViewer.compId = compId;
		xpdlViewer.userId = userId;
		xpdlViewer.activate();
		svc.diagram.pool.x = 0;
		svc.diagram.pool.y = 0;
		xpdlViewer.diagram = svc.diagram;
	} finally {
		//xpdlViewer.endLoading();
	}
}

private function xpdlViewer_resize(event: ResizeEvent): void {
	resetExtents();
}

public function resetExtents(): void {
	if(xpdlViewer.diagram){
		var ctrl: GanttChartGridController = xpdlViewer.findControllerByModel(XPDLDiagram(xpdlViewer.diagram).pool) as GanttChartGridController;
		ctrl.refreshWindowSize();
	}
}

public function moveGanttPage(direction:String):void{
	if(direction == GANTT_MOVE_LEFT)
		xpdlViewer.chartMoveToLeftPage();
	else if(direction == GANTT_MOVE_RIGHT)
		xpdlViewer.chartMoveToRightPage();
}
			
public function changeGanttViewScope(viewScope:String):void{
	if(viewScope == GANTT_VIEW_SCOPE_DAY)
		xpdlViewer.setChartLevel(GanttChartGrid.VIEWSCOPE_ONEDAY);
	else if(viewScope == GANTT_VIEW_SCOPE_WEEK)
		xpdlViewer.setChartLevel(GanttChartGrid.VIEWSCOPE_ONEWEEK);
	else if(viewScope == GANTT_VIEW_SCOPE_MONTH)
		xpdlViewer.setChartLevel(GanttChartGrid.VIEWSCOPE_ONEMONTH);
	else if(viewScope == GANTT_VIEW_SCOPE_YEAR)
		xpdlViewer.setChartLevel(GanttChartGrid.VIEWSCOPE_ONEYEAR);
}