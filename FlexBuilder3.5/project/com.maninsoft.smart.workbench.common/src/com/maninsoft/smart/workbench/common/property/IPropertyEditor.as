
package com.maninsoft.smart.workbench.common.property
{
	import com.maninsoft.smart.workbench.common.property.page.PropertyPageItem;
	
	public interface IPropertyEditor /*extends IEventDispatcher*/ {
		
		/**
		 * 편집기를 표시하고 입력 가능한 상태로 만든다.
		 */
		function activate(pageItem: PropertyPageItem): void;
		/**
		 * 편집기를 숨긴다.
		 */
		function deactivate(): void;
		/**
		 * 편집기에 값을 가져오거나 설정한다.
		 */
		function get editValue(): Object;
		function set editValue(val: Object): void;

		/**
		 * 크기와 위치를 지정한다.
		 */		
		function setBounds(x: Number, y: Number, width: Number, height: Number): void;
		/**
		 * 수정 가능 상태를 지정한다.
		 */
		function setEditable(val: Boolean): void;
		/**
		 * 프로퍼티페이지에서 직접 값을 입력하는 것이 아니라, 대화상자를 띄워서 값을 설정한다.
		 */
		function get isDialog(): Boolean;
	}
}