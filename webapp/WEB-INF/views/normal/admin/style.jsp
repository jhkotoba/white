<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<h4>input</h4>

<h6>input-gray sm</h6>
<input class="input-gray size-sm" type="text" placeholder="input">

<h6>input-gray</h6>
<input class="input-gray" type="text" placeholder="input">

<h6>input-gray lg</h6>
<input class="input-gray lg" type="text" placeholder="input">

<h4>button</h4>

<h6>btn-gray trs sm</h6>
<button class="btn-gray trs size-sm">button</button>

<h6>btn-gray trs</h6>
<button class="btn-gray trs">button</button>

<h6>btn-gray trs lg</h6>
<button class="btn-gray trs lg">button</button>

<h4>selectbox</h4>

<h6>select-gray sm</h6>
<select class="select-gray size-sm">
	<option>book</option>
	<option>phone</option>
</select>

<h6>select-gray</h6>
<select class="select-gray">
	<option>book</option>
	<option>phone</option>
</select>

<h6>select-gray lg</h6>
<select class="select-gray lg">
	<option>book</option>
	<option>phone</option>
</select>
