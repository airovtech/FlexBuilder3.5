package com.maninsoft.smart.formeditor.model
{
	import com.maninsoft.smart.common.util.SmartUtil;
	
	import mx.collections.ArrayCollection;
	
	public class ActualParameters extends AbstractActualParameter
	{		

		public static const EXECUTION_BEFORE:String = "before";
		public static const EXECUTION_AFTER:String = "after";
		
		private var _actualParameters:ArrayCollection = new ArrayCollection();
		
		public function ActualParameters()
		{
			this.execution = EXECUTION_BEFORE;
		}
		
		public function get actualParameters():ArrayCollection {
			return _actualParameters;
		}
		public function set actualParameters(actualParameters:ArrayCollection):void {
			if (!SmartUtil.isEmpty(actualParameters)) {
				for each (var actualParameter:ActualParameter in actualParameters)
					actualParameter.parent = this;
			}
			this._actualParameters = actualParameters;
		}
		
		override public function set parent(parent:ActualParameters):void {
			super.parent = parent;
			this.actualParameters = this._actualParameters;
		}
		
		public function addActualParameter(actualParameter:AbstractActualParameter, index:int = -1):void {
			if (this.actualParameters == null) {
				actualParameters = new ArrayCollection();
			} else if (this.actualParameters.contains(actualParameter)) {
				return;
			}
			actualParameter.parent = this;
			if (index == -1) {
				this.actualParameters.addItem(actualParameter);
			} else {
				this.actualParameters.addItemAt(actualParameter, index);
			}
		}
		public function removeActualParameter(actualParameter:AbstractActualParameter):void {
			if (SmartUtil.isEmpty(this.actualParameters) || !this.actualParameters.contains(actualParameter))
				return;
			this.actualParameters.removeItemAt(this.actualParameters.getItemIndex(actualParameter));
		}
		
		override public function clone():AbstractActualParameter{
			var actualParameters:ActualParameters = new ActualParameters();
			
			actualParameters.execution = execution;
			
			for each (var actualParameter:ActualParameter in this.actualParameters) {
				var cloneActualParameter:AbstractActualParameter = actualParameter.clone();
				actualParameters.addActualParameter(cloneActualParameter);
			}
			
			return actualParameters;
		}
		override public function toXML(dst:XML=null):XML {
			var paramsXML:XML = <ActualParameters/>;
			if(dst)	paramsXML = dst;

			paramsXML.@Execution = execution;
			
			if(!dst){
				for each (var actualParameter:ActualParameter in this.actualParameters)
					paramsXML.appendChild(actualParameter.toXML());
			}
			
			return paramsXML;
		}
		public static function parseXML(paramsXML:XML):ActualParameters {
			var actualParameters:ActualParameters = new ActualParameters();
			
			actualParameters.execution = paramsXML.@Execution;
			
			for each(var paramXml:XML in paramsXML.children()){
				var actualParameter:ActualParameter;
				actualParameter = ActualParameter.parseXML(paramXml);
				actualParameter.parent = actualParameters;
				actualParameters.addActualParameter(actualParameter);
			}
			
			return actualParameters;
		}
		
		public function toString():String{
			var text:String = "";
			for each(var actualParameter:ActualParameter in actualParameters){
				if(actualParameter.formalParameterMode == ActualParameter.FORMALPARAMETERMODE_OUT) continue;
				if (text!="") text += ", ";
				text += actualParameter.toString();
			}
			return text;
		}
	}
}