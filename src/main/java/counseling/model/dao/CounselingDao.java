package counseling.model.dao;

import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import common.Category;
import common.OX;
import counseling.model.dto.Counseling;
import counseling.model.exception.CounselingException;
import member.model.dao.MemberDao;

public class CounselingDao {
	
	Properties prop = new Properties();
	
	public CounselingDao() {
		String path = MemberDao.class.getResource("/sql/counseling/counseling-query.properties").getPath();
		try {
			prop.load(new FileReader(path));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public int insertCounseling(Connection conn, Counseling counseling) {
		int result = 0;
		String sql = prop.getProperty("insertCounseling");
		try(PreparedStatement pstmt = conn.prepareStatement(sql)){
			//insert into counseling values(seq_cs_no.nextval, ?, ?, ?, default, default, ?, default, ?, ?, ?)
			pstmt.setString(1, counseling.getWriter());
			pstmt.setString(2, counseling.getTitle());
			pstmt.setString(3, counseling.getContent());
			pstmt.setString(4, counseling.getCategory().toString());
			pstmt.setString(5, counseling.getLimitGender());
			pstmt.setInt(6, counseling.getLimitAge());
			pstmt.setString(7, counseling.getAnonymous().toString());
			
			result = pstmt.executeUpdate();
			
		} catch (SQLException e) {
			throw new CounselingException("고민게시글 등록오류!", e);
		}
		return result;
	}

	public List<Counseling> selectAllCounseling(Connection conn) {
		List<Counseling> counselingList = new ArrayList<>();
		String sql = prop.getProperty("selectAllCounseling");
		try(PreparedStatement pstmt = conn.prepareStatement(sql)){
			try(ResultSet rset = pstmt.executeQuery()){
				while(rset.next()) {
					Counseling counseling = new Counseling();
					counseling.setNo(rset.getInt("no"));
					counseling.setWriter(rset.getString("writer"));
					counseling.setTitle(rset.getString("title"));
					counseling.setContent(rset.getString("content"));
					counseling.setViews(rset.getInt("views"));
					counseling.setLike(rset.getInt("cs_like"));
					counseling.setCategory(Category.valueOf(rset.getString("category")));
					counseling.setRegDate(rset.getDate("reg_date"));
					counseling.setLimitGender(rset.getString("limit_gender"));
					counseling.setLimitAge(rset.getInt("limit_age"));
					counseling.setAnonymous(OX.valueOf(rset.getString("anonymous")));
					
					counselingList.add(counseling);
				}
			}
		} catch (SQLException e) {
			throw new CounselingException("게시글 불러오기 오류!", e);
		}
		return counselingList;
	}
}
