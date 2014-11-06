package com.maninsoft.smart.formeditor.refactor.component.model
{
	import com.maninsoft.smart.formeditor.refactor.component.unit.TextFont;
	import com.maninsoft.smart.formeditor.refactor.component.unit.TextSize;
	
	public class TextStyleModel 
	{
		public static const LEFT:String="left";
		public static const CENTER:String="center";
		public static const RIGHT:String="right";
		
		public var color:Number;
		
		public var align:String = LEFT;
		
		public var bold:Boolean = false;
		public var italic:Boolean = false;
		public var underline:Boolean = false;
		
		public var font:String = TextFont.DEFAULT_FONT;
		
		public var size:String = TextSize.DEFAULT_SIZE;
		
		public function clone():TextStyleModel{
			var textModel:TextStyleModel = new TextStyleModel();
			
			textModel.color = this.color;
			textModel.align = this.align;
			
			textModel.bold = this.bold;
			textModel.italic = this.italic;
			textModel.underline = this.underline;
			
			textModel.font = this.font;
			textModel.size = this.size;
			
			return textModel;
		}
		
		/**
		 * XML로 변환
		 */ 		
		public function toXML():XML{
			var entityXML:XML = 
				<textStyle size="" color="" align="" bold="" italic="" underline="">
					<font></font>
				</textStyle>;
			
			entityXML.@size = size;
			entityXML.@color = color;
			entityXML.@align = align;
			entityXML.@bold = (bold)?"true":"false";
			entityXML.@italic = (italic)?"true":"false";
			entityXML.@underline = (underline)?"true":"false";
			
			entityXML.font[0] = font;
						
			return entityXML;
		}	
		/**
		 * XML을 객체로 생성
		 */
		public static function parseXML(entityXML:XML):TextStyleModel{
			var textStyleModel:TextStyleModel = new TextStyleModel();
			
			textStyleModel.size = entityXML.@size;
			textStyleModel.color = new int(entityXML.@color);
			textStyleModel.align = entityXML.@align;
			textStyleModel.bold = (entityXML.@bold == "true");
			textStyleModel.italic = (entityXML.@italic == "true");
			textStyleModel.underline = (entityXML.@underline == "true");
			
			textStyleModel.font = entityXML.font[0].toString();
			
			return textStyleModel;
		}
	}
}