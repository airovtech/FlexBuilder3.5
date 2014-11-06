////////////////////////////////////////////////////////////////////////////////
//  SizePropertyEditor.as
//  2008.01.28, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.workbench.common.property
{
	import com.maninsoft.smart.workbench.common.util.Size;
	
	/**
	 * 문자열 속성을 편집하는 에디터
	 */
	public class SizePropertyEditor extends TextPropertyEditor implements IPropertyEditor	{

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function SizePropertyEditor() {
			super();
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		/**
		 * 편집기에 값을 가져오거나 설정한다.
		 */
		override public function get editValue(): Object {
			return Size.parse(this.text);
		}
		
		override public function set editValue(val: Object): void {
			this.text = val.toString();	
		}
	}
}