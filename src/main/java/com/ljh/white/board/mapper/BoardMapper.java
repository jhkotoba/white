package com.ljh.white.board.mapper;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ljh.white.common.collection.WhiteMap;

@Repository("BoardMapper")
public class BoardMapper {

	@Autowired
	private SqlSession sqlSession;
	
	/**
	 * 게시판 리스트 카운트
	 * @param param
	 * @return
	 */
	public int selectBoardCount(WhiteMap param) {
		return sqlSession.selectOne("boardMapper.selectBoardCount", param);
	}
	
	/**
	 * 게시판 리스트 조회
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectBoardList(WhiteMap param) {
		return sqlSession.selectList("boardMapper.selectBoardList", param);
	}
	
	/**
	 * 게시판 상세화면 조회
	 * @param param
	 * @return
	 */
	public WhiteMap selectBoardDtlView(WhiteMap param) {
		return sqlSession.selectOne("boardMapper.selectBoardDtlView", param);
	}
	
	/**
	 * 게시판 상세화면 댓글 조회
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectBoardCommentList(WhiteMap param) {
		return sqlSession.selectList("boardMapper.selectBoardCommentList", param);
	}
	
	/**
	 * 게시판 새글 저장
	 * @param param
	 * @return
	 */
	public int insertBoard(WhiteMap param) {
		return sqlSession.insert("boardMapper.insertBoard", param);
	}
	
	/**
	 * 게시판 글수정
	 * @param param
	 * @return
	 */
	public int updateBoard(WhiteMap param) {
		return sqlSession.update("boardMapper.updateBoard", param);
	}
	
	/**
	 * 게시판 글삭제
	 * @param param
	 * @return
	 */
	public int deleteBoard(WhiteMap param) {
		return sqlSession.delete("boardMapper.deleteBoard", param);
	}
}
