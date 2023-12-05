package com.koreaIT.demo.service;

import org.springframework.stereotype.Service;

import com.koreaIT.demo.dao.ProjectDao;
import com.koreaIT.demo.vo.Project;

@Service
public class ProjectService {
	
	private ProjectDao projectDao;
	
	public ProjectService(ProjectDao projectDao) {
		this.projectDao = projectDao;
	}
	
	public void makeProject(String name, String description) {
		projectDao.makeProject(name, description);
	}

	public Project getProjectByProjectId(int projectId) {
		
		return projectDao.getProjectByProjectId(projectId);
	}

	public int getLastInsertId() {
		return projectDao.getLastInsertId();
	}

}
