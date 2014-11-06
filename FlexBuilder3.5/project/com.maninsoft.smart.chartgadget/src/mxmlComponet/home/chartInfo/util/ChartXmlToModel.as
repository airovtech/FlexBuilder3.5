package mxmlComponet.home.chartInfo.util{
	import mx.collections.ArrayCollection;
	import mx.collections.XMLListCollection;
	
	import mxmlComponet.home.chartInfo.model.ChartInfoModel;
	import mxmlComponet.home.chartInfo.model.ColumnModel;
	import mxmlComponet.home.chartInfo.model.ConditionModel;
	import mxmlComponet.home.chartInfo.model.GroupingFilterModel;
	import mxmlComponet.home.chartInfo.model.ValueFilterModel;
	
	public class ChartXmlToModel{
		public function ChartXmlToModel(){
		}
		
		public static function xmlToModel(model:ChartInfoModel):String{
			var valueFilterModel:ValueFilterModel = model.valueFilterModel;
			var groupingFilterModel:GroupingFilterModel = model.groupingFilterModel;
			var columns:ArrayCollection = model.columns;
			var condtions:ArrayCollection = model.conditions;
			var chartXml:String;
			
			chartXml = '<Gadget formId="'+model.formId+'" type="'+model.chartType+'">' + '\n';
			chartXml += '	<name>'+XmlUtil.startCdataTag()+model.chartName+XmlUtil.endCdataTag()+'</name>' + '\n';
			chartXml += '	<remark id="'+model.remarkId+'">' + '\n';
			chartXml += '		<name>'+XmlUtil.startCdataTag()+model.reamrkName+XmlUtil.endCdataTag()+'</name>' + '\n';
			chartXml += '	</remark>' + '\n';
			chartXml += '	<valueInfo id="'+model.valueInfoId+'">' + '\n';
			chartXml += '		<name>'+XmlUtil.startCdataTag()+model.valueInfoName+XmlUtil.endCdataTag()+'</name>' + '\n';
			chartXml += '		<filter functionType="'+valueFilterModel.functionType+'" minValue="'+valueFilterModel.minValue+'" maxValue="'+valueFilterModel.maxValue+'" dataType="'+valueFilterModel.dataType+'"/>' + '\n';
			chartXml += '	</valueInfo>' + '\n';
			chartXml += '	<groupInfo id="'+model.groupingId+'">' + '\n';
			chartXml += '		<name>'+XmlUtil.startCdataTag()+model.groupingName+XmlUtil.endCdataTag()+'</name>' + '\n';
			chartXml += '		<filter inclusion="'+groupingFilterModel.inclusion+'">' + '\n';
			chartXml += '			<elements>'+XmlUtil.startCdataTag()+groupingFilterModel.elements+XmlUtil.endCdataTag()+'</elements>' + '\n';
			chartXml += '		</filter>' + '\n';
			chartXml += '	</groupInfo>' + '\n';
			chartXml += '	<columns>' + '\n';
			if(columns){
				for(var k:int=0; k<columns.length; k++){
					var columnModel:ColumnModel = columns.getItemAt(k) as ColumnModel;
					chartXml += '		<column id="'+columnModel.columnId+'">' + '\n';
					chartXml += '			<name>'+XmlUtil.startCdataTag()+columnModel.columnName+XmlUtil.endCdataTag()+'</name>' + '\n';
					chartXml += '		</column>' + '\n';
				}
			}
			chartXml += '	</columns>' + '\n';
			chartXml += '	<conditions>' + '\n';
			if(condtions){
				for(var i:int=0; i<condtions.length; i++){
					var condtionModel:ConditionModel = condtions.getItemAt(i) as ConditionModel;
					chartXml += '		<condition name="'+condtionModel.name+'">' + '\n';
					chartXml += '			<columnId>'+condtionModel.columnId+'</columnId>' + '\n';
					chartXml += '			<columnName>'+condtionModel.columnName+'</columnName>' + '\n';
					chartXml += '			<conditionValue>'+condtionModel.conditionValue+'</conditionValue>' + '\n';
					chartXml += '			<comparison>'+XmlUtil.startCdataTag()+condtionModel.comparison+XmlUtil.endCdataTag()+'</comparison>' + '\n';
					chartXml += '		</condition>' + '\n';
				}
			}
			chartXml += '		<conditionsRelation>'+model.conditionsRelation+'</conditionsRelation>' + '\n';
			chartXml += '	</conditions>' + '\n';
			chartXml += '</Gadget>';
			
			return chartXml;
		}
		
		public static function modelToXml(xml:XML):ChartInfoModel{
			var model:ChartInfoModel = new ChartInfoModel();
			try{
				model.chartType = xml.@type;
				model.formId = xml.@formId;
				model.chartName = xml.name;
				model.remarkId = xml.remark.@id;
				model.reamrkName = xml.remark.name;
				model.valueInfoId = xml.valueInfo.@id;
				model.valueInfoName = xml.valueInfo.name;
				model.groupingId = xml.groupInfo.@id;
				model.groupingName = xml.groupInfo.name;
				model.valueFilterModel.functionType = xml.valueInfo.filter.@functionType;
				model.valueFilterModel.minValue = xml.valueInfo.filter.@minValue;
				model.valueFilterModel.maxValue = xml.valueInfo.filter.@maxValue;
				model.valueFilterModel.dataType = xml.valueInfo.filter.@dataType;
				model.groupingFilterModel.elements = xml.groupInfo.filter.elements;
				model.groupingFilterModel.inclusion = xml.groupInfo.filter.@inclusion;
				
				var columnList:XMLListCollection = new XMLListCollection(xml.columns.column);
	        	for(var i:int=0; i<columnList.length; i++){
	        		var column:ColumnModel = new ColumnModel();
	        		column.columnId = columnList[i].@id;
	        		column.columnName = columnList[i].name;
	        		model.columns.addItem(column);
	        	}
				
				var conditionList:XMLListCollection = new XMLListCollection(xml.conditions.condition);
	        	for(var i:int=0; i<conditionList.length; i++){
	        		var condition:ConditionModel = new ConditionModel();
	        		condition.name = conditionList[i].@name;
	        		condition.columnId = conditionList[i].columnId;
	        		condition.columnName = conditionList[i].columnName;
	        		condition.conditionValue = conditionList[i].conditionValue;
	        		condition.comparison = conditionList[i].comparison;
	        		model.conditions.addItem(condition);
	        	}
	        	model.conditionsRelation = xml.conditions.conditionsRelation;
	        }catch(e:Error){}
			return model;
		}
	}
}