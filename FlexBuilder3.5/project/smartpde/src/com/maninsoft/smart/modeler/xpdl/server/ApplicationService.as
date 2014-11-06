////////////////////////////////////////////////////////////////////////////////
//  TaskForm.as
//  2008.01.30, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.server
{
	import com.maninsoft.smart.modeler.assets.XPDLEditorAssets;
	import com.maninsoft.smart.modeler.common.ObjectBase;
	import com.maninsoft.smart.workbench.common.property.IPropertySource;
	
	/**
	 * 태스크 업무화면
	 */
	public class ApplicationService extends ObjectBase implements IPropertySource {
		
		//----------------------------------------------------------------------
		// Class consts
		//----------------------------------------------------------------------
		
		public static const EMPTY_APPLICATION_SERVICE: String = "EMPTYSERVICE";

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		public var id: String;
		public var name: String;
		public var url: String;
		public var editMethod: String;
		public var viewMethod: String;
		public var editParams: Array;
		public var viewParams: Array;
		public var returnParams: Array;
		public var description: String;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function ApplicationService() {
			super();
		}
/*
		public function get editParams(): Array{
			return this.editParams;
		}
		
		public function set editParams(params: Array) : void{
			this.editParams = params;
		}
*/		
		//----------------------------------------------------------------------
		// IPropertySource
		//----------------------------------------------------------------------

		public function get displayName(): String {
			return resourceManager.getString("ProcessEditorETC", "applicationServiceText");
		}

		public function get label(): String {
			return name;
		}
		
		public function get icon(): Class {
			return XPDLEditorAssets.taskCustomFormIcon;
		}

		/**
		 * 프로퍼티 소스가 제공하는 IPropertyInfo 목록
		 */
		public function getPropertyInfos(): Array {
			return [];
		}
		
		public function refreshPropertyInfos(): Array{
			return getPropertyInfos();
		}
		
		public function createPropertyInfos(): Array {
			return [];
		}
		
		/**
		 * id 에 해당하는 프로퍼티의 현재 값을 리턴
		 */
		public function getPropertyValue(id: String): Object {
			return null;
		}
		
		/**
		 * id 에 해당하는 프로퍼티의 값을 설정
		 */
		public function setPropertyValue(id: String, value: Object): void {
		}
		
		/**
		 * 현재 프로퍼티의 값이 기본값과 다른 값으로 설정되어 있는가?
		 * 의미있는 기본값이 존재하지 않는 프로퍼티라면 true를 리턴한다.
		 */
		public function isPropertySet(id: String): Boolean {
			return true;
		}
		
		/**
		 * 기본값으로 reset 가능한 프로퍼티인가?
		 */
		public function isPropertyResettable(id: String): Boolean {
			return false;
		}
		
		/**
		 * 프로퍼티의 값을 기본값으로 변경
		 */
		public function resetPropertyValue(id: Object): void {
		}

		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		public function clone():ApplicationService{
			var applicationService:ApplicationService = new ApplicationService();
			applicationService.id = this.id;			
			applicationService.name = this.name;			
			applicationService.url = this.url;			
			applicationService.editMethod = this.editMethod;			
			applicationService.viewMethod = this.viewMethod;			
			applicationService.editParams = this.editParams;			
			applicationService.viewParams = this.viewParams;			
			applicationService.returnParams = this.returnParams;			
			applicationService.description = this.description;			
			return applicationService;
		}
	}
}