package mxmlComponet.home.chartInfo.info
{
	import com.maninsoft.smart.common.event.CustormEvent;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Box;
	import mx.core.Application;
	
	import mxmlComponet.home.chartInfo.filter.GroupingFilter;
	import mxmlComponet.home.chartInfo.filter.ValueFilter;
	import mxmlComponet.home.chartInfo.model.ChartInfoModel;
	import mxmlComponet.home.chartInfo.util.FilterPopUpLayOut;
	
	public class ChartInfo extends Box{
		private var _chartInfoModel:ChartInfoModel = new ChartInfoModel();
		private var groupingFilter:GroupingFilter = new GroupingFilter();
		private var valueFilter:ValueFilter = new ValueFilter();
		public var app:Application;
		public var _chartType:String;
		private var filterPopUpLayOut:FilterPopUpLayOut = new FilterPopUpLayOut();
		
		public function ChartInfo(){
			super();
			groupingFilter.filterModel = _chartInfoModel.groupingFilterModel;
			valueFilter.filterModel = _chartInfoModel.valueFilterModel;
		}
		
		public function set chartInfoModel(model:ChartInfoModel):void{
			if(model.chartType == _chartInfoModel.chartType){
				_chartInfoModel = model;
				groupingFilter.filterModel = chartInfoModel.groupingFilterModel;
				valueFilter.filterModel = chartInfoModel.valueFilterModel;
				infoChange();
			}
		}
		
		public function get chartInfoModel():ChartInfoModel{
			return _chartInfoModel;
		}
		
		public function set chartType(type:String):void{
			_chartInfoModel.chartType = type;
			_chartType = type;
		}
		
		public function get chartType():String{
			return _chartType;
		}
		
		public function valueInfoChange(event:CustormEvent):void{
			chartInfoModel.valueInfoId = event.columnId;
			chartInfoModel.valueInfoName = event.columnName;
			chartInfoModel.valueFilterModel.dataType = event.columnType;
		}
		
		public function remarkChange(event:CustormEvent):void{
			chartInfoModel.remarkId = event.columnId;
			chartInfoModel.reamrkName = event.columnName;
		}
		
		public function groupingChange(event:CustormEvent):void{
			chartInfoModel.groupingId = event.columnId;
			chartInfoModel.groupingName = event.columnName;
		}
		
		public function openValueFilter(event:MouseEvent):void{
			filterPopUpLayOut.createPop("Value필터", valueFilter, app, this);
			
		}
		
		public function openGroupingFilter(event:MouseEvent):void{
			filterPopUpLayOut.createPop("Grouping필터", groupingFilter, app, this);
		}
		
		public function infoChange():void{}
	}
}