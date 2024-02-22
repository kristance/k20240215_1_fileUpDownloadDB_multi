<%@page import="com.tjoeun.fileupload.FileDAO"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="javax.swing.plaf.multi.MultiToolTipUI"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
 
 <%
 	request.setCharacterEncoding("UTF-8");
 	MultipartRequest multipartRequest = new MultipartRequest(
 			request,
 			// application.getRealPath("/upload"),
 			// 보안성 향상을 위해 upload 폴더를 프로젝트 외부에 만든다.
 			"C:/upload/",
 			5 * 1024 * 1024 * 1024,
 			"UTF-8",
 			new DefaultFileRenamePolicy()
 			);
 
//	index.jsp에서 넘어오는 업로드할 파일 이름 여러개를 받는다.
//	getFileNames() : 업로드 하는 여러개의 파일 이름을 얻어온다.
 	Enumeration filenames = multipartRequest.getFileNames();

//	업로드할 파일이 있는 동안 반복한다.
//	hasMoreElements() : Enumeration 인터페이스 객체에 저장된 다음 데이터가 있으면 true, 없으면 false를 리턴시킨다.
	while ( filenames.hasMoreElements() ) {
		//	netxtElement() : Enumeration 인터페이스 객체에 저장된 다음 데이터를 얻어온다.
		String parameter = (String) filenames.nextElement();
		//	업로드 페이지의 type 속성이 file로 설정한 객체를 역순으로 얻어온다.
		//	out.println(parameter + "<br/>");
		
		String filename = multipartRequest.getOriginalFileName(parameter);
		String fileRealname = multipartRequest.getFilesystemName(parameter);
	
		//	업로드할 파일이 넘어오지 않았으면 다음 파일을 처리한다. -> 남아있는 while 반복을 실행할 필요없다.
		if (filename == null) {
			continue;
		}
//		out.println("원본 파일 이름 : " + filename + "<br/>");
//		out.println("업로드된 파일 이름 : " + fileRealname + "<br/>");
		
//		업로드 하는 파일의 크기를 얻어온다.
		//	File realFile = multipartRequest.getFile(parameter); // 업로드 하는 파일 크기
		File realFile = new File("C:/upload/" + fileRealname); // 업로드된 파일 크기
		long fileLength = realFile.length();
//		out.println("업로드 파일 크기 : " + fileLength + "<br/>");


//		업로드 제한
		if (fileLength > 5 * 1024 * 1024) { 
			out.println("<script>");
			out.println("alert('" + filename + " 은(는) 업로드 용량을 초과하였습니다.')");
			out.println("</script>");
			realFile.delete();
			
		} else if(!fileRealname.endsWith(".zip") && !fileRealname.endsWith(".png") ) {
			out.println("<script>");
			out.println("alert('" + filename +  "(은)는 업로드할 수 있는 파일의 형식이 아닙니다.')");
			out.println("</script>");
			realFile.delete();
		} else { 
			out.println("<script>");
			out.println("alert('" + filename + "업로드 성공')");
			out.println("</script>");
			
			
			// filename과 fileRealname을 테이블에 저장하는 메소드를 호출한다.
			new FileDAO().upload(filename, fileRealname);
			
		}
		
	}
		out.println("<script>");
		out.println("location.href='index.jsp'");
		out.println("</script>");
	

 %>
 
</body>
</html>