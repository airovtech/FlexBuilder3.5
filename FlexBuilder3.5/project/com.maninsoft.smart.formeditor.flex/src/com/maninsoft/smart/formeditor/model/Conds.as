package com.maninsoft.smart.formeditor.model
{
	import com.maninsoft.smart.common.util.SmartUtil;
	
	import mx.collections.ArrayCollection;
	
	public class Conds extends AbstractCond
	{		

		public static const OPERATOR_AND:String = "and";
		public static const OPERATOR_OR:String = "or";
		public static const OPERATOR_AND_SYMBOL:String = "&&";
		public static const OPERATOR_OR_SYMBOL:String = "||";
		
		private var _conds:ArrayCollection = new ArrayCollection();
		
		public function Conds()
		{
			this.operator = OPERATOR_AND;
		}
		
		public function get conds():ArrayCollection {
			return _conds;
		}
		public function set conds(conds:ArrayCollection):void {
			if (!SmartUtil.isEmpty(conds)) {
				for each (var cond:AbstractCond in conds)
					cond.parent = this;
			}
			this._conds = conds;
		}
		
		override public function set parent(parent:Conds):void {
			super.parent = parent;
			this.conds = this._conds;
		}
		
		public function addCond(cond:AbstractCond, index:int = -1):void {
			if (this.conds == null) {
				conds = new ArrayCollection();
			} else if (this.conds.contains(cond)) {
				return;
			}
			cond.parent = this;
			if (index == -1) {
				this.conds.addItem(cond);
			} else {
				this.conds.addItemAt(cond, index);
			}
		}
		public function removeCond(cond:AbstractCond):void {
			if (SmartUtil.isEmpty(this.conds) || !this.conds.contains(cond))
				return;
			this.conds.removeItemAt(this.conds.getItemIndex(cond));
		}
		
		override public function clone():AbstractCond{
			var conds:Conds = new Conds();
			
			conds.operator = operator;
			
			for each (var cond:AbstractCond in this.conds) {
				var cloneCond:AbstractCond = cond.clone();
				conds.addCond(cloneCond);
			}
			
			return conds;
		}
		override public function toXML():XML {
			var condsXML:XML = <conds/>;
				
			condsXML.@operator = operator;
			
			for each (var cond:AbstractCond in this.conds)
				condsXML.appendChild(cond.toXML());
			
			return condsXML;
		}
		public static function parseXML(condsXML:XML):Conds {
			var conds:Conds = new Conds();
			
			conds.operator = condsXML.@operator;
			
			for each(var condXml:XML in condsXML.children()){
				var cond:AbstractCond;
				if(condXml.localName() == 'conds'){
					cond = Conds.parseXML(condXml);
				}else{
					cond = Cond.parseXML(condXml);
				}
				cond.parent = conds;
				conds.addCond(cond);
			}
			
			return conds;
		}
	}
}