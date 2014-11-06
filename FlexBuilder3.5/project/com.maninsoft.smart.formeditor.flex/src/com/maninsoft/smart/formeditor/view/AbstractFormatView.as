package com.maninsoft.smart.formeditor.view
{
	import com.maninsoft.smart.formeditor.model.FormEntity;
	import com.maninsoft.smart.formeditor.model.type.FormatType;
	import com.maninsoft.smart.formeditor.model.type.FormatTypes;
	import com.maninsoft.smart.formeditor.refactor.editor.FormEditDomain;
	
	import mx.containers.Box;
	
	public class AbstractFormatView extends Box implements IFormatView
	{
		private var _editDomain:FormEditDomain;
		private var _fieldModel:FormEntity;
		private var _fieldView:FieldView;
		private var _option:Object;
		
		public function AbstractFormatView()
		{
			this.styleName = "formFormat";
		}
		
		public function get formatType():FormatType {
			return FormatTypes.textInput;
		}

		public function get fieldModel():FormEntity {
		    return this._fieldModel;
		}
		public function set fieldModel(fieldModel:FormEntity):void {
		    this._fieldModel = fieldModel;
		}
		public function get option():Object {
		    return this._option;
		}
		public function set option(option:Object):void {
		    this._option = option;
		}
		public function get fieldView():FieldView {
		    return this._fieldView;
		}
		public function set fieldView(fieldView:FieldView):void {
		    this._fieldView = fieldView;
		}
		public function get editDomain():FormEditDomain {
		    return this._editDomain;
		}
		public function set editDomain(editDomain:FormEditDomain):void {
		    this._editDomain = editDomain;
		}
		
		public function refreshVisual():void {
		}
		public function release():void {
		}
	}
}