package com.maninsoft.smart.formeditor.layout.grid.util
{
	import com.maninsoft.smart.common.assets.Cursors;
	import com.maninsoft.smart.formeditor.layout.IFormContainerLayoutView;
	import com.maninsoft.smart.formeditor.layout.grid.view.FormGridItemView;
	import com.maninsoft.smart.formeditor.util.FormSelectionBox;
	import com.maninsoft.smart.formeditor.view.FormDocumentView;
	import com.maninsoft.smart.formeditor.view.ISelectableView;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.managers.CursorManager;
	
	public class FormGridItemSelectionBox extends FormSelectionBox
	{
		public static var formDocumentView:FormDocumentView;
		public static var layoutView:IFormContainerLayoutView;
		
		public static function registerSelectionHandler(_formDocumentView:FormDocumentView, selectView:ISelectableView):void
		{
			if(selectView is FormGridItemView){
				formDocumentView = _formDocumentView;
					
				formDocumentView.selectBoxLBottom.addEventListener(MouseEvent.MOUSE_DOWN, resizeVStart);
				formDocumentView.selectBoxLBottom.addEventListener(MouseEvent.MOUSE_MOVE, resizeVCursor);
				formDocumentView.selectBoxLBottom.addEventListener(MouseEvent.MOUSE_OUT, resizeCursorOut);
				formDocumentView.selectBoxLBottom.addEventListener(MouseEvent.MOUSE_UP, resizeEnd);
					
				formDocumentView.selectBoxCBottom.addEventListener(MouseEvent.MOUSE_DOWN, resizeVStart);
				formDocumentView.selectBoxCBottom.addEventListener(MouseEvent.MOUSE_MOVE, resizeVCursor);
				formDocumentView.selectBoxCBottom.addEventListener(MouseEvent.MOUSE_OUT, resizeCursorOut);
				formDocumentView.selectBoxCBottom.addEventListener(MouseEvent.MOUSE_UP, resizeEnd);

				var selectItemView:FormGridItemView = selectView as FormGridItemView;
				if(FormGridUtil.isLastGridItem(selectItemView.gridCell)){		
					formDocumentView.selectBoxRBottom.addEventListener(MouseEvent.MOUSE_DOWN, resizeVStart);
					formDocumentView.selectBoxRBottom.addEventListener(MouseEvent.MOUSE_MOVE, resizeVCursor);
					formDocumentView.selectBoxRBottom.addEventListener(MouseEvent.MOUSE_OUT, resizeCursorOut);
					formDocumentView.selectBoxRBottom.addEventListener(MouseEvent.MOUSE_UP, resizeEnd);	
				}else{
					formDocumentView.selectBoxRTop.addEventListener(MouseEvent.MOUSE_DOWN, resizeHStart);
					formDocumentView.selectBoxRTop.addEventListener(MouseEvent.MOUSE_MOVE, resizeHCursor);
					formDocumentView.selectBoxRTop.addEventListener(MouseEvent.MOUSE_OUT, resizeCursorOut);
					formDocumentView.selectBoxRTop.addEventListener(MouseEvent.MOUSE_UP, resizeEnd);
						
					formDocumentView.selectBoxRMid.addEventListener(MouseEvent.MOUSE_DOWN, resizeHStart);
					formDocumentView.selectBoxRMid.addEventListener(MouseEvent.MOUSE_MOVE, resizeHCursor);
					formDocumentView.selectBoxRMid.addEventListener(MouseEvent.MOUSE_OUT, resizeCursorOut);
					formDocumentView.selectBoxRMid.addEventListener(MouseEvent.MOUSE_UP, resizeEnd);
	
					formDocumentView.selectBoxRBottom.addEventListener(MouseEvent.MOUSE_DOWN, resizeLRStart);
					formDocumentView.selectBoxRBottom.addEventListener(MouseEvent.MOUSE_MOVE, resizeLRCursor);
					formDocumentView.selectBoxRBottom.addEventListener(MouseEvent.MOUSE_OUT, resizeCursorOut);
					formDocumentView.selectBoxRBottom.addEventListener(MouseEvent.MOUSE_UP, resizeEnd);	
				}

				formDocumentView.layoutView.addEventListener(MouseEvent.MOUSE_UP, resizeEnd);
				formDocumentView.layoutView.addEventListener(MouseEvent.MOUSE_MOVE, resizeOver);
					
				formDocumentView.addEventListener(MouseEvent.MOUSE_UP, resizeEnd);
				formDocumentView.addEventListener(MouseEvent.MOUSE_MOVE, resizeOver);
				formDocumentView.addEventListener(MouseEvent.MOUSE_OUT, resizeOutEnd);
			}							
		}
			
		 /****************************리사이즈********************************/
		public static const H_TYPE:String = "h";
		public static const V_TYPE:String = "v";
		public static const LR_TYPE:String = "lr";
		public static const RL_TYPE:String = "rl";
		public static const CURSOR_XOFFSET:Number = -8; 
		public static const CURSOR_YOFFSET:Number = -8; 
			
		public static var locX:int;
		public static var locY:int;
			
		public static var type:String;
		public static var resizeViewer:FormGridItemView;
			
		private static function resizeHStart(event:MouseEvent):void{
			if(FormGridUtil.isLastGridItem(FormGridItemView(formDocumentView.selectionViewer).gridCell))
				return;
			var startPoint:Point = formDocumentView.localToGlobal(new Point(formDocumentView.selectBoxRTop.x, formDocumentView.selectBoxLBottom.y));
			locX = startPoint.x;
					
			locY = event.stageY;
					
			type = H_TYPE;
			resizeViewer = formDocumentView.selectionViewer as FormGridItemView;
			CursorManager.setCursor(Cursors.horisontal, 0, CURSOR_XOFFSET, CURSOR_YOFFSET);
		}
			
		private static function resizeVStart(event:MouseEvent):void{
			locX = event.stageX;
			var startPoint:Point = formDocumentView.localToGlobal(new Point(formDocumentView.selectBoxRTop.x, formDocumentView.selectBoxLBottom.y));
			locY = startPoint.y;
					
			type = V_TYPE;
			resizeViewer = formDocumentView.selectionViewer as FormGridItemView;
					
			CursorManager.setCursor(Cursors.vertical, 0, CURSOR_XOFFSET, CURSOR_YOFFSET);
		}
			
		private static function resizeLRStart(event:MouseEvent):void{
			if(FormGridUtil.isLastGridItem(FormGridItemView(formDocumentView.selectionViewer).gridCell))
				return;
			var startPoint:Point = formDocumentView.localToGlobal(new Point(formDocumentView.selectBoxRTop.x, formDocumentView.selectBoxLBottom.y));
			locX = startPoint.x;
			locY = startPoint.y;
					
			type = LR_TYPE;
			resizeViewer = formDocumentView.selectionViewer as FormGridItemView;
			CursorManager.setCursor(Cursors.leftRight, 0, CURSOR_XOFFSET, CURSOR_YOFFSET);
		}
			
		private static function resizeRLStart(event:MouseEvent):void{
			locX = event.stageX;
			locY = event.stageY;
					
			type = RL_TYPE;
			resizeViewer = formDocumentView.selectionViewer as FormGridItemView;
			CursorManager.setCursor(Cursors.rightLef, 0, CURSOR_XOFFSET, CURSOR_YOFFSET);
		}
			
		private static function resizeHCursor(event:MouseEvent):void{
			CursorManager.setCursor(Cursors.horisontal, 0, CURSOR_XOFFSET, CURSOR_YOFFSET);
		}
			
		private static function resizeVCursor(event:MouseEvent):void{
			CursorManager.setCursor(Cursors.vertical, 0, CURSOR_XOFFSET, CURSOR_YOFFSET);				
		}
			
		private static function resizeLRCursor(event:MouseEvent):void{
			CursorManager.setCursor(Cursors.leftRight, 0, CURSOR_XOFFSET, CURSOR_YOFFSET);
		}
			
		private static function resizeRLCursor(event:MouseEvent):void{
			CursorManager.setCursor(Cursors.rightLef, 0, CURSOR_XOFFSET, CURSOR_YOFFSET);
		}
			
		private static function resizeEnd(event:MouseEvent):void{
			if(type != null && resizeViewer != null){

				var formGridItemView:FormGridItemView = resizeViewer as FormGridItemView;

				var endPoint:Point = formDocumentView.localToGlobal(new Point(formDocumentView.selectBoxRTop.x, formDocumentView.selectBoxLBottom.y));
					
//						var newWidth:Number = this.selectBox8.x - this.selectBox1.x;
//						var diffWidth:Number = event.stageX - locX;
				var diffWidth:Number = endPoint.x - locX;
						
//						var newHeight:Number = this.selectBox8.y - this.selectBox1.y;
//						var newHeight:Number = formGridItemView.gridCell.gridRow.size + event.stageY - locY;
				var newHeight:Number = formGridItemView.gridCell.gridRow.size + endPoint.y - locY;
											
				var command:Command;
				if(type == H_TYPE){
					command = FormGridCommandUtil.updateColumnSizeCommand(formGridItemView.gridCell.gridRow.gridLayout, formGridItemView.gridCell.gridRow.getCellIndex(formGridItemView.gridCell) + formGridItemView.gridCell.span - 1, diffWidth);
				}else if(type == V_TYPE){
					command = FormGridCommandUtil.updateRowSizeCommand(formGridItemView.gridCell.gridRow.gridLayout, formGridItemView.gridCell.gridRow.gridLayout.getRowIndex(formGridItemView.gridCell.gridRow), newHeight);
				}else if(type == LR_TYPE){
					command = FormGridCommandUtil.updateColumnSizeCommand(formGridItemView.gridCell.gridRow.gridLayout, formGridItemView.gridCell.gridRow.getCellIndex(formGridItemView.gridCell) + formGridItemView.gridCell.span - 1, diffWidth);
					command = command.chain(FormGridCommandUtil.updateRowSizeCommand(formGridItemView.gridCell.gridRow.gridLayout, formGridItemView.gridCell.gridRow.gridLayout.getRowIndex(formGridItemView.gridCell.gridRow), newHeight));
				}
					formDocumentView.editDomain.getCommandStack().execute(command);
					
				releaseResizeEnd();					
			}								
		}
			
		private static function resizeOver(event:MouseEvent):void{
				
			if(type != null && resizeViewer != null){
				var newWidth:int = resizeViewer.width;
				var newHeight:int = resizeViewer.height;
				trace(newWidth);
//						var mousePoint:Point = this.globalToLocal(new Point(event.stageX, event.stageY));
				var mousePoint:Point = new Point(event.stageX, event.stageY);
				if(type == H_TYPE){
					newWidth += mousePoint.x - locX;
				}else if(type == V_TYPE){
					newHeight += mousePoint.y - locY;
				}else if(type == LR_TYPE){
					newWidth += mousePoint.x - locX;
					newHeight += mousePoint.y - locY;
				}
				trace(newWidth);
				formDocumentView.drawSelection(resizeViewer, newWidth, newHeight);
			}
		}
		
		private static function resizeOutEnd(event:MouseEvent):void{
			if(event.target is DisplayObject && !(formDocumentView.containThis(DisplayObject(event.target)))){
				releaseResizeEnd();
			}				
		}
			
		public static function releaseResizeEnd():void{
			resizeViewer.gridCell.select(true);
				
			type = null;
			resizeViewer = null;		
			CursorManager.removeAllCursors();	
				
		}
			
		public static function resizeCursorOut(event:MouseEvent):void{
			if(type == null || resizeViewer == null){
				CursorManager.removeAllCursors();	
			}				
		}
	}
}