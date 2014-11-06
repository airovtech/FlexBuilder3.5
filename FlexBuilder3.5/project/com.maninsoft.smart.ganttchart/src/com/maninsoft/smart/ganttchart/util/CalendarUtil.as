package com.maninsoft.smart.ganttchart.util
{
			import mx.formatters.DateFormatter;

    public class CalendarUtil
    {    
			    
       public static function getDaysInMonth(year:int, month:int):int {

		    var days:int;        
		    switch(month)
		    {
		    case 1:
		    case 3:
		    case 5:
		    case 7:
		    case 8:
		    case 10:
		    case 12:
		        days = 31;
		        break;
		    case 4:
		    case 6:
		    case 9:
		    case 11:
		        days = 30;
		        break;
		    case 2:
		        if (((year% 4)==0) && ((year% 100)!=0) || ((year% 400)==0))                
		            days = 29;                
		        else                                
		            days = 28;                
		        break;
		    }
		    return (days);
		}                

		public static function changeDateByPlusHours(inDate:Date, inHours:int ):void{

			if(inDate==null || inHours<=0){
				return;
			}
			var tYear:int = inDate.getFullYear();
			var tMonth:int = inDate.getMonth();
			var tDay:int = inDate.getDate();
			var tHour:int = inDate.getHours();
			var daysInMonth:int=0;

			tHour = tHour+inHours;
			while(tHour>24){
				daysInMonth=getDaysInMonth(tYear,tMonth+1);
				tHour=tHour-24;
				if(tDay==daysInMonth){
					tMonth++;
					tDay=1;
					if(tMonth==12){
						tYear++;
						tMonth=0;
					}
				}
				else{
					tDay++;
				}
			}
	
			inDate.setFullYear(tYear,tMonth,tDay);
			inDate.setHours(tHour);
			return;
						
		}		
		public static function changeDateByMinusHours(inDate:Date, inHours:int ):void{

			if(inDate==null || inHours<=0){
				return;
			}
			var tYear:int = inDate.getFullYear();
			var tMonth:int = inDate.getMonth();
			var tDay:int = inDate.getDate();
			var tHour:int = inDate.getHours();
			var daysInMonth:int;

			tHour = tHour-inHours;
			while(tHour<0){
				tDay--;
				if(tDay==0){
					tMonth--;
					if(tMonth==-1){
						tYear--;
						tMonth=11;
					}
					daysInMonth=getDaysInMonth(tYear,tMonth+1);
					tDay=daysInMonth;
				}
				tHour=tHour+24;
			}
			inDate.setFullYear(tYear,tMonth,tDay);
			inDate.setHours(tHour);
			return;
						
		}		
		public static function changeDateByPlusDays(inDate:Date, inDays:int ):void{

			if(inDate==null || inDays<=0){
				return;
			}
			var tYear:int = inDate.getFullYear();
			var tMonth:int = inDate.getMonth();
			var tDay:int = inDate.getDate();
			var daysInMonth:int=0;

			tDay = tDay+inDays;
			while(tDay>daysInMonth){
				daysInMonth=getDaysInMonth(tYear,tMonth+1);
				tDay=tDay-daysInMonth;
				if(tMonth==11){
					tYear++;
					tMonth=0;
				}
				else{
					tMonth++;
				}
			}
	
			inDate.setFullYear(tYear,tMonth,tDay);
			return;
						
		}		
		public static function changeDateByMinusDays(inDate:Date, inDays:int ):void{

			if(inDate==null || inDays<=0){
				return;
			}
			var tYear:int = inDate.getFullYear();
			var tMonth:int = inDate.getMonth();
			var tDay:int = inDate.getDate();

			tDay = tDay-inDays;
			while(tDay<=0){
				if(tMonth==0){
					tYear--;
					tMonth=11;
				}else{
					tMonth--;
				}
				tDay=tDay+getDaysInMonth(tYear,tMonth+1);
			}
			inDate.setFullYear(tYear,tMonth,tDay);
			return;
						
		}		
		public static function changeDateByPlusMonths(inDate:Date, inMonths:int ):void{

			if(inDate==null || inMonths<=0){
				return;
			}
			var tYear:int = inDate.getFullYear();
			var tMonth:int = inDate.getMonth();

			tMonth = tMonth+inMonths;
			while(tMonth>11){
				tMonth-=12;
				tYear++;
			}
	
			inDate.setFullYear(tYear,tMonth);
			return;
						
		}		
		public static function changeDateByMinusMonths(inDate:Date, inMonths:int ):void{

			if(inDate==null || inMonths<=0){
				return;
			}
			var tYear:int = inDate.getFullYear();
			var tMonth:int = inDate.getMonth();
			tMonth = tMonth-inMonths;
			while(tMonth<0){
				tMonth+=12;
				tYear--;
			}
			inDate.setFullYear(tYear,tMonth);
			return;
						
		}		
		
		public static function getCntChangeMonth(fromDate:Date, toDate:Date):Number {

		    var cnt:Number=0;        

			var fromYear:int = fromDate.getFullYear();
			var fromMonth:int = fromDate.getMonth();
			var fromDay:int = fromDate.getDate();
			var toYear:int = toDate.getFullYear();
			var toMonth:int = toDate.getMonth();
			var toDay:int = toDate.getDate();

			cnt += (24-fromDate.getHours())/24/getDaysInMonth(fromYear,fromMonth+1);
			if(fromDay==getDaysInMonth(fromYear,fromMonth+1)){
				if(fromMonth==11){
					fromYear++;
					fromMonth=0;
				}else{
					fromMonth++;
				}
				fromDay=1;
			}else{
				fromDay++;
			}
			
			cnt += (getDaysInMonth(fromYear,fromMonth+1)-fromDay)/getDaysInMonth(fromYear,fromMonth+1)
			if(fromMonth==11){
				fromMonth=0;
				fromYear++;
			}else{
				fromMonth++;
			}
			
			cnt += toDate.getHours()/24/getDaysInMonth(toYear,toMonth+1);
			cnt += toDay/getDaysInMonth(toYear,toMonth+1)
			cnt += (toYear-fromYear)*12;
			cnt += toMonth-fromMonth;
		  	return cnt  
		}           
		
		public static function stringToDate(valueString:String, inputFormat:String):Date
	    {
	        var mask:String
	        var temp:String;
	        var dateString:String = "";
	        var monthString:String = "";
	        var yearString:String = "";
	        var j:int = 0;
	
	        var n:int = inputFormat.length;
	        for (var i:int = 0; i < n; i++,j++)
	        {
	            temp = "" + valueString.charAt(j);
	            mask = "" + inputFormat.charAt(i);
	
	            if (mask == "M")
	            {
	                if (isNaN(Number(temp)) || temp == " ")
	                    j--;
	                else
	                    monthString += temp;
	            }
	            else if (mask == "D")
	            {
	                if (isNaN(Number(temp)) || temp == " ")
	                    j--;
	                else
	                    dateString += temp;
	            }
	            else if (mask == "Y")
	            {
	                yearString += temp;
	            }
	            else if (!isNaN(Number(temp)) && temp != " ")
	            {
	                return null;
	            }
	        }
	
	        temp = "" + valueString.charAt(inputFormat.length - i + j);
	        if (!(temp == "") && (temp != " "))
	            return null;
	
	        var monthNum:Number = Number(monthString);
	        var dayNum:Number = Number(dateString);
	        var yearNum:Number = Number(yearString);
	
	        if (isNaN(yearNum) || isNaN(monthNum) || isNaN(dayNum))
	            return null;
	
	        if (yearString.length == 2 && yearNum < 70)
	            yearNum+=2000;
	
	        var newDate:Date = new Date(yearNum, monthNum - 1, dayNum, 9);
	
	        if (dayNum != newDate.getDate() || (monthNum - 1) != newDate.getMonth())
	            return null;
	
	        return newDate;
	    }
	    
	    public static function dateToStringYYYYmmDD(date:Date):String
	    {
			
			var tmpDate:Date = date;
			var dateString:String;
			var strMonth:String;
			var strDate:String;
			var intMonth:int = tmpDate.getMonth()+1;
			
			if(intMonth<10) {
				strMonth = "0"+intMonth;
			} else {
				strMonth = intMonth.toString();
			}
			
			if(tmpDate.getDate()<10) {
				strDate = "0"+tmpDate.getDate();
			} else {
				strDate = tmpDate.getDate().toString();
			}
			
			dateString = tmpDate.getFullYear()+ "-" +strMonth+ "-" +strDate +" 09:00:00";
	
	        return dateString;
	    }
		
		public static function getTaskDate(value: String): Date{
			if(value==null || value.length<19) return null;
			
			var date:Date = new Date(value.substring(0,4), parseInt(value.substring(5,7))-1, value.substring(8,10));
			date.setHours(value.substring(11,13), value.substring(14,16), value.substring(17,19) );
			return date;
		}		    

		public static function getTaskString(date: Date): String{			
			if(date==null) return null;

			
			var dateFormatter: DateFormatter = new DateFormatter();
			dateFormatter.formatString = "YYYY-MM-DD JJ:NN:SS";
			return dateFormatter.format(date);
		}		    

		public static function getWorkDay(value: String): Date{
			if(value==null || value.length<19) return null;
			
			var date:Date = new Date(value.substring(0,4), parseInt(value.substring(5,7))-1, value.substring(8,10));
			return date;
		}		    

		public static function getWorkDayString(date: Date): String{			
			if(date==null) return null;

			var dateFormatter: DateFormatter = new DateFormatter();
			dateFormatter.formatString = "YYYY-MM-DD";
			return dateFormatter.format(date);
		}		    
    }
}