package com.maninsoft.smart.workbench.common.property
{
	/**
	 * 프로퍼티 편집기 등에서 표시되고 편집될 프로퍼티들을 제공하는
	 * 개체들이 구현해야 할 인터페이스
	 */
	public interface IPropertySource {
		
		/**
		 * 프로퍼터 편집기 등에서 표시할 이름
		 */
		function get displayName(): String;
		/**
		 * 프로퍼티 소스가 제공하는 IPropertyInfo 목록
		 */
		function getPropertyInfos(): Array;
		/**
		 * 프로퍼티 소스가 제공하는 IPropertyInfo 목록
		 */
		function refreshPropertyInfos(): Array;
		/**
		 * id 에 해당하는 프로퍼티의 현재 값을 리턴
		 */
		function getPropertyValue(id: String): Object;
		/**
		 * id 에 해당하는 프로퍼티의 값을 설정
		 */
		function setPropertyValue(id: String, value: Object): void;
		/**
		 * 현재 프로퍼티의 값이 기본값과 다른 값으로 설정되어 있는가?
		 * 의미있는 기본값이 존재하지 않는 프로퍼티라면 true를 리턴한다.
		 */
		function isPropertySet(id: String): Boolean;
		/**
		 * 기본값으로 reset 가능한 프로퍼티인가?
		 */
		function isPropertyResettable(id: String): Boolean;
		/**
		 * 프로퍼티의 값을 기본값으로 변경
		 */
		function resetPropertyValue(id: Object): void;
	}
}