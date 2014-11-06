////////////////////////////////////////////////////////////////////////////////
//  InstanceViewer_mxml.as
//  2008.03.27, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////


import com.maninsoft.smart.modeler.common.Size;
import com.maninsoft.smart.modeler.editor.events.SelectionEvent;
import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
import com.maninsoft.smart.modeler.xpdl.parser.XPDLReader;
import com.maninsoft.smart.modeler.xpdl.utils.XPDLDiagramUtils;
import com.maninsoft.smart.workbench.common.event.LoadCallbackEvent;
import com.maninsoft.smart.workbench.common.event.SelectActivityCallbackEvent;
import com.maninsoft.smart.workbench.common.util.MsgUtil;

import flash.events.TimerEvent;
import flash.utils.Timer;

import mx.controls.Alert;
import mx.controls.TextArea;
import mx.events.ResizeEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.mxml.HTTPService;
import mx.utils.StringUtil;

//------------------------------------------------------------------------------
// Variables
//------------------------------------------------------------------------------

private var _msgLabel: TextArea;

//------------------------------------------------------------------------------
// Properties
//------------------------------------------------------------------------------

/**
 * serviceUrl
 */
public var serviceUrl: String;
public var builderServiceUrl: String;

/**
 * compId
 */
public var compId: String;

/**
 * userId
 */
public var userId: String;

/**
 * prcInstId
 */
public var prcInstId: String;

/**
 * interestTaskId
 */
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
	var reader: XPDLReader = new XPDLReader();
	var _xpdlSource: String = StringUtil.trim(event.message.body.toString());  
	var xml: XML = new XML(_xpdlSource);
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
		
		xpdlViewer.gripMode = true;
	}
}

private function loadDiagram_fault(event: FaultEvent): void {
	Alert.show(event.message.toString(), "Fault");
}

public function loadFromLocal(): void {
	var svc: HTTPService = new HTTPService();
	
	svc.url = "file://C:/Documents and Settings/sohong/My Documents/Flex Builder 3/com.maninsoft.smart.modeler/doc/xpdl/demo.xml";

	svc.showBusyCursor = true;
	svc.addEventListener("result", loadDiagram_result);
	svc.addEventListener("falut", loadDiagram_fault);

	svc.send();
}

public function loadDiagram(diagram: XPDLDiagram): void{

	xpdlViewer.activate();
		
	diagram.pool.x = 0;
	diagram.pool.y = 0;
	xpdlViewer.diagram = diagram;
		
	for each (var act: Activity in diagram.pool.getActivities(Activity)) {
		if(act.id+"" == interestTaskId){
			act.interestStatus = true;
		}
	}
		
	xpdlViewer.gripMode = true;	
}

//------------------------------------------------------------------------------
// Internal methods
//------------------------------------------------------------------------------

private var _oldZoom: Number;
private var _newZoom: Number;
private var _repeatDelay: Number = 10;
private var _repeatCount: Number = 20;
private var _zooming:Boolean=false;
public function resetExtents(): void {
	if (xpdlViewer.xpdlDiagram && !_zooming && xpdlViewer.width && xpdlViewer.height) {
		_zooming=true;
		var sz: Size = xpdlViewer.xpdlDiagram.pool.size;
		sz.width += 20;
		sz.height += xpdlViewer.scrollMargin;
		var zx: Number = xpdlViewer.width * 100 / sz.width;
		var zy: Number = xpdlViewer.height * 100 / sz.height;
		xpdlViewer.zoom = Math.min(zx, zy) - 56;
		
		diagramScale.value = xpdlViewer.zoom;
		
		_oldZoom = xpdlViewer.zoom;
		_newZoom = xpdlViewer.zoom + 50;
		
		var timer: Timer = new Timer(_repeatDelay, _repeatCount);
		timer.addEventListener(TimerEvent.TIMER, doTimer);
		timer.addEventListener(TimerEvent.TIMER_COMPLETE, doTimerComplete);
		timer.start();
	}
}


private function doTimer(ev: TimerEvent): void {
	xpdlViewer.zoom += (_newZoom - _oldZoom) / _repeatCount;

	var sz: Size = xpdlViewer.xpdlDiagram.pool.size;
	sz.width += 20;
	sz.height += xpdlViewer.scrollMargin;
	sz.width = sz.width * xpdlViewer.zoom / 100;
	sz.height = sz.height * xpdlViewer.zoom / 100;
	
	var dx: Number = ((xpdlViewer.width - sz.width) / 2 - xpdlViewer.scrollX) / _repeatCount * 4  / 5;
	var dy: Number = ((xpdlViewer.height - sz.height) / 2 - xpdlViewer.scrollY) / _repeatCount * 4 / 5;
	xpdlViewer.scrollBy(dx, dy);
	
	ev.updateAfterEvent();
}

private function doTimerComplete(ev: TimerEvent): void {
	xpdlViewer.zoom = _newZoom;

	var sz: Size = xpdlViewer.xpdlDiagram.pool.size;
	sz.width += 20;
	sz.height += xpdlViewer.scrollMargin;
	sz.width = sz.width * xpdlViewer.zoom / 100;
	sz.height = sz.height * xpdlViewer.zoom / 100;
	xpdlViewer.scrollTo((xpdlViewer.width - sz.width) / 2, (xpdlViewer.height - sz.height) / 2);
	xpdlViewer.playRuntimeEffect(XPDLDiagramUtils.getCompletedNodes(xpdlViewer.xpdlDiagram));	
	this.diagramScale.value = xpdlViewer.zoom;
	_zooming = false;
}

//------------------------------------------------------------------------------
// Event handlers
//------------------------------------------------------------------------------

//---------------------------
// Component
//---------------------------

//---------------------------
// xpdlViewer
//---------------------------

private function xpdlViewer_resize(event: ResizeEvent): void {
	resetExtents();
}

private function xpdlViewer_selectionChanged(event: SelectionEvent): void {
	var obj:Object = event.selectedItem;
	
	if (obj is TaskApplication){
		this.dispatchEvent(new SelectionEvent("taskSelectionCallback", new Array(obj)));		
//		this.parentDocument.dispatchEvent(new SelectionEvent("taskSelectionCallback", new Array(obj)));		
//		this.dispatchEvent(new SelectActivityCallbackEvent(SelectActivityCallbackEvent.SELECT_ACTIVITY_CALLBACK, TaskApplication(obj).id.toString()));
	}
}

private function sliderChange():void{
	xpdlViewer.zoom = this.diagramScale.value;
}

private function fitMap():void{
	resetExtents();
}	      
