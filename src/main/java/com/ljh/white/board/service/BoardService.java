package com.ljh.white.board.service;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ljh.white.board.mapper.BoardMapper;
import com.ljh.white.common.collection.WhiteMap;

@Service("BoardService")
public class BoardService {

	@Resource(name = "BoardMapper")
	private BoardMapper boardMapper;
	
	/**
	 * 게시판 리스트 카운트
	 * @param param
	 * @return
	 */
	public int selectBoardCount(WhiteMap param) {
		return boardMapper.selectBoardCount(param);	
	}
	
	/**
	 * 게시판 리스트 조회
	 * @param Parma
	 * @return
	 */
	public List<WhiteMap> selectBoardList(WhiteMap param){
		param.put("pagePre", (param.getInt("pageIndex")-1)*param.getInt("pageSize"));
		return boardMapper.selectBoardList(param);
	}
	
	/**
	 * 게시판 상세화면 조회
	 * @param param
	 * @return
	 */
	public WhiteMap selectBoardDtlView(WhiteMap param) {		
		return boardMapper.selectBoardDtlView(param);		
	}	
	
	/**
	 * 게시판 상세화면 댓글 조회
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectBoardCommentList(WhiteMap param) {		
		return boardMapper.selectBoardCommentList(param);	
	}
	
	/**
	 * 게시판 상세화면 댓글 저장
	 * @param param
	 * @return
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public int insertBoardComment(WhiteMap param) {		
		return boardMapper.insertBoardComment(param);	
	}
	
	/**
	 * 게시판 상세화면 댓글 삭제(수정)
	 * @param param
	 * @return
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public int updateDelComment(WhiteMap param) {
		return boardMapper.updateDelComment(param);	
	}
	
	/**
	 * 게시판 새글 저장
	 * @param param
	 * @return
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public int insertBoard(WhiteMap param) {
		return boardMapper.insertBoard(param);
	}
	
	/**
	 * 게시판 글수정
	 * @param param
	 * @return
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public int updateBoard(WhiteMap param) {		
		return boardMapper.updateBoard(param);
	}
	
	/**
	 * 게시판 글삭제
	 * @param param
	 * @return
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public int deleteBoard(WhiteMap param) {
		
		int cnt = boardMapper.selectBoardCommentCount(param);
		System.out.println(cnt);
		return 0;
		//return boardMapper.deleteBoard(param);
	}
	
}
