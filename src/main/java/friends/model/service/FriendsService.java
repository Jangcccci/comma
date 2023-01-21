package friends.model.service;

import static common.JdbcTemplate.*;

import java.sql.Connection;
import java.util.List;

import friends.model.dao.FriendsDao;
import friends.model.dto.Friends;

public class FriendsService {

	private FriendsDao friendsDao = new FriendsDao();

	public List<Friends> selectAllFriends(String nickname) {
		Connection conn = getConnection();
		List<Friends> friendsList = friendsDao.selectAllFriends(conn, nickname);
		close(conn);
		return friendsList;
	} // selectAllFriends() end
	
} // class
