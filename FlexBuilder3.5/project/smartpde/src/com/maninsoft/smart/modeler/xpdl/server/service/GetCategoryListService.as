package com.maninsoft.smart.modeler.xpdl.server.service
{
	import com.maninsoft.smart.workbench.common.model.WorkCategory;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.StringUtil;
	
	/**
	 * 작업 폼 목록을 내려받는 서비스
	 */
	public class GetCategoryListService extends ServiceBase
	{
		//----------------------------------------------------------------------
		// Service parameters
		//----------------------------------------------------------------------

		public var compId: String;
		public var userId: String;
		public var categoryId: String;
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private const ROOT_CATEGORY:String = "RootCategory";
		private var _categories: Array;
		private var _method:String;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function GetCategoryListService(parentId:String=null) {
			if(!parentId) parentId = ROOT_CATEGORY;
			(parentId == ROOT_CATEGORY) ? _method="retrieveRootCategory" : _method="retrieveChildrenByCategoryId";
			super(_method);
			this.categoryId = parentId;
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * forms
		 */
		public function get categories(): Array{
			return _categories;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override protected function get params(): Object {
			var obj: Object = new Object();
			
			obj.compId = compId;
			obj.userId = userId;
			if(categoryId != ROOT_CATEGORY)
				obj.categoryId = categoryId;
			
			return obj;
		}
		
		override protected function doResult(event:ResultEvent): void {
			trace(event);
			
			var xml: XML = new XML(StringUtil.trim(event.message.body.toString()));
			_categories = [];
			
			for each (var x: XML in xml.category) {
				var category: WorkCategory = new WorkCategory();
				category.parseXML(x);
				_categories.push(category);	
			}
			
			super.doResult(event);
		}
		
		override protected function doFault(event:FaultEvent): void {
			trace("GetCategoryListServce: " + event);
			
			super.doFault(event);
		}
	}
}