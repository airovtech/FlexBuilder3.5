package portalAs.gridComponent{
	import flash.events.MouseEvent;
	
	public class EmbedGridUtil{
		public function EmbedGridUtil(){
			public static function findDataGrid(evt:MouseEvent):DataGrid{
				return DataGrid(UIComponent(UIComponent(UIComponent(evt.target).parent).parent).parent);
			}
		}
	}
}