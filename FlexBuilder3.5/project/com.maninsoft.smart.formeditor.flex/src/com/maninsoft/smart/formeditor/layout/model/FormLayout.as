package com.maninsoft.smart.formeditor.layout.model
{
	import com.maninsoft.smart.formeditor.model.SelectableModel;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridLayout;
	import com.maninsoft.smart.formeditor.model.IFormContainer;
	
	public class FormLayout extends SelectableModel
	{
		public static const GRID:String = "grid_layout";
		public static const ABSOLUTE:String = "absolute_layout";
		public static const AUTO:String = "auto_layout";
		
		private var _container:IFormContainer;

		public function set container(container:IFormContainer):void{
		    this._container = container;
		}
		public function get container():IFormContainer{
		    return this._container;
		}
		
		/**
		 * XML로 변환
		 */ 		
		public function toXML():XML{
			return null;
		}	
		/**
		 * XML을 객체로 생성
		 */
		public static function parseXML(layoutXML:XML):FormLayout{
			if(layoutXML.@type == FormLayout.GRID){
				return FormGridLayout.parseXML(layoutXML);
			}
			return null;
		}	
	}
}