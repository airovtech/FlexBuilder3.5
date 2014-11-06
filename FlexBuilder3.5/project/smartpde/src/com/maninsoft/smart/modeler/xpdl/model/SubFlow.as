////////////////////////////////////////////////////////////////////////////////
//  SubFlow.as
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
	import com.maninsoft.smart.modeler.xpdl.model.base.Implementation;
	import com.maninsoft.smart.modeler.xpdl.model.process.FormalParameter;
	import com.maninsoft.smart.modeler.xpdl.model.process.WorkflowProcess;
	import com.maninsoft.smart.modeler.xpdl.property.ActualParametersPropertyInfo;
	import com.maninsoft.smart.modeler.xpdl.property.SubFlowExecutionPropertyInfo;
	import com.maninsoft.smart.modeler.xpdl.property.SubProcessIdPropertyInfo;
	import com.maninsoft.smart.modeler.xpdl.server.ProcessInfo;
	import com.maninsoft.smart.modeler.xpdl.syntax.Problem;
	
	/**
	 * XPDL SubFlow implementation
	 */
	public class SubFlow extends Implementation {
		
		//----------------------------------------------------------------------
		// Property consts
		//----------------------------------------------------------------------
		
		public static const PROP_SUBPROCESS_ID	: String = "prop.subProcessId";
		public static const PROP_SUBPROCESS_INST_ID	: String = "prop.subProcessInstId";
		public static const PROP_SUBPROCESS		: String = "prop.subProcess";
		public static const PROP_EXECUTION		: String = "prop.execution";
		public static const PROP_VIEW			: String = "prop.view";
		public static const PROP_ACTUAL_PARAMETERS: String = "prop.actualParameters";
		
		public static const EXECUTION_ASYNCHR	: String = "ASYNCHR"
		public static const EXECUTION_SYNCHR	: String = "SYNCHR"
		
		public static const VIEW_COLLAPSED		: String = "COLLAPSED";
		public static const VIEW_EXPANDED		: String = "EXPANDED";

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _subProcessDiagram: XPDLDiagram;
		private var _subProcess: WorkflowProcess;
		private var _subProcessInstId: String;
		
		private var _subProcessId: String;
		private var _subProcessInfo: ProcessInfo;
		private var _execution: String = EXECUTION_SYNCHR;
		private var _subFlowView: String = VIEW_COLLAPSED;
		private var _startActivityId: String;
		private var _actualParameters: ActualParameters;

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/**
		 * Construtor 
		 */
		public function SubFlow() {
			super();

		}

		override protected function initDefaults():void{
			super.initDefaults();			
			this.name = this.defaultName;
		}
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		override public function get defaultName(): String {
			return resourceManager.getString("ProcessEditorETC", "subProcessText");
		}

		override public function get defaultWidth(): Number {
			return 100;
		}
		
		override public function get defaultHeight(): Number {
			return 40;
		}
		
		override public function get defaultFillColor(): uint {
			return 0xeff8ff;
		}
		
		override public function get defaultTextColor(): uint {
			return 0x666666;
		}

		override public function get defaultBorderColor(): uint {
			return 0xa0c4ce;
		}

		public function get execution(): String {
			return _execution;
		}
		
		public function set execution(value: String): void {
			_execution = value;
		}

		public function get subFlowView(): String {
			return _subFlowView;
		}
		
		public function set subFlowView(value: String): void {
			if(_subFlowView == value) return;
			var oldValue:String = _subFlowView;
			_subFlowView = value;
			fireChangeEvent(PROP_VIEW, oldValue);			
		}

		public function get startActivityId(): String {
			return _startActivityId;
		}
		
		public function set startActivityId(value: String): void {
			_startActivityId = value;
		}
		
		public function get subProcessDiagram(): XPDLDiagram{
			return _subProcessDiagram;
		}
		
		public function set subProcessDiagram(value: XPDLDiagram): void{
			if(_subProcessDiagram == value) return;
			
			if(actualParameters && !_subProcessDiagram){ 
				_subProcessDiagram = value;
				return;
			}
			_subProcessDiagram = value;
			actualParameters = new ActualParameters();
			for each(var param:FormalParameter in _subProcessDiagram.xpdlPackage.process.formalParameters){
				var actualParam:ActualParameter = new ActualParameter();
				if(param.mode != FormalParameter.MODE_OUT){
					actualParam.formalParameterId = param.id;
					actualParam.formalParameterName = param.id;
					actualParam.formalParameterType = param.dataType;
					actualParam.formalParameterMode = param.mode;
					actualParam.targetType = ActualParameter.TARGETTYPE_EXPRESSION;
					actualParam.targetTypeName = ActualParameter.getTargetTypeNameByValue(actualParam.targetType);
					actualParam.targetValueType = ActualParameter.TARGETVALUETYPE_VALUE;
					actualParam.targetValueTypeName = ActualParameter.getTargetValueTypeNameByValue(actualParam.targetValueType);						
				}else{
					actualParam.formalParameterId = param.id;
					actualParam.formalParameterName = param.id;
					actualParam.formalParameterType = param.dataType;
					actualParam.formalParameterMode = param.mode;
					actualParam.targetType = null;
					actualParam.targetTypeName = null;
					actualParam.targetValueType = null;
					actualParam.targetValueTypeName = null;	
				}
				actualParameters.addActualParameter(actualParam);
			}
		}
		
		public function set subProcess(value: WorkflowProcess):void{
			if(_subProcess == value) return;
			if(xpdlDiagram){
				if(_subProcess){
					for(var i:int=0; i<xpdlDiagram.xpdlPackage.processes.length-1;i++)
						if(xpdlDiagram.xpdlPackage.processes[i] == _subProcess)
							xpdlDiagram.xpdlPackage.processes.splice(i,1);
				}
				if(value){
					for(var j:int=0; j<xpdlDiagram.xpdlPackage.processes.length-1;j++)
						if(xpdlDiagram.xpdlPackage.processes[j] == _subProcess)
							break;
					if(j==xpdlDiagram.xpdlPackage.processes.length-1)
						xpdlDiagram.xpdlPackage.processes.splice(0, 0, value);
				}
			}
			_subProcess = value;
			fireChangeEvent(PROP_SUBPROCESS, null);			
		}
		
		public function get subProcess():WorkflowProcess{
			return _subProcess;
		}

		public function get subProcessId(): String{
			return _subProcessId;
		}
		
		public function set subProcessId(value:String): void{
			if(_subProcessId == value) return;
			_subProcessId = value;
		}
		
		public function get subProcessName(): String{
			if(subProcessInfo) return subProcessInfo.label;
			return null;
		}
		
		public function get subProcessInfo(): ProcessInfo{
			return _subProcessInfo;
		}
		
		public function set subProcessInfo(value: ProcessInfo): void{
			if(_subProcessInfo == value) return
			var oldValue:ProcessInfo = _subProcessInfo;
			_subProcessInfo = value;
			fireChangeEvent(PROP_SUBPROCESS_ID, oldValue);			
		}

		public function get subProcessInstId(): String{
			return _subProcessInstId;
		}
		
		public function set subProcessInstId(value: String): void{
			if(_subProcessInstId == value) return
			var oldValue:String = _subProcessInstId;
			_subProcessInstId = value;
			fireChangeEvent(PROP_SUBPROCESS_INST_ID, oldValue);			
		}

		public function get meanTimeInHours():Number{
			var meanTime: Number = 0;
			if(!subProcess) return meanTime;
			var arr:Array = subProcess.activities;
			for each (var activity:Activity in arr) {
				if(activity is TaskApplication){
					meanTime += (TaskApplication(activity).meanTimeInHours>0)?TaskApplication(activity).meanTimeInHours:0;
				}
			}
			return meanTime;
		}
		
		public function get passedTimeInHours():Number{
			var passedTime: Number = 0;
			if(!subProcess) return passedTime;
			var arr:Array = subProcess.activities;
			for each (var activity:Activity in arr) {
				if(activity is TaskApplication){
					passedTime += (TaskApplication(activity).passedTimeInHours>0)?TaskApplication(activity).passedTimeInHours:0;
				}
			}
			return passedTime;
		}
		
		public function get subProcessProblem(): Problem{
			if(!subProcess) return null;
			var arr:Array = subProcess.activities;
			for each (var activity:Activity in arr) {
				if(activity.problem){
					var newProblem: Problem = new Problem(activity.problem.source, activity.problem.label);
					newProblem.label = "[" + resourceManager.getString("ProcessEditorETC", "subProcessText") + "]" + activity.problem.label ;
					newProblem.message = "[" + resourceManager.getString("ProcessEditorETC", "subProcessText") + "]" + activity.problem.message; 
					newProblem.description = "[" + resourceManager.getString("ProcessEditorETC", "subProcessText") + "]" + activity.problem.description;
					return newProblem;
				}
			}
			return null;
		}

		public function get subProcessStatus():String{
			if(!subProcess) return null;
			return subProcess.status;
		}
		
		public function get actualParameters(): ActualParameters{
			return _actualParameters;
		}
		
		public function set actualParameters(value: ActualParameters):void{
			_actualParameters = value;
		}
		
		//----------------------------------------------------------------------
		// IXPDLElement
		//----------------------------------------------------------------------
		
		override protected function doRead(src: XML): void {
			var xml: XML = src._ns::Implementation._ns::SubFlow[0];
			
			var subProcessId:String = xml.@SubProcessId;
			var subProcessPackId:String = xml.@SubProcessPackId;
			var subProcessVer:String = xml.@SubProcessVer;
			var subProcessInstId:String = xml.@SubProcessInstId;
			if(subProcessPackId && subProcessVer){
				var processInfo:ProcessInfo = new ProcessInfo();
				processInfo.packageId = subProcessPackId;
				processInfo.version = subProcessVer;
				subProcessInfo = processInfo;
			}else{
				this.subProcessId = subProcessId; 
			}

			if(subProcessInstId){
				this.subProcessInstId = subProcessInstId;
			}
			
			_execution = xml.@Execution;

			xml = src._ns::Implementation._ns::SubFlow[0]._ns::ActualParameters[0];
			actualParameters = ActualParameters.parseXML(xml)

			super.doRead(src);
		}

		override protected function doWrite(dst: XML): void {
			dst._ns::Implementation._ns::SubFlow = "";
			var xml: XML = dst._ns::Implementation._ns::SubFlow[0];
			if(subProcessInfo){
				xml.@SubProcessPackId = subProcessInfo.packageId;
				xml.@SubProcessVer = subProcessInfo.version;
			}else{
				xml.@SubProcessId = subProcessId;
			}
			xml.@Execution = execution;

			dst._ns::Implementation._ns::SubFlow._ns::ActualParameters = "";
			if (_actualParameters) {
				xml = dst._ns::Implementation._ns::SubFlow._ns::ActualParameters[0];
				_actualParameters.toXML(xml);
				for (var i:int = 0; i < _actualParameters.actualParameters.length; i++) {
					dst._ns::Implementation._ns::SubFlow._ns::ActualParameters._ns::ActualParameter[i] = "";
					xml = dst._ns::Implementation._ns::SubFlow._ns::ActualParameters._ns::ActualParameter[i];
					ActualParameter(_actualParameters.actualParameters[i]).toXML(xml);
				}
			}

			super.doWrite(dst);
		}

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function assign(source: DiagramObject): void {
			super.assign(source);
			
			if (source is SubFlow) {
				var tmp:SubFlow = source as SubFlow;
				this.subProcessInfo = tmp.subProcessInfo;
				this._execution = tmp._execution;
				this._subFlowView = tmp._subFlowView;
			}
		}

		/**
		 * 프로퍼티 소스가 제공하는 IPropertyInfo 목록
		 */
		override protected function createPropertyInfos(): Array {
			var props: Array = super.createPropertyInfos();

			return props.concat(
				new SubProcessIdPropertyInfo(PROP_SUBPROCESS_ID, resourceManager.getString("ProcessEditorETC", "subProcessIdText"), "", "", false),
				new SubFlowExecutionPropertyInfo(PROP_EXECUTION, resourceManager.getString("ProcessEditorETC", "subFlowExecutionText"), "", "", false),
//				new SubFlowViewPropertyInfo(PROP_VIEW, resourceManager.getString("ProcessEditorETC", "subFlowViewText"), "", "", false)
				new ActualParametersPropertyInfo(PROP_ACTUAL_PARAMETERS, resourceManager.getString("ProcessEditorETC", "actualParametersText"), "", "", false)
			);
		}
		
		/**
		 * id 에 해당하는 프로퍼티의 현재 값을 리턴
		 */
		override public function getPropertyValue(id: String): Object {
			switch (id) {
				case PROP_EXECUTION:
					return _execution;

				case PROP_VIEW:
					return _subFlowView;

				case PROP_SUBPROCESS_ID:
					if(subProcessName)
						return subProcessName;
				
				case PROP_ACTUAL_PARAMETERS:
					if(actualParameters)
						return actualParameters.toString();
				
				default:
					return super.getPropertyValue(id);
			}
		}
		
		/**
		 * id 에 해당하는 프로퍼티의 값을 설정
		 */
		override public function setPropertyValue(id: String, value: Object): void {
			switch (id) {
				case PROP_EXECUTION:
					execution = value.toString();
					break;
					
				case PROP_VIEW:
					if(value.toString() == subFlowView) return;
					var oldValue:String = subFlowView;
					fireChangeEvent(PROP_VIEW, oldValue);			
					break;

				default:
					super.setPropertyValue(id, value);
					break;
			}
		}
	}
}