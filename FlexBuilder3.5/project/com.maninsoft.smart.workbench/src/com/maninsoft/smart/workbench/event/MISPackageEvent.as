package com.maninsoft.smart.workbench.event
{
	import com.maninsoft.smart.workbench.common.meta.impl.SWForm;
	import com.maninsoft.smart.workbench.common.meta.impl.SWGanttProcess;
	import com.maninsoft.smart.workbench.common.meta.impl.SWPackage;
	import com.maninsoft.smart.workbench.common.meta.impl.SWProcess;
	
	import flash.events.Event;
	
	public dynamic class MISPackageEvent extends Event
	{
		
		public static const ADD_PROCESS:String = "addProcess";
		public static const ADD_FORM:String = "addForm";
		public static const REMOVE_PROCESS:String = "removeProcess";
		public static const REMOVE_FORM:String = "removeForm";
		
		public static const DEPLOY_GANTT_PACKAGE:String = "deployGanttPackage";
		
		public static const LOAD_PACKAGE:String = "loadPackage";
		
		public static const SUCESS:String = "sucessService";
		public static const FAULT:String = "faultService";
		
		public var packMetaModel:SWPackage;
		public var swPackages:Array;
		public var msg:String;
		
		public var prcId:String;
		public var formId:String;		
		
		public var swForm:SWForm;
		public var swProcess:SWProcess;
		public var swGanttProcess:SWGanttProcess;
		
		public function MISPackageEvent(type:String, packMetaModel:SWPackage){
			this.packMetaModel = packMetaModel;		
			super(type);
		}
		
	}
}