package mxmlComponet.gadget.chart{
	import mx.collections.ArrayList;
	import mx.collections.XMLListCollection;
	import mx.controls.DataGrid;
	import mx.controls.Label;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.resources.ResourceManager;
	
	import smartWork.util.StringTokenizer;
	public class ChartXmlUtil{
		public function ChartXmlUtil():void{}
		
		public static function xyMakeTitle(xmlResult:XML, xTitle:Label, yTitle:Label):void {
			xTitle.text = xmlResult.groupingDefineName;
			yTitle.text = xmlResult.valueInfoDefineName;	
		}
		
		public static function unitTitle(xmlResult:XML, unitInfo:Label):void {
			var token:StringTokenizer = new StringTokenizer(xmlResult.valueInfoDefineUnit, "|");
			if(token.getTokenCount>1){
				token.nextToken();
				unitInfo.text = ResourceManager.getInstance().getString("ChartGadgetETC", "UnitInfoText") + " : " + xmlResult.valueInfoDefineName + "(" + token.nextToken() + ")";
			}
		}
		
		public static function makeChartXml(type:ChartType, xmlResult:XML, tranceXml:XML, tranceResArray:Array=null, repeatCount:int=0):void {
			if(xmlResult.@dimension == 3){
				makeChartXmlDepth3(type, xmlResult, tranceXml, tranceResArray, repeatCount);
			}else if(xmlResult.@dimension == 2){
				makeChartXmlDepth2(type, xmlResult, tranceXml, tranceResArray, repeatCount);
			}else if(xmlResult.@dimension == 1){
				//makeChartXmlDepth3(xmlResult, tranceXml);
			}
		}
		
		private static function makeChartXmlDepth3(type:ChartType, xmlResult:XML, tranceXml:XML, tranceResArray:Array=null, repeatCount:int=0):void{
			var resList:XMLList = xmlResult.grouping.name;
			var tranceResXml:XML = <chartInfo></chartInfo>;
			for(var t:int=0; t<resList.length(); t++){
				tranceXml.appendChild("<res cycle=\"" + resList[t] + "\"/>");
				if(tranceResArray)
					tranceResXml.appendChild("<res cycle=\"" + resList[t] + "\"/>");
			}
			
			var arr:ArrayList = new ArrayList();
			var accList:XMLList = xmlResult.grouping.remark.name;
			var eqaulBool:Boolean = false;
			for(var i:int=0; i<accList.length(); i++){
				if(i==0){
					arr.addItem(accList[i]);
					tranceXml.appendChild("<act name=\"item" + i + "\">" + accList[i] + "</act>");
				}
				for(var k:int=0; k<arr.length; k++){
					if(accList[i] == arr.getItemAt(k)){
						eqaulBool = true;
					}
				}
				
				if(!eqaulBool){
					arr.addItem(accList[i]);
					tranceXml.appendChild("<act name=\"item" + i + "\">" + accList[i] + "</act>");
				}
				eqaulBool = false;
			}
			
			var itemList:XMLList = xmlResult.grouping.remark.value;
			var resCou:int = 0;
			var itemCou:int = 0;
			for(var j:int=0; j<itemList.length(); j++){
				resCou = j/arr.length;
				tranceXml.res[resCou].appendChild("<item" + itemCou + ">" + itemList[j] + "</item" + itemCou + ">");
				itemCou++;
				if(itemCou == arr.length){
					itemCou = 0;
				}
			}
			
			if(tranceResArray){
				for(var cnt:int=0; cnt<repeatCount; cnt++){
					var resXml:XML = new XML(tranceResXml);
					for(resCou=0, itemCou=0, j=0; j<itemList.length(); j++){
						resCou = j/arr.length;
						resXml.res[resCou].appendChild("<item" + itemCou + ">" + itemList[j]*(cnt+1)/repeatCount + "</item" + itemCou + ">");
						itemCou++;
						if(itemCou == arr.length){
							itemCou = 0;
						}
					}
					tranceResArray.push(resXml);
				}
			}
		}
		
		private static function makeChartXmlDepth2(type:ChartType, xmlResult:XML, tranceXml:XML, tranceResArray:Array=null, repeatCount:int=0):void{
			var resList:XMLList = xmlResult.grouping.name;
			var itemList:XMLList = xmlResult.grouping.value;
			var tranceResXml:XML = <chartInfo></chartInfo>;
			if(type.data != ChartTypes.pieChartType.data){
				tranceXml.appendChild("<act name=\"item0\"></act>");
				for(var i:int=0; i<resList.length(); i++){
					tranceXml.appendChild("<res cycle=\"" + resList[i] + "\"/>");
					if(tranceResArray){
						tranceResXml.appendChild("<res cycle=\"" + resList[i] + "\"/>");
					}
					tranceXml.res[i].appendChild("<item0>" + itemList[i] + "</item0>");
				}
				if(tranceResArray){
					for(var cnt:int=0; cnt<repeatCount; cnt++){
						var resXml:XML = new XML(tranceResXml);
						for( i=0; i<resList.length(); i++){
							resXml.res[i].appendChild("<item0>" + itemList[i]*(cnt+1)/repeatCount + "</item0>");
						}
						tranceResArray.push(resXml);
					}
				}
			}else{
				for(var j:int=0; j<resList.length(); j++){
					tranceXml.appendChild("<res value=\"" + itemList[j] + "\"/>");
					tranceXml.res[j].appendChild("<name><![CDATA[" + resList[j] + "]]></name>");
				}
			}
		}
		
//		private static function makeChartXmlDepth1(xmlResult:XML, tranceXml:XML):void{
//			tranceXml.appendChild("<act name=\"item0\"></act>");
//			tranceXml.appendChild("<res cycle=\"\"/>");
//			var itemList:XMLList = xmlResult.items.item.value;
//			for(var i:int=0; i<itemList.length(); i++){
//				tranceXml.res[i].appendChild("<item0>" + itemList[i] + "</item0>");
//			}
//		}

		public static function makeGrid(xmlResult:XML, grid:DataGrid):void {
			var columnInfoList:XMLListCollection = new XMLListCollection(xmlResult.columnInfos.column);
			var colWidth:Number = grid.width/(columnInfoList.length);
			var columnId:String;
			for(var i:int=0; i<columnInfoList.length; i++){
				var comp:DataGridColumn = new DataGridColumn();
				comp.headerText = columnInfoList[i];
				comp.dataField = columnInfoList[i].@id;
				comp.setStyle("textAlign", "center");
				var arr:Array = grid.columns;
				arr.push(comp);
				grid.columns = arr;
			}
		}
		
		public static function makeMatrixXml(xmlResult:XML, tranceXml:XML):void{
			if(xmlResult.@dimension == 3){
				makeMatrixXmlDepth3(xmlResult, tranceXml);
			}else if(xmlResult.@dimension == 2){
				makeMatrixXmlDepth2(xmlResult, tranceXml);
			}
        }    
        
        public static function makeMatrixXmlDepth3(xmlResult:XML, tranceXml:XML):void{
        	tranceXml.appendChild("<defineInfo></defineInfo>");
        	tranceXml.appendChild("<dataInfo></dataInfo>");
        	
        	var groupingDefine:String = xmlResult.groupingDefineName;
			var remarkDefine:String = xmlResult.remarkDefineName;	
			var valueInfoDefine:String = xmlResult.valueInfoDefineName;
        	var accList:XMLList = xmlResult.grouping.remark.name;
        	var itemList:XMLList = xmlResult.grouping.remark.value;
        	var resList:XMLList = xmlResult.grouping.name;
        	                              
        	tranceXml.defineInfo[0].appendChild('<xAxis><![CDATA[' + groupingDefine +']]></xAxis>');
        	tranceXml.defineInfo[0].appendChild('<yAxis><![CDATA[' + remarkDefine + ']]></yAxis>');
        	tranceXml.defineInfo[0].appendChild('<measure check="N"><![CDATA[' + valueInfoDefine + '값]]></measure>');
        	tranceXml.defineInfo[0].appendChild('<measureUnit><![CDATA[none]]></measureUnit>');
        	
        	var cou:int = 0;
			for(var i:int=0; i<accList.length(); i++){
				cou = i/(itemList.length()/resList.length());
				var data:String = groupingDefine + ":" + resList[cou] + "," + remarkDefine + ":" + accList[i] + "," + valueInfoDefine + "값:" + itemList[i];
				tranceXml.dataInfo[0].appendChild('<item><![CDATA[' + data + ']]></item>');
			}
        }    
        
        public static function makeMatrixXmlDepth2(xmlResult:XML, tranceXml:XML):void{
        	tranceXml.appendChild("<defineInfo></defineInfo>");
        	tranceXml.appendChild("<dataInfo></dataInfo>");
        	
        	var groupingDefine:String = xmlResult.groupingDefineName;
			var valueInfoDefine:String = xmlResult.valueInfoDefineName;
        	var itemList:XMLList = xmlResult.grouping.value;
        	var resList:XMLList = xmlResult.grouping.name;
        	                              
        	tranceXml.defineInfo[0].appendChild('<xAxis><![CDATA[' + groupingDefine +']]></xAxis>');
        	tranceXml.defineInfo[0].appendChild('<yAxis><![CDATA[]]></yAxis>');
        	tranceXml.defineInfo[0].appendChild('<measure check="R"><![CDATA[' + valueInfoDefine + ']]></measure>');
        	tranceXml.defineInfo[0].appendChild('<measureUnit><![CDATA[none]]></measureUnit>');
        	
			for(var i:int=0; i<itemList.length(); i++){
				var data:String = groupingDefine + ":" + resList[i] + "," + valueInfoDefine + ":" + itemList[i];
				tranceXml.dataInfo[0].appendChild('<item><![CDATA[' + data + ']]></item>');
			}
        }    
	}
}