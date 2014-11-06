package com.maninsoft.smart.workbench.common.meta.impl
{
	import com.maninsoft.smart.workbench.common.meta.AbstractPackageChildResourceMeta;
	import com.maninsoft.smart.workbench.common.meta.IFormMetaModel;
	import com.maninsoft.smart.workbench.common.meta.SmartModelConstant;
	import com.maninsoft.smart.workbench.common.assets.WorkbenchIconLibrary;
	
	public class SWForm extends AbstractPackageChildResourceMeta implements IFormMetaModel
	{
		public static const FORMTYPE_PROCESS:String="process";
		public static const FORMTYPE_SINGLE:String="single";
		
		private var _formType:String = FORMTYPE_PROCESS;
		private var _swWorkType:SWWorkType;
		
		[Bindable]
		public function set swWorkType(swWorkType:SWWorkType):void{
			this._swWorkType = swWorkType;
		}
		public function get swWorkType():SWWorkType{
			return this._swWorkType;
		}		
		
		[Bindable]
		public function set formType(formType:String):void{
			this._formType = formType;
		}
		public function get formType():String{
			return this._formType;
		}
		
		public function SWForm()
		{
			this.type = SmartModelConstant.FORM_TYPE;
		}
		
		public override function get icon():Class{
			//return (this.status == STATUS_CHECKED_OUT)?WorkbenchIconLibrary.FORM_LOCAL_ICON:WorkbenchIconLibrary.FORM_REMOTE_ICON;
			return null;
		}
		
		public static function parseXML(formXML:XML):SWForm{
			if(formXML != null && formXML.id.toString() != ""){
				var swForm:SWForm = new SWForm();
				parseChildResource(swForm, formXML);
				
				swForm.id = formXML.formId;
				swForm.uid = formXML.id;
				swForm.formType = formXML.type;
				return swForm;	
			}
			return null;			
		}
	}
}