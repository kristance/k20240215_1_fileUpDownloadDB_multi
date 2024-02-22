package com.tjoeun.fileupload;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.PageContext;
import javax.xml.stream.Location;

@WebServlet("/DownloadAction")
public class DownloadAction extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public DownloadAction() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		actionDo(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		actionDo(request, response);
	}
	
	protected void actionDo(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("DownloadAction 서블릿의 actionDo() 메소드 실행");
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
//		fileDownload.jsp에서 넘어오는 업로드 한 파일 이름과 실제로 디스크에 저장된 파일 이름을 받는다.
		String filename = request.getParameter("file"); // 업로드한 파일 이름
		String fileRealname = request.getParameter("realfile"); // 실제 디스크에 저장된 파일 이름
//		System.out.println("filename : " + filename ); 
//		System.out.println("fileRealname : " + fileRealname ); 
//		다운로드 할 파일이 실제 저장된 경로(C:/upload)와 다운로드 할 파일 이름(fileRealname)을 연결한다.
		String downloadFile = "C:/upload/" + fileRealname;
		
//		다운로드 할 파일 객체를 만든다.
		File file = new File(downloadFile);
	
//		MIME 타입을 얻어오지 못한 경우 파일을 전송함을 알려준다.
		String mimeType = getServletContext().getMimeType(filename.toString());
		if(mimeType == null) {
			response.setContentType("application/octet-stream");
		}
		
//		접속한 브라우저에 따라 다운로드 할 파일의 헤더 정보를 다르게 설정한다.
		String downloadName = "";
		if(request.getHeader("user-agent").indexOf("MSIE") == -1) {
			downloadName = new String(filename.getBytes("UTF-8"), "8859_1");
		} else {
			downloadName = new String(filename.getBytes("EUC-KR"), "8859_1");
		}
		
//		파일 이름을 헤더에 저장한다.
		response.setHeader("Content-Disposition", "attachment;filename=\"" + downloadName + "\";");
		
//		파일을 전송할 준비를 한다.
		FileInputStream fileInputStream = new FileInputStream(file);
		ServletOutputStream servletOutputStream = response.getOutputStream();
		
		byte[] b = new byte[1024];
		int data = 0;
		
//		브라우저로 파일을 전송한다.
		while ( (data = fileInputStream.read(b, 0, b.length)) != -1 ) { 
			servletOutputStream.write(b, 0, data);
		}
//		다운로드에 사용한 모든 객체를 닫는다.
		servletOutputStream.flush();
		servletOutputStream.close();
		fileInputStream.close();
	
//		다운로드가 완료되면 다운로드 횟수를 증가시킨다.
		new FileDAO().hit(fileRealname);
		
	}
	

}
