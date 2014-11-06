////////////////////////////////////////////////////////////////////////////////
//  DiagramObject.as
//  2007.12.13, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.model
{
	import com.maninsoft.smart.modeler.common.ObjectBase;
	import com.maninsoft.smart.workbench.common.property.IPropertySource;
	
	import flash.geom.Rectangle;
	
	
	/**
	 * Diagram과 Diagram의 구성 개체들을 나타내는 모델들을 우힌 기본 클래스
	 * (Command 호출을 통해) 모델이 생성/삭제되거나 값의 변경이 이루어지면
	 * 이벤트가 발생되고, 이 이벤트들은 컨트롤러들에게 전달된다.
	 * 컨트롤러들은 모델과 연결된 뷰의 모습이나 상태를 변경시킨다.  
	 * 모델은 뷰를 전혀 참조해서는 안된다.
	 * 
	 * 외부 --> Command --> 모델 --> 컨트롤러 --> 뷰
	 */
	public class DiagramObject extends ObjectBase implements IPropertySource {
		

		//----------------------------------------------------------------------
		// Class constants
		//----------------------------------------------------------------------

		public static const EMPTY_BOUNDS: Rectangle = new Rectangle(0, 0, 0, 0);
		public static const EMPTY_STRING: String = "";

		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _propInfos: Array;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function DiagramObject() {
			super();
		}
		
		
		//----------------------------------------------------------------------
		// IPropertySource
		//----------------------------------------------------------------------

		public function get displayName(): String {
			return getClassName();
		}

		/**
		 * 프로퍼티 소스가 제공하는 IPropertyInfo 목록
		 */
		public function getPropertyInfos(): Array {
			if (!_propInfos) {
				_propInfos = createPropertyInfos();
			}
			
			return _propInfos;
		}
		
		public function refreshPropertyInfos(): Array {
			_propInfos = createPropertyInfos();
			return _propInfos;
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

		public function get diagram(): Diagram {
			return null;
		}
		
		public function get bounds(): Rectangle {
			return EMPTY_BOUNDS;
		}

		
		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		
		/**
		 * 다른 DiagramObject로 부터 값들을 가져온다.
		 */
		public function assign(source: DiagramObject): void {
		}

		/**
		 * (x, y) ==> (y, x)
		 */
		public function changeXY(): void {
		}
	}
}