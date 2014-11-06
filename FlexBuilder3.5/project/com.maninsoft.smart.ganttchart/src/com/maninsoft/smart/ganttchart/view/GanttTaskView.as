package com.maninsoft.smart.ganttchart.view
{
	import com.maninsoft.smart.ganttchart.assets.GanttIconLibrary;
	import com.maninsoft.smart.ganttchart.model.GanttChartGrid;
	import com.maninsoft.smart.modeler.xpdl.server.User;
	import com.maninsoft.smart.modeler.xpdl.view.TaskApplicationView;
	
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import mx.controls.ToolTip;
	import mx.core.SpriteAsset;
	import mx.formatters.DateFormatter;
	import mx.managers.ToolTipManager;

	public class GanttTaskView extends TaskApplicationView
	{

		private var _tip: ToolTip;
		private var _planFrom: Date;
		private var _planTo: Date;
		private var _executionFrom: Date;
		private var _executionTo: Date;
		private var _planTaskRect: Rectangle = new Rectangle();		
		private var _executionTaskRect: Rectangle = new Rectangle();

		public var taskNameTextColor:uint = 0x686868;
		
		private var _exeSelected: Boolean;		
		private var _exeBorderWidth: Number = 1;
		private var _exeBorderColor: uint;
		private var _exeFillColor: uint;

		private var _actualNodeWidth: Number=0;
		
		private var _subProcessId: String;
		
		public var parentViewBounds: Rectangle;

		private var leftMoreIcon:SpriteAsset;
		private var rightMoreIcon:SpriteAsset;
				
		public function GanttTaskView()
		{
			super();

			addEventListener(MouseEvent.MOUSE_OVER, doMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, doMouseOut);
		}
		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		public function get viewBoolean():Boolean{
			return GanttChartGrid.readOnly;
		}

		public function get toolTip(): String {
			var dateTimeFormatter:DateFormatter = new DateFormatter();
			dateTimeFormatter.formatString = "YYYY-MM-DD JJ:NN";
			
			var actualTime:String = (this.executionFrom)?("\n"+resourceManager.getString("GanttChartETC", "actualDateText") + " : " + dateTimeFormatter.format(executionFrom) +
														   		 " ~ " + ((executionTo)?(dateTimeFormatter.format(executionTo)):"")) : "";
			return 	resourceManager.getString("ProcessEditorETC", "approvalLineText") + " : " + this.approvalLineName + "\n" +
					resourceManager.getString("GanttChartETC", "planDateText") + " : " + dateTimeFormatter.format(planFrom) + 
							" ~ " + dateTimeFormatter.format(planTo) +
					actualTime; 
		}
		
		public function get planFrom(): Date{
			return _planFrom;
		}

		public function set planFrom(value: Date): void{
			_planFrom = value;
		}

		public function get planTo(): Date{
			return _planTo;
		}

		public function set planTo(value: Date): void{
			_planTo = value;
		}

		public function get executionFrom(): Date{
			return _executionFrom;
		}

		public function set executionFrom(value: Date): void{
			_executionFrom = value;
		}

		public function get executionTo(): Date{
			return _executionTo;
		}

		public function set executionTo(value: Date): void{
			_executionTo = value;
		}

		public function get planTaskRect(): Rectangle{
			return _planTaskRect;
		}
		public function set planTaskRect(value: Rectangle): void{
			 _planTaskRect = value
		}

		public function get executionTaskRect(): Rectangle{
			return _executionTaskRect;
		}
		public function set executionTaskRect(value: Rectangle): void{
			
			 _executionTaskRect = value
		}

		public function get exeBorderWidth(): Number{
			return _exeBorderWidth;
		}
		public function set exeBorderWidth(value: Number): void{
			 _exeBorderWidth = value
		}
		
		public function get exeBorderColor(): uint{
			return _exeBorderColor;
		}
		public function set exeBorderColor(value: uint): void{
			 _exeBorderColor = value
		}
		
		public function get exeFillColor(): uint{
			return _exeFillColor;
		}
		public function set exeFillColor(value: uint): void{
			 _exeFillColor = value
		}
				
		public function get actualNodeWidth(): uint{
			return _actualNodeWidth;
		}
		public function set actualNodeWidth(value: uint): void{
			 _actualNodeWidth = value
		}
		
		public function get subProcessId(): String{
			return _subProcessId;
		}
		public function set subProcessId(value: String): void{
			_subProcessId = value;
		}
		
		public function get connectBounds(): Rectangle{
			var rect:Rectangle = new Rectangle(bounds.x, bounds.y, bounds.width, bounds.height);
			if(!executionTaskRect || (!executionFrom && !executionTo)) return rect;
			if(bounds.x > executionTaskRect.x) rect.x = executionTaskRect.x;
			if(bounds.x + bounds.width < executionTaskRect.x + executionTaskRect.width) rect.width = executionTaskRect.x + executionTaskRect.width - rect.x;
			return rect;
		}
				
		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override protected function drawText(r: Rectangle, text: String, field: TextField = null, format: TextFormat = null): void {
			var chartMore: int = GanttChartGrid.CHARTMORE_WIDTH

			this.fontFamily = "flexDefaultFontThin";
			this.fontSize = 10;
			this.textColor = taskNameTextColor;

			textField.text = text; 
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.wordWrap = false;

			if(this.x + r.x<=GanttChartGrid.CHARTMORE_ICON_SIZE) 
				r.x = 0-this.x+GanttChartGrid.CHARTMORE_ICON_SIZE;
			else if(this.x+r.x+textField.width+chartMore>parentViewBounds.right){
				var viewLeft: Number = planTaskRect.x;
				if(executionTaskRect.width>0 && planTaskRect.x>executionTaskRect.x)
					viewLeft = executionTaskRect.x;						
				if(viewLeft+chartMore>=parentViewBounds.right)
					r.x = parentViewBounds.right-this.x-(textField.width+chartMore+GanttChartGrid.CHARTMORE_ICON_SIZE);
				else if(viewLeft-GanttChartGrid.CHARTMORE_ICON_SIZE-textField.width>=0)
					r.x = viewLeft-this.x-GanttChartGrid.CHARTMORE_ICON_SIZE*2-textField.width;
				else if(viewLeft-GanttChartGrid.CHARTMORE_ICON_SIZE-textField.width<0){
					r.x = parentViewBounds.right/2-this.x-textField.width/2-chartMore/2;
					if(executionTaskRect.left < this.x + r.x+chartMore && executionTaskRect.right > this.x + r.x + textField.width+chartMore){
						this.textColor = 0xffffff;
					} 
				}
			}
			
			super.drawText(r, text, field, format );

			if (!text)
				return;
			
			if (!field)
				field = textField;
			
			field.background = false;
			field.autoSize = TextFieldAutoSize.LEFT;
			field.wordWrap = false;
		}

		protected function drawLeftRightMore(g: Graphics): void{
			var chartMore:int = GanttChartGrid.CHARTMORE_WIDTH;
			var chartMoreIconX:int = GanttChartGrid.CHARTMORE_ICON_X;
			var chartMoreIconY:int = GanttChartGrid.CHARTMORE_ICON_Y;
			var chartMoreIconWidth:int = GanttChartGrid.CHARTMORE_ICON_WIDTH;
			var chartMoreIconHeight:int = GanttChartGrid.CHARTMORE_ICON_HEIGHT;
			var chartMoreIconSize:int = GanttChartGrid.CHARTMORE_ICON_SIZE;

			if(leftMoreIcon){
				removeChild(leftMoreIcon);
				leftMoreIcon = null;
			}
			if(rightMoreIcon){
				removeChild(rightMoreIcon);
				rightMoreIcon = null;
			}
				
			if(planTaskRect.left>=0 && (planTaskRect.right+chartMore<=parentViewBounds.right)
				&& executionTaskRect.left>=0 && (executionTaskRect.right+chartMore<=parentViewBounds.right))
				return;

			if(planTaskRect.right<=0 && (executionTaskRect.right<=0 || executionTaskRect.width==0)){
				leftMoreIcon = SpriteAsset(new GanttIconLibrary.overLeftIcon());
				leftMoreIcon.x = chartMoreIconX-this.x;
			}else if((planTaskRect.left+chartMore>=parentViewBounds.right) 
					&& ((executionTaskRect.left+chartMore>=parentViewBounds.right) || executionTaskRect.width==0)){
				rightMoreIcon = SpriteAsset(new GanttIconLibrary.overRightIcon());
				rightMoreIcon.x = parentViewBounds.width-chartMoreIconX-chartMoreIconWidth-this.x;
			}else if((planTaskRect.right<=0 && executionTaskRect.left+chartMore>=parentViewBounds.right) 
					|| (executionTaskRect.right<=0 && planTaskRect.left+chartMore>=parentViewBounds.right)){
				leftMoreIcon = SpriteAsset(new GanttIconLibrary.overLeftIcon());
				leftMoreIcon.x = chartMoreIconX-this.x;
				rightMoreIcon = SpriteAsset(new GanttIconLibrary.overRightIcon());
				rightMoreIcon.x = parentViewBounds.width-chartMoreIconX-chartMoreIconWidth-this.x;
			}else{
				if(planTaskRect.left<0 || executionTaskRect.left<0 ){
					if(executionTaskRect.width>0){
						if(	   (planTaskRect.left>=chartMoreIconSize || planTaskRect.right<=0) 
   							&& (executionTaskRect.left>=chartMoreIconSize || executionTaskRect.right<=0))
							leftMoreIcon = SpriteAsset(new GanttIconLibrary.overLeftIcon());
						else						
							leftMoreIcon = SpriteAsset(new GanttIconLibrary.overLeftWhiteIcon());
					}else{
						if(planTaskRect.left>=chartMoreIconSize || planTaskRect.right<=0) 
							leftMoreIcon = SpriteAsset(new GanttIconLibrary.overLeftIcon());
						else						
							leftMoreIcon = SpriteAsset(new GanttIconLibrary.overLeftWhiteIcon());
					}
					leftMoreIcon.x = chartMoreIconX-this.x;						
				}
				if((planTaskRect.right+chartMore>parentViewBounds.right) || (executionTaskRect.right+chartMore>parentViewBounds.right)){
					if(executionTaskRect.width>0){
						if(	   (planTaskRect.left+chartMore>=parentViewBounds.right
								|| planTaskRect.right+chartMore<=parentViewBounds.right-chartMoreIconSize) 
   							&& (executionTaskRect.left+chartMore>=parentViewBounds.right
   								|| executionTaskRect.right+chartMore<=parentViewBounds.right-chartMoreIconSize))
							rightMoreIcon = SpriteAsset(new GanttIconLibrary.overRightIcon());
						else
							rightMoreIcon = SpriteAsset(new GanttIconLibrary.overRightWhiteIcon());
					}else{
						if(planTaskRect.left+chartMore>=parentViewBounds.right
							|| planTaskRect.right+chartMore<=parentViewBounds.right-chartMoreIconSize) 
							rightMoreIcon = SpriteAsset(new GanttIconLibrary.overRightIcon());
						else
							rightMoreIcon = SpriteAsset(new GanttIconLibrary.overRightWhiteIcon());
					}
					rightMoreIcon.x = parentViewBounds.width-chartMoreIconX-chartMoreIconWidth-this.x;					
				}
			}
			if(leftMoreIcon){
				leftMoreIcon.y = chartMoreIconY;
				addChild(leftMoreIcon);
			}
			if(rightMoreIcon){
				rightMoreIcon.y = chartMoreIconY;
				addChild(rightMoreIcon);
			}
		}
		
		protected function getNewRect(r: Rectangle): Rectangle{
			var rect: Rectangle = new Rectangle(r.x, r.y, r.width, r.height);

			var chartMore: int = GanttChartGrid.CHARTMORE_WIDTH
			
			if(rect.right<=0 ||  rect.left+chartMore>=parentViewBounds.right){
				rect.width =0;
				return rect;
			}
			
			if(rect.x <0){
				rect.width += rect.x;
				rect.x = 0;
			}
			
			if(rect.right+chartMore>parentViewBounds.right){
				rect.width -= (rect.right+chartMore)-parentViewBounds.right;
			}
			return rect;			
		}
		
		override public function draw(): void {
			var g: Graphics = graphics;
			var rect:Rectangle;
			var chartMore: int = GanttChartGrid.CHARTMORE_WIDTH

			if(_tip){
				ToolTipManager.destroyToolTip(_tip);
				_tip = null;
			}
			
			g.clear();
			
			if(planTaskRect.right>0 && planTaskRect.left+chartMore<parentViewBounds.right){
				rect = getNewRect(planTaskRect);
				g.lineStyle(borderWidth, borderColor, 1, true/*pixel hinting*/);
				g.beginFill(fillColor);
				g.drawRect(rect.x-this.x, rect.y, rect.width, rect.height);
				g.endFill();
			}
			
			if(executionTaskRect.width != 0 && executionTaskRect.right>0 && executionTaskRect.left+chartMore<parentViewBounds.right) {
				rect = getNewRect(executionTaskRect);
				g.lineStyle(exeBorderWidth, exeBorderColor, 1, true/*pixel hinting*/);			
				g.beginFill(exeFillColor);
				g.drawRect(rect.x-this.x, rect.y, rect.width, rect.height );
				g.endFill();				
			}

			drawText( new Rectangle(this.actualNodeWidth+GanttChartGrid.CHARTMORE_ICON_SIZE*2, 0, 0, this.nodeHeight), this.name+" - "+((performer && performer!="null")?performer:User.EMPTY_USER_NAME), null);
			
			drawLeftRightMore(g);
		}		

		override public function connectAnchorToPoint(anchor: Number): Point {
			var r: Rectangle = this.bounds;
			r.x += GanttChartGrid.CHARTMORE_WIDTH;
			
			switch (anchor) {
				case 0: 
					return new Point(r.x + r.width / 2, r.y);
				case 90: 
					return new Point(r.x + r.width, r.y + r.height / 2);
				case 180:
					return new Point(r.x + r.width / 2, r.y + r.height);
				case 270:
					return new Point(r.x, r.y + r.height / 2);
				default:
					throw new Error(resourceManager.getString("GanttChartMessages", "GCE003") + "(" + anchor + ")");
			}
		}

		protected function doMouseOver(event: MouseEvent): void {
			if(viewBoolean){
				if(_tip) ToolTipManager.destroyToolTip(_tip);				
				_tip = ToolTipManager.createToolTip(toolTip, event.stageX + 10, event.stageY) as ToolTip;
				_tip.setStyle("fontSize", 11);
			}	
		}

		protected function doMouseOut(event: MouseEvent): void {
			if(viewBoolean){
				if(_tip) ToolTipManager.destroyToolTip(_tip);
				_tip = null;
			}
		}
	}
}