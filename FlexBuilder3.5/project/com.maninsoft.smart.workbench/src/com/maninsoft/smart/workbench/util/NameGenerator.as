package com.maninsoft.smart.workbench.util
{
	import com.maninsoft.smart.modeler.xpdl.model.process.WorkflowProcess;
	import com.maninsoft.smart.modeler.xpdl.model.process.XPDLPackage;
	import com.maninsoft.smart.workbench.common.meta.impl.SWForm;
	import com.maninsoft.smart.workbench.common.meta.impl.SWPackage;
	
	public class NameGenerator
	{
		/**
		 * 프로세스  이름 생성
		 **/
		public static function generateProcessName(swPack:SWPackage):String
		{
			return WorkbenchConfig.PROCESS_NAME
		}
		/**
		 * 간트프로세스  이름 생성
		 **/
		public static function generateGanttProcessName(swPack:SWPackage):String
		{
			return WorkbenchConfig.GANTTPROCESS_NAME
		}
		/**
		 * 폼 이름 생성
		 **/
		public static function generateFormName(swPack:SWPackage):String
		{
			var i:int = 1;
			
			var exist:Boolean = false;
			
			do{
				exist = false;
				for each(var swForm:SWForm in swPack.getFormResources()){
					if(WorkbenchConfig.FORM_NAME_PREFIX + i == swForm.name){
						i++;
						exist = true;	
						break;	
					}
				}	
			}while(exist);
			
			return WorkbenchConfig.FORM_NAME_PREFIX + i;
		}
		/**
		 * 내부 서스프로세스 이름
		 **/
		public static function generateInternalProcessName(xpdlpackage: XPDLPackage):String
		{
			var i:int = 1;
			
			var exist:Boolean = false;
			
			do{
				exist = false;
				for each(var process:WorkflowProcess in xpdlpackage.processes){
					if(WorkbenchConfig.INTERNAL_PROCESS_NAME_PREFIX + i == process.id){
						i++;
						exist = true;	
						break;	
					}
				}	
			}while(exist);
			
			return WorkbenchConfig.INTERNAL_PROCESS_NAME_PREFIX + i;
		}
	}
}