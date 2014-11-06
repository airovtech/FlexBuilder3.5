
package com.maninsoft.smart.workbench.common.property
{
	import mx.controls.Image;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	/**
	 * 기본 IPropertyInfo
	 */
	public class PropertyInfo implements IPropertyInfo {

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _resourceManager:IResourceManager;

		private var _id: String;
		private var _displayName: String;
		private var _category: String;
		private var _description: String;
		private var _helpId: String;
		private var _editable: Boolean;


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function PropertyInfo(id: String, displayName: String, 
		                               description: String = null,
		                               category: String = null,
		                               editable: Boolean = true,
		                               helpId: String = null) {
			super();

			_resourceManager = ResourceManager.getInstance();
						
			_id = id;
			_displayName = displayName;
			_description = description;
			_category = category;
			_editable = editable;
			_helpId = helpId;
		}


		//----------------------------------------------------------------------
		// IPropertyInfo
		//----------------------------------------------------------------------
		
		public function get resourceManager():IResourceManager{
			if(_resourceManager==null)
				_resourceManager = ResourceManager.getInstance();
			return _resourceManager;
		}
		/**
		 * 프로퍼티의 아이덴터티
		 */
		public function get id(): String {
			return _id;
		}
		
		/**
		 * 프로퍼티 편집기 등에 표시될 프로퍼트이 표시명
		 */
		public function get displayName(): String {
			return _displayName;
		}
		
		/**
		 * 프로퍼티가 속한 분류의 이름
		 * 프로퍼티 편집기 등에서 같은 분류에 속한 프로퍼티들을 묶어서 표시할 수 있을 것이다.
		 */
		public function get category(): String {
			return _category;
		}
		
		public function set category(value: String): void {
			_category = value;
		}
		
		/**
		 * 프로퍼티의 간략한 설명
		 * 프로퍼티 편집기 등에 표시될 수 있다.
		 */
		public function get description(): String {
			return _description;
		}
		
		public function set description(value: String): void {
			_description = value;
		}
		
		/**
		 * 프로퍼티와 관련된 도움말 시스템의 id
		 */
		public function get helpId(): String {
			return _helpId;
		}
		
		public function set helpId(value: String): void {
			_helpId = value;
		}
		
		/**
		 * 사용자가 수정 가능한가?
		 */
		public function get editable(): Boolean {
			return _editable;
		}
		
		public function set editable(value: Boolean): void {
			_editable = value;
		}
		
		/**
		 * 프로퍼티 값 value를 문자열로 나타낸다.
		 */
		public function getText(value: Object): String {
			return (value != null) ? value.toString() : "";
		}
		
		/**
		 * 프로퍼티 값 value를 이미지로 나타낸다.
		 */
		public function getImage(value: Object): Image {
			return null;
		}
		
		/**
		 * 프로퍼티를 편집하는 에디터를 리턴한다.
		 * 수정 불가능한 프로퍼티라면 null을 리턴한다.
		 */
		public function getEditor(source: IPropertySource): IPropertyEditor {
			return null;
		}

		/**
		 * null을 리턴하면 기본 page item으로 생성된다.
		 */
		public function get pageItemClass(): Class {
			return null;
		}
		
	}
}