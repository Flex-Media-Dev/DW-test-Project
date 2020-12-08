<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="InputExample.aspx.vb" Inherits="Dynamicweb.Admin.Input_Example" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls.OMC" TagPrefix="omc" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>
<head>

    <title></title>
    <!-- Default control resources -->
    <link href="/Admin/Resources/vendors/animate-css/animate.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/Admin/Resources/fonts/font-awesome/css/font-awesome.min.css">
    <link href="/Admin/Resources/vendors/noUiSlider/jquery.nouislider.min.css" rel="stylesheet">
    <%--<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-table/1.8.1/bootstrap-table.min.css" rel="stylesheet">--%>
    
    <link href="/Admin/Resources/css/fonts.min.css" rel="stylesheet">
    <link href="/Admin/Resources/css/app.min.css" rel="stylesheet">
</head>
<body class="area-blue">
    <section id="content" class="dw8-container">
        <dwc:BlockHeader runat="server">
            <ul class="actions">
                <li>
                    <a class="icon-pop" href="javascript:help();"><i class="md md-help"></i></a>
                </li>
            </ul>
        </dwc:BlockHeader>

        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" Title="Input Controls">
            </dwc:CardHeader>

            <div role="tabpanel">
                <ul class="tab-nav" role="tablist" data-tab-color="green">
                    <li class="active"><a href="#dw" aria-controls="dw" role="tab" data-toggle="tab">Dw: Controls</a></li>
                    <li><a href="#asp" aria-controls="asp" role="tab" data-toggle="tab">Asp: Controls</a></li>
                </ul>
            </div>

            <dwc:CardBody runat="server">
                <div class="tab-content">
                    <div role="tabpanel" class="tab-pane active" id="dw">
                        <dwc:GroupBox ID="GroupBox2" runat="server" Title="Basic input controls" GroupWidth="4">
                            <dwc:InputText runat="server" Label="Afsnitsnavn" ID="ParagraphHeader22" MaxLength="255" />

                            <dwc:CheckBox runat="server" ID="checkbox" Header="Checkbox" Label="Check this!" />

                            <div class="form-group">
                                <dw:TranslateLabel runat="server" ID="translate" Text="This is a translate label"></dw:TranslateLabel>
                            </div>

                            <div class="form-group">
                                <label class="control-label">Radio button list</label>
                                <dwc:RadioButton runat="server" Label="radioButton 0" Name="test" checked="true" />
                                <dwc:RadioButton runat="server" Label="radioButton 1" Name="test" />
                                <dwc:RadioButton runat="server" Label="radioButton 2" Name="test" />
                                <dwc:RadioButton runat="server" Label="radioButton 3" Name="test" />
                            </div>
                        </dwc:GroupBox>

                        <dwc:GroupBox ID="GroupBox3" runat="server" Title="Selectors" GroupWidth="4">
                            <dw:ColorSelect runat="server" ID="colorselector" Label="Select color" Placeholder="#C21212" />

                            <dw:DateSelector runat="server" EnableViewState="false" ID="dateselector" />

                            <%--<dw:Label runat="server" ID="label" Title="Label basic" doTranslation="true" />--%>

                            <dw:FileManager runat="server" ID="filemanager" Label="Choose a favorite" />

                            <dw:LinkManager runat="server" ID="lm" />
                        </dwc:GroupBox>

                        <dwc:GroupBox ID="GroupBox4" runat="server" Title="Other" GroupWidth="4">
                            <dw:Richselect ID="PageLayout" runat="server" Height="60" Itemheight="60" Width="300" Itemwidth="300">
                                <dw:RichselectItem ID="itemf" runat="server" name="bla" Value="bla" />
                            </dw:Richselect>

                            <dwc:GroupBox runat="server" ID="GroupBox1" Title="Groupbox">
                                <p>This is a groupbox</p>
                            </dwc:GroupBox>
                        </dwc:GroupBox>
                    </div>

                    <div role="tabpanel" class="tab-pane" id="asp">
                        <form id="form1" runat="server">
                            <div class="col-md-3">
                                <div class="formgroup">
                                    <p class="m-b-15 c-gray f-500">Textbox - Basic</p>
                                    <!-- asp:TextBox- Start -->
                                    <div class="form-group-input">
                                        <asp:TextBox runat="server" ID="tekstboksen" CssClass="form-control fg-input" placeholder="Type something..." />
                                    </div>
                                    <!-- End -->
                                </div>
                                <br />

                                <div class="formgroup">
                                    <p class="m-b-15 c-gray f-500">TextArea - Basic</p>
                                    <label class="control-label">With label and placeholder</label>
                                    <div class="form-group-input">
                                        <!-- asp:TextBox- Start -->
                                        <asp:TextBox TextMode="multiline" runat="server" CssClass="form-control fg-input" ID="TextBox1" placeholder="Type something..." />
                                    </div>

                                    <!-- End -->
                                </div>
                                <br />

                                <div class="formgroup">
                                    <p class="m-b-15 c-gray f-500">Button - Basic</p>
                                    <!-- asp:Button- Start -->
                                    <asp:Button runat="server" ID="Button" Text="submit" value="test" CssClass="btn btn-primary" />
                                    <!-- End -->
                                </div>
                                <br />

                                <div class="formgroup">
                                    <p class="m-b-15 c-gray f-500">CheckBox - Basic</p>
                                    <!-- asp:CheckBox- Start -->
                                    <asp:CheckBox runat="server" ID="check1" />
                                    <label for="check1">This is a checkbox</label>
                                    <!-- End -->
                                </div>
                            </div>

                            <div class="col-md-3">
                                <br />
                                <div class="formgroup">
                                    <p class="m-b-15 c-gray f-500">RadioButtonList - Basic</p>
                                    <!-- asp:RadioButtonList- Start -->
                                    <asp:RadioButtonList ID="EnableCdn" CssClass="radio m-b-15" runat="server" RepeatDirection="Vertical" CellPadding="0" CellSpacing="0">

                                        <asp:ListItem Value="True" Text="Activate">
                                        </asp:ListItem>
                                        <asp:ListItem Value="False" Text="Deactivate">
                                        </asp:ListItem>
                                        <asp:ListItem Value="False" Text="Inherits global settings">
                                        </asp:ListItem>
                                    </asp:RadioButtonList>

                                    <!-- End -->
                                </div>
                                <br />


                                <div class="formgroup">
                                    <p class="m-b-15 c-gray f-500">FileUpload - Basic</p>
                                    <!-- asp:FileUpload- Start -->
                                    <asp:FileUpload runat="server" ID="UploadFile" CssClass="btn btn-primary" EnableTheming="False" AllowMultiple="True" /><br />
                                    <!-- End -->
                                </div>
                                <br />
                            </div>

                            <div class="col-md-3">
                                <div class="formgroup">
                                    <p class="m-b-15 c-gray f-500">Image - Basic</p>
                                    <!-- asp:Image- Start -->
                                    <asp:Image ID="Logo" runat="server" />
                                    <!-- End -->
                                </div>
                                <br />

                                <div class="formgroup">
                                    <p class="m-b-15 c-gray f-500">Panel - Basic</p>
                                    <!-- asp:Panel- Start -->
                                    <asp:Panel ID="pLinks" CssClass="links tab-switch" runat="server">

                                        <div class="dashboard-separator"></div>

                                    </asp:Panel>
                                    <!-- End -->
                                </div>
                                <br />


                                <div class="formgroup">
                                    <p class="m-b-15 c-gray f-500">HiddenField - Basic</p>
                                    <!-- asp:HiddenField- Start -->
                                    <asp:HiddenField ID="ChosenColor" runat="server" Value="#FFFFFF" />
                                    <!-- End -->
                                </div>
                                <br />

                            </div>
                        </form>
                    </div>
                </div>
            </dwc:CardBody>

            <dwc:CardFooter runat="server">
            </dwc:CardFooter>
        </dwc:Card>

    </section>


    <!-- INSERT SCRIPTS, ONLY USED ON THIS PAGE, HERE -->

    <script src="/Admin/Resources/js/jquery-2.1.1.min.js"></script>
    <script src="/Admin/Resources/js/layout/bootstrap.min.js"></script>

    <script src="/Admin/Resources/vendors/moment/moment.min.js"></script>
    <script src="/Admin/Resources/vendors/auto-size/jquery.autosize.min.js"></script>
    <script src="/Admin/Resources/vendors/bootstrap-select/bootstrap-select.min.js"></script>
    <script src="/Admin/Resources/vendors/chosen/chosen.jquery.min.js"></script>
    <script src="/Admin/Resources/vendors/input-mask/input-mask.min.js"></script>
    <script src="/Admin/Resources/vendors/maxlength/bootstrap-maxlength.min.js"></script>
    <script src="/Admin/Resources/vendors/waves/waves.min.js"></script>
    <script src="/Admin/Resources/vendors/bootstrap-wizard/jquery.bootstrap.wizard.min.js"></script>

    <%--<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-table/1.8.1/bootstrap-table-all.min.js"></script>--%>

    <script src="/Admin/Resources/js/layout/input-functions.js"></script>
    <script src="/Admin/Resources/js/layout/screen-functions.js"></script>
    <script src="/Admin/Resources/js/layout/picker.js"></script>
    <script src="/Admin/Resources/js/layout/selector.js"></script>
    <script src="/Admin/Resources/js/layout/treeview.js"></script>
    <script src="/Admin/Resources/js/layout/tilesview.js"></script>
</body>
