<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<!DOCTYPE html PUBLIC>
<html>
<head>
<script type="text/javascript" src="${contextPath}/resources/jquery/js/jquery-3.2.1.min.js"></script>
<style type="text/css">

@import url(https://fonts.googleapis.com/css?family=Montserrat:300&subset=latin-ext);

body {
-moz-osx-font-smoothing:grayscale;
-ms-flex-direction:column;
-webkit-box-direction:normal;
-webkit-box-orient:vertical;
-webkit-font-smoothing:antialiased;
background:#f5f5f5;
color:#777;
display:flex;
flex-direction:column;
font-family:Montserrat, sans-serif;
font-size: 1em;
/* font-weight:300; */
font-weight:600;
margin:0;
min-height:100vh;
padding:5%;
}

h1 {
	font-weight: 200;
	font-size: 2.2rem;
	color: #222;
	text-align: center;
}

nav {
	margin: 0 auto;
	max-width: 800px;
	/* background: #008FEA; */
	background: #4C4C4C;
	
	box-shadow:0 3px 15px rgba(0,0,0,.15);
}

nav::after {
	display: block;
	content: '';
	clear: both;
}

nav ul {
	padding: 0;
	margin: 0;
	list-style: none;
}

nav ul li {
	float: left;
	position: relative;
}

nav ul li a {
	display: block;
	/* color: rgba(255, 255, 255, .9); */
	color: rgba(189, 189, 189, .9);	
	text-decoration: none;
	padding: 1rem 2rem;
	border-top: 2px solid transparent;
	border-bottom: 2px solid transparent;
	transition: all .3s ease-in-out;
}

nav ul li a:hover,
nav ul li a:focus {
	/* background: rgba(0, 0, 0, .15); */
	color: white;
}

nav ul li a:focus {
	color: white;
}

nav ul li a:not(:only-child)::after {
	padding-left: 4px;
	/* content: ' ▾'; */
}

nav ul li ul li {
	min-width: 190px;
}

nav ul li ul li a {
	background: transparent;
	color: #555;
	border-bottom: 1px solid #DDE0E7;
}

nav ul li ul li a:hover,
nav ul li ul li a:focus {
	background: #eee;
	color: #111;
}

.dropdown {
	display: none;
	position: absolute;
	background: #fff;
	box-shadow: 0 4px 10px rgba(10, 20, 30, .2);
}
</style>

<script type="text/javascript">
$(document).ready(function(){
	$(".drop").mouseover(function() {
		$(".dropdown").show(300);
	});
	$(".drop").mouseleave(function() {
		$(".dropdown").hide(300);     
	});
});


</script>

<meta charset=UTF-8>
<title>whiteHome</title>
<body>

<nav class="nav">
	<ul>
		<li><a href="#">Start</a></li>
		<li><a href="#">한글</a></li>
	    <li><a href="#">O nas</a></li>
		<li class="nav-drop"><a href="#">Oferta</a>
			<ul class="nav-dropdown">
				<li><a href="#">Oferta 01</a></li>
				<li><a href="#">Oferta 02</a></li>
				<li><a href="#">Oferta 03</a></li>
			</ul>
		</li>
		<li><a href="#">Aktualności</a></li>
		<li><a href="#">Kontakt</a></li>
	</ul>
</nav>

</body>
</head>
</html>