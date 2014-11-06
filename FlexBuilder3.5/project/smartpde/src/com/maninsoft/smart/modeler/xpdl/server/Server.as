////////////////////////////////////////////////////////////////////////////////
//  Session.as
//  2008.02.01, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.server
{
	import com.maninsoft.smart.formeditor.model.SystemService;
	import com.maninsoft.smart.modeler.common.ObjectBase;
	import com.maninsoft.smart.modeler.xpdl.server.service.FindChildDeptService;
	import com.maninsoft.smart.modeler.xpdl.server.service.FindGroupsService;
	import com.maninsoft.smart.modeler.xpdl.server.service.FindUserByDeptService;
	import com.maninsoft.smart.modeler.xpdl.server.service.FindUserByGroupService;
	import com.maninsoft.smart.modeler.xpdl.server.service.GetApplicationServiceDefsService;
	import com.maninsoft.smart.modeler.xpdl.server.service.GetApprovalLineDefsService;
	import com.maninsoft.smart.modeler.xpdl.server.service.GetCategoryListService;
	import com.maninsoft.smart.modeler.xpdl.server.service.GetFormFieldListService;
	import com.maninsoft.smart.modeler.xpdl.server.service.GetFormListService;
	import com.maninsoft.smart.modeler.xpdl.server.service.GetFullPackageService;
	import com.maninsoft.smart.modeler.xpdl.server.service.GetPackageListService;
	import com.maninsoft.smart.modeler.xpdl.server.service.GetProcessInfoByPackageService;
	import com.maninsoft.smart.modeler.xpdl.server.service.GetRootDeptService;
	import com.maninsoft.smart.modeler.xpdl.server.service.GetSubProcessDiagramService;
	import com.maninsoft.smart.modeler.xpdl.server.service.GetSubProcessInstanceService;
	import com.maninsoft.smart.modeler.xpdl.server.service.GetSystemServiceDefsService;
	import com.maninsoft.smart.workbench.common.model.WorkPackage;
	
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.core.Application;
	
	/**
	 * 현재 모델러가 연결한 서버 및 세션 관련 정보 관리.
	 * 프로세스 리파지토리 클라이언트.
	 */
	public class Server extends ObjectBase {

		//----------------------------------------------------------------------
		// Class variables
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _serviceUrl: String;
		private var _userId: String;		
		private var _compId: String;		
		private var _packageId: String;
		private var _version: String;
		
		private var _taskForms: Array /* TaskForm */;
		private var _taskFormFields: Array /* TaskFormField */;
		private var _organization: Department;
		private var _approvalLines:Array;
		private var _systemServices:Array;
		private var _applicationServices:Array;
		
		private var _currentTaskForms: Array /* TaskForm */;
		private var _currentTaskFormFields: Array /* TaskFormField */;
		private var _currentOrganization: Department;
		private var _currentApprovalLines:Array;
		private var _currentSystemServices:Array;
		private var _currentApplicationServices:Array;
		private var _runtimeServiceUrl: String =  Application.application.parameters.serviceUrl + "smartworksV3/services/runtime/searchingService.jsp";


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function Server(serviceUrl: String, userId: String, compId:String, packageId: String, version: String) {
			super();
			
			_serviceUrl = serviceUrl;
			_userId = userId;
			_compId = compId;
			_packageId = packageId;
			_version = version;
		}

		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		public var process: ProcessInfo;
		
		/**
		 * 현재 에디팅중인 taskForms
		 */
		public function get taskForms(): Array {
			return _taskForms;
		}
		
		/**
		 * 현재 에디팅중인 taskFormFields
		 */
		public function get taskFormFields(): Array {
			return _taskFormFields;
		}
		
		/**
		 * 현재 에디팅중인 department
		 */
		public function get organization(): Department {
			return _organization;
		}
		
		/**
		 * 현재 에디팅중인 approvalLines
		 */
		public function get approvalLines(): Array {
			return _approvalLines;
		}
		
		/**
		 * 현재 에디팅중인 systemServices
		 */
		public function get systemServices(): Array {
			return _systemServices;
		}
		
		/**
		 * 현재 에디팅중인 applicationServices
		 */
		public function get applicationServices(): Array {
			return _applicationServices;
		}
		
		/**
		 * 현재 저장중인 taskForms
		 */
		public function get currentTaskForms(): Array {
			return _currentTaskForms;
		}
		
		/**
		 * 현재 저장중인 taskFormFields
		 */
		public function get currentTaskFormFields(): Array {
			return _currentTaskFormFields;
		}
		
		/**
		 * 현재 저장중인 department
		 */
		public function get currentOrganization(): Department {
			return _currentOrganization;
		}
		
		/**
		 * 현재 저장중인 approvalLines
		 */
		public function get currentApprovalLines(): Array {
			return _currentApprovalLines;
		}
		
		/**
		 * 현재 저장중인 systemServices
		 */
		public function get currentSystemServices(): Array {
			return _currentSystemServices;
		}
		
		/**
		 * 현재 저장중인 applicationServices
		 */
		public function get currentApplicationServices(): Array {
			return _currentApplicationServices;
		}
		
		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		
		/**
		 * 현재 지정된 리파지토리 서버에서 작업폼 및 작업폼 필드 목록을 가져온다.
		 * 일단, 모든 목록을 가져온다. 모델러에서 리파지토리 관련 설계가 필요하다.
		 */
		public function load(resultFunc:Function = null, formId:String = null): void {
			loadTaskForms(resultFunc, formId);
			loadOrganization();
		}
		
		/**
		 * formId 로 form 을 찾는다.
		 */
		public function findForm(formId: String): TaskForm {
			for each (var form: TaskForm in _taskForms) {
				if (form.formId == formId)
					return form;
			}
			
			return null;
		}
		
		/**
		 * formId 로 form 을 찾는다.
		 */
		public function findWork(workId: String): WorkPackage {
			return null;
		}
		
		public function getFormName(formId: String): String {
			for each (var form: TaskForm in _taskForms) {
				if (form.formId == formId)
					return form.name;
			}
			
			return "";
		}
		
		/**
		 * formId 폼에 속한 폼필드 목록을 리턴한다.
		 */
		public function getTaskFormFields(formId: String): Array {
			var flds: Array = [];
		
			if (taskFormFields) {
				for each (var fld: TaskFormField in taskFormFields) {
					if (fld.formId == formId) {
						flds.push(fld);
					}	
				}
			}
			
			return flds;
		}
		
		/**
		 * approvalLineId 로  approvalLine 을 찾는다.
		 */
		public function findApprovalLine(approvalLineId: String): ApprovalLine {
			for each (var approvalLine:ApprovalLine in this._approvalLines) {
				if (approvalLine.id == approvalLineId)
					return approvalLine;
			}
			
			return null;
		}
		
		/**
		 * systemServiceId 로  systemService 을 찾는다.
		 */
		public function findSystemService(systemServiceId: String): SystemService {
			for each (var systemService: SystemService in this._systemServices) {
				if (systemService.id == systemServiceId)
					return systemService;
			}
			
			return null;
		}
		
		/**
		 * applicationServiceId 로  applicationService 을 찾는다.
		 */
		public function findApplicationService(applicationServiceId: String): ApplicationService{
			for each (var applicationService: ApplicationService in this._applicationServices) {
				if (applicationService.id == applicationServiceId)
					return applicationService;
			}
			
			return null;
		}
		
		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		
		public function loadDeptChildren(dept: Department): void {
			dept.clearChildren();

			var svc: FindUserByDeptService = new FindUserByDeptService();
			
			svc.serviceUrl = getOrgServiceUrl();
			svc.compId = _compId;
			svc.userId = _userId;
			svc.deptId = dept.id;
			svc.data = this;
			
			svc.resultHandler = function (svc: FindUserByDeptService): void {
				dept.addItems(svc.users);
				loadChildDepts(dept);
			}
			svc.send();
		}

		public function loadChildDepts(dept: Department): void {
			var svc: FindChildDeptService = new FindChildDeptService();
			
			svc.serviceUrl = getOrgServiceUrl();
			svc.compId = _compId;
			svc.userId = _userId;
			svc.parentId = dept.id;
			svc.data = this;
			
			svc.resultHandler = function (svc: FindChildDeptService): void {
				dept.addItems(svc.depts);
				dept.loaded = true;
				dispatchEvent(new Event("deptChildrenLoaded"));
			}
			
			svc.send();
		}
		
		public function loadGroupChildren(group: Group): void {
			group.clearChildren();

			var svc: FindUserByGroupService = new FindUserByGroupService();
			
			svc.serviceUrl = getGroupServiceUrl();
			svc.compId = _compId;
			svc.userId = _userId;
			svc.groupId = group.id;
			svc.data = this;
			
			svc.resultHandler = function (svc: FindUserByGroupService): void {
				group.addItems(svc.users);
				group.loaded = true;
				dispatchEvent(new Event("groupChildrenLoaded"));
			}
			svc.send();
		}

		public function loadChildGroups(group: Group): void {
			var svc: FindGroupsService = new FindGroupsService();
			svc.serviceUrl = getGroupServiceUrl();
			svc.compId = _compId;
			svc.userId = _userId;
			svc.data = this;
			
			svc.resultHandler = function (svc: FindGroupsService): void {
				group.addItems(svc.groups);
				group.loaded = true;
				dispatchEvent(new Event("groupChildrenLoaded"));
			}
			
			svc.send();
		}
		
		public function createForm(): void {
		}
		
		public function deleteForm(): void {
		}

		public function refreshForms(): void {
			loadTaskForms();
		}
		
		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		public function loadTaskForms(resultFunc: Function = null, formId: String = null): void {
			var svc: GetFormListService = new GetFormListService();
			
			svc.serviceUrl = _serviceUrl;
			svc.compId = _compId;
			svc.userId = _userId;		
			svc.packageId = _packageId;	
			svc.version = _version;
			svc.data = this;
			
			svc.resultHandler = function (svc: GetFormListService): void {
				var server: Server = svc.data as Server;
				server._taskForms = svc.forms;
				if (resultFunc != null)
					resultFunc(svc.forms, formId);
				loadTaskFormFields();
			}
			
			svc.send();
		}
		
		public function loadTaskFormFields(): void {
			var svc: GetFormFieldListService = new GetFormFieldListService();
			
			svc.serviceUrl = _serviceUrl;
			svc.compId = _compId;
			svc.userId = _userId;		
			svc.packageId = _packageId;	
			svc.version = _version;
			svc.data = this;
			
			svc.resultHandler = function (svc: GetFormFieldListService): void {
				var server: Server = svc.data as Server;
				server._taskFormFields = svc.fields;
			}
			
			svc.send();
		}
		
		public function loadOrganization(): void {

			var svc: FindChildDeptService = new FindChildDeptService();
			
			svc.serviceUrl = getOrgServiceUrl();
			svc.compId = _compId;
			svc.userId = _userId;
			svc.parentId = "root";
			svc.data = this;
			svc.resultHandler = function (svc: FindChildDeptService): void {
				var server: Server = svc.data as Server;
				server._organization = svc.depts[0] as Department;
				dispatchEvent(new Event("serverLoaded"));
			}
			
			svc.send();
		}
		
		public function getApprovalLines(resultFunction:Function=null): void {

			var svc: GetApprovalLineDefsService = new GetApprovalLineDefsService();
			
			svc.serviceUrl = _serviceUrl;
			svc.compId = _compId;
			svc.userId = _userId;
			svc.data = this;
			svc.resultHandler = function (svc: GetApprovalLineDefsService): void {
				var server: Server = svc.data as Server;
				server._approvalLines = svc.approvalLines;
				if(resultFunction!=null) resultFunction();
			}
			
			svc.send();
		}
		
		public function getSystemServices(resultFunction:Function=null): void {

			var svc: GetSystemServiceDefsService = new GetSystemServiceDefsService();
			
			svc.serviceUrl = _serviceUrl;
			svc.compId = _compId;
			svc.userId = _userId;
			svc.data = this;
			svc.resultHandler = function (svc: GetSystemServiceDefsService): void {
				var server: Server = svc.data as Server;
				server._systemServices = svc.systemServices;
				if(resultFunction!=null) resultFunction();
				dispatchEvent(new Event("systemServicesLoaded"));
			}
			
			svc.send();
		}
		
		public function getApplicationServices(resultFunction:Function=null): void {

			var svc: GetApplicationServiceDefsService = new GetApplicationServiceDefsService();
			
			svc.serviceUrl = _serviceUrl;
			svc.compId = _compId;
			svc.userId = _userId;
			svc.data = this;
			svc.resultHandler = function (svc: GetApplicationServiceDefsService): void {
				var server: Server = svc.data as Server;
				server._applicationServices = svc.applicationServices;
				if(resultFunction!=null) resultFunction();
				dispatchEvent(new Event("applicationServicesLoaded"));
			}
			
			svc.send();
		}
		
		public function getCategoryList(parentId:String, resultCallback:Function): void {

			var svc: GetCategoryListService = new GetCategoryListService(parentId);
			
			svc.serviceUrl = _serviceUrl;
			svc.compId = _compId;
			svc.userId = _userId;
			svc.compId = _compId;
			svc.data = this;
			svc.resultHandler = function (svc: GetCategoryListService): void {
				resultCallback(svc);
			}
			svc.send();
		}
		
		public function getPackageList(parentId:String, resultCallback:Function): void {

			var svc: GetPackageListService = new GetPackageListService(parentId);
			
			svc.serviceUrl = _serviceUrl;
			svc.compId = _compId;
			svc.userId = _userId;
			svc.compId = _compId;
			svc.data = this;
			svc.resultHandler = function (svc: GetPackageListService): void {
				resultCallback(svc);
			}
			svc.send();
		}
		
		public function getFullPackage(packageId:String, version:String, resultCallback:Function): void {

			var svc: GetFullPackageService = new GetFullPackageService(packageId, version);
			
			svc.serviceUrl = _serviceUrl;
			svc.compId = _compId;
			svc.userId = _userId;
			svc.compId = _compId;
			svc.data = this;
			svc.resultHandler = function (svc: GetFullPackageService): void {
				resultCallback(svc);
			}
			svc.send();
		}
		
		public function getProcessInfoByPackage(packageId:String, version:String, resultCallback:Function): void {

			var svc: GetProcessInfoByPackageService = new GetProcessInfoByPackageService();
			
			svc.serviceUrl = _serviceUrl;
			svc.compId = _compId;
			svc.userId = _userId;
			svc.packageId = packageId;
			svc.version = version;
			svc.data = this;
			svc.resultHandler = function (svc: GetProcessInfoByPackageService): void {
				resultCallback(svc);
			}
			svc.send();
		}
		
		public function getTaskForms(packageId:String, packageVersion:String, resultFunc:Function): void {
			var svc: GetFormListService = new GetFormListService();
			
			svc.serviceUrl = _serviceUrl;
			svc.compId = _compId;
			svc.userId = _userId;		
			svc.packageId = packageId;	
			svc.version = packageVersion;
			svc.data = this;
			
			svc.resultHandler = function (svc: GetFormListService): void {
				resultFunc(svc);
			}			
			svc.send();
		}
		
		public function getSubProcessDiagram(processId:String, version:String, resultFunc:Function): void {
			var svc: GetSubProcessDiagramService = new GetSubProcessDiagramService();
			
			svc.serviceUrl = _serviceUrl;
			svc.compId = _compId;
			svc.userId = _userId;		
			svc.processId = processId;	
			svc.version = version;
			svc.data = this;
			
			svc.resultHandler = function (svc: GetSubProcessDiagramService): void {
				resultFunc(svc);
			}			
			svc.send();
		}
		
		public function getSubProcessInstance(subProcessInstId:String, resultFunc:Function): void {
			var svc: GetSubProcessInstanceService = new GetSubProcessInstanceService();
			
			svc.serviceUrl = _runtimeServiceUrl;
			svc.compId = _compId;
			svc.userId = _userId;		
			svc.prcInstId = subProcessInstId;	
			svc.data = this;
			
			svc.resultHandler = function (svc: GetSubProcessInstanceService): void {
				resultFunc(svc);
			}			
			svc.send();
		}
		
		public function currentLoadTaskForms(): void {
			var svc: GetFormListService = new GetFormListService();
			svc.serviceUrl = _serviceUrl;
			svc.compId = _compId;
			svc.userId = _userId;		
			svc.packageId = _packageId;	
			svc.version = _version;
			svc.data = this;
			svc.resultHandler = function (svc: GetFormListService): void {
				var server: Server = svc.data as Server;
				server._currentTaskForms = svc.forms;
			}
			svc.send();
		}
		
		public function currentLoadTaskFormFields(): void {
			var svc: GetFormFieldListService = new GetFormFieldListService();
			svc.serviceUrl = _serviceUrl;
			svc.compId = _compId;
			svc.userId = _userId;		
			svc.packageId = _packageId;	
			svc.version = _version;
			svc.data = this;
			svc.resultHandler = function (svc: GetFormFieldListService): void {
				var server: Server = svc.data as Server;
				server._currentTaskFormFields = svc.fields;
			}
			svc.send();
		}
		
		public function currentLoadOrganization(): void {
			var svc: GetRootDeptService = new GetRootDeptService();
			svc.serviceUrl = getOrgServiceUrl();
			svc.compId = _compId;
			svc.userId = _userId;
			svc.data = this;
			svc.resultHandler = function (svc: GetRootDeptService): void {
				var server: Server = svc.data as Server;
				server._currentOrganization = svc.dept;
			}
			svc.send();
		}
		
		private function getOrgServiceUrl(): String {
			var url: String = _serviceUrl;
			var idx: int = url.indexOf("/builder");
			url = url.substr(0, idx) + "/common/organizationService.jsp";
			return url;
		}
		
		private function getGroupServiceUrl(): String {
			var url: String = _serviceUrl;
			var idx: int = url.indexOf("/builder");
			url = url.substr(0, idx) + "/common/groupService.jsp";
			return url;
		}
	}
}