////////////////////////////////////////////////////////////////////////////////
//  WorkflowProcess.as
//  2008.01.09, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model.process
{
	import com.maninsoft.smart.formeditor.model.SystemService;
	import com.maninsoft.smart.modeler.xpdl.model.AndGateway;
	import com.maninsoft.smart.modeler.xpdl.model.ComplexGateway;
	import com.maninsoft.smart.modeler.xpdl.model.EndEvent;
	import com.maninsoft.smart.modeler.xpdl.model.IntermediateEvent;
	import com.maninsoft.smart.modeler.xpdl.model.OrGateway;
	import com.maninsoft.smart.modeler.xpdl.model.StartEvent;
	import com.maninsoft.smart.modeler.xpdl.model.SubFlow;
	import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
	import com.maninsoft.smart.modeler.xpdl.model.TaskManual;
	import com.maninsoft.smart.modeler.xpdl.model.TaskService;
	import com.maninsoft.smart.modeler.xpdl.model.XorGateway;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLLink;
	import com.maninsoft.smart.modeler.xpdl.server.ApplicationService;
	import com.maninsoft.smart.workbench.common.meta.impl.SWPackage;
	
	/**
	 * XPDL Process
	 */
	public class WorkflowProcess extends XPDLElement {
		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
	
		private var _owner: XPDLPackage;

		
		//------------------------------
		// XPDL properties
		//------------------------------
		
		public var id: String;
		public var name: String;
		public var parentId: String;
		public var accessLevel: String;
		public var status: String;		
		
		public var processHeader: ProcessHeader = new ProcessHeader();
		public var redefinableHeader: RedefinableHeader = new RedefinableHeader();
		public var formalParameters: Array = [];
		public var extApplications: Array = [];
		public var participants: Array = [];
		public var dataFields: Array = [];
		public var activities: Array = [];
		public var transitions: Array = [];
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function WorkflowProcess(owner: XPDLPackage) {
			super();
			
			_owner = owner;
		}

		public function get isInternalSubProcess():Boolean{
			return (id.substring(0, SWPackage.SUBPROCESS_ID_PREFIX.length)==SWPackage.SUBPROCESS_ID_PREFIX);
		}

		public function refreshApplicationServices(applicationServices:Array):void{
			if(!applicationServices || applicationServices.length == 0) return;
			for each(var extApplication:ExtApplication in extApplications){
				for(var i:int=0; i<applicationServices.length; i++){
					if(extApplication.id == applicationServices[i].id){
						extApplication.name 			= applicationServices[i].name;
						extApplication.url 				= applicationServices[i].url;
						extApplication.editMethod 		= applicationServices[i].editMethod;
						extApplication.viewMethod 		= applicationServices[i].viewMethod;
						extApplication.description 		= applicationServices[i].description;
						extApplication.formalParameters = [];
						for each(var editParam:FormalParameter in applicationServices[i].editParams)
							extApplication.formalParameters.push(editParam);
						for each(var viewParam:FormalParameter in applicationServices[i].viewParams)
							extApplication.formalParameters.push(viewParam);
						for each(var returnParam:FormalParameter in applicationServices[i].returnParams)
							extApplication.formalParameters.push(returnParam);
						extApplication.externalReference.location 	= null;
						extApplication.externalReference.port 		= null;
						extApplication.externalReference.xref 		= null;			
						
					}
				}
			}
		}

		public function refreshSystemServices(systemServices:Array):void{
			if(!systemServices || systemServices.length == 0) return;
			for each(var extApplication:ExtApplication in extApplications){
				for(var i:int=0; i<systemServices.length; i++){
					if(extApplication.id == systemServices[i].id){
						extApplication.name 			= systemServices[i].name;
						extApplication.url 				= null;
						extApplication.editMethod 		= null;
						extApplication.viewMethod 		= null;
						extApplication.description 		= systemServices[i].description;
						extApplication.formalParameters = [];
						extApplication.externalReference.location 	= systemServices[i].wsdlUli;
						extApplication.externalReference.port 		= systemServices[i].port;
						extApplication.externalReference.xref 		= systemServices[i].operation;
					}
				}
			}
		}

		public function addExtApplication(serviceId:String, service:Object, owner: Activity):void{
			if(!serviceId || !service || !owner) return;
			var extApplication:ExtApplication;
			for(var i:int=0; i<extApplications.length; i++){
				extApplication = extApplications[i] as ExtApplication;
				if(extApplication.id == serviceId){
					for(var cnt:int=0; cnt<extApplication.owners.length; cnt++){
						if(extApplication.owners[cnt] == owner)
							break;
					}
					if(cnt==extApplication.owners.length)
						extApplication.owners.push(owner);
					break;
				}
			}
			if(i==extApplications.length){
				extApplication = new ExtApplication();
				extApplication.id = serviceId;
				extApplication.owners.push(owner);
				extApplications.push(extApplication);
			}else{
				extApplication = extApplications[i] as ExtApplication;
			}
			
			if(service is SystemService){
				var systemService:SystemService = service as SystemService;
				extApplication.name 			= systemService.name;
				extApplication.url 				= null;
				extApplication.editMethod 		= null;
				extApplication.viewMethod 		= null;
				extApplication.description 		= systemService.description;
				extApplication.formalParameters = [];
				extApplication.externalReference.location 	= systemService.wsdlUli;
				extApplication.externalReference.port 		= systemService.port;
				extApplication.externalReference.xref 		= systemService.operation;
			}else if(service is ApplicationService){
				var applicationService:ApplicationService = service as ApplicationService;
				extApplication.name 			= applicationService.name;
				extApplication.url 				= applicationService.url;
				extApplication.editMethod 		= applicationService.editMethod;
				extApplication.viewMethod 		= applicationService.viewMethod;
				extApplication.description 		= applicationService.description;
				extApplication.formalParameters = [];
				for each(var editParam:FormalParameter in applicationService.editParams)
					extApplication.formalParameters.push(editParam);
				for each(var viewParam:FormalParameter in applicationService.viewParams)
					extApplication.formalParameters.push(viewParam);
				for each(var returnParam:FormalParameter in applicationService.returnParams)
					extApplication.formalParameters.push(returnParam);
				extApplication.externalReference.location 	= null;
				extApplication.externalReference.port 		= null;
				extApplication.externalReference.xref 		= null;			
			}
		} 
		
		public function removeExtApplication(serviceId:String, owner: Activity):void{
			if(!serviceId || !owner) return;
			var extApplication:ExtApplication;
			for(var i:int=0; i<extApplications.length; i++){
				extApplication = extApplications[i] as ExtApplication;
				if(extApplication.id == serviceId){
					for(var cnt:int=0; cnt<extApplication.owners.length; cnt++){
						if(extApplication.owners[cnt] == owner){
							extApplication.owners.splice(cnt,1);
							break;
						}
					}
					if(extApplication.owners.length==0){
						extApplications.splice(i, 1);
						break;
					}
				}
			}			
		}
		
		override public function read(xml: XML): void {
			super.read(xml);
		}
		
		override public function write(xml: XML): void {
			super.write(xml);
		}	

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * owner
		 */
		public function get owner(): XPDLPackage {
			return _owner;
		}
		
		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function doRead(src: XML): void {
			id			= src.@Id;
			name		= src.@Name;
			parentId	= src.@ParentId;
			accessLevel	= src.@AccessLevel;
			status		= src.@Status;
			
			if (src._ns::ProcessHeader.length() > 0)
				processHeader.read(src._ns::ProcessHeader[0]);
			
			if (src._ns::RedefinableHeader.length() > 0)
				redefinableHeader.read(src._ns::RedefinableHeader[0]);
			
			for each (var f: XML in src._ns::FormalParameters._ns::FormalParameter) {
				var param: FormalParameter = new FormalParameter(this);
				param.read(f);
				formalParameters.push(param);
			}
			
			for each (var ap: XML in src._ns::Applications._ns::Application) {
				var app: ExtApplication = new ExtApplication();
				app.read(ap);
				extApplications.push(app);
			}
			
			for each (var p: XML in src._ns::Participants._ns::Participant) {
				var part: Participant = new Participant();
				part.read(p);
				participants.push(part);
			}
			
			for each (var d: XML in src._ns::DataFields._ns::DataField) {
				var fld: DataField = new DataField(this);
				fld.read(d);
				dataFields.push(fld);
			}
			
			for each (var a: XML in src._ns::Activities._ns::Activity) {
				var act: Activity = readActivity(a);
				
				if (act){
					activities.push(act);
					if (act is SubFlow){
						for each  (var subProcess:WorkflowProcess in owner.processes){
							if (SubFlow(act).subProcessId == subProcess.id){
								addSubProcess(subProcess);
								SubFlow(act).subProcess = subProcess;
							}
						}
					}			
				}
			}
			
			for each (var t: XML in src._ns::Transitions._ns::Transition) {
				var link: XPDLLink = readTransition(t);
				
				if (link)
					transitions.push(link);
			}
		}

		protected function addSubProcess(subProcess: WorkflowProcess): void{

			for each (var param: FormalParameter in subProcess.formalParameters) {
				formalParameters.push(param);
			}
			
			for each (var app: ExtApplication in subProcess.extApplications) {
				extApplications.push(app);
			}
			
			for each (var part: Participant in subProcess.participants) {
				participants.push(part);
			}
			
			for each (var fld: DataField in subProcess.dataFields) {
				dataFields.push(fld);
			}
			
			for each (var act: Activity in subProcess.activities) {
				activities.push(act);
				if (act is SubFlow){
					for each ( var subProcess:WorkflowProcess in owner.processes){
						if (SubFlow(act).subProcessId == subProcess.id){
							addSubProcess(subProcess);
							SubFlow(act).subProcess = subProcess;
							
						}
					}
				}
			}
			
			for each (var link: XPDLLink in subProcess.transitions) {
				transitions.push(link);
			}			
		}
		
		private	var formalParameters_tmp: Array;
		private	var extApplications_tmp: Array;
		private	var participants_tmp: Array;
		private	var dataFields_tmp: Array;
		private	var activities_tmp: Array;
		private	var transitions_tmp: Array;
		override protected function doWrite(dst: XML): void {
			dst.@Id				= id;
			dst.@Name			= name;
			dst.@ParentId		= parentId;
			dst.@AccessLevel	= accessLevel;
			dst.@Status			= status;
			
			dst._ns::ProcessHeader = "";
			processHeader.write(dst._ns::ProcessHeader[0]);
			
			dst._ns::RedefinableHeader = "";
			redefinableHeader.write(dst._ns::RedefinableHeader[0]);
			
			var i: int;

			formalParameters_tmp=[];
			extApplications_tmp=[];
			participants_tmp=[];
			dataFields_tmp=[];
			activities_tmp=[];
			transitions_tmp=[];
			for(i=0; i<formalParameters.length; i++)
				formalParameters_tmp[i] = formalParameters[i];
			for(i=0; i<extApplications.length; i++)
				extApplications_tmp[i] = extApplications[i];
			for(i=0; i<participants.length; i++)
				participants_tmp[i] = participants[i];
			for(i=0; i<dataFields.length; i++)
				dataFields_tmp[i] = dataFields[i];
			for(i=0; i<activities.length; i++)
				activities_tmp[i] = activities[i];
			for(i=0; i<transitions.length; i++)
				transitions_tmp[i] = transitions[i];
			
			if(!this.isInternalSubProcess)
				for(i = 0; i < owner.processes.length-1; i++)
					removeSubProcessInTemp(owner.processes[i] as WorkflowProcess);
						
			for (i = 0; i < formalParameters.length; i++) {
				dst._ns::FormalParameters._ns::FormalParameter[i] = "";
				FormalParameter(formalParameters[i]).write(dst._ns::FormalParameters._ns::FormalParameter[i]);
			}
			
			for (i = 0; i < extApplications.length; i++) {
				dst._ns::Applications._ns::Application[i] = "";
				ExtApplication(extApplications[i]).write(dst._ns::Applications._ns::Application[i]);
			}
			
			for (i = 0; i < participants_tmp.length; i++) {
				dst._ns::Participants._ns::Participant[i] = "";
				Participant(participants_tmp[i]).write(dst._ns::Participants._ns::Participant[i]);
			}
			
			for (i = 0; i < dataFields_tmp.length; i++) {
				dst._ns::DataFields._ns::DataField[i] = "";
				DataField(dataFields_tmp[i]).write(dst._ns::DataFields._ns::DataField[i]);
			}
			
			for (i = 0; i < activities_tmp.length; i++) {
				
				dst._ns::Activities._ns::Activity[i] = "";
				writeActivity(activities_tmp[i], dst._ns::Activities._ns::Activity[i]);
			}
			
			for (i = 0; i < transitions_tmp.length; i++) {
				dst._ns::Transitions._ns::Transition[i] = "";
				writeTransition(transitions_tmp[i], dst._ns::Transitions._ns::Transition[i]);
			}			
		}
		
		protected function removeSubProcessInTemp(subProcess: WorkflowProcess): void{

			if(!subProcess) return;
				
			var i: int;
			for each (var param: FormalParameter in subProcess.formalParameters) {
				for (i = 0; i < formalParameters_tmp.length; i++){
					if(param == FormalParameter(formalParameters_tmp[i])){
						formalParameters_tmp.splice(i,1);
					} 
				}
			}
			
			for each (var app: ExtApplication in subProcess.extApplications) {
				for (i = 0; i < extApplications_tmp.length; i++){
					if(app == ExtApplication(extApplications_tmp[i])){
						extApplications_tmp.splice(i,1);
					} 
				}
			}
			
			for each (var part: Participant in subProcess.participants) {
				for (i = 0; i < participants_tmp.length; i++){
					if(part == Participant(participants_tmp[i])){
						participants_tmp.splice(i,1);
					} 
				}
			}
			
			for each (var fld: DataField in subProcess.dataFields) {
				for (i = 0; i < dataFields_tmp.length; i++){
					if(fld == DataField(dataFields_tmp[i])){
						dataFields_tmp.splice(i,1);
					} 
				}
			}
			
			for each (var act: Activity in subProcess.activities) {
				for (i = 0; i < activities_tmp.length; i++){
					if(act == Activity(activities_tmp[i])){
						activities_tmp.splice(i,1);
					}
				}
			}
			
			for each (var lnik: XPDLLink in subProcess.transitions) {
				for (i = 0; i < transitions_tmp.length; i++){
					if(lnik == XPDLLink(transitions_tmp[i])){
						transitions_tmp.splice(i,1);
					} 
				}
			}
		} 
		
		protected function readActivity(xml: XML): Activity {
			var act: Activity = null;
			
			if (xml._ns::Event.length() > 0) {
				if (xml._ns::Event._ns::StartEvent.length() > 0) {
					act = new StartEvent();
				} else if (xml._ns::Event._ns::EndEvent.length() > 0) {
					act = new EndEvent();
				} else if (xml._ns::Event._ns::IntermediateEvent.length() > 0) {
					act = new IntermediateEvent();
				}
				
			} else if (xml._ns::Route.length() > 0) {
				var x: XMLList = xml._ns::Route;
				
				trace(x.@GatewayType);
				
				switch (x.@GatewayType.toString()) {
					case "OR":
						act = new OrGateway();
						break;	
						
					case "AND":
						act = new AndGateway();
						break;
					
					case "Complex":
						act = new ComplexGateway();
						break;
					
					default:	// "XOR"
						act = new XorGateway();
						break;						
				}
				
			} else if (xml._ns::Implementation.length() > 0) {
				if (xml._ns::Implementation._ns::Task.length() > 0) {
					if (xml._ns::Implementation._ns::Task._ns::TaskApplication.length() > 0) {
						act = new TaskApplication();
					}else if (xml._ns::Implementation._ns::Task._ns::TaskService.length() > 0) {
						act = new TaskService();
					}else if (xml._ns::Implementation._ns::Task._ns::TaskManual.length() > 0) {
						act = new TaskManual();
					}
				}else if (xml._ns::Implementation._ns::SubFlow.length() > 0) {
					act = new SubFlow();
				}
			}
			
			if (act) {
				act.read(xml);
			}
						
			return act;
		}
		
		protected function writeActivity(act: Activity, xml: XML): void {
			act.write(xml);			
		}
		
		protected function findActivity(id: int): Activity {
			for each (var act: Activity in activities) {
				if (act.id == id) 
					return act;
			}
			
			return null;
		}
		
		protected function readTransition(xml: XML): XPDLLink {
			var source: Activity = findActivity(xml.@From);
			var target: Activity = findActivity(xml.@To);
			var path: String = xml._ns::ConnectorGraphicsInfos._ns::ConnectorGraphicsInfo.@Path;
			
			if(source is StartEvent){
				target.startActivity = true;
			}
			
			var link: XPDLLink = new XPDLLink(source, target, path);
			
			link.read(xml);
			
			return link;
		}
		
		protected function writeTransition(link: XPDLLink, xml: XML): void {
			link.write(xml);
		}
	}
}