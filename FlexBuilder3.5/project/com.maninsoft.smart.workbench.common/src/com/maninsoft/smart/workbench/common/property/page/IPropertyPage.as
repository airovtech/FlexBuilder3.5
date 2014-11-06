
package com.maninsoft.smart.workbench.common.property.page
{
	import com.maninsoft.smart.workbench.common.property.IPropertySource;
	
	/**
	 * IPropertySource의 프로퍼티들을 표시하고 편집하는 컴포넌트
	 */
	public interface IPropertyPage {
		
		function set propSource(value: IPropertySource): void;
	}
}