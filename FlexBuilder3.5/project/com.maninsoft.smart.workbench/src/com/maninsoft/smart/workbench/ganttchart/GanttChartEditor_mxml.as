/**
 * 
 *  Package: 		com.maninsoft.smart.ganttchart.editor
 *  Class: 			GanttChartEditor_mxml
 * 					extends None
 * 					implements None
 *  Author:			Y.S. Jung
 *  Description:	GanttChartEditor.mxml의 액션스크립트들을 모아놓은 클래스
 * 				
 *  History:		2009.12.1 Created by Y.S. Jung
 * 
 *  Copyright (C) 2007-2010 Maninsoft, Inc. All Rights Reserved.
 *  
 */
import com.maninsoft.smart.common.util.EncodeImageOpts;
import com.maninsoft.smart.common.util.SmartUtil;
import com.maninsoft.smart.ganttchart.command.GanttNodeCreateCommand;
import com.maninsoft.smart.ganttchart.controller.GanttChartGridController;
import com.maninsoft.smart.ganttchart.controller.GanttTaskGroupController;
import com.maninsoft.smart.ganttchart.model.ConstraintLine;
import com.maninsoft.smart.ganttchart.model.GanttChartGrid;
import com.maninsoft.smart.ganttchart.model.GanttMilestone;
import com.maninsoft.smart.ganttchart.model.GanttTask;
import com.maninsoft.smart.ganttchart.model.GanttTaskGroup;
import com.maninsoft.smart.ganttchart.model.process.GanttPackage;
import com.maninsoft.smart.ganttchart.parser.GanttWriter;
import com.maninsoft.smart.ganttchart.server.service.DeployGanttDiagramService;
import com.maninsoft.smart.ganttchart.server.service.GetCompanyCalendarService;
import com.maninsoft.smart.ganttchart.server.service.LoadGanttDiagramService;
import com.maninsoft.smart.ganttchart.server.service.SaveGanttDiagramService;
import com.maninsoft.smart.ganttchart.syntax.GanttSyntaxChecker;
import com.maninsoft.smart.ganttchart.util.CalendarUtil;
import com.maninsoft.smart.ganttchart.view.GanttMilestoneView;
import com.maninsoft.smart.ganttchart.view.GanttTaskGroupView;
import com.maninsoft.smart.ganttchart.view.GanttTaskView;
import com.maninsoft.smart.modeler.editor.events.CreateNodeRequestEvent;
import com.maninsoft.smart.modeler.editor.events.DiagramChangeEvent;
import com.maninsoft.smart.modeler.editor.events.SelectionEvent;
import com.maninsoft.smart.modeler.model.DiagramObject;
import com.maninsoft.smart.modeler.model.events.LinkEvent;
import com.maninsoft.smart.modeler.model.events.NodeChangeEvent;
import com.maninsoft.smart.modeler.view.NodeView;
import com.maninsoft.smart.modeler.xpdl.dialogs.SelectFormDialog;
import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
import com.maninsoft.smart.modeler.xpdl.model.base.XPDLNode;
import com.maninsoft.smart.modeler.xpdl.property.FormIdPropertyInfo;
import com.maninsoft.smart.modeler.xpdl.server.Server;
import com.maninsoft.smart.modeler.xpdl.server.TaskForm;
import com.maninsoft.smart.modeler.xpdl.server.TaskFormField;
import com.maninsoft.smart.modeler.xpdl.server.service.GetProcessInfoByPackageService;
import com.maninsoft.smart.modeler.xpdl.tool.LaneSelectionEvent;
import com.maninsoft.smart.modeler.xpdl.utils.XPDLDiagramUtils;
import com.maninsoft.smart.workbench.SmartWorkbench;
import com.maninsoft.smart.workbench.common.editor.EditDomain;
import com.maninsoft.smart.workbench.common.event.FormEditorEvent;
import com.maninsoft.smart.workbench.common.event.LoadCallbackEvent;
import com.maninsoft.smart.workbench.common.meta.impl.SWForm;
import com.maninsoft.smart.workbench.common.meta.impl.SWPackage;
import com.maninsoft.smart.workbench.common.preloader.CustomPreloadEvent;
import com.maninsoft.smart.workbench.common.property.PropertyInfo;
import com.maninsoft.smart.workbench.common.util.MsgUtil;
import com.maninsoft.smart.workbench.event.MISPackageEvent;
import com.maninsoft.smart.workbench.util.WorkbenchConfig;
import com.maninsoft.smart.ganttchart.model.GanttTaskGroup;
import com.maninsoft.smart.ganttchart.server.service.GetCompanyCalendarService;
import com.maninsoft.smart.ganttchart.server.service.LoadGanttDiagramService;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.external.ExternalInterface;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.collections.ArrayCollection;
import mx.core.DragSource;
import mx.events.DragEvent;
import mx.events.ResizeEvent;
import mx.managers.DragManager;
import mx.resources.ResourceManager;


//------------------------------------------------------------------------------
// Variables
//------------------------------------------------------------------------------

private var _syntaxChecker: GanttSyntaxChecker;
private var _packId: String;
private var _packVer: int;
private var _server: Server;
private var _xpdlSource: XML;
private var _loadDiagram: Boolean;

[Bindable]
private var swPackage:SWPackage;

[Bindable]
private var editDomain:EditDomain;

[Bindable]
private var toolBoxY:Number=10;

public var selectedObject:Object;
public var selectedForm:SWForm;

//------------------------------------------------------------------------------
// Internal methods
//------------------------------------------------------------------------------

/**
 * 	Function Name : serverLoad
 * 	Params :
 * 		packId:String
 * 		packVer
 * 	간트차트에디터가 호출될때, 서버에서 간트차트에디터에 필요한 패키지 관련 정보들을 불러와 로딩하는 기능을 한다.
 */			
public function serverLoad(packId: String, packVer: int, spk:SWPackage, ed:EditDomain, loadDiagram: Boolean, resultFunc: Function=null, formId: String=null):void{
	_packId = packId;
	_packVer = packVer;
	_loadDiagram = loadDiagram;
	swPackage = spk;
	editDomain = ed;
	if (_server == null) {
		_server = new Server(WorkbenchConfig.serviceUrl, WorkbenchConfig.userId, WorkbenchConfig.compId, packId, packVer+"");
		_server.addEventListener("serverLoaded", loadServerHandler);
		ganttChart.server = _server;
		//miniXPDLEditor.server = _server;
	}
	_server.load(resultFunc, formId);
}

/**
 * 	간트차트에디터가 호출되어, 서버에서  정보들을 가져오기 위한 서비스들을 호출하기 위한 Server클래스가 로딩이 완료되었을때 호출되는 콜백함수
 */
public function loadServerHandler(event: Event):void{
	var svc: GetProcessInfoByPackageService = new GetProcessInfoByPackageService();
	svc.serviceUrl = WorkbenchConfig.serviceUrl;
	svc.userId = WorkbenchConfig.userId;
	svc.packageId = _packId;
	svc.version = _packVer+"";
	svc.resultHandler = loadServer_result;
	svc.send();
}

/**
 * 	간트차트에디터에서, 서버에 패키지관련 정보를 가져오기 위한 서비스를 호출한 결과인 콜백함수
 */
public function loadServer_result(svc: GetProcessInfoByPackageService): void {
	_server.process = svc.process;

	loadCompanyCalendar();	
}

public function loadCompanyCalendar(): void{
	
	var svc: GetCompanyCalendarService = new GetCompanyCalendarService(ganttChart.workCalendar);
	
	svc.serviceUrl = WorkbenchConfig.serviceUrl;
	svc.compId = WorkbenchConfig.compId;
	svc.userId = WorkbenchConfig.userId;

	svc.resultHandler = loadCompanyCalendar_result;
	svc.send();
}

/**
 * 간트차트에디터에 필요한 컴퍼니 캘린더정보를 서버에서 가져오는 서비스를 호출하여 결과가 리턴된 콜백 함수
 */
public function loadCompanyCalendar_result(svc: GetCompanyCalendarService): void {
	ganttChart.workCalendar = svc.workCalendar;

	if (_loadDiagram && _server.process) {
		loadDiagram();
	}
}

/**
 *  간트차트에디터에서, 호출된 패키지의 간트프로세스 정보를 서버에서 가져오는 서비스를 호출하는 함수
 */
public function loadDiagram(): void {
	var dueDate:Date = CalendarUtil.getTaskDate(WorkbenchConfig.dueDate);
	var svc: LoadGanttDiagramService = new LoadGanttDiagramService(dueDate);

/**
 * 	간트차트디버그를 위해, 서버에서 정보를 가져오는 것과 같은 테스트 xpdl데이터를 하드코드 하였다.
 * 	테스트가 아닐경우에는 아래코드를 제거해야 한다.
 */ 
//svc.setTestGanttXPDLSource(testGanttXPDLSource);
	
	svc.serviceUrl = WorkbenchConfig.serviceUrl;
	svc.userId = WorkbenchConfig.userId;
	svc.processId = _server.process.processId;
	svc.version = _packVer+"";

	svc.resultHandler = loadDiagram_result;
	svc.faultHandler = faultHandler;
	svc.send();
}

/**
 * 	간트차트에디터에서, 호출된 패키지의 간트프로세스 정보를 서버에서 가져오는 서비스를 호출하여 결과로 리턴되는 콜백 함수
 */
public function loadDiagram_result(svc: LoadGanttDiagramService): void {

	ganttChart.beginLoading();
	try {
		ganttChart.activate();
		ganttChart.diagram = svc.diagram;
		workNameLabel.text = ResourceManager.getInstance().getString("WorkbenchETC", "workNameText") + " : " + svc.diagram.xpdlPackage.name;
		checkSyntax();
		resetExtents();
	} finally {
		ganttChart.endLoading();
		if(this.swPackage.pkgStatus== SWPackage.SWPACKAGE_STATUS_CHECKED_OUT && !GanttChartGrid.DEPLOY_MODE){
			saveDiagram("initSave");	
		}
	}

	try {
		ganttChart.playLinkingEffect(XPDLDiagramUtils.getSortedNodes(ganttChart.xpdlDiagram));
	}
	catch (ex: Error) {
	}
}

/**
 * 	간트차트에디터에서, 호출된 패키지의 간트프로세스 정보를 서버에서 가져오기 위해 호출된 서비스가 이상이 발생할 경우 호출되는 콜백 함수
 */
private function faultHandler(event:MISPackageEvent):void{
	//TODO 에러처리
	MsgUtil.showError(event.msg);
}

/**
 * 	간트차트에디터에서, 서버에서 간트프로세스 정보를 가져와 로딩하는 도중에 이상이 발생하면, 이전 정보를 서버에 다시 세이브하는 함수
 */            
public function saveDiagram(type:String): void {
	ganttChart.beginSaving();
	var currForms:Array = _server.currentTaskForms;
	var currFormFields:Array = _server.currentTaskFormFields;
	var forms:Array = _server.taskForms;
	var formFields:Array = _server.taskFormFields;
	var activities:Array = ganttChart.xpdlDiagram.activities;
	try {
		//폼, 폼항목 서버와 비교해서 XPDL반영한다.
		for each (var act: Activity in activities) {
			if(act is GanttTask){
				var ganttTask:GanttTask = act as GanttTask;
				for each (var form: TaskForm in currForms) {
					if(ganttTask.formId == form.formId && ganttTask.formName!= form.name){
						ganttTask.formName = form.name;
					}
				}
				for each (var formField: TaskFormField in currFormFields) {
					if(ganttTask.formId == formField.formId && ganttTask.performer == formField.id && ganttTask.performerName!= formField.name){
						ganttTask.performerName =formField.name;
					}
				}
			}
		}
		saveToUrl(type);
	} finally {
		//폼, 폼항목을 에디팅 상태로 돌려놓는다.
		for each (var act: Activity in activities) {
			if(act is GanttTask){
				var ganttTask:GanttTask = act as GanttTask;
				for each (var form: TaskForm in forms) {
					if(ganttTask.formId == form.formId && ganttTask.formName!= form.name){
						ganttTask.formName = form.name;
					}
				}
				for each (var formField: TaskFormField in formFields) {
					if(ganttTask.formId == formField.formId && ganttTask.performer == formField.id && ganttTask.performerName!= formField.name){
						ganttTask.performerName =formField.name;
					}
				}
			}
		}
		if (ganttChart.endSaving()) {
			if (timer != null && timer.currentCount >= 1) {
				closePreload();
			} else if (timer != null) {
				this.timeoutId = setTimeout(closePreload, 1500);
			}
		}
	}
}

public function closePreload():void {
	timer.stop();
	timer.removeEventListener(TimerEvent.TIMER, timerEventHandler);
	this.dispatchEvent(new CustomPreloadEvent(CustomPreloadEvent.CLOSE_PROGRESS_IMG));
}

/**
 *  간트차트의 다이어그램 정보를 xpdl source로 다시 새롭게 쓰는 함수 	
 */
public function refreshXpdlSource(): void {
	var writer: GanttWriter = new GanttWriter();
	var xml: XML = writer.serialize(ganttChart.diagram as XPDLDiagram)
	_xpdlSource = new XML('<?xml version="1.0" encoding="utf-8"?>' + xml.toString());
}

/**
 * 	
 */
public function saveToUrl(type:String): void {
	refreshXpdlSource();

	var svc: SaveGanttDiagramService = new SaveGanttDiagramService();
	svc.serviceUrl = WorkbenchConfig.serviceUrl;
	svc.compId = WorkbenchConfig.compId;
	svc.userId = WorkbenchConfig.userId;
	svc.processId = _server.process.processId;
	svc.version = _packVer+"";
	svc.saveType = type;
	svc.processContent = _xpdlSource.toXMLString();
	svc.send();
	
	try {
		var layer:Sprite = this.ganttChart.primaryLayer;
		var opts:EncodeImageOpts = new EncodeImageOpts();
		opts.left = 4;
		opts.top = 0;
		opts.fixedScale = true;
		opts.width = 1024;
		var img:String = SmartUtil.encodeImageAsBase64(layer, opts);
		opts.width = 200;
		opts.height = 120;
		opts.cutHeightEnabled = false;
		var imgTn:String = SmartUtil.encodeImageAsBase64(layer, opts);
		
		var url:String = WorkbenchConfig.basePath + "/services/builder/SmartApi.jsp";
		var params:Object = new Object();
		params.method = "setImage";
		params.group = _packId;
		
		params.id = _server.process.processId;
		params.base64 = img;
		SmartUtil.send(url, params);
		
		params.id += "_tn";
		params.base64 = imgTn;
		SmartUtil.send(url, params);
		
	} catch (e:Error) {
	}
}

public function deployGanttDiagram(resultHandler:Function): void {
	refreshXpdlSource();
	var svc: DeployGanttDiagramService = new DeployGanttDiagramService();
	svc.resultHandler = resultHandler;
	svc.serviceUrl = WorkbenchConfig.serviceUrl;
	svc.compId = WorkbenchConfig.compId;
	svc.userId = WorkbenchConfig.userId;
	svc.packId = this.swPackage.id;
	svc.packVer = this.swPackage.version.toString();
	svc.processContent = _xpdlSource.toXMLString();
	svc.send();
}

public function checkSyntax(): void {
	_syntaxChecker.check(ganttChart.xpdlDiagram);
	//Alert.show(_syntaxChecker.problems.length.toString());
	//grdProblem.dataProvider = _syntaxChecker.problems;
}


public function processTBarBtnClick(btnID:String): void {
	switch (btnID) {
		case "SAVE":
			this.dispatchEvent(new CustomPreloadEvent(CustomPreloadEvent.SAVE_PROGRESS_IMG));
			saveDiagram("save");
			break;

		case "UNDO":
			ganttChart.undo();
			break;

		case "REDO":
			ganttChart.redo();
			break;

		case "LevelDown":
			ganttChart.chartLevelDown();
			break;
			
		case "LevelUp":
			ganttChart.chartLevelUp();
			break;			

		case "MoveLeftPage":
			ganttChart.chartMoveToLeftPage();
			break;
			
		case "MoveRightPage":
			ganttChart.chartMoveToRightPage();
			break;			

		case "MoveLeftStep":
			ganttChart.chartMoveToLeftStep();
			break;
			
		case "MoveRightStep":
			ganttChart.chartMoveToRightStep();
			break;			
	}
}

public function chartTBarBtnClick(bntID:String): void {

	switch (bntID) {
		case "SELECT":
			break;
			
		case "LINE":
			ganttChart.beginConnection();
			break;
			
		case "TASK":
			ganttChart.beginCreation("GanttTask");
			break;
			
		case "TASKGROUP":
			ganttChart.beginCreation("GanttTaskGroup");
			break;			

		case "SUBTASK":
			ganttChart.beginCreation("GanttSubTask");
			break;			

		case "MILESTONE":
			ganttChart.beginCreation("GanttMilestone");
			break;
			
	}
}

public function renameSucess(packEvent:MISPackageEvent):void{
	//refreshPackageTree();
	//saveDiagram();
}

public function renameFail(packEvent:MISPackageEvent):void{
}

public function formRename(event:FormEditorEvent):void{
	var taskForms:Array = _server.taskForms;
	var activities:Array = ganttChart.xpdlDiagram.activities;
	
	for each (var form: TaskForm in taskForms) {
		if(form.formId == event.formId && form.name!=event.newName){
			form.name = event.newName;
		}
	}
	
	for each (var act: Activity in activities) {
		if(act is GanttTask){
			var ganttTask:GanttTask = act as GanttTask;
			if(ganttTask.formId == event.formId && ganttTask.formName!=event.newName){
				ganttTask.formName = event.newName;
				break;
			}
		}
	}
}

public function formRename2(formId:String, formName:String):void{
	if(_server){
		var taskForms:Array = _server.taskForms;
		var activities:Array = ganttChart.xpdlDiagram.activities;
		
		for each (var form: TaskForm in taskForms) {
			if(form.formId == formId && form.name!=formName){
				form.name = formName;
			}
		}
		
		for each (var act: Activity in activities) {
			if(act is GanttTask){
				var ganttTask:GanttTask = act as GanttTask;
				if(ganttTask.formId == formId && ganttTask.formName!=formName){
					ganttTask.formName = formName;
					break;
				}
			}
		}
	}
}

public function formFieldRename(event:FormEditorEvent):void{
	try{
		var taskFormFields:Array = _server.taskFormFields;
		var activities:Array = ganttChart.xpdlDiagram.activities;
		
		for each (var formField: TaskFormField in taskFormFields) {
			if(formField.formId == event.formId && formField.id == event.formFieldId && formField.name!=event.newName){
				formField.name = event.newName;
				break;
			}
		}
		
		for each (var act: Activity in activities) {
			if(act is GanttTask){
				var ganttTask:GanttTask = act as GanttTask;
				if(ganttTask.formId == event.formId && ganttTask.performer == event.formFieldId && ganttTask.performerName!=event.newName){
					ganttTask.performerName = event.newName;
					break;
				}
			}
		}
	}catch(e:Error){}
}

public function formFieldAdd(event:FormEditorEvent):void{
	try{
		var taskFormFields:Array = _server.taskFormFields;
		
		var tff:TaskFormField = new TaskFormField();
		tff.formId = event.formId;
		tff.id = event.formFieldId;
		tff.name = event.newName;
		taskFormFields.push(tff);
	}catch(e:Error){}
}

public function formFieldRemove(event:FormEditorEvent):void{
	try{
		var taskFormFields:Array = _server.taskFormFields;
		var count:int = 0;
		for each (var formField: TaskFormField in taskFormFields) {
			if(formField.formId == event.formId && formField.id == event.formFieldId && formField.name!=event.newName){
				taskFormFields.splice(count, 1);
				break;
			}
			count++;
		}
	}catch(e:Error){}
}


//----------------------------
// xpdleditor
//----------------------------

public function ganttChart_creationComplete(event: Event): void {
	_syntaxChecker = new GanttSyntaxChecker();
	//Fonts.init();
	
}

/**
 * palette 에서 드랍되어 생성되는 경우 후출
 * 그 외의 경우는 XPDLNodeFactory에서 처리
 */
public function ganttChart_createNodeRequest(event: CreateNodeRequestEvent): void {
	trace(event.creationType + ": " + event.creationRect);
	
	var r: Rectangle = event.creationRect;
	var node: XPDLNode = ganttChart.createNode(event.creationType) as XPDLNode;

	if(!node) return;

	var groupView: GanttTaskGroupView;
	var groupCtrl: GanttTaskGroupController;
	var groupNode: GanttTaskGroup;
	var targetView:NodeView = event.creationController.view as NodeView;
	var ganttChartGrid: GanttChartGrid = ganttChart.xpdlDiagram.pool as GanttChartGrid;
	if(r.width==0) r.width = ganttChartGrid.chartColumnWidth;	
	if(event.creationController != ganttChart.findControllerByModel(ganttChartGrid)){
		if(!targetView) return;
		r.x +=targetView.x;
		r.y +=targetView.y;
	}
	var nodeIndex: int = ganttChartGrid.yToNodeIndex(r.y);
	if(targetView is GanttTaskGroupView){
		groupNode = event.creationController.model as GanttTaskGroup;
		setForTaskGroup(groupNode);
	}else if(targetView is GanttTaskView){
		groupNode = GanttTask(event.creationController.model).taskGroup;
		if(groupNode) setForTaskGroup(groupNode);
	}else if(targetView is GanttMilestoneView){
		groupNode = GanttMilestone(event.creationController.model).taskGroup;
		if(groupNode) setForTaskGroup(groupNode);
	}
	function setForTaskGroup(groupNode: GanttTaskGroup):void{
		if(!groupNode) return;
		if(groupNode.isTaskGroupNodeEditable && groupNode.isTaskGroupViewExpanded){
			if(nodeIndex == groupNode.nodeIndex)
				nodeIndex++;
			node["taskGroup"] = groupNode;				
		}else if(groupNode.taskGroup){
			setForTaskGroup(groupNode.taskGroup);
		}else{
			nodeIndex=groupNode.nodeIndex;
		}			
	}
		
	if(node is GanttTask){
		var ganttTask: GanttTask = node as GanttTask;
		ganttTask.planTaskRect = r;
		var planFromTo: Array = ganttChartGrid.getTaskFromTo(r); 
		ganttTask.planFrom = planFromTo[0] as Date; 
		ganttTask.planTo = planFromTo[1] as Date;
		ganttTask.name =resourceManager.getString("GanttChartETC", "taskText");
	}else if(node is GanttTaskGroup){
		var ganttTaskGroup: GanttTaskGroup = node as GanttTaskGroup;
		ganttChartGrid.createSubProcess(ganttChart.xpdlDiagram.xpdlPackage as GanttPackage, ganttTaskGroup);
		ganttTaskGroup.taskRect = r;
		var planFromTo1: Array = ganttChartGrid.getTaskFromTo(r); 
		ganttTaskGroup.planFrom = planFromTo1[0] as Date;
		ganttTaskGroup.planTo = planFromTo1[1] as Date;
		ganttTaskGroup.name =resourceManager.getString("GanttChartETC", "groupTaskText"); 
	}else if(node is GanttMilestone){
		var ganttMilestone: GanttMilestone = node as GanttMilestone;
		ganttMilestone.planMilestonePoint = new Point(r.x, r.y);
		ganttMilestone.planDate = ganttChartGrid.getTaskDate(ganttMilestone.planMilestonePoint); 
		ganttMilestone.name =resourceManager.getString("GanttChartETC", "milestoneText"); 
	}
		
	ganttChart.execute(new GanttNodeCreateCommand(ganttChartGrid, nodeIndex, node));
		
	ganttChart.resetTool();
		
	ganttChart.diagram.dispatchEvent(new DiagramChangeEvent(DiagramChangeEvent.CHART_REFRESHED, node, "", null));
	var selectedEvent:DiagramChangeEvent = new DiagramChangeEvent("diagramSelected", node, "", null);
	selectedEvent.model = node;
	ganttChart.dispatchEvent(selectedEvent);
}

public function ganttChart_linkCreated(event: LinkEvent): void {
	if (!ganttChart.isLoading)
		ConstraintLine(event.link).id = XPDLDiagram(ganttChart.diagram).getNextId();
}
		
/**
 * 화면 편집 버튼을 클릭시 호출.
 * form이 기본업무화면이면 다이얼로그를 띄워 새업무화면을 생성할 지 기존업무화면을 사용할 지 선택하게 된다. 선택결과는 openDivision에서 처리한다.
 * form이 기본업무화면이 아니면 화면편집으로 이동한다.
 * 2009.02.02 sjyoon
 */
public function goForm(event:MouseEvent = null):void{
	setForm();
	if (selectedForm) {
		if (selectedForm.id == TaskApplication.SYSTEM_FORM_ID) {
			MsgUtil.confirmMsg(ResourceManager.getInstance().getString("ProcessEditorMessages", "PEI001"), createNewFormResult); 
			function createNewFormResult(result:Boolean):void{
				if(result) openDivision("newTask");
				else return;
			}
		} else {
			openForm(selectedForm.id);
		}
	} else {
		MsgUtil.showError(resourceManager.getString("GanttChartMessages", "GCE001"));
	}
}

/**
 * 기존의 form이 업데이트가 안되는 현상을 해결하기 위해 추가한 function이다.
 * task를 선택하여 해당하는 form이 있으면 편집화면으로 가는 것이 정상이지만
 * task에 대해 form이 없으면 기존 선택한 form에 대해 편집화면으로 가는 문제점과
 * 기억된 form이 없다면 에러가 발생하게 된다.
 * 따라서 task를 선택하고 화면편집을 클릭하면 최종적으로 form에 대한 검증을 실시한다.
 * 2009.02.02 sjyoon
 */
private function setForm(): void {
	if(propertyPage.propSource == null) return;
	var propertyInfos: Array = propertyPage.propSource.getPropertyInfos();
	for each (var propertyInfo: PropertyInfo in propertyInfos) {
		
		if (propertyInfo as FormIdPropertyInfo) {
			var formIdPropertyInfo: FormIdPropertyInfo = propertyInfo as FormIdPropertyInfo;
			var ganttTask: GanttTask = formIdPropertyInfo.task as GanttTask;
			if (!ganttTask) {
				return;
			}						

			if(ganttTask.formId == TaskApplication.SYSTEM_FORM_ID) {
				var swForm: SWForm = new SWForm();
				swForm.id = ganttTask.formId;
				selectedForm = swForm;
				return;
			}
			
			var arr:ArrayCollection = this.swPackage.getFormResources();
			for(var i: int; i < arr.length; i++){
				if(ganttTask.formId == SWForm(arr.getItemAt(i)).id){
					selectedForm = SWForm(arr.getItemAt(i));
					break;
				} 
			}
		}
	}
}

/*
private function showMiniFormEditor(id:String = null, group:String = null):void {
	initEditFormButton();
	if (id == null) {
		ganttChartPropertyStage.addChild(this.editFormButton);
		return;
	}
	
	if (id == "SYSTEMFORM")
		group = null;
	
	loadMiniFormImage(id, group);
}

private function hideMiniFormEditor():void {
	initEditFormButton();
	
	if (ganttChartPropertyStage.contains(this.editFormButton))
		ganttChartPropertyStage.removeChild(this.editFormButton);
	
//	miniFormEditorImageBox.visible = false;
//	miniFormEditorImageBox.width = 0;
//	miniFormEditorImage.source = null;
}
private var loadMiniFormImage_url:String = null;
private function loadMiniFormImage(id:String, group:String = null):void {
	if (id == null)
		return;
	loadMiniFormImage_url = WorkbenchConfig.basePath + "/systemImages/workDef/";
	if (group != null)
		loadMiniFormImage_url += group + "/";
	loadMiniFormImage_url += id + "_tn.png";
	var loader:URLLoader = new URLLoader();
	loader.addEventListener(Event.COMPLETE, loadMiniFormImageCallback);
	loader.addEventListener(IOErrorEvent.IO_ERROR, loadMiniFormImageFault);
	loader.load(new URLRequest(loadMiniFormImage_url));
}
private function loadMiniFormImageCallback(event:Event = null):void {
//	this.miniFormEditorImage.source = loadMiniFormImage_url;
//	miniFormEditorImageBox.visible = true;
//	miniFormEditorImageBox.width = 200;
}
private function loadMiniFormImageFault(event:Event):void {

	ganttChartPropertyStage.addChild(this.editFormButton);
}
*/

public function ganttChart_selectionChanged(event: SelectionEvent): void {
	propertyPage.propSource = event.selectedSource;
	if (!event.selectedSource) {
		selectedForm = null;
//간트차트를 위해 잠시 주석처리
//		hideMiniFormEditor();
		selectObjectType.text = "";
	} else {
		selectModel(event.selectedSource);
	}
}
public function ganttChart_laneSelectionChanged(event: LaneSelectionEvent): void {
//	propertyPage.propSource = event.selectedLane;
//	propertyPage.title=resourceManager.getString("GanttchartETC", "linePropertiesText");
//	propertyPage.show(this, false);
}

public function ganttChart_toolInitialized(event: Event): void {
	//tbarPDEPalette.selectedIndex = 0;
}

public function ganttChart_diagramChanged(event: DiagramChangeEvent): void {
	checkSyntax();
}

public function ganttChart_selected(event: DiagramChangeEvent): void { //toolTip는 사용을 안함. 사용하려면  DiagramEditor의 doMouseDown메소드에 주석을 풀어준다.
//	hideMiniFormEditor();
//	selectObjectType.text = "";
//	selectModel(event.model);
}

public function selectModel(model:Object):void {
	if (model == null)
		return;
	
	this.selectedObject = model;
//간트차트를 위해 잠시 주석처리
//	hideMiniFormEditor();
	
	if (model is ConstraintLine) {
		propertyPage.title = ConstraintLine(model).name + " " + resourceManager.getString("GanttChartETC", "propertiesText");
	} else if (model is GanttTaskGroup) {
		propertyPage.title = GanttTaskGroup(model).name + " " + resourceManager.getString("GanttChartETC", "propertiesText");
	} else if (model is GanttTask) {
		propertyPage.title = GanttTask(model).name + " " + resourceManager.getString("GanttChartETC", "propertiesText");
			
		var ganttTask:GanttTask = model as GanttTask;
		var arr:ArrayCollection = this.swPackage.getFormResources();

// 간트차트을 위해 잠시 주석처리			
//		showMiniFormEditor(ganttTask.formId, _packId);
			
		if (ganttTask.formId == TaskApplication.SYSTEM_FORM_ID) {
			var swForm: SWForm = new SWForm();
			swForm.id = ganttTask.formId;
			selectedForm = swForm;
				
			// task가 null이므로 task를 여기서 set해준다. 2009.02.02
			var propertyInfos: Array = propertyPage.propSource.getPropertyInfos();
			for each (var propertyInfo: PropertyInfo in propertyInfos) {
				if (propertyInfo as FormIdPropertyInfo) {
					var formIdPropertyInfo: FormIdPropertyInfo = propertyInfo as FormIdPropertyInfo;
					formIdPropertyInfo.task = ganttTask;
				}
			}
		}else{
			for(var i:int; i<arr.length; i++) {
				if (ganttTask.formId == SWForm(arr.getItemAt(i)).id) {
					selectedForm = SWForm(arr.getItemAt(i));
					//editFormButton.load(selectedForm);
					break;
				}	 
			}
		}
	} else if (model is GanttMilestone) {
		propertyPage.title = GanttMilestone(model).name + " " + resourceManager.getString("GanttChartETC", "propertiesText");
	}
	if(ganttChart.findControllerByModel(model as DiagramObject).showPropertyView && !propertyPage.isPopUped)
		propertyPage.show(this, false);
}

//---------------------------
// diagramPropertyPage
//---------------------------

public function ganttChartPropertyPage_sourceChanged(event: Event): void {
}

public function ganttChartPropertyPage_sourcevalueChanged(event:NodeChangeEvent): void {
	if(event.prop == TaskApplication.PROP_FORMID){
		if(event.node is GanttTask){
			var task:GanttTask = event.node as GanttTask;
			ExternalInterface.call("formChangeCallback", task.formId, event.oldValue);
		}
	}
}

public function ganttChartPropertyPage_selectionChanged(event: Event): void {
}

public function refreshToolbox():void{
	if(ganttToolBox.visible)
		if(ganttToolBox.y+ganttToolBox.height>WorkbenchConfig.contentHeight-this.editorHeaderToolBar.height){
			ganttToolBox.y = WorkbenchConfig.contentHeight-this.editorHeaderToolBar.height-ganttToolBox.height-8-20;
			toolBoxY = ganttToolBox.y;
		}

}

private function doToolBoxDragging(event: MouseEvent):void{
	var ds: DragSource = new DragSource();
	ds.addData(this, "toolBox");
	DragManager.doDrag(ganttToolBox, ds, event);
}

private function doToolBoxDragEnter(event: DragEvent):void{
	if (   event.dragSource.hasFormat("toolBox")
   		&& HBox(event.currentTarget).mouseY < HBox(event.currentTarget).height 
    	&& HBox(event.currentTarget).mouseX > VBox(event.dragInitiator).x 
        && HBox(event.currentTarget).mouseX < VBox(event.dragInitiator).x + VBox(event.dragInitiator).width ) 
    {
        DragManager.acceptDragDrop(HBox(event.currentTarget));
    }				
}
			
private function doToolBoxDragDrop(event: DragEvent):void{
	if (   event.dragSource.hasFormat("toolBox")
   		&& HBox(event.currentTarget).mouseY < HBox(event.currentTarget).height 
    	&& HBox(event.currentTarget).mouseX > VBox(event.dragInitiator).x 
        && HBox(event.currentTarget).mouseX < VBox(event.dragInitiator).x + VBox(event.dragInitiator).width ) 
    {
       	if(HBox(event.currentTarget).mouseY<HBox(event.currentTarget).height-VBox(event.dragInitiator).height)
       		VBox(event.dragInitiator).y = HBox(event.currentTarget).mouseY ;
       	else
       		VBox(event.dragInitiator).y = HBox(event.currentTarget).height-VBox(event.dragInitiator).height-4;
		toolBoxY = VBox(event.dragInitiator).y;
	}
}

public var _oldZoom: Number;
public var _newZoom: Number;
public var _repeatDelay: Number = 10;
public var _repeatCount: Number = 20;
[Bindable]
public var szWidth:Number;
public var initRate:Number = 0;
public var initCount:int = 0;
public var defalultZoom: Number;

public function ganttChart_resize(event: ResizeEvent): void {
	resetExtents();
}

public function resizeWorkbench():void{
	if (ganttChart.xpdlDiagram){
		var contentHeight:Number = this.editorHeaderToolBar.height+ganttChart.xpdlDiagram.pool.height+8+6;
		this.parentDocument.dispatchEvent(new LoadCallbackEvent(LoadCallbackEvent.LOAD_CALLBACK, LoadCallbackEvent.STAGENAME_GANTT, contentHeight));
		ganttToolBox.y = 100;
	}
}

public function resetExtents(): void {
	if(ganttChart.diagram){
		var ctrl: GanttChartGridController = ganttChart.findControllerByModel(XPDLDiagram(ganttChart.diagram).pool) as GanttChartGridController;
		ctrl.refreshWindowSize();
	}
}

public function loadTaskFormFields():void{
	_server.loadTaskFormFields();	
}

public function formListEdit():void{
	var position: Point = formListBtn.localToGlobal(new Point(formListBtn.x, formListBtn.height+1));
	SelectFormDialog.execute(_server, null, doFormListEdit, true, position, 187);
}

private function doFormListEdit(item: Object): void {
	if(item){
		var swForm:SWForm = new SWForm();
		swForm.id = TaskForm(item).formId;
		swForm.name = TaskForm(item).name;
		selectedForm = swForm;
		propertyPage.propSource=null;
		goForm();
	} 
}