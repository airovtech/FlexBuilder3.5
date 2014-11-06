package com.maninsoft.smart.ganttchart.view
{
	import com.maninsoft.smart.ganttchart.assets.GanttIconLibrary;
	import com.maninsoft.smart.ganttchart.model.GanttChartGrid;
	import com.maninsoft.smart.ganttchart.server.CalendarInfo;
	import com.maninsoft.smart.modeler.xpdl.model.SubFlow;
	import com.maninsoft.smart.modeler.xpdl.view.SubFlowView;
	
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

	public class GanttTaskGroupView extends SubFlowView
	{
		
		private var _tip: ToolTip;
		private var _planFrom: Date;
		private var _planTo: Date;
		private var _taskRect: Rectangle = new Rectangle();	
		private var _groupRect: Rectangle = new Rectangle();	
		
		public var taskNameTextColor:uint = 0x686868;
		
		private var _actualNodeWidth: Number=0;		

		public var parentViewBounds: Rectangle;

		private var leftMoreIcon:SpriteAsset;
		private var rightMoreIcon:SpriteAsset;

		public function GanttTaskGroupView()
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

		public function get toolTip(): String{
			var dateTimeFormatter:DateFormatter = new DateFormatter();
			dateTimeFormatter.formatString = "YYYY-MM-DD JJ:NN";
			return	resourceManager.getString("GanttChartETC", "taskGroupIdText") + " : " + this.subProcessName + "\n" +
					resourceManager.getString("GanttChartETC", "planDateText") + " : " + dateTimeFormatter.format(planFrom) +				
							" ~ " + dateTimeFormatter.format(planTo);
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

		public function get taskRect(): Rectangle{
			return _taskRect;
		}
		public function set taskRect(value: Rectangle): void{
			 _taskRect = value
		}
				
		public function get actualNodeWidth(): uint{
			return _actualNodeWidth;
		}
		public function set actualNodeWidth(value: uint): void{
			 _actualNodeWidth = value
		}
		
		public function get groupRect(): Rectangle{
			return _groupRect;
		}
		public function set groupRect(value: Rectangle): void{
			_groupRect = value;
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

			if(this.x + r.x<=10) 
				r.x = 0-this.x+10;
			else if(this.x+r.x+textField.width+chartMore>parentViewBounds.right){
				if(taskRect.x+chartMore>=parentViewBounds.right)
					r.x = parentViewBounds.right-this.x-(textField.width+chartMore+10);
				else if(taskRect.x-10-textField.width>=0)
					r.x = taskRect.x-this.x-GanttChartGrid.CHARTMORE_ICON_SIZE*2-textField.width;
				else if(taskRect.x-10-textField.width<0)
					r.x = parentViewBounds.right/2-this.x-textField.width/2-chartMore/2;
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
				
			if(taskRect.left>=0 && (taskRect.right+chartMore<=parentViewBounds.right))
				return;

			if(taskRect.right<=0){
				leftMoreIcon = SpriteAsset(new GanttIconLibrary.overLeftIcon());
				leftMoreIcon.x = chartMoreIconX-this.x;
			}else if(taskRect.left+chartMore>=parentViewBounds.right){ 
				rightMoreIcon = SpriteAsset(new GanttIconLibrary.overRightIcon());
				rightMoreIcon.x = parentViewBounds.width-chartMoreIconX-chartMoreIconWidth-this.x;
			}
/*
			else{
				if(taskRect.left<0){
					if(taskRect.left>=chartMoreIconSize || taskRect.right<=0) 
						leftMoreIcon = SpriteAsset(new GanttIconLibrary.overLeftIcon());
					else						
						leftMoreIcon = SpriteAsset(new GanttIconLibrary.overLeftWhiteIcon());
					leftMoreIcon.x = chartMoreIconX-this.x;						
				}		
				if(taskRect.right+chartMore>parentViewBounds.right){
					if(taskRect.left+chartMore>=parentViewBounds.right || taskRect.right+chartMore<=parentViewBounds.right-chartMoreIconSize) 
						rightMoreIcon = SpriteAsset(new GanttIconLibrary.overRightIcon());
					else
						rightMoreIcon = SpriteAsset(new GanttIconLibrary.overRightWhiteIcon());
					rightMoreIcon.x = parentViewBounds.width-chartMoreIconX-chartMoreIconWidth-this.x;					
				}
			}
*/
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
			var rect:Rectangle, gRect: Rectangle;
			var chartMore: int = GanttChartGrid.CHARTMORE_WIDTH
			
			if(_tip){
				ToolTipManager.destroyToolTip(_tip);
				_tip = null;
			}
			
			g.clear();
			
			if(taskRect.right>0 && taskRect.left+chartMore<parentViewBounds.right){
				rect = getNewRect(taskRect);
				gRect = new Rectangle(rect.x, groupRect.y, rect.width, groupRect.height);

				g.lineStyle(borderWidth, borderColor, 1, true/*pixel hinting*/);
				g.beginFill(fillColor, 0.1);
				g.drawRect(gRect.x-this.x, gRect.y, gRect.width, gRect.height);
			
				g.lineStyle(borderWidth, borderColor, 1, true/*pixel hinting*/);
				g.beginFill(fillColor);
				g.drawRect(rect.x-this.x, rect.y, rect.width, rect.height/2);

				g.lineStyle(0, borderColor, 0);
				if(subFlowView == SubFlow.VIEW_EXPANDED){
					if(rect.x == taskRect.x){
						g.moveTo(rect.x-this.x, rect.y+rect.height/2);
						g.lineTo(rect.x+rect.height/2/2-this.x, rect.y+rect.height);
						g.lineTo(rect.x+rect.height/2-this.x, rect.y+rect.height/2);
						g.lineTo(rect.x-this.x, rect.y+rect.height/2);
					}
					
					if(rect.width == taskRect.width){
						g.moveTo(rect.x+rect.width-this.x, rect.y+rect.height/2);
						g.lineTo(rect.x+rect.width-rect.height/2/2-this.x, rect.y+rect.height);
						g.lineTo(rect.x+rect.width-rect.height/2-this.x, rect.y+rect.height/2);
						g.lineTo(rect.x+rect.width-this.x, rect.y+rect.height/2);
					}
				}else{
					if(rect.x == taskRect.x){
						g.moveTo(rect.x-this.x, rect.y+rect.height/2);
						g.lineTo(rect.x-this.x, rect.y+rect.height);
						g.lineTo(rect.x+rect.height/2-this.x, rect.y+rect.height/4*3);
						g.lineTo(rect.x-this.x, rect.y+rect.height/2);
					}

					if(rect.width == taskRect.width){
						g.moveTo(rect.x+rect.width-this.x, rect.y+rect.height/2);
						g.lineTo(rect.x+rect.width-this.x, rect.y+rect.height);
						g.lineTo(rect.x+rect.width-rect.height/2-this.x, rect.y+rect.height/4*3);
						g.lineTo(rect.x+rect.width-this.x, rect.y+rect.height/2);				
					}
				}
				g.endFill();
			}
			
			drawText( new Rectangle(this.actualNodeWidth+GanttChartGrid.CHARTMORE_ICON_SIZE*2, 0, 0, this.nodeHeight), this.name, null);
			
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