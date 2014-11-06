////////////////////////////////////////////////////////////////////////////////
//  DiagramViewer_mxml.as
//  2008.03.27, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////
import com.maninsoft.smart.modeler.common.Size;
import com.maninsoft.smart.modeler.editor.events.SelectionEvent;
import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
import com.maninsoft.smart.modeler.xpdl.server.service.LoadDiagramService;
import com.maninsoft.smart.workbench.common.event.SelectActivityCallbackEvent;

import flash.events.TimerEvent;
import flash.utils.Timer;

import mx.events.ResizeEvent;

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
 * processId
 */
public var processId: String;

/**
 * version
 */
public var version: String;


//------------------------------------------------------------------------------
// Methods
//------------------------------------------------------------------------------

/**
 * diagram을 로드한다.
 */
public function load(): void {
	var svc: LoadDiagramService = new LoadDiagramService();
	svc.serviceUrl = serviceUrl;
	svc.compId = compId;
	svc.userId = userId;
	svc.processId = processId;
	svc.version = version;
	svc.resultHandler = loadDiagram_result;
	svc.send();
}

private function loadDiagram_result(svc: LoadDiagramService): void {	
	try {
		xpdlViewer.serviceUrl = serviceUrl;
		xpdlViewer.builderServiceUrl = builderServiceUrl;
		xpdlViewer.compId = compId;
		xpdlViewer.userId = userId;
		xpdlViewer.activate();
		svc.diagram.pool.x = 0;
		svc.diagram.pool.y = 0;
		xpdlViewer.diagram = svc.diagram;
		xpdlViewer.gripMode = true;
	} finally {
		//xpdlViewer.endLoading();
	}
}
/*
public function loadDiagram(diagram: XPDLDiagram): void {	
	try {
		xpdlViewer.activate();
		diagram.pool.x = 0;
		diagram.pool.y = 0;
		xpdlViewer.diagram = diagram;
		xpdlViewer.gripMode = true;
	} finally {
		//xpdlViewer.endLoading();
	}
}
*/
//------------------------------------------------------------------------------
// Internal methods
//------------------------------------------------------------------------------

private var _oldZoom: Number;
private var _newZoom: Number;
private var _repeatDelay: Number = 10;
private var _repeatCount: Number = 20;
private var _zooming:Boolean=false;
public function resetExtents(): void {
	if(xpdlViewer.xpdlDiagram && !_zooming && xpdlViewer.width && xpdlViewer.height) {
		_zooming=true;
		var sz: Size = xpdlViewer.xpdlDiagram.pool.size;
		sz.width += 20;
		sz.height += xpdlViewer.scrollMargin;
		var zx: Number = xpdlViewer.width * 100 / sz.width;
		var zy: Number = xpdlViewer.height * 100 / sz.height;
		xpdlViewer.zoom = Math.min(zx, zy) - 50;
		
		this.diagramScale.value = xpdlViewer.zoom;
		
		_oldZoom = xpdlViewer.zoom ;
		_newZoom = xpdlViewer.zoom+40;
		
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
	this.diagramScale.value = xpdlViewer.zoom;
	_zooming=false;
}

private function xpdlViewer_resize(event: ResizeEvent): void {
	resetExtents();
}

public function sliderChange():void{
	xpdlViewer.zoom = this.diagramScale.value;
}

private function xpdlViewer_selectionChanged(event: SelectionEvent): void {
	var obj:Object = event.selectedItem;
	
	if (obj is TaskApplication){
		this.dispatchEvent(new SelectActivityCallbackEvent(SelectActivityCallbackEvent.SELECT_ACTIVITY_CALLBACK, TaskApplication(obj).id.toString()));
	}
}

public function fitMap():void{
	resetExtents();
}