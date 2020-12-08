<%@ Page Language="vb" MasterPageFile="/Admin/Content/Management/EntryContent2.Master" AutoEventWireup="false" CodeBehind="EcomAdvConfigImages_Edit.aspx.vb" Inherits="Dynamicweb.Admin.EcomAdvConfigImages_Edit" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import namespace="Dynamicweb" %>
<%@ Import namespace="Dynamicweb.SystemTools" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <script language="javascript" type="text/javascript">
        var page = SettingsPage.getInstance();
        page.init = function () {
            
            document.getElementById("DeprecateOldImages").addEventListener("click", function () {
                page.showAndHideFeatures();
            });

            document.getElementById("UseImprovedPatterns").addEventListener("click", function () {
                document.getElementById("DeprecateOldImages").checked = true;
                document.getElementById("UseCaching").checked = true;
                page.showAndHideFeatures();
            });

            this.showAndHideFeatures();
        }

        page.showAndHideFeatures = function () {
            var deprecateOldImages = document.getElementById("DeprecateOldImages").checked;
            var useImprovedImagePatterns = document.getElementById("UseImprovedPatterns").checked;

            if (deprecateOldImages || useImprovedImagePatterns) {
                document.getElementById("nopictureSmall").style.display = "none";
                document.getElementById("nopictureMedium").style.display = "none";
                document.getElementById("ImagePatternPane").style.display = "none";
                document.getElementById("AutoscalePane").style.display = "none";

                document.getElementById("oldLabel").style.display = "none";
                document.getElementById("newLabel").style.display = "block";
                
                
            } else {
                document.getElementById("nopictureSmall").style.display = "block";
                document.getElementById("nopictureMedium").style.display = "block";
                document.getElementById("ImagePatternPane").style.display = "block";
                document.getElementById("AutoscalePane").style.display = "block";

                document.getElementById("oldLabel").style.display = "block";
                document.getElementById("newLabel").style.display = "none";
                
            }
            if (useImprovedImagePatterns) {
                document.getElementById("DeprecateOldImages").checked = true;
                document.getElementById("UseImprovedPatternsFeatures").style.display = "block";
            } else {
                document.getElementById("UseImprovedPatternsFeatures").style.display = "none";
            }
           
        };
        
        page.onSave = function() {
            document.getElementById('MainForm').submit();
        }
        
        page.onHelp = function() {
            <%=Dynamicweb.SystemTools.Gui.help("", "administration.controlpanel.ecom.images") %>
        }

        document.addEventListener("DOMContentLoaded", function (event) {
            page.init();
        });
    </script>
    <style>
        #UseImprovedPatternsFeatures{
            padding-left:25px;
        }

        table.autoscale input[type=number] {
            width: 65px;
        }

        table.autoscale td,
        table.autoscale th {
            padding: 5px;
        }

        table.autoscale th {
            text-align: left;
        }

        table.autoscale th.text-center {
            text-align: center;
        }
    </style>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server" >

    <div id="PageContent">
        <dwc:GroupBox runat="server" Title="Settings">
            <dwc:CheckBox runat="server" Name="/Globalsettings/Ecom/Picture/DeprecateOldImages" ID="DeprecateOldImages" Value="True" Label="Deprecate Small, Medium and Large image features" Info="Removes image pattern fields for small, medium and large images" />
            <dwc:CheckBox runat="server" Name="/Globalsettings/Ecom/Picture/UseImprovedPatterns" ID="UseImprovedPatterns" Value="True" Label="Improved Image Patterns" Info="Enables the new and faster image pattern feature. New tags neeeds to be used in templates" />
            <div id="UseImprovedPatternsFeatures">
                <dwc:CheckBox runat="server" Name="/Globalsettings/Ecom/Picture/Patterns/UseCaching" ID="UseCaching" Value="True" Label="Enable caching" Info="Caches image paths for enhanced performance. Only disable for debugging purposes." />
                <dwc:CheckBox runat="server" Name="/Globalsettings/Ecom/Picture/Patterns/Compatability" ID="UseCompatability" Value="True" Label="Compatibility mode" Info="Enables deprecated image pattern tags. (Ecom:Product.ImageLarge.Clean, Ecom:Product.ImageDefault, Ecom:Product.ImageDefault.Default.Clean, Ecom:Product.Image{PatternName}.Clean )" />
            </div>
        </dwc:GroupBox>
        
        <dwc:GroupBox runat="server" Title="Product default images" ID="ProductDefaultImagesPane">
            <div Class="form-group" id="nopictureSmall">
                <Label Class="control-label"><%=Translate.Translate("Lille")%></label>
                <%= Dynamicweb.SystemTools.Gui.FileManager(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Ecom/Picture/NoPicture/Small"), Dynamicweb.Content.Files.FilesAndFolders.GetImagesFolderName(), "/Globalsettings/Ecom/Picture/NoPicture/Small", "/Globalsettings/Ecom/Picture/NoPicture/Small", "", True, "std", True, Nothing)%>
            </div>
            <div class="form-group" id="nopictureMedium">
                <label class="control-label"><%=Translate.Translate("Medium")%></label>
                <%= Dynamicweb.SystemTools.Gui.FileManager(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Ecom/Picture/NoPicture/Medium"), Dynamicweb.Content.Files.FilesAndFolders.GetImagesFolderName(), "/Globalsettings/Ecom/Picture/NoPicture/Medium", "/Globalsettings/Ecom/Picture/NoPicture/Medium", "", True, "std", True, Nothing)%>
            </div>               
            <div class="form-group">
                <label class="control-label old-label" id="oldLabel"><%=Translate.Translate("Stor")%></label>
                <label class="control-label new-label" id="newLabel" style="display:none"><%=Translate.Translate("Missing image")%></label>
                <%= Dynamicweb.SystemTools.Gui.FileManager(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Ecom/Picture/NoPicture/Large"), Dynamicweb.Content.Files.FilesAndFolders.GetImagesFolderName(), "/Globalsettings/Ecom/Picture/NoPicture/Large", "/Globalsettings/Ecom/Picture/NoPicture/Large", "", True, "std", True, Nothing)%>
            </div>
        </dwc:GroupBox>

        <dwc:GroupBox runat="server" Title="Group default images">
            <div class="form-group">
                <label class="control-label"><%=Translate.Translate("Lille")%></label>
                <%= Dynamicweb.SystemTools.Gui.FileManager(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Ecom/Picture/Group/NoPicture/Small"), Dynamicweb.Content.Files.FilesAndFolders.GetImagesFolderName(), "/Globalsettings/Ecom/Picture/Group/NoPicture/Small", "/Globalsettings/Ecom/Picture/Group/NoPicture/Small", "", True, "std", True, Nothing)%>
            </div>
            <div class="form-group">
                <label class="control-label"><%=Translate.Translate("Stor")%></label>
                <%= Dynamicweb.SystemTools.Gui.FileManager(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Ecom/Picture/Group/NoPicture/Large"), Dynamicweb.Content.Files.FilesAndFolders.GetImagesFolderName(), "/Globalsettings/Ecom/Picture/Group/NoPicture/Large", "/Globalsettings/Ecom/Picture/Group/NoPicture/Large", "", True, "std", True, Nothing)%>
            </div>
        </dwc:GroupBox>
        <dwc:GroupBox runat="server" Title="Image pattern" ID="ImagePatternPane">
            <dwc:InputText runat="server" Label="Pattern" ID="ImagePattern" Name="/Globalsettings/Ecom/Picture/ImagePattern" />            
        </dwc:GroupBox>

		<dwc:GroupBox runat="server" Title="Autoscale" ID="AutoscalePane">
            <table class="autoscale">
                <tr>
				    <th width="100px"></th>
				    <th width="60px" class="text-center"><%=Translate.JsTranslate("Active")%></th>
				    <th><%=Translate.JsTranslate("Width")%></th>
                    <th></th>
                    <th><%=Translate.JsTranslate("Height")%></th>
			    </tr>				        
			    <tr>
				    <td><%=Translate.Translate("Lille")%></td>
				    <td align="center">
                        <input type="checkbox" value="True" <%=IIf(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Ecom/Picture/Autoscale/Small/Active") = "True", "CHECKED", "")%> id="/Globalsettings/Ecom/Picture/Autoscale/Small/Active" name="/Globalsettings/Ecom/Picture/Autoscale/Small/Active" class="checkbox" />
                        <label for="/Globalsettings/Ecom/Picture/Autoscale/Small/Active"></label>
				    </td>
				    <td>
				        <input type="number" name="/Globalsettings/Ecom/Picture/Autoscale/Small/Width" id="/Globalsettings/Ecom/Picture/Autoscale/Small/Width" value="<%=Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Ecom/Picture/Autoscale/Small/Width")%>" maxlength="255" size="4" min="0" class="std" /> 
				    </td>
                    <td>
                        <span style="color:Gray">x</span>
                    </td>
				    <td>
                        <input type="number" name="/Globalsettings/Ecom/Picture/Autoscale/Small/Height" id="/Globalsettings/Ecom/Picture/Autoscale/Small/Height" value="<%=Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Ecom/Picture/Autoscale/Small/Height")%>" maxlength="255" size="4" min="0" class="std" /> 
				        <span style="color:Gray"><%=Translate.JsTranslate("px")%></span>
				    </td>
			    </tr>
			    <tr>
				    <td><%=Translate.Translate("Medium")%></td>
				    <td align="center">
                        <input type="checkbox" value="True" <%=IIf(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Ecom/Picture/Autoscale/Medium/Active") = "True", "CHECKED", "")%> id="/Globalsettings/Ecom/Picture/Autoscale/Medium/Active" name="/Globalsettings/Ecom/Picture/Autoscale/Medium/Active" class="checkbox" />
                        <label for="/Globalsettings/Ecom/Picture/Autoscale/Medium/Active"></label>
				    </td>
                    <td>
				        <input type="number" name="/Globalsettings/Ecom/Picture/Autoscale/Medium/Width" id="/Globalsettings/Ecom/Picture/Autoscale/Medium/Width" value="<%=Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Ecom/Picture/Autoscale/Medium/Width")%>" maxlength="255" size="4" min="0" class="std" /> 
				    </td>
                    <td>
                        <span style="color:Gray">x</span>
                    </td>
                    <td>
				        <input type="number" name="/Globalsettings/Ecom/Picture/Autoscale/Medium/Height" id="/Globalsettings/Ecom/Picture/Autoscale/Medium/Height" value="<%=Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Ecom/Picture/Autoscale/Medium/Height")%>" maxlength="255" size="4" min="0" class="std" /> 
				        <span style="color:Gray"><%=Translate.JsTranslate("px")%></span>
				    </td>
			    </tr>
			    <tr>
				    <td><%=Translate.Translate("Stor")%></td>
				    <td align="center">
                        <input type="checkbox" value="True" <%=IIf(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Ecom/Picture/Autoscale/Large/Active") = "True", "CHECKED", "")%> id="/Globalsettings/Ecom/Picture/Autoscale/Large/Active" name="/Globalsettings/Ecom/Picture/Autoscale/Large/Active" class="checkbox" />
                        <label for="/Globalsettings/Ecom/Picture/Autoscale/Large/Active"></label>
				    </td>
                    <td>
				        <input type="number" name="/Globalsettings/Ecom/Picture/Autoscale/Large/Width" id="/Globalsettings/Ecom/Picture/Autoscale/Large/Width" value="<%=Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Ecom/Picture/Autoscale/Large/Width")%>" maxlength="255" size="4" min="0" class="std" /> 
				    </td>
                    <td>
                        <span style="color:Gray">x</span>
                    </td>
                    <td>
				        <input type="number" name="/Globalsettings/Ecom/Picture/Autoscale/Large/Height" id="/Globalsettings/Ecom/Picture/Autoscale/Large/Height" value="<%=Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Ecom/Picture/Autoscale/Large/Height")%>" maxlength="255" size="4" min="0" class="std" /> 
				        <span style="color:Gray"><%=Translate.JsTranslate("px")%></span>
				    </td>
			    </tr>
		    </table>
		</dwc:GroupBox>

    <% Translate.GetEditOnlineScript() %>

</asp:Content>
