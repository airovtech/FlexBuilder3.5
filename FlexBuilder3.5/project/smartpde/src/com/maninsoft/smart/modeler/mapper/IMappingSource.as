////////////////////////////////////////////////////////////////////////////////
//  IMapperable.as
//  2008.01.08, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.mapper
{
	import flash.geom.Rectangle;
	
	/**
	 * Data mapping이 가능한 노드 컨트롤러가 구현해야 할 스펙
	 */
	public interface IMappingSource	{
		
		/**
		 * 소스 컨트롤러의 bounds
		 */
		function get mappingBounds(): Rectangle;
		/**
		 * panel에 표시될 타이틀
		 */
		function get mappingTitle(): String;
		/**
		 * IMappingItem 컬렉션
		 */
		function get mappingItems(): Array;
		
		/**
		 * source로 부터 이 소스로 연결된 링크(IMappingLink)들의 컬렉션
		 */
		function getMappingLinks(source: IMappingSource): Array;
		/**
		 * 이 매핑소스를 타깃으로 하는 매핑링크를 추가
		 */
		function addMappingLink(source: IMappingItem, target: IMappingItem): IMappingLink;
		/**
		 * 이 매핑소스가 소유한 링크들 중에서 하나의 링크 제거
		 */
		function removeMappingLink(link: IMappingLink): void;
	}
}