<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="SelectorsDemo.ascx.vb" Inherits="Dynamicweb.Admin.InputTextsDemo" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<link rel="stylesheet" href="/Admin/Resources/vendors/slim-select/slimselect.min.css" />
<script src="/Admin/Resources/vendors/slim-select/slimselect.min.js"></script>
<script src="/Admin/Resources/js/layout/dwselector.js"></script>

<script>
    window.addEventListener("load", () => {
        console.log("dsfdsf");
        document.querySelectorAll(".selector-ini").forEach(function (el) {
            const options = el.dataset;
            const opts = Object.assign({ container: el }, options);
            dwGlobal.createSelector(opts);
        });

        dwGlobal.createSelector({
            select: document.getElementById("Country1")
        });        
    })
</script>

<dwc:GroupBox Title="Select picker with slimselect.js demo" runat="server" DoTranslation="False">
    <dwc:SelectPicker runat="server" class="selector-ini" Label="Areas" Datasource="/admin/api/navigators/Content" />
    <dwc:SelectPicker runat="server" class="selector-ini" Label="Files" Datasource="/admin/api/navigators/Files" />
    <dwc:SelectPicker runat="server" class="selector-ini" Label="Pim" Datasource="/admin/api/navigators/PIM" />
    <dwc:SelectPicker runat="server" ID="Country1" ClientIDMode="Static" class="zzz-ini" Label="SelectPicker:Country" data-dataobject="Denmark">
        <asp:ListItem Text="Afghanistan" Value="Afghanistan" />
        <asp:ListItem Text="Albania" Value="Albania" />
        <asp:ListItem Text="Algeria" Value="Algeria" />
        <asp:ListItem Text="Andorra" Value="Andorra" />
        <asp:ListItem Text="Angola" Value="Angola" />
        <asp:ListItem Text="Antigua and Barbuda" Value="Antigua and Barbuda" />
        <asp:ListItem Text="Argentina" Value="Argentina" />
        <asp:ListItem Text="Armenia" Value="Armenia" />
        <asp:ListItem Text="Australia" Value="Australia" />
        <asp:ListItem Text="Austria" Value="Austria" />
        <asp:ListItem Text="Azerbaijan" Value="Azerbaijan" />
        <asp:ListItem Text="Bahamas" Value="Bahamas" />
        <asp:ListItem Text="Bahrain" Value="Bahrain" />
        <asp:ListItem Text="Bangladesh" Value="Bangladesh" />
        <asp:ListItem Text="Barbados" Value="Barbados" />
        <asp:ListItem Text="Belarus" Value="Belarus" />
        <asp:ListItem Text="Belgium" Value="Belgium" />
        <asp:ListItem Text="Belize" Value="Belize" />
        <asp:ListItem Text="Benin" Value="Benin" />
        <asp:ListItem Text="Bhutan" Value="Bhutan" />
        <asp:ListItem Text="Bolivia" Value="Bolivia" />
        <asp:ListItem Text="Bosnia and Herzegovina" Value="Bosnia and Herzegovina" />
        <asp:ListItem Text="Botswana" Value="Botswana" />
        <asp:ListItem Text="Brazil" Value="Brazil" />
        <asp:ListItem Text="Brunei" Value="Brunei" />
        <asp:ListItem Text="Bulgaria" Value="Bulgaria" />
        <asp:ListItem Text="Burkina Faso" Value="Burkina Faso" />
        <asp:ListItem Text="Burundi" Value="Burundi" />
        <asp:ListItem Text="Cambodia" Value="Cambodia" />
        <asp:ListItem Text="Cameroon" Value="Cameroon" />
        <asp:ListItem Text="Canada" Value="Canada" />
        <asp:ListItem Text="Cape Verde" Value="Cape Verde" />
        <asp:ListItem Text="Central African Republic" Value="Central African Republic" />
        <asp:ListItem Text="Chad" Value="Chad" />
        <asp:ListItem Text="Chile" Value="Chile" />
        <asp:ListItem Text="China" Value="China" />
        <asp:ListItem Text="Colombia" Value="Colombia" />
        <asp:ListItem Text="Comoros" Value="Comoros" />
        <asp:ListItem Text="Congo, Democratic Republic of the" Value="Congo, Democratic Republic of the" />
        <asp:ListItem Text="Congo, Republic of the" Value="Congo, Republic of the" />
        <asp:ListItem Text="Costa Rica" Value="Costa Rica" />
        <asp:ListItem Text="Côte d'Ivoire (Ivory Coast)" Value="Côte d'Ivoire (Ivory Coast)" />
        <asp:ListItem Text="Croatia" Value="Croatia" />
        <asp:ListItem Text="Cuba" Value="Cuba" />
        <asp:ListItem Text="Cyprus" Value="Cyprus" />
        <asp:ListItem Text="Czech Republic (Czechia)5" Value="Czech Republic (Czechia)5" />
        <asp:ListItem Text="Denmark" Value="Denmark" />
        <asp:ListItem Text="Djibouti" Value="Djibouti" />
        <asp:ListItem Text="Dominica" Value="Dominica" />
        <asp:ListItem Text="Dominican Republic" Value="Dominican Republic" />
        <asp:ListItem Text="East Timor" Value="East Timor" />
        <asp:ListItem Text="Ecuador" Value="Ecuador" />
        <asp:ListItem Text="Egypt" Value="Egypt" />
        <asp:ListItem Text="El Salvador" Value="El Salvador" />
        <asp:ListItem Text="England6" Value="England6" />
        <asp:ListItem Text="Equatorial Guinea" Value="Equatorial Guinea" />
        <asp:ListItem Text="Eritrea" Value="Eritrea" />
        <asp:ListItem Text="Estonia" Value="Estonia" />
        <asp:ListItem Text="Eswatini (Swaziland)7" Value="Eswatini (Swaziland)7" />
        <asp:ListItem Text="Ethiopia" Value="Ethiopia" />
    </dwc:SelectPicker>
    <dwc:SelectPicker runat="server" ID="SelectPicker1" ClientIDMode="Static" Label="SelectPicker:Country" data-dataobject="Denmark">
        <asp:ListItem Text="Afghanistan" Value="Afghanistan" />
        <asp:ListItem Text="Albania" Value="Albania" />
        <asp:ListItem Text="Algeria" Value="Algeria" />
        <asp:ListItem Text="Andorra" Value="Andorra" />
        <asp:ListItem Text="Angola" Value="Angola" />
        <asp:ListItem Text="Antigua and Barbuda" Value="Antigua and Barbuda" />
        <asp:ListItem Text="Argentina" Value="Argentina" />
        <asp:ListItem Text="Armenia" Value="Armenia" />
        <asp:ListItem Text="Australia" Value="Australia" />
        <asp:ListItem Text="Austria" Value="Austria" />
        <asp:ListItem Text="Azerbaijan" Value="Azerbaijan" />
        <asp:ListItem Text="Bahamas" Value="Bahamas" />
        <asp:ListItem Text="Bahrain" Value="Bahrain" />
        <asp:ListItem Text="Bangladesh" Value="Bangladesh" />
        <asp:ListItem Text="Barbados" Value="Barbados" />
        <asp:ListItem Text="Belarus" Value="Belarus" />
        <asp:ListItem Text="Belgium" Value="Belgium" />
        <asp:ListItem Text="Belize" Value="Belize" />
        <asp:ListItem Text="Benin" Value="Benin" />
        <asp:ListItem Text="Bhutan" Value="Bhutan" />
        <asp:ListItem Text="Bolivia" Value="Bolivia" />
        <asp:ListItem Text="Bosnia and Herzegovina" Value="Bosnia and Herzegovina" />
        <asp:ListItem Text="Botswana" Value="Botswana" />
        <asp:ListItem Text="Brazil" Value="Brazil" />
        <asp:ListItem Text="Brunei" Value="Brunei" />
        <asp:ListItem Text="Bulgaria" Value="Bulgaria" />
        <asp:ListItem Text="Burkina Faso" Value="Burkina Faso" />
        <asp:ListItem Text="Burundi" Value="Burundi" />
        <asp:ListItem Text="Cambodia" Value="Cambodia" />
        <asp:ListItem Text="Cameroon" Value="Cameroon" />
        <asp:ListItem Text="Canada" Value="Canada" />
        <asp:ListItem Text="Cape Verde" Value="Cape Verde" />
        <asp:ListItem Text="Central African Republic" Value="Central African Republic" />
        <asp:ListItem Text="Chad" Value="Chad" />
        <asp:ListItem Text="Chile" Value="Chile" />
        <asp:ListItem Text="China" Value="China" />
        <asp:ListItem Text="Colombia" Value="Colombia" />
        <asp:ListItem Text="Comoros" Value="Comoros" />
        <asp:ListItem Text="Congo, Democratic Republic of the" Value="Congo, Democratic Republic of the" />
        <asp:ListItem Text="Congo, Republic of the" Value="Congo, Republic of the" />
        <asp:ListItem Text="Costa Rica" Value="Costa Rica" />
        <asp:ListItem Text="Côte d'Ivoire (Ivory Coast)" Value="Côte d'Ivoire (Ivory Coast)" />
        <asp:ListItem Text="Croatia" Value="Croatia" />
        <asp:ListItem Text="Cuba" Value="Cuba" />
        <asp:ListItem Text="Cyprus" Value="Cyprus" />
        <asp:ListItem Text="Czech Republic (Czechia)5" Value="Czech Republic (Czechia)5" />
        <asp:ListItem Text="Denmark" Value="Denmark" />
        <asp:ListItem Text="Djibouti" Value="Djibouti" />
        <asp:ListItem Text="Dominica" Value="Dominica" />
        <asp:ListItem Text="Dominican Republic" Value="Dominican Republic" />
        <asp:ListItem Text="East Timor" Value="East Timor" />
        <asp:ListItem Text="Ecuador" Value="Ecuador" />
        <asp:ListItem Text="Egypt" Value="Egypt" />
        <asp:ListItem Text="El Salvador" Value="El Salvador" />
        <asp:ListItem Text="England6" Value="England6" />
        <asp:ListItem Text="Equatorial Guinea" Value="Equatorial Guinea" />
        <asp:ListItem Text="Eritrea" Value="Eritrea" />
        <asp:ListItem Text="Estonia" Value="Estonia" />
        <asp:ListItem Text="Eswatini (Swaziland)7" Value="Eswatini (Swaziland)7" />
        <asp:ListItem Text="Ethiopia" Value="Ethiopia" />
    </dwc:SelectPicker>

    <div class="dw-ctrl select-picker-ctrl form-group selector">
        <label class="control-label">Country</label>
        <div class="form-group-input">
            <asp:DropDownList runat="server" Label="Country" ID="CountrySingleSelector" ClientIDMode="Static" CssClass="zzz aaa">
                <asp:ListItem Text="Afghanistan" Value="Afghanistan" />
                <asp:ListItem Text="Albania" Value="Albania" />
                <asp:ListItem Text="Algeria" Value="Algeria" />
                <asp:ListItem Text="Andorra" Value="Andorra" />
                <asp:ListItem Text="Angola" Value="Angola" />
                <asp:ListItem Text="Antigua and Barbuda" Value="Antigua and Barbuda" />
                <asp:ListItem Text="Argentina" Value="Argentina" />
                <asp:ListItem Text="Armenia" Value="Armenia" />
                <asp:ListItem Text="Australia" Value="Australia" />
                <asp:ListItem Text="Austria" Value="Austria" />
                <asp:ListItem Text="Azerbaijan" Value="Azerbaijan" />
                <asp:ListItem Text="Bahamas" Value="Bahamas" />
                <asp:ListItem Text="Bahrain" Value="Bahrain" />
                <asp:ListItem Text="Bangladesh" Value="Bangladesh" />
                <asp:ListItem Text="Barbados" Value="Barbados" />
                <asp:ListItem Text="Belarus" Value="Belarus" />
                <asp:ListItem Text="Belgium" Value="Belgium" />
                <asp:ListItem Text="Belize" Value="Belize" />
                <asp:ListItem Text="Benin" Value="Benin" />
                <asp:ListItem Text="Bhutan" Value="Bhutan" />
                <asp:ListItem Text="Bolivia" Value="Bolivia" />
                <asp:ListItem Text="Bosnia and Herzegovina" Value="Bosnia and Herzegovina" />
                <asp:ListItem Text="Botswana" Value="Botswana" />
                <asp:ListItem Text="Brazil" Value="Brazil" />
                <asp:ListItem Text="Brunei" Value="Brunei" />
                <asp:ListItem Text="Bulgaria" Value="Bulgaria" />
                <asp:ListItem Text="Burkina Faso" Value="Burkina Faso" />
                <asp:ListItem Text="Burundi" Value="Burundi" />
                <asp:ListItem Text="Cambodia" Value="Cambodia" />
                <asp:ListItem Text="Cameroon" Value="Cameroon" />
                <asp:ListItem Text="Canada" Value="Canada" />
                <asp:ListItem Text="Cape Verde" Value="Cape Verde" />
                <asp:ListItem Text="Central African Republic" Value="Central African Republic" />
                <asp:ListItem Text="Chad" Value="Chad" />
                <asp:ListItem Text="Chile" Value="Chile" />
                <asp:ListItem Text="China" Value="China" />
                <asp:ListItem Text="Colombia" Value="Colombia" />
                <asp:ListItem Text="Comoros" Value="Comoros" />
                <asp:ListItem Text="Congo, Democratic Republic of the" Value="Congo, Democratic Republic of the" />
                <asp:ListItem Text="Congo, Republic of the" Value="Congo, Republic of the" />
                <asp:ListItem Text="Costa Rica" Value="Costa Rica" />
                <asp:ListItem Text="Côte d'Ivoire (Ivory Coast)" Value="Côte d'Ivoire (Ivory Coast)" />
                <asp:ListItem Text="Croatia" Value="Croatia" />
                <asp:ListItem Text="Cuba" Value="Cuba" />
                <asp:ListItem Text="Cyprus" Value="Cyprus" />
                <asp:ListItem Text="Czech Republic (Czechia)5" Value="Czech Republic (Czechia)5" />
                <asp:ListItem Text="Denmark" Value="Denmark" />
                <asp:ListItem Text="Djibouti" Value="Djibouti" />
                <asp:ListItem Text="Dominica" Value="Dominica" />
                <asp:ListItem Text="Dominican Republic" Value="Dominican Republic" />
                <asp:ListItem Text="East Timor" Value="East Timor" />
                <asp:ListItem Text="Ecuador" Value="Ecuador" />
                <asp:ListItem Text="Egypt" Value="Egypt" />
                <asp:ListItem Text="El Salvador" Value="El Salvador" />
                <asp:ListItem Text="England6" Value="England6" />
                <asp:ListItem Text="Equatorial Guinea" Value="Equatorial Guinea" />
                <asp:ListItem Text="Eritrea" Value="Eritrea" />
                <asp:ListItem Text="Estonia" Value="Estonia" />
                <asp:ListItem Text="Eswatini (Swaziland)7" Value="Eswatini (Swaziland)7" />
                <asp:ListItem Text="Ethiopia" Value="Ethiopia" />
                <asp:ListItem Text="Federated States of Micronesia" Value="Federated States of Micronesia" />
                <asp:ListItem Text="Fiji" Value="Fiji" />
                <asp:ListItem Text="Finland" Value="Finland" />
                <asp:ListItem Text="France" Value="France" />
                <asp:ListItem Text="French Guiana" Value="French Guiana" />
                <asp:ListItem Text="Gabon" Value="Gabon" />
                <asp:ListItem Text="Gambia" Value="Gambia" />
                <asp:ListItem Text="Georgia" Value="Georgia" />
                <asp:ListItem Text="Germany" Value="Germany" />
                <asp:ListItem Text="Ghana" Value="Ghana" />
                <asp:ListItem Text="Greece" Value="Greece" />
                <asp:ListItem Text="Grenada" Value="Grenada" />
                <asp:ListItem Text="Guatemala" Value="Guatemala" />
                <asp:ListItem Text="Guinea" Value="Guinea" />
                <asp:ListItem Text="Guinea-Bissau" Value="Guinea-Bissau" />
                <asp:ListItem Text="Guyana" Value="Guyana" />
                <asp:ListItem Text="Haiti" Value="Haiti" />
                <asp:ListItem Text="Honduras" Value="Honduras" />
                <asp:ListItem Text="Hungary" Value="Hungary" />
                <asp:ListItem Text="Iceland" Value="Iceland" />
                <asp:ListItem Text="India" Value="India" />
                <asp:ListItem Text="Indonesia" Value="Indonesia" />
                <asp:ListItem Text="Iran" Value="Iran" />
                <asp:ListItem Text="Iraq" Value="Iraq" />
                <asp:ListItem Text="Ireland" Value="Ireland" />
                <asp:ListItem Text="Israel" Value="Israel" />
                <asp:ListItem Text="Italy" Value="Italy" />
                <asp:ListItem Text="Jamaica" Value="Jamaica" />
                <asp:ListItem Text="Japan" Value="Japan" />
                <asp:ListItem Text="Jordan" Value="Jordan" />
                <asp:ListItem Text="Kazakhstan" Value="Kazakhstan" />
                <asp:ListItem Text="Kenya" Value="Kenya" />
                <asp:ListItem Text="Kiribati" Value="Kiribati" />
                <asp:ListItem Text="Kosovo" Value="Kosovo" />
                <asp:ListItem Text="Kuwait" Value="Kuwait" />
                <asp:ListItem Text="Kyrgyzstan" Value="Kyrgyzstan" />
                <asp:ListItem Text="Laos" Value="Laos" />
                <asp:ListItem Text="Latvia" Value="Latvia" />
                <asp:ListItem Text="Lebanon" Value="Lebanon" />
                <asp:ListItem Text="Lesotho" Value="Lesotho" />
                <asp:ListItem Text="Liberia" Value="Liberia" />
                <asp:ListItem Text="Libya" Value="Libya" />
                <asp:ListItem Text="Liechtenstein" Value="Liechtenstein" />
                <asp:ListItem Text="Lithuania" Value="Lithuania" />
                <asp:ListItem Text="Luxembourg" Value="Luxembourg" />
                <asp:ListItem Text="Madagascar" Value="Madagascar" />
                <asp:ListItem Text="Malawi" Value="Malawi" />
                <asp:ListItem Text="Malaysia" Value="Malaysia" />
                <asp:ListItem Text="Maldives" Value="Maldives" />
                <asp:ListItem Text="Mali" Value="Mali" />
                <asp:ListItem Text="Malta" Value="Malta" />
                <asp:ListItem Text="Marshall Islands" Value="Marshall Islands" />
                <asp:ListItem Text="Mauritania" Value="Mauritania" />
                <asp:ListItem Text="Mauritius" Value="Mauritius" />
                <asp:ListItem Text="Mexico" Value="Mexico" />
                <asp:ListItem Text="Moldova" Value="Moldova" />
                <asp:ListItem Text="Monaco" Value="Monaco" />
                <asp:ListItem Text="Mongolia" Value="Mongolia" />
                <asp:ListItem Text="Montenegro" Value="Montenegro" />
                <asp:ListItem Text="Morocco" Value="Morocco" />
                <asp:ListItem Text="Mozambique" Value="Mozambique" />
                <asp:ListItem Text="Myanmar (Burma)" Value="Myanmar (Burma)" />
                <asp:ListItem Text="Namibia" Value="Namibia" />
                <asp:ListItem Text="Nauru" Value="Nauru" />
                <asp:ListItem Text="Nepal" Value="Nepal" />
                <asp:ListItem Text="Netherlands" Value="Netherlands" />
                <asp:ListItem Text="New Zealand" Value="New Zealand" />
                <asp:ListItem Text="Nicaragua" Value="Nicaragua" />
                <asp:ListItem Text="Niger" Value="Niger" />
                <asp:ListItem Text="Nigeria" Value="Nigeria" />
                <asp:ListItem Text="North Korea" Value="North Korea" />
                <asp:ListItem Text="North Macedonia (Macedonia)13" Value="North Macedonia (Macedonia)13" />
                <asp:ListItem Text="Northern Ireland14" Value="Northern Ireland14" />
                <asp:ListItem Text="Norway" Value="Norway" />
                <asp:ListItem Text="Oman" Value="Oman" />
                <asp:ListItem Text="Pakistan" Value="Pakistan" />
                <asp:ListItem Text="Palau" Value="Palau" />
                <asp:ListItem Text="Panama" Value="Panama" />
                <asp:ListItem Text="Papua New Guinea" Value="Papua New Guinea" />
                <asp:ListItem Text="Paraguay" Value="Paraguay" />
                <asp:ListItem Text="Peru" Value="Peru" />
                <asp:ListItem Text="Philippines" Value="Philippines" />
                <asp:ListItem Text="Poland" Value="Poland" />
                <asp:ListItem Text="Portugal" Value="Portugal" />
                <asp:ListItem Text="Qatar" Value="Qatar" />
                <asp:ListItem Text="Romania" Value="Romania" />
                <asp:ListItem Text="Russia" Value="Russia" />
                <asp:ListItem Text="Rwanda" Value="Rwanda" />
                <asp:ListItem Text="Saint Kitts and Nevis" Value="Saint Kitts and Nevis" />
                <asp:ListItem Text="Saint Lucia" Value="Saint Lucia" />
                <asp:ListItem Text="Saint Vincent and the Grenadines" Value="Saint Vincent and the Grenadines" />
                <asp:ListItem Text="Samoa" Value="Samoa" />
                <asp:ListItem Text="San Marino" Value="San Marino" />
                <asp:ListItem Text="Sao Tome and Principe" Value="Sao Tome and Principe" />
                <asp:ListItem Text="Saudi Arabia" Value="Saudi Arabia" />
                <asp:ListItem Text="Scotland15" Value="Scotland15" />
                <asp:ListItem Text="Senegal" Value="Senegal" />
                <asp:ListItem Text="Serbia" Value="Serbia" />
                <asp:ListItem Text="Seychelles" Value="Seychelles" />
                <asp:ListItem Text="Sierra Leone" Value="Sierra Leone" />
                <asp:ListItem Text="Singapore" Value="Singapore" />
                <asp:ListItem Text="Slovakia" Value="Slovakia" />
                <asp:ListItem Text="Slovenia" Value="Slovenia" />
                <asp:ListItem Text="Solomon Islands" Value="Solomon Islands" />
                <asp:ListItem Text="Somalia" Value="Somalia" />
                <asp:ListItem Text="South Africa" Value="South Africa" />
                <asp:ListItem Text="South Korea" Value="South Korea" />
                <asp:ListItem Text="South Sudan" Value="South Sudan" />
                <asp:ListItem Text="Spain" Value="Spain" />
                <asp:ListItem Text="Sri Lanka" Value="Sri Lanka" />
                <asp:ListItem Text="Sudan" Value="Sudan" />
                <asp:ListItem Text="Suriname" Value="Suriname" />
                <asp:ListItem Text="Sweden" Value="Sweden" />
                <asp:ListItem Text="Switzerland" Value="Switzerland" />
                <asp:ListItem Text="Syria" Value="Syria" />
                <asp:ListItem Text="Taiwan18" Value="Taiwan18" />
                <asp:ListItem Text="Tajikistan" Value="Tajikistan" />
                <asp:ListItem Text="Tanzania" Value="Tanzania" />
                <asp:ListItem Text="Thailand" Value="Thailand" />
                <asp:ListItem Text="Togo" Value="Togo" />
                <asp:ListItem Text="Tonga" Value="Tonga" />
                <asp:ListItem Text="Trinidad and Tobago" Value="Trinidad and Tobago" />
                <asp:ListItem Text="Tunisia" Value="Tunisia" />
                <asp:ListItem Text="Turkey" Value="Turkey" />
                <asp:ListItem Text="Turkmenistan" Value="Turkmenistan" />
                <asp:ListItem Text="Tuvalu" Value="Tuvalu" />
                <asp:ListItem Text="Uganda" Value="Uganda" />
                <asp:ListItem Text="Ukraine" Value="Ukraine" />
                <asp:ListItem Text="United Arab Emirates" Value="United Arab Emirates" />
                <asp:ListItem Text="United Kingdom" Value="United Kingdom" />
                <asp:ListItem Text="United States" Value="United States" />
                <asp:ListItem Text="Uruguay" Value="Uruguay" />
                <asp:ListItem Text="Uzbekistan" Value="Uzbekistan" />
                <asp:ListItem Text="Vanuatu" Value="Vanuatu" />
                <asp:ListItem Text="Vatican City" Value="Vatican City" />
                <asp:ListItem Text="Venezuela" Value="Venezuela" />
            </asp:DropDownList>
        </div>
    </div>
</dwc:GroupBox>

