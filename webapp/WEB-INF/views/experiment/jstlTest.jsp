<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC>
<html>
<head>
	<meta charset=UTF-8>
	<title>jstlTest</title>
</head>
<body>

<h4>fn:replace TEST</h4>


<pre>
*.java
//fn:replace TEST
request.setAttribute("data1","/data1/page/test.txt" );	
request.setAttribute("data2","/page/page/page/number/test.txt" );
request.setAttribute("data3","/typeA/upload/AAA/BBB/100/image.jpg" );	

List<Map<String, String>> list = new ArrayList<Map<String, String>>();
for(int i=0; i<5; i++) {
	Map<String, String> map = new HashMap<String, String>();
	map.put("nm", "image"+(i+1));
	map.put("ph", "/typeA/upload/AAA/BBB/100/image("+(i+1)+").jpg");
	
	list.add(map);
}
request.setAttribute("list",list);
</pre>


original data1 : ${data1 }<br>
fn:replace data1->data2 : ${fn:replace(data1, 'data1', 'data2')}<br>
fn:replace data1->aaaa :  ${fn:replace(data1, 'data1', 'aaaa')}<br>
fn:replace page->home :  ${fn:replace(data1, 'page', 'home')}<br>

<br><br>
original data2 : ${data2 }<br>
fn:replace page->home :  ${fn:replace(data2, 'page', 'home')}<br>

<br><br>
original data3 : ${data3 }<br>
fn:replace  :  ${fn:replace(data3, '/typeA/upload', '/typeZ/upload')}<br>

<br>
list TEST<br>
<c:forEach items="${list}" var="item">
	nm:${item.nm }<br>
	origin_ph:${item.ph }<br>
	ph:${fn:replace(item.ph, '/typeA/upload', '/typeZ/upload')}<br>
</c:forEach>





</body>
</html>