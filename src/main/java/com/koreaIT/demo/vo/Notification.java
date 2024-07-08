package com.koreaIT.demo.vo;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Notification {
	private int id;
	private int writerId;
	private String writerName;
	private String title;
	private String content;
	private String regDate;
	private String projectName;
	private int articleId;
	private List<String> managers; // managers 필드 추가
	private int taggedMemberId;
}
