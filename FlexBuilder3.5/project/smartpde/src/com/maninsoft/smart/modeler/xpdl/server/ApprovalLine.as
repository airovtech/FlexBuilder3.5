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
	import com.maninsoft.smart.workbench.common.property.IPropertySource;
	
	/**
	 * 태스크 업무화면
	 */
	public class ApprovalLine extends ObjectBase implements IPropertySource {
		
		//----------------------------------------------------------------------
		// Class consts
		//----------------------------------------------------------------------
		
		public static const EMPTY_APPROVAL	: String = "EMPTYAPPROVAL";


		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		public var id: String;
		public var name: String;
		public var description: String;
		public var approvalLevel:String;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function ApprovalLine() {
			super();
		}

		
		
		//----------------------------------------------------------------------
		// IPropertySource
		//----------------------------------------------------------------------

		public function get displayName(): String {
			return resourceManager.getString("ProcessEditorETC", "approvalLineText");
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
	}
}