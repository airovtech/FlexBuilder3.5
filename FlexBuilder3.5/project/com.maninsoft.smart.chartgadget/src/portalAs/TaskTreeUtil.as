// ActionScript file
import flash.events.*;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.xml.*;

import mx.controls.Tree;
import mx.events.TreeEvent;

import portalAs.Properties;
					
public var dataXML:XML;
public var selectedNode:Object;
public var selectedIndex:int;
public var xmlURL:String ;
public var tree_status:String = "init";
public var user_tree:Tree;
private var myLoader:URLLoader;
private var initFlag:Boolean = true;

public function treeInit(tree:Tree, url:String):void
{	
	this.user_tree = tree;
	this.xmlURL = url;
	dataCall(this.xmlURL);
}

public function dataCall(url:String):void
{
	var dataXMLURL:URLRequest = new URLRequest(url);
	this.myLoader = new URLLoader(dataXMLURL);
	this.myLoader.addEventListener("complete", this.xmlLoaded);
}	

public function xmlLoaded(evtObj:Event):void 
{ 
	if(this.tree_status == "init")
	{
		this.dataXML = new XML(this.myLoader.data);
		user_tree.dataProvider = this.dataXML;
		trace(dataXML.items.item.length());
		trace("---------------------------------------------------------------------");
		trace(dataXML.item.length());
		trace("---------------------------------------------------------------------");
		trace(dataXML.item);
		trace("---------------------------------------------------------------------");
		for(var i:int=0;i<dataXML.item.length();i++){
			user_tree.setItemIcon(dataXML.item[i], this[dataXML.item[i].@icon], this[dataXML.item[i].@icon]);
			
			var dataXmlList:XMLList = dataXML.item[i].children();
			if(dataXmlList.length() > 0){
				trace(dataXmlList.length());
				for(var j:int=0;j<dataXmlList.length();j++){
					var temp:XML = XML(dataXmlList[j]);
					user_tree.setItemIcon(temp, this[temp.@icon], this[temp.@icon]);
				}	
			}
		}
		if(initFlag){
			this.user_tree.openItems = dataXML..item;
			initFlag = false;
		}
	}
	else if(this.tree_status == "itemClick")
	{
		var childNode:XML = new XML(this.myLoader.data);
		this.expandTree(childNode.item);
	}
	else if(this.tree_status == "selCombo")
	{
		this.dataXML = new XML(this.myLoader.data);
		user_tree.dataProvider = this.dataXML;
	}
	trace(dataXML);
}

//트리를 클릭하여 해당 노드에  맞는 액션을 설정한다.
public function treeSelect():void
{
	this.tree_status = "itemClick"
	this.selectedIndex = user_tree.selectedIndex;
	this.selectedNode = user_tree.selectedItem;	
	var isOpened:String = this.isOpenedValue(user_tree.selectedItem);
	var id:String = user_tree.selectedItem.@id;
	
	var _packageVersion:String = user_tree.selectedItem.@packageVersion;
	var _packageId:String = user_tree.selectedItem.@packageId;
	var _targetUrl:String = user_tree.selectedItem.@targetUrl;
	var _processId:String = user_tree.selectedItem.@processId;
	var _version:String = user_tree.selectedItem.@version;
	var _formId:String = user_tree.selectedItem.@formId;
	var _clickType:String = user_tree.selectedItem.@clickType;
	var _label:String = user_tree.selectedItem.@label;
	
	if(isOpened == "false")
	{
		user_tree.selectedItem.@isOpened = "itemOpen";
		var tempXmlUrl:String = Properties.basePath + "smartserver/services/";
		if(_clickType == "categoryList"){//카테고리 목록 
			tempXmlUrl = tempXmlUrl + "common/categoryService.jsp?method=rootFindChildrenForTree&userId="+Properties.userId;
			dataCall(tempXmlUrl);
		} else if(_clickType == "packageList"){
			tempXmlUrl = tempXmlUrl + "runtime/searchingService.jsp?method=getPackageListByCategoryForTree&userId=" + Properties.userId + "&categoryId=" + id;
			dataCall(tempXmlUrl);
		} /* else if(_clickType == "formList"){
			tempXmlUrl = tempXmlUrl + "runtime/searchingService.jsp?method=getResourcesByPackageIdForTree&userId=" + Properties.userId + "&packageId=" + _packageId + "&version=" + _packageVersion;
			dataCall(tempXmlUrl);
		} */ 
	}
	else if(isOpened == "itemOpen")
	{
		user_tree.selectedItem.@isOpened = "itemClose";
		user_tree.expandItem(this.selectedNode, false, true, true);	
 		dispatchEvent( new Event(TreeEvent.ITEM_CLOSE) ); 	
	}
	else
	{
		user_tree.selectedItem.@isOpened = "itemOpen";
		user_tree.expandItem(user_tree.selectedItem,true);	
	}
	
	if(_clickType == "process"){
		processIdVer = _processId + "|" + _version;
		clickedLabel = _label;
		FindApplication.getApplciation(this).viewstack1.selectedIndex = 6;
	} else if(_clickType == "singleWork"){
		formIdVer = _formId + "|" + _version;
		clickedLabel = _label;
		FindApplication.getApplciation(this).viewstack1.selectedIndex = 12;
	} else if(_clickType == "taskCab"){
		clickedLabel = _label;
		FindApplication.getApplciation(this).viewstack1.selectedIndex = int(_targetUrl);
	} else if(_clickType == "procInit"){
		formIdProcessIdVer = _formId + "|" + user_tree.getParentItem(this.selectedNode).@processId + "|" + user_tree.getParentItem(this.selectedNode).@version;
		clickedLabel = _label;
		FindApplication.getApplciation(this).viewstack1.selectedIndex = 13;
	} 
}

/* public function treeOpening(event:TreeEvent):void {
	var itemObj:Object = event.item;
	
	this.tree_status = "itemClick";
	this.selectedIndex = this.getSelectItemIndex(itemObj);
	this.selectedNode = itemObj;
	var nodeType:String = itemObj.@nodeType;
	var isOpened:String = this.isOpenedValue(itemObj);
	var id:String = itemObj.@id;
	var _packageVersion:String = itemObj.@packageVersion;
	var _packageId:String = itemObj.@packageId;	
	var _clickType:String = itemObj.@clickType;
	var _processId:String = itemObj.@processId;
	var _version:String = itemObj.@version;
		
	if(isOpened == "false")
	{
		this.selectedNode.@isOpened = "itemOpen";
		var tempXmlUrl:String = Properties.basePath + "smartserver/services/";

		if(_clickType == "categoryList"){//카테고리 목록 
			tempXmlUrl = tempXmlUrl + "common/categoryService.jsp?method=rootFindChildrenForTree&userId="+Properties.userId;
			dataCall(tempXmlUrl);
		} else if(_clickType == "packageList"){
			tempXmlUrl = tempXmlUrl + "builder/builderService.jsp?method=getPackageListByCategoryForTree&userId=" + Properties.userId + "&categoryId=" + id;
			dataCall(tempXmlUrl);
		} else if(_clickType == "formList"){
			tempXmlUrl = tempXmlUrl + "runtime/searchingService.jsp?method=getResourcesByPackageIdForTree&userId=" + Properties.userId + "&packageId=" + _packageId + "&version=" + _packageVersion;
			dataCall(tempXmlUrl);
		} 
	}
	else if(isOpened == "itemOpen")
	{
		itemObj.@isOpened = "itemClose";
	}
	else
	{
		itemObj.@isOpened = "itemOpen";
		user_tree.expandItem(itemObj,true);	
	}
} */

//해당 인덱스 구하기 
public function getSelectItemIndex(selectItem:Object):int
{
	var childNode:XML = new XML(this.myLoader.data);
	var _dataProvider:XMLList = childNode.item;
	var selectIndex:int = 0;
	for(var x:int=0;x< _dataProvider.length();x++)
	{
		if(_dataProvider.@id == selectItem.@id)
		{
			selectIndex = x;
			break;
		}
	}
	return selectIndex;
}

// 해당 폴더 트리 오픈하기 
public function expandTree(childNode:XMLList):void
{
    //user_tree.openItems = []; 전체 닫
	var index:int = this.selectedIndex;
	var node:XML = this.selectedNode as XML;
	var parentNode:*;
	
	parentNode = node;
	index = 0;
	
	// 하위 노드추가하기 
	for(var x:int=0;x<childNode.length();x++) {
		var tag:int = Math.abs(childNode.length()-x)-1;
		var childData:XML = new XML(childNode[tag]);
		user_tree.setItemIcon(childData, this[childData.@icon], this[childData.@icon]);	
 		user_tree.dataDescriptor.addChildAt(parentNode,childData,index);
	}
		 		
	user_tree.expandItem(this.selectedNode, true, true, true);	
}

// 한번 오픈되었던 폴더는 더이상 노드를 추가하지 않는다.
public function isOpenedValue(itemObj:Object):String
{
	var nodeType:String = itemObj.@nodeType;
	var isOpenedValue:String = itemObj.@isOpened;
	var isOpened:String = itemObj.@isOpened;
	
	if(isOpened == "" || isOpened == "false" || isOpened == null) {
		isOpenedValue = "false";
	}
	else {
		isOpenedValue = isOpened;
	}
	return isOpenedValue;
}