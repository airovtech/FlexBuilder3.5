package com.maninsoft.smart.formeditor.view.util
{
	import com.maninsoft.smart.formeditor.assets.FormEditorAssets;
	import com.maninsoft.smart.formeditor.layout.grid.view.FormGridCanvas;
	import com.maninsoft.smart.formeditor.layout.grid.view.FormGridContainer;
	import com.maninsoft.smart.formeditor.layout.grid.view.FormGridRowView;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Image;
	import mx.controls.LinkButton;
	import mx.resources.ResourceManager;
	
	public class CellsToolBox
	{
		private static var parent:DisplayObjectContainer;
		private static var gridRowView:FormGridRowView;
		
		private static var toolBox:VBox;
		private static var mergeCellButton:LinkButton;
		private static var divider:Image;
		
		public static function show(_parent:DisplayObjectContainer, _gridRowView:FormGridRowView, stageX:Number, stageY:Number):void {
			// 유효성 체크
			if (_parent == null || _gridRowView == null)
				return;
			parent = _parent;
			gridRowView = _gridRowView;
			
			// 셀병합 버튼
			if (mergeCellButton == null) {
				divider = new Image();
				divider.source = FormEditorAssets.dividerIcon;
				mergeCellButton = new LinkButton();
				mergeCellButton.toolTip = ResourceManager.getInstance().getString("FormEditorETC", "cellMergeUnmergeText");
				mergeCellButton.styleName = "mergeCellButton";
				mergeCellButton.setStyle("paddingLeft", 0);
				mergeCellButton.setStyle("paddingTop", 0);
				mergeCellButton.setStyle("paddingRight", 0);
				mergeCellButton.setStyle("paddingBottom", 0);
				mergeCellButton.addEventListener(MouseEvent.CLICK, mergeCell);
			}
			
			// 화면에 보여질 버튼 박스
			if (toolBox == null) {
				toolBox = new VBox();
				toolBox.width = 20;
				toolBox.setStyle("horizontalGap", 8);
				toolBox.setStyle("horizontalAlign", "middle");
				toolBox.setStyle("verticalAlign", "top");
				toolBox.setStyle("borderThickness", 0);
				toolBox.setStyle("paddingLeft", 0);
				toolBox.setStyle("paddingTop", 0);
				toolBox.setStyle("paddingRight", 0);
				toolBox.setStyle("paddingBottom", 0);
			} else if (parent.contains(toolBox)) {
				parent.removeChild(toolBox);
			}
			parent.addChild(toolBox);
			if (!toolBox.contains(mergeCellButton)){
				toolBox.addChild(divider);
				toolBox.addChild(mergeCellButton);
			}
			toolBox.visible = true;
		}
		
		public static function hide():void{
			if (toolBox != null)
				toolBox.visible = false;
		}
		
		private static function mergeCell(e:MouseEvent):void {
			// TODO 
			var table:FormGridContainer = gridRowView.parent as FormGridContainer;
			var canvas:FormGridCanvas = table.parent as FormGridCanvas;
		}
	}
}