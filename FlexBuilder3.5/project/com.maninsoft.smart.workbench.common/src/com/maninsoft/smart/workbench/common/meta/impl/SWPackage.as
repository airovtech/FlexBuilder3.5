package com.maninsoft.smart.workbench.common.meta.impl
{
	import com.maninsoft.smart.workbench.common.assets.WorkbenchIconLibrary;
	import com.maninsoft.smart.workbench.common.meta.AbstractResourceMetaModel;
	import com.maninsoft.smart.workbench.common.meta.IFormMetaModel;
	import com.maninsoft.smart.workbench.common.meta.IPackageMetaModel;
	import com.maninsoft.smart.workbench.common.meta.IProcessMetaModel;
	
	import mx.collections.ArrayCollection;
	import mx.events.PropertyChangeEvent;
	
	public class SWPackage extends AbstractResourceMetaModel implements IPackageMetaModel
	{
		public static const SWPACKAGE_STATUS_CHECKED_IN:String = "CHECKED-IN";
		public static const SWPACKAGE_STATUS_CHECKED_OUT:String = "CHECKED-OUT";
		public static const SWPACKAGE_STATUS_DEPLOYED:String = "DEPLOYED";

		public static const SUBPROCESS_ID_PREFIX:String = "sub_";
		
		private var processResource:IProcessMetaModel;
		private var formResources:ArrayCollection = new ArrayCollection();
		
		public function SWPackage(){
		}
				
		public function getProcessResource():IProcessMetaModel{
			return this.processResource;
		}
		public function clearProcessResource():void{
			this.processResource = null;
			dispatchEvent(new PropertyChangeEvent("propertyChange"));
		}
		public function setProcessResource(processResource:IProcessMetaModel):void{
			if(processResource != null){
				processResource.setPackage(this);				
			}		
			this.processResource = processResource;
			dispatchEvent(new PropertyChangeEvent("propertyChange"));	
		}

		public function addFormResource(formResource:IFormMetaModel, num:int = -1):void{
			if(formResource != null){
				formResource.setPackage(this);
				if(num == -1 || this.formResources.length <= num)
					this.formResources.addItem(formResource);
				else
					this.formResources.addItemAt(formResource, num);
				dispatchEvent(new PropertyChangeEvent("propertyChange"));	
			}			
		}
		public function removeFormResource(formResource:IFormMetaModel):void{
			var num:int = -1;
			if((num = this.formResources.getItemIndex(formResource)) != -1){
				this.formResources.removeItemAt(num);
				dispatchEvent(new PropertyChangeEvent("propertyChange"));
			}
		}
		public function removeFormResourceByNum(num:int):void{
			if(num < this.formResources.length){
				this.formResources.removeItemAt(num);
				dispatchEvent(new PropertyChangeEvent("propertyChange"));
			}	
		}		
		public function getFormResource(num:int):IFormMetaModel{
			if(num < this.formResources.length)
				return IFormMetaModel(this.formResources.getItemAt(num));
			return null;	
		}
		public function getFormResources():ArrayCollection{
			return this.formResources;
		}
		
		public function get children():ArrayCollection{
			var _children:ArrayCollection = new ArrayCollection();
			
			if(this.processResource != null)
				_children.addItem(this.processResource);

			for each(var formResource:IFormMetaModel in this.formResources){
				_children.addItem(formResource);				
			}			
			return _children;
		}
		
		public override function get icon():Class{
			//return WorkbenchIconLibrary.PACKAGE_ICON;
			return null;
		}
		
		public override function toXML():XML{
			var packXML:XML = 
			<swPackage id="" name="" type="" createdTime="" creator="" description="">
			</swPackage>;
			
			packXML.@id = this.id;
			packXML.@name = this.name;
			packXML.@type = this.type;
			packXML.@createdTime = this.createdTime;
			packXML.@creator = this.creator;
			packXML.@description = this.description;
			
			return packXML;
		}
		
		public static function parseXML(packXML:XML):SWPackage{
			var swPack:SWPackage = new SWPackage();			
			parseResource(swPack, packXML.Package[0]);
			swPack.id = packXML.Package.packageId;
			swPack.type = packXML.Package.type;
			swPack.setProcessResource(SWProcess.parseXML(packXML.Process[0]));
			for each (var formXML:XML in packXML.forms.Form){
				swPack.addFormResource(SWForm.parseXML(formXML));
			}			
			return swPack;
		}
	}
}