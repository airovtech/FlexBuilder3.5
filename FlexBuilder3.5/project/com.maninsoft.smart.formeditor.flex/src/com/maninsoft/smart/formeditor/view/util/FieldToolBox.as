package com.maninsoft.smart.formeditor.view.util
{
	import com.maninsoft.smart.formeditor.FormEditorBase;
	import com.maninsoft.smart.formeditor.layout.grid.view.FormGridItemView;
	import com.maninsoft.smart.formeditor.util.FormEditorInvoker;
	import com.maninsoft.smart.formeditor.util.FormEditorPopup;
	import com.maninsoft.smart.formeditor.view.FieldView;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.containers.HBox;
	import mx.controls.LinkButton;
	import mx.resources.ResourceManager;
	
	public class FieldToolBox
	{
		private static var parent:DisplayObjectContainer;
		private static var gridItemView:FormGridItemView;
		private static var fieldView:FieldView;
		
		private static var toolBox:HBox;
		private static var importButton:LinkButton;
		private static var exportButton:LinkButton;
		private static var removeBtn:LinkButton;
		
		private static const BUTTON_SIZE:Number = 16;
		private static const BUTTON_GAP:Number = 4;
		
		public static function show(_parent:DisplayObjectContainer, _gridItemView:FormGridItemView, stageX:Number, stageY:Number):void {
			// 유효성 체크
			if (_parent == null || _gridItemView == null)
				return;
			parent = _parent;
			gridItemView = _gridItemView;
			fieldView = gridItemView.fieldView;
			if (fieldView == null || fieldView.model == null)
				return;
			
			// 데이터가져오기 버튼
			if (importButton == null) {
				importButton = new LinkButton();
				importButton.toolTip = ResourceManager.getInstance().getString("FormEditorETC", "dataImportText");
				importButton.styleName = "importButton";
				importButton.addEventListener(MouseEvent.CLICK, popupInMappingMenu);
			}
			
			// 데이터내보내기 버튼
			if (exportButton == null) {
				exportButton = new LinkButton();
				exportButton.toolTip = ResourceManager.getInstance().getString("FormEditorETC", "dataExportText");
				exportButton.styleName = "exportButton";
				exportButton.addEventListener(MouseEvent.CLICK, popupOutMappingMenu);
			}
			
			// 항목삭제 버튼
			if (removeBtn == null) {
				removeBtn = new LinkButton();
				removeBtn.toolTip = ResourceManager.getInstance().getString("FormEditorETC", "removeItemText");
				removeBtn.styleName = "removeFieldButton";
				removeBtn.addEventListener(MouseEvent.CLICK, remove);
			}
			
			// 테이블포맷인 경우 내보내기 버튼을 disable 시킵니다.
			if (fieldView.model.format.type == "dataGrid") {
				exportButton.enabled = true;
				exportButton.alpha = 1;
			} else {
				exportButton.enabled = true;
				exportButton.alpha = 1;
			}
			
			// 화면에 보여질 버튼 박스
			if (toolBox == null) {
				toolBox = new HBox();
				toolBox.setStyle("horizontalGap", BUTTON_GAP);
				toolBox.setStyle("paddingLeft", 0);
				toolBox.setStyle("paddingTop", 0);
				toolBox.setStyle("paddingRight", 0);
				toolBox.setStyle("paddingBottom", 0);
			} else if (parent.contains(toolBox)) {
				parent.removeChild(toolBox);
			}
			parent.addChild(toolBox);
			if (!toolBox.contains(importButton))
				toolBox.addChild(importButton);
			if (!toolBox.contains(exportButton))
				toolBox.addChild(exportButton);
			if (!toolBox.contains(removeBtn))
				toolBox.addChild(removeBtn);
			toolBox.x = stageX + BUTTON_GAP;// + fieldView.width - (BUTTON_SIZE * 3) - (BUTTON_GAP * 2);
			toolBox.y = stageY - BUTTON_SIZE - BUTTON_GAP;
			toolBox.visible = true;
		}
		
		public static function hide():void{
			fieldView = null;
			if (toolBox != null)
				toolBox.visible = false;
		}
		
		private static function popupInMappingMenu(e:MouseEvent):void {
			var point:Point = toolBox.localToGlobal(new Point(importButton.x, importButton.y + importButton.height));
			FormEditorPopup.popupInMappingMenu(FormEditorBase.getInstance(), point.x, point.y, fieldView.model);
		}
		private static function popupOutMappingMenu(e:MouseEvent):void {
			var point:Point = toolBox.localToGlobal(new Point(exportButton.x, exportButton.y + exportButton.height));
			FormEditorPopup.popupOutMappingMenu(FormEditorBase.getInstance(), point.x, point.y, fieldView.model);
		}
		private static function remove(e:MouseEvent):void {
			FormEditorInvoker.removeField(fieldView.model);
			FieldToolBox.hide();
			gridItemView.gridCell.select(false);
		}
	}
}