<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="InputTextsDemo.ascx.vb" Inherits="Dynamicweb.Admin.InputTextsDemo" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<dwc:GroupBox Title="Text controls demo" runat="server" DoTranslation="False">
    <script>
        const textCtrlId = "MyTest";

        function addTextAddon() {
            let idx = dwGlobal.FieldAddOn.getAll(textCtrlId).length;
            dwGlobal.FieldAddOn.addToControl(textCtrlId, { text: idx, click: function () { alert(idx); } });
        }

        function removeLastTextAddon() {
            const idx = dwGlobal.FieldAddOn.getAll(textCtrlId).length - 1;
            dwGlobal.FieldAddOn.removeByIndex(textCtrlId, idx);
        }

        function toggleDisableLastTextAddon() {
            const idx = dwGlobal.FieldAddOn.getAll(textCtrlId).length - 1;
            if (idx >= 0) {
                const addon = dwGlobal.FieldAddOn.getByIndex(textCtrlId, idx);
                dwGlobal.FieldAddOn.disable(addon, !dwGlobal.FieldAddOn.isDisabled(addon));
            }
        }
    </script>

    <dwc:InputText runat="server" Label="InputText10" Placeholder="text 10" DoTranslate="False" Info="" />
    <dwc:InputText runat="server" Label="InputText20" Placeholder="text 20" DoTranslate="False" Info="test" />
    <dwc:InputText runat="server" Label="InputText30" Placeholder="text 30" DoTranslate="False" ValidationMessage="Error" />
    <dwc:InputText runat="server" ID="MyTest" Label="InputText40" Placeholder="text 40" DoTranslate="False" Info="test" ValidationMessage="Error" />
    <div class="ctrl-commands-pane">
        <label>Control: </label>
        <button type="button" onclick="addTextAddon()">Add</button>
        <button type="button" onclick="removeLastTextAddon()">remove last</button>
        <button type="button" onclick="toggleDisableLastTextAddon()">disable/enable last</button>
    </div>

    <dwc:InputText runat="server" ID="InputText1" Label= "Icon Addon with color" Placeholder="text 30">
        <AddOns>
            <dwc:FieldAddOn Icon="Dollar" IconColor="Marketing" Id="xz"  />
        </AddOns>
    </dwc:InputText>

    <dwc:InputText runat="server" ID="InputText6" Label= "Icon Addon with action" Placeholder="text 30">
        <AddOns>
            <dwc:FieldAddOn Icon="AddCircleOutline" IconColor="Danger" OnClick="alert(5)"  />
            <dwc:FieldAddOn Icon="Place" IconColor="Default" OnClick="alert(6)"  />
        </AddOns>
    </dwc:InputText>

    <dwc:InputText runat="server" ID="InputText7" Label= "Currency" Placeholder="30">
        <AddOns>
            <dwc:FieldAddOn Icon="AddCircleOutline" IconColor="Danger" OnClick="alert(5)"  />
            <dwc:FieldAddOn Text="€"  Title="Euro" OnClick="alert(8)"  />
        </AddOns>
    </dwc:InputText>

    <dwc:InputText runat="server" ID="InputText2" Label= "Text with info" Placeholder="30" Info="bla bla text">
        <AddOns>
            <dwc:FieldAddOn Text="Hi"  Title="Hello"  />
            <dwc:FieldAddOn Text="guys"  Title="My friend" OnClick="alert(8)"  />
        </AddOns>
    </dwc:InputText>
    <dwc:InputText runat="server" ID="InputText3" Label= "Text with info" Placeholder="30" ValidationMessage="Hey">
        <AddOns>
            <dwc:FieldAddOn Text="Hi"  Title="Hello"  />
            <dwc:FieldAddOn Text="guys"  Title="My friend" OnClick="alert(8)"  />
        </AddOns>
    </dwc:InputText>
    <dwc:InputText runat="server" ID="InputText4" Label= "Text with info" Placeholder="30" ValidationMessage="Only key" Info="tests sysys">
        <AddOns>
            <dwc:FieldAddOn Text="Hi"  Title="Hello"  />
            <dwc:FieldAddOn Text="guys"  Title="My friend" OnClick="alert(8)"  />
        </AddOns>
    </dwc:InputText>
</dwc:GroupBox>

