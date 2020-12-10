<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ Page CodeBehind="Access_User_Login.aspx.vb" Language="vb" AutoEventWireup="false" Inherits="Dynamicweb.Admin.Access_User_Login" codePage="65001"%>

<!DOCTYPE html>
<html>
    <head>
        <meta content=""text/html; charset=utf-8"" http-equiv=""Content-Type"" />
        <title>Permission denied</title>
        <style type=""text/css"">
            html, body {
                font-family: Helvetica, Arial;
                text-align: center;
                vertical-align: middle;
                width: 100%;
                height: 100%;
                margin:0;
                padding:0;
            }
            
            h1 {
                margin:0;
                padding-top: 20%;
                font-size: 72px;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <h1>You do not have permission to enter this site</h1>
        <p>The website you are trying to enter has probably been locked by the administrator. </p>
        <br />
        <a href="/Admin/Access/Default.aspx">Go to the login page</a>
    </body>
</html>
