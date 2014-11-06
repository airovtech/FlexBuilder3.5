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
	import com.maninsoft.smart.formeditor.model.Mapping;
	import com.maninsoft.smart.formeditor.model.Mappings;
	import com.maninsoft.smart.formeditor.model.SystemService;
	import com.maninsoft.smart.formeditor.model.SystemServiceParameter;
	import com.maninsoft.smart.modeler.model.DiagramObject;
	import com.maninsoft.smart.modeler.xpdl.model.base.ActivityTypes;
	import com.maninsoft.smart.modeler.xpdl.model.base.Task;
	import com.maninsoft.smart.modeler.xpdl.property.ActualParametersPropertyInfo;
	import com.maninsoft.smart.modeler.xpdl.property.FormMappingPropertyInfo;
	import com.maninsoft.smart.modeler.xpdl.property.ServiceIdPropertyInfo;
	import com.maninsoft.smart.modeler.xpdl.property.ServiceTypePropertyInfo;
	
	import mx.controls.Alert;
	
	/**
	 * XPDL TaskService Task
	 */
	public class TaskService extends Task {
		
		//----------------------------------------------------------------------
		// Property consts
		//----------------------------------------------------------------------
		public static const PROP_SERVICE_TYPE		: String = "prop.serviceType";
		public static const PROP_SERVICE_ID			: String = "prop.serviceId";
		public static const PROP_ACTUAL_PARAMETERS	: String = "prop.actualParameters";
		public static const PROP_MAIL_RECEIVERS		: String = "prop.mailReceivers";
		public static const PROP_MAIL_CC_RECEIVERS	: String = "prop.mailCcReceivers";
		public static const PROP_MAIL_BCC_RECEIVERS	: String = "prop.mailBccReceivers";
		public static const PROP_MAIL_SUBJECT		: String = "prop.mailSubject";
		public static const PROP_MAIL_CONTENT		: String = "prop.mailContent";
		public static const PROP_MAIL_ATTACHMENT	: String = "prop.mailAttachment";
		
		public static const SERVICE_TYPE_SYSTEM : String = "systemService";
		public static const SERVICE_TYPE_MAIL	: String = "mailService"
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _serviceType: String = SERVICE_TYPE_SYSTEM;
		private var _serviceId: String;
		private var _serviceName: String;
		private var _systemService: SystemService;
		private var _actualParameters:ActualParameters;

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/**
		 * Construtor 
		 */
		public function TaskService() {
			super();
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		public function get serviceType(): String {
			return _serviceType;
		}

		public function set serviceType(value: String): void {
			if(_serviceType != value){
				var oldVal: String = _serviceType;
				_serviceType = value;				
				fireChangeEvent(PROP_SERVICE_TYPE, oldVal);
			}
		}
		
		public function get serviceId(): String {
			return _serviceId;
		}

		public function set serviceId(value: String): void {
			if(value==null || value=="null"){
				value = "";
			}
			if(_serviceId != value){
				var oldVal: String = _serviceId;
				_serviceId = value;				
				fireChangeEvent(PROP_SERVICE_ID, oldVal);
			}
		}
		
		public function get serviceName(): String {
			return _serviceName;
		}
		
		public function set serviceName(val:String): void {
			this._serviceName = val;
		}		
		
		public function get systemService(): SystemService {
			return _systemService;
		}
		
		public function set systemService(val: SystemService): void {
			if(_systemService == val) return;
			
			if(actualParameters && !_systemService){
				this._systemService = val;
				return;
			}

			this._systemService = val;
			actualParameters = new ActualParameters();
			for each(var inParam:SystemServiceParameter in _systemService.messageIn){
				var actualParam:ActualParameter = new ActualParameter();
				actualParam.formalParameterId = inParam.id;
				actualParam.formalParameterName = inParam.name;
				actualParam.formalParameterType = inParam.elementType;
				actualParam.formalParameterMode = ActualParameter.FORMALPARAMETERMODE_IN;

				actualParam.targetType = ActualParameter.TARGETTYPE_EXPRESSION;
				actualParam.targetTypeName = ActualParameter.getTargetTypeNameByValue(actualParam.targetType);
				actualParam.targetValueType = ActualParameter.TARGETVALUETYPE_VALUE;
				actualParam.targetValueTypeName = ActualParameter.getTargetValueTypeNameByValue(actualParam.targetValueType);						
				actualParameters.addActualParameter(actualParam);
			}
			for each(var outParam:SystemServiceParameter in _systemService.messageOut){
				actualParam = new ActualParameter();
				actualParam.formalParameterId = outParam.id;
				actualParam.formalParameterName = outParam.name;
				actualParam.formalParameterType = outParam.elementType;
				actualParam.formalParameterMode = ActualParameter.FORMALPARAMETERMODE_OUT;

				actualParam.targetType = null;
				actualParam.targetTypeName = null;
				actualParam.targetValueType = null;
				actualParam.targetValueTypeName = null;						
				actualParameters.addActualParameter(actualParam);
			}
		}		
		
		public function get actualParameters(): ActualParameters {
			return _actualParameters;
		}
		
		public function set actualParameters(val: ActualParameters): void {
			this._actualParameters = val;
		}		
		
		private var _mailReceivers: Mapping;
		public function get mailReceivers():Mapping {
			return _mailReceivers;
		}
		public function set mailReceivers(value:Mapping):void {
			if(_mailReceivers != value){
				var oldVal: Mapping = _mailReceivers;
				_mailReceivers = value;				
				fireChangeEvent(PROP_MAIL_RECEIVERS, oldVal);
			}
		}

		private var _mailCcReceivers: Mapping;
		public function get mailCcReceivers():Mapping {
			return _mailCcReceivers;
		}
		public function set mailCcReceivers(value:Mapping):void {
			if(_mailCcReceivers != value){
				var oldVal: Mapping = _mailCcReceivers;
				_mailCcReceivers = value;				
				fireChangeEvent(PROP_MAIL_CC_RECEIVERS, oldVal);
			}
		}

		private var _mailBccReceivers: Mapping;
		public function get mailBccReceivers():Mapping {
			return _mailBccReceivers;
		}
		public function set mailBccReceivers(value:Mapping):void {
			if(_mailBccReceivers != value){
				var oldVal: Mapping = _mailBccReceivers;
				_mailBccReceivers = value;				
				fireChangeEvent(PROP_MAIL_BCC_RECEIVERS, oldVal);
			}
		}

		private var _mailSubject: Mapping;
		public function get mailSubject():Mapping {
			return _mailSubject;
		}
		public function set mailSubject(value:Mapping):void {
			if(_mailSubject != value){
				var oldVal: Mapping = _mailSubject;
				_mailSubject = value;				
				fireChangeEvent(PROP_MAIL_SUBJECT, oldVal);
			}
		}

		private var _mailContent: Mapping;
		public function get mailContent():Mapping {
			return _mailContent;
		}
		public function set mailContent(value:Mapping):void {
			if(_mailContent != value){
				var oldVal: Mapping = _mailContent;
				_mailContent = value;				
				fireChangeEvent(PROP_MAIL_CONTENT, oldVal);
			}
		}

		private var _mailAttachment: Mapping;
		public function get mailAttachment():Mapping {
			return _mailAttachment;
		}
		public function set mailAttachment(value:Mapping):void {
			if(_mailAttachment != value){
				var oldVal: Mapping = _mailAttachment;
				_mailAttachment = value;				
				fireChangeEvent(PROP_MAIL_ATTACHMENT, oldVal);
			}
		}

		//----------------------------------------------------------------------
		// IXPDLElement
		//----------------------------------------------------------------------
		
		override protected function doRead(src: XML): void {
			var xml: XML = src._ns::Implementation._ns::Task._ns::TaskService[0];
			
			_serviceType = xml.@ServiceType;
			_serviceId = xml.@Id;
			_serviceName = xml.@Name;

			if(_serviceType == null || _serviceType == "null")
				_serviceType = TaskService.SERVICE_TYPE_SYSTEM;

			if(_serviceType==TaskService.SERVICE_TYPE_SYSTEM){
				xml = src._ns::Implementation._ns::Task._ns::TaskService[0]._ns::MessageIn._ns::ActualParameters[0];
				var messageIn: ActualParameters = ActualParameters.parseXML(xml)
	
				xml = src._ns::Implementation._ns::Task._ns::TaskService[0]._ns::MessageOut._ns::ActualParameters[0];
				var messageOut: ActualParameters = ActualParameters.parseXML(xml)
	
				actualParameters = new ActualParameters();
				for each(var actualParam: ActualParameter in messageIn.actualParameters)
					actualParameters.addActualParameter(actualParam);
					
				for each(actualParam in messageOut.actualParameters)
					actualParameters.addActualParameter(actualParam);

			}else if(_serviceType==TaskService.SERVICE_TYPE_MAIL){
				xml = src._ns::Implementation._ns::Task._ns::TaskService[0]._ns::MessageIn._ns::DataMappings[0];
				var dataMappings:Mappings = Mappings.parseXML(null, xml, _ns);
				if(dataMappings!=null){
					for(var i:int=0; i<dataMappings.inMappings.length; i++){
						if(dataMappings.inMappings[i].propertyId == PROP_MAIL_RECEIVERS)
							_mailReceivers = dataMappings.inMappings[i];
						else if(dataMappings.inMappings[i].propertyId == PROP_MAIL_CC_RECEIVERS)
							_mailCcReceivers = dataMappings.inMappings[i];
						else if(dataMappings.inMappings[i].propertyId == PROP_MAIL_BCC_RECEIVERS)
							_mailBccReceivers = dataMappings.inMappings[i];
						else if(dataMappings.inMappings[i].propertyId == PROP_MAIL_SUBJECT)
							_mailSubject = dataMappings.inMappings[i];
						else if(dataMappings.inMappings[i].propertyId == PROP_MAIL_CONTENT)
							_mailContent = dataMappings.inMappings[i];
						else if(dataMappings.inMappings[i].propertyId == PROP_MAIL_ATTACHMENT)
							_mailAttachment = dataMappings.inMappings[i];
					}
				}
			}
				
			super.doRead(src);
		}

		override protected function doWrite(dst: XML): void {
			dst._ns::Implementation._ns::Task._ns::TaskService = "";
			var xml: XML = dst._ns::Implementation._ns::Task._ns::TaskService[0];
			
			xml.@ServiceType = _serviceType;
			xml.@Id = _serviceId;
			xml.@Name = _serviceName;

			if(_serviceType == null || _serviceType == "" || _serviceType == "null" || _serviceType == TaskService.SERVICE_TYPE_SYSTEM){
				var paramCnt:int;
				dst._ns::Implementation._ns::Task._ns::TaskService._ns::MessageIn._ns::ActualParameters = "";
				if (_actualParameters) {
					xml = dst._ns::Implementation._ns::Task._ns::TaskService._ns::MessageIn._ns::ActualParameters[0];
					_actualParameters.toXML(xml);
					paramCnt=0;
					for (var i:int = 0; i < _actualParameters.actualParameters.length; i++) {
						if(ActualParameter(_actualParameters.actualParameters[i]).formalParameterMode == ActualParameter.FORMALPARAMETERMODE_IN){
							dst._ns::Implementation._ns::Task._ns::TaskService[0]._ns::MessageIn._ns::ActualParameters._ns::ActualParameter[paramCnt] = "";
							xml = dst._ns::Implementation._ns::Task._ns::TaskService[0]._ns::MessageIn._ns::ActualParameters._ns::ActualParameter[paramCnt];
							ActualParameter(_actualParameters.actualParameters[i]).toXML(xml);
							paramCnt++;
						}
					}
				}
	
				dst._ns::Implementation._ns::Task._ns::TaskService._ns::MessageOut._ns::ActualParameters = "";
				if (_actualParameters) {
					xml = dst._ns::Implementation._ns::Task._ns::TaskService._ns::MessageOut._ns::ActualParameters[0];
					_actualParameters.toXML(xml);
					paramCnt=0;
					for (var j:int = 0; j < _actualParameters.actualParameters.length; j++) {
						if(ActualParameter(_actualParameters.actualParameters[j]).formalParameterMode == ActualParameter.FORMALPARAMETERMODE_OUT){
							dst._ns::Implementation._ns::Task._ns::TaskService[0]._ns::MessageOut._ns::ActualParameters._ns::ActualParameter[paramCnt] = "";
							xml = dst._ns::Implementation._ns::Task._ns::TaskService[0]._ns::MessageOut._ns::ActualParameters._ns::ActualParameter[paramCnt];
							ActualParameter(_actualParameters.actualParameters[j]).toXML(xml);
							paramCnt++;
						}
					}
				}

			}else if(_serviceType == TaskService.SERVICE_TYPE_MAIL){
				dst._ns::Implementation._ns::Task._ns::TaskService._ns::MessageIn._ns::DataMappings = "";
				xml = dst._ns::Implementation._ns::Task._ns::TaskService._ns::MessageIn._ns::DataMappings[0];
				var childCnt:int=0;
				if(_mailReceivers!=null){
					_mailReceivers.propertyId = PROP_MAIL_RECEIVERS;
					dst._ns::Implementation._ns::Task._ns::TaskService._ns::MessageIn._ns::DataMappings[0]._ns::DataMapping[childCnt] = "";
					_mailReceivers.toXML(dst._ns::Implementation._ns::Task._ns::TaskService._ns::MessageIn._ns::DataMappings[0]._ns::DataMapping[childCnt++]);
				}
				if(_mailCcReceivers!=null){
					_mailCcReceivers.propertyId = PROP_MAIL_CC_RECEIVERS;
					dst._ns::Implementation._ns::Task._ns::TaskService._ns::MessageIn._ns::DataMappings[0]._ns::DataMapping[childCnt] = "";
					_mailCcReceivers.toXML(dst._ns::Implementation._ns::Task._ns::TaskService._ns::MessageIn._ns::DataMappings[0]._ns::DataMapping[childCnt++]);
				}
				if(_mailBccReceivers!=null){
					_mailBccReceivers.propertyId = PROP_MAIL_BCC_RECEIVERS;
					dst._ns::Implementation._ns::Task._ns::TaskService._ns::MessageIn._ns::DataMappings[0]._ns::DataMapping[childCnt] = "";
					_mailBccReceivers.toXML(dst._ns::Implementation._ns::Task._ns::TaskService._ns::MessageIn._ns::DataMappings[0]._ns::DataMapping[childCnt++]);
				}
				if(_mailSubject!=null){
					_mailSubject.propertyId = PROP_MAIL_SUBJECT;
					dst._ns::Implementation._ns::Task._ns::TaskService._ns::MessageIn._ns::DataMappings[0]._ns::DataMapping[childCnt] = "";
					_mailSubject.toXML(dst._ns::Implementation._ns::Task._ns::TaskService._ns::MessageIn._ns::DataMappings[0]._ns::DataMapping[childCnt++]);
				}
				if(_mailContent!=null){
					_mailContent.propertyId = PROP_MAIL_CONTENT;
					dst._ns::Implementation._ns::Task._ns::TaskService._ns::MessageIn._ns::DataMappings[0]._ns::DataMapping[childCnt] = "";
					_mailContent.toXML(dst._ns::Implementation._ns::Task._ns::TaskService._ns::MessageIn._ns::DataMappings[0]._ns::DataMapping[childCnt++]);
				}
				if(_mailAttachment!=null){
					_mailAttachment.propertyId = PROP_MAIL_ATTACHMENT;
					dst._ns::Implementation._ns::Task._ns::TaskService._ns::MessageIn._ns::DataMappings[0]._ns::DataMapping[childCnt] = "";
					_mailAttachment.toXML(dst._ns::Implementation._ns::Task._ns::TaskService._ns::MessageIn._ns::DataMappings[0]._ns::DataMapping[childCnt++]);
				}
			}
			super.doWrite(dst);
		}


		//----------------------------------------------------------------------
		// Overriden properties
		//----------------------------------------------------------------------

		override public function get defaultName(): String {
			return resourceManager.getString("ProcessEditorETC", "taskServiceText");
		}

		override public function get activityType(): String {
			return ActivityTypes.TASK_SERVICE;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function assign(source: DiagramObject): void {
			super.assign(source);
			
			if (source is TaskService) {
				var tmp:TaskService = source as TaskService;
				this._serviceType = tmp._serviceType;
				this._serviceId = tmp._serviceId;
				this._serviceName = tmp._serviceName;
				this._systemService = tmp._systemService;
				this._actualParameters = tmp._actualParameters;
				this._mailReceivers = tmp._mailReceivers;
				this._mailCcReceivers = tmp._mailCcReceivers;
				this._mailBccReceivers = tmp._mailBccReceivers;
				this._mailSubject = tmp._mailSubject;
				this._mailContent = tmp._mailContent;
				this._mailAttachment = tmp._mailAttachment;
			}
		}

		/**
		 * 프로퍼티 소스가 제공하는 IPropertyInfo 목록
		 */
		override protected function createPropertyInfos(): Array {
			var props: Array = super.createPropertyInfos();

			if(_serviceType == TaskService.SERVICE_TYPE_MAIL){
				return props.concat(
					new ServiceTypePropertyInfo(PROP_SERVICE_TYPE, resourceManager.getString("ProcessEditorETC", "serviceTypeText"), null, null, false),
					new FormMappingPropertyInfo(PROP_MAIL_RECEIVERS, resourceManager.getString("ProcessEditorETC", "mailReceiversText"), null, null, false),
					new FormMappingPropertyInfo(PROP_MAIL_CC_RECEIVERS, resourceManager.getString("ProcessEditorETC", "mailCcReceiversText"), null, null, false),
					new FormMappingPropertyInfo(PROP_MAIL_BCC_RECEIVERS, resourceManager.getString("ProcessEditorETC", "mailBccReceiversText"), null, null, false),
					new FormMappingPropertyInfo(PROP_MAIL_SUBJECT, resourceManager.getString("ProcessEditorETC", "mailSubjectText"), null, null, false),
					new FormMappingPropertyInfo(PROP_MAIL_CONTENT, resourceManager.getString("ProcessEditorETC", "mailContentText"), null, null, false),
					new FormMappingPropertyInfo(PROP_MAIL_ATTACHMENT, resourceManager.getString("ProcessEditorETC", "mailAttachmentText"), null, null, false)
				);
			}
			return props.concat(
				new ServiceTypePropertyInfo (PROP_SERVICE_TYPE, resourceManager.getString("ProcessEditorETC", "serviceTypeText"), null, null, false),
				new ServiceIdPropertyInfo(PROP_SERVICE_ID, resourceManager.getString("ProcessEditorETC", "systemServiceText"), null, null, false),
				new ActualParametersPropertyInfo(PROP_ACTUAL_PARAMETERS, resourceManager.getString("ProcessEditorETC", "actualParametersText"), null, null, false)
				);
		}
		
		/**
		 * id 에 해당하는 프로퍼티의 현재 값을 리턴
		 */
		override public function getPropertyValue(id: String): Object {
			switch (id) {
				case PROP_SERVICE_TYPE:
					return serviceType;

				case PROP_SERVICE_ID:
					return serviceName;

				case PROP_ACTUAL_PARAMETERS:
					if(actualParameters)
						return actualParameters.toString();
					return null;

				case PROP_MAIL_RECEIVERS:
					return mailReceivers==null ? resourceManager.getString("ProcessEditorETC", "noneText") : mailReceivers.name;
					
				case PROP_MAIL_CC_RECEIVERS:
					return mailCcReceivers==null ? resourceManager.getString("ProcessEditorETC", "noneText") : mailCcReceivers.name;
					
				case PROP_MAIL_BCC_RECEIVERS:
					return mailBccReceivers==null ? resourceManager.getString("ProcessEditorETC", "noneText") : mailBccReceivers.name;
					
				case PROP_MAIL_SUBJECT:
					return mailSubject==null ? resourceManager.getString("ProcessEditorETC", "noneText") : mailSubject.name;
					
				case PROP_MAIL_CONTENT:
					return mailContent==null ? resourceManager.getString("ProcessEditorETC", "noneText") : mailContent.name;
					
				case PROP_MAIL_ATTACHMENT:
					return mailAttachment==null ? resourceManager.getString("ProcessEditorETC", "noneText") : mailAttachment.name;
					
				default:
					return super.getPropertyValue(id);
			}
		}
		
		/**
		 * id 에 해당하는 프로퍼티의 값을 설정
		 */
		override public function setPropertyValue(id: String, value: Object): void {
			switch (id) {
				case PROP_SERVICE_TYPE: 
					serviceType = value.toString();
					break;
					
				case PROP_SERVICE_ID: 
					serviceName = value.toString();
					break;
					
				default:
					super.setPropertyValue(id, value);
					break;
			}
		}


		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------

	}
}