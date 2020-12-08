<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ControlsDemo.aspx.vb" Inherits="Dynamicweb.Admin.ControlsDemo" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <dwc:ScriptLib runat="server" ID="ScriptLib">
        <script src="/Admin/Content/JsLib/colors-js-1.2.4/colors.min.js"></script>
        <script src="/Admin/Content/JsLib/jscolor-1.3.1/jscolor.js"></script>        
    </dwc:ScriptLib>
</head>
<body class="screen-container">
    <form id="form1" runat="server">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" Title="New markup example"></dwc:CardHeader>
            <dwc:CardBody runat="server">
                <dwc:GroupBox runat="server" Title="First type of errors/tooltips">
                    <div class="field-example">
                        <label class="field__label">Text</label>
                        <div class="field__group">
                            <input class="std" placeholder="Input text" />
                        </div>
                    </div>

                    <div class="field-example">
                        <div class="field__group left-indent">
                            <input class="std" placeholder="Input without label" />
                            <button class="std-addon" type="button">
                                <i class="fa fa-file-o color-primary"></i>
                            </button>
                        </div>
                    </div>

                    <div class="field-example" id="field_1">
                        <label class="field__label">Some label</label>
                        <div class="field__group">
                            <input class="std" placeholder="Input with buttons" />
                            <button class="std-addon" type="button">
                                <i class="fa fa-file-o color-primary"></i>
                            </button>
                            <button class="std-addon" type="button" title="Toogle error" onclick="jQuery('#field_1').toggleClass('field--error')">
                                <i class="md md-warning color-danger"></i>
                            </button>
                            <div class="tooltip-block error">
                                Some error
                            </div>
                            <div class="tooltip-block info">
                                Some help tooltip
                            </div>
                        </div>
                    </div>
                    
                    <div class="field-example" id="field_2">
                        <label class="field__label">Select</label>
                        <div class="field__group">
                            <select class="std selectpicker">
                                <option>Some select</option>
                            </select>
                            <button class="std-addon" type="button">
                                <i class="fa fa-file-o color-primary"></i>
                            </button>
                            <button class="std-addon" type="button">
                                <i class="fa fa-file-o color-primary"></i>
                            </button>
                            <button class="std-addon" type="button">
                                <i class="fa fa-file-o color-primary"></i>
                            </button>
                            <button class="std-addon" type="button" title="Toogle error" onclick="jQuery('#field_2').toggleClass('field--error')">
                                <i class="md md-warning color-danger"></i>
                            </button>
                            <button class="std-addon" type="button">
                                <i class="fa fa-file-o color-primary"></i>
                            </button>
                            <div class="tooltip-block error">
                                Some error
                            </div>
                        </div>
                    </div>

                    <div class="field-example">
                        <label class="field__label">Number</label>
                        <div class="field__group">
                            <input class="std" type="number" placeholder="9999" />
                            <span class="std-addon-text">%</span>
                        </div>
                    </div>

                    <div class="field-example field--error">
                        <label class="field__label">Number</label>
                        <div class="field__group">
                            <input class="std" type="number" placeholder="9999" />
                            <span class="std-addon-text">inch</span>
                            <div class="tooltip-block error">
                                Some error
                            </div>
                        </div>
                    </div>

                    <div class="field-example">
                        <label class="field__label">Number with select</label>
                        <div class="field__group">
                            <input class="std" type="number" placeholder="9999" />
                            <select class="std-addon-units">
                                <option>mm</option>
                                <option>cm</option>
                                <option>inch</option>
                                <option>foot</option>
                            </select>
                        </div>
                    </div>

                    <div class="field-example">
                        <label class="field__label">Throw exception</label>
                        <div class="field__group">
                            <asp:Button runat="server" ID="ThrowException" Text="Throw exception now" CssClass="btn btn-danger" />
                        </div>
                    </div>
                </dwc:GroupBox>

                <dwc:GroupBox runat="server" Title="Throw and log SQL exceptions">
                    <div class="field-example">
                        <label class="field__label"></label>
                        <div class="field__group">
                            <asp:Button runat="server" ID="ExecuteNonQueryThrow" Text="ExecuteNonQuery method" CssClass="btn btn-danger" />
                        </div>
                    </div>

                    <div class="field-example">
                        <label class="field__label"></label>
                        <div class="field__group">
                            <asp:Button runat="server" ID="ExecuteScalarThrow" Text="ExecuteScalar method" CssClass="btn btn-danger" />
                        </div>
                    </div>

                    <div class="field-example">
                        <label class="field__label"></label>
                        <div class="field__group">
                            <asp:Button runat="server" ID="CreateDataReaderThrow" Text="CreateDataReader method" CssClass="btn btn-danger" />
                        </div>
                    </div>
                </dwc:GroupBox>

                <dwc:GroupBox runat="server" ID="DisabledSelectionBox" Title="Disabled SelectionBox control">
                    <asp:Literal runat="server" ID="SelectionBoxOutput"></asp:Literal>
                </dwc:GroupBox>

                <dwc:GroupBox runat="server" ID="DropDownExample" Title="Parameter editor example">
                    <asp:Literal ID="AddinSelectorScripts" runat="server"></asp:Literal>
                    <de:AddInSelector runat="server" ID="addinSelector" AddInTypeName="Dynamicweb.Admin.IConfigurableAddInExample" AddInShowNothingSelected="false" />
                    <asp:Literal ID="AddinSelectorLoadScripts" runat="server"></asp:Literal>
                </dwc:GroupBox>

                <dwc:GroupBox runat="server" ID="second_type" Title="Second type of errors/tooltips">
                    <div class="field-example">
                        <label class="field__label">Text</label>
                        <div class="field__group">
                            <input class="std" placeholder="Input text" />
                        </div>
                    </div>

                    <div class="field-example" id="field_3">
                        <label class="field__label">Text</label>
                        <div class="field__group">
                            <input class="std" placeholder="Input without label" />
                            <button class="std-addon" type="button" title="Toogle error" onclick="jQuery('#field_3').toggleClass('field--error')">
                                <i class="md md-warning color-danger"></i>
                            </button>
                            <div class="tooltip-block error">
                                Some error
                            </div>
                        </div>
                    </div>

                    <div class="field-example" id="field_4">
                        <label class="field__label">Some label</label>
                        <div class="field__group">
                            <input class="std" placeholder="Input with buttons" />
                            <button class="std-addon" type="button">
                                <i class="fa fa-file-o color-primary"></i>
                            </button>
                            <button class="std-addon" type="button" title="Toogle error" onclick="jQuery('#field_4').toggleClass('field--error')">
                                <i class="md md-warning color-danger"></i>
                            </button>
                            <div class="tooltip-block error">
                                Some error
                            </div>
                            <div class="tooltip-block info">
                                Some help tooltip
                            </div>
                        </div>
                    </div>
                    
                    <div class="field-example field--error">
                        <label class="field__label">Select</label>
                        <div class="field__group">
                            <select class="std selectpicker">
                                <option>Some select</option>
                            </select>
                            <button class="std-addon" type="button">
                                <i class="fa fa-file-o color-primary"></i>
                            </button>
                        </div>
                    </div>
                </dwc:GroupBox>
            </dwc:CardBody>
        </dwc:Card>
    </form>
</body>
</html>
