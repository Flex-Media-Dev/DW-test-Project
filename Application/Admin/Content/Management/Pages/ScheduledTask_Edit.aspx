<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ScheduledTask_Edit.aspx.vb" Inherits="Dynamicweb.Admin.ScheduledTask_Edit" %>


<%--<%@ Register TagPrefix="management" TagName="ImpersonationDialog" Src="/Admin/Content/Management/ImpersonationDialog/ImpersonationDialog.ascx" %>--%>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources runat="server" IncludePrototype="false" IncludeRequireJS="false" IncludeUIStylesheet="false"></dw:ControlResources>
    <style type="text/css">
        .floating-actionbar #cmdSaveToXml {
            color: #353535;
            background-color: #e0e0e0;
        }
    </style>
    <dwc:ScriptLib runat="server" ID="ScriptLib1">
        <script src="/Admin/Content/JsLib/dw/Utilities.js" type="text/javascript"></script>
        <script src="/Admin/Images/Ribbon/UI/Toolbar/Toolbar.js" type="text/javascript"></script>
        <script src="/Admin/Images/Ribbon/UI/Contextmenu/Contextmenu.js" type="text/javascript"></script>
        <script src="/Admin/Images/Controls/UserSelector/UserSelector.js" type="text/javascript"></script>
        <script src="/Admin/Resources/js/layout/Actions.js" type="text/javascript"></script>
        <script>
            jQuery.noConflict();
            var $j = jQuery;

            var ScheduledTask = {};
            (function ($) {
                $.extend(ScheduledTask, {
                    init: function (options) {
                        this.options = options;
                        this.isUrlRegExp = /^((((https?|ftp|gopher|telnet|file|notes|ms-help):((\/\/)|(\\\\)))|(\/admin\/public))+[\w\d:#@%/;$()~_?\+-=\\\.&]*)$/i;

                        var selectedEl = $("input[name=ActivationType]").on("change", function () {
                            $(".activation-panel").hide().filter("." + $(this).val()).show();

                            if ($(this).val() == "ClassMethodActivation") {
                                ScheduledTask.getAssemblies(options);
                            }
                        }).filter(":checked").trigger("change");

                        $("#TaskActivationUrl")
                            .on("mouseup", function () {
                                this.select();
                            }).prop("readonly", true);
                    },

                    editSave: function (close) {
                        if (!this.isValid()) {
                            return false;
                        }
                        this.initiatePostBack("EditTask", close ? "close" : "")
                    },
                    editSaveToXml: function () {
                        if (!this.isValid()) {
                            return false;
                        }
                        this.initiatePostBack("SaveTaskToXml", "")
                    },

                    isValid: function () {
                        var result = true;
                        dwGlobal.hideAllControlsErrors(null, "");
                        var taskNameEl = $("#TaskName");
                        if (!taskNameEl.val()) {
                            dwGlobal.showControlErrors("TaskName", this.options.titles.nameRequired);
                            result = false;
                        }
                        var datepicker = Dynamicweb.UIControls.DatePicker.get_current();
                        if (datepicker) {
                            var taskActiveTo = datepicker.GetDate("TaskActiveTo");
                            if (taskActiveTo) {
                                var taskActiveFrom = datepicker.GetDate("TaskActiveFrom");
                                if (taskActiveFrom) {
                                    if (taskActiveTo < taskActiveFrom) {
                                        dwGlobal.showControlErrors("helpTaskActiveTo", this.options.titles.endDateLessBeginDate);
                                        result = false;
                                    }
                                }
                            }
                        }
                        var activationType = $("input[name=ActivationType]:checked").val();
                        if (activationType == "UrlActivation") {
                            var el = $("#TaskUrl");
                            if (!this.isUrlRegExp.test(el.val())) {
                                dwGlobal.showControlErrors("TaskUrl", this.options.titles.urlInvalid);
                                result = false;
                            }
                            if (!el.val()) {
                                dwGlobal.showControlErrors("TaskUrl", this.options.titles.urlRequired);
                                result = false;
                            }
                        }
                        else if (activationType == "ClassMethodActivation") {
                            var el = $("#ddlAssembly");
                            if (!el.val()) {
                                ScheduledTask.showDropDownError("#helpddlAssembly", this.options.titles.nameRequired);
                                result = false;
                            }
                            el = $("#ddlNamespace");
                            if (!el.val()) {
                                ScheduledTask.showDropDownError("#helpddlNamespace", this.options.titles.nameRequired);
                                result = false;
                            }
                            el = $("#ddlClass");
                            if (!el.val()) {
                                ScheduledTask.showDropDownError("#helpddlClass", this.options.titles.nameRequired);
                                result = false;
                            }
                            el = $("#ddlMethod");
                            if (!el.val()) {
                                ScheduledTask.showDropDownError("#helpddlMethod", this.options.titles.nameRequired);
                                result = false;
                            }
                        }
                        return result;
                    },

                    cancel: function () {
                        Action.Execute({
                            Name: "OpenScreen",
                            Url: this.options.urls.list
                        });
                    },

                    initiatePostBack: function (action, target) {
                        var frm = $("#MainForm");
                        $("#PostBackAction").val(action + ':' + target);
                        frm.submit();
                    },

                    deleteTask: function () {
                        if (confirm(this.options.titles.deleteConfirmationMessage)) {
                            this.initiatePostBack('RemoveTask', "");
                        }
                    },

                    getAssemblies: function (options) {
                        $.ajax({
                            type: "POST",
                            url: "ScheduledTask_Edit.aspx/GetAssemblies",
                            data: "{}",
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (msg) {
                                ScheduledTask.hideDropDownError("#helpddlAssembly");

                                var dropdown = $("#ddlAssembly").get(0);
                                dropdown.options.length = 0;
                                dropdown.options[0] = new Option(options.titles.select, "");

                                $.each(msg.d, function (index, item) {
                                    var selected = (item.Value && options.MethodInfo.taskAssembly && item.Value.toLowerCase() == options.MethodInfo.taskAssembly.toLowerCase());
                                    dropdown.options[dropdown.options.length] = new Option(item.Name, item.Value, false, selected);
                                });
                                $("#ddlAssembly").change(function () {
                                    ScheduledTask.getNamespaces(options);
                                });
                                if (dropdown.selectedIndex > 0) {
                                    $("#ddlAssembly").trigger("change");
                                }
                            },
                            error: function () {
                                ScheduledTask.showDropDownError("#helpddlAssembly", options.titles.failedToLoad);
                            }
                        });
                    },

                    getNamespaces: function (options) {
                        $j("#ddlClass").get(0).options.length = 0;
                        $j("#ddlMethod").get(0).options.length = 0;
                        var dropdown = $j("#ddlNamespace").get(0);
                        var assemblyName = $("#ddlAssembly").val();
                        if (assemblyName != null && assemblyName.length > 0) {
                            dropdown.options.length = 0;
                            dropdown.options[0] = new Option(options.titles.loading, "");
                            dropdown.options.length = 0;

                            $.ajax({
                                type: "POST",
                                url: "ScheduledTask_Edit.aspx/GetNamespaces",
                                data: JSON.stringify({ "assemblyName": assemblyName }),
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                success: function (msg) {
                                    ScheduledTask.hideDropDownError("#helpddlNamespace");

                                    var dropdown = $("#ddlNamespace").get(0);
                                    dropdown.options.length = 0;
                                    dropdown.options[0] = new Option(options.titles.select, "");

                                    $.each(msg.d, function (index, item) {
                                        var selected = (item.Value && options.MethodInfo.taskNamespace && item.Value.toLowerCase() == options.MethodInfo.taskNamespace.toLowerCase());
                                        dropdown.options[dropdown.options.length] = new Option(item.Name, item.Value, false, selected);
                                    });
                                    $("#ddlNamespace").off('change').change(function () {
                                        ScheduledTask.getClasses(options);
                                    });
                                    if (dropdown.selectedIndex > 0) {
                                        $("#ddlNamespace").trigger("change");
                                    }
                                },
                                error: function () {
                                    ScheduledTask.showDropDownError("#ddlNamespace", options.titles.failedToLoad);
                                }
                            });
                        }
                    },

                    getClasses: function (options) {
                        $j("#ddlMethod").get(0).options.length = 0;
                        var assemblyName = $("#ddlAssembly").val();
                        var namespace = $("#ddlNamespace").val();
                        var dropdown = $j("#ddlClass").get(0);
                        if (namespace != null && namespace.length > 0) {
                            dropdown.options.length = 0;
                            dropdown.options[0] = new Option(options.titles.loading, "");
                            dropdown.options.length = 0;

                            $j.ajax({
                                type: "POST",
                                url: "ScheduledTask_Edit.aspx/GetClasses",
                                data: JSON.stringify({ "assemblyName": assemblyName, "assemblyNamespace": namespace }),
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                success: function (msg) {
                                    ScheduledTask.hideDropDownError("#helpddlClass");

                                    dropdown.options.length = 0;
                                    dropdown.options[0] = new Option(options.titles.select, "");

                                    $j.each(msg.d, function (index, item) {
                                        var selected = (item.Value && options.MethodInfo.taskClass && item.Value.toLowerCase() == options.MethodInfo.taskClass.toLowerCase());
                                        dropdown.options[dropdown.options.length] = new Option(item.Name, item.Value, false, selected);
                                    });
                                    $("#ddlClass").off('change').change(function () {
                                        ScheduledTask.getMethods(options);
                                    });
                                    if (dropdown.selectedIndex > 0) {
                                        $j("#ddlClass").trigger("change");
                                    }
                                },
                                error: function (e) {
                                    dropdown.options.length = 0;
                                    ScheduledTask.showDropDownError("#helpddlClass", options.titles.failedToLoad);
                                }
                            });
                        }
                        else {
                            dropdown.options.length = 0;
                        }
                    },

                    getMethods: function (options) {
                        var dropdown = $j("#ddlMethod").get(0);
                        var assemblyName = $("#ddlAssembly").val();
                        var namespace = $("#ddlNamespace").val();
                        var className = $("#ddlClass").val();

                        if (assemblyName != null && assemblyName.length > 0 && className != null && className.length > 0) {
                            dropdown.options.length = 0;
                            dropdown.options[0] = new Option(options.titles.loading, "");

                            $j.ajax({
                                type: "POST",
                                url: "ScheduledTask_Edit.aspx/GetMethods",
                                data: JSON.stringify({ "assemblyName": assemblyName, "assemblyNamespace": namespace, "className": className }),
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                success: function (msg) {
                                    ScheduledTask.hideDropDownError("#helpddlMethod");

                                    dropdown.options.length = 0;
                                    dropdown.options[0] = new Option(options.titles.select, "");

                                    $j.each(msg.d, function (index, item) {
                                        var selected = (item.Name && options.MethodInfo.taskMethod && item.Name.toLowerCase() == options.MethodInfo.taskMethod.toLowerCase());
                                        dropdown.options[dropdown.options.length] = new Option(item.Name, item.Name, false, selected);
                                    });
                                },
                                error: function (e) {
                                    dropdown.options.length = 0;
                                    ScheduledTask.showDropDownError("#helpddlMethod", options.titles.failedToLoad);
                                }
                            });
                        }
                        else {
                            dropdown.options.length = 0;
                        }
                    },

                    hideDropDownError: function (id) {
                        $j(id).get(0).style.display = "none";
                        $j(id).parent().parent().removeClass("has-error");
                    },

                    showDropDownError: function (id, message) {
                        $j(id).get(0).style.display = "block";
                        $j(id).get(0).innerText = message;
                        $j(id).parent().parent().addClass("has-error");
                    }
                });

                $(function () {
                    ScheduledTask.init({
                        urls: {
                            list: "<%= GetListUrl()%>"
                        },
                        titles: {
                            nameRequired: "<%=Translate.JsTranslate("required")%>",
                            urlRequired: "<%=Translate.JsTranslate("required")%>",
                            urlInvalid: "<%=Translate.JsTranslate("incorrect URL format")%>",
                            methodRequired: "<%=Translate.JsTranslate("required")%>",
                            deleteConfirmationMessage: "<%=Translate.JsTranslate("Are you sure you want to delete this scheduled task ?")%>",
                            select: "<%=Translate.JsTranslate("Select")%>",
                            loading: "<%=Translate.JsTranslate("Loading")%>",
                            failedToLoad: "<%=Translate.JsTranslate("Failed to load")%>",
                            endDateLessBeginDate: "<%=Translate.JsTranslate("End date must be grater than begin date")%>"
                        },
                        MethodInfo: {
                            taskAssembly: "<%= GetTaskAssembly()%>",
                            taskNamespace: "<%= GetTaskNamespace()%>",
                            taskClass: "<%= GetTaskClass()%>",
                            taskMethod: "<%= GetTaskMethod()%>"
                        }
                    });
                });
            })(jQuery);
        </script>
    </dwc:ScriptLib>
</head>
<body class="area-blue">
    <div class="dw8-container">
        <form id="MainForm" runat="server">
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" ID="lbSetup" Title="Edit scheduled task"></dwc:CardHeader>
                <dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false" ShowAsRibbon="true" Visible="false">
                    <dw:ToolbarButton ID="TaskDelete" runat="server" Divide="None" Icon="Delete" OnClientClick="ScheduledTask.deleteTask()" Text="Delete" />
                </dw:Toolbar>
                <dwc:CardBody runat="server">
                    <dw:Infobar ID="infWarning" runat="server" Type="Warning" Visible="False" Message="In the NLB setup, all operations should be performed only on the main server."></dw:Infobar>
                    <dw:Infobar ID="ErrorMessage" Visible="false" Type="Error" Message="" runat="server" />
                    <asp:HiddenField ID="PostBackAction" runat="server" />
                    <dwc:GroupBox ID="GroupBox1" runat="server" Title="Generel information">
                        <dwc:InputText runat="server" ID="TaskName" Label="Task name" ValidationMessage="" />
                        <dw:DateSelector runat="server" ID="TaskActiveFrom" Label="Begin"></dw:DateSelector>
                        <dw:DateSelector runat="server" ID="TaskActiveTo" Label="End" ValidationMessage=""></dw:DateSelector>
                        <div class="form-group">
                            <div class="form-group-input left-indent">
                                <small id="helpTaskActiveTo" class="help-block error"></small>
                            </div>
                        </div>
                        <dwc:SelectPicker runat="server" ID="TaskRepeat" Label="Repeat every"></dwc:SelectPicker>
                        <dwc:InputText runat="server" ID="TaskActivationUrl" Label="Activation URL" />
                        <dwc:CheckBox runat="server" ID="CheckPreviousTask" Label="Run if previous task executed successfully" DoTranslate="true" />
                        <dw:FileManager runat="server" ID="ConfigXml" Folder="/Files" AllowBrowse="true" Extensions="xml" Label="Configuration file" ToolTip="Configuration file parameters takes precedence" Visible="false" />
                    </dwc:GroupBox>
                    <dwc:GroupBox ID="GroupBox2" runat="server" Title="Task status">
                        <div class="form-group">
                            <label class="control-label"><%=Translate.Translate("Last run state")%></label>
                            <div>
                                <asp:Literal ID="LastRunState" runat="server"></asp:Literal>
                            </div>
                        </div>
                        <div class="form-group" runat="server" id="LastEventDiv" visible="false">
                            <label class="control-label"><a href="/Admin/Content/Management/EventViewer/EventViewerDetails.aspx?Id=<%=currentTask.LastEventId%>"><%=Translate.Translate("Last event")%></a></label>
                        </div>
                        <div class="form-group" runat="server" id="LastExceptionDiv" visible="false">
                            <label class="control-label"><%=Translate.Translate("Last exception")%></label>
                            <div class="dw-ctrl textarea-ctrl form-group">
                                <div class="form-group-input">
                                    <textarea id="LastException" runat="server" type="text" readonly="readonly" class="form-control auto-size" rows="15" style="overflow: hidden; overflow-wrap: break-word; height: 299px;">
                                </textarea>
                                </div>
                            </div>
                        </div>
                    </dwc:GroupBox>

                    <dwc:GroupBox ID="ScheduledTaskActivationType" runat="server" Title="Activation">
                        <dwc:RadioGroup runat="server" ID="ActivationType" Label="Type">
                            <dwc:RadioButton runat="server" FieldValue="UrlActivation" Label="Url" />
                            <dwc:RadioButton runat="server" FieldValue="ClassMethodActivation" Label="Method" />
                            <dwc:RadioButton runat="server" FieldValue="AddInActivation" Label="Add-in" />
                        </dwc:RadioGroup>

                        <div class="activation-panel UrlActivation">
                            <dwc:InputText runat="server" ID="TaskUrl" Label="Url" ValidationMessage="" />
                        </div>
                        <div class="activation-panel ClassMethodActivation">
                            <div class="form-group">
                                <label class="control-label">
                                    <dw:TranslateLabel runat="server" Text="Assembly" />
                                </label>
                                <div class="btn-group bootstrap-select">
                                    <select id="ddlAssembly" name="ddlAssembly" class="std" style="width: 100%;"></select>
                                    <small class="help-block error" id="helpddlAssembly"></small>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label">
                                    <dw:TranslateLabel runat="server" Text="Namespace" />
                                </label>
                                <div class="btn-group bootstrap-select">
                                    <select id="ddlNamespace" name="ddlNamespace" class="std" style="width: 100%;"></select>
                                    <small class="help-block error" id="helpddlNamespace"></small>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label">
                                    <dw:TranslateLabel runat="server" Text="Class" />
                                </label>
                                <div class="btn-group bootstrap-select">
                                    <select id="ddlClass" name="ddlClass" class="std" style="width: 100%;"></select>
                                    <small class="help-block error" id="helpddlClass"></small>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label">
                                    <dw:TranslateLabel runat="server" Text="Method" />
                                </label>
                                <div class="btn-group bootstrap-select">
                                    <select id="ddlMethod" name="ddlMethod" class="std" style="width: 100%;"></select>
                                    <small class="help-block error" id="helpddlMethod"></small>
                                </div>
                            </div>
                            <dwc:InputText runat="server" ID="MethodParams" Label="Parameters" ValidationMessage="" />
                        </div>
                    </dwc:GroupBox>
                    <div class="activation-panel AddInActivation">
                        <div runat="server" id="AddInSelectorDiv">
                            <%= addInSelector.Jscripts %>
                            <de:AddInSelector ID="addInSelector" runat="server" AddInShowParameters="true" UseLabelAsName="True" AddInShowNothingSelected="false" AddInShowNoFoundMsg="false"
                                AddInTypeName="Dynamicweb.Scheduling.BaseScheduledTaskAddIn"
                                AddInIgnoreTypeNames="Dynamicweb.DataIntegration.Integration.Interfaces.IERPIntegration,Dynamicweb.Scheduling.Providers.CalculatedFieldsScheduledTaskAddIn" />
                            <%= addInSelector.LoadParameters %>
                        </div>
                        <div runat="server" id="ErpAddInSelectorDiv">
                            <%= erpAddInSelector.Jscripts %>
                            <de:AddInSelector ID="erpAddInSelector" runat="server" AddInShowParameters="true" UseLabelAsName="True" AddInShowNothingSelected="false" AddInShowNoFoundMsg="false"
                                AddInTypeName="Dynamicweb.DataIntegration.BatchIntegrationScheduledTaskAddin" />
                            <%= erpAddInSelector.LoadParameters %>
                        </div>
                    </div>
                    <asp:HiddenField runat="server" ID="hdIsErpAddInTask" />
                </dwc:CardBody>
            </dwc:Card>
        </form>
        <dwc:ActionBar runat="server">
            <dw:ToolbarButton ID="cmdSave" runat="server" Divide="None" Image="NoImage" Disabled="false" OnClientClick="if(!Toolbar.buttonIsDisabled('cmdSave')) {{ ScheduledTask.editSave(false); }}" Text="Gem" />
            <dw:ToolbarButton ID="cmdSaveAndClose" runat="server" Divide="None" Image="NoImage" Disabled="false" OnClientClick="if(!Toolbar.buttonIsDisabled('cmdSaveAndClose')) {{ ScheduledTask.editSave(true); }}" Text="Gem og luk" />
            <dw:ToolbarButton ID="cmdCancel" runat="server" Divide="None" Image="NoImage" Text="Cancel" ShowWait="true" OnClientClick="ScheduledTask.cancel();" />
            <dw:ToolbarButton ID="cmdSaveToXml" runat="server" Divide="None" IconColor="Modules" Image="NoImage" Disabled="false" OnClientClick="if(!Toolbar.buttonIsDisabled('cmdSaveToXml')) {{ ScheduledTask.editSaveToXml(false); }}" Text="Save to xml" />
        </dwc:ActionBar>
    </div>
    <dw:Overlay ID="wait" runat="server" Message="Please wait" ShowWaitAnimation="True">
    </dw:Overlay>
</body>

<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html>


