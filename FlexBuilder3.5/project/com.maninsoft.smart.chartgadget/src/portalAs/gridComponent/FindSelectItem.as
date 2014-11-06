package portalAs.gridComponent
{
	import mx.collections.ArrayCollection;
	import mx.controls.DataGrid;
	
	import portalAs.commonModel.GridDataProviderModel;
	
	public class FindSelectItem{
		public static function  getSelectItemId(dataGrid:DataGrid):String{
			var selectId:String;
			var arr:ArrayCollection = ArrayCollection(dataGrid.dataProvider);
			var gp:GridDataProviderModel;
			for(var i:int; i<arr.length; i++){
				gp = GridDataProviderModel(arr.getItemAt(i));
				if(gp.isChecked){
					selectId = gp.id;
					break;
				}
			}
			return selectId;
		} 
		
		public static function  getSelectItemObject(dataGrid:DataGrid):GridDataProviderModel{
			var arr:ArrayCollection = ArrayCollection(dataGrid.dataProvider);
			var gp:GridDataProviderModel;
			var selectedGp:GridDataProviderModel;
			for(var i:int; i<arr.length; i++){
				gp = GridDataProviderModel(arr.getItemAt(i));
				if(gp.isChecked){
					selectedGp = gp;
					break;
				}
			}
			return selectedGp;
		} 
		
		public static function  getArraySelectItemId(dataGrid:DataGrid):Array{
			var selectIdArr:Array = new Array();
			var arr:ArrayCollection = ArrayCollection(dataGrid.dataProvider);
			var gp:GridDataProviderModel;
			for(var i:int; i<arr.length; i++){
				gp = GridDataProviderModel(arr.getItemAt(i));
				if(gp.isChecked){
					selectIdArr.push(gp.id);
				}
			}
			return selectIdArr;
		}
		
		public static function  getArraySelectItemObject(dataGrid:DataGrid):Array{
			var selectIdArr:Array = new Array();
			var arr:ArrayCollection = ArrayCollection(dataGrid.dataProvider);
			var gp:GridDataProviderModel;
			for(var i:int; i<arr.length; i++){
				gp = GridDataProviderModel(arr.getItemAt(i));
				if(gp.isChecked){
					selectIdArr.push(gp);
				}
			}
			return selectIdArr;
		}
	}
}