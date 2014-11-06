package com.maninsoft.smart.ganttchart.view
{
	import com.maninsoft.smart.ganttchart.assets.GanttIconLibrary;
	import com.maninsoft.smart.ganttchart.model.GanttChartGrid;
	import com.maninsoft.smart.ganttchart.model.GanttMilestone;
	import com.maninsoft.smart.ganttchart.server.CalendarInfo;
	import com.maninsoft.smart.modeler.xpdl.view.TaskManualView;
	
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

	public class GanttMilestoneView extends TaskManualView
	{

		private var _tip: ToolTip;
		private var _planDate: Date;
		private var _executionDate: Date;
		private var _planMilestonePoint: Point = new Point(0,0);		
		private var _executionMilestonePoint: Point = new Point(0,0);		

		public var taskNameTextColor:uint = 0x993A3A;

		private var _exeSelected: Boolean;		
		private var _exeBorderWidth: Number = 1;
		private var _exeBorderColor: uint;
		private var _exeFillColor: uint;

		private var _actualNodeWidth: Number=0;
		
		public var parentViewBounds: Rectangle;

		private var leftMoreIcon:SpriteAsset;
		private var rightMoreIcon:SpriteAsset;

		public function GanttMilestoneView()
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
			var actualTime:String = (this.executionDate)?("\n"+resourceManager.getString("GanttChartETC", "actualDateText") + " : " + dateTimeFormatter.format(executionDate)):"";
			return 	resourceManager.getString("GanttChartETC", "planDateText") + " : " + dateTimeFormatter.format(planDate) +
					actualTime; 
		}
		
		public function get planDate(): Date{
			return _planDate;
		}

		public function set planDate(value: Date): void{
			_planDate = value;
		}

		public function get executionDate(): Date{
			return _executionDate;
		}

		public function set executionDate(value: Date): void{
			_executionDate = value;
		}

		public function get planMilestonePoint(): Point{
			return _planMilestonePoint;
		}
		public function set planMilestonePoint(value: Point): void{
			 _planMilestonePoint = value
		}

		public function get executionMilestonePoint(): Point{
			return _executionMilestonePoint;
		}
		public function set executionMilestonePoint(value: Point): void{
			 _executionMilestonePoint = value
		}

		public function get exeSelected(): Boolean{
			return _exeSelected;
		}
		public function set exeSelected(value: Boolean): void{
			 _exeSelected = value
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
				
		public function get connectBounds(): Rectangle{
			var rect:Rectangle = new Rectangle(bounds.x, bounds.y, bounds.width, bounds.height);
			if(!executionMilestonePoint || !executionDate) return rect;
			if(bounds.x > executionMilestonePoint.x) rect.x = executionMilestonePoint.x;
			return rect;
		}
				
		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		override public function get bounds(): Rectangle{
			return(new Rectangle(this.x-this.nodeWidth/2, this.y, this.nodeWidth, this.nodeHeight));
		}

		override protected function drawText(r: Rectangle, text: String, field: TextField = null, format: TextFormat = null): void {

			var chartMore: int = GanttChartGrid.CHARTMORE_WIDTH

			this.fontFamily = "flexDefaultFont";
			this.fontSize = 11;
			this.textColor = taskNameTextColor;

			textField.text = text; 
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.wordWrap = false;
			if(this.x + r.x<=10) 
				r.x = 0-this.x+10;
			else if(this.x+r.x+textField.width+chartMore>parentViewBounds.right){
				var viewLeft: Number = planMilestonePoint.x-GanttMilestone.MILESTONESYMBOL_WIDTH/2;
				if(this.executionMilestonePoint.x!=0 && planMilestonePoint.x>executionMilestonePoint.x)
					viewLeft = executionMilestonePoint.x-GanttMilestone.MILESTONESYMBOL_WIDTH/2;
						
				if(viewLeft+chartMore>=parentViewBounds.right)
					r.x = parentViewBounds.right-this.x-(textField.width+chartMore+10);
				else if(viewLeft-10-textField.width>=0)
					r.x = viewLeft-this.x-10-textField.width;
				else if(viewLeft-10-textField.width<0)
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
			var milestoneSymbolWidth:int = GanttMilestone.MILESTONESYMBOL_WIDTH;
			var milestoneSymbolHeight:int = GanttMilestone.MILESTONESYMBOL_HEIGHT;
			var milestoneSymbolExeGap:int = GanttMilestone.MILESTONESYMBOL_EXEGAP;

			if(leftMoreIcon){
				removeChild(leftMoreIcon);
				leftMoreIcon = null;
			}
			if(rightMoreIcon){
				removeChild(rightMoreIcon);
				rightMoreIcon = null;
			}

			if(planMilestonePoint.x>=0 && (planMilestonePoint.x+chartMore<=parentViewBounds.right)
				&& executionMilestonePoint.x>=0 && (executionMilestonePoint.x+chartMore<=parentViewBounds.right))
				return;
			
			if(	planMilestonePoint.x<=0 && executionMilestonePoint.x<=0){
				leftMoreIcon = SpriteAsset(new GanttIconLibrary.overLeftIcon());
				leftMoreIcon.x = chartMoreIconX-this.x;
			}else if(planMilestonePoint.x+chartMore>=parentViewBounds.right && executionMilestonePoint.x+chartMore>=parentViewBounds.right){
				rightMoreIcon = SpriteAsset(new GanttIconLibrary.overRightIcon());
				rightMoreIcon.x = parentViewBounds.width-chartMoreIconX-chartMoreIconWidth-this.x;
			}else if((planMilestonePoint.x<=0 && executionMilestonePoint.x+chartMore>=parentViewBounds.right)
					|| (executionMilestonePoint.x<=0 && planMilestonePoint.x+chartMore>=parentViewBounds.right)){
				leftMoreIcon = SpriteAsset(new GanttIconLibrary.overLeftIcon());
				leftMoreIcon.x = chartMoreIconX-this.x;
				rightMoreIcon = SpriteAsset(new GanttIconLibrary.overRightIcon());
				rightMoreIcon.x = parentViewBounds.width-chartMoreIconX-chartMoreIconWidth-this.x;						
			}else{
				if(planMilestonePoint.x<0 || executionMilestonePoint.x<0 ){
					if(executionMilestonePoint.x!=0 && executionMilestonePoint.y != 0){
						if(	   (planMilestonePoint.x-milestoneSymbolWidth/2>=chartMoreIconSize || planMilestonePoint.x<0) 
   							&& (executionMilestonePoint.x-milestoneSymbolWidth/2>=chartMoreIconSize || executionMilestonePoint.x<=0))
							leftMoreIcon = SpriteAsset(new GanttIconLibrary.overLeftIcon());
						else						
							leftMoreIcon = SpriteAsset(new GanttIconLibrary.overLeftWhiteIcon());
					}else{
						if(planMilestonePoint.x-milestoneSymbolWidth/2>=chartMoreIconSize || planMilestonePoint.x<0) 
							leftMoreIcon = SpriteAsset(new GanttIconLibrary.overLeftIcon());
						else						
							leftMoreIcon = SpriteAsset(new GanttIconLibrary.overLeftWhiteIcon());
					}
					leftMoreIcon.x = chartMoreIconX-this.x;						

				}
				if((planMilestonePoint.x+chartMore>parentViewBounds.right) || (executionMilestonePoint.x+chartMore>parentViewBounds.right)){
					if(executionMilestonePoint.x!=0 && executionMilestonePoint.y != 0){
						if(	   (planMilestonePoint.x+chartMore>=parentViewBounds.right
								|| planMilestonePoint.x+chartMore<=parentViewBounds.right-chartMoreIconSize) 
   							&& (executionMilestonePoint.x+chartMore>=parentViewBounds.right
   								|| executionMilestonePoint.x+chartMore<=parentViewBounds.right-chartMoreIconSize))
							rightMoreIcon = SpriteAsset(new GanttIconLibrary.overRightIcon());
						else
							rightMoreIcon = SpriteAsset(new GanttIconLibrary.overRightWhiteIcon());
					}else{
						if(planMilestonePoint.x+chartMore>=parentViewBounds.right || planMilestonePoint.x+chartMore<=parentViewBounds.right-chartMoreIconSize) 
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
		
		override public function draw(): void {
			var g: Graphics = graphics;
			var chartMore: int = GanttChartGrid.CHARTMORE_WIDTH
			var milestoneSymbolWidth:int = GanttMilestone.MILESTONESYMBOL_WIDTH;
			var milestoneSymbolHeight:int = GanttMilestone.MILESTONESYMBOL_HEIGHT;
			var milestoneSymbolExeGap:int = GanttMilestone.MILESTONESYMBOL_EXEGAP;
			
			if(_tip){
				ToolTipManager.destroyToolTip(_tip);
				_tip = null;
			}
			
			g.clear();
			
			if(planMilestonePoint.x>0 && planMilestonePoint.x+chartMore<parentViewBounds.right){
				g.lineStyle(borderWidth, borderColor, 1, true/*pixel hinting*/);
				g.beginFill(fillColor);
				g.moveTo(planMilestonePoint.x-this.x,						planMilestonePoint.y);
				g.lineTo(planMilestonePoint.x-milestoneSymbolWidth/2-this.x,planMilestonePoint.y+milestoneSymbolHeight/2);
				g.lineTo(planMilestonePoint.x-this.x,						planMilestonePoint.y+milestoneSymbolHeight);
				g.lineTo(planMilestonePoint.x+milestoneSymbolWidth/2-this.x,planMilestonePoint.y+milestoneSymbolHeight/2);
				g.lineTo(planMilestonePoint.x-this.x,						planMilestonePoint.y);
				g.endFill();
			
				if(executionDate != null) {
					g.lineStyle(exeBorderWidth, exeBorderColor, 1, true/*pixel hinting*/);
			
					g.beginFill(exeFillColor);
					g.moveTo(executionMilestonePoint.x-this.x,												executionMilestonePoint.y+milestoneSymbolExeGap);
					g.lineTo(executionMilestonePoint.x-milestoneSymbolWidth/2-this.x+milestoneSymbolExeGap,	executionMilestonePoint.y+milestoneSymbolHeight/2);
					g.lineTo(executionMilestonePoint.x-this.x,												executionMilestonePoint.y+milestoneSymbolHeight-milestoneSymbolExeGap);
					g.lineTo(executionMilestonePoint.x+milestoneSymbolWidth/2-this.x-milestoneSymbolExeGap, executionMilestonePoint.y+milestoneSymbolHeight/2);
					g.lineTo(executionMilestonePoint.x-this.x,												executionMilestonePoint.y+milestoneSymbolExeGap);
					g.endFill();				
				}
			}
			drawText( new Rectangle(this.actualNodeWidth+10, 0, 0, this.nodeHeight), this.name, null);

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