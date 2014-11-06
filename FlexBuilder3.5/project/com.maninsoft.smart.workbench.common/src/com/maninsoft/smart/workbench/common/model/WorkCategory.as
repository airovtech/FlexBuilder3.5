////////////////////////////////////////////////////////////////////////////////
//  Department.as
//  2008.04.08, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.workbench.common.model
{
	import com.maninsoft.smart.workbench.common.assets.WorkbenchIconLibrary;
	
	import mx.resources.ResourceManager;
	
	/**
	 * 업무 카테고리 모델
	 */
	public class WorkCategory {

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		public const WORK_CATEGORY_ROOT:String = "_PKG_ROOT_";
		public const WORK_CATEGORY_DEFAULT_NAME:String = "기본";
		public const WORK_CATEGORY_DOWNLOADED_NAME:String = "[받은업무]";

		private var _children: Array = [];


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function WorkCategory() {
			super();
		}

		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		public var loaded: Boolean;
		
		public var id: String;
		
		public var name: String;
		
		public var parentId: String;
		
		public var displayOrder: int;
		
		public var description: String;
		
		public function get label(): String {
			return name;
		}
		
		public function get icon(): Class {
			return WorkbenchIconLibrary.categoryIcon;
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
			_children = _children.concat(items);
		}
		
		public function parseXML(xml:XML):void{
			if(xml){
 				this.id = xml.@objId;
 				this.name = xml.@name;
 				if(this.id == WORK_CATEGORY_ROOT)
 					this.name = ResourceManager.getInstance().getString("WorkbenchETC", "rootCategoryNameText");
 				else if(this.name == WORK_CATEGORY_DEFAULT_NAME)
 					this.name = ResourceManager.getInstance().getString("WorkbenchETC", "defaultCategoryNameText");
 				else if(this.name == WORK_CATEGORY_DOWNLOADED_NAME)
 					this.name = ResourceManager.getInstance().getString("WorkbenchETC", "downloadedCategoryNameText");
 				this.parentId = xml.@parentId;
 				this.description = xml.description;
 			}			
		}
	}
}