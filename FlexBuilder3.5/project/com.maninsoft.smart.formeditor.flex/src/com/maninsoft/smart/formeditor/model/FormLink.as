package com.maninsoft.smart.formeditor.model
{
	public class FormLink
	{
		public var parent:FormLinks;
		
		public var id:String;
		public var name:String;
		public var targetFormId:String;
		private var _conds:Conds;
		
		public function FormLink(parent:FormLinks){
			super();
			this.parent = parent;
			this.id = this.parent.form.generateEntityId();
			this.conds = new Conds();
		}
		
		public function get conds():Conds {
			return _conds;
		}
		public function set conds(conds:Conds):void {
			this._conds = conds;
			this._conds.formLink = this;
		}
		
//		public function clone():FormLink{
//			var formLink:FormLink = new FormLink(parent);
//
//			formLink.id = this.id;
//			formLink.name = this.name;
//			formLink.targetFormId = this.targetFormId;
//						
//			formLink.conds = this.conds.clone() as Conds;
//			
//			return formLink;
//		}
		
		public function clone():FormLink {
			return FormLink(parseXML(parent, this.toXML()));
		}
		public function toXML():XML{
			var formLinkXML:XML = <mappingForm/>;
			
			formLinkXML.@id = id;
			formLinkXML.@name = name;
			formLinkXML.@targetFormId = targetFormId;
			
			formLinkXML.appendChild(conds.toXML());
				
			return formLinkXML;
		}
		public static function parseXML(parent:FormLinks, formLinkXML:XML):FormLink{
			var formLink:FormLink = new FormLink(parent);

			formLink.id = formLinkXML.@id;
			formLink.name = formLinkXML.@name;
			formLink.targetFormId = formLinkXML.@targetFormId;
			
			formLink.conds = Conds.parseXML(formLinkXML.conds[0]);
			
			return formLink;
		}	

	}
}