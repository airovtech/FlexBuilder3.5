package com.maninsoft.smart.formeditor.layout.grid
{
	import com.maninsoft.smart.common.dialog.AbstractDialog;
	
	import flash.events.Event;
	
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.DataGrid;
	import mx.controls.Label;
	import mx.controls.NumericStepper;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.events.NumericStepperEvent;

	public class FormGridInitDialog extends AbstractDialog
	{
		public var colInput:NumericStepper = new NumericStepper();
		public var rowInput:NumericStepper = new NumericStepper();
		public var exampleTable:DataGrid = new DataGrid();
		
		public function FormGridInitDialog()
		{
			super();
			this.title = resourceManager.getString("FormEditorETC", "gridSettingText");
			this.showCloseButton=true;
			this.showOkButton=true;
			this.showCancelButton=true;
		}
			
		override protected function childrenCreated():void{

			var colLabel:Label = new Label();
			colLabel.text = resourceManager.getString("FormEditorETC", "rowCountText");
			colInput.value = 2;
			colInput.minimum = 1;
			colInput.maximum = 6;
			colInput.addEventListener(NumericStepperEvent.CHANGE, drawGrid);
			var hBoxUpper:HBox = new HBox();
			hBoxUpper.setStyle("horizontalAlign", "right");
			hBoxUpper.percentWidth = 100;
			hBoxUpper.addChild(colLabel);
			hBoxUpper.addChild(colInput);
			this.contentBox.addChild(hBoxUpper);
			
			var rowLabel:Label = new Label();
			rowLabel.text = resourceManager.getString("FormEditorETC", "columnCountText");		
			rowInput.value = 6;
			rowInput.minimum = 1;
			rowInput.addEventListener(NumericStepperEvent.CHANGE, drawGrid);
			var vBoxInLower:VBox = new VBox();
			vBoxInLower.percentHeight = 100;
			vBoxInLower.setStyle("verticalAlign", "bottom");
			vBoxInLower.addChild(rowLabel);
			vBoxInLower.addChild(rowInput);
			var hBoxLower:HBox = new HBox();
			hBoxLower.addChild(vBoxInLower);
			exampleTable.showHeaders=false;
			exampleTable.enabled = false;
			exampleTable.setStyle("horizontalGridLines", true);
			exampleTable.setStyle("alternatingItemColors", [0xffffff, 0xffffff]);
			exampleTable.height = 120;
			exampleTable.width = 260;
			exampleTable.rowCount = this.rowInput.value;
			hBoxLower.addChild(exampleTable);
			this.contentBox.addChild(hBoxLower);
			drawGrid();

		}

		private function drawGrid(event:NumericStepperEvent=null):void{
			var gridColumns:Array = new Array();
			for(var i:int=0; i<this.colInput.value; i++){
				var gridColumn:DataGridColumn = new DataGridColumn();
				gridColumns.push(gridColumn);
			}
			exampleTable.columns = gridColumns;
			exampleTable.rowCount = this.rowInput.value;
		}

		override protected function ok(event:Event = null):void {
			super.ok(event);
			dispatchEvent(new Event(Event.COMPLETE));
			close();
		}
	}
}