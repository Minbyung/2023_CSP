package com.koreaIT.demo.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.koreaIT.demo.dao.GroupDao;
import com.koreaIT.demo.dao.ProjectDao;
import com.koreaIT.demo.vo.Member;
import com.koreaIT.demo.vo.Project;

@Service
public class ProjectService {
	
	private ProjectDao projectDao;
	private GroupDao groupDao;
	
	public ProjectService(ProjectDao projectDao, GroupDao groupDao) {
		this.projectDao = projectDao;
		this.groupDao = groupDao;
	}
	
	public void makeProject(String name, String description, int teamId, int memberId) {
		projectDao.makeProject(name, description, teamId);
		
		int projectId = getLastInsertId();
		projectDao.addMemberToProject(memberId, projectId);
		groupDao.doMakeGroup(projectId, "그룹 미지정");
		
	}

	public Project getProjectByProjectId(int projectId) {
		
		return projectDao.getProjectByProjectId(projectId);
	}

	public int getLastInsertId() {
		return projectDao.getLastInsertId();
	}

	public List<String> getMembersByName(String name, int projectId) {
		
		return projectDao.getMembersByName(name, projectId);
	}

	public List<Project> getProjectsByTeamIdAndMemberId(int teamId, int memberId) {
		
		return projectDao.getProjectsByTeamIdAndMemberId(teamId, memberId);
	}

	public List<Project> getFavoriteProjects(int teamId, int memberId) {
		return projectDao.getFavoriteProjects(teamId, memberId);
	}
	
	public List<Project> getNonFavoriteProjects(int teamId, int memberId) {
		return projectDao.getNonFavoriteProjects(teamId, memberId);
	}
	
	public void addMemberToProject(int memberId, int projectId) {
		projectDao.addMemberToProject(memberId, projectId);
		
		
	}

	public boolean isMemberAlreadyInProject(int memberId, int projectId) {
		
		return projectDao.isMemberAlreadyInProject(memberId, projectId);
	}

	
	public List<Integer> getProjectMemberIdsByProjectId(int projectId) {
		return projectDao.getProjectMemberIdsByProjectId(projectId);
	}
	
	

}
