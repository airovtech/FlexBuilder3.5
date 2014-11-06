////////////////////////////////////////////////////////////////////////////////
//  XPDLLink.as
//  2008.01.07, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model.base
{
	import com.maninsoft.smart.formeditor.model.SystemServiceParameter;
	import com.maninsoft.smart.modeler.model.Link;
	import com.maninsoft.smart.modeler.xpdl.model.IXPDLElement;
	import com.maninsoft.smart.modeler.xpdl.model.SubFlow;
	import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
	import com.maninsoft.smart.modeler.xpdl.model.TaskService;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.model.process.Condition;
	import com.maninsoft.smart.modeler.xpdl.model.process.FormalParameter;
	import com.maninsoft.smart.modeler.xpdl.model.process.XPDLElement;
	import com.maninsoft.smart.modeler.xpdl.property.LinkCondtionPropertyInfo;
	import com.maninsoft.smart.modeler.xpdl.server.TaskFormField;
	import com.maninsoft.smart.modeler.xpdl.syntax.Problem;
	import com.maninsoft.smart.workbench.common.property.BooleanPropertyInfo;
	import com.maninsoft.smart.workbench.common.property.TextPropertyInfo;
	
	/**
	 * XPDL Link base
	 */
	public class XPDLLink extends Link implements IXPDLElement {
		
		//----------------------------------------------------------------------
		// Property consts
		//----------------------------------------------------------------------
		
		public static const PROP_ID			: String = "prop.id";
		public static const PROP_NAME			: String = "prop.name";
		public static const PROP_DESCRIPTION	: String = "prop.description";
		public static const PROP_CONDITION	: String = "prop.condition";
		public static const PROP_ISDEFAULT	: String = "prop.isDefault";
		public static const PROP_PROBLEM		: String = "prop.problem";
		
		
		//------------------------------
		// status
		//------------------------------
	
		public static const STATUS_NONE     : String = "NONE";
		public static const STATUS_READY    : String = "READY";
		public static const STATUS_COMPLETED: String = "COMPLETED";


		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _id: int;
		private var _name: String = EMPTY_STRING ;
		private var _description: String = EMPTY_STRING;
		private var _condition: Condition;
		

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function XPDLLink(source: Activity, target: Activity, 
								   path: String = null, connectType: String = null) {
			super(source, target, path, connectType);
			_condition = new Condition();
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * XPDL Id
		 */
		public function get id(): int {
			return _id;
		}
		
		public function set id(value: int): void {
			_id = value;
		}
		
		/**
		 * XPDL Name
		 */
		public function get name(): String {
			return _name;
		}
		
		public function set name(value: String): void {
			if (value != _name) {
				var oldVal: String = _name;
				_name = value;
				fireChangeEvent(PROP_NAME, oldVal);
			}
		}
		
		/**
		 * XPDL Description
		 */
		public function get description(): String {
			return _description;
		}
		
		public function set description(value: String): void {
			if (value != _description) {
				var oldVal: String = _description;
				_description = value;
				fireChangeEvent(PROP_DESCRIPTION, oldVal);
			}
		}
		
		/**
		 * XPDL From
		 */
		public function get fromId(): int {
			return Activity(source).id;
		}
		
		/**
		 * XPDL To
		 */
		public function get toId(): int {
			return Activity(target).id;
		}
		
		/**
		 * XPDL Condition
		 */
		public function get condition(): String {
			var xpdl:XPDLDiagram = this.diagram as XPDLDiagram;
			if (xpdl == null || xpdl.xpdlPackage == null || xpdl.xpdlPackage.process == null || 
					xpdl.xpdlPackage.process.activities == null || _condition.expression == null)
				return _condition.expression;

			var tmp:String = _condition.expression;
			var simpleExpr:String="";
			var index:int = tmp.indexOf("{$");
			tmp = tmp.substr(index+2);
			while(index != -1){
				index = tmp.indexOf(".");
				if(index==-1) break;
				if(tmp.substr(0, index) == "ProcessParam"){
					tmp = tmp.substr(index + 1);
					index = tmp.indexOf(".");
					if(index == -1)	break;
					simpleExpr += "{" + xpdl.xpdlPackage.process.name + "." + FormalParameter.MODE_TYPES_NAME_FULL[FormalParameter.getModeIndex(tmp.substr(0, index))] + ".";
					
				}else if(tmp.substr(0, index) == "ActivityData"){
					tmp = tmp.substr(index + 1);
					index = tmp.indexOf(".");
					if (index == -1) break;
					for each (var act:Activity in xpdl.activities){
						if ((act.id).toString() == tmp.substr(0, index)){
							simpleExpr+= "{" + TaskApplication(act).formName +"."; 
							break;
						}
					}
					tmp=tmp.substr(index+1);
					index = tmp.indexOf(".");
					if(index == -1)	break;
					
				}else if(tmp.substr(0, index) == "SubParameter"){
					tmp = tmp.substr(index + 1);
					index = tmp.indexOf(".");
					if (index == -1) break;
					for each (act in xpdl.activities){
						if (act is SubFlow && (act.id).toString() == tmp.substr(0, index)){
							simpleExpr+= "{" + SubFlow(act).name +"."; 
							break;
						}
					}
					tmp=tmp.substr(index+1);
					index = tmp.indexOf(".");
					if(index == -1)	break;
					simpleExpr += FormalParameter.MODE_TYPES_NAME[FormalParameter.getModeIndex(tmp.substr(0, index))] + ".";
					
				}else if(tmp.substr(0, index) == "ServiceParam"){
					tmp = tmp.substr(index + 1);
					index = tmp.indexOf(".");
					if (index == -1) break;
					for each (act in xpdl.activities){
						if (act is TaskService && (act.id).toString() == tmp.substr(0, index)){
							simpleExpr+= "{" + TaskService(act).name +"."; 
							break;
						}else if (act is TaskApplication && (act.id).toString() == tmp.substr(0, index)){
							simpleExpr+= "{" + TaskApplication(act).name +"."; 
							break;
						}
					}
					tmp=tmp.substr(index+1);
					index = tmp.indexOf(".");
					if(index == -1)	break;
					simpleExpr += FormalParameter.MODE_TYPES_NAME_FULL[FormalParameter.getModeIndex(tmp.substr(0, index))] + ".";
					
				}
				tmp = tmp.substr(index+1);
				index = tmp.indexOf("}");
				if(index == -1)	break;
					
				simpleExpr += tmp.substr(0,index) + "}";
				tmp = tmp.substr(index+1);
				index = tmp.indexOf("{$");
				if(index!=-1){
					simpleExpr += tmp.substr(0, index);
					tmp = tmp.substr(index+2);
				}
			}
			return simpleExpr += tmp;			
		}
		
		public function set condition(value: String): void {
			if (value != condition) {
				var oldValue: String = condition;
			}
			
			var xpdl:XPDLDiagram = this.diagram as XPDLDiagram;
			if (xpdl == null || xpdl.xpdlPackage == null || xpdl.xpdlPackage.process == null || 
					xpdl.xpdlPackage.process.activities == null || value == null){
				_condition.expression = value;
				fireChangeEvent(PROP_CONDITION, oldValue);
				return;
			}

			var tmp:String = value;
			var expression:String="";
			var index:int = tmp.indexOf("{");
			while(index!=-1){
				tmp = tmp.substr(index+1);
				index = tmp.indexOf(".");
				var processId:String, formId:String, subFlowId:String, taskServiceId:String, appServiceId:String;
				var actIndex:int = 0;
				processId = formId = subFlowId = taskServiceId = appServiceId = "";
				if( xpdl.xpdlPackage.process.name == tmp.substr(0, index)){
					if(xpdl.xpdlPackage.process.formalParameters){
						tmp = tmp.substr(index+1);
						index = tmp.indexOf(".");
						if(index==-1) break;						
						processId = xpdl.xpdlPackage.process.id.toString();
						expression += "{$ProcessParam." + FormalParameter.MODE_TYPES_FULL[FormalParameter.getModeIndex(tmp.substr(0,index))] + "."; 
					}											
				}else{
					for each (var act:Activity in xpdl.activities){
						if (act is TaskApplication && TaskApplication(act).formName == tmp.substr(0, index)){
							if(TaskApplication(act).formId && (TaskApplication(act).formId != "SYSTEMFORM")){
								formId = TaskApplication(act).formId;
								expression += "{$ActivityData." + act.id.toString() +"."; 
								break;
							}
						}else if (act is TaskApplication && TaskApplication(act).isCustomForm){
							if(!TaskApplication(act).formId && TaskApplication(act).isCustomForm && TaskApplication(act).applicationService && TaskApplication(act).name == tmp.substr(0,index)){
								if(TaskApplication(act).applicationService.returnParams){
									tmp = tmp.substr(index+1);
									index = tmp.indexOf(".");
									if(index==-1) break;						
									appServiceId = act.id.toString();
									expression += "{$ServiceParam." + appServiceId +"." + FormalParameter.MODE_TYPES_FULL[FormalParameter.getModeIndex(tmp.substr(0,index))] + "."; 
									break;
								}								
							}
						}else if(act is SubFlow && SubFlow(act).name == tmp.substr(0,index)){
							if(SubFlow(act).subProcess.formalParameters){
								tmp = tmp.substr(index+1);
								index = tmp.indexOf(".");
								if(index==-1) break;						
								subFlowId = act.id.toString();
								expression += "{$SubParameter." + subFlowId +"." + FormalParameter.MODE_TYPES_FULL[FormalParameter.getModeIndex(tmp.substr(0,index))] + "."; 
								break;
							}						
						}else if(act is TaskService && TaskService(act).name == tmp.substr(0,index)){
							if(TaskService(act).systemService.messageOut){
								tmp = tmp.substr(index+1);
								index = tmp.indexOf(".");
								if(index==-1) break;						
								taskServiceId = act.id.toString();
								expression += "{$ServiceParam." + taskServiceId +"." + FormalParameter.MODE_TYPES_FULL[FormalParameter.getModeIndex(tmp.substr(0,index))] + "."; 
								break;
							}
						}					
						actIndex++;
					}
				}
				if(processId == null && formId == null && subFlowId == null && taskServiceId == null && appServiceId == null) break;
				if(processId){
					tmp = tmp.substr(index+1);
					index = tmp.indexOf("}");
					if(index==-1) break;
					for each(var param:FormalParameter in xpdl.xpdlPackage.process.formalParameters){
						if(param.id==tmp.substr(0,index)){
							expression += param.id + "}";
							break;
						}
					}
				}else if(formId){
					var formFields:Array = xpdl.server.getTaskFormFields(formId);
					if(formFields == null) return;
					tmp = tmp.substr(index+1);
					index = tmp.indexOf("}");
					if(index==-1) break;

					for each (var formField:TaskFormField in formFields) {
						if(formField.name == tmp.substr(0, index)){
							expression += formField.id.toString() + "." + tmp.substr(0, index) + "}";
							break;
						} 
					}
				
				}else if(subFlowId){
					tmp = tmp.substr(index+1);
					index = tmp.indexOf("}");
					if(index==-1 || !SubFlow(xpdl.activities[actIndex]).subProcess ) break;
					for each(var subParam:FormalParameter in SubFlow(xpdl.activities[actIndex]).subProcess.formalParameters){
						if(subParam.id==tmp.substr(0,index)){
							expression += subParam.id + "}";
							break;
						}
					}
				}else if(taskServiceId){
					tmp = tmp.substr(index+1);
					index = tmp.indexOf("}");
					if(index==-1 || !TaskService(xpdl.activities[actIndex]).systemService ) break;
					for each(var serviceParam:SystemServiceParameter in TaskService(xpdl.activities[actIndex]).systemService.messageOut){
						if(serviceParam.id==tmp.substr(0,index)){
							expression += serviceParam.id + "}";
							break;
						}
					}
				}else if(appServiceId){
					tmp = tmp.substr(index+1);
					index = tmp.indexOf("}");
					if(index==-1 || !TaskApplication(xpdl.activities[actIndex]).applicationService ) break;
					for each(var returnParam:FormalParameter in TaskApplication(xpdl.activities[actIndex]).applicationService.returnParams){
						if(returnParam.id==tmp.substr(0,index)){
							expression += returnParam.id + "}";
							break;
						}
					}
				}
				tmp = tmp.substr(index+1);
				index = tmp.indexOf("{");
				if(index!=-1)
					expression += tmp.substr(0, index);
			}
			expression += tmp;
			_condition.expression = expression;
			fireChangeEvent(PROP_CONDITION, oldValue);
		}

		/**
		 * isDefault
		 */
		public function get isDefault(): Boolean {
			return _condition.type == "OTHERWISE";
		}
		
		public function set isDefault(value: Boolean): void {
			if (value != isDefault) {
				var oldValue: Boolean = isDefault;
				_condition.type = value ? "OTHERWISE" : "CONDITION"
				fireChangeEvent(PROP_ISDEFAULT, oldValue);
			}
		}
		
		/**
		 * problem
		 */
		private var _problem: Problem;
		
		public function get problem(): Problem {
			return _problem;
		}
		
		public function set problem(value: Problem): void {
			if (value != _problem) {
				var oldValue: Problem = _problem;
				_problem = value;
				fireChangeEvent(PROP_PROBLEM, oldValue);
			}
		}
		
		
		/**
		 * status
		 */
		private var _status: String = STATUS_NONE;
		
		public function get status(): String {
			return _status ? _status : STATUS_NONE;
		}
		
		public function set status(value: String): void {
			if (value != _status) {
				var oldValue: String = _status;
				_status = value;
				//fireChangeEvent(PROP_STATUS, null);
			}
		}

		//----------------------------------------------------------------------
		// IXPDLElement
		//----------------------------------------------------------------------
		
		protected function get _ns(): Namespace {
			return XPDLElement._ns;
		}
		
		public function read(xml: XML): void {
			doRead(xml);
		}
		
		public function write(xml: XML): void {
			doWrite(xml);
		}	

		protected function doRead(src: XML): void {
			_id				= src.@Id;
			_name			= src.@Name;
			_description	= src._ns::Description;
			try{
				_status = src.@Status;
			}catch (e:Error){}
			
			if (src._ns::Condition.length() > 0)
				_condition.read(src._ns::Condition[0]);
			if(src._ns::ConnectorGraphicsInfos._ns::ConnectorGraphicsInfo.length() > 0)	
				doReadGraphics(src._ns::ConnectorGraphicsInfos._ns::ConnectorGraphicsInfo[0]);
		}
		
		protected function doReadGraphics(xml: XML): void {
			path = xml.@Path;
			textPos = xml.@TextPos;
		}

		protected function doWrite(dst: XML): void {
			dst.@Id			= id;
			dst.@Name		= name;
			dst.@From		= XPDLNode(source).id;
			dst.@To			= XPDLNode(target).id;
			dst._ns::Description = description;
			
			dst._ns::Condition = "";
			_condition.write(dst._ns::Condition[0]);

			dst._ns::ConnectorGraphicsInfos._ns::ConnectorGraphicsInfo = "";
			doWriteGraphics(dst._ns::ConnectorGraphicsInfos._ns::ConnectorGraphicsInfo[0]);		
		}
		
		protected function doWriteGraphics(xml: XML): void {
			xml.@Path = path;
			xml.@TextPos = textPos;
		}

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function isHiddenProperty(property: String): Boolean {
			return property == "source" ||
			        property == "target";
		}

		override protected function isDiagramProp(prop: String): Boolean {
			return prop != PROP_PROBLEM && super.isDiagramProp(prop);
		}

		/**
		 * 프로퍼티 소스가 제공하는 IPropertyInfo 목록
		 */
		override protected function createPropertyInfos(): Array {
			var props: Array = super.createPropertyInfos();
			
			return props.concat(
				new TextPropertyInfo(PROP_ID, "Id"),
				new TextPropertyInfo(PROP_NAME, resourceManager.getString("WorkbenchETC", "nameText")),
				new BooleanPropertyInfo(PROP_ISDEFAULT, resourceManager.getString("ProcessEditorETC", "defaultGatewayText"), null, null, false),
				new LinkCondtionPropertyInfo(PROP_CONDITION, resourceManager.getString("ProcessEditorETC", "gatewayConditionText"), null, null, false)
			);
		}
		
		/**
		 * id 에 해당하는 프로퍼티의 현재 값을 리턴
		 */
		override public function getPropertyValue(id: String): Object {
			switch (id) {
				case PROP_ID: 
					return this.id;
					
				case PROP_NAME: 
					return name;
					
				case PROP_SOURCE: 
					return XPDLNode(source).name;
					
				case PROP_TARGET:
					return XPDLNode(target).name;
					
				case PROP_CONDITION:
					return condition;
					
				case PROP_ISDEFAULT:
					return isDefault;
					
				default:
					return super.getPropertyValue(id);
			}
		}
		
		/**
		 * id 에 해당하는 프로퍼티의 값을 설정
		 */
		override public function setPropertyValue(id: String, value: Object): void {
			switch (id) {
				case PROP_NAME:
					name = value.toString();
					break;
					
				case PROP_CONDITION:
					condition = value.toString();
					break;
					
				case PROP_ISDEFAULT:
					isDefault = value;
					break;
					
				default:
					super.setPropertyValue(id, value);
					break;
			}
		}
	}
}