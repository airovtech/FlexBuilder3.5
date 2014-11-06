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
	import com.maninsoft.smart.modeler.common.ObjectBase;
	import com.maninsoft.smart.workbench.common.assets.PropertyIconLibrary;
	import com.maninsoft.smart.workbench.common.property.IPropertySource;
	
	import mx.resources.ResourceManager;
	
	/**
	 * 태스크 업무화면
	 */
	public class TaskForm extends ObjectBase implements IPropertySource {
		
		//----------------------------------------------------------------------
		// Class consts
		//----------------------------------------------------------------------
		
		public static const PROCESS_FORM	: String = "PROCESS";
		public static const SINGLE_FORM	: String = "SINGLE";
		public static const NONE_FORM	: String = "NONE";
		public static const EMPTY_FORM_NAME:String = ResourceManager.getInstance().getString("WorkbenchETC", "emptyFormNameText");;

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		public var id: String;
		public var packageId: String;
		public var formId: String;
		public var version: String;
		public var name: String;
		public var status: String;
		public var creator: String;
		public var type: String;

		public var loaded: Boolean=false;
		
		private var _children: Array = [];

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function TaskForm() {
			super();
		}

		
		
		//----------------------------------------------------------------------
		// IPropertySource
		//----------------------------------------------------------------------

		public function get displayName(): String {
			return resourceManager.getString("ProcessEditorETC", "workFormText");
		}

		public function get label(): String {
			return name;
		}
		
		public function get icon(): Class {
			if(this.type == TaskForm.NONE_FORM){
				return PropertyIconLibrary.formDisassignedIcon;
			}else{
				return PropertyIconLibrary.formAssignedIcon;
			}
		}
		/**
		 * children
		 */
		public function get children(): Array {
			return _children;
		}

		/**
		 * 프로퍼티 소스가 제공하는 IPropertyInfo 목록
		 */
		public function getPropertyInfos(): Array {
			/*
			if (!_propInfos) {
				_propInfos = createPropertyInfos();
			}
			
			return _propInfos;
			*/
			return [];
		}

		public function refreshPropertyInfos(): Array{
			return getPropertyInfos();
		}
		
		protected function createPropertyInfos(): Array {
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
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * 단위업무인가?
		 */
		public function get isSingle(): Boolean {
			return type == SINGLE_FORM;
		}
		
		
		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
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
		
		public function clone():TaskForm{
			var taskForm:TaskForm = new TaskForm();
			taskForm.id = this.id;			
			taskForm.packageId = this.packageId;			
			taskForm.formId = this.formId;			
			taskForm.version = this.version;			
			taskForm.name = this.name;			
			taskForm.status = this.status;			
			taskForm.creator = this.creator;			
			taskForm.type = this.type;			
			return taskForm;
		}
	}
}