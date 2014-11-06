////////////////////////////////////////////////////////////////////////////////
//  ProcessEditor_mxml.as
//  2007.12.13, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////
//import com.maninsoft.smart.modeler.assets.Fonts;
import com.maninsoft.smart.common.util.EncodeImageOpts;
import com.maninsoft.smart.common.util.SmartUtil;
import com.maninsoft.smart.modeler.command.NodeCreateCommand;
import com.maninsoft.smart.modeler.common.Size;
import com.maninsoft.smart.modeler.editor.events.CreateNodeRequestEvent;
import com.maninsoft.smart.modeler.editor.events.DiagramChangeEvent;
import com.maninsoft.smart.modeler.editor.events.SelectionEvent;
import com.maninsoft.smart.modeler.editor.helper.AlignmentTypes;
import com.maninsoft.smart.modeler.model.DiagramObject;
import com.maninsoft.smart.modeler.model.Node;
import com.maninsoft.smart.modeler.model.events.LinkEvent;
import com.maninsoft.smart.modeler.palette.PaletteItemEvent;
import com.maninsoft.smart.modeler.view.NodeView;
import com.maninsoft.smart.modeler.xpdl.dialogs.SelectFormDialog;
import com.maninsoft.smart.modeler.xpdl.model.AndGateway;
import com.maninsoft.smart.modeler.xpdl.model.Annotation;
import com.maninsoft.smart.modeler.xpdl.model.Block;
import com.maninsoft.smart.modeler.xpdl.model.DataObject;
import com.maninsoft.smart.modeler.xpdl.model.EndEvent;
import com.maninsoft.smart.modeler.xpdl.model.IntermediateEvent;
import com.maninsoft.smart.modeler.xpdl.model.Pool;
import com.maninsoft.smart.modeler.xpdl.model.StartEvent;
import com.maninsoft.smart.modeler.xpdl.model.SubFlow;
import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
import com.maninsoft.smart.modeler.xpdl.model.TaskService;
import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
import com.maninsoft.smart.modeler.xpdl.model.XorGateway;
import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
import com.maninsoft.smart.modeler.xpdl.model.base.XPDLLink;
import com.maninsoft.smart.modeler.xpdl.model.base.XPDLNode;
import com.maninsoft.smart.modeler.xpdl.model.pool.Lane;
import com.maninsoft.smart.modeler.xpdl.model.process.WorkflowProcess;
import com.maninsoft.smart.modeler.xpdl.parser.XPDLWriter;
import com.maninsoft.smart.modeler.xpdl.property.FormIdPropertyInfo;
import com.maninsoft.smart.modeler.xpdl.server.Server;
import com.maninsoft.smart.modeler.xpdl.server.TaskForm;
import com.maninsoft.smart.modeler.xpdl.server.TaskFormField;
import com.maninsoft.smart.modeler.xpdl.server.service.GetProcessInfoByPackageService;
import com.maninsoft.smart.modeler.xpdl.server.service.LoadDiagramService;
import com.maninsoft.smart.modeler.xpdl.server.service.SaveDiagramService;
import com.maninsoft.smart.modeler.xpdl.syntax.SyntaxChecker;
import com.maninsoft.smart.modeler.xpdl.tool.LaneSelectionEvent;
import com.maninsoft.smart.modeler.xpdl.utils.XPDLDiagramUtils;
import com.maninsoft.smart.workbench.SmartWorkbench;
import com.maninsoft.smart.workbench.common.editor.EditDomain;
import com.maninsoft.smart.workbench.common.event.FormEditorEvent;
import com.maninsoft.smart.workbench.common.event.LoadCallbackEvent;
import com.maninsoft.smart.workbench.common.meta.impl.SWForm;
import com.maninsoft.smart.workbench.common.meta.impl.SWPackage;
import com.maninsoft.smart.workbench.common.property.PropertyInfo;
import com.maninsoft.smart.workbench.common.util.MsgUtil;
import com.maninsoft.smart.workbench.event.MISPackageEvent;
import com.maninsoft.smart.workbench.util.WorkbenchConfig;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.geom.Rectangle;
import flash.utils.Timer;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.Button;
import mx.core.DragSource;
import mx.events.DragEvent;
import mx.events.ResizeEvent;
import mx.managers.DragManager;
import mx.resources.ResourceManager;

//------------------------------------------------------------------------------
// Variables
//------------------------------------------------------------------------------

private var _syntaxChecker: SyntaxChecker;
//public var _swProcess: SWProcess;
private var _packId: String;
private var _packVer: int;

private var _server: Server;
private var _xpdlSource: XML;
private var _loadDiagram: Boolean;

[Bindable]
private var swPackage:SWPackage;

[Bindable]
private var editDomain:EditDomain;

public var selectedObject:Object;
public var selectedForm:SWForm;

//[Bindable]
//private var selectObjectType:Label;

//------------------------------------------------------------------------------
// Internal methods
//------------------------------------------------------------------------------
			

public function serverLoad(packId: String, packVer: int, spk:SWPackage, ed:EditDomain, loadDiagram: Boolean, resultFunc: Function=null, formId: String=null):void{
	_packId = packId;
	_packVer = packVer;
	_loadDiagram = loadDiagram;
	swPackage = spk;
	editDomain = ed;
	if (_server == null) {
		_server = new Server(WorkbenchConfig.serviceUrl, WorkbenchConfig.userId, WorkbenchConfig.compId, packId, packVer+"");
		_server.addEventListener("serverLoaded", loadServerHandler);
		_server.addEventListener("applicationServicesLoaded", applicationServicesHandler);
		_server.addEventListener("systemServicesLoaded", systemServicesHandler);
		xpdleditor.server = _server;
		//miniXPDLEditor.server = _server;
	}
	_server.load(resultFunc, formId);
}

private function applicationServicesHandler(event:Event):void{
	if(!xpdleditor.diagram || !XPDLDiagram(xpdleditor.diagram).xpdlPackage || !XPDLDiagram(xpdleditor.diagram).xpdlPackage.process)
		return;
	WorkflowProcess(XPDLDiagram(xpdleditor.diagram).xpdlPackage.process).refreshApplicationServices(_server.applicationServices);
}
private function systemServicesHandler(event:Event):void{
	if(!xpdleditor.diagram || !XPDLDiagram(xpdleditor.diagram).xpdlPackage || !XPDLDiagram(xpdleditor.diagram).xpdlPackage.process)
		return;
	WorkflowProcess(XPDLDiagram(xpdleditor.diagram).xpdlPackage.process).refreshSystemServices(_server.systemServices);
	
}
public function loadServerHandler(event: Event):void{
	var svc: GetProcessInfoByPackageService = new GetProcessInfoByPackageService();
	svc.serviceUrl = WorkbenchConfig.serviceUrl;
	svc.userId = WorkbenchConfig.userId;
	svc.packageId = _packId;
	svc.version = _packVer+"";
	svc.resultHandler = loadServer_result;
	svc.send();
}

public function loadServer_result(svc: GetProcessInfoByPackageService): void {
	_server.process = svc.process;
	
	if (_loadDiagram && _server.process) {
		loadDiagram();
	}
}

public function loadDiagram(): void {
	var svc: LoadDiagramService = new LoadDiagramService();
	
	svc.serviceUrl = WorkbenchConfig.serviceUrl;
	svc.userId = WorkbenchConfig.userId;
	svc.processId = _server.process.processId;
	svc.version = _packVer+"";

	svc.resultHandler = loadDiagram_result;
	svc.faultHandler = faultHandler;
	svc.send();
}

public function loadDiagram_result(svc: LoadDiagramService): void {

	xpdleditor.beginLoading();
	try {
		xpdleditor.activate();
		xpdleditor.diagram = svc.diagram;
		workNameLabel.text = ResourceManager.getInstance().getString("WorkbenchETC", "workNameText") + " : " + svc.diagram.xpdlPackage.name;
		checkSyntax();
		resetExtents();
	} finally {
		xpdleditor.endLoading();
		if(this.swPackage.pkgStatus== SWPackage.SWPACKAGE_STATUS_CHECKED_OUT){
			saveDiagram("initSave");	
		}
	}

	try {
		xpdleditor.playLinkingEffect(XPDLDiagramUtils.getSortedNodes(xpdleditor.xpdlDiagram));
	}
	catch (ex: Error) {
	}
}

private function faultHandler(event:MISPackageEvent):void{
	MsgUtil.showError(event.msg);
}
            
public function saveDiagram(type:String): void {
	xpdleditor.beginSaving();
	var currForms:Array = _server.currentTaskForms;
	var currFormFields:Array = _server.currentTaskFormFields;
	var forms:Array = _server.taskForms;
	var formFields:Array = _server.taskFormFields;
	var activities:Array = xpdleditor.xpdlDiagram.activities;
	try {
		//폼, 폼항목 서버와 비교해서 XPDL반영한다.
		for each (var act: Activity in activities) {
			if(act is TaskApplication){
				var taskApp:TaskApplication = act as TaskApplication;
				for each (var form: TaskForm in currForms) {
					if(taskApp.formId == form.formId && taskApp.formName!= form.name){
						taskApp.formName = form.name;
					}
				}
				for each (var formField: TaskFormField in currFormFields) {
					if(taskApp.formId == formField.formId && taskApp.performer == formField.id && taskApp.performerName!= formField.name){
						taskApp.performerName =formField.name;
					}
				}
			}
		}
		saveToUrl(type);
	} finally {
		//폼, 폼항목을 에디팅 상태로 돌려놓는다.
		for each (var act: Activity in activities) {
			if(act is TaskApplication){
				var taskApp:TaskApplication = act as TaskApplication;
				for each (var form: TaskForm in forms) {
					if(taskApp.formId == form.formId && taskApp.formName!= form.name){
						taskApp.formName = form.name;
					}
				}
				for each (var formField: TaskFormField in formFields) {
					if(taskApp.formId == formField.formId && taskApp.performer == formField.id && taskApp.performerName!= formField.name){
						taskApp.performerName =formField.name;
					}
				}
			}
		}
		if (xpdleditor.endSaving()) {
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

public function refreshXpdlSource(): void {
	var writer: XPDLWriter = new XPDLWriter();
	var xml: XML = writer.serialize(xpdleditor.diagram as XPDLDiagram)
	_xpdlSource = new XML('<?xml version="1.0" encoding="utf-8"?>' + xml.toString());
}

public function saveToUrl(type:String): void {
	refreshXpdlSource();

	var svc: SaveDiagramService = new SaveDiagramService();
	svc.serviceUrl = WorkbenchConfig.serviceUrl;
	svc.compId = WorkbenchConfig.compId;
	svc.userId = WorkbenchConfig.userId;
	svc.processId = _server.process.processId;
	svc.version = _packVer+"";
	svc.saveType = type;
	svc.processContent = _xpdlSource.toXMLString();
	svc.send();
	
	try {
		var layer:Sprite = this.xpdleditor.primaryLayer;
		var opts:EncodeImageOpts = new EncodeImageOpts();
		opts.left = 4;
		opts.top = 0;
		opts.fixedScale = true;
		opts.width = 1024;
		var img:String = SmartUtil.encodeImageAsBase64(layer, opts);
		opts.width = 200;
		opts.minHeight = 120;
		opts.height = 120;
		opts.cutHeightEnabled = false;
		var imgTn:String = SmartUtil.encodeImageAsBase64(layer, opts);
		
		var url:String = WorkbenchConfig.basePath + "/services/builder/SmartApi.jsp";
		var params:Object = new Object();
		params.method = "setImage";
		params.companyId = WorkbenchConfig.compId;
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

public function checkSyntax(): void {
	_syntaxChecker.check(xpdleditor.xpdlDiagram);
	//Alert.show(_syntaxChecker.problems.length.toString());
	//grdProblem.dataProvider = _syntaxChecker.problems;
}


//------------------------------------------------------------------------------
// Event handlers
//------------------------------------------------------------------------------
public function tbarPDEPalette_btnClick(btnId:String): void {
	switch (btnId) {
		case "select":
			xpdleditor.resetTool();
			break;
			
		case "sequence":
			xpdleditor.beginConnection();
			break;
			
		case "pool":
			xpdleditor.beginCreation("Pool");
			break;
			
		case "start":
			xpdleditor.beginCreation("StartEvent");
			break;
			
		case "end":
			xpdleditor.beginCreation("EndEvent");
			break;
			
		case "intermediate":
			xpdleditor.beginCreation("IntermediateEvent");
			break;
			
		case "userTask":
			xpdleditor.beginCreation("TaskUser");
			break;
			
		case "applicationTask":
			xpdleditor.beginCreation("TaskApplication");
			break;
			
		case "serviceTask":
			xpdleditor.beginCreation("TaskService");
			break;
			
		case "subFlow":
			xpdleditor.beginCreation("SubFlow");
			break;
			
		case "xor":
			xpdleditor.beginCreation("XorGateway");
			break;
			
		case "and":
			xpdleditor.beginCreation("AndGateway");
			break;
			
		case "or":
			xpdleditor.beginCreation("OrGateway");
			break;
			
		case "dataobject":
			xpdleditor.beginCreation("DataObject");
			break;
			
		case "block":
			xpdleditor.beginCreation("Block");
			break;
			
		case "group":
			xpdleditor.beginCreation("Group");
			break;
			
		case "annotation":
			xpdleditor.beginCreation("Annotation");
			break;
	}
}

public function tbarPDEEdit_BtnClick(btnId:String): void {
	switch (btnId) {
		case "UNDO":
			xpdleditor.undo();
			break;

		case "REDO":
			xpdleditor.redo();
			break;

		case "ZOOMIN":
			if(xpdleditor.zoom >= 200) break;
			else xpdleditor.zoom += 10; break;
			
		case "ZOOMOUT":
			if(xpdleditor.zoom <= 20) break;
			else xpdleditor.zoom -= 10; break;
			
		case "ORIENTATION":
			xpdleditor.changeOrientation();
			break;
	}
}

public function tbarPDEAlign_BtnClick(btnId:String): void {
	switch (btnId) {
		case "ALIGN_LEFT":
			xpdleditor.alignSelection(AlignmentTypes.ALIGN_LEFT);
			break;
			
		case "ALIGN_HCENTER":
			xpdleditor.alignSelection(AlignmentTypes.ALIGN_HCENTER);
			break;
			
		case "ALIGN_RIGHT":
			xpdleditor.alignSelection(AlignmentTypes.ALIGN_RIGHT);
			break;
			
		case "ALIGN_TOP":
			xpdleditor.alignSelection(AlignmentTypes.ALIGN_TOP);
			break;
			
		case "ALIGN_VCENTER":
			xpdleditor.alignSelection(AlignmentTypes.ALIGN_VCENTER);
			break;
			
		case "ALIGN_BOTTOM":
			xpdleditor.alignSelection(AlignmentTypes.ALIGN_BOTTOM);
			break;
			
		case "ALIGN_LANECENTER":
			xpdleditor.alignSelection("laneCenter");
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
	var activities:Array = xpdleditor.xpdlDiagram.activities;
	
	for each (var form: TaskForm in taskForms) {
		if(form.formId == event.formId && form.name!=event.newName){
			form.name = event.newName;
		}
	}
	
	for each (var act: Activity in activities) {
		if(act is TaskApplication){
			var taskApp:TaskApplication = act as TaskApplication;
			if(taskApp.formId == event.formId && taskApp.formName!=event.newName){
				taskApp.formName = event.newName;
				break;
			}
		}
	}
}

public function formRename2(formId:String, formName:String):void{
	if(_server){
		var taskForms:Array = _server.taskForms;
		var activities:Array = xpdleditor.xpdlDiagram.activities;
		
		for each (var form: TaskForm in taskForms) {
			if(form.formId == formId && form.name!=formName){
				form.name = formName;
			}
		}
		
		for each (var act: Activity in activities) {
			if(act is TaskApplication){
				var taskApp:TaskApplication = act as TaskApplication;
				if(taskApp.formId == formId && taskApp.formName!=formName){
					taskApp.formName = formName;
					break;
				}
			}
		}
	}
}

public function formFieldRename(event:FormEditorEvent):void{
	try{
		var taskFormFields:Array = _server.taskFormFields;
		var activities:Array = xpdleditor.xpdlDiagram.activities;
		
		for each (var formField: TaskFormField in taskFormFields) {
			if(formField.formId == event.formId && formField.id == event.formFieldId && formField.name!=event.newName){
				formField.name = event.newName;
				break;
			}
		}
		
		for each (var act: Activity in activities) {
			if(act is TaskApplication){
				var taskApp:TaskApplication = act as TaskApplication;
				if(taskApp.formId == event.formId && taskApp.performer == event.formFieldId && taskApp.performerName!=event.newName){
					taskApp.performerName = event.newName;
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

public function xpdleditor_creationComplete(event: Event): void {
	_syntaxChecker = new SyntaxChecker();
	//Fonts.init();
}

/**
 * palette 에서 드랍되어 생성되는 경우 후출
 * 그 외의 경우는 XPDLNodeFactory에서 처리
 */
public function xpdleditor_createNodeRequest(event: CreateNodeRequestEvent): void {
	trace(event.creationType + ": " + event.creationRect);
	
	var r: Rectangle = event.creationRect;
	var creationType:String = event.creationType;
	if(event.creationType == "TaskUser") creationType = "TaskApplication";
	
	var node: XPDLNode = xpdleditor.createNode(creationType) as XPDLNode;
	
	if(event.creationType == "TaskApplication") TaskApplication(node).isCustomForm = true;
	
	if (node) {
		if(event.creationController != xpdleditor.findControllerByModel(xpdleditor.xpdlDiagram.pool)){
			var targetView:NodeView = event.creationController.view as NodeView;
			if(!targetView) return;
			r.x +=targetView.x;
			r.y +=targetView.y;			
		}

		node.x = r.x;
		node.y = r.y;
		
		if (r.width >= node.defaultWidth && r.height >= node.defaultHeight) {
			node.size = (new Size(r.width, r.height));
		}
		
		xpdleditor.execute(new NodeCreateCommand(xpdleditor.xpdlDiagram.pool, node));
		
		xpdleditor.resetTool();
		
		// diagramSelected 이벤트를 발생시킨다.
		var selectedEvent:DiagramChangeEvent = new DiagramChangeEvent("diagramSelected", node, "", null);
		selectedEvent.model = node;
		xpdleditor.dispatchEvent(selectedEvent);
		//tbarPDEPalette.selectedIndex = 0;
	}
}

public function xpdleditor_linkCreated(event: LinkEvent): void {
	if (!xpdleditor.isLoading)
		XPDLLink(event.link).id = XPDLDiagram(xpdleditor.diagram).getNextId();
}

private var editFormButton:Button;
//<mx:Button label="화면편집" id="editFormButton" width="0" height="120" click="goForm()" visible="false"/>
private function initEditFormButton():void {
	if (editFormButton != null)
		return;
	editFormButton = new Button();
	editFormButton.label = resourceManager.getString("WorkbenchETC", "editFormText");
	editFormButton.width = 200;
	editFormButton.height = 120;
	editFormButton.addEventListener(MouseEvent.CLICK, goForm);
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
		MsgUtil.showError(resourceManager.getString("WorkbenchMessages", "WBE002"));
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
	if(!propertyPage.propSource) return;
	var propertyInfos: Array = propertyPage.propSource.getPropertyInfos();
	for each (var propertyInfo: PropertyInfo in propertyInfos) {
		
		if (propertyInfo is FormIdPropertyInfo) {
			var formIdPropertyInfo: FormIdPropertyInfo = propertyInfo as FormIdPropertyInfo;
			var taskApp: TaskApplication = formIdPropertyInfo.task;
			if (!taskApp) {
				return;
			}						

			if(taskApp.formId == TaskApplication.SYSTEM_FORM_ID) {
				var swForm: SWForm = new SWForm();
				swForm.id = taskApp.formId;
				selectedForm = swForm;
				return;
			}
			
			var arr:ArrayCollection = this.swPackage.getFormResources();
			for(var i: int; i < arr.length; i++){
				if(taskApp.formId == SWForm(arr.getItemAt(i)).id){
					selectedForm = SWForm(arr.getItemAt(i));
					break;
				} 
			}
		}
	}
}

/*=====
private function showMiniFormEditor(id:String = null, group:String = null):void {
	initEditFormButton();
	if (id == null) {
		diagramEditorPropertyStage.addChild(this.editFormButton);
		return;
	}
	
	if (id == "SYSTEMFORM")
		group = null;
	
	loadMiniFormImage(id, group);
}
private function hideMiniFormEditor():void {
	initEditFormButton();
	
	if (diagramEditorPropertyStage.contains(this.editFormButton))
		diagramEditorPropertyStage.removeChild(this.editFormButton);
	
	miniFormEditorImageBox.visible = false;
	miniFormEditorImageBox.width = 0;
	miniFormEditorImage.source = null;
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
	this.miniFormEditorImage.source = loadMiniFormImage_url;
	miniFormEditorImageBox.visible = true;
	miniFormEditorImageBox.width = 200;
}
private function loadMiniFormImageFault(event:Event):void {
	diagramEditorPropertyStage.addChild(this.editFormButton);
}
*/

public function xpdleditor_selectionChanged(event: SelectionEvent): void {
	propertyPage.propSource = event.selectedSource;
	if (!event.selectedSource) {
		propertyPage.title="";
	} else {
		selectModel(event.selectedSource);
	}
}

public function xpdleditor_laneSelectionChanged(event: LaneSelectionEvent): void {
	propertyPage.propSource = event.selectedLane;
	if (!event.selectedLane) {
		propertyPage.title="";
	} else {
		propertyPage.title = resourceManager.getString("WorkbenchETC", "lanePropertiesText");
		if(xpdleditor.findControllerByModel(event.selectedLane.owner as DiagramObject).showPropertyView && !propertyPage.isPopUped)
			propertyPage.show(this, false);
	}
}

public function xpdleditor_toolInitialized(event: Event): void {
	//tbarPDEPalette.selectedIndex = 0;
}

public function xpdleditor_diagramChanged(event: DiagramChangeEvent): void {
	checkSyntax();
}

public function xpdleditor_selected(event: DiagramChangeEvent): void { //toolTip는 사용을 안함. 사용하려면  DiagramEditor의 doMouseDown메소드에 주석을 풀어준다.
//	hideMiniFormEditor();
//	selectObjectType.text = "";
//	selectModel(event.model);
}

public function selectModel(model:Object):void {
	if (model == null)
		return;
	
	this.selectedObject = model;
	
	if (model is Lane) {
		propertyPage.title = resourceManager.getString("WorkbenchETC", "lanePropertiesText");
		return;
	} else if (model is XPDLLink) {
		propertyPage.title = resourceManager.getString("WorkbenchETC", "linePropertiesText");
	} else if (model is Pool) {
		propertyPage.title = resourceManager.getString("WorkbenchETC", "poolPropertiesText");
	} else {
		if (model is TaskApplication) {
			propertyPage.title =resourceManager.getString("WorkbenchETC", "taskPropertiesText");
			
			var taskApp:TaskApplication = model as TaskApplication;
			var arr:ArrayCollection = this.swPackage.getFormResources();
			
			if (taskApp.formId == TaskApplication.SYSTEM_FORM_ID) {
				var swForm: SWForm = new SWForm();
				swForm.id = taskApp.formId;
				selectedForm = swForm;
				
				// task가 null이므로 task를 여기서 set해준다. 2009.02.02
				var propertyInfos: Array = propertyPage.propSource.getPropertyInfos();
				for each (var propertyInfo: PropertyInfo in propertyInfos) {
					if (propertyInfo as FormIdPropertyInfo) {
						var formIdPropertyInfo: FormIdPropertyInfo = propertyInfo as FormIdPropertyInfo;
						formIdPropertyInfo.task = taskApp;
					}
				}
			}else{			
				for(var i:int; i<arr.length; i++) {
					if (taskApp.formId == SWForm(arr.getItemAt(i)).id) {
						selectedForm = SWForm(arr.getItemAt(i));
						//editFormButton.load(selectedForm);
						break;
					} 
				}
			}
			this.parentDocument.dispatchEvent(new SelectionEvent("taskSelectionCallback", new Array(model)));
		} else if (model is TaskService) {
			propertyPage.title = resourceManager.getString("WorkbenchETC", "taskServicePropertiesText");
		} else if (model is SubFlow) {
			propertyPage.title = resourceManager.getString("WorkbenchETC", "subFlowPropertiesText");
		} else if (model is XorGateway) {
			propertyPage.title = resourceManager.getString("WorkbenchETC", "xorPropertiesText");
		} else if (model is AndGateway) {
			propertyPage.title = resourceManager.getString("WorkbenchETC", "andPropertiesText");
		} else if (model is EndEvent) {
			propertyPage.title = resourceManager.getString("WorkbenchETC", "endPropertiesText");
		} else if (model is StartEvent) {
			propertyPage.title = resourceManager.getString("WorkbenchETC", "startPropertiesText");
		} else if (model is IntermediateEvent) {
			propertyPage.title = resourceManager.getString("WorkbenchETC", "intermediatePropertiesText");
		} else if (model is DataObject) {
			propertyPage.title = resourceManager.getString("WorkbenchETC", "dataObjectPropertiesText");
		} else if (model is Block) {
			propertyPage.title = resourceManager.getString("WorkbenchETC", "blockPropertiesText");
		} else if (model is Annotation) {
			propertyPage.title = resourceManager.getString("WorkbenchETC", "annotationPropertiesText");
		}
			
	}
	if(xpdleditor.findControllerByModel(model as DiagramObject).showPropertyView && !propertyPage.isPopUped)
		propertyPage.show(this, false);
}

public var _oldZoom: Number;
public var _newZoom: Number;
public var _repeatDelay: Number = 10;
public var _repeatCount: Number = 20;
[Bindable]
public var szWidth:Number;
public var initRate:Number = 0;
public var initCount:int = 0;
public var defaultZoom: Number;

public function xpdleditor_resize(event: ResizeEvent): void {
	resetExtents();
}

public function resetExtents(): void {
	xpdleditor.zoom = xpdleditor.zoom;
	var timerWidth: Timer = new Timer(_repeatDelay, _repeatCount);
	timerWidth.addEventListener(TimerEvent.TIMER, doTimerWidth);
	timerWidth.start();
	if (xpdleditor.xpdlDiagram) {
		var sz: Size = xpdleditor.xpdlDiagram.pool.size;
		szWidth = sz.width;
		sz = xpdleditor.xpdlDiagram.pool.size;
		var zx: Number = xpdleditor.width * 100 / sz.width;
		var zy: Number = xpdleditor.height * 100 / sz.height;
		
		workbench.diagramScale.value = xpdleditor.zoom;
		workbench.diagramScale.visible = true;
		defaultZoom = xpdleditor.zoom;
		
		_oldZoom = xpdleditor.zoom;
		_newZoom = Math.min(zx, zy) - 10;
	}
}

public function doTimerWidth(ev: TimerEvent): void {
	if (xpdleditor.xpdlDiagram) {
		var sz: Size = xpdleditor.xpdlDiagram.pool.size;
		szWidth = sz.width;
		if(initRate==0){
			initRate = sz.width/XPDLEditorBox.width;
		}
	}
}

public function doTimer(ev: TimerEvent): void {
	if (xpdleditor.xpdlDiagram) {
		var sz: Size = xpdleditor.xpdlDiagram.pool.size;
		szWidth = sz.width;
		if(initRate==0){
			initRate = sz.width/XPDLEditorBox.width;
		}
		
		xpdleditor.zoom += (_newZoom - _oldZoom) / _repeatCount;

		sz.width = sz.width * xpdleditor.zoom / 100;
		sz.height = sz.height * xpdleditor.zoom / 100;
		
		var dx: Number = ((xpdleditor.width - sz.width) / 2 - xpdleditor.scrollX) / _repeatCount * 4  / 5;
		var dy: Number = ((xpdleditor.height - sz.height) / 2 - xpdleditor.scrollY) / _repeatCount * 4 / 5;
		xpdleditor.scrollBy(dx, dy);
		
		ev.updateAfterEvent();
	}
}

public function doTimerComplete(ev: TimerEvent): void {
	xpdleditor.zoom = _newZoom;

	var sz: Size = xpdleditor.xpdlDiagram.pool.size;
	sz.width = sz.width * xpdleditor.zoom / 100;
	sz.height = sz.height * xpdleditor.zoom / 100;
	xpdleditor.scrollTo((xpdleditor.width - sz.width) / 2, (xpdleditor.height - sz.height) / 2);

	xpdleditor.playLinkingEffect(XPDLDiagramUtils.getSortedNodes(xpdleditor.xpdlDiagram));
}

private function get workbench():SmartWorkbench{
	return this.parentApplication.workbench;
}

public function sliderChange():void{
	xpdleditor.zoom = workbench.diagramScale.value;
	resizeWorkbench();
}

private function expandToolBoxBtnClick():void{
	toolBox.width=53;
	toolBox.height=380;
	defaultToolBox.visible=false;
	defaultToolBox.height=0;
	expandedToolBox.visible=true;
	expandedToolBox.height=10;
	processToolBar1Sub.visible=true;
	processToolBar1Sub.percentHeight=100;
	processToolBar2.visible=true;
	processToolBar2.width=20;
	processToolBar2.percentHeight=100;
	refreshToolbox();
}

private function collapseToolBoxBtnClick():void{
	toolBox.width=30;
	toolBox.height=111;
	defaultToolBox.visible=true;
	defaultToolBox.height=10;
	expandedToolBox.visible=false;
	expandedToolBox.height=0;
	processToolBar1Sub.visible=false;
	processToolBar1Sub.height=0;
	processToolBar2.visible=false;
	processToolBar2.width=0;
	processToolBar2.height=0;
	refreshToolbox();
}

public function refreshToolbox():void{
	if(toolBox.visible)
		if(toolBox.y+toolBox.height>WorkbenchConfig.contentHeight-this.processEditorHeaderToolBar.height)
			toolBox.y = WorkbenchConfig.contentHeight-this.processEditorHeaderToolBar.height-toolBox.height-8-20;
}

private function doToolBoxDragging(event: MouseEvent):void{
	var ds:DragSource = new DragSource();
	ds.addData(this, "toolBox");
	DragManager.doDrag(toolBox, ds, event);
}

private function doToolBoxDragEnter(event: DragEvent):void{
	if (   event.dragSource.hasFormat("toolBox")
   		&& Canvas(event.currentTarget).mouseY < Canvas(event.currentTarget).height 
    	&& Canvas(event.currentTarget).mouseX > VBox(event.dragInitiator).x 
        && Canvas(event.currentTarget).mouseX < VBox(event.dragInitiator).x + VBox(event.dragInitiator).width ) 
    {
        DragManager.acceptDragDrop(Canvas(event.currentTarget));
    }				
}
			
private function doToolBoxDragDrop(event: DragEvent):void{
	if (   event.dragSource.hasFormat("toolBox")
   		&& Canvas(event.currentTarget).mouseY < Canvas(event.currentTarget).height 
    	&& Canvas(event.currentTarget).mouseX > VBox(event.dragInitiator).x 
        && Canvas(event.currentTarget).mouseX < VBox(event.dragInitiator).x + VBox(event.dragInitiator).width ) 
    {
       	if(Canvas(event.currentTarget).mouseY<Canvas(event.currentTarget).height-VBox(event.dragInitiator).height)
       		VBox(event.dragInitiator).y = Canvas(event.currentTarget).mouseY ;
       	else
       		VBox(event.dragInitiator).y = Canvas(event.currentTarget).height-VBox(event.dragInitiator).height-20;
    }
}
		
public function touch():void{
//	proGet.height += 1;
//	proGet.height -= 1;
}

public function resizeWorkbench():void{

	if (xpdleditor.xpdlDiagram){
		var editorHeight:Number = xpdleditor.xpdlDiagram.pool.y + xpdleditor.xpdlDiagram.pool.height*xpdleditor.zoom/100 + xpdleditor.scrollMargin;
		editorHeight = (editorHeight>xpdleditor.minimumContentHeight)? editorHeight:xpdleditor.minimumContentHeight;
		var contentHeight:Number = this.processEditorHeaderToolBar.height+editorHeight+8;
		this.parentDocument.dispatchEvent(new LoadCallbackEvent(LoadCallbackEvent.LOAD_CALLBACK, LoadCallbackEvent.STAGENAME_PROCESS, contentHeight));
		xpdleditor.height = editorHeight;
	}
}

public function fitMap():void{
	xpdleditor.zoom = 100;
	this.resetExtents();
	xpdleditor.scrollTo(0,0);	
/*
	if (xpdleditor.xpdlDiagram) {
		var sz: Size = xpdleditor.xpdlDiagram.pool.size;
		szWidth = sz.width;
		sz = xpdleditor.xpdlDiagram.pool.size;
		var zx: Number = xpdleditor.width * 100 / sz.width;
		
		_oldZoom = xpdleditor.zoom;
		_newZoom = zx - 10;
		defaultZoom = _newZoom;
	}

	xpdleditor.zoom = defaultZoom;
	workbench.diagramScale.value = defaultZoom;
*/
	resizeWorkbench();
}

public function formListEdit():void{
	var position:Point = formListBtn.localToGlobal(new Point(0, formListBtn.height+1));
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

public function addLane():void{
	var lane: Lane = new Lane(xpdleditor.xpdlDiagram.pool);
	lane.name = resourceManager.getString("WorkbenchETC", "departmentText");
	xpdleditor.xpdlDiagram.pool.addLane(lane);
}

private function palMain_itemClick(event: PaletteItemEvent): void {
	trace(event.item.label);
	
	var node: Node = new Node();
	node.x = 310;
	node.y = 310;
	//node.width = 100;
	//node.height = 100;
	
	xpdleditor.execute(new NodeCreateCommand(xpdleditor.diagram.root, node));
}

public function loadTaskFormFields():void{
	_server.loadTaskFormFields();	
}