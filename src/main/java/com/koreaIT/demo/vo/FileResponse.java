package com.koreaIT.demo.vo;

import lombok.Getter;

import java.time.LocalDateTime;

@Getter
public class FileResponse {

    private Long id;                      // 파일 번호 (PK)
    private int article_id;                  // 게시글 번호 (FK)
    private String original_name;          // 원본 파일명
    private String save_name;              // 저장 파일명
    private long size;                    // 파일 크기
    private int delete_yn;             // 삭제 여부
    private LocalDateTime created_date;    // 생성일시
    private LocalDateTime deleted_date;    // 삭제일시

}
