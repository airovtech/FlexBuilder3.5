package com.maninsoft.smart.formeditor.refactor.util
{
	import mx.collections.ArrayCollection;
	
	public class Map
	{
		private var keys:ArrayCollection = new ArrayCollection();
		private var values:ArrayCollection = new ArrayCollection();
		
		public function putItem(key:Object, value:Object):Boolean{
			if(containsKey(key))
				return false;
			this.keys.addItem(key);	
			this.values.addItem(value);
			return true;
		}
		
		public function getItem(key:Object):Object{
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
	    public function containsKey(key:Object):Boolean{
	    	return keys.contains(key);
	    }
	    public function containsValue(value:Object):Boolean{
	    	return this.values.contains(value);
	    }
	    public function valuesArray():ArrayCollection{
	    	return this.values;
	    }
	    public function putAll(map:Map):void{
	    	if(map == null)
	    		return;
	    		
	    	for each(var key:Object in map.getkeyArray()){
	    		this.putItem(key, map.getItem(key));
	    	}
	    }
	    public function getkeyArray():ArrayCollection{
	    	return this.keys;
	    }
	    public function remove(key:Object):Object{
	    	var index:int = this.keys.getItemIndex(key);
	    	this.keys.removeItemAt(index);
	    	return this.values.removeItemAt(index);
	    }
	}
}