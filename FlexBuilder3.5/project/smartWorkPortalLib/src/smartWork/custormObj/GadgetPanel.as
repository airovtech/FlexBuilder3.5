package smartWork.custormObj {
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.containers.Canvas;
	import mx.containers.Panel;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.core.Application;
	import mx.core.BitmapAsset;
	import mx.core.Container;
	import mx.core.DragSource;
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	import mx.events.DragEvent;
	import mx.events.EffectEvent;
	import mx.events.ResizeEvent;
	import mx.managers.CursorManager;
	import mx.managers.DragManager;
	
	import smartWork.custormObj.event.PanelEvent;
	
	[Event(name="panelClose", type="smartWork.custormObj.event")]
	
	public class GadgetPanel extends Panel {
		public var gadgetId:String;
		[Bindable] 
		public var showControls:Boolean = false; //title바에 최대화, 최소화 버튼이 활성여부
		[Bindable] 
		public var enableResize:Boolean = false; //사이즈 조절 여부
		[Bindable] 
		public var closeEnable:Boolean = false;  //닫기버튼 활성여부
		[Bindable] 
		public var insertEnable:Boolean = false; //Gadget LoyOut에서  Gadget사이에 끼워 넣기 가능여부(title바 부분에 drop하면 발생한다)
		[Bindable] 
		public var mainCanvas:Container; //Gadget이 배치되는 Gadget LoyOu의 인스턴스
		[Bindable] 
		public var parentCanvas:Container; //Gadget을 감싸주는 Canvas
		[Bindable] 
		public var layOutBox:Boolean = false;
		[Bindable] 
		public var columnsArr:Array; //사용자선택한 column정보
		[Bindable] 
		public var columnsIdArr:String; //사용자선택한 column정보
		[Bindable] 
		public var formId:String; //사용자선택한 Form정보
		[Bindable] 
		public var noneTitle:Boolean = false; //사용자선택한 Form정보
		[Embed(source="assets/img/resizeCursor.png")] private var resizeCursor:Class; //사이즈조절 버튼
		[Embed(source="assets/img/resource.gif")] private var dragClass:Class; //Drag시 이동되어지는 이미지
		private var	pTitleBar:UIComponent;  //상속받은 부모클래스 panel의  titleBar
		private var oW:Number; //사이즈 변경전 넓이
		private var oH:Number; //사이즈 변경전 높이
		private var oX:Number; //변경전 X축위치
		private var oY:Number; //변경전 Y축위치
		private var normalMinButton:Button	= new Button(); //최소화 버튼
		private var normalMaxButton:Button	= new Button(); //최대화 버튼
		private var closeButton:Button		= new Button(); //닫기 버튼
		private var resizeHandler:Button	= new Button(); //reSize버튼
		private var oPoint:Point 			= new Point(); //변경전 Point
		private var resizeCur:Number		= 0; //reSize변경 값
		private var format:String = "^";  //drag&drop 데이터구분포맷
		private var bigCanvas:Canvas; //최대사이즈 변경시 Gadget을 포함하는 Canvas
		private var tempTargetObj:Object; //drag해서 이동하는 Gadget
		private var shadowCanvas:Canvas; //Gadget과 Gadget사이 끼워 넣을때  임시로 생기는 Canvas.
		private var mainVerticalScrollPosition:int; //Gadget Layout의 수직 스크롤위치
		private var parentCanvasHeight:int = 0; //감싸고 있는 parent Canvas높이를  저장하는 변수
		
		/**
		 * 생성자
		 */
		public function GadgetPanel() {
			CssLoader.cssLoad();
		}
	
		override protected function measure():void {
			super.measure();
			this.measuredWidth = 100;
			this.measuredHeight = 100;
		}

		/**
		 * 초기에 인스턴스 생성시 panel구성한다.
		 */
		override protected function createChildren():void {
			super.createChildren();
			this.pTitleBar = super.titleBar;
			if(noneTitle){
				super.titleBar.height = 0;
				this.pTitleBar.height = 0;
			}
			this.parentCanvas = Container(this.parent);
			/*this.setStyle("headerColors", [0xC3D1D9, 0xD2DCE2]);
			this.setStyle("borderColor", 0xD2DCE2);
			this.setStyle("borderThicknessBottom", 5); 
			this.setStyle("borderThicknessLeft", 5); 
			this.setStyle("borderThicknessRight", 5); 
			this.setStyle("borderThicknessTop", 5); 
			this.setStyle("headerHeight", 24);글로벌스타일 적용(지웅)*/
			
			this.doubleClickEnabled = true;
			if (enableResize) {
				this.resizeHandler.width     = 12;
				this.resizeHandler.height    = 12;
				this.resizeHandler.styleName = "resizeHndlr";
				this.rawChildren.addChild(resizeHandler);
				this.initPos();
			}
			if (showControls) {
				this.normalMinButton.width     	= 10;
				this.normalMinButton.height    	= 10;
				this.normalMinButton.styleName 	= "minimizeBtn";
				this.normalMaxButton.width     	= 10;
				this.normalMaxButton.height    	= 10;
				this.normalMaxButton.styleName 	= "increaseBtn";
				this.closeButton.width     		= 10;
				this.closeButton.height    		= 10;
				this.closeButton.styleName 		= "closeBtn";
				if(this.closeEnable){
					this.pTitleBar.addChild(this.normalMaxButton);
					this.pTitleBar.addChild(this.closeButton);
				}else{
					this.pTitleBar.addChild(this.normalMaxButton);
				}
			}
			this.positionChildren();	
			this.addListeners();
		}
		
		/**
		 * 변경시 이전 상태를 저장한다.
		 */
		public function initPos():void {
			this.oW = this.width;
			this.oH = this.height;
			this.oX = this.x;
			this.oY = this.y;
		}
	
		/**
		 * 각종버튼들을 배치한다.
		 */
		public function positionChildren():void {
			if (showControls) {
				if(this.closeEnable){
					this.normalMaxButton.buttonMode    = true;
					this.normalMaxButton.useHandCursor = true;
					this.normalMaxButton.x = this.unscaledWidth - this.normalMaxButton.width - 24;
					this.normalMaxButton.y = 8;
					
					this.closeButton.buttonMode	   = true;
					this.closeButton.useHandCursor = true;
					this.closeButton.x = this.unscaledWidth - this.closeButton.width - 8;
					this.closeButton.y = 8;
				}else{
					this.normalMaxButton.buttonMode    = true;
					this.normalMaxButton.useHandCursor = true;
					this.normalMaxButton.x = this.unscaledWidth - this.normalMaxButton.width - 8;
					this.normalMaxButton.y = 8;
				}
			}
			if (enableResize) {
				this.resizeHandler.y = this.unscaledHeight - resizeHandler.height - 1;
				this.resizeHandler.x = this.unscaledWidth - resizeHandler.width - 1;
			}
			if(this.percentWidth.toString()=="NaN"){
				this.percentWidth = 100;
				this.percentHeight = 100;
			}
		}
		
		/**
		 * 이벤트를 등록한다.
		 */
		public function addListeners():void {
			this.addEventListener(MouseEvent.CLICK, panelClickHandler);
			this.addEventListener(ResizeEvent.RESIZE, doResize);
			this.pTitleBar.addEventListener(MouseEvent.MOUSE_DOWN, titleBarDownHandler);
			this.pTitleBar.addEventListener(MouseEvent.DOUBLE_CLICK, titleBarDoubleClickHandler);
			
			this.parentCanvas.addEventListener(DragEvent.DRAG_ENTER, doDragEnter);
			this.parentCanvas.addEventListener(DragEvent.DRAG_OVER, doDragOver);
			this.parentCanvas.addEventListener(DragEvent.DRAG_DROP, doDragDrop);
			
			if(insertEnable){
				this.pTitleBar.addEventListener(DragEvent.DRAG_ENTER, titleDoDragEnter);
				this.pTitleBar.addEventListener(DragEvent.DRAG_OVER, titleDoDragOver);
				//this.pTitleBar.addEventListener(DragEvent.DRAG_DROP, titleDoDragDrop);
			}
			
			if (showControls) {
				this.closeButton.addEventListener(MouseEvent.CLICK, closeClickHandler);
				this.normalMaxButton.addEventListener(MouseEvent.CLICK, normalMaxClickHandler);
			}
			
			if (enableResize) {
				this.resizeHandler.addEventListener(MouseEvent.MOUSE_OVER, resizeOverHandler);
				this.resizeHandler.addEventListener(MouseEvent.MOUSE_OUT, resizeOutHandler);
				this.resizeHandler.addEventListener(MouseEvent.MOUSE_DOWN, resizeDownHandler);
			}
		}
		
		private function doResize(event:ResizeEvent):void{
			GadgetPanel(event.target).positionChildren(); // this.positionChildren(); 와 같다.
        }
        
        private function doDragEnter(event:DragEvent):void{
			if(event.dragSource.hasFormat(format)){
				DragManager.acceptDragDrop(IUIComponent(event.target));
			}
        }
        
        private function doDragOver(event:DragEvent):void{
			scrollMove();
        }
        
        private function doDragDrop(event:DragEvent):void{
        	var targetCanvas:Canvas = Canvas(event.target);
			var obj:Object=new Object();
			obj=event.dragSource.dataForFormat(format);
			var moveCanvas:Canvas = Canvas(obj);	
			if(moveCanvas!=targetCanvas){
				var movePanel:GadgetPanel = GadgetPanel(moveCanvas.getChildAt(0));	 
				var targetPanel:GadgetPanel = GadgetPanel(targetCanvas.getChildAt(0));	
				try{
					moveCanvas.removeChild(movePanel);
					targetCanvas.removeChild(targetPanel);
				}catch(err:Error){}
				movePanel.parentCanvas = targetCanvas;
				targetPanel.parentCanvas = moveCanvas;
				moveCanvas.addChild(targetPanel);
				targetCanvas.addChild(movePanel);
			}
        }
        
        private function titleDoDragEnter(event:DragEvent):void{
			if(event.dragSource.hasFormat(format)){
				DragManager.acceptDragDrop(IUIComponent(event.target));
			}
        }
        
        private function titleDoDragOver(event:DragEvent):void{
        	scrollMove();
        	var obj:Object=new Object();
			obj=event.dragSource.dataForFormat(format);
			var moveCanvas:Canvas = Canvas(obj);
			var movePanel:GadgetPanel = GadgetPanel(moveCanvas.getChildAt(0));
			if(this!=movePanel && event.target!=this.tempTargetObj){
				this.tempTargetObj = event.target;
				if(this.shadowCanvas==null){
					this.shadowCanvas = new Canvas();
					this.shadowCanvas.width = movePanel.parentCanvas.width-3;
					this.shadowCanvas.height = movePanel.parentCanvas.height-3;
					this.shadowCanvas.setStyle("borderColor", 0xEFF0F1);
					this.shadowCanvas.setStyle("borderStyle", "solid");
					this.shadowCanvas.setStyle("backgroundAlpha", 0.7);
					this.shadowCanvas.setStyle("backgroundColor", 0xF7F6F6);
					this.shadowCanvas.addEventListener(DragEvent.DRAG_ENTER, shadowDoDragEnter);
					this.shadowCanvas.addEventListener(DragEvent.DRAG_OVER, shadowDoDragOver);
					this.shadowCanvas.addEventListener(DragEvent.DRAG_DROP, shadowDoDragDrop);
					this.shadowCanvas.addEventListener(MouseEvent.MOUSE_DOWN, shadowBarDownHandler);
				}
				this.parentCanvas.parent.addChildAt(this.shadowCanvas, this.parentCanvas.parent.getChildIndex(this.parentCanvas));
			}
        }
        
        private function titleDoDragDrop(event:DragEvent):void{
        	this.tempTargetObj = null;
        	if(this.layOutBox){
        		var targetObj:UIComponent = UIComponent(event.target);
				var obj:Object=new Object();
				obj=event.dragSource.dataForFormat(format);
				var moveCanvas:Canvas = Canvas(obj);	
				var movePanel:GadgetPanel = GadgetPanel(moveCanvas.getChildAt(0));
				if(moveCanvas!=targetObj.parent.parent){
					try{
						moveCanvas.parent.removeChild(moveCanvas);
					}catch(err:Error){}
					this.parentCanvas.parent.addChildAt(moveCanvas, this.parentCanvas.parent.getChildIndex(this.parentCanvas));
				}
        	}
        	if(this.shadowCanvas!=null){
        		this.parentCanvas.parent.removeChild(this.shadowCanvas);
        	}
        }
        
        
        private function shadowDoDragEnter(event:DragEvent):void{
        	if(event.dragSource.hasFormat(format)){
				DragManager.acceptDragDrop(IUIComponent(event.target));
			}
        }
        
        private function shadowDoDragOver(event:DragEvent):void{
        }
        
        private function shadowDoDragDrop(event:DragEvent):void{
        	this.tempTargetObj = null;
        	if(this.layOutBox){
        		var targetObj:UIComponent = UIComponent(event.target);
				var obj:Object=new Object();
				obj=event.dragSource.dataForFormat(format);
				var moveCanvas:Canvas = Canvas(obj);	
				var movePanel:GadgetPanel = GadgetPanel(moveCanvas.getChildAt(0));
				if(moveCanvas!=targetObj.parent.parent){
					try{
						moveCanvas.parent.removeChild(moveCanvas);
					}catch(err:Error){}
					this.parentCanvas.parent.addChildAt(moveCanvas, this.parentCanvas.parent.getChildIndex(this.parentCanvas));
				}
        	}
        	if(this.shadowCanvas!=null){
        		this.parentCanvas.parent.removeChild(this.shadowCanvas);
        	}
        }
        
        private function shadowDoDragExit(event:DragEvent):void{
        	this.tempTargetObj = null;
        	if(this.shadowCanvas!=null){
        		this.parentCanvas.parent.removeChild(this.shadowCanvas);
        	}
        }
        
        private function shadowBarDownHandler(event:MouseEvent):void{
			if(this.shadowCanvas!=null){
        		this.parentCanvas.parent.removeChild(this.shadowCanvas);
        	}
			this.shadowCanvas = null;
        }
        
        private function scrollMove():void{
        	if(this.mainCanvas!=null){
	        	if(this.mainCanvas.mouseY+10 > this.mainCanvas.height){
	        		this.mainCanvas.verticalScrollPosition = this.mainCanvas.verticalScrollPosition + 100;
	        	}else{
	        		this.mainCanvas.verticalScrollPosition = this.mainCanvas.verticalScrollPosition - 100;
	        	}
	        }
        }
        
		public function panelClickHandler(event:MouseEvent):void {
			this.pTitleBar.removeEventListener(MouseEvent.MOUSE_MOVE, titleBarMoveHandler);
			this.parent.setChildIndex(this, this.parent.numChildren - 1);
			this.panelFocusCheckHandler();
		}
		
		public function titleBarDownHandler(event:MouseEvent):void {
			this.pTitleBar.addEventListener(MouseEvent.MOUSE_MOVE, titleBarMoveHandler);
		}
			
		public function titleBarMoveHandler(event:MouseEvent):void {
			var di:BitmapAsset = BitmapAsset(new dragClass());
    		di.width = 78;
    		di.height = this.titleBar.height-3;
    		di.x = this.parentCanvas.mouseX; 
			di.y = this.parentCanvas.mouseY;
            var ds:DragSource=new DragSource();
            ds.addData(this.parentCanvas,"^");   
            DragManager.doDrag(this ,ds, event, di); 
		}
		
		public function titleBarDragDropHandler(event:MouseEvent):void {
			this.pTitleBar.removeEventListener(MouseEvent.MOUSE_MOVE, titleBarMoveHandler);
			this.alpha = 1.0;
			this.stopDrag();
		}
		
		public function panelFocusCheckHandler():void {
			for (var i:int = 0; i < this.parent.numChildren; i++) {
				var child:UIComponent = UIComponent(this.parent.getChildAt(i));
				if (this.parent.getChildIndex(child) < this.parent.numChildren - 1) {
					/*child.setStyle("headerColors", [0xC3D1D9, 0xD2DCE2]);
					child.setStyle("borderColor", 0xD2DCE2);글로벌스타일적용(지웅)*/
				} else if (this.parent.getChildIndex(child) == this.parent.numChildren - 1) {
					/*
					child.setStyle("headerColors", [0xC3D1D9, 0x5A788A]);
					child.setStyle("borderColor", 0x5A788A);
					*/
					/*
					child.setStyle("headerColors", [0xC3D1D9, 0xD2DCE2]);
					child.setStyle("borderColor", 0xD2DCE2);글로벌스타일적용(지웅)*/
				}
			}
		}
		
		public function titleBarDoubleClickHandler(event:MouseEvent):void {
			if(this.parentCanvasHeight==0){
				this.parentCanvasHeight = this.parentCanvas.height;
			}
			if(this.parentCanvas.height != this.parentCanvasHeight){
				this.parentCanvas.height = this.parentCanvasHeight;
			}else{
				this.parentCanvas.height = 29;
			}
		}
						
		public function endEffectEventHandler(event:EffectEvent):void {
			this.resizeHandler.visible = true;
		}

		public function normalMaxClickHandler(event:MouseEvent):void {
			if (this.normalMaxButton.styleName == "increaseBtn") {                      
				if(bigCanvas==null){
					this.bigCanvas = new Canvas();
					this.bigCanvas.percentWidth = 99;
					this.bigCanvas.percentHeight = 100;
					this.mainCanvas.addChild(bigCanvas);
				}
				try{
					this.parentCanvas.removeChild(this);
				}catch(err:Error){}
				this.bigCanvas.addChild(this);
				this.bigCanvas.visible = true;
				this.mainCanvas.getChildAt(0).visible = false;
				this.mainVerticalScrollPosition = this.mainCanvas.verticalScrollPosition
				this.mainCanvas.verticalScrollPosition = 0;
				this.normalMaxButton.styleName = "decreaseBtn";
			}else {         
				try{
					this.bigCanvas.removeChild(this);
				}catch(err:Error){}
				this.parentCanvas.addChild(this);
				this.bigCanvas.visible = false; 
				this.mainCanvas.getChildAt(0).visible = true;
				this.mainCanvas.verticalScrollPosition = this.mainVerticalScrollPosition;
				this.normalMaxButton.styleName = "increaseBtn";
			}
			this.positionChildren();
		}
		
		public function closeClickHandler(event:MouseEvent):void {
			 Alert.show("창을 닫으시겠습니까?", "", 3, this, alertClickHandler);
		}
	
		private function alertClickHandler(event:CloseEvent):void {
			if (event.detail==Alert.YES){
				this.removeEventListener(MouseEvent.CLICK, panelClickHandler);
//				if(this.mainCanvas!=null){
//					this.mainCanvas.getChildAt(0).visible = true;
//					this.parent.removeChild(this);
//					this.parentCanvas.parent.removeChild(this.parentCanvas);
//				}else{
//					this.parent.removeChild(this);
//				}
				var eventObj:PanelEvent = new PanelEvent("panelClose");
				eventObj["gadgetId"] = gadgetId;
				dispatchEvent(eventObj);
			}
		}
		
		public function resizeOverHandler(event:MouseEvent):void {
			this.resizeCur = CursorManager.setCursor(resizeCursor);
		}
		
		public function resizeOutHandler(event:MouseEvent):void {
			CursorManager.removeCursor(CursorManager.currentCursorID);
		}
		
		public function resizeDownHandler(event:MouseEvent):void {
			Application.application.parent.addEventListener(MouseEvent.MOUSE_MOVE, resizeMoveHandler);
			Application.application.parent.addEventListener(MouseEvent.MOUSE_UP, resizeUpHandler);
			this.resizeHandler.addEventListener(MouseEvent.MOUSE_OVER, resizeOverHandler);
			this.panelClickHandler(event);
			this.resizeCur = CursorManager.setCursor(resizeCursor);
			this.oPoint.x = mouseX;
			this.oPoint.y = mouseY;
			this.oPoint = this.localToGlobal(oPoint);		
		}
		
		public function resizeMoveHandler(event:MouseEvent):void {
			this.stopDragging();

			var xPlus:Number = Application.application.parent.mouseX - this.oPoint.x;			
			var yPlus:Number = Application.application.parent.mouseY - this.oPoint.y;
			
			if (this.oW + xPlus > 140) {
				this.width = this.oW + xPlus;
			}
			
			if (this.oH + yPlus > 80) {
				this.height = this.oH + yPlus;
			}
			this.positionChildren();
		}
		
		public function resizeUpHandler(event:MouseEvent):void {
			Application.application.parent.removeEventListener(MouseEvent.MOUSE_MOVE, resizeMoveHandler);
			Application.application.parent.removeEventListener(MouseEvent.MOUSE_UP, resizeUpHandler);
			CursorManager.removeCursor(CursorManager.currentCursorID);
			this.resizeHandler.addEventListener(MouseEvent.MOUSE_OVER, resizeOverHandler);
			this.initPos();
		}
	}
}