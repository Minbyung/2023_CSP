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
	
	public void makeProject(String name, String description, int teamId, int memberId) {
		projectDao.makeProject(name, description, teamId);
		
		int projectId = getLastInsertId();
		projectDao.addMemberToProject(memberId, projectId);
		
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

	public List<Project> getProjectsByTeamIdAndMemberId(int teamId, int memberId) {
		
		return projectDao.getProjectsByTeamIdAndMemberId(teamId, memberId);
	}

	public void addMemberToProject(int memberId, int projectId) {
		projectDao.addMemberToProject(memberId, projectId);
		
		
	}

	public boolean isMemberAlreadyInProject(int memberId, int projectId) {
		
		return projectDao.isMemberAlreadyInProject(memberId, projectId);
	}

}
