<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="InputNumbersDemo.ascx.vb" Inherits="Dynamicweb.Admin.InputNumbersDemo" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<dwc:GroupBox Title="Numbers control demo" runat="server" DoTranslation="False">
    <script>
        const numberCtrlId = "<%=MyTest.ClientID%>";

        function addNumberAddon() {
            let idx = dwGlobal.FieldAddOn.getAll(numberCtrlId).length;
            dwGlobal.FieldAddOn.addToControl(numberCtrlId, { text: idx, click: function () { alert(idx); } });
        }

        function removeLastNumberAddon() {
            const idx = dwGlobal.FieldAddOn.getAll(numberCtrlId).length - 1;
            dwGlobal.FieldAddOn.removeByIndex(numberCtrlId, idx);
        }

        function toggleDisableLastNumberAddon() {
            const idx = dwGlobal.FieldAddOn.getAll(numberCtrlId).length - 1;
            if (idx >= 0) {
                const addon = dwGlobal.FieldAddOn.getByIndex(numberCtrlId, idx);
                dwGlobal.FieldAddOn.disable(addon, !dwGlobal.FieldAddOn.isDisabled(addon));
            }
        }
    </script>

    <dwc:InputNumber runat="server" Label="InputNumber10" Placeholder="10" DoTranslate="False" Info="" />
    <dwc:InputNumber runat="server" Label="InputNumber20" Placeholder="20" DoTranslate="False" Info="test" />
    <dwc:InputNumber runat="server" Label="InputNumber30" Placeholder="30" DoTranslate="False" ValidationMessage="Error" />
    <dwc:InputNumber runat="server" ID="MyTest" Label="InputNumber40" Placeholder="40" DoTranslate="False" Info="test" ValidationMessage="Error" />
    <div class="ctrl-commands-pane">
        <label>Control: </label>
        <button type="button" onclick="addNumberAddon()">Add</button>
        <button type="button" onclick="removeLastNumberAddon()">remove last</button>
        <button type="button" onclick="toggleDisableLastNumberAddon()">disable/enable last</button>
    </div>

    <dwc:InputNumber runat="server" ID="InputNumber1" Label= "Icon Addon with color" Placeholder="30">
        <AddOns>
            <dwc:FieldAddOn Icon="Dollar" IconColor="Marketing" Id="xz"  />
        </AddOns>
    </dwc:InputNumber>

    <dwc:InputNumber runat="server" ID="InputNumber6" Label= "Icon Addon with action" Placeholder="30">
        <AddOns>
            <dwc:FieldAddOn Icon="AddCircleOutline" IconColor="Danger" OnClick="alert(5)"  />
            <dwc:FieldAddOn Icon="Place" IconColor="Default" OnClick="alert(6)"  />
        </AddOns>
    </dwc:InputNumber>

    <dwc:InputNumber runat="server" ID="InputNumber7" Label= "Currency" Placeholder="30">
        <AddOns>
            <dwc:FieldAddOn Text="$"  Title="Dollar" OnClick="alert(7)"  />
            <dwc:FieldAddOn Text="€"  Title="Euro" OnClick="alert(8)"  />
        </AddOns>
    </dwc:InputNumber>

    <dwc:InputNumber runat="server" ID="InputNumber2" Label= "Number with info" Placeholder="30" Info="bla bla text">
        <AddOns>
            <dwc:FieldAddOn Text="Hi"  Title="Hello"  />
            <dwc:FieldAddOn Text="guys"  Title="My friend" OnClick="alert(8)"  />
        </AddOns>
    </dwc:InputNumber>
    <dwc:InputNumber runat="server" ID="InputNumber3" Label= "Number with info" Placeholder="30" ValidationMessage="Only negative number">
        <AddOns>
            <dwc:FieldAddOn Text="Hi"  Title="Hello"  />
            <dwc:FieldAddOn Text="guys"  Title="My friend" OnClick="alert(8)"  />
        </AddOns>
    </dwc:InputNumber>
    <dwc:InputNumber runat="server" ID="InputNumber4" Label= "Number with info" Placeholder="30" ValidationMessage="Only negative number" Info="tests sysys">
        <AddOns>
            <dwc:FieldAddOn Text="Hi"  Title="Hello"  />
            <dwc:FieldAddOn Text="guys"  Title="My friend" OnClick="alert(8)"  />
        </AddOns>
    </dwc:InputNumber>
</dwc:GroupBox>
