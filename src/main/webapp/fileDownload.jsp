<%@page import="java.net.URLEncoder"%>
<%@page import="com.tjoeun.fileupload.FileDAO"%>
<%@page import="com.tjoeun.fileupload.FileVO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>파일 다운로드 페이지</title>
</head>
<body>

<h1>업로드된 파일 목록</h1>

<%
//	파일이 업로드되는 폴더에 저장된 파일 목록을 얻어온다.
//	String[] files = new File("C:/upload/").list();
//	for(int i = 0; i < files.length; i++) {
//		out.println( (i+1)+ ". " + files[i]+ "<br/>");
//	}

//	테이블에 저장된 업로드된 파일 정보를 얻어온다.
	ArrayList<FileVO> files = new FileDAO().getUploadList();
	for(int i = 0; i < files.size(); i++) {
//		out.println( (i+1)+ ". " + files.get(i) + "<br/>");

%>

<%=i+1%>.
<a href="<%=request.getContextPath()%>/DownloadAction?file=<%=URLEncoder.encode(files.get(i).getFilename(), "UTF-8")%>&realfile=<%=URLEncoder.encode(files.get(i).getFileRealname(), "UTF-8")%>"> <!-- get --> 
	<%=files.get(i).getFilename()%>
</a>
(다운로드 횟수 : <%=files.get(i).getDownloadCount()%>)
<br/> 

<%
	}
	
%>


<a href="./index.jsp">돌아가기</a>

</body>
</html>