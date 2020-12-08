<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CacheOverview.aspx.vb" Inherits="Dynamicweb.Admin.CacheOverview" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Cache overview</title>
    <dw:ControlResources ID="ctrlResources" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
        </Items>
    </dw:ControlResources>
    <script type="text/javascript">
        function ClearCache(fullName) {
            (async () => {
                await fetch(window.location + "&ClearCache=" + fullName);     
                location.reload();
            })();
        }
    </script>
</head>
<body class="screen-container">
    <form id="form1" runat="server">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" ID="CardHeader" Title="Cache overview"></dwc:CardHeader>
            <dwc:CardBody runat="server">
                <dwc:GroupBox runat="server" ID="StaticTypesBox" Title="Static types" Visible="false" Expandable="true">
                    <div class="form-group">
                        <label class="control-label"><%=Translate.Translate("Types total")%></label>
                        <div>
                            <asp:Literal ID="AssemblyTypesTotal" runat="server" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label"><%=Translate.Translate("Assembly name")%></label>
                        <div>
                            <asp:Literal ID="AssemblyName" runat="server" />
                        </div>
                    </div>
                    <dw:List ID="StaticTypeList" runat="server" ShowTitle="false" EnableViewState="false">
                        <Columns>
                            <dw:ListColumn ID="ColType" Name="Type" EnableSorting="true" runat="server" />
                            <dw:ListColumn ID="ColCaches" Name="Caches" EnableSorting="false" runat="server" />
                            <dw:ListColumn ID="ColFields" Name="Fields" EnableSorting="true" runat="server" Width="100" />
                            <dw:ListColumn ID="ColProperties" Name="Properties" EnableSorting="true" runat="server" Width="100" />
                        </Columns>
                    </dw:List>
                </dwc:GroupBox>
                <dwc:GroupBox runat="server" ID="StaticTypesEcommerceBox" Title="Static types (eCommerce)" Visible="false" Expandable="true">
                    <div class="form-group">
                        <label class="control-label"><%=Translate.Translate("Types total")%></label>
                        <div>
                            <asp:Literal ID="AssemblyEcommerceTypesTotal" runat="server" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label"><%=Translate.Translate("Assembly name")%></label>
                        <div>
                            <asp:Literal ID="AssemblyEcommerceName" runat="server" />
                        </div>
                    </div>
                    <dw:List ID="StaticTypeEcommerceList" runat="server" ShowTitle="false" EnableViewState="false">
                        <Columns>
                            <dw:ListColumn ID="ListColumn7" Name="Type" EnableSorting="true" runat="server" />
                            <dw:ListColumn ID="ListColumn10" Name="Caches" EnableSorting="false" runat="server" />
                            <dw:ListColumn ID="ListColumn8" Name="Fields" EnableSorting="true" runat="server" Width="100" />
                            <dw:ListColumn ID="ListColumn9" Name="Properties" EnableSorting="true" runat="server" Width="100" />
                        </Columns>
                    </dw:List>
                </dwc:GroupBox>
                <dwc:GroupBox runat="server" ID="MemoryCachesBox" Title="Memory caches" Visible="false" Expandable="true">
                    <div class="form-group">
                        <label class="control-label"><%=Translate.Translate("Objects total")%></label>
                        <div>
                            <asp:Literal ID="MemoryObjectsTotal" runat="server" />
                        </div>
                    </div>
                    <dw:List ID="MemoryCacheList" runat="server" ShowTitle="false" EnableViewState="false">
                        <Columns>
                            <dw:ListColumn ID="ListColumn1" Name="Key" EnableSorting="true" runat="server" />
                            <dw:ListColumn ID="ListColumn2" Name="Object" EnableSorting="true" runat="server" />
                        </Columns>
                    </dw:List>
                </dwc:GroupBox>
                <dwc:GroupBox runat="server" ID="SessionCacheBox" Title="Session caches" Visible="false" Expandable="true">
                    <div class="form-group">
                        <label class="control-label"><%=Translate.Translate("Objects total")%></label>
                        <div>
                            <asp:Literal ID="SessionObjectsTotal" runat="server" />
                        </div>
                    </div>
                    <dw:List ID="SessionCacheList" runat="server" ShowTitle="false" EnableViewState="false">
                        <Columns>
                            <dw:ListColumn ID="ListColumn3" Name="Key" EnableSorting="true" runat="server" />
                            <dw:ListColumn ID="ListColumn4" Name="Object" EnableSorting="true" runat="server" />
                        </Columns>
                    </dw:List>
                </dwc:GroupBox>
                <dwc:GroupBox runat="server" ID="ApplicationCacheBox" Title="Application caches" Visible="false" Expandable="true">
                    <div class="form-group">
                        <label class="control-label"><%=Translate.Translate("Objects total")%></label>
                        <div>
                            <asp:Literal ID="ApplicationObjectsTotal" runat="server" />
                        </div>
                    </div>
                    <dw:List ID="ApplicationCacheList" runat="server" ShowTitle="false" EnableViewState="false">
                        <Columns>
                            <dw:ListColumn ID="ListColumn5" Name="Key" EnableSorting="true" runat="server" />
                            <dw:ListColumn ID="ListColumn6" Name="Object" EnableSorting="true" runat="server" />
                        </Columns>
                    </dw:List>
                </dwc:GroupBox>
                <dwc:GroupBox runat="server" ID="ServiceCacheBox" Title="Service caches" Visible="false" Expandable="true">
                    <div class="form-group">
                        <label class="control-label"><%=Translate.Translate("Services total")%></label>
                        <div>
                            <asp:Literal ID="ServicesTotal" runat="server" />
                        </div>
                    </div>
                    <dw:List ID="ServiceCacheList" runat="server" ShowTitle="false" EnableViewState="false">
                        <Columns>
                            <dw:ListColumn ID="ListColumn11" Name="Service" EnableSorting="true" runat="server" />
                            <dw:ListColumn ID="ListColumn12" Name="Cache type" EnableSorting="true" runat="server" />
                            <dw:ListColumn ID="ListColumn13" Name="Cache information" EnableSorting="true" runat="server" />
                            <dw:ListColumn ID="ListColumn14" Name="Cached items" EnableSorting="true" runat="server" />
                            <dw:ListColumn ID="ListColumn15" Name="Last changed" EnableSorting="true" runat="server" />
                            <dw:ListColumn ID="ListColumn16" Name="Last cleared" EnableSorting="true" runat="server" />
                            <dw:ListColumn ID="ListColumn18" Name="Clear" runat="server" />
                        </Columns>
                    </dw:List>
                </dwc:GroupBox>
            </dwc:CardBody>
            <dwc:CardFooter runat="server" />
        </dwc:Card>
    </form>
</body>
</html>
