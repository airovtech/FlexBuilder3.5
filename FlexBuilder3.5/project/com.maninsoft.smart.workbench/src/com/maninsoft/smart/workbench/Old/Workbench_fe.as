// ActionScript file
import com.maninsoft.smart.formeditor.refactor.event.FormEditEvent;
import com.maninsoft.smart.formeditor.refactor.event.FormPropertyEvent;
import com.maninsoft.smart.formeditor.util.FormEditorConfig;
import com.maninsoft.smart.workbench.common.util.MsgUtil;


private function registerFormEvent():void{
	this.addEventListener(FormEditEvent.SELECT_FORM_DOCUMENT, selectFormDocument, true);
	this.addEventListener(FormEditEvent.SELECT_FORM_ITEM, selectFormItem, true);
	this.addEventListener(FormEditEvent.SELECT_FORM_ITEMS, selectFormItems, true);
	
	this.addEventListener(FormEditEvent.OPEN_PROP_FORM_ITEM, openFormItemProp, true);
	this.addEventListener(FormEditEvent.OPEN_PROP_FORM_DOCUMENT, openFormDocumentProp, true);
	
	this.addEventListener(FormPropertyEvent.UPDATE_FORM_STRUCTURE, updateFormStructure, true);					
}

/**************************폼 문서 변경****************************************/
// 폼 문서 오픈 
private function selectFormDocument(event:FormEditEvent):void{
	var formResources:ArrayCollection = new ArrayCollection();
	formResources.addItem(event.formDocument);				
	formEditor.formEditor.selectFormResource(formResources);
	
//	formPropertyEditor.load(this.formEditor.formEditor.formModel);
}
// 폼 아이템 오픈 
private function selectFormItem(event:FormEditEvent):void{
	var formResources:ArrayCollection = new ArrayCollection();
	formResources.addItem(event.formItem);				
	formEditor.formEditor.selectFormResource(formResources);
	
//	formPropertyEditor.load(this.formEditor.formEditor.formModel, event.formItem);
}
// 멀티 폼 아이템 오픈 
private function selectFormItems(event:FormEditEvent):void{
	formEditor.formEditor.selectFormResource(event.formItems);
	
	// TODO 멀티 실렉션 프로퍼티 처리
}
// 멀티 폼 아이템 오픈 
private function updateFormStructure(event:FormPropertyEvent):void{
	formEditor.formEditor.refreshVisual();
}

private function openFormItemProp(event:FormEditEvent):void{
	propertyPop(formEditorPropertyStage); 
}

private function openFormDocumentProp(event:FormEditEvent):void{	
	propertyPop(formEditorPropertyStage); 
}
/****************************폼 에디터 메뉴*********************************/
[Bindable]
public var formMenuBarCollection:XMLListCollection;

private var formMenubarXML:XMLList =
    <>
        <menuitem label="파일" data="file">
            <menuitem label="저장" data="save"/>
            <menuitem label="불러오기" data="load"/>
        </menuitem>
        <menuitem label="편집" data="edit">
            <menuitem label="취소" data="undo"/>
            <menuitem label="다시실행" data="redo"/>
        </menuitem>
        <menuitem label="디버그" data="debug">
            <menuitem label="인자" data="parameter"/>
        </menuitem>                    
    </>;

// Event handler to initialize the MenuBar control.
private function initFormMenuBar():void {
    formMenuBarCollection = new XMLListCollection(formMenubarXML);
}

private function selectFormMenu(event:MenuEvent):void{
	if(event.item.@data == "save"){
		formEditor.formEditor.saveForm();
	}else if(event.item.@data == "load"){
		formEditor.formEditor.loadForm();
	}else if(event.item.@data == "parameter"){
		debugParameter();
	}
}

// 파라미터를 디버그 창에 보여줌			
public function debugParameter():void{
	MsgUtil.showMsg("serviceUrl : " + FormEditorConfig.serviceUrl + "\n sessionUserId : " +  FormEditorConfig.userId + "\n formId : " + this.swForm.id);
}	