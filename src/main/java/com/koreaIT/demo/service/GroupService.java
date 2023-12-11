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
		
		return groupDao.getGroups(projectId);
	}
	
}
