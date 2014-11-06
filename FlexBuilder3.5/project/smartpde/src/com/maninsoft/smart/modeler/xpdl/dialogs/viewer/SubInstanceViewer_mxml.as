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
import com.maninsoft.smart.workbench.common.event.SelectActivityCallbackEvent;

import flash.events.TimerEvent;
import flash.utils.Timer;

import mx.controls.Alert;
import mx.controls.TextArea;
import mx.events.ResizeEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.mxml.HTTPService;
import mx.utils.StringUtil;

/**
 * interestTaskId
 */
public var interestTaskId: String;


//------------------------------------------------------------------------------
// Methods
//------------------------------------------------------------------------------

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
	if(xpdlViewer.xpdlDiagram && !_zooming && owner.width && owner.height) {
		_zooming=true;
		var sz: Size = xpdlViewer.xpdlDiagram.pool.size;
		sz.width += 20;
		sz.height += xpdlViewer.scrollMargin;
		var zx: Number = owner.width * 100 / sz.width;
		var zy: Number = owner.height * 100 / sz.height;
		xpdlViewer.zoom = Math.min(zx, zy) - 50;
		
		this.diagramScale.value = xpdlViewer.zoom;
		
		_oldZoom = xpdlViewer.zoom ;
		_newZoom = xpdlViewer.zoom+45;
		
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
	
	var dx: Number = ((owner.width - sz.width) / 2 - xpdlViewer.scrollX) / _repeatCount * 4  / 5;
	var dy: Number = ((owner.height - sz.height) / 2 - xpdlViewer.scrollY) / _repeatCount * 4 / 5;
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
	xpdlViewer.scrollTo((owner.width - sz.width) / 2, (owner.height - sz.height) / 2 - 25);
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
		this.dispatchEvent(new SelectActivityCallbackEvent(SelectActivityCallbackEvent.SELECT_ACTIVITY_CALLBACK, TaskApplication(obj).id.toString()));
	}
}

private function sliderChange():void{
	xpdlViewer.zoom = this.diagramScale.value;
}

private function fitMap():void{
	resetExtents();
}	      
