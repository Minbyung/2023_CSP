package com.koreaIT.demo.vo;

import java.util.ArrayList;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Article {
	private int id;
	private String regDate;
	private String updateDate;
	private int memberId;
	private int projectId;
	private String title;
	private String content;
	private String status;
	private String startDate;
	private String endDate;
	
	
	
	private String writerName;
	private String taggedNames;
	private String groupName;
	private int groupId;
	private String projectName;
	private List<MultipartFile> files = new ArrayList<>();    // 첨부파일 List
	private List<FileResponse> infoFiles;
	
	
	
	
	
	public String getContentBr() {
        if (content == null) {
            return null;
        }
        return content.replaceAll("(\r\n|\n)", "<br>");
    }
}
