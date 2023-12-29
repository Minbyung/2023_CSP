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
import com.koreaIT.demo.vo.Group;
import com.koreaIT.demo.vo.TeamInvite;

@Mapper
public interface FileDao {

	@Insert({
        "<script>",
        "INSERT INTO tb_file (",
        "    id, article_id, original_name, save_name, size, delete_yn, created_date, deleted_date",
        ") VALUES",
        "<foreach item='file' collection='list' separator=','>",
        "    (",
        "        #{file.id},",
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
}

	

