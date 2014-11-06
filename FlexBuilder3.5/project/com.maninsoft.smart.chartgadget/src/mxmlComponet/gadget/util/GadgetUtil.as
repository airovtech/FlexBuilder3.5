package mxmlComponet.gadget.util{
	import flash.utils.*;
	
	import mx.collections.ArrayCollection;
	import mx.collections.XMLListCollection;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	
	import mxmlComponet.gadget.column.SupperGadgetColumns;
	import mxmlComponet.gadget.declaration.GadgetDeclaration;
	import mxmlComponet.gadget.model.GadgetColumn;
	import mxmlComponet.gadget.model.GadgetContent;
	
	import smartWork.custormObj.GadgetPanel;
	import smartWork.util.StringTokenizer;
	
	public class GadgetUtil{
		
		public static function coulmnFilter(columnsArr:Array, grid:DataGrid, gadget:GadgetPanel):void{
			gadget.columnsIdArr = "";
			var colWidth:Number = grid.width/(columnsArr.length);
			for(var i:int=0; i<columnsArr.length; i++){
				var comp:DataGridColumn = new DataGridColumn();
				var col:GadgetColumn = GadgetColumn(columnsArr[i])
				comp.headerText = col.name;
				comp.dataField = col.id;
				comp.setStyle("textAlign", "center");
				var arr:Array = grid.columns;
				arr.push(comp);
				grid.columns = arr;
				if(i==0){
					gadget.columnsIdArr += col.id;
				}else{
					gadget.columnsIdArr += "," + col.id;
				}
			}
			
			var colArr:Array = grid.columns;
			for(var k:int=0; k<colArr.length; k++){
				if(k==0){
					DataGridColumn(colArr[k]).width = 0;
				}else{
					DataGridColumn(colArr[k]).width = 100;	
				}
			}
			grid.columns = colArr;
		}
		
		public static function getGadgetColumns(gadgetName:String):SupperGadgetColumns{
			var gadgetDeclaration:GadgetDeclaration = new GadgetDeclaration()
			var gac:GadgetContent;
			var gadgetColumns:SupperGadgetColumns;
			for(var i:int=0; i<gadgetDeclaration.gadgetContents.length; i++){
				gac = GadgetContent(gadgetDeclaration.gadgetContents.getItemAt(i));
				if(gac.className == gadgetName){
					break;
				}
			}
			var clazz:Class = Class(getDefinitionByName(gac.columnName));
			gadgetColumns = SupperGadgetColumns(new clazz());
			return gadgetColumns;
		} 
		
		public static function searchColumns(gadgetName:String, columnsIdArr:String, grid:DataGrid, gadget:GadgetPanel):void{
			var selArr:Array = new Array();
			var gcu:ArrayCollection = getGadgetColumns(gadgetName).getColumnArray();
			var token:StringTokenizer = new StringTokenizer(columnsIdArr, ",");
			var columnId:String;
			while(token.hasMoreTokens()){
				columnId = token.nextToken();
				for(var k:int=0; k<gcu.length; k++){
					var ga:GadgetColumn = GadgetColumn(gcu.getItemAt(k));
					if(ga.id == String(columnId)){
						selArr.push(ga);
						break;
					}
				}
			}
			coulmnFilter(selArr, grid, gadget);
		}
		
		public static function formCoulmnFilter(columnsId:String, grid:DataGrid, gadget:GadgetPanel, headXml:XML):void{
			var token:StringTokenizer = new StringTokenizer(columnsId, ",");
			var colWidth:Number = grid.width/(token.getTokenCount);
			var columnId:String;
			var headList:XMLListCollection = new XMLListCollection(headXml.header);
			while(token.hasMoreTokens()){
				columnId = token.nextToken();
				var comp:DataGridColumn = new DataGridColumn();
				comp.headerText = getHeandName(headList, columnId);
				comp.dataField = columnId;
				comp.setStyle("textAlign", "center");
				var arr:Array = grid.columns;
				arr.push(comp);
				grid.columns = arr;
			}
			
			var colArr:Array = grid.columns;
			for(var k:int=0; k<colArr.length; k++){
				if(k==0){
					DataGridColumn(colArr[k]).width = 0;
				}else{
					DataGridColumn(colArr[k]).width = 100;	
				}
			}
			grid.columns = colArr;
		}
		
		public static function getHeandName(headList:XMLListCollection, headId:String):String{
			var returnName:String="";
			for(var i:int=0; i<headList.length; i++){
				if(headId==headList[i].@id){
					returnName = headList[i].@name;
					break;
				}
			}
			return returnName;
		}
	}
}