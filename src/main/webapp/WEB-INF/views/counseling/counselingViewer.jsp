<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/header.jsp"%>
<%@ page import="counseling.model.dto.Counseling" %>
<%@ page import="common.Attachment" %>
<%@ page import="counseling.model.dto.CounselingComment" %>
<%@ page import="common.OX" %>
<%
	Counseling counseling = (Counseling)request.getAttribute("counseling");
	List<Attachment> attachList = counseling.getAttachments();
	List<CounselingComment> comments = (List<CounselingComment>) request.getAttribute("comments");
%>
<section id="csViewerSection">
	<div id="csContainer">
		<div id="titleContainer">
			<span id="csCategory"><%= counseling.getCategory() %></span>
			<h1 id="csTitle"><%= counseling.getTitle() %></h1>
			<div id="smallBox">
				<p><%= counseling.getWriter() %></p>
				<p><%= counseling.getRegDate() %></p>
			</div>
		</div>
		<div id="csContent" >
			<% if(attachList == null){ %>
			<% } else{ %>
				<% for(Attachment attach : attachList){ %>
				<div id="imgDiv" name="imgDiv">
					<img src="<%= request.getContextPath() %>/upload/counseling/<%= attach.getRenamedFilename() %>" alt="" id="img" name="img" />
				</div>
				<% } %>
			<% } %>
			<%= counseling.getContent() %>
		</div>
		<div id="likeBox">
			<button id="likeBtn"><i class="fa-regular fa-heart"></i> 공감</button>
		</div>
		<div id="commentBox">
			<div class="comment-editor">
	            <form
	            action="<%=request.getContextPath()%>/counseling/csCommentEnroll" method="post" name="csCommentForm">
	                <input type="hidden" name="csNo" value="<%= counseling.getNo() %>" />
	                <input type="hidden" name="writer" value="<%= loginMember.getNickname() %>" />
	                <input type="hidden" name="commentLevel" value="X" />
	                <input type="hidden" name="commentRef" value="0" />    
	                <textarea id="commentContent"name="commentContent"></textarea>
	                <div id="commentSubmitBox">
	                	<button type="submit" id="commentEnrollBtn">댓글달기</button>
	                </div>
	            </form>
	        </div>
	        <!--table#tbl-comment-->
	        <%
	        	if(!comments.isEmpty()){
	        %>
	        <table id="tbl-comment">
	        <%
	        	for(CounselingComment comment : comments){
	        		if(comment.getCommentLevel() == OX.X){
	        %>
	            <%-- 댓글인 경우 tr.level1 --%>
	            <tr class="level1">
	                <td>
	                    <sub class=comment-writer><%= comment.getWriter() %></sub>
	                    <sub class=comment-date><%= comment.getRegDate() %></sub>
	                    <br />
	                    <%-- 댓글내용 --%>
	                    <%= comment.getContent() %>
	                </td>
	                <td class="btnDiv">
	                    <button class="btn-reply" value="<%= comment.getCommentNo() %>">답글</button>
	                    <% 
	                    	if(comment.getWriter().equals(loginMember.getNickname()) || loginMember.getMemberRole() == MemberRole.A || loginMember.getMemberRole() == MemberRole.M) {
	                    %>
	                    		<button class="btn-delete" data-csComment-no="<%= comment.getCommentNo() %>" data-cs-No="<%= comment.getNo() %>">삭제</button>
	                    <%
	                    	}
	                    %>
	                </td>
	            </tr>
	           <%
	        		} else{
	           %>
	            <%-- 대댓글인 경우 tr.level2 --%>
	            <tr class="level2">
	                <td>
	                    <sub class=comment-writer><%= comment.getWriter() %></sub>
	                    <sub class=comment-date><%= comment.getRegDate() %></sub>
	                <br />
	                    <%-- 대댓글 내용 --%>
	                    <%= comment.getContent() %>
	                </td>
	                <td>
	                <% 
	                if(comment.getWriter().equals(loginMember.getNickname()) || loginMember.getMemberRole() == MemberRole.A || loginMember.getMemberRole() == MemberRole.M) {
	                    %>
	                		<button class="btn-delete" data-csComment-no="<%= comment.getCommentNo() %>" data-cs-No="<%= comment.getNo() %>">삭제</button>
	                <%
	                    }
	                %>
	                </td>
	            </tr>
	            <%
	        			} // if...else end
	        		} // for end
	            %>
	        </table>
	        <% } %>
		</div>
		
	</div>
	<script>
	document.querySelectorAll(".btn-reply").forEach((button) => {
		button.onclick = (e) => {
			console.log(e.target.value);
			const tr = `
			<tr>
				<td colspan="2" style="text-align:left">
					<form id="cocomentEnrollFrm" action="<%=request.getContextPath()%>/counseling/csCommentEnroll" method="post" name="boardCommentFrm">
		                <input type="hidden" name="csNo" value="<%= counseling.getNo() %>" />
		                <input type="hidden" name="writer" value="<%= loginMember.getNickname() %>" />
		                <input type="hidden" name="commentLevel" value="O" />
		                <input type="hidden" name="commentRef" value="\${e.target.value}" />    
		                <textarea id="cocoment" name="commentContent" cols="58" rows="1"></textarea>
		                <button type="submit" id="btn-comment-enroll2">등록</button>
		            </form>
	            </td>
	         </tr>
			`;
			
			const target = e.target.parentElement.parentElement; // tr
			console.log(target);
			target.insertAdjacentHTML("afterend", tr);
			
			button.onclick = null; // 이벤트핸들러 제거
				
		}
	});

	/* 
	이벤트버블링을 통해 부모요소에서 이벤트 핸들링
	*/
	document.body.addEventListener("submit", (e)=>{
		console.log("ahwfohwlekfjklsjfildsik");
		
		if(e.target.name === 'csCommentForm'){
			
			// 유효성검사
			const content = e.target.content;
			if(!/^(.|\n)+$/.test(content.value)){
				e.preventDefault();
				alert('내용을 작성해주세요');
				content.focus();
			}
		}
	}); 
	</script>
</section>
</body>
</html>