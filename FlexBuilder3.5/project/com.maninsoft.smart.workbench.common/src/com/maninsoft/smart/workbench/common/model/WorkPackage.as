package com.maninsoft.smart.workbench.common.model
{
	import com.maninsoft.smart.workbench.common.assets.WorkbenchIconLibrary;
	
	import mx.resources.ResourceManager;
	
	/**
	 * 업무 카테고리 모델
	 */
	public class WorkPackage {

		private var _children: Array;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function WorkPackage() {
			super();
		}

		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		public static const PACKAGE_TYPE_SINGLE:String = "SINGLE";
		public static const PACKAGE_TYPE_PROCESS:String = "PROCESS";
		public static const PACKAGE_TYPE_GANTT:String = "GANTT";
		
		public static const INTERNAL_PROCESS_ID:String = "InternalProcess";
		public static const INTERNAL_PROCESS_NAME:String = ResourceManager.getInstance().getString("WorkbenchETC", "internalProcessText");
		public static const INTERNAL_GANTT_NAME:String = ResourceManager.getInstance().getString("WorkbenchETC", "internalGanttText");
		public static const EMPTY_WORK_ID:String = "EmptyWork";
		public static const EMPTY_WORK_NAME:String = ResourceManager.getInstance().getString("WorkbenchETC", "emptyWorkText");

		
		public var loaded: Boolean=true;
		public var id: String;
		public var version:String;
		public var name: String;
		public var formId:String;
		public var categoryId:String;
		public var categoryName:String;
		public var status:String;
		public var type:String;
		
		public function get label(): String {
			return name;
		}
		
		public function get icon(): Class {
			if(type == PACKAGE_TYPE_SINGLE){
				return WorkbenchIconLibrary.informationWorkIcon;
			}else if(type == PACKAGE_TYPE_PROCESS){
				return WorkbenchIconLibrary.processWorkIcon;
			}else if(type == PACKAGE_TYPE_GANTT){
				return WorkbenchIconLibrary.ganttWorkIcon;
			}
			return null;
		}
		
		public function get children(): Array {
			return _children;
		}
		
		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		
		public function clearChildren(): void {
			_children = [];
		}
		
		public function addItems(items: Array): void {
			if(!_children) clearChildren();
			_children = _children.concat(items);
		}
		
		public function parseXML(xml:XML):void{
			if(xml){
				this.id = xml.@packageId;
				this.version = xml.@version;
				this.name = xml.@name;
				this.formId = xml.@ext_formId;
				this.categoryId = xml.@categoryId;
				this.categoryName = xml.@ext_categoryName;
				this.status = xml.@status;
				this.type = xml.@type;
			}
		}
	}
}