package mxmlComponet.home.chartInfo.util{
	public class XmlUtil{
		public function XmlUtil(){
		}
		
		public static function startCdataTag():String{
			return "<![CDATA[";
		}
		
		public static function endCdataTag():String{
			return "]]>";
		}
	}
}