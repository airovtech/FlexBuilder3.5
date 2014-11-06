package mxmlComponet.gadget.column{
	import mx.collections.ArrayCollection;
	import mxmlComponet.gadget.model.GadgetColumn;
	
	public class WorkListedGadgetColumns extends SupperGadgetColumns{
		public override function getColumnArray():ArrayCollection{
			gadgetColumns = new ArrayCollection([
				new GadgetColumn("title", "제목", "", false),
				new GadgetColumn("status", "상태", "", false),
				new GadgetColumn("assigneeType", "할당자타입", "", false),
				new GadgetColumn("assignee", "할당자", "", false),
				new GadgetColumn("performer", "수행자", "", false),
				new GadgetColumn("keyword", "키워드", "", false),
				new GadgetColumn("importance", "중요도", "", false),
				new GadgetColumn("priority", "긴급도", "", false),
				new GadgetColumn("createdTime", "생성시간", "", false),
				new GadgetColumn("completedTime", "완료시간", "", false),
				new GadgetColumn("previousId", "워크아이템ID", "", false),
				new GadgetColumn("type", "타입", "", false),
				new GadgetColumn("refId", "참조ID", "", false),
				new GadgetColumn("groupId", "GroupID", "", false),
				new GadgetColumn("description", "설명", "", false),
				new GadgetColumn("data", "테이터", "", false)
			]);
			return gadgetColumns;
		}
	}
}