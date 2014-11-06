package mxmlComponet.home.chartInfo.axis{
	import com.maninsoft.smart.common.event.CustormEvent;
	
	import mx.controls.Label;
	import mx.core.UIComponent;
	import mx.core.IUIComponent;
	import mx.effects.Rotate;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import smartWork.custormObj.CssLoader;

	public class CustormLabel extends UIComponent{
		public var label:Label;
		private var _columnId:String;
		private var _columnName:String;
		public var angle:Number = 0;
		public var widthAndHeightChange:Boolean = false;
		public var rotateble:Boolean = false;
		
		public function CustormLabel(){
//			CssLoader.cssLoad();
		}
		
		public function set columnId(id:String):void{
			_columnId = id;
		}
		
		public function set columnName(name:String):void{
			_columnName = name;
			label.text = name;
		}
		
		private function doDragEnter(event:DragEvent):void{
			if(event.dragSource.hasFormat("columnInfo")){
				DragManager.acceptDragDrop(IUIComponent(event.target));
			}
        }
	        
        private function doDragOver(event:DragEvent):void{
        }
        
        private function doDragDrop(event:DragEvent):void{
			var dgRow:Object=new Object();
          	dgRow=event.dragSource.dataForFormat("columnInfo");
          	_columnId = dgRow[0].id;
          	_columnName = dgRow[0].name;
          	label.text = dgRow[0].name;
          	
			var eventObj:CustormEvent = new CustormEvent("custormItemChange");
			eventObj["columnId"] = dgRow[0].id;
			eventObj["columnName"] = dgRow[0].name;
			eventObj["columnType"] = dgRow[0].type;
			dispatchEvent(eventObj);
        }
		
		override protected function createChildren(): void {
			super.createChildren();
			
			label = new Label();
			label.styleName = "customTextStyle";

			if(rotateble){
				var rotate:Rotate = new Rotate(label);
				rotate.angleFrom = 0;
	    		rotate.angleTo = angle;
	    		rotate.duration = 1;
				rotate.play();
			}
			addChild(label);
			
			this.addEventListener(DragEvent.DRAG_DROP, doDragDrop);
			this.addEventListener(DragEvent.DRAG_OVER, doDragOver);
			this.addEventListener(DragEvent.DRAG_ENTER, doDragEnter);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number): void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(widthAndHeightChange){
				label.width  = this.width;
				label.height = this.height;
				label.x = this.x;
				label.y = this.y;
			}else{
				label.width = this.width;
				label.height = this.height;
			}
		}
	}
}