<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomFieldOptions_List.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomFieldOptions_List" %>

<%@ Register TagPrefix="dw" Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/images/layermenu.js" />
        </Items>
    </dw:ControlResources>
    <script>
        function TryAddMultipleOptions() {
            var multipleOptionsText = document.getElementById('MultipleOptionsInput').value;
            if (multipleOptionsText.trim().length < 1) {
                <%=GetEmptyOptinosTextConfirmation()%>
            } else if(multipleOptionsText.indexOf(",") != -1) {
                <%=GetMultipleCreateValidateionConfirmation()%>
            } else {
                AddMultipleOptions(false)
            }
        }

        function AddMultipleOptions(replaceCommas) {
            if (replaceCommas) {
                var multipleOptionsElement = document.getElementById('MultipleOptionsInput');
                multipleOptionsElement.value = multipleOptionsElement.value.replace(/,/g, ' ');
            }
            var cmd = document.getElementById('cmdSubmit');
            cmd.value = "AddMultipleOptions";
            cmd.click();
        }

        function deleteOptions() {            
            document.getElementById('deletedOptionIds').value = List.getSelectedRows('FieldOptionsList').map(function (selectedOptionRow) { { return selectedOptionRow.id; } }).join();
            var cmd = document.getElementById('cmdSubmit');
            cmd.value = "delete";
            cmd.click();
        }
    </script>
</head>
<body class="screen-container">
    <div class="card">
        <form id="form1" runat="server" enableviewstate="false">
            <dw:Toolbar ID="Toolbar" runat="server">
                <dw:ToolbarButton ID="cmdCancel" runat="server" Divide="None" Image="NoImage" Icon="Cancel" Text="Close" ShowWait="True" />
                <dw:ToolbarButton ID="cmdAddNew" runat="server" Divide="None" Image="NoImage" Icon="PlusSquare" Text="Add new option" ShowWait="True" />
                <dw:ToolbarButton ID="cmdDelete" Icon="Remove" Text="Delete" runat="server" Disabled="true" />
                <dw:ToolbarButton ID="cmdAddMultiple" Icon="ObjectGroup" Text="Add multiple options" runat="server" />
            </dw:Toolbar>   
            <input type="hidden" name="Ids" id="deletedOptionIds" />
            <dw:List ID="FieldOptionsList" runat="server" Title="" ShowTitle="false" StretchContent="false" PageSize="500" AllowMultiSelect="true">
                <Filters>
                    <dw:ListAutomatedSearchFilter runat="server" ID="TextFilter" Priority="1" WaterMarkText="" />
                    <dw:ListDropDownListFilter ID="PageSizeFilter" Width="80" Label="Paging size" AutoPostBack="true" Priority="2" runat="server">
                        <Items>
                            <dw:ListFilterOption Text="50" Value="50" DoTranslate="false" />
                            <dw:ListFilterOption Text="100" Value="100" DoTranslate="false" />
                            <dw:ListFilterOption Text="200" Value="200" DoTranslate="false" />
                            <dw:ListFilterOption Text="500" Value="500" DoTranslate="false" Selected="true" />
                            <dw:ListFilterOption Text="1000" Value="1000" DoTranslate="false" />
                        </Items>
                    </dw:ListDropDownListFilter>
                </Filters>
                <Columns>
                    <dw:ListColumn ID="colName" runat="server" Name="Name" EnableSorting="true" />
                    <dw:ListColumn ID="colValue" runat="server" Name="Value" EnableSorting="true" Width="300" />
                    <dw:ListColumn ID="colDefault" runat="server" Name="Default" EnableSorting="true" Width="50" ItemAlign="Center" HeaderAlign="Center" />
                </Columns>
            </dw:List>            
            <input type="submit" id="cmdSubmit" name="cmd" value="Submit" style="display: none" />
            <dw:Dialog runat="server" ID="CreateMultipleOptionsDialog" Title="Add multiple options" ShowOkButton="true" ShowCancelButton="true"
                    OkAction="TryAddMultipleOptions()" CancelAction="dialog.hide('CreateMultipleOptionsDialog');document.getElementById('MultipleOptionsInput').value = '';">
                <dw:GroupBox ID="GroupBox2" runat="server" DoTranslation="True" Title="Options">
                    <textarea name="MultipleOptionsInput" id="MultipleOptionsInput" style="width: 490px;" rows="6"></textarea>
                    <dwc:CheckBox runat="server" ID="UpdateExisting" Label="Update existing options" Indent="false" />
                </dw:GroupBox>
                <dw:GroupBox ID="GroupBox1" runat="server" DoTranslation="True" Title="Eksempel">
                    <textarea readonly="readonly" style="width: 490px; resize: none;" rows="3" disabled="disabled">Name;Value
Name2
Name3;Value3</textarea>
                </dw:GroupBox>
            </dw:Dialog>
        </form>
    </div>
</body>
</html>
