package com.ljh.white.board.mapper;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.common.extend.CommonMapper;

@Repository("BoardMapper")
public class BoardMapper extends CommonMapper {	
	
	/**
	 * 게시판 리스트 카운트
	 * @param param
	 * @return
	 */
	public int selectBoardCount(WhiteMap param) {
		return selectInt("boardMapper.selectBoardCount", param);
	}
	
	/**
	 * 게시판 리스트 조회
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectBoardList(WhiteMap param) {
		return selectList("boardMapper.selectBoardList", param);
	}
	
	/**
	 * 게시판 상세화면 조회
	 * @param param
	 * @return
	 */
	public WhiteMap selectBoardDtlView(WhiteMap param) {
		return selectOne("boardMapper.selectBoardDtlView", param);
	}
	
	/**
	 * 게시판 상세화면 댓글 개수 조회
	 * @param param
	 * @return
	 */
	public int selectBoardCommentCount(WhiteMap param) {
		return selectInt("boardMapper.selectBoardCommentCount", param);
	}
	
	/**
	 * 게시판 상세화면 댓글 조회
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectBoardCommentList(WhiteMap param) {
		return selectList("boardMapper.selectBoardCommentList", param);
	}
	
	/**
	 * 게시판 상세화면 댓글 삭제(수정)
	 * @param param
	 * @return
	 */
	public int updateDelComment(WhiteMap param) {
		return update("boardMapper.updateDelComment", param);
	}
	
	/**
	 * 게시판 상세화면 댓글 삭제
	 * @param param
	 * @return
	 */
	public int deleteComment(WhiteMap param) {
		return delete("boardMapper.deleteComment", param);
	}
	
	/**
	 * 게시판 상세화면 댓글 저장
	 * @param param
	 * @return
	 */
	public int insertBoardComment(WhiteMap param) {
		return insert("boardMapper.insertBoardComment", param);
	}
	
	/**
	 * 게시판 새글 저장
	 * @param param
	 * @return
	 */
	public int insertBoard(WhiteMap param) {
		return insert("boardMapper.insertBoard", param);
	}
	
	/**
	 * 게시판 글수정
	 * @param param
	 * @return
	 */
	public int updateBoard(WhiteMap param) {
		return update("boardMapper.updateBoard", param);
	}
	
	/**
	 * 게시판 글삭제
	 * @param param
	 * @return
	 */
	public int deleteBoard(WhiteMap param) {
		return delete("boardMapper.deleteBoard", param);
	}
}
