package com.maninsoft.smart.common.util
{
	import mx.collections.ArrayCollection;
	
	public class Map
	{
		private var keys:ArrayCollection = new ArrayCollection();
		private var values:ArrayCollection = new ArrayCollection();
		
		public function put(key:Object, value:Object):void {
			if(containsKey(key)) {
				if (getValue(key) == value)
					return;
				remove(key);
			}
			this.keys.addItem(key);	
			this.values.addItem(value);
		}
		
		public function getValue(key:Object):Object {
			if(containsKey(key))
				return this.values.getItemAt(keys.getItemIndex(key));			
			return null;
		} 	
		
		public function size():int{
			return keys.length;
		}
		
		public function clear():void{
			this.keys.removeAll();
			this.values.removeAll();
		}
		public function isEmpty():Boolean{
			return keys.length == 0;
		}
		public function containsKey(key:Object):Boolean {
			return keys.contains(key);
		}
		public function containsValue(value:Object):Boolean {
			return this.values.contains(value);
		}
		public function valuesArray():ArrayCollection{
			return this.values;
		}
		public function putAll(map:Map):void {
			if(map == null)
				return;
			for each (var key:Object in map.keys)
				this.put(key, map.getValue(key));
		}
		public function getKeys():Array {
			return this.keys.toArray();
		}
		public function getValues():Array {
			return this.values.toArray();
		}
		public function remove(key:Object):Object {
			var index:int = this.keys.getItemIndex(key);
			this.keys.removeItemAt(index);
			return this.values.removeItemAt(index);
		}
	}
}