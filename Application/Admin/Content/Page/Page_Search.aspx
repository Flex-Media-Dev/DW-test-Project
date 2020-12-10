<%@ Page CodeBehind="Page_Search.aspx.vb" Language="vb" AutoEventWireup="false" Inherits="Dynamicweb.Admin.Page_Search" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<!DOCTYPE html>
<html>
<head id="Head1" runat="server">
    <title>Search</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta name="Cache-control" content="no-cache" />
    <meta http-equiv="Cache-control" content="no-cache" />
    <meta http-equiv="Expires" content="Tue, 20 Aug 1996 14:25:27 GMT" />
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" IncludeScriptaculous="true" runat="server" CombineOutput="false">
        <Items>            
            <dw:GenericResource Url="/Admin/Content/Page/Page_Search.css" />            
            <dw:GenericResource Url="/Admin/Content/Page/Page_Search.js" />
        </Items>
    </dw:ControlResources>
</head>
<body class="screen-container area-blue">
    <div class="card searchBox">
        <div class="card-header">
            <h2><dw:TranslateLabel Text="Search" runat="server" /></h2>
        </div>

        <div class="card-body">

            <!-- / SEARCH -->
            <table id="SearchBox" cellpadding="0" border="0" cellspacing="0" width="248" style="height: 100%; overflow: auto;">
                <tr>
                    <td colspan="3" align="center" valign="top" width="100%">
                        <form id="SearchForm" name="Searchform" runat="server" action="Page_Search.aspx" method="post">
                            <fieldset class="searchactions">
                                <legend class="gbTitle"><dw:TranslateLabel Text="Action" runat="server" /></legend>
                                <table width="100%" cellspacing="2" cellpadding="0" border="0" style="overflow: auto;">
                                    <tr height="20">
                                        <td>Page ID:</td>
                                        <td align="right">
                                            <input id="PageSearchID" type="text" maxlength="255" class="std" name="PageSearchID" runat="server" style="width: 120px" />
                                        </td>
                                    </tr>
                                    <tr height="25">
                                        <td>Paragraph ID:</td>
                                        <td align="right">
                                            <input id="PageSearchParagraphID" type="text" maxlength="255" class="std" name="PageSearchParagraphID"  runat="server" style="width: 120px" />
                                        </td>
                                    </tr>
                                    <tr height="25">
                                        <td>Text string:</td>
                                        <td align="right">
                                            <input id="PageSearchText" type="text" maxlength="255" class="std" name="PageSearchText" runat="server" style="width: 120px" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td width="100%" align="right" colspan="2">
                                            <input type="submit" class="btn btn-default buttonSubmit" onclick="DoSearch(); return false;" value="Search" />
                                        </td>
                                    </tr>
                                </table>
                            </fieldset>

                            <fieldset class="searchsettings">
                                <legend class="gbTitle"><dw:TranslateLabel Text="Settings" runat="server" /></legend>
                                <table width="100%" cellspacing="0" cellpadding="0" border="0" style="height: 100; overflow: auto;">
                                    <tr>
                                        <td width="100%">
                                            <input type="hidden" id="hiddenIsPostback" value="<%= Page.IsPostBack OrElse Not String.IsNullOrEmpty(Request("PageSearchID")) %>" />
                                            <input type="hidden" id="hiddenPageSearchIn_Page" value="<%= Request("PageSearchIn_Page") %>" />
                                            <input type="hidden" id="hiddenPageSearchIn_Paragraph" value="<%= Request("PageSearchIn_Paragraph") %>" />
                                            <input type="hidden" id="hiddenPageSearchIn_WebsiteOnly" value="<%= Request("PageSearchIn_WebsiteOnly") %>" />
                                            <input type="hidden" id="hiddenModuleSearch" runat="server" />
                                            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                                                <tr>
                                                    <td colspan="2"><b><dw:TranslateLabel Text="Search in" runat="server" /></b></td>
                                                </tr>                                                
                                                <tr>
                                                    <td width="25">
                                                        <dw:CheckBox runat="server" name="PageSearchIn" ID="PageSearchIn_Page" Value="page" Checked="true" />
                                                    </td>
                                                    <td>
                                                        <label for="PageSearchIn_Page">Pages</label></td>
                                                </tr>
                                                <tr>
                                                    <td width="25">
                                                        <dw:CheckBox runat="server" name="PageSearchIn" ID="PageSearchIn_Paragraph" Value="paragraph" Checked="true" />
                                                    </td>
                                                    <td>
                                                        <label for="PageSearchIn_Paragraph">Paragraph</label></td>
                                                </tr>
                                                <tr>
                                                    <td width="25">
                                                        <dw:CheckBox runat="server" name="PageSearchIn" ID="PageSearchIn_WebsiteOnly" Value="website" Checked="true" />
                                                    </td>
                                                    <td>
                                                        <label for="PageSearchIn_WebsiteOnly">Search this website only</label></td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2">
                                                        <div class="gbTitle">App</div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2">
                                                        <select name="PageSearch_Modules" id="ModuleSearch" class="std" style="width: 210px" runat="server"></select>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </fieldset>
                        </form>
                    </td>
                </tr>
            </table>
            <!-- SEARCH / -->

            <div id="searchResult">
                <%--<form id="UserListForm" >--%>
                <%--<input type="hidden" id="ResultPageSearchID" name="ResultPageSearchID" value="<%=IIf(IsPostBack, Request.Form("ResultPageSearchID"), Request.Form("PageSearchID")) %>" />--%>
                <%--<input type="hidden" id="ResultParagraphSearchID" name="ResultParagraphSearchID" value="<%=IIf(IsPostBack, Request.Form("ResultParagraphSearchID"), Request.Form("PageSearchParagraphID"))%>" />--%>
                <%--<input type="hidden" id="TextSearch" name="TextSearch" value="<%=IIf(IsPostBack, Request.Form("TextSearch"), Request.Form("PageSearchText")) %>" />--%>
                <%--<input type="hidden" id="ModuleSearch" name="ModuleSearch" value="<%=IIf(IsPostBack, Request.Form("ModuleSearch"), Request.Form("PageSearch_Modules")) %>" />--%>
                <%--<input type="hidden" id="ResultPageSearchIn" name="ResultPageSearchIn" value="<%=IIf(IsPostBack, Request.Form("ResultPageSearchIn"), Request.Form("PageSearchIn")) %>" />--%>
                <dw:List ID="SearchList" runat="server" Title="Søgeresultat" PageSize="30">
                    <Columns>
                        <dw:ListColumn ID="ListColumn1" runat="server" Name="" EnableSorting="false" Width="5" />
                        <dw:ListColumn runat="server" Name="Overskrift" Width="250" EnableSorting="true" />
                        <dw:ListColumn ID="WebsiteColumn" runat="server" Name="Website" Width="150" EnableSorting="true" />
                        <dw:ListColumn runat="server" Name="Aktiv" Width="65" EnableSorting="true" ItemAlign="Center" />
                        <dw:ListColumn runat="server" Name="Oprettet" Width="80" EnableSorting="true" />
                        <dw:ListColumn runat="server" Name="Redigeret" Width="80" EnableSorting="true" />
                    </Columns>
                </dw:List>
                <%--</form>--%>
            </div>
        </div>
    </div>

    <div class="card-footer"></div>
</body>
</html>
<%--<% Translate.GetEditOnlineScript()%>--%>
