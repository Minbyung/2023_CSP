package com.koreaIT.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreaIT.demo.service.GroupService;
import com.koreaIT.demo.util.Util;
import com.koreaIT.demo.vo.Rq;

@Controller
public class UsrGroupController {
	
	private GroupService groupService;
	private Rq rq;
	
	UsrGroupController(GroupService groupService, Rq rq) {
		this.groupService = groupService;
		this.rq = rq;
	}
	
	@RequestMapping("/usr/group/doMake")
	@ResponseBody
	public String doMake(int projectId, String group_name) {
		
		groupService.doMakeGroup(projectId, group_name);

		int id = projectId;

		return Util.jsReplace(Util.f("%d번 프로젝트 그룹을 생성했습니다", id), Util.f("detail?id=%d", id));
	}
	
}