package com.koreaIT.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Member {
	private int id;
	private String regDate;
	private String updateDate;
	private String loginId;
	private String loginPw;
	private int authLevel;
	private String name;
	private String nickname;
	private String teamName;
	private String cellphoneNum;
	private String email;
	private int delStatus;
	private String delDate;
	private String profilePhotoPath;
	
	private int teamId;
	private int projectId;
	private String project_name;
}
