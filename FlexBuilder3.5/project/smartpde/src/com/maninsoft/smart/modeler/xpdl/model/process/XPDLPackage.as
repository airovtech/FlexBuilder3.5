////////////////////////////////////////////////////////////////////////////////
//  XPDLPackage.as
//  2008.01.09, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model.process
{
	import com.maninsoft.smart.modeler.xpdl.model.Annotation;
	import com.maninsoft.smart.modeler.xpdl.model.DataObject;
	import com.maninsoft.smart.modeler.xpdl.model.Block;
	import com.maninsoft.smart.modeler.xpdl.model.Group;
	import com.maninsoft.smart.modeler.xpdl.model.Pool;
	import com.maninsoft.smart.modeler.xpdl.model.base.Artifact;
	
	/** 
	 * XPDLPackage
	 */
	public class XPDLPackage extends XPDLElement {
		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		public var id: String;
		public var name: String;
		public var artifacts: Array = [];
		
		private var _packageHeader: PackageHeader;
		private var _redefinableHeader: RedefinableHeader;
		private var _script: Script;
		private var _pool: Pool;
		private var _process: WorkflowProcess;
		public var processes: Array = [];

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function XPDLPackage() {
			super();

			_packageHeader = new PackageHeader();
			_redefinableHeader = new RedefinableHeader();
			_pool = new Pool(this);
			_process = new WorkflowProcess(this);
			_script = new Script();
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * version - redfinableHeader 에 기록되어 있다.
		 * id와 verserion은 최초 다이어그램 생성시 서버쪽에서 기록한다.
		 */
		public function get version(): String {
			return _redefinableHeader.version;
		}
		
		/**
		 * packageHeader
		 */
		public function get packageHeader(): PackageHeader {
			return _packageHeader;
		}
		
		/**
		 * redifinableHeader
		 */
		public function get redefinableHeader(): RedefinableHeader {
			return _redefinableHeader;
		}
		
		/**
		 * pool
		 */
		public function get pool(): Pool {
			return _pool;
		}
		public function set pool(value: Pool): void{
			_pool = value;
		}
		
		/**
		 * process
		 */
		public function get process(): WorkflowProcess {
			return _process;
		}
		public function set process(value: WorkflowProcess): void {
			_process = value;
		}
		
		/**
		 * script
		 */
		public function get script(): Script {
			return _script;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function doRead(src: XML): void {
			id = src.@Id;
			name = src.@Name;
			
			if (src._ns::PackageHeader.length() > 0)
				packageHeader.read(src._ns::PackageHeader[0]);
			
			if (src._ns::RedefinableHeader.length() > 0)
				redefinableHeader.read(src._ns::RedefinableHeader[0]);
			
			if (src._ns::Script.length() > 0)
				script.read(src._ns::Script[0])
			
			pool.read(src._ns::Pools._ns::Pool[0]);
			process.read(src._ns::WorkflowProcesses._ns::WorkflowProcess[0]);
			
			if (src._ns::Artifacts.length() > 0)
				readArtifacts(src._ns::Artifacts[0]);
		}
		
		override protected function doWrite(dst: XML): void {
			dst.@Id = id;
			dst.@Name = name;
			
			dst._ns::PackageHeader = "";
			packageHeader.write(dst._ns::PackageHeader[0]);
			
			dst._ns::RedefinableHeader = "";
			redefinableHeader.write(dst._ns::RedefinableHeader[0]);
			
			dst._ns::Script = "";
			script.write(dst._ns::Script[0]);
			
			dst._ns::Pools._ns::Pool = "";
			pool.write(dst._ns::Pools._ns::Pool[0]);
			
			dst._ns::WorkflowProcesses._ns::WorkflowProcess = "";
			process.write(dst._ns::WorkflowProcesses._ns::WorkflowProcess[0]);
			
			dst._ns::Artifacts = "";
			writeArtifacts(dst._ns::Artifacts[0]);
		}
		

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		private function readArtifacts(src: XML): void {
			for each (var xml: XML in src._ns::Artifact) {
				var art: Artifact = null;
			
				switch (xml.@ArtifactType.toString()) {
					case "DataObject":
						art = new DataObject();
						break;			

					case "Block":
						art = new Block();
						break;			

					case "Annotation":
						art = new Annotation();
						break;			

					case "Group":
						art = new Group();
						break;			
				}
			
				if (art) { 
					art.read(xml);
					artifacts.push(art);
				}
			}
		}
		
		private function writeArtifacts(dst: XML): void {
			for (var i: int = 0; i < artifacts.length; i++) {
				dst._ns::Artifact[i] = "";
				writeArtifact(artifacts[i], dst._ns::Artifact[i]);
			}
		}
		
		private function writeArtifact(art: Artifact, dst: XML): void {
			art.write(dst);
		}
	}
}