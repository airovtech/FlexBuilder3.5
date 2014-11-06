package com.maninsoft.smart.workbench.common.meta.impl
{
	import com.maninsoft.smart.workbench.common.meta.AbstractPackageChildResourceMeta;
	import com.maninsoft.smart.workbench.common.meta.IProcessMetaModel;
	import com.maninsoft.smart.workbench.common.meta.SmartModelConstant;
	import com.maninsoft.smart.workbench.common.assets.WorkbenchIconLibrary;
	
	public class SWProcess extends AbstractPackageChildResourceMeta implements IProcessMetaModel
	{
		public function SWProcess()
		{
			this.type = SmartModelConstant.PROCESS_TYPE;
		}
				
		public override function get icon():Class{
			//return (this.status == STATUS_CHECKED_OUT)?WorkbenchIconLibrary.PROCESS_LOCAL_ICON:WorkbenchIconLibrary.PROCESS_REMOTE_ICON;
			return null;
		}

		public static function parseXML(prcXML:XML):SWProcess{
			if(prcXML != null && prcXML.id.toString() != ""){
				var swPrc:SWProcess = new SWProcess();
				parseChildResource(swPrc, prcXML);
				
				swPrc.id = prcXML.processId;
				return swPrc;	
			}
			return null;			
		}
	}
}