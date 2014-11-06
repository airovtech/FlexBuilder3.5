////////////////////////////////////////////////////////////////////////////////
//  TaskApplication.as
//  2007.12.20, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model
{
	import com.maninsoft.smart.formeditor.model.ActualParameter;
	import com.maninsoft.smart.formeditor.model.ActualParameters;
	import com.maninsoft.smart.modeler.model.DiagramObject;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.model.base.ActivityTypes;
	import com.maninsoft.smart.modeler.xpdl.model.base.Task;
	import com.maninsoft.smart.modeler.xpdl.model.process.DataField;
	import com.maninsoft.smart.modeler.xpdl.model.process.FormalParameter;
	import com.maninsoft.smart.modeler.xpdl.property.ActualParametersPropertyInfo;
	import com.maninsoft.smart.modeler.xpdl.property.ApplicationIdPropertyInfo;
	import com.maninsoft.smart.modeler.xpdl.property.ApprovalLinePropertyInfo;
	import com.maninsoft.smart.modeler.xpdl.property.FieldIdPropertyInfo;
	import com.maninsoft.smart.modeler.xpdl.property.FormIdPropertyInfo;
	import com.maninsoft.smart.modeler.xpdl.property.PerformerPropertyInfo;
	import com.maninsoft.smart.modeler.xpdl.server.ApplicationService;
	import com.maninsoft.smart.modeler.xpdl.server.ApprovalLine;
	import com.maninsoft.smart.modeler.xpdl.server.TaskForm;
	import com.maninsoft.smart.modeler.xpdl.server.TaskFormField;
	import com.maninsoft.smart.modeler.xpdl.server.User;
	import com.maninsoft.smart.workbench.common.property.MeanTimePropertyInfo;
	
	import mx.resources.ResourceManager;
	
	/**
	 * XPDL TaskApplication Task
	 */
	public class TaskApplication extends Task {
		
		//----------------------------------------------------------------------
		// Property consts
		//----------------------------------------------------------------------
		public static const PROP_APPLICATION_ID		: String = "prop.applicationId";
		public static const PROP_ACTUAL_PARAMETERS	: String = "prop.actualParameters";
		public static const PROP_FORMID				: String = "prop.formId";
		public static const PROP_FORMVERSION		: String = "prop.formVersion";
		public static const PROP_SUBJECT_FIELDID	: String = "prop.subjectFieldId";
		public static const PROP_MEANTIME			: String = "prop.meanTime";
		public static const PROP_PASSEDTIME			: String = "prop.passedTime";
		public static const PROP_APPROVALLINE		: String = "prop.approvalLine";

		public static const PROP_APPLICATION_SERVICE: String = "prop.applicationService";
		
		public static const SYSTEM_APPLICATION_ID	: String = "WorkListManager";	
		public static const SYSTEM_FORM_ID			: String = "SYSTEMFORM";
		public static var SYSTEM_FORM_NAME			: String = ResourceManager.getInstance().getString("ProcessEditorETC", "defaultFormText");
		
		public static const USERTASKTYPE_NORMAL		: String = "normal";
		public static const USERTASKTYPE_APPROVAL	: String = "approval";
		public static const DEFAULT_MEANTIME		: String = "30";
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		/** XPDL TaskApplication id */
		private var _isCustomForm:Boolean = false;
		private var _taskId: String = "";
		private var _appId: String = SYSTEM_APPLICATION_ID;
		private var _appName: String;
		private var _applicationService: ApplicationService;
		private var _actualParameters: ActualParameters;

		private var _formId: String = SYSTEM_FORM_ID;
		private var _formName: String = SYSTEM_FORM_NAME;
		private var _formVersion: String = "0";
		private var _subjectFieldId : String = "";
		private var _subjectFieldName : String ="";
		private var _userTaskType:String = USERTASKTYPE_NORMAL;

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/**
		 * Construtor 
		 */
		public function TaskApplication() {
			super();
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		public function get isCustomForm(): Boolean{
			return _isCustomForm;
		}
		
		public function set isCustomForm(value:Boolean):void{
			if(_isCustomForm == value) return;
			_isCustomForm = value;
			if(_isCustomForm == true){
				appId = ApplicationService.EMPTY_APPLICATION_SERVICE;
				appName = resourceManager.getString("ProcessEditorETC", "emptyApplicationServiceText");
				_formId = null;
				formName = null;
				formVersion = null;
				this.name =  resourceManager.getString("ProcessEditorETC", "taskApplicationText");
			}else{
				appId = SYSTEM_APPLICATION_ID;
				appName = null;
				formId = SYSTEM_FORM_ID;
				formName = SYSTEM_FORM_NAME;
				formVersion = "0";				
				this.name =  resourceManager.getString("ProcessEditorETC", "taskUserText");
			}
		}
		public function get taskId(): String {
			return _taskId;
		}
		
		public function get appId(): String {
			return _appId;
		}
		
		public function set appId(value: String): void {
			if(_appId == value) return;
			var oldVal: String = _appId;
			_appId = value;
			fireChangeEvent(PROP_APPLICATION_ID, oldVal);
		}

		public function get appName(): String{
			return _appName;
		}

		public function set appName(value: String):void{
			_appName = value;
		}
		
		public function get applicationService(): ApplicationService{
			return _applicationService;
		}
		
		public function set applicationService(value: ApplicationService):void{
			if(_applicationService == value) return;
			if(actualParameters && !_applicationService){
				this._applicationService = value;
				return;
			}

			this._applicationService = value;
			actualParameters = new ActualParameters();
			var actualParam:ActualParameter;
			for each(var editParam:FormalParameter in _applicationService.editParams){
				editParam.mode = FormalParameter.MODE_IN;
				actualParam = new ActualParameter();
				actualParam.editMode = resourceManager.getString("ProcessEditorETC", "editModeEditText");;
				actualParam.formalParameterId = editParam.id;
				actualParam.formalParameterName = editParam.label;
				actualParam.formalParameterType = editParam.dataType;
				actualParam.formalParameterMode = editParam.mode;
				actualParam.targetType = ActualParameter.TARGETTYPE_EXPRESSION;
				actualParam.targetTypeName = ActualParameter.getTargetTypeNameByValue(actualParam.targetType);
				actualParam.targetValueType = ActualParameter.TARGETVALUETYPE_VALUE;
				actualParam.targetValueTypeName = ActualParameter.getTargetValueTypeNameByValue(actualParam.targetValueType);						
				actualParameters.addActualParameter(actualParam);
			}
			for each(var viewParam:FormalParameter in _applicationService.viewParams){
				viewParam.mode = FormalParameter.MODE_IN;
				actualParam = new ActualParameter();
				actualParam.editMode = resourceManager.getString("ProcessEditorETC", "editModeViewText");
				actualParam.formalParameterId = viewParam.id;
				actualParam.formalParameterName = viewParam.label;
				actualParam.formalParameterType = viewParam.dataType;
				actualParam.formalParameterMode = viewParam.mode;
				actualParam.targetType = ActualParameter.TARGETTYPE_EXPRESSION;
				actualParam.targetTypeName = ActualParameter.getTargetTypeNameByValue(actualParam.targetType);
				actualParam.targetValueType = ActualParameter.TARGETVALUETYPE_VALUE;
				actualParam.targetValueTypeName = ActualParameter.getTargetValueTypeNameByValue(actualParam.targetValueType);						
				actualParameters.addActualParameter(actualParam);
			}
			for each(var returnParam:FormalParameter in _applicationService.returnParams){
				returnParam.mode = FormalParameter.MODE_OUT;
				actualParam = new ActualParameter();
				actualParam.editMode = null;
				actualParam.formalParameterId = returnParam.id;
				actualParam.formalParameterName = returnParam.label;
				actualParam.formalParameterType = returnParam.dataType;
				actualParam.formalParameterMode = returnParam.mode;
				actualParam.targetType = ActualParameter.TARGETTYPE_EXPRESSION;
				actualParam.targetTypeName = ActualParameter.getTargetTypeNameByValue(actualParam.targetType);
				actualParam.targetValueType = ActualParameter.TARGETVALUETYPE_VALUE;
				actualParam.targetValueTypeName = ActualParameter.getTargetValueTypeNameByValue(actualParam.targetValueType);						
				actualParameters.addActualParameter(actualParam);
			}
		}
		
		public function get actualParameters(): ActualParameters{
			return _actualParameters;
		}
		
		public function set actualParameters(value: ActualParameters): void{
			if(_actualParameters == value) return;
			_actualParameters = value;
		}
		
		public function get formId(): String {
			return _formId;
		}

		public function set formId(value: String): void {
			if(value==null || value=="null"){
				value = "";
			}

			var oldVal: String = formId;
			_formId = value;
				
			if (xpdlDiagram && xpdlDiagram.server) {
				_formName = xpdlDiagram.server.getFormName(_formId);
				if (!_formName) { _formName = formName }
				dataFields = createDataFields();
			}
				
			if(SYSTEM_FORM_ID == _formId){
				_formName = SYSTEM_FORM_NAME;
			}
				
			//form타입을 일괄로 정리해준다.
			if(xpdlDiagram){
				var acts:Array = this.xpdlDiagram.activities;
				var taskforms:Array = this.xpdlDiagram.server.taskForms;
				for each (var taskform:TaskForm in taskforms) {
					taskform.type = TaskForm.NONE_FORM;
				}
				
				for each (var act:Activity in acts) {
					if(act is TaskApplication){
						var taskApp:TaskApplication = act as TaskApplication;
						var tf:TaskForm = this.xpdlDiagram.server.findForm(taskApp._formId);
						if(tf){
							tf.type = TaskForm.PROCESS_FORM;
						}
					}
				}
			}
			fireChangeEvent(PROP_FORMID, oldVal);
		}
		
		public function get formName(): String {
			return _formName;
		}
		
		public function set formName(val:String): void {
			this._formName = val;
		}		
		
		public function get subjectFieldId(): String {
			return _subjectFieldId;
		}
		
		public function set subjectFieldId(val:String): void {
			this._subjectFieldId = val;
		}		
		
		public function get subjectFieldName(): String {
			return _subjectFieldName;
		}
		
		public function set subjectFieldName(val:String): void {
			this._subjectFieldName = val;
		}		
		
		public function get userTaskType(): String {
			return _userTaskType;
		}
		
		public function set userTaskType(val:String): void {
			this._userTaskType = val;
		}		
		
		/**
		 * formVersion
		 */
		public function get formVersion(): String {
			return _formVersion;
		}
		
		public function set formVersion(value: String): void {
			if (value != _formVersion) {
				var oldVal: String = _formVersion;
				_formVersion = value;

				fireChangeEvent(PROP_FORMVERSION, oldVal);
			}				
		}
		
		private var _meanTime:String = DEFAULT_MEANTIME;
		
		public function get meanTimeInHours():Number{
			return Number(_meanTime)/60;
		}
		
		public function get meanTime():String {
			return _meanTime;
		}
		public function set meanTime(value:String):void {
			if (_meanTime == value)
				return;
			_meanTime = value;
			fireChangeEvent(PROP_MEANTIME, !value);
		}

		private var _passedTime:String="-1";
		
		public function get passedTimeInHours():Number{
			return Number(_passedTime)/60;
		}
		
		public function get passedTime():String {
			return _passedTime;
		}
		public function set passedTime(value:String):void {
			if (_passedTime == value)
				return;
			_passedTime = value;
			fireChangeEvent(PROP_PASSEDTIME, !value);
		}

		private var _approvalLine:String = ApprovalLine.EMPTY_APPROVAL;
		public function get approvalLine():String {
			if(_approvalLine)
				return _approvalLine;
			else
				return ApprovalLine.EMPTY_APPROVAL;
		}
		public function set approvalLine(value:String):void {
			if (_approvalLine == value)
				return;
			_approvalLine = value;
			if(_approvalLine)
				_userTaskType = USERTASKTYPE_APPROVAL;
			else
				_userTaskType = USERTASKTYPE_NORMAL;
			fireChangeEvent(PROP_APPROVALLINE, !value);
		}
		
		private var _approvalLineName:String = resourceManager.getString("ProcessEditorETC", "emptyApprovalText");
		public function get approvalLineName():String {
			if(_approvalLineName){
				if(_approvalLine){
					return _approvalLineName;
				}
			}
			return resourceManager.getString("ProcessEditorETC", "emptyApprovalText");
		}
		public function set approvalLineName(value:String):void {
			if (_approvalLineName == value)
				return;
			_approvalLineName = value;
		}
		
		//----------------------------------------------------------------------
		// IXPDLElement
		//----------------------------------------------------------------------
		
		override protected function doRead(src: XML): void {
			var xml: XML = src._ns::Implementation._ns::Task._ns::TaskApplication[0];
			
			var value:String = xml.@IsCustomForm;
			_isCustomForm = (value && value=="true") ? true:false;
			_taskId = xml.@TaskId;
			_appId = xml.@Id;
			if(_isCustomForm == true)
				_appName = xml.@Name;
			else
				_formId = xml.@Name;
			_formName = xml.@FormName;
			_formVersion = xml.@Version;
			_userTaskType = xml.@UserTaskType;
			_subjectFieldId = xml.@SubjectFieldId;
			_subjectFieldName = xml.@SubjectFieldName;
			_meanTime = xml.@MeanTime;
			if(!_meanTime || _meanTime == "null" ) _meanTime = DEFAULT_MEANTIME;
			_passedTime = xml.@PassedTime;
			if(!_passedTime || _passedTime == "null" ) _passedTime = "-1"; 
			_approvalLine = xml.@ApprovalLine;
			_approvalLineName = xml.@ApprovalLineName;
			if(_isCustomForm == true){
				_formId = null;
				formName = null;
				formVersion = null;
				xml = src._ns::Implementation._ns::Task._ns::TaskApplication[0]._ns::ActualParameters[0];
				actualParameters = ActualParameters.parseXML(xml)
			}

			super.doRead(src);
		}

		override protected function doWrite(dst: XML): void {
			dst._ns::Implementation._ns::Task._ns::TaskApplication = "";
			var xml: XML = dst._ns::Implementation._ns::Task._ns::TaskApplication[0];
			
			xml.@IsCustomForm = _isCustomForm;
			xml.@Id = _appId;
			if(_isCustomForm)
				xml.@Name = _appName;
			else
				xml.@Name = _formId;
			xml.@FormName = _formName;
			xml.@Version = _formVersion;
			xml.@UserTaskType = _userTaskType;
			xml.@SubjectFieldId = _subjectFieldId;
			xml.@SubjectFieldName = _subjectFieldName;
			xml.@MeanTime = _meanTime;
			xml.@ApprovalLine = _approvalLine;
			xml.@ApprovalLineName = _approvalLineName;

			if(_isCustomForm == true){
				dst._ns::Implementation._ns::Task._ns::TaskApplication._ns::ActualParameters = "";
				if (_actualParameters) {
					xml = dst._ns::Implementation._ns::Task._ns::TaskApplication._ns::ActualParameters[0];
					_actualParameters.toXML(xml);
					for (var i:int = 0; i < _actualParameters.actualParameters.length; i++) {
						dst._ns::Implementation._ns::Task._ns::TaskApplication[0]._ns::ActualParameters._ns::ActualParameter[i] = "";
						xml = dst._ns::Implementation._ns::Task._ns::TaskApplication[0]._ns::ActualParameters._ns::ActualParameter[i];
						ActualParameter(_actualParameters.actualParameters[i]).toXML(xml);
					}
				}
			}

			super.doWrite(dst);
		}

		override public function get defaultName(): String {
			if(isCustomForm==true)
				return resourceManager.getString("ProcessEditorETC", "taskApplicationText");
			else
				return resourceManager.getString("ProcessEditorETC", "taskUserText");
		}

		//----------------------------------------------------------------------
		// Overriden properties
		//----------------------------------------------------------------------

		override public function get activityType(): String {
			return userTaskType && userTaskType == USERTASKTYPE_APPROVAL? ActivityTypes.TASK_APPROVAL:ActivityTypes.TASK_APPLICATION;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function assign(source: DiagramObject): void {
			super.assign(source);
			
			if (source is TaskApplication) {
				var tmp:TaskApplication = source as TaskApplication;
				this._isCustomForm = tmp._isCustomForm;
				this._appId = tmp._appId;
				this._appName = tmp._appName
				this._applicationService = tmp._applicationService;
				this._actualParameters = tmp._actualParameters;
				this._formId = tmp._formId;
				this._formName = tmp._formName;
				this._formVersion = tmp._formVersion;
				this._userTaskType = tmp._userTaskType;
				this._subjectFieldId = tmp._subjectFieldId;
				this._subjectFieldName = tmp._subjectFieldName;
				this._meanTime = tmp._meanTime;
				this._approvalLine = tmp._approvalLine;
				this._approvalLineName = tmp._approvalLineName;
			}
		}

		/**
		 * 프로퍼티 소스가 제공하는 IPropertyInfo 목록
		 */
		override protected function createPropertyInfos(): Array {
			var props: Array = super.createPropertyInfos();
			
			if(isCustomForm == true){
				return props.concat(
					new PerformerPropertyInfo(PROP_PERFORMER, resourceManager.getString("ProcessEditorETC", "performerText"), null, null, false),
					new ApplicationIdPropertyInfo(PROP_APPLICATION_ID, resourceManager.getString("ProcessEditorETC", "applicationServiceText"), null, null, false),
					new MeanTimePropertyInfo(PROP_MEANTIME, resourceManager.getString("ProcessEditorETC", "meanTimeText")),
					new ActualParametersPropertyInfo(PROP_ACTUAL_PARAMETERS, resourceManager.getString("ProcessEditorETC", "actualParametersText"), null, null, false)
				);
			}else if(startActivity){
				return props.concat(
					new PerformerPropertyInfo(PROP_PERFORMER, resourceManager.getString("ProcessEditorETC", "performerText"), null, null, false),
					new FormIdPropertyInfo(PROP_FORMID, resourceManager.getString("ProcessEditorETC", "workFormText"), null, null, false),
					new FieldIdPropertyInfo(PROP_SUBJECT_FIELDID, resourceManager.getString("ProcessEditorETC", "subjectFieldIdText")),
					new MeanTimePropertyInfo(PROP_MEANTIME, resourceManager.getString("ProcessEditorETC", "meanTimeText")),
					new ApprovalLinePropertyInfo(PROP_APPROVALLINE, resourceManager.getString("ProcessEditorETC", "approvalLineText"), null, null, false)
				);
			}else{
				return props.concat(
					new PerformerPropertyInfo(PROP_PERFORMER, resourceManager.getString("ProcessEditorETC", "performerText"), null, null, false),
					new FormIdPropertyInfo(PROP_FORMID, resourceManager.getString("ProcessEditorETC", "workFormText"), null, null, false),
					new MeanTimePropertyInfo(PROP_MEANTIME, resourceManager.getString("ProcessEditorETC", "meanTimeText")),
					new ApprovalLinePropertyInfo(PROP_APPROVALLINE, resourceManager.getString("ProcessEditorETC", "approvalLineText"), null, null, false)
				);
			}
		}
		
		/**
		 * id 에 해당하는 프로퍼티의 현재 값을 리턴
		 */
		override public function getPropertyValue(id: String): Object {
			switch (id) {
				case PROP_APPLICATION_ID:
					return appName;
				
				case PROP_ACTUAL_PARAMETERS:
					if(actualParameters)
						return actualParameters.toString();
					return null;
					
				case PROP_FORMID: 
					return (formName&&formName!="null")?formName:TaskForm.EMPTY_FORM_NAME;
					
				case PROP_FORMVERSION:
					return formVersion;

				case PROP_PERFORMER: 
					return (performerName&&performer!="null")?performerName:User.EMPTY_USER_NAME;

				case PROP_SUBJECT_FIELDID: 
					return (subjectFieldName&&subjectFieldName!="null")?subjectFieldName:TaskFormField.EMPTY_FIELD_NAME;
					
				case PROP_MEANTIME: 
					return meanTime;

				case PROP_APPROVALLINE:
					return approvalLineName;

				default:
					return super.getPropertyValue(id);
			}
		}
		
		/**
		 * id 에 해당하는 프로퍼티의 값을 설정
		 */
		override public function setPropertyValue(id: String, value: Object): void {
			switch (id) {
				case PROP_APPLICATION_ID:
					appId = value.toString();
					break;
					
				case PROP_FORMID:
					if(value && (value.toString() == TaskForm.EMPTY_FORM_NAME))
						formId = null;
					else
						formId = value.toString();
					break;
					
				case PROP_PERFORMER:
					if(value && (value.toString() == User.EMPTY_USER_NAME))
						performer = null;
					else
						performer = value.toString();
					break;
				
				case PROP_SUBJECT_FIELDID:
					if(value && (value.toString() == TaskFormField.EMPTY_FIELD_NAME))
						subjectFieldId = null;
					else
						subjectFieldId = value.toString();
					break;
					
				case PROP_MEANTIME: 
					meanTime = value.toString();
					break;
					
				case PROP_APPROVALLINE: 
					if(value && (value.toString() == ApprovalLine.EMPTY_APPROVAL))
						approvalLine = "";
					else
						approvalLine = value.toString();
					break;
					
				default:
					super.setPropertyValue(id, value);
					break;
			}
		}


		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------

		private function createDataFields(): Array {
			var flds: Array = [];

			if (xpdlDiagram && xpdlDiagram.server) {
				var formFlds: Array = xpdlDiagram.server.getTaskFormFields(formId);
				
				for each (var fld: TaskFormField in formFlds) {
					var dataFld: DataField = new DataField(this);
					
					dataFld.id = fld.id;
					dataFld.name = fld.name;
					dataFld.dataType = fld.type;
					dataFld.initialValue = "";
					dataFld.isArray = false;
					
					flds.push(dataFld);
				}
			}
				
			return flds;
		}
	}
}