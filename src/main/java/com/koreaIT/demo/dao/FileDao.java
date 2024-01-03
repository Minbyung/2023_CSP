package com.koreaIT.demo.dao;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.koreaIT.demo.vo.Article;
import com.koreaIT.demo.vo.ArticleAndTagInfo;
import com.koreaIT.demo.vo.FileRequest;
import com.koreaIT.demo.vo.FileResponse;
import com.koreaIT.demo.vo.Group;
import com.koreaIT.demo.vo.TeamInvite;

@Mapper
public interface FileDao {

	@Insert({
        "<script>",
        "INSERT INTO tb_file (",
        "    article_id, original_name, save_name, size, delete_yn, created_date, deleted_date",
        ") VALUES",
        "<foreach item='file' collection='list' separator=','>",
        "    (",
        "        #{file.articleId},",
        "        #{file.originalName},",
        "        #{file.saveName},",
        "        #{file.size},",
        "        0,",
        "        NOW(),",
        "        NULL",
        "    )",
        "</foreach>",
        "</script>"
    })
    @Options(useGeneratedKeys = true, keyProperty = "id")
    void saveAll(List<FileRequest> files);


	
	/**
	 * 파일 리스트 조회
	 * @param postId - 게시글 번호 (FK)
	 * @return 파일 리스트
	 */
	
	
	
	@Select("""
			SELECT * 
				FROM tb_file
				WHERE delete_yn = 0
				AND article_id = #{articleId}
				ORDER BY id
			""")
	List<FileResponse> findAllFileByArticleId(int articleId);
	
	/**
	 * 파일 리스트 조회
	 * @param ids - PK 리스트
	 * @return 파일 리스트
	 */
	List<FileResponse> findAllByIds(List<Long> ids);
	
	/**
	 * 파일 삭제
	 * @param ids - PK 리스트
	 */
	void deleteAllByIds(List<Long> ids);


	
	 /**
     * 파일 상세정보 조회
     * @param id - PK
     * @return 파일 상세정보
     */
	@Select("""
			SELECT * 
				FROM tb_file
				WHERE delete_yn = 0
				AND id = #{id}
			""")
    FileResponse findFileById(Long id);

}



