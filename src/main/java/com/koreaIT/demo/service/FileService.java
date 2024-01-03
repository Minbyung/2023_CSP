package com.koreaIT.demo.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import com.koreaIT.demo.dao.FileDao;
import com.koreaIT.demo.vo.FileRequest;
import com.koreaIT.demo.vo.FileResponse;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FileService {

    private final FileDao fileDao;

    @Transactional
    public void saveFiles(final int id, final int projectId, final List<FileRequest> files) {
        if (CollectionUtils.isEmpty(files)) {
            return;
        }
        for (FileRequest file : files) {
            file.setArticleId(id);
            file.setProjectId(projectId);
        }
        fileDao.saveAll(files);
    }

    
    
    /**
     * 파일 리스트 조회
     * @param postId - 게시글 번호 (FK)
     * @return 파일 리스트
     */
    public List<FileResponse> findAllFileByArticleId(int articleId) {
        return fileDao.findAllFileByArticleId(articleId);
    }
    
    /**
     * 파일 상세정보 조회
     * @param id - PK
     * @return 파일 상세정보
     */
    public FileResponse findFileById(final Long id) {
        return fileDao.findFileById(id);
    }

}

