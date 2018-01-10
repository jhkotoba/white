<!doctype html>
<html lang="ko">
	<head>
		<meta charset="UTF-8">
		<title>myfirst css3 animation</title>
		<style>
			@-webkit-keyframes myfirstkeyframe {
				from {margin-top: 0;}
				to {margin-top: 100px;}
			}
			@-moz-keyframes myfirstkeyframe {
				from {margin-top: 0;}
				to {margin-top: 100px;}
			}
			@-o-keyframes myfirstkeyframe {
				from {margin-top: 0;}
				to {margin-top: 100px;}
			}
			@keyframes myfirstkeyframe {
				from {margin-top: 0;}
				to {margin-top: 100px;}	
			}
			h1 { 
				-webkit-animation: myfirstkeyframe 2s infinite alternate; 
				-moz-animation: myfirstkeyframe 2s infinite alternate; 
				-o-animation: myfirstkeyframe 2s infinite alternate; 
				animation: myfirstkeyframe 2s infinite alternate; 
			}
		</style>
	</head>
	<body>
		<h1>Hello CSS3 Animation!!!</h1>
	</body>
</html>
