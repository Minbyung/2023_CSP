package com.koreaIT.demo.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.koreaIT.demo.service.FileService;
import com.koreaIT.demo.util.FileUtils;
import com.koreaIT.demo.vo.FileResponse;

@Controller
public class UsrFileController {
	private FileService fileService;
	private FileUtils fileUtils;


	UsrFileController(FileService fileService, FileUtils fileUtils) {
		this.fileService = fileService;
		this.fileUtils = fileUtils;
	}
	
	
	// 첨부파일 다운로드
    @GetMapping("/usr/file/downloadFile")
    public ResponseEntity<Resource> downloadFile(@PathVariable final int articleId, @PathVariable final Long fileId) {
        FileResponse file = fileService.findFileById(fileId);
        Resource resource = fileUtils.readFileAsResource(file);
        try {
            String filename = URLEncoder.encode(file.getOriginal_name(), "UTF-8");
            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_OCTET_STREAM)
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; fileName=\"" + filename + "\";")
                    .header(HttpHeaders.CONTENT_LENGTH, file.getSize() + "")
                    .body(resource);

        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException("filename encoding failed : " + file.getOriginal_name());
        }
    }

	
	
	
}
	
	

