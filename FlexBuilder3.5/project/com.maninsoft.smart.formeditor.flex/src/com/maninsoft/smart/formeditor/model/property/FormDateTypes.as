package com.maninsoft.smart.formeditor.model.property
{
	import mx.collections.ArrayCollection;
	
	public class FormDateTypes
	{
		private static var formDateTypes:ArrayCollection;
		
		private static var formDateTypesXML:XML=
			<formDateTypes>
				<formDateType>
					<locale type="KR">한국어</locale>
					<days>
						<day>일요일</day>
						<day>월요일</day>
						<day>화요일</day>
						<day>수요일</day>
						<day>목요일</day>
						<day>금요일</day>
						<day>토요일</day>
					</days>
					<dayShorts>
						<dayShort>일</dayShort>
						<dayShort>월</dayShort>
						<dayShort>화</dayShort>
						<dayShort>수</dayShort>
						<dayShort>목</dayShort>
						<dayShort>금</dayShort>
						<dayShort>토</dayShort>
					</dayShorts>
					<months>
						<month>1월</month>
						<month>2월</month>
						<month>3월</month>
						<month>4월</month>
						<month>5월</month>
						<month>6월</month>
						<month>7월</month>
						<month>8월</month>
						<month>9월</month>
						<month>10월</month>
						<month>11월</month>
						<month>12월</month>
					</months>
					<times>
						<time>오전</time>
						<time>오후</time>
					</times>
					<dateFormats>
						<format>DD-MMM</format>
						<format>*YYYY-MM-DD</format>
						<format>*YYYY년 M월 DD일 EEEE</format>
						<format>YYYY년 M월 DD일</format>
						<format>YY年 M月 DD日</format>
						<format>YYYY년 M월</format>
						<format>M월 DD일</format>
						<format>YY-M-DD</format>
						<format>YY-M-DD HH:NN</format>
						<format>YY-M-DD A KK:NN</format>
						<format>YY-M-DD KK:NN A</format>
						<format>YY/M/DD</format>
						<format>YYYY-M-DD</format>
						<format>YYYY/M/DD</format>
						<format>M/DD</format>
						<format>M/DD/YY</format>
						<format>MM/DD/YY</format>
						<format>DD-MMM-YY</format>
						<format>MMM-DD</format>
						<format>MMMM-DD</format>
					</dateFormats>
					<timeFormats>
						<format>H:NN</format>
						<format>H:NN:SS</format>
						<format>A K:NN</format>
						<format>A K:NN:SS</format>
						<format>YYYY-MM-DD H:NN</format>
						<format>YYYY-MM-DD A K:NN</format>
						<format>HH시 NN분</format>
						<format>HH시 NN분 SS초</format>
						<format>A K시 NN분</format>
					</timeFormats>
				</formDateType>
				<formDateType>
					<locale type="US">영어</locale>
					<days>
						<day>Sunday</day>
						<day>Monday</day>
						<day>Tuesday</day>
						<day>Wednesday</day>
						<day>Thursday</day>
						<day>Friday</day>
						<day>Saturday</day>
					</days>
					<dayShorts>
						<dayShort>Sun</dayShort>
						<dayShort>Mon</dayShort>
						<dayShort>Tue</dayShort>
						<dayShort>Wed</dayShort>
						<dayShort>Thu</dayShort>
						<dayShort>Fri</dayShort>
						<dayShort>Sat</dayShort>
					</dayShorts>
					<months>
						<month>January</month>
						<month>February</month>
						<month>March</month>
						<month>April</month>
						<month>May</month>
						<month>June</month>
						<month>July</month>
						<month>August</month>
						<month>September</month>
						<month>October</month>
						<month>November</month>
						<month>December</month>
					</months>
					<monthShorts>
						<monthShort>Jan</monthShort>
						<monthShort>Feb</monthShort>
						<monthShort>Mar</monthShort>
						<monthShort>Apr</monthShort>
						<monthShort>May</monthShort>
						<monthShort>Jun</monthShort>
						<monthShort>Jul</monthShort>
						<monthShort>Aug</monthShort>
						<monthShort>Sep</monthShort>
						<monthShort>Oct</monthShort>
						<monthShort>Nov</monthShort>
						<monthShort>Dec</monthShort>
					</monthShorts>
					<times>
						<time>AM</time>
						<time>PM</time>
					</times>
					<dateFormats>
						<format>M-DD</format>
						<format>M-DD-YY</format>
						<format>MM-DD-YY</format>
						<format>DD-MMM</format>
						<format>DD-MMM-YY</format>
						<format>MMM-YY</format>
						<format>MMMM-YY</format>
						<format>MMMM DD, YYYY</format>
						<format>M-DD-YY KK:NN A</format>
						<format>M-DD-YY HH:NN</format>
						<format>M-DD-YYYY</format>
						<format>DD-MMM-YYYY</format>
					</dateFormats>
					<timeFormats>
						<format>H:NN</format>
						<format>K:NN A</format>
						<format>H:NN:SS</format>
						<format>K:NN:SS A</format>
						<format>M-DD-YY K:NN A</format>
						<format>M-DD-YY H:NN</format>
					</timeFormats>
				</formDateType>
			</formDateTypes>;
		
		public static function getFormDateTypes():ArrayCollection{
			if(formDateTypes == null){
				formDateTypes = new ArrayCollection();
				for each(var formDateTypeXML:XML in formDateTypesXML.formDateType){
					var formDateType:FormDateType = new FormDateType();
					formDateType.localeLabel = formDateTypeXML.locale.toString();
					formDateType.localeType = formDateTypeXML.locale.@type;
					for each(var dateFormatXML:XML in formDateTypeXML.dateFormats.format){
						var dateObj:Object = new Object();
						dateObj.formatString = dateFormatXML.toString();
						formDateType.dateFormatStrings.addItem(dateObj);
					}
					for each(var timeFormatXML:XML in formDateTypeXML.timeFormats.format){
						var timeObj:Object = new Object();
						timeObj.formatString = timeFormatXML.toString();
						formDateType.timeFormatStrings.addItem(timeObj);
					}
					for each(var dayXML:XML in formDateTypeXML.days.day){
						formDateType.days.push(dayXML.toString());
					}
					for each(var dayShortXML:XML in formDateTypeXML.dayShorts.dayShort){
						formDateType.dayShorts.push(dayShortXML.toString());
					}
					for each(var monthXML:XML in formDateTypeXML.months.month){
						formDateType.months.push(monthXML.toString());
					}
					for each(var monthShortXML:XML in formDateTypeXML.monthShorts.monthShort){
						formDateType.monthShorts.push(monthShortXML.toString());
					}
					if(formDateType.monthShorts.length == 0){
						formDateType.monthShorts = formDateType.months;
					}
					for each(var timeXML:XML in formDateTypeXML.times.time){
						formDateType.times.push(timeXML.toString());
					}
					formDateTypes.addItem(formDateType);
				}
			}
			
			return formDateTypes;
		}
		
		public static function getLocaleTypeIndex(localeType:String):int{
			var formDateTypes:ArrayCollection = getFormDateTypes();
			for(var i:int = 0 ; i < formDateTypes.length ; i++){
				var formDateType:FormDateType = FormDateType(formDateTypes.getItemAt(i));
				if(formDateType.localeType == localeType)
					return i;
			}
			return -1;
		}

	}
}