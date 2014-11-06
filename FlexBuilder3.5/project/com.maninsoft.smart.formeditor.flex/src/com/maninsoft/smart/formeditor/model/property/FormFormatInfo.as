package com.maninsoft.smart.formeditor.model.property
{
	import com.maninsoft.smart.formeditor.model.AutoIndexRule;
	import com.maninsoft.smart.formeditor.model.FormRef;
	import com.maninsoft.smart.formeditor.model.type.FormatTypes;
	import com.maninsoft.smart.formeditor.refactor.view.property.detail.FormListType;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	public class FormFormatInfo
	{
		[Bindable]
		public var type:String = FormatTypes.textInput.type;
		
		/*******************목록********************/
		[Bindable]
		public var listType:String = FormListType.STATIC;		
		
		[Bindable]
		public var staticListExamples:ArrayCollection = new ArrayCollection();

		[Bindable]
		public var refCodeCategoryId:String;
		
		[Bindable]
		public var refCodeCategoryName:String;	
				
		/*******************캘린더********************/
		[Bindable]
		public var yearUse:Boolean = false;
		
		[Bindable]
		public var sunNotUse:Boolean = false;
		[Bindable]
		public var monNotUse:Boolean = false;		
		[Bindable]
		public var tueNotUse:Boolean = false;
		[Bindable]
		public var wedNotUse:Boolean = false;
		[Bindable]
		public var thuNotUse:Boolean = false;
		[Bindable]
		public var friNotUse:Boolean = false;
		[Bindable]
		public var satNotUse:Boolean = false;
		/*******************숫자********************/
		[Bindable]
		public var maxNumUse:Boolean = false;
		[Bindable]
		public var maxNum:int = 10;
		[Bindable]
		public var minNumUse:Boolean = false;
		[Bindable]
		public var minNum:int = 0;
		[Bindable]
		public var stepSize:int = 1;
		/*******************참조********************/
		[Bindable]
		public var refCategoryId:String;
		[Bindable]
		public var refCategoryName:String;
		[Bindable]
		public var refFormId:String;
		[Bindable]
		public var refFormVer:int;
		[Bindable]
		public var refFormName:String;
		[Bindable]
		public var refFormFieldId:String;
		[Bindable]
		public var refFormFieldName:String;
		[Bindable]
		public var refFormFieldType:String;

		public var formRef:FormRef;
		/*******************통화********************/
		[Bindable]
		public var currencyCode:String = "￦";
		
		[Bindable]
		public var autoIndexRuleList:ArrayCollection = new ArrayCollection();
					
		public function clone():FormFormatInfo{
			var formFormatInfo:FormFormatInfo = new FormFormatInfo();
			
			formFormatInfo.type = type;
			if(type == FormatTypes.comboBox.type || type == FormatTypes.radioButton.type){
				formFormatInfo.listType = listType;
				formFormatInfo.staticListExamples = staticListExamples;
				formFormatInfo.refCodeCategoryId = refCodeCategoryId;
				formFormatInfo.refCodeCategoryName = refCodeCategoryName;
			}else if(type == FormatTypes.dateChooser.type){
				formFormatInfo.yearUse = yearUse;
				formFormatInfo.sunNotUse = sunNotUse;
				formFormatInfo.monNotUse = monNotUse;
				formFormatInfo.tueNotUse = tueNotUse;
				formFormatInfo.wedNotUse = wedNotUse;
				formFormatInfo.thuNotUse = thuNotUse;
				formFormatInfo.friNotUse = friNotUse;
				formFormatInfo.satNotUse = satNotUse;
			}else if(type == FormatTypes.numericStepper.type){
				formFormatInfo.maxNumUse = maxNumUse;
				formFormatInfo.maxNum = maxNum;
				formFormatInfo.minNumUse = minNumUse;
				formFormatInfo.minNum = minNum;
				formFormatInfo.stepSize = stepSize;
			}else if(type == FormatTypes.refFormField.type){
				formFormatInfo.refCategoryId = refCategoryId;
				formFormatInfo.refCategoryName = refCategoryName;
				formFormatInfo.refFormId = refFormId;
				formFormatInfo.refFormVer = refFormVer;
				formFormatInfo.refFormName = refFormName;
				formFormatInfo.refFormFieldId = refFormFieldId;
				formFormatInfo.refFormFieldName = refFormFieldName;
				formFormatInfo.refFormFieldType = refFormFieldType;
			}else if(type == FormatTypes.currencyInput.type){
				formFormatInfo.currencyCode = currencyCode;
			}

			return formFormatInfo;
		}
		
		public function toXML():XML{

			var formFormatInfoXML:XML= 
						<format type="" viewingType="">
						</format>;
			
			formFormatInfoXML.@type = type;
			formFormatInfoXML.@viewingType = type;
			
			var formFormatDetail:XML;
			if(type == FormatTypes.comboBox.type || type == FormatTypes.radioButton.type){
				formFormatDetail = 							
							<list type="" refCodeCategoryId="" refCodeCategoryName="">
								<staticItems>									
								</staticItems>
							</list>;
							
				formFormatDetail.@listType = listType;
				for each(var staticListExample:String in staticListExamples){
					XML(formFormatDetail.staticItems[0]).appendChild(new XML("<staticItem>" + staticListExample + "</staticItem>"));
				}
				formFormatDetail.@refCodeCategoryId = refCodeCategoryId;
				formFormatDetail.@refCodeCategoryName = refCodeCategoryName;
			}else if(type == FormatTypes.dateChooser.type){
				formFormatDetail = 							
							<date yearUse="" sunNotUse="" monNotUse="" tueNotUse="" wedNotUse="" thuNotUse="" friNotUse="" satNotUse=""/>;
							
				formFormatDetail.@yearUse = (yearUse)?"true":"false";
				formFormatDetail.@sunNotUse = (sunNotUse)?"true":"false";
				formFormatDetail.@monNotUse = (monNotUse)?"true":"false";
				formFormatDetail.@tueNotUse = (tueNotUse)?"true":"false";
				formFormatDetail.@wedNotUse = (wedNotUse)?"true":"false";
				formFormatDetail.@thuNotUse = (thuNotUse)?"true":"false";
				formFormatDetail.@friNotUse = (friNotUse)?"true":"false";
				formFormatDetail.@satNotUse = (satNotUse)?"true":"false";
				formFormatDetail.@thuNotUse = (thuNotUse)?"true":"false";
			}else if(type == FormatTypes.numericStepper.type){
				formFormatDetail = 							
							<numeric minNumUse="" minNum="" maxNumUse="" maxNum="" stepSize=""/>;
							
				formFormatDetail.@maxNumUse = maxNumUse?"true":"false";
				formFormatDetail.@maxNum = maxNum;
				formFormatDetail.@minNumUse = minNumUse?"true":"false";
				formFormatDetail.@minNum = minNum;
				formFormatDetail.@stepSize = stepSize;
			}else if(type == FormatTypes.refFormField.type){
				formFormatDetail = 							
							<refForm id="" ver="">
								<name/>
								<category id="">								
								</category>
								<field id="">								
								</field>
							</refForm>;
				if(refFormId != null){
					formFormatDetail.@id = refFormId;
					formFormatDetail.@ver = refFormVer;
					formFormatDetail.name[0] = refFormName;
					
					if(formFormatDetail.category != null){
						formFormatDetail.category[0].@id = refCategoryId;
						formFormatDetail.category[0] = refCategoryName;
					}
										
					formFormatDetail.field[0].@id = refFormFieldId;
					formFormatDetail.field[0] = refFormFieldName;
					formFormatDetail.field[0].@type = refFormFieldType;
					
				}
			}else if(type == FormatTypes.currencyInput.type){
				formFormatDetail = 							
							<currency>
							</currency>;
							
				formFormatDetail.appendChild(currencyCode);
				formFormatInfoXML.@viewingType = type + "|" + currencyCode;
			}else if(type == FormatTypes.autoIndex.type){
				formFormatDetail = <autoIndexRules/>;				
				for each (var rule:AutoIndexRule in autoIndexRuleList)
					formFormatDetail.appendChild(rule.toXML());
			}else{
				formFormatDetail = new XML();
			}

			formFormatInfoXML.appendChild(formFormatDetail);
			
			return formFormatInfoXML;
		}
		
		public static function parseXML(formFormatInfoXML:XML):FormFormatInfo{
			var formFormatInfo:FormFormatInfo = new FormFormatInfo();
			
			formFormatInfo.type = formFormatInfoXML.@type;
			
			var formFormatDetail:XML;
			if(formFormatInfo.type == FormatTypes.comboBox.type || formFormatInfo.type == FormatTypes.radioButton.type){
				if(formFormatInfoXML.list[0] != null){
					formFormatInfo.listType = formFormatInfoXML.list[0].@listType;
	
					for each(var itemXML:XML in formFormatInfoXML.list[0].staticItems[0].staticItem){
						formFormatInfo.staticListExamples.addItem(itemXML.toString());
					}
				}
			}else if(formFormatInfo.type == FormatTypes.dateChooser.type){
				formFormatInfo.yearUse = (formFormatInfoXML.date[0].@yearUse == "true");
				formFormatInfo.sunNotUse = (formFormatInfoXML.date[0].@sunNotUse == "true");
				formFormatInfo.monNotUse = (formFormatInfoXML.date[0].@monNotUse == "true");
				formFormatInfo.tueNotUse = (formFormatInfoXML.date[0].@tueNotUse == "true");
				formFormatInfo.wedNotUse = (formFormatInfoXML.date[0].@wedNotUse == "true");
				formFormatInfo.thuNotUse = (formFormatInfoXML.date[0].@thuNotUse == "true");
				formFormatInfo.friNotUse = (formFormatInfoXML.date[0].@friNotUse == "true");
				formFormatInfo.satNotUse = (formFormatInfoXML.date[0].@satNotUse == "true");
			}else if(formFormatInfo.type == FormatTypes.numericStepper.type){
				formFormatInfo.maxNumUse = (formFormatInfoXML.numeric[0].@maxNumUse == "true");
				formFormatInfo.maxNum = new int(formFormatInfoXML.numeric[0].@maxNum);
				formFormatInfo.minNumUse = (formFormatInfoXML.numeric[0].@minNumUse == "true");
				formFormatInfo.minNum = new int(formFormatInfoXML.numeric[0].@minNum);
				formFormatInfo.stepSize = new int(formFormatInfoXML.numeric[0].@stepSize);
			}else if(formFormatInfo.type == FormatTypes.refFormField.type){
				formFormatInfo.refCodeCategoryId = formFormatInfoXML.list.@refCodeCategoryId;
				formFormatInfo.refCodeCategoryName = formFormatInfoXML.list.@refCodeCategoryName;
				
				if(formFormatInfoXML.refForm[0] != null && formFormatInfoXML.refForm[0].toString() != ""){
					formFormatInfo.refFormId  = formFormatInfoXML.refForm[0].@id;
					formFormatInfo.refFormVer  = formFormatInfoXML.refForm[0].@ver;
					formFormatInfo.refFormName  = formFormatInfoXML.refForm[0].name[0].toString();
					
					if(formFormatInfoXML.refForm[0].category[0] != null && formFormatInfoXML.refForm[0].category[0].toString() != ""){
						formFormatInfo.refCategoryId = formFormatInfoXML.refForm[0].category[0].@id;
						formFormatInfo.refCategoryName = formFormatInfoXML.refForm[0].category[0].toString();
					}
					
					formFormatInfo.refFormFieldId = formFormatInfoXML.refForm[0].field[0].@id;
					formFormatInfo.refFormFieldName = formFormatInfoXML.refForm[0].field[0].toString();
					formFormatInfo.refFormFieldType = formFormatInfoXML.refForm[0].field[0].@type;
				}
			}else if(formFormatInfo.type == FormatTypes.currencyInput.type){
				if(formFormatInfoXML.currency[0] != null && formFormatInfoXML.currency[0].toString() != ""){
					formFormatInfo.currencyCode  = formFormatInfoXML.currency[0].toString();
				}
			}else if(formFormatInfo.type == FormatTypes.autoIndex.type){
				if(formFormatInfoXML.autoIndexRules[0] != null){
					for each(var listXML:XML in formFormatInfoXML.autoIndexRules[0].autoIndexRule){
						var rule:AutoIndexRule = AutoIndexRule.parseXML(listXML);
						formFormatInfo.autoIndexRuleList.addItem(rule);
					}
				}
			}
			
			return formFormatInfo;
		}
	}
}