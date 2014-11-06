////////////////////////////////////////////////////////////////////////////////
//  Workbench_pde.as
//  2007.12.13, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////
//import com.maninsoft.smart.modeler.assets.Fonts;
import com.maninsoft.smart.modeler.command.LinkDeleteCommand;
import com.maninsoft.smart.modeler.command.NodeCreateCommand;
import com.maninsoft.smart.modeler.command.NodeDeleteCommand;
import com.maninsoft.smart.modeler.common.Size;
import com.maninsoft.smart.modeler.editor.events.CreateNodeRequestEvent;
import com.maninsoft.smart.modeler.editor.events.DiagramChangeEvent;
import com.maninsoft.smart.modeler.editor.events.SelectionEvent;
import com.maninsoft.smart.modeler.editor.helper.AlignmentTypes;
import com.maninsoft.smart.modeler.model.Node;
import com.maninsoft.smart.modeler.model.events.LinkEvent;
import com.maninsoft.smart.modeler.toolTipMenu.event.ToolTipMenuEvent;
import com.maninsoft.smart.modeler.xpdl.components.ProblemFixUpRenderer;
import com.maninsoft.smart.modeler.xpdl.components.ProblemHintRenderer;
import com.maninsoft.smart.modeler.xpdl.dialogs.ProblemDialog;
import com.maninsoft.smart.modeler.xpdl.model.Pool;
import com.maninsoft.smart.modeler.xpdl.model.StartEvent;
import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
import com.maninsoft.smart.modeler.xpdl.model.base.XPDLLink;
import com.maninsoft.smart.modeler.xpdl.model.base.XPDLNode;
import com.maninsoft.smart.modeler.xpdl.model.pool.Lane;
import com.maninsoft.smart.modeler.xpdl.navigator.DiagramTreeActivity;
import com.maninsoft.smart.modeler.xpdl.navigator.DiagramTreeForm;
import com.maninsoft.smart.modeler.xpdl.navigator.DiagramTreeLane;
import com.maninsoft.smart.modeler.xpdl.packages.PackageTreeForm;
import com.maninsoft.smart.modeler.xpdl.packages.PackageTreeFormRoot;
import com.maninsoft.smart.modeler.xpdl.packages.PackageTreeProcess;
import com.maninsoft.smart.modeler.xpdl.parser.XPDLWriter;
import com.maninsoft.smart.modeler.xpdl.server.Server;
import com.maninsoft.smart.modeler.xpdl.server.TaskForm;
import com.maninsoft.smart.modeler.xpdl.server.TaskFormField;
import com.maninsoft.smart.modeler.xpdl.server.service.GetProcessInfoByPackageService;
import com.maninsoft.smart.modeler.xpdl.server.service.LoadDiagramService;
import com.maninsoft.smart.modeler.xpdl.server.service.SaveDiagramService;
import com.maninsoft.smart.modeler.xpdl.syntax.Problem;
import com.maninsoft.smart.modeler.xpdl.syntax.SyntaxChecker;
import com.maninsoft.smart.modeler.xpdl.tool.LaneSelectionEvent;
import com.maninsoft.smart.modeler.xpdl.utils.XPDLDiagramUtils;
import com.maninsoft.smart.workbench.command.CheckInPackageCommond;
import com.maninsoft.smart.workbench.command.CheckOutPackageCommond;
import com.maninsoft.smart.workbench.common.event.FormEditorEvent;
import com.maninsoft.smart.workbench.common.meta.SmartModelConstant;
import com.maninsoft.smart.workbench.common.meta.impl.SWProcess;
import com.maninsoft.smart.workbench.event.MISPackageEvent;
import com.maninsoft.smart.workbench.util.WorkbenchConfig;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

import mx.controls.Alert;
import mx.controls.TextInput;
import mx.core.Container;
import mx.events.CloseEvent;
import mx.events.DragEvent;
import mx.events.DynamicEvent;
import mx.events.ItemClickEvent;
import mx.events.ListEvent;
import mx.events.ResizeEvent;


//------------------------------------------------------------------------------
// Variables
//------------------------------------------------------------------------------

private var _syntaxChecker: SyntaxChecker;
//private var _swProcess: SWProcess;
private var _packId: String;
private var _packVer: String;

private var _server: Server;
private var _xpdlSource: XML;
private var _loadDiagram: Boolean;

//------------------------------------------------------------------------------
// Internal methods
//------------------------------------------------------------------------------

private function refreshPackageTree(): void {
	dnavMain.editor = null
	dnavMain.removeEventListener(ListEvent.CHANGE, dnavMain_change);
	deMain.diagram = null;
	deMain.deactivate();

	//miniXPDLEditor.diagram = null;
	//miniXPDLEditor.deactivate();

	openPackageTree(_packId, _packVer, dnavMain.packageName, true);
}

private function refreshFormTree(): void {
	openPackageTree(_packId, _packVer, dnavMain.packageName, false);
}

private function openPackageTree(packId: String, packVer: String, packName: String, loadDiagram: Boolean): void {
	_packId = packId;
	_packVer = packVer;
	dnavMain.packageName = packName;
	_loadDiagram = loadDiagram;
	
	if (_server == null) {
		_server = new Server(WorkbenchConfig.serviceUrl, WorkbenchConfig.userId, packId, packVer);
		_server.addEventListener("serverLoaded", loadPackageTree);
		deMain.server = _server;
		//miniXPDLEditor.server = _server;
	}
	
	_server.load();
}

private function loadPackageTree(event: Event): void {
	var svc: GetProcessInfoByPackageService = new GetProcessInfoByPackageService();
	svc.serviceUrl = WorkbenchConfig.serviceUrl;
	svc.userId = WorkbenchConfig.userId;
	svc.packageId = _packId;
	svc.version = _packVer;
	svc.resultHandler = loadPackageTree_result;
	svc.send();
}

private function loadPackageTree_result(svc: GetProcessInfoByPackageService): void {
	_server.process = svc.process;
	dnavMain.server = _server;
	
	if (_loadDiagram && _server.process) {
		loadDiagram();
	}
}

private function loadDiagram(): void {
	var svc: LoadDiagramService = new LoadDiagramService();
	
	svc.serviceUrl = WorkbenchConfig.serviceUrl;
	svc.userId = WorkbenchConfig.userId;
	svc.processId = _server.process.processId;
	svc.version = _packVer;

	svc.resultHandler = loadDiagram_result;
	svc.send();
}


private function loadDiagram_result(svc: LoadDiagramService): void {
	deMain.beginLoading();
	//miniXPDLEditor.beginLoading();
	try {
		deMain.activate();
		deMain.diagram = svc.diagram;
		
		//miniXPDLEditor.activate();
		//miniXPDLEditor.diagram = svc.diagram;
		
		dnavMain.editor = deMain;
		dnavMain.addEventListener(ListEvent.CHANGE, dnavMain_change);
		checkSyntax();
		resetExtents();
	} finally {
		deMain.endLoading();	
		saveDiagram("initSave");	
	}

	try {
		deMain.playLinkingEffect(XPDLDiagramUtils.getSortedNodes(deMain.xpdlDiagram));
	}
	catch (ex: Error) {
	}
}

private function saveDiagram(type:String): void {
	deMain.beginSaving();
	var currForms:Array = _server.currentTaskForms;
	var currFormFields:Array = _server.currentTaskFormFields;
	var forms:Array = _server.taskForms;
	var formFields:Array = _server.taskFormFields;
	var activities:Array = dnavMain.editor.xpdlDiagram.activities;
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
		deMain.endSaving();
	}
}

private function refreshXpdlSource(): void {
	var writer: XPDLWriter = new XPDLWriter();
	var xml: XML = writer.serialize(deMain.diagram as XPDLDiagram)
	_xpdlSource = new XML('<?xml version="1.0" encoding="utf-8"?>' + xml.toString());
}

private function saveToUrl(type:String): void {
	refreshXpdlSource();

	var svc: SaveDiagramService = new SaveDiagramService();
	svc.serviceUrl = WorkbenchConfig.serviceUrl;
	svc.userId = WorkbenchConfig.userId;
	svc.processId = _server.process.processId;
	svc.version = _packVer;
	svc.saveType = type;
	svc.processContent = _xpdlSource.toXMLString();
	svc.send();
}

private function checkSyntax(): void {
	_syntaxChecker.check(deMain.xpdlDiagram);
	//Alert.show(_syntaxChecker.problems.length.toString());
	grdProblem.dataProvider = _syntaxChecker.problems;
}


//------------------------------------------------------------------------------
// Event handlers
//------------------------------------------------------------------------------

//----------------------------
// tbarMain
//----------------------------

private function tbarPDEPalette_itemClick(event: ItemClickEvent): void {
	//trace(event.item.label);
	switch (event.item.label) {
		case "select":
			deMain.resetTool();
			break;
			
		case "sequence":
			deMain.beginConnection();
			break;
			
		case "pool":
			deMain.beginCreation("Pool");
			break;
			
		case "start":
			deMain.beginCreation("StartEvent");
			break;
			
		case "end":
			deMain.beginCreation("EndEvent");
			break;
			
		case "task":
			deMain.beginCreation("TaskApplication");
			break;
			
		case "xor":
			deMain.beginCreation("XorGateway");
			break;
			
		case "and":
			deMain.beginCreation("AndGateway");
			break;
			
		case "or":
			deMain.beginCreation("OrGateway");
			break;
			
		case "dataobject":
			deMain.beginCreation("DataObject");
			break;
			
		case "group":
			deMain.beginCreation("Group");
			break;
			
		case "annotation":
			deMain.beginCreation("Annotation");
			break;
	}
}

private function tbarPDEPalette_btnClick(btnId:String): void {
	switch (btnId) {
		case "select":
			deMain.resetTool();
			break;
			
		case "sequence":
			deMain.beginConnection();
			break;
			
		case "pool":
			deMain.beginCreation("Pool");
			break;
			
		case "start":
			deMain.beginCreation("StartEvent");
			break;
			
		case "end":
			deMain.beginCreation("EndEvent");
			break;
			
		case "task":
			deMain.beginCreation("TaskApplication");
			break;
			
		case "xor":
			deMain.beginCreation("XorGateway");
			break;
			
		case "and":
			deMain.beginCreation("AndGateway");
			break;
			
		case "or":
			deMain.beginCreation("OrGateway");
			break;
			
		case "dataobject":
			deMain.beginCreation("DataObject");
			break;
			
		case "group":
			deMain.beginCreation("Group");
			break;
			
		case "annotation":
			deMain.beginCreation("Annotation");
			break;
	}
}


//----------------------------
// tbarDiagram
//----------------------------

private function tbarDiagram_itemClick(event: ItemClickEvent): void {
	switch (event.item.label) {
		case "S":
			saveDiagram("save");
			break;
	}
}


//----------------------------
// tbarEdit
//----------------------------

private function tbarPDEEdit_itemClick(event: ItemClickEvent): void {
	switch (event.item.label) {
		case "U":
			deMain.undo();
			break;

		case "R":
			deMain.redo();
			break;

		case "+":
			deMain.zoom += 5;
			break;
			
		case "-":
			deMain.zoom -= 5;
			break;
			
		case "?":
			deMain.changeOrientation();
			break;
	}
}


//----------------------------
// tbarAlign
//----------------------------

private function tbarPDEAlign_itemClick(event: ItemClickEvent): void {
	switch (event.item.label) {
		case "align_left":
			deMain.alignSelection(AlignmentTypes.ALIGN_LEFT);
			break;
			
		case "align_hcenter":
			deMain.alignSelection(AlignmentTypes.ALIGN_HCENTER);
			break;
			
		case "align_right":
			deMain.alignSelection(AlignmentTypes.ALIGN_RIGHT);
			break;
			
		case "align_top":
			deMain.alignSelection(AlignmentTypes.ALIGN_TOP);
			break;
			
		case "align_vcenter":
			deMain.alignSelection(AlignmentTypes.ALIGN_VCENTER);
			break;
			
		case "align_bottom":
			deMain.alignSelection(AlignmentTypes.ALIGN_BOTTOM);
			break;
			
		case "align_lanecenter":
			deMain.alignSelection("laneCenter");
			break;
			
	}
}

//----------------------------
// tbarDiagram
//----------------------------

private function tbarDiagram_BtnClick(btnId:String): void {
	switch (btnId) {
		case "SAVE":
			saveDiagram("save");
			break;
	}
}


//----------------------------
// tbarEdit
//----------------------------

private function tbarPDEEdit_BtnClick(btnId:String): void {
	switch (btnId) {
		case "UNDO":
			deMain.undo();
			break;

		case "REDO":
			deMain.redo();
			break;

		case "ZOOMIN":
			deMain.zoom += 5;
			break;
			
		case "ZOOMOUT":
			deMain.zoom -= 5;
			break;
			
		case "ORIENTATION":
			deMain.changeOrientation();
			break;
	}
}


//----------------------------
// tbarAlign
//----------------------------

private function tbarPDEAlign_BtnClick(btnId:String): void {
	switch (btnId) {
		case "ALIGN_LEFT":
			deMain.alignSelection(AlignmentTypes.ALIGN_LEFT);
			break;
			
		case "ALIGN_HCENTER":
			deMain.alignSelection(AlignmentTypes.ALIGN_HCENTER);
			break;
			
		case "ALIGN_RIGHT":
			deMain.alignSelection(AlignmentTypes.ALIGN_RIGHT);
			break;
			
		case "ALIGN_TOP":
			deMain.alignSelection(AlignmentTypes.ALIGN_TOP);
			break;
			
		case "ALIGN_VCENTER":
			deMain.alignSelection(AlignmentTypes.ALIGN_VCENTER);
			break;
			
		case "ALIGN_BOTTOM":
			deMain.alignSelection(AlignmentTypes.ALIGN_BOTTOM);
			break;
			
		case "ALIGN_LANECENTER":
			deMain.alignSelection("laneCenter");
			break;
			
	}
}

//----------------------------
// dnavMain
//----------------------------

private function dnavMain_change(event: ListEvent): void {
	deMain.select(dnavMain.currentActivity);
	if (dnavMain.currentActivity is TaskApplication){
		if(TaskApplication(dnavMain.currentActivity).formId!=null){
			miniFormLoad(TaskApplication(dnavMain.currentActivity).formId);
		}
	}
	else if (dnavMain.currentLane)
		deMain.selectLane(dnavMain.currentLane);
}

private function dnavMain_doubleClick(event: MouseEvent): void {
	var item: Object = dnavMain.selectedItem;
	if(item==null){
		return;
	}
	if (item is PackageTreeForm) {
		//openForm(item["formId"]);
		packageFormToolTipMenu.form = item as PackageTreeForm;
		packageFormToolTipMenu.x = Application.application.mouseX;
		packageFormToolTipMenu.y = Application.application.mouseY;
		packageFormToolTipMenu.open();	
		allToolTipMenuDisable(packageFormToolTipMenu);
	}else if(item is DiagramTreeForm){
		diagramFormToolTipMenu.form = item as DiagramTreeForm;
		diagramFormToolTipMenu.x = Application.application.mouseX;
		diagramFormToolTipMenu.y = Application.application.mouseY;
		diagramFormToolTipMenu.open();
		allToolTipMenuDisable(diagramFormToolTipMenu);
	}else if (item is PackageTreeProcess) {
		openProcess();
		processToolTipMenu.x = Application.application.mouseX;
		processToolTipMenu.y = Application.application.mouseY;
		processToolTipMenu.open();	
		allToolTipMenuDisable(processToolTipMenu);
	}else if(item.parent==null && !(item is PackageTreeProcess)){
		singleWorkToolTipMenu.x = Application.application.mouseX;
		singleWorkToolTipMenu.y = Application.application.mouseY;
		singleWorkToolTipMenu.open();	
		allToolTipMenuDisable(singleWorkToolTipMenu);
	}else if (item is DiagramTreeActivity) {
		activityToolTipMenu.activity = diagramPropertyPage.PDEPropertyPage1.propSource as Activity;
		activityToolTipMenu.x = Application.application.mouseX;
		activityToolTipMenu.y = Application.application.mouseY;
		activityToolTipMenu.open();	
		allToolTipMenuDisable(activityToolTipMenu);
	}else if (item is DiagramTreeLane) {
		laneToolTipMenu.lane = diagramPropertyPage.PDEPropertyPage1.propSource as Lane;
		laneToolTipMenu.x = Application.application.mouseX;
		laneToolTipMenu.y = Application.application.mouseY;
		laneToolTipMenu.open();	
		allToolTipMenuDisable(laneToolTipMenu);
	}
}

private function dnavMain_menuItemSelect(event: DynamicEvent): void {
	if (event.menu.caption == "열기") {
		if (event.node is DiagramTreeForm || event.node is PackageTreeForm) {
			openForm(event.node["formId"]);
		}
		else if (event.node is PackageTreeProcess) {
			openProcess();
		}
	}
	
	else if (event.menu.caption == "이름 바꾸기") {
		dnavMain.editedItemPosition = {rowIndex: this.dnavMain.selectedIndex, columnIndex: 0};
	}
	
	else if (event.menu.caption == "단위업무로 변경") {
		changeFormTypeService(swForm.id, String(swForm.version))
	}
	
	else if (event.menu.caption == "삭제") {
		if (event.node is PackageTreeProcess) {
			removeProcess();
		}
		else if (event.node is PackageTreeForm) {
			removeForm(PackageTreeForm(event.node).formId);
		}
	}
	else if (event.menu.caption == "프로세스 생성") {
		addProcess();
	}
	else if (event.menu.caption == "단위업무 추가") {
		addForm();
	}
}

private function packageInfoRename(event:ListEvent, type:String):void{
	// Disable copying data back to the control.
    event.preventDefault();
	var newName:String = TextInput(dnavMain.itemEditorInstance).text
	if(type == SmartModelConstant.FORM_TYPE){
		WorkbenchConfig.repoService.renameForm(swForm, newName, renameSucess, renameFail);
	}else if(type == SmartModelConstant.PROCESS_TYPE){
		this.swProcess = SWProcess(swPackage.getProcessResource());
		this.swProcess.name = newName;
		WorkbenchConfig.repoService.renameProcess(swPackage, this.swProcess, renameSucess, renameFail);	
	}else{
		return;
	}                 

    // Close the item editor.
    dnavMain.destroyItemEditor();
    dnavMain.editable = false;
    dnavMain.setFocus();   
}

private function renameSucess(packEvent:MISPackageEvent):void{
	//refreshPackageTree();
	//saveDiagram();
}

private function renameFail(packEvent:MISPackageEvent):void{
}

private function formRename(event:FormEditorEvent):void{
	var taskForms:Array = _server.taskForms;
	var activities:Array = dnavMain.editor.xpdlDiagram.activities;
	
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
			}
		}
	}
	dnavMain.refresh();
}

private function formFieldRename(event:FormEditorEvent):void{
	var taskFormFields:Array = _server.taskFormFields;
	var activities:Array = dnavMain.editor.xpdlDiagram.activities;
	
	for each (var formField: TaskFormField in taskFormFields) {
		if(formField.id == event.formFieldId && formField.name!=event.newName){
			formField.name = event.newName;
		}
	}
	
	for each (var act: Activity in activities) {
		if(act is TaskApplication){
			var taskApp:TaskApplication = act as TaskApplication;
			if(taskApp.formId == event.formId && taskApp.performer == event.formFieldId && taskApp.performerName!=event.newName){
				taskApp.performerName = event.newName;
			}
		}
	}
}

private function dnavMain_dragEnter(event: DragEvent): void {
	trace(event.toString());
}

private function dnavMain_dragOver(event: DragEvent): void {
	trace(event.toString());
}

private function dnavMain_dragDrop(event: DragEvent): void {
	event.preventDefault();
    dnavMain.hideDropFeedback(event);

	var dropLoc: int = dnavMain.calculateDropIndex(event);

	var dragObjs: Array = event.dragSource.dataForFormat("treeItems") as Array;
	
	if (dragObjs && dragObjs.length > 0) {
		var dragNode: Object = dragObjs[0];
		var dropNode: Object = dnavMain.indexToItemRenderer(dnavMain.calculateDropIndex(event)).data;

		if (dragNode is DiagramTreeForm && (dropNode is PackageTreeFormRoot || dropNode is PackageTreeForm)) {
			TaskApplication(DiagramTreeActivity(DiagramTreeForm(dragNode).parent).activity).formId = null;
		}
		else if (dragNode is PackageTreeForm && dropNode is DiagramTreeActivity) {
			TaskApplication(DiagramTreeActivity(dropNode).activity).formId = PackageTreeForm(dragNode).formId;
		}
		else if (dragNode is PackageTreeForm && dropNode is DiagramTreeForm) {
			TaskApplication(DiagramTreeActivity(dropNode.parent).activity).formId = PackageTreeForm(dragNode).formId;
		}
 	}
}


//----------------------------
// deMain
//----------------------------

private function deMain_creationComplete(event: Event): void {
	_syntaxChecker = new SyntaxChecker();
	//Fonts.init();
}

/**
 * palette 에서 드랍되어 생성되는 경우 후출
 * 그 외의 경우는 XPDLNodeFactory에서 처리
 */
private function deMain_createNodeRequest(event: CreateNodeRequestEvent): void {
	trace(event.creationType + ": " + event.creationRect);
	
	var r: Rectangle = event.creationRect;
	var node: XPDLNode = deMain.createNode(event.creationType) as XPDLNode;
	
	if (node) {
		node.x = r.x;
		node.y = r.y;
		
		if (r.width > 8 && r.height > 8) {
			node.size = (new Size(r.width, r.height));
		}
		
		deMain.execute(new NodeCreateCommand(event.parent as Node, node));
		
		deMain.resetTool();
		//tbarPDEPalette.selectedIndex = 0;
	}
}

private function deMain_linkCreated(event: LinkEvent): void {
	if (!deMain.isLoading)
		XPDLLink(event.link).id = XPDLDiagram(deMain.diagram).getNextId();
}

private function deMain_selectionChanged(event: SelectionEvent): void {
	diagramPropertyPage.PDEPropertyPage1.propSource = event.selectedSource;
	//diagramPropertyPage.PDEPropertyPage2.propSource = event.selectedSource;
	dnavMain.currentActivity = event.selectedItem as Activity;
	
	if (dnavMain.currentActivity is TaskApplication){
		if(TaskApplication(dnavMain.currentActivity).formId!=null){
			miniFormLoad(TaskApplication(dnavMain.currentActivity).formId);
		}
	}
}

private function deMain_laneSelectionChanged(event: LaneSelectionEvent): void {
	diagramPropertyPage.PDEPropertyPage1.propSource = event.selectedLane;
	//diagramPropertyPage.PDEPropertyPage2.propSource = event.selectedLane;
	dnavMain.currentLane = event.selectedLane;
}

private function deMain_toolInitialized(event: Event): void {
	//tbarPDEPalette.selectedIndex = 0;
}

private function deMain_diagramChanged(event: DiagramChangeEvent): void {
	checkSyntax();
}


//---------------------------
// diagramPropertyPage
//---------------------------

private function diagramPropertyPage_sourceChanged(event: Event): void {
	//if (diagramPropertyPage.propSource)
	//	txtProperty.text = diagramPropertyPage.propSource.displayName;
	if(diagramPropertyPage.PDEPropertyPage1.propSource!=null){
		if(diagramPropertyPage.PDEPropertyPage1.propSource is Lane){
			laneToolTipMenu.lane = diagramPropertyPage.PDEPropertyPage1.propSource as Lane;
			laneToolTipMenu.x = Application.application.mouseX;
			laneToolTipMenu.y = Application.application.mouseY;
			laneToolTipMenu.open();	
			allToolTipMenuDisable(laneToolTipMenu);
		}else if(diagramPropertyPage.PDEPropertyPage1.propSource is XPDLLink){
			linkToolTipMenu.link = diagramPropertyPage.PDEPropertyPage1.propSource as XPDLLink;
			linkToolTipMenu.x = Application.application.mouseX;
			linkToolTipMenu.y = Application.application.mouseY;
			linkToolTipMenu.open();	
			allToolTipMenuDisable(linkToolTipMenu);
		}else{
			activityToolTipMenu.activity = diagramPropertyPage.PDEPropertyPage1.propSource as Activity;
			activityToolTipMenu.x = Application.application.mouseX;
			activityToolTipMenu.y = Application.application.mouseY;
			activityToolTipMenu.open();	
			allToolTipMenuDisable(activityToolTipMenu);
		}
	}
//	else if(dnavMain.selectedItem.parent==null){
//		processToolTipMenu.x = Application.application.mouseX;
//		processToolTipMenu.y = Application.application.mouseY;
//		processToolTipMenu.open();	
//		allToolTipMenuDisable(processToolTipMenu);
//	}
	
}

private function diagramPropertyPage_selectionChanged(event: Event): void {
	/*
	if (diagramPropertyPage.currentItem)
		txtPropDesc.text = diagramPropertyPage.currentItem.propInfo.description;
	else
		txtPropDesc.text = "";
    */
}


//----------------------------
// grdProblem
//----------------------------

/**
 * 힌트 컬럼과 처리 컬럼의 renderer를 설정한다.
 */
private function grdProblem_creationComplete(event: Event): void {
	var factory: ClassFactory = new ClassFactory(ProblemFixUpRenderer);
	factory.properties = {editor: deMain};
	colFixUp.itemRenderer = factory;	

	factory = new ClassFactory(ProblemHintRenderer);
	factory.properties = {editor: deMain};
	colHint.itemRenderer = factory;	
}


/**
 * 마우스로 클릭하면 문제가 되는 다이어그램 개체를 선택한다.
 */
private function grdProblem_click(event: MouseEvent): void {
	if (grdProblem.selectedItem)
		deMain.select(grdProblem.selectedItem.source);
}

/**
 * 더블클릭하면 힌트 상자를 표시한다. 다른게 있을까?
 */
private function grdProblem_doubleClick(event: MouseEvent): void {
	var problem: Problem = grdProblem.selectedItem as Problem;
			
	if (problem && problem.hasHint)
		ProblemDialog.execute(problem, deMain);
}


private var _oldZoom: Number;
private var _newZoom: Number;
private var _repeatDelay: Number = 10;
private var _repeatCount: Number = 20;
[Bindable]
private var szWidth:Number;
private var initRate:Number = 0;
private var initCount:int = 0;
private var defalultZoom: Number;

private function deMain_resize(event: ResizeEvent): void {
	resetExtents();
}

private function resetExtents(): void {
	var timerWidth: Timer = new Timer(_repeatDelay, _repeatCount);
	timerWidth.addEventListener(TimerEvent.TIMER, doTimerWidth);
	timerWidth.start();
	if (deMain.xpdlDiagram) {
		var sz: Size = deMain.xpdlDiagram.pool.size;
		szWidth = sz.width;
		sz = deMain.xpdlDiagram.pool.size;
		var zx: Number = deMain.width * 100 / sz.width;
		var zy: Number = deMain.height * 100 / sz.height;
		
		diagramScale.minimum = 0;
		diagramScale.maximum = deMain.zoom * 2;
		diagramScale.value = deMain.zoom;
		diagramScale.tickInterval = deMain.zoom * 2 /10;
		defalultZoom = deMain.zoom;
		
		_oldZoom = deMain.zoom;
		_newZoom = Math.min(zx, zy) - 10;
		//var timer: Timer = new Timer(_repeatDelay, _repeatCount);
		//timer.addEventListener(TimerEvent.TIMER, doTimer);
		//timer.addEventListener(TimerEvent.TIMER_COMPLETE, doTimerComplete);
		//timer.start();
	}
}

private function doTimerWidth(ev: TimerEvent): void {
	if (deMain.xpdlDiagram) {
		var sz: Size = deMain.xpdlDiagram.pool.size;
		szWidth = sz.width;
		if(initRate==0){
			initRate = sz.width/XPDLEditorHBox.width;
		}
	}
}

private function doTimer(ev: TimerEvent): void {
	if (deMain.xpdlDiagram) {
		var sz: Size = deMain.xpdlDiagram.pool.size;
		szWidth = sz.width;
		if(initRate==0){
			initRate = sz.width/XPDLEditorHBox.width;
		}
		
		deMain.zoom += (_newZoom - _oldZoom) / _repeatCount;

		sz.width = sz.width * deMain.zoom / 100;
		sz.height = sz.height * deMain.zoom / 100;
		
		var dx: Number = ((deMain.width - sz.width) / 2 - deMain.scrollX) / _repeatCount * 4  / 5;
		var dy: Number = ((deMain.height - sz.height) / 2 - deMain.scrollY) / _repeatCount * 4 / 5;
		deMain.scrollBy(dx, dy);
		
		ev.updateAfterEvent();
	}
}

private function doTimerComplete(ev: TimerEvent): void {
	deMain.zoom = _newZoom;

	var sz: Size = deMain.xpdlDiagram.pool.size;
	sz.width = sz.width * deMain.zoom / 100;
	sz.height = sz.height * deMain.zoom / 100;
	deMain.scrollTo((deMain.width - sz.width) / 2, (deMain.height - sz.height) / 2);

	deMain.playLinkingEffect(XPDLDiagramUtils.getSortedNodes(deMain.xpdlDiagram));
}

//---------------------------
// cmZoomIn
//---------------------------
private function cmZoomIn_click(event: MouseEvent): void {
	deMain.zoom += 10;
	var sz: Size = deMain.xpdlDiagram.pool.size;
	diagramScale.value = deMain.zoom;
}

//----------------------------
// cmZoomOut
//----------------------------

private function cmZoomOut_click(event: MouseEvent): void {
	deMain.zoom -= 10;
	var sz: Size = deMain.xpdlDiagram.pool.size;
	diagramScale.value = deMain.zoom;
}

//---------------------------
// cmZoomIn
//---------------------------
private function cmZoomIn_Slider(value:Number): void {
	var ga:Number = value - deMain.zoom;
	deMain.zoom = value;
	var sz: Size = deMain.xpdlDiagram.pool.size;
	diagramScale.value = deMain.zoom;
}

//----------------------------
// cmZoomOut
//----------------------------

private function cmZoomOut_Slider(value:Number): void {
	var ga:Number =  deMain.zoom - value;
	deMain.zoom = value;
	var sz: Size = deMain.xpdlDiagram.pool.size;
	diagramScale.value = deMain.zoom;
}

private function sliderChange():void{
	if(diagramScale.value>defalultZoom){
		cmZoomIn_Slider(diagramScale.value);
	}else if(diagramScale.value<defalultZoom){
		cmZoomOut_Slider(diagramScale.value);
	}
}

private function fitMap():void{
	deMain.zoom = defalultZoom;
	diagramScale.value = defalultZoom;
}


//액티비트 ToolTipMenu 관련 함수
private function registerTooltipActivityMenu():void{
	activityToolTipMenu.addEventListener(ToolTipMenuEvent.PROPERTY, toolTipActivityMenuProperty);
	activityToolTipMenu.addEventListener(ToolTipMenuEvent.RENAME, toolTipActivityRename);
	activityToolTipMenu.addEventListener(ToolTipMenuEvent.REMOVE, toolTipActivityRemove);
}

private function toolTipActivityMenuProperty(e:ToolTipMenuEvent):void{
	propertyPop(diagramEditorPropertyStage);
	activityToolTipMenu.close();
}

private function toolTipActivityRename(e:ToolTipMenuEvent):void{
	dnavMain.editedItemPosition = {rowIndex: this.dnavMain.selectedIndex, columnIndex: 0};
	dnavMain.editableTrue();
	activityToolTipMenu.close();
}

private function toolTipActivityRemove(e:ToolTipMenuEvent):void{
	deMain.clearSelection();
	Alert.show("삭제 하시겠습니까?", "", 3, this, 
		function removeExe(event:CloseEvent):void{
			if (event.detail==Alert.YES){
				deMain.execute(new NodeDeleteCommand(activityToolTipMenu.activity));
			}
		});
	activityToolTipMenu.close();
}


//레인(Lane) ToolTipMenu 관련 함수
private function registerTooltipLaneMenu():void{
	laneToolTipMenu.addEventListener(ToolTipMenuEvent.PROPERTY, toolTipLaneMenuProperty);
	laneToolTipMenu.addEventListener(ToolTipMenuEvent.ACTIVITYADD, toolTipLaneMenuDeptAdd);
	laneToolTipMenu.addEventListener(ToolTipMenuEvent.RENAME, toolTipLaneMenuRename);
	laneToolTipMenu.addEventListener(ToolTipMenuEvent.REMOVE, toolTipLaneMenuRemove);
}

private function toolTipLaneMenuProperty(e:ToolTipMenuEvent):void{
	propertyPop(diagramEditorPropertyStage);
	laneToolTipMenu.close();
}

private function toolTipLaneMenuDeptAdd(e:ToolTipMenuEvent):void{
	var node: DiagramTreeLane = dnavMain.selectedItem as DiagramTreeLane;
	if (node) {
		var lane: Lane = node.lane;
		var pool: Pool = dnavMain.diagram.pool;
		
		if (lane) {
			var act: Activity;

			if (!pool.hasActivityOf(StartEvent))  {
				act = new StartEvent();						
			} 
			else {
				act = new TaskApplication();
			}
			var p: Point = dnavMain.diagram.pool.getNextActivityPos(lane, act);
			act.center = p;
			deMain.execute(new NodeCreateCommand(dnavMain.diagram.pool, act));
			dnavMain.currentActivity = act;
		}
	}
	laneToolTipMenu.close();
}

private function toolTipLaneMenuRename(e:ToolTipMenuEvent):void{
	dnavMain.editedItemPosition = {rowIndex: this.dnavMain.selectedIndex, columnIndex: 0};
	dnavMain.editableTrue();
	laneToolTipMenu.close();
}

private function toolTipLaneMenuRemove(e:ToolTipMenuEvent):void{
	Alert.show("삭제 하시겠습니까?", "", 3, this, 
		function removeExe(event:CloseEvent):void{
			if (event.detail==Alert.YES){
				deMain.deleteLane(laneToolTipMenu.lane);
			}
		});
	laneToolTipMenu.close();
}


//프로세스  ToolTipMenu 관련 함수
private function registerTooltipProcessMenu():void{
	processToolTipMenu.addEventListener(ToolTipMenuEvent.DEPTADD, toolTipProcessMenuDeptAdd);
	processToolTipMenu.addEventListener(ToolTipMenuEvent.RENAME, toolTipProcessMenuRename);
	processToolTipMenu.addEventListener(ToolTipMenuEvent.REMOVE, toolTipProcessMenuRemove);
}

private function toolTipProcessMenuDeptAdd(e:ToolTipMenuEvent):void{
	var lane: Lane = new Lane(dnavMain.diagram.pool);
	lane.name = "부서";
	dnavMain.diagram.pool.addLane(lane);
	processToolTipMenu.close();
}

private function toolTipProcessMenuRename(e:ToolTipMenuEvent):void{
	dnavMain.editedItemPosition = {rowIndex: this.dnavMain.selectedIndex, columnIndex: 0};
	dnavMain.editableTrue();
	processToolTipMenu.close();
}

private function toolTipProcessMenuRemove(e:ToolTipMenuEvent):void{
	Alert.show("삭제 하시겠습니까?", "", 3, this, 
		function removeExe(event:CloseEvent):void{
			if (event.detail==Alert.YES){
				removeProcess();
			}
		});
	processToolTipMenu.close();
}


//단위업무  ToolTipMenu 관련 함수
private function registerTooltipSingleMenu():void{
	singleWorkToolTipMenu.addEventListener(ToolTipMenuEvent.PROCESSCREATE, toolTipSingleMenuProcessAdd);
	singleWorkToolTipMenu.addEventListener(ToolTipMenuEvent.FORMADD, toolTipSingleMenuFormAdd);
}

private function toolTipSingleMenuProcessAdd(e:ToolTipMenuEvent):void{
	addProcess();
	singleWorkToolTipMenu.close();
}

private function toolTipSingleMenuFormAdd(e:ToolTipMenuEvent):void{
	addForm();
	singleWorkToolTipMenu.close();
}


//패키지 Form ToolTipMenu 관련 함수
private function registerTooltipPackageFormMenu():void{
	packageFormToolTipMenu.addEventListener(ToolTipMenuEvent.EDITOR, toolTipPackageFormMenuEditor);
	packageFormToolTipMenu.addEventListener(ToolTipMenuEvent.REMOVE, toolTipPackageFormMenuRemove);
}

private function toolTipPackageFormMenuEditor(e:ToolTipMenuEvent):void{
	openForm(packageFormToolTipMenu.form.formId);
	packageFormToolTipMenu.close();
}

private function toolTipPackageFormMenuRemove(e:ToolTipMenuEvent):void{
	Alert.show("삭제 하시겠습니까?", "", 3, this, 
		function removeExe(event:CloseEvent):void{
			if (event.detail==Alert.YES){
				removeForm(packageFormToolTipMenu.form.formId);
			}
		});
	packageFormToolTipMenu.close();
}


//다이어그램 Form ToolTipMenu 관련 함수
private function registerTooltipDiagramFormMenu():void{
	diagramFormToolTipMenu.addEventListener(ToolTipMenuEvent.EDITOR, toolTipDiagramFormMenuEditor);
}

private function toolTipDiagramFormMenuEditor(e:ToolTipMenuEvent):void{
	openForm(diagramFormToolTipMenu.form.formId);
	diagramFormToolTipMenu.close();
}

//패키지 Form ToolTipMenu 관련 함수
private function registerTooltipPackageMenu():void{
	packageToolTipMenu.addEventListener(ToolTipMenuEvent.CHECKIN, toolTipPackageMenuCheckIn);
	packageToolTipMenu.addEventListener(ToolTipMenuEvent.CHECKOUT, toolTipPackageMenuCheckOut);
}

private function toolTipPackageMenuCheckIn(e:ToolTipMenuEvent):void{
	editDomain.getCommandStack().execute(new CheckInPackageCommond(this.packId, this.packVer, checkHandler));
	packageToolTipMenu.close();
}

private function toolTipPackageMenuCheckOut(e:ToolTipMenuEvent):void{
	editDomain.getCommandStack().execute(new CheckOutPackageCommond(this.packId, this.packVer, checkHandler));
	packageToolTipMenu.close();
}

public function checkHandler(event:MISPackageEvent):void{
}


//연결선 ToolTipMenu 관련 함수
private function registerTooltipLinkMenu():void{
	linkToolTipMenu.addEventListener(ToolTipMenuEvent.PROPERTY, toolTipLinkMenuProperty);
	linkToolTipMenu.addEventListener(ToolTipMenuEvent.REMOVE, toolTipLinkRemove);
}

private function toolTipLinkMenuProperty(e:ToolTipMenuEvent):void{
	propertyPop(diagramEditorPropertyStage);
	linkToolTipMenu.close();
}

private function toolTipLinkRemove(e:ToolTipMenuEvent):void{
	deMain.clearSelection();
	Alert.show("삭제 하시겠습니까?", "", 3, this, 
		function removeExe(event:CloseEvent):void{
			if (event.detail==Alert.YES){
				deMain.execute(new LinkDeleteCommand(linkToolTipMenu.link));
			}
		});
	linkToolTipMenu.close();
}

private function allToolTipMenuDisable(toolTipMenu:Container):void{
	if(!(toolTipMenu is ActivityToolTipMenu)){
		activityToolTipMenu.close();
	}
	if(!(toolTipMenu is LaneToolTipMenu)){
		laneToolTipMenu.close();
	}
	if(!(toolTipMenu is ProcessToolTipMenu)){
		processToolTipMenu.close();
	}
	if(!(toolTipMenu is SingleWorkToolTipMenu)){
		singleWorkToolTipMenu.close();
	}
	if(!(toolTipMenu is PackageFormToolTipMenu)){
		packageFormToolTipMenu.close();
	}
	if(!(toolTipMenu is DiagramFormToolTipMenu)){
		diagramFormToolTipMenu.close();
	}
	if(!(toolTipMenu is PackageToolTipMenu)){
		packageToolTipMenu.close();
	}
	if(!(toolTipMenu is LinkToolTipMenu)){
		linkToolTipMenu.close();
	}
}