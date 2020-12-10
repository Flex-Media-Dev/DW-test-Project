<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="License_Login.aspx.vb" Inherits="Dynamicweb.Admin.License_Login" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>Setup Dynamicweb
    </title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="false" IncludeScriptaculous="false" runat="server" CombineOutput="false" />
    <link href="../DefaultNewUI.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        html, body {
            overflow: auto;
        }

        body {
            overflow-y: scroll;
        }

        h1 {
            margin-top: 10px;
        }

        #header {
            overflow: auto;
            width: 100%;
        }

        #logocontainer {
            text-align: right;
            margin-top: 20px;
            margin-bottom: 20px;
            float: right;
        }

        #numbers {
            float: left;
            margin-top: 20px;
            margin-bottom: 20px;
        }

        .number {
            border: 1px solid #a1a1a1;
            width: 30px;
            height: 30px;
            display: inline-block;
            border-radius: 15px;
            font-family: Ubuntu, sans-serif, Arial;
            font-size: 20px;
            font-weight: bold;
            text-indent: 10px;
            line-height: 30px;
            color: #777777;
            margin-left: 5px;
        }

            .number.active {
                background-color: #0085CA;
                color: white;
            }

        .step {
            display: none;
        }

        #step1 {
            display: inherit;
        }

        #box {
            padding-left: 45px;
            padding-right: 45px;
            margin-top: 2%;
            margin-bottom: 2%;
        }

        #boxinner {
            text-align: left;
            width: 750px;
        }

        .buttonContainer {
            text-align: right;
        }

            .buttonContainer .back {
                color: #bfbfbf;
                margin-right: 30px;
                border: none;
                background-color: transparent;
            }

        small {
            color: #a1a1a1;
        }

        label > small {
            padding-left: 23px;
        }

        input[type=text], input[type=password] {
            width: 250px;
        }

        #waitingPlaceholder {
            margin-top: 30%;
            margin-bottom: auto;
        }

        #weecommerce {
            padding-left: 22px;
        }

        .items-list {
        }

        #TrialErrorMessage{
            color: red;
        }
    </style>
    <script type="text/javascript">
        function setCustomerNumber(value) {
            setValue(value, 'customerNumber', '<%= goToLicenseButton.ClientID %>')
         }

         function setSolutionId(value) {
             setValue(value, 'solutionId', '<%= goToTypeButton.ClientID %>')
         }

        function setEnvironmentType(value)
        {
            setValue(value, 'installationTypeId', '<%= registerInstallationBtn.ClientID %>')
        }

        function setTrialType(value)
        {
            setValue(value, 'trialTypeId', '<%= RegisterTrialBtn.ClientID %>')
        }

        function setValue(value, inputElementId, nextButtonId) {
            document.getElementById(inputElementId).value = value;

            if (document.getElementById(inputElementId).value && document.getElementById(inputElementId).value != "") {
                document.getElementById(nextButtonId).disabled = false;
            }
        }
    </script>
</head>
<body>
    <form id="setupForm" runat="server" enableviewstate="false">
        <input type="hidden" name="customerNumber" id="customerNumber" runat="server" />
        <input type="hidden" name="solutionId" id="solutionId" runat="server" />
        <input type="hidden" name="installationTypeId" id="installationTypeId" runat="server" />
        <input type="hidden" name="currentStep" id="currentStep" runat="server" value="1" />

        <div id="container">
            <div id="box">
                <div id="boxinner">

                    <div id="header">
                        <div id="numbers">
                            <span class="number <%=If(isStepActive(1), "active", "") %>" id="stepNum1">1</span>
                            <span class="number <%=If(isStepActive(2), "active", "") %>" id="stepNum2">2</span>
                            <span class="number <%=If(isStepActive(3), "active", "") %>" id="stepNum3">3</span>
                            <span class="number <%=If(isStepActive(4), "active", "") %>" id="stepNum4">4</span>
                            <span class="number <%=If(isStepActive(5), "active", "") %>" id="stepNum5">5</span>
                            <span class="number <%=If(isStepActive(6), "active", "") %>" id="stepNum6">6</span>
                        </div>

                        <div id="logocontainer">
                            <img src="../../Resources/img/DW_logo_200.png" style="width: 200px;" alt="Dynamicweb 9" />
                        </div>
                    </div>

                    <asp:Panel ID="step1" CssClass="step" runat="server">
                        <h1>1. Welcome to license configuration</h1>
                        <h2>Congratulations with your Dynamicweb!</h2>
                        <div>
                            <p>
                            This guide will help you install your license. Follow the steps to download and install your valid license. This requires that you already have a license from Dynamicweb.
                            </p>
                            <p>
                            You can read more about how to setup your license and how it affects you <a href="https://doc.dynamicweb.com/downloads/releases/upgrading/new-license-model-faq">here</a>
                            </p>
                        </div>

                        <dw:InfoBar ID="TrialErrorMessage" runat="server" Type="Error" Message="A trial has already been setup for this installation." Visible="False"></dw:InfoBar>

                        <div class="buttonContainer">
                            <asp:Button ID="debugLicense" CssClass="button orange" runat="server" OnClick="setupDebugLicense_Click" Text="Debug license" Visible="False"></asp:Button>
                            <asp:Button CssClass="button orange" runat="server" OnClick="setupLicense_Click" Text="Install license"></asp:Button>
                            <asp:Button ID="setupTrial" CssClass="button orange" runat="server" OnClick="setupTrial_Click" Text="Get a free trial" />
                        </div>
                    </asp:Panel>

                    <asp:Panel ID="step2" CssClass="step" runat="server" DefaultButton="logonButton">
                        <h1>2. Login</h1>
                        <div id="filessetupoptionsDone">
                            <h2>Please logon</h2>
                            <p>
                                Use your Dynamicweb ID (Your engage and doc website logon as provided by Dynamicweb) to get access to your valid licenses.
                                This will lookup all licenses ordered by the Dynamicweb partner associated with your login.
                            </p>
                            <p>
                                If you do not have a valid login, go back and install a trial and contact Dynamicweb at support@dynamicweb.com to get a login and a valid license.
                            </p>
                        </div>
                        <div id="filessetupoptions">
                            <dwc:InputText runat="server" title="Brugernavn" Placeholder="Brugernavn" Value="" ID="UsernameTextBox" Name="Username" />
                            <br />
                            <br />
                            <dwc:InputText runat="server" Password="true" title="Kodeord" Placeholder="Kodeord" Value="" ID="PasswordTextBox" Name="Password" MaxLength="1000" />
                            <br />
                            <dw:TranslateLabel ID="ErrorMessage" runat="server" Text="Username or password is incorrect" Visible="False" />
                        </div>

                        <div class="buttonContainer">
                            <asp:Button runat="server" ID="logonBackButton" CssClass="back" OnClick="logonBackButton_Click" Text="Back" />
                            <asp:Button runat="server" ID="logonButton" Text="Logon" OnClick="logonButton_Click" CssClass="button orange" />
                        </div>
                    </asp:Panel>

                    <asp:Panel ID="step3" CssClass="step" runat="server">
                        <h1>3. Pick a customer</h1>
                        <div id="databasesetupoptions">
                            <p>
                                This is the customers with valid licenses associated with the Dynamicweb partner your login is linked to.
                            </p>
                            <p>
                                Unable to find your customer? Contact our service desk (support@dynamicweb.com) to get the issue fixed. You can use a trial until license is registered.
                            </p>
                            <p>
                                <strong>Choose the customer which license you want to install</strong>
                            </p>
                            <asp:ScriptManager ID="CustomerScriptManager" runat="server"></asp:ScriptManager>
                            <asp:Repeater ID="CustomerRepeater" runat="server" EnableViewState="false" OnItemDataBound="SetRadioButtonID">
                                <ItemTemplate>
                                    <dwc:RadioButton ID="customer" runat="server" DoTranslation="False" Label='<%# Eval("Name") %>' FieldValue='<%# Eval("ID") %>' Name="customer" OnClick="javascript:setCustomerNumber(this.value)"></dwc:RadioButton>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                        <div class="buttonContainer">
                            <asp:Button runat="server" ID="CustomerBackButton" CssClass="back" OnClick="CustomerBackButton_Click" Text="Back" />
                            <asp:Button ID="goToLicenseButton" runat="server" CssClass="button orange" Text="Continue" OnClick="goToLicenseButton_Click" Enabled="False" />
                        </div>
                    </asp:Panel>

                    <asp:Panel ID="step4" CssClass="step" runat="server">
                        <h1>4. Select a license</h1>
                        <p>
                                This is the list of licenses available for the chosen customer. Choose one and click "Set license" to apply the license.
                            </p>
                        <asp:Repeater ID="SubscriptionRepeater" runat="server" EnableViewState="false" OnItemDataBound="SetRadioButtonID">
                            <ItemTemplate>
                                <div>
                                    <dwc:RadioButton ID="subscription" runat="server" DoTranslation="false" Enabled="<%#IsValidSubscription(Container.DataItem) %>" Label='<%# Eval("id") %>' FieldValue='<%# Eval("Id") %>' Name="license" OnClick="javascript:setSolutionId(this.value)"></dwc:RadioButton>
                                    <div class="items-list">
                                        <ul>
                                            <asp:Repeater ID="ItemsRepeater" DataSource='<%# Eval("Items") %>' runat="server" EnableViewState="false">
                                                <ItemTemplate>
                                                    <li><%# Eval("Name") %></li>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </ul>
                                    </div>

                                    <div class="installations-list">
                                        <ul>
                                            <asp:Repeater ID="InstallationsRepeater" DataSource='<%# Eval("Installations") %>' runat="server" EnableViewState="false">
                                                <ItemTemplate>
                                                    <li><%# Eval("MachineName") %></li>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </ul>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <div class="buttonContainer">
                            <asp:Button runat="server" ID="LicenseBackButton" CssClass="back" OnClick="LicenseBackButton_Click" Text="Back" />
                            <asp:Button ID="goToTypeButton" runat="server" CssClass="button orange" Text="Set license" OnClick="goToTypeButton_Click" OnClientClick="javascript:goToStep(5);" Enabled="false" />
                        </div>
                    </asp:Panel>

                    <asp:Panel ID="step5" CssClass="step" runat="server">
                        <h1>5. Type</h1>
                        <p>
                            Set your license type.
                        </p>
                        <p>
                            The same license can be used in multiple installations of the solution. Choose the environment that describes this installation of the solution.
                            You should have only one live license related to this solution.
                        </p>
                        <div>
                            <asp:Repeater ID="EnvironmentTypesRepeater" runat="server" EnableViewState="false" OnItemDataBound="SetRadioButtonID">
                                <ItemTemplate>
                                    <dwc:RadioButton runat="server" DoTranslation="false" Label='<%# Eval("Name") %>' FieldValue='<%# Eval("Id") %>' Name="environmentType" OnClick="javascript:setEnvironmentType(this.value)"></dwc:RadioButton>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                        <div class="buttonContainer">
                            <asp:Button ID="registerInstallationBtn" runat="server" OnClick="registerInstallation_Click" Text="Register" CssClass="button orange" Enabled="false" />
                        </div>
                    </asp:Panel>

                    <asp:Panel ID="step6" CssClass="step" runat="server">
                        <h1>6. Congratulations! 
                        </h1>
                        <h2>Setup is completed. Your Dynamicweb license is now configured and ready to make awesome websites and Ecommerce solutions.</h2>
                        <p>You are now ready to go. Click the button to start the administration of Dynamicweb.</p>
                        <div class="buttonContainer"><a class="button orange" href="/Admin/Default.aspx">Go to administration</a></div>
                    </asp:Panel>

                    <asp:Panel ID="step7" CssClass="step" runat="server">
                        <h1>2. Your Trial is ready!
                        </h1>
                        <h2>Setup is completed. Your Dynamicweb installation is now setup and ready to make awesome websites and Ecommerce solutions.</h2>
                        <p>You are now ready to go. Click the button to start the administration of Dynamicweb.</p>
                        <p>The trial will expire in 30 days!</p>
                        <div class="buttonContainer"><a class="button orange" href="/Admin/Default.aspx">Go to administration</a></div>
                    </asp:Panel>

                    <asp:Panel ID="step8" CssClass="step" runat="server">
                        <h1>No Connection</h1>
                        <p>
                            <dw:TranslateLabel ID="NoConnectionText" runat="server" />
                        </p>

                        <div class="buttonContainer"><a class="button orange" href="/Admin/Default.aspx">Go to login</a></div>
                    </asp:Panel>

                        <asp:Panel ID="step9" CssClass="step" runat="server">
                         <h1>2. Trial type</h1>
                        <p>
                            Set your trial type.
                        </p>
                        <p>
                            Choose the trial that describes this installation of the solution.
                        </p>
                        <div>
                            <asp:Repeater ID="TrialRepeater" runat="server" EnableViewState="false" OnItemDataBound="SetRadioButtonID">
                                <ItemTemplate>
                                      <dwc:RadioButton ID="trialType" runat="server" Label='<%#Eval("Name") %>'  FieldValue='<%# Eval("LicenseId") %>' SelectedFieldValue='<%# If(Container.ItemIndex = 0, Eval("LicenseId"), "") %>'  Name="trialTypeId" DoTranslation="False"></dwc:RadioButton>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                        <div class="buttonContainer">
                            <asp:Button ID="RegisterTrialBtn" runat="server" OnClick="registerTrial_Click" Text="Register" CssClass="button orange" Enabled="true" />
                        </div>
                    </asp:Panel>
                </div>
            </div>
        </div>
    </form>
    <dw:Overlay ID="setupOverlay" Message="wait" runat="server"></dw:Overlay>
</body>
</html>
