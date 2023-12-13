package com.koreaIT.demo.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.koreaIT.demo.dao.GroupDao;
import com.koreaIT.demo.vo.Group;

@Service
public class GroupService {
	
	private GroupDao groupDao; 
	
	public GroupService(GroupDao groupDao) {
		this.groupDao = groupDao;
	}

	public List<Group> getGroups(int projectId) {
		// 그룹이 없을시 "그룹 미지정"그룹 생성
		List<Group> groups = groupDao.getGroups(projectId);
		
		 if (groups.isEmpty()) {
			 groupDao.doMakeGroup(projectId, "그룹 미지정");
		 }
		
		
		return groups;
	}

	public void doMakeGroup(int projectId, String group_name) {
		groupDao.doMakeGroup(projectId, group_name);
		
	}
	
}
