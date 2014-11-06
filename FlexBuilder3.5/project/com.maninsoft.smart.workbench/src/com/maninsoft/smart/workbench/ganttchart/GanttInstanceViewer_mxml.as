import com.maninsoft.smart.ganttchart.controller.GanttChartGridController;
import com.maninsoft.smart.ganttchart.model.GanttChartGrid;
import com.maninsoft.smart.ganttchart.model.process.GanttPackage;
import com.maninsoft.smart.ganttchart.parser.GanttReader;
import com.maninsoft.smart.modeler.editor.events.SelectionEvent;
import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
import com.maninsoft.smart.workbench.assets.WorkbenchAssets;
import com.maninsoft.smart.workbench.util.WorkbenchConfig;
import com.maninsoft.smart.workbench.common.event.SelectActivityCallbackEvent;

import mx.controls.TextArea;
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
public var prcInstId: String;
public var interestTaskId: String;

//------------------------------------------------------------------------------
// Methods
//------------------------------------------------------------------------------

/**
 * instance 다이어그램을 로드한다.
 */
public function load(): void {
	var svc: HTTPService = new HTTPService();
	
	svc.url = serviceUrl  
	        + "?method=monitorPrcInst"
	        + "&compId=" + compId
	        + "&userId=" + userId
	        + "&prcInstId=" + prcInstId;

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
		
		xpdlViewer.serviceUrl = serviceUrl;
		xpdlViewer.builderServiceUrl = builderServiceUrl;
		xpdlViewer.compId = compId;
		xpdlViewer.userId = userId;
		xpdlViewer.activate();
		
		var dgm: XPDLDiagram = reader.parse(xml) as XPDLDiagram;
		
		dgm.pool.x = 0;
		dgm.pool.y = 0;
		xpdlViewer.diagram = dgm;
		
//		for each (var act: Activity in dgm.pool.getActivities(Activity)) {
//			act.effectStatus = act.status;
//			act.status = Activity.STATUS_NONE;
//		}
//
//		for each (var link: Link in dgm.links) {
//			link.lineColor = 0x888888;
//			link.lineWidth = 1;
//		}

		for each (var act: Activity in dgm.pool.getActivities(Activity)) {
			if(act.id+"" == interestTaskId){
				act.interestStatus = true;
			}
		}
		
		xpdlViewer.gripMode = false;
	}
}

private function loadDiagram_fault(event: FaultEvent): void {
	//Alert.show(event.message.toString(), "Fault");
}

public function loadFromLocal(): void {
	var svc: HTTPService = new HTTPService();
	
	svc.url = "file://C:/Documents and Settings/sohong/My Documents/Flex Builder 3/com.maninsoft.smart.modeler/doc/xpdl/demo.xml";

	svc.showBusyCursor = true;
	svc.addEventListener("result", loadDiagram_result);
	svc.addEventListener("falut", loadDiagram_fault);

	svc.send();
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
		this.dispatchEvent(new SelectActivityCallbackEvent(SelectActivityCallbackEvent.SELECT_ACTIVITY_CALLBACK, TaskApplication(obj).id.toString()));
	}
}

private function xpdlViewer_resize(event: ResizeEvent): void {
	resetExtents();
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