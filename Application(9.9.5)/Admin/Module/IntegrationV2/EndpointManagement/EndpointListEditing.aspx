<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EndpointListEditing.aspx.vb" Inherits="Dynamicweb.Admin.EndpointListEditing" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" runat="server" IncludeUIStylesheet="true" IncludePrototype="true">
    </dw:ControlResources>
    <script src="/Admin/Resources/js/layout/dwglobal.js" type="text/javascript"></script>
    <script src="/Admin/Resources/js/layout/Actions.js" type="text/javascript"></script>
    <script type="text/javascript">
        isUrlRegExp = /^((((https?|ftp|gopher|telnet|file|notes|ms-help):((\/\/)|(\\\\)))|(\/admin\/public))+[\w\d:#@%/;$()~_?\+-=\\\.&']*)$/i;
        isValid = function () {
            var result = true;
            dwGlobal.hideAllControlsErrors(null, "");

            var rows = dwGrid_endpointsGrid.rows.getAll();
            for (var i = 0; i < rows.length; i++) {
                var currentRow = rows[i];
                var el = currentRow.findControl('txName');
                if (!el.value) {                    
                    dwGlobal.showControlErrors(currentRow.findControl('helptxName'), '<%=Translate.JsTranslate("required")%>');
                    result = false;
                }

                el = currentRow.findControl('txUrl');
                if (!isUrlRegExp.test(el.value)) {
                    dwGlobal.showControlErrors(currentRow.findControl('helptxUrl'), '<%=Translate.JsTranslate("incorrect URL format")%>');
                    result = false;
                }
            }
            return result;
        }

        editSave = function (close) {
            if (!isValid()) {
                return false;
            }
            initiatePostBack("EditEndpointList", close ? "close" : "")
        }

        initiatePostBack = function (action, target) {
            var frm = document.getElementById("EndpointListEditingForm");
            document.getElementById("PostBackAction").value = (action + ':' + target);
            frm.submit();
        }

        function storeChangedRow(rowIndex) {
            var el = document.getElementById("<%= hdChangedRows.ClientID %>");
            var id = " " + rowIndex + ",";
            if (el != null && !el.value.includes(id)) {
                el.value += id;
            }
        }

        function cancel() {
            window.location = "EndpointsList.aspx";
        }
    </script>
    <style type="text/css">
        
    </style>
</head>
<body>
    <form id="EndpointListEditingForm" runat="server">

        <dw:RibbonBar ID="Ribbon" runat="server">
            <dw:RibbonBarTab ID="RibbonbarTab1" runat="server" Active="true" Name="Bulk edit">
                <dw:RibbonBarGroup ID="RibbonbarGroup3" runat="server" Name="Tools">
                    <dw:RibbonBarButton runat="server" Text="Save" Size="Small" Icon="Save" ID="RibbonbarButton2"
                        EnableServerClick="false" OnClientClick="editSave(false);" />
                    <dw:RibbonBarButton runat="server" Text="Save and close" Size="Small" Icon="Save"
                        EnableServerClick="false" ID="RibbonbarButton3" OnClientClick="editSave(true);" />
                    <dw:RibbonBarButton runat="server" Text="Cancel" Size="Small" Icon="TimesCircle" OnClientClick="cancel();"
                        ID="RibbonbarButton4" />
                </dw:RibbonBarGroup>
            </dw:RibbonBarTab>
        </dw:RibbonBar>
        <asp:HiddenField ID="endpointIds" runat="server" />

        <dw:StretchedContainer ID="EndpointEditScroll" Stretch="Fill" Scroll="Auto" Anchor="document" runat="server">
            <asp:Literal ID="errorOutput" runat="server" Text=""></asp:Literal>
            <dw:Infobar ID="errorBar" runat="server" Visible="false">
            </dw:Infobar>
            <div id="gridcontainer" style="overflow: auto;">
                <dw:EditableGrid ID="endpointsGrid" AllowAddingRows="true" AddNewRowMessage="Click here to add new endpoint..." ShowHeader="true"
                    NoRowsMessage="No endpoints found" AllowSortingRows="false" runat="server" DataKeyNames="Id" RowStyle-VerticalAlign="Top">
                    <Columns>
                        <asp:TemplateField HeaderText="Name" ItemStyle-Width="100px">
                            <ItemTemplate>
                                <div style="white-space: nowrap" class="form-group">
                                    <div class="form-group-input">
                                        <asp:TextBox ID="txName" MaxLength="255" CssClass="w-100 form-control" Text='<%#Eval("Name")%>' onchange='<%# "storeChangedRow(" + Container.DisplayIndex.ToString() + ");"%>' runat="server" />
                                        <small class="help-block error" id="helptxName"></small>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Description" ItemStyle-Width="100px">
                            <ItemTemplate>
                                <asp:TextBox ID="txDescription" CssClass="w-100 form-control" Text='<%#Eval("Description")%>' runat="server" onchange='<%# "storeChangedRow(" + Container.DisplayIndex.ToString() + ");"%>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Url" ItemStyle-Width="150px">
                            <ItemTemplate>
                                <div style="white-space: nowrap" class="form-group">
                                    <div class="form-group-input">
                                        <asp:TextBox ID="txUrl" CssClass="w-100 form-control" Text='<%#Eval("Url")%>' runat="server" onchange='<%# "storeChangedRow(" + Container.DisplayIndex.ToString() + ");"%>' />
                                        <small class="help-block error" id="helptxUrl"></small>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Request Type" ItemStyle-Width="20px">
                            <HeaderStyle Width="20px" />
                            <ItemStyle Width="20px" />
                            <ItemTemplate>
                                <asp:DropDownList runat="server" ID="ddRequestType" CssClass="w-100 selectpicker" name="ddRequestType" label="Type" SelectedValue='<%# Bind("RequestType") %>' onchange='<%# "storeChangedRow(" + Container.DisplayIndex.ToString() + ");"%>'>
                                    <asp:ListItem Text="GET" Value="GET" Selected="true"></asp:ListItem>
                                    <asp:ListItem Text="POST" Value="POST"></asp:ListItem>
                                </asp:DropDownList>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Request Headers" ItemStyle-Width="150px">
                            <ItemTemplate>
                                <asp:TextBox ID="txHeaders" ToolTip="Rows are separated by new lines. Keys and values are separated by :" onkeyup="CheckUniquenessOfNames();" CssClass="w-100 form-control" Text='<%#GetHeaders(Eval("Headers"))%>' runat="server" TextMode="MultiLine" onchange='<%# "storeChangedRow(" + Container.DisplayIndex.ToString() + ");"%>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Request Body" ItemStyle-Width="150px">
                            <ItemTemplate>
                                <asp:TextBox ID="txBody" CssClass="w-100 form-control" Text='<%#Eval("Body")%>' runat="server" TextMode="MultiLine" onchange='<%# "storeChangedRow(" + Container.DisplayIndex.ToString() + ");"%>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Authentication" ItemStyle-Width="20px">
                            <HeaderStyle Width="20px" />
                            <ItemStyle Width="20px" />
                            <ItemTemplate>
                                <asp:DropDownList runat="server" ID="ddAuthentication" CssClass="w-100 selectpicker" name="ddAuthentication" label="Authentication" onchange='<%# "storeChangedRow(" + Container.DisplayIndex.ToString() + ");"%>'>
                                    <asp:ListItem Text="None" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </dw:EditableGrid>
            </div>
        </dw:StretchedContainer>


        <asp:HiddenField ID="PostBackAction" runat="server" />
        <asp:HiddenField ID="hdBackUrl" runat="server" />
        <asp:HiddenField ID="hdChangedRows" runat="server" />
        <asp:HiddenField ID="hdOrderBy" runat="server" />
    </form>
</body>
</html>
