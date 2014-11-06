
package com.maninsoft.smart.workbench.common.property
{
	import mx.controls.Image;
	
	/**
	 * 프로퍼티 편집기 등에서 표시되고 편집될 프로퍼티의 정보
	 */
	public interface IPropertyInfo {
		
		/**
		 * 프로퍼티의 아이덴터티
		 */
		function get id(): String;
		/**
		 * 프로퍼티 편집기 등에 표시될 프로퍼트이 표시명
		 */
		function get displayName(): String;
		/**
		 * 프로퍼티가 속한 분류의 이름
		 * 프로퍼티 편집기 등에서 같은 분류에 속한 프로퍼티들을 묶어서 표시할 수 있을 것이다.
		 */
		function get category(): String;
		/**
		 * 프로퍼티의 간략한 설명
		 * 프로퍼티 편집기 등에 표시될 수 있다.
		 */
		function get description(): String;
		/**
		 * 프로퍼티와 관련된 도움말 시스템의 id
		 */
		function get helpId(): String;
		/**
		 * 편집 가능한가?
		 */
		function get editable(): Boolean;
		/**
		 * 프로퍼티 값 value를 문자열로 나타낸다.
		 */
		function getText(value: Object): String;
		/**
		 * 프로퍼티 값 value를 이미지로 나타낸다.
		 */
		function getImage(value: Object): Image;
		/**
		 * 프로퍼티를 편집하는 에디터를 리턴한다.
		 * 수정 불가능한 프로퍼티라면 null을 리턴한다.
		 */
		function getEditor(source: IPropertySource): IPropertyEditor;
		/**
		 * page item 클래스
		 */
		function get pageItemClass(): Class;
	}
}