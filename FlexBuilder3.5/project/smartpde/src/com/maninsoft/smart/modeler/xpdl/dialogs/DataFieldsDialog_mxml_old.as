////////////////////////////////////////////////////////////////////////////////
//  DataFieldsDialog_mxml.as - DataFieldsDialog.mxml
//  2008.01.03, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
////////////////////////////////////////////////////////////////////////////////

//import com.maninsoft.smart.modeler.xpdl.dialogs.DataFieldsDialog;

import com.maninsoft.smart.modeler.xpdl.dialogs.DataFieldsDialog;
import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
import com.maninsoft.smart.modeler.xpdl.model.process.DataField;

import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Keyboard;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.ListEvent;
import mx.managers.PopUpManager;

//----------------------------------------------------------------------
// Class Variables
//----------------------------------------------------------------------

private static var _dialog: DataFieldsDialog;


//----------------------------------------------------------------------
// Variables
//----------------------------------------------------------------------

private var _activity: Activity;

[Bindable]
private var _dataFields: ArrayCollection;

//----------------------------------------------------------------------
// Class methods
//----------------------------------------------------------------------

public static function execute(activity: Activity, parent: DisplayObject, x: int, y: int): void {
	_dialog = PopUpManager.createPopUp(parent, DataFieldsDialog, true) as DataFieldsDialog;

	_dialog._activity = activity;
	_dialog.title = "DataFields - " + activity.name;
	_dialog.x = x;
	_dialog.y = y;
	
	_dialog.load();
}


//----------------------------------------------------------------------
// Properties
//----------------------------------------------------------------------

public function get activity(): Activity {
	return _activity;
}


//----------------------------------------------------------------------
// Internal methods
//----------------------------------------------------------------------

private function load(): void {
	_dataFields = new ArrayCollection(_activity.dataFields);
	grdFields.dataProvider = _dataFields;

	checkButtons();
	edName.setFocus();
}

private function checkButtons(): void {
	cmUpdate.enabled = grdFields.selectedItem;
	cmDelete.enabled = grdFields.selectedItem;
}

private function close(accept: Boolean = true): void {
	if (accept)
		_activity.dataFields = _dataFields.toArray();
		
	PopUpManager.removePopUp(this);
}


//----------------------------------------------------------------------
// Event handlers
//----------------------------------------------------------------------

//------------------------
// Dialog
//------------------------

private function dlg_close(): void {
	close();
}

private function dlg_keyDown(event: KeyboardEvent): void {
	if (event.keyCode == Keyboard.ESCAPE)
		close();
}	

//------------------------
// grdFields
//------------------------

private function grdFields_change(event: ListEvent): void {
	if (grdFields.selectedItem) {
		edName.text = grdFields.selectedItem.name;
		cmbDataType.selectedItem = grdFields.selectedItem.dataType;
	} else {
		edName.text = "";
		cmbDataType.selectedItem = "STRING";
	}
	
	checkButtons();
}


//------------------------
// cmCreate
//------------------------

private function cmCreate_click(event: MouseEvent): void {
	if (edName.text) {
		if (!activity.checkUniqueDataField(edName.text)) {
			Alert.show(resourceManager.getString("ProcessEditorMessages", "PEW001"));
			return;
		}
		
		var fld: DataField = new DataField(activity);
	
		fld.name = edName.text;
		fld.dataType = cmbDataType.selectedItem.toString();
		
		_dataFields.addItem(fld);
		
		grdFields.selectedIndex = grdFields.rowCount - 1;
		edName.text = "";
	
	} else {
		Alert.show(resourceManager.getString("ProcessEditorMessages", "PEW002"));
	}
}

//------------------------
// cmUpdate
//------------------------

private function cmUpdate_click(event: MouseEvent): void {
	if (grdFields.selectedItem && edName.text) {
		var idx: int = grdFields.selectedIndex;
		
		grdFields.selectedItem.name = edName.text;
		grdFields.selectedItem.dataType = cmbDataType.selectedItem;
		
		grdFields.dataProvider = _dataFields;
		grdFields.selectedIndex = idx;
	}
}

//------------------------
// cmDelete
//------------------------

private function cmDelete_click(event: MouseEvent): void {
	if (grdFields.selectedItem) {
		_dataFields.removeItemAt(grdFields.selectedIndex);
		_activity.dataFields = _dataFields.toArray();
	}
}


//------------------------
// cmDelete
//------------------------

private function cmClose_click(event: MouseEvent): void {
	close();
}
