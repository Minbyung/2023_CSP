package com.koreaIT.demo.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.koreaIT.demo.dao.ProjectDao;
import com.koreaIT.demo.vo.Member;
import com.koreaIT.demo.vo.Project;

@Service
public class ProjectService {
	
	private ProjectDao projectDao;
	
	public ProjectService(ProjectDao projectDao) {
		this.projectDao = projectDao;
	}
	
	public void makeProject(String name, String description, int teamId) {
		projectDao.makeProject(name, description, teamId);
	}

	public Project getProjectByProjectId(int projectId) {
		
		return projectDao.getProjectByProjectId(projectId);
	}

	public int getLastInsertId() {
		return projectDao.getLastInsertId();
	}

	public List<String> getMembersByName(String name) {
		
		return projectDao.getMembersByName(name);
	}

	public List<Project> getProjectsByTeamId(int teamId) {
		
		return projectDao.getProjectsByTeamId(teamId);
	}

}
