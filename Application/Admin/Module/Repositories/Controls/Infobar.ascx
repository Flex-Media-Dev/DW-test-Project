<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="Infobar.ascx.vb" Inherits="Dynamicweb.Admin.Repositories.Controls.Infobar" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Register TagPrefix="omc" Namespace="Dynamicweb.Controls.OMC" Assembly="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<div class="BottomInformation card-footer" id="BottomInformationBg">
    <table border="0" cellspacing="0" cellpadding="0">
        <tbody>
            <tr>

                <td rowspan="2">
                    <img class="h" id="icon" alt="" src="<%=Icon%>" onclick="dialog.show('dlgSource');"/>
                </td>

                <td align="right">
                    <span class="label"><%=Translate.Translate("Name")%>:</span>
                </td>
                <td>
                    <span id="_itemName"><%=Name%></span>
                </td>

                <td align="right">
                    <span class="label"><%=Translate.Translate("Type")%>:</span>
                </td>

                <td>
                    <span id="_fieldCount"><%=Type%></span>
                </td>

                <% If Not String.IsNullOrEmpty(Modified) Then %>
                <td align="right">
                    <span class="label"><%=Translate.Translate("Modified")%>:</span>
                </td>

                <td>
                    <span id="_fieldCount"><%=Modified%></span>
                </td>
                <% End If %>

                <td align="right"></td>
                <td width="50%"></td>
                <td></td>
            </tr>
            <tr>
                <td align="right">
                    <span class="label"><%=Translate.Translate("Filename")%>:</span>
                </td>

                <td colspan="5">
                    <span id="_systemName"><%=FileName%></span>
                </td>


                <td align="right"></td>
                <td width="50%"></td>
                <td></td>

            </tr>
        </tbody>
    </table>
</div>

<dw:Dialog ID="dlgSettings" Title="Settings"  ShowClose="true"  ShowOkButton="true" ShowCancelButton="false" OkAction="document.getElementById('dlgSettings').style.display = 'none';" runat="server">
	<dw:GroupBox ID="GroupBox1" runat="server" Title="Name & Type" DoTranslation="true">
		<div Title="Name" DoTranslation="true">
            <input type="text" style="width:100%" disabled="true" ng-model="<%=Model%>.Name">
		</div>
		<div Title="Name" DoTranslation="true">
            <select style="width:100%"  disabled="true">
                <option value="Default">Default</option>
            </select>
		</div>
	</dw:GroupBox>
	<dw:GroupBox ID="GroupBox5" runat="server" Title="Settings" DoTranslation="true">
 		<div style="overflow-y:scroll; height:100px;">
            <div class="item-field" style="border-bottom:1px solid silver;height:18px;v" ng-repeat="(name, value) in <%=Model%>.Settings">
                <span class="C1"><input type="text" ng-model="name" readonly="true"/></span>
                <span class="C2"><input type="text" ng-model="<%=Model%>.Settings[name]"/></span>
            </div>
		</div>
	</dw:GroupBox>
	<dw:GroupBox ID="GroupBox2" runat="server" Title="Meta" DoTranslation="true">
 		<div style="overflow-y:scroll;">
            <div class="item-field" ng-repeat="(name, value) in <%=Model%>.Meta">
                <span class="C1"><input type="text" ng-model="name" readonly="true"/></span>
                <span class="C2"><input type="text" ng-model="<%=Model%>.Meta[name]"/></span>
            </div>
		</div>
	</dw:GroupBox>
</dw:Dialog>

<dw:Dialog ID="dlgSource" Title="Source" Width="600" ShowClose="true"  ShowOkButton="true" ShowCancelButton="false" OkAction="document.getElementById('dlgSource').style.display = 'none';" runat="server">
	<dw:GroupBox ID="GroupBox4" runat="server" Title="Source" DoTranslation="true">
 		<textarea style="width:525px;height:400px;">
                {{<%=Model%>}}
		</textarea>
	</dw:GroupBox>
</dw:Dialog>
