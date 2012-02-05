<%@taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>XDP 2 HTML converter</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="xdp, html, xdp2html">
<meta http-equiv="description" content="XDP 2 HTML converter">
<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
</head>

<body>
	<html:form action="/uploadFormular" method="post" enctype="multipart/form-data">
		<br />
		<bean:message key="label.common.file.label" />: 
    <html:file property="file" size="50" />
		<br />
		<br />
		<html:submit>
			<bean:message key="label.common.button.submit" />
		</html:submit>

	</html:form>
</body>
</html>
