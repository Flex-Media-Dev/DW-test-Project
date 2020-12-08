<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/OMC/Marketing.Master" CodeBehind="EditEmail.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Emails.EditEmail" %>

<%@ Import Namespace="Dynamicweb.EmailMarketing" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="omc" Namespace="Dynamicweb.Controls.OMC" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<asp:Content runat="server" ContentPlaceHolderID="HeadContent">
    <style>
        .content-preview {
            width:100%;
            height:35vh;
            border: 1px solid #e0e0e0;
        }

        .content-preview-box {
            display:none;
        }

        .emails-list-container .list .container table .header > td:last-child,
        .emails-list-container .list .container table .listRow > td:last-child {
            display:none
        }
    </style>
    <script>
        function showHelp() {
            <%=Gui.Help("omc.email.list", "omc.email.list")%>
        }

        <% If Core.Converter.ToString(Dynamicweb.Context.Current.Request("NavigatorSync")).ToLower() = "selectnode" Then %>
        <%= Dynamicweb.Management.Marketing.Nodes.EmailMarketing.EmailNode.RefreshEmailListAction(Core.Converter.ToInt32(Request("folderId")), Core.Converter.ToInt32(TopFolderId), False).ToString() %>;
        <% End If %>
    </script>

    <script type="text/javascript">
        function getNewsletterName() {
            return $('txSubject').value;             
        }

        function getScheduledDate() {            
            var scheduledDate = "";
            if($('<%=dsStartDate.UniqueID%>_calendar') && Dynamicweb && Dynamicweb.UIControls && Dynamicweb.UIControls.DatePicker){
                scheduledDate = Dynamicweb.UIControls.DatePicker.get_current().GetDate('<%=dsStartDate.UniqueID%>');
            }
            return scheduledDate; 
        }

        function setScheduledDate(newDate) {
            const ctrlId = '<%=dsStartDate.UniqueID%>';
            const val = newDate;
            Dynamicweb.UIControls.DatePicker.get_current().SetDate(ctrlId, val);
            Dynamicweb.UIControls.DatePicker.get_current().UpdateCalendarDate(val, ctrlId);
        }

        function getConfirmText() {
            var confirmText= '<%=Translate.JsTranslate("The sending of e-mail")%>' + " '" + getNewsletterName() + "' " + '<%=Translate.JsTranslate(" will be scheduled for ")%>' + getScheduledDate() + '<%=Translate.JsTranslate(". Do you want to continue?")%>';
            return confirmText;
        }


        function showPreviewEmailDialog() {  
            var userId = $('PreviewEmailSelectorhidden').value;            
            if (userId) {
                var url = "/Admin/Module/OMC/Emails/EditEmail.aspx";
                var hasSplitTest = $('chkOriginal') ? true : false;
                    
                new Ajax.Request(url, {
                    method: 'get',
                    parameters: {
                        UserID: userId
                    },
                    onSuccess: function (transport) {
                        if(transport.responseText.length > 0) {
                            alert(transport.responseText);
                        } else {
                            window.open('/Admin/Module/OMC/Emails/PreviewMailPage.aspx?emailId=' + <%=EmailID%> + '&userId=' + userId + '&hasSplitTest=' + hasSplitTest, 'PreviewMailPopup', 'status=1,toolbar=0,menubar=0,resizable=1,directories=0,titlebar=0,modal=no');
                        }
                    }, 
                });
            } else {
                alert('<%=Translate.JsTranslate("Please select a user")%>');
            }
        }

        function getVariantPageId() {
            var pageUrl = $('lmVariantEmailPage').value;
            var pageId = pageUrl.split('=')[1];

            return pageId;
        }

        function execResponse(text) {
            if(!text && text != "") {
                eval(text);
            }
        }

        function disableInputsFields() {
            $('cbCreateSplitTestVariation').disable();
            $('<%=DomainSelector.ClientID%>').disable();
            $('RecipientAddinControlDiv').disabled =true;
            $('RecipientAddinControlDiv').select('img').each(function(element) {
                element.onclick = "";
            });
        }

        function OnRecipientsCountChanged(ids) {
            var el = $('lblTotalRecipientsValue');

            if(el != null) {
                var url = '/Admin/Module/OMC/Emails/EditEmail.aspx?newsletterId=<%=EmailID%>';

                new Ajax.Request(url, {
                    method: 'get',
                    parameters: {
                        OpType: 'OnRecipientsCountChanged',
                        IncludedIds: ids,
                        ExcludedIds: document.getElementById('RecipientsExcluded').value
                    },
                    onSuccess: function (transport) {
                        if(transport.responseText != null && transport.responseText.length > 0)
                            el.textContent = transport.responseText;
                        else
                            el.textContent = '0';
                    }
                });      
            }
        }

        function ShowRecipientsPopup() {
            <%=If(IsEmailSent(), "return;", String.Empty)%>
            var included = document.getElementById('<%=RecipientSelector.ID%>hidden').value;
            var excluded = document.getElementById('RecipientsExcluded').value;

            dwGlobal.marketing.showDialog(
                '/Admin/Module/OMC/Emails/RecipientsList.aspx?emailId=<%=EmailID%>&included=' + included + '&excluded=' + excluded, 
                950, 
                482, 
                { title: '<%=Translate.Translate("All recipients")%>', hideCancelButton: true },
                updateRecipients);
            }

            function updateRecipients() {
                <%="UserSelector" + Me.RecipientSelector.ID%>.clearExcluded();
                var excluded = document.getElementById('RecipientsExcluded').value;
                var items = excluded.split(',');

                for(i = 0; i < items.length; i++)
                    <%="UserSelector" + Me.RecipientSelector.ID%>.excludeUser('u' + items[i]);   

                <%="UserSelector" + Me.RecipientSelector.ID%>.renderItems('', '');
                OnRecipientsCountChanged(document.getElementById('<%=Me.RecipientSelector.ID%>hidden').value);
            }

            function RenderRecipientControl() {
                var providerSelector = $('Dynamicweb.EmailMarketing.EmailRecipientProvider_AddInTypes');
                var provType = providerSelector.value;
                var providerName = providerSelector[providerSelector.selectedIndex].text;
                var translatedText = '<%=Translate.Translate("Using a custom recipient provider")%>: ';

                if(provType != '<%=GetType(RecipientProviders.AccessUserRecipientProvider).FullName%>') {
                    var customDiv;
                    customDiv = document.getElementById('CustomRecipientSelectorDiv');
                    customDiv.innerHTML = translatedText + '<a href="javascript:dialog.show(\'RecipientProviderDialog\')">' + providerName + '</a>';
                    customDiv.removeAttribute('style');

                    document.getElementById('RecipientAddinControlDiv').style.display = 'none';
                    var isEmailSent = eval('<%=_email.IsEmailSent()%>'.toLowerCase());
                if(isEmailSent) {
                    var addTagEl = document.getElementById("addTag");
                    if (addTagEl){
                        addTagEl.style.visibility = "hidden";
                    }
                    var addVarTagEl = document.getElementById("addVarTag");
                    if (addVarTagEl) {
                        addVarTagEl.style.visibility = "hidden";
                    }
                }
            } else {
                document.getElementById('RecipientAddinControlDiv').removeAttribute('style');
                document.getElementById('CustomRecipientSelectorDiv').style.display = 'none';
                var addTagEl = document.getElementById("addTag");
                if (addTagEl){
                    addTagEl.style.visibility = "visible";
                }
                var addVarTagEl = document.getElementById("addVarTag");
                if (addVarTagEl) {
                    addVarTagEl.style.visibility = "visible";
                }
            }          
        }

        function toggleScheduledRepeatSettings() {
            var intervalDropDown = $("<%= ddlScheduledRepeatInterval.ClientID%>");

            var endTimeRow = $("trRepeatEndTime");
            if (intervalDropDown.options[intervalDropDown.selectedIndex].value == "0") {
                endTimeRow.hide();
            }
            else {
                endTimeRow.show();
            }
        }

        function toggleQuarantinePeriodSettings() {
            var quarantineDropDown = $("<%= ddlQuarantinePeriod.ClientID%>");
            var uniqueRecipients = $("<%= chkUniqueRecipients.ClientID%>").checked;
            var quarantineBox = $("boxCustomQuarantinePeriod");
            var quarantineRow = $("trQuarantinePeriod");

            if (uniqueRecipients)
                quarantineRow.hide();
            else
                quarantineRow.show();

            if (quarantineDropDown.options[quarantineDropDown.selectedIndex].value == "_")
                quarantineBox.show();
            else
                quarantineBox.hide();
        }

        function togglePlainTextRow() {
            var usePlainText = $("<%= radioCustomPlainText.ClientID%>").checked;
            var plainTextRow = $("trPlainTextRow");

            if (usePlainText)
                plainTextRow.show();
            else
                plainTextRow.hide();
        }

        function onLinkManagerSelect(controlId, model) {
            $(controlId).value = model.SelectedAreaAndPageName;
            currentPage.checkLinkedPage(null, controlId);
            currentPage.showPagePreview();
            const createPagesCopyEl = document.getElementById("MakePageCopy");
            createPagesCopyEl.value = "";
        }

        Event.observe(window, "load", function () {
            RenderRecipientControl();
            setScheduledDate(new Date());
            chooseLocaltimeZone(document.getElementById("<%= ScheduledSendTimeZone.ClientID %>"));
            currentPage.showPagePreview();
        });

        function HideUnsubscribeDialog() {
            var messageText = '<%=Translate.Translate("It is not recommended to disable unsubscribe link unless it is absolutely necessary. It can be illegal to do so.")%>';
            var checked = $("DoNotAddUnsubscribe").checked;
            if (checked) {
                alert(messageText);
            }
            dialog.hide('UnsubscribeDialog');
        }

        function chooseLocaltimeZone(ctrl) {
            // windows zone <=> iana zone relation
            // http://unicode.org/repos/cldr/trunk/common/supplemental/windowsZones.xml
            const windowsZones = [["Dateline Standard Time", "Etc/GMT+12"],["Dateline Standard Time", "Etc/GMT+12"],["UTC-11", "Etc/GMT+11"],["UTC-11", "Pacific/Pago_Pago"],["UTC-11", "Pacific/Niue"],["UTC-11", "Pacific/Midway"],["UTC-11", "Etc/GMT+11"],["Aleutian Standard Time", "America/Adak"],["Aleutian Standard Time", "America/Adak"],["Hawaiian Standard Time", "Pacific/Honolulu"],["Hawaiian Standard Time", "Pacific/Rarotonga"],["Hawaiian Standard Time", "Pacific/Tahiti"],["Hawaiian Standard Time", "Pacific/Johnston"],["Hawaiian Standard Time", "Pacific/Honolulu"],["Hawaiian Standard Time", "Etc/GMT+10"],["Marquesas Standard Time", "Pacific/Marquesas"],["Marquesas Standard Time", "Pacific/Marquesas"],["Alaskan Standard Time", "America/Anchorage"],["Alaskan Standard Time", "America/Anchorage America/Juneau America/Metlakatla America/Nome America/Sitka America/Yakutat"],["UTC-09", "Etc/GMT+9"],["UTC-09", "Pacific/Gambier"],["UTC-09", "Etc/GMT+9"],["Pacific Standard Time (Mexico)", "America/Tijuana"],["Pacific Standard Time (Mexico)", "America/Tijuana America/Santa_Isabel"],["UTC-08", "Etc/GMT+8"],["UTC-08", "Pacific/Pitcairn"],["UTC-08", "Etc/GMT+8"],["Pacific Standard Time", "America/Los_Angeles"],["Pacific Standard Time", "America/Vancouver America/Dawson America/Whitehorse"],["Pacific Standard Time", "America/Los_Angeles"],["Pacific Standard Time", "PST8PDT"],["US Mountain Standard Time", "America/Phoenix"],["US Mountain Standard Time", "America/Dawson_Creek America/Creston America/Fort_Nelson"],["US Mountain Standard Time", "America/Hermosillo"],["US Mountain Standard Time", "America/Phoenix"],["US Mountain Standard Time", "Etc/GMT+7"],["Mountain Standard Time (Mexico)", "America/Chihuahua"],["Mountain Standard Time (Mexico)", "America/Chihuahua America/Mazatlan"],["Mountain Standard Time", "America/Denver"],["Mountain Standard Time", "America/Edmonton America/Cambridge_Bay America/Inuvik America/Yellowknife"],["Mountain Standard Time", "America/Ojinaga"],["Mountain Standard Time", "America/Denver America/Boise"],["Mountain Standard Time", "MST7MDT"],["Central America Standard Time", "America/Guatemala"],["Central America Standard Time", "America/Belize"],["Central America Standard Time", "America/Costa_Rica"],["Central America Standard Time", "Pacific/Galapagos"],["Central America Standard Time", "America/Guatemala"],["Central America Standard Time", "America/Tegucigalpa"],["Central America Standard Time", "America/Managua"],["Central America Standard Time", "America/El_Salvador"],["Central America Standard Time", "Etc/GMT+6"],["Central Standard Time", "America/Chicago"],["Central Standard Time", "America/Winnipeg America/Rainy_River America/Rankin_Inlet America/Resolute"],["Central Standard Time", "America/Matamoros"],["Central Standard Time", "America/Chicago America/Indiana/Knox America/Indiana/Tell_City America/Menominee America/North_Dakota/Beulah America/North_Dakota/Center America/North_Dakota/New_Salem"],["Central Standard Time", "CST6CDT"],["Easter Island Standard Time", "Pacific/Easter"],["Easter Island Standard Time", "Pacific/Easter"],["Central Standard Time (Mexico)", "America/Mexico_City"],["Central Standard Time (Mexico)", "America/Mexico_City America/Bahia_Banderas America/Merida America/Monterrey"],["Canada Central Standard Time", "America/Regina"],["Canada Central Standard Time", "America/Regina America/Swift_Current"],["SA Pacific Standard Time", "America/Bogota"],["SA Pacific Standard Time", "America/Rio_Branco America/Eirunepe"],["SA Pacific Standard Time", "America/Coral_Harbour"],["SA Pacific Standard Time", "America/Bogota"],["SA Pacific Standard Time", "America/Guayaquil"],["SA Pacific Standard Time", "America/Jamaica"],["SA Pacific Standard Time", "America/Cayman"],["SA Pacific Standard Time", "America/Panama"],["SA Pacific Standard Time", "America/Lima"],["SA Pacific Standard Time", "Etc/GMT+5"],["Eastern Standard Time (Mexico)", "America/Cancun"],["Eastern Standard Time (Mexico)", "America/Cancun"],["Eastern Standard Time", "America/New_York"],["Eastern Standard Time", "America/Nassau"],["Eastern Standard Time", "America/Toronto America/Iqaluit America/Montreal America/Nipigon America/Pangnirtung America/Thunder_Bay"],["Eastern Standard Time", "America/New_York America/Detroit America/Indiana/Petersburg America/Indiana/Vincennes America/Indiana/Winamac America/Kentucky/Monticello America/Louisville"],["Eastern Standard Time", "EST5EDT"],["Haiti Standard Time", "America/Port-au-Prince"],["Haiti Standard Time", "America/Port-au-Prince"],["Cuba Standard Time", "America/Havana"],["Cuba Standard Time", "America/Havana"],["US Eastern Standard Time", "America/Indianapolis"],["US Eastern Standard Time", "America/Indianapolis America/Indiana/Marengo America/Indiana/Vevay"],["Paraguay Standard Time", "America/Asuncion"],["Paraguay Standard Time", "America/Asuncion"],["Atlantic Standard Time", "America/Halifax"],["Atlantic Standard Time", "Atlantic/Bermuda"],["Atlantic Standard Time", "America/Halifax America/Glace_Bay America/Goose_Bay America/Moncton"],["Atlantic Standard Time", "America/Thule"],["Venezuela Standard Time", "America/Caracas"],["Venezuela Standard Time", "America/Caracas"],["Central Brazilian Standard Time", "America/Cuiaba"],["Central Brazilian Standard Time", "America/Cuiaba America/Campo_Grande"],["SA Western Standard Time", "America/La_Paz"],["SA Western Standard Time", "America/Antigua"],["SA Western Standard Time", "America/Anguilla"],["SA Western Standard Time", "America/Aruba"],["SA Western Standard Time", "America/Barbados"],["SA Western Standard Time", "America/St_Barthelemy"],["SA Western Standard Time", "America/La_Paz"],["SA Western Standard Time", "America/Kralendijk"],["SA Western Standard Time", "America/Manaus America/Boa_Vista America/Porto_Velho"],["SA Western Standard Time", "America/Blanc-Sablon"],["SA Western Standard Time", "America/Curacao"],["SA Western Standard Time", "America/Dominica"],["SA Western Standard Time", "America/Santo_Domingo"],["SA Western Standard Time", "America/Grenada"],["SA Western Standard Time", "America/Guadeloupe"],["SA Western Standard Time", "America/Guyana"],["SA Western Standard Time", "America/St_Kitts"],["SA Western Standard Time", "America/St_Lucia"],["SA Western Standard Time", "America/Marigot"],["SA Western Standard Time", "America/Martinique"],["SA Western Standard Time", "America/Montserrat"],["SA Western Standard Time", "America/Puerto_Rico"],["SA Western Standard Time", "America/Lower_Princes"],["SA Western Standard Time", "America/Port_of_Spain"],["SA Western Standard Time", "America/St_Vincent"],["SA Western Standard Time", "America/Tortola"],["SA Western Standard Time", "America/St_Thomas"],["SA Western Standard Time", "Etc/GMT+4"],["Pacific SA Standard Time", "America/Santiago"],["Pacific SA Standard Time", "America/Santiago"],["Turks And Caicos Standard Time", "America/Grand_Turk"],["Turks And Caicos Standard Time", "America/Grand_Turk"],["Newfoundland Standard Time", "America/St_Johns"],["Newfoundland Standard Time", "America/St_Johns"],["Tocantins Standard Time", "America/Araguaina"],["Tocantins Standard Time", "America/Araguaina"],["E. South America Standard Time", "America/Sao_Paulo"],["E. South America Standard Time", "America/Sao_Paulo"],["SA Eastern Standard Time", "America/Cayenne"],["SA Eastern Standard Time", "Antarctica/Rothera"],["SA Eastern Standard Time", "America/Fortaleza America/Belem America/Maceio America/Recife America/Santarem"],["SA Eastern Standard Time", "Atlantic/Stanley"],["SA Eastern Standard Time", "America/Cayenne"],["SA Eastern Standard Time", "America/Paramaribo"],["SA Eastern Standard Time", "Etc/GMT+3"],["Argentina Standard Time", "America/Buenos_Aires"],["Argentina Standard Time", "America/Buenos_Aires America/Argentina/La_Rioja America/Argentina/Rio_Gallegos America/Argentina/Salta America/Argentina/San_Juan America/Argentina/San_Luis America/Argentina/Tucuman America/Argentina/Ushuaia America/Catamarca America/Cordoba America/Jujuy America/Mendoza"],["Greenland Standard Time", "America/Godthab"],["Greenland Standard Time", "America/Godthab"],["Montevideo Standard Time", "America/Montevideo"],["Montevideo Standard Time", "America/Montevideo"],["Magallanes Standard Time", "America/Punta_Arenas"],["Magallanes Standard Time", "Antarctica/Palmer"],["Magallanes Standard Time", "America/Punta_Arenas"],["Saint Pierre Standard Time", "America/Miquelon"],["Saint Pierre Standard Time", "America/Miquelon"],["Bahia Standard Time", "America/Bahia"],["Bahia Standard Time", "America/Bahia"],["UTC-02", "Etc/GMT+2"],["UTC-02", "America/Noronha"],["UTC-02", "Atlantic/South_Georgia"],["UTC-02", "Etc/GMT+2"],["Azores Standard Time", "Atlantic/Azores"],["Azores Standard Time", "America/Scoresbysund"],["Azores Standard Time", "Atlantic/Azores"],["Cape Verde Standard Time", "Atlantic/Cape_Verde"],["Cape Verde Standard Time", "Atlantic/Cape_Verde"],["Cape Verde Standard Time", "Etc/GMT+1"],["UTC", "Etc/GMT"],["UTC", "America/Danmarkshavn"],["UTC", "Etc/GMT Etc/UTC"],["Morocco Standard Time", "Africa/Casablanca"],["Morocco Standard Time", "Africa/El_Aaiun"],["Morocco Standard Time", "Africa/Casablanca"],["GMT Standard Time", "Europe/London"],["GMT Standard Time", "Atlantic/Canary"],["GMT Standard Time", "Atlantic/Faeroe"],["GMT Standard Time", "Europe/London"],["GMT Standard Time", "Europe/Guernsey"],["GMT Standard Time", "Europe/Dublin"],["GMT Standard Time", "Europe/Isle_of_Man"],["GMT Standard Time", "Europe/Jersey"],["GMT Standard Time", "Europe/Lisbon Atlantic/Madeira"],["Greenwich Standard Time", "Atlantic/Reykjavik"],["Greenwich Standard Time", "Africa/Ouagadougou"],["Greenwich Standard Time", "Africa/Abidjan"],["Greenwich Standard Time", "Africa/Accra"],["Greenwich Standard Time", "Africa/Banjul"],["Greenwich Standard Time", "Africa/Conakry"],["Greenwich Standard Time", "Africa/Bissau"],["Greenwich Standard Time", "Atlantic/Reykjavik"],["Greenwich Standard Time", "Africa/Monrovia"],["Greenwich Standard Time", "Africa/Bamako"],["Greenwich Standard Time", "Africa/Nouakchott"],["Greenwich Standard Time", "Atlantic/St_Helena"],["Greenwich Standard Time", "Africa/Freetown"],["Greenwich Standard Time", "Africa/Dakar"],["Greenwich Standard Time", "Africa/Lome"],["W. Europe Standard Time", "Europe/Berlin"],["W. Europe Standard Time", "Europe/Andorra"],["W. Europe Standard Time", "Europe/Vienna"],["W. Europe Standard Time", "Europe/Zurich"],["W. Europe Standard Time", "Europe/Berlin Europe/Busingen"],["W. Europe Standard Time", "Europe/Gibraltar"],["W. Europe Standard Time", "Europe/Rome"],["W. Europe Standard Time", "Europe/Vaduz"],["W. Europe Standard Time", "Europe/Luxembourg"],["W. Europe Standard Time", "Europe/Monaco"],["W. Europe Standard Time", "Europe/Malta"],["W. Europe Standard Time", "Europe/Amsterdam"],["W. Europe Standard Time", "Europe/Oslo"],["W. Europe Standard Time", "Europe/Stockholm"],["W. Europe Standard Time", "Arctic/Longyearbyen"],["W. Europe Standard Time", "Europe/San_Marino"],["W. Europe Standard Time", "Europe/Vatican"],["Central Europe Standard Time", "Europe/Budapest"],["Central Europe Standard Time", "Europe/Tirane"],["Central Europe Standard Time", "Europe/Prague"],["Central Europe Standard Time", "Europe/Budapest"],["Central Europe Standard Time", "Europe/Podgorica"],["Central Europe Standard Time", "Europe/Belgrade"],["Central Europe Standard Time", "Europe/Ljubljana"],["Central Europe Standard Time", "Europe/Bratislava"],["Romance Standard Time", "Europe/Paris"],["Romance Standard Time", "Europe/Brussels"],["Romance Standard Time", "Europe/Copenhagen"],["Romance Standard Time", "Europe/Madrid Africa/Ceuta"],["Romance Standard Time", "Europe/Paris"],["Central European Standard Time", "Europe/Warsaw"],["Central European Standard Time", "Europe/Sarajevo"],["Central European Standard Time", "Europe/Zagreb"],["Central European Standard Time", "Europe/Skopje"],["Central European Standard Time", "Europe/Warsaw"],["W. Central Africa Standard Time", "Africa/Lagos"],["W. Central Africa Standard Time", "Africa/Luanda"],["W. Central Africa Standard Time", "Africa/Porto-Novo"],["W. Central Africa Standard Time", "Africa/Kinshasa"],["W. Central Africa Standard Time", "Africa/Bangui"],["W. Central Africa Standard Time", "Africa/Brazzaville"],["W. Central Africa Standard Time", "Africa/Douala"],["W. Central Africa Standard Time", "Africa/Algiers"],["W. Central Africa Standard Time", "Africa/Libreville"],["W. Central Africa Standard Time", "Africa/Malabo"],["W. Central Africa Standard Time", "Africa/Niamey"],["W. Central Africa Standard Time", "Africa/Lagos"],["W. Central Africa Standard Time", "Africa/Sao_Tome"],["W. Central Africa Standard Time", "Africa/Ndjamena"],["W. Central Africa Standard Time", "Africa/Tunis"],["W. Central Africa Standard Time", "Etc/GMT-1"],["Jordan Standard Time", "Asia/Amman"],["Jordan Standard Time", "Asia/Amman"],["GTB Standard Time", "Europe/Bucharest"],["GTB Standard Time", "Asia/Famagusta Asia/Nicosia"],["GTB Standard Time", "Europe/Athens"],["GTB Standard Time", "Europe/Bucharest"],["Middle East Standard Time", "Asia/Beirut"],["Middle East Standard Time", "Asia/Beirut"],["Egypt Standard Time", "Africa/Cairo"],["Egypt Standard Time", "Africa/Cairo"],["E. Europe Standard Time", "Europe/Chisinau"],["E. Europe Standard Time", "Europe/Chisinau"],["Syria Standard Time", "Asia/Damascus"],["Syria Standard Time", "Asia/Damascus"],["West Bank Standard Time", "Asia/Hebron"],["West Bank Standard Time", "Asia/Hebron Asia/Gaza"],["South Africa Standard Time", "Africa/Johannesburg"],["South Africa Standard Time", "Africa/Bujumbura"],["South Africa Standard Time", "Africa/Gaborone"],["South Africa Standard Time", "Africa/Lubumbashi"],["South Africa Standard Time", "Africa/Maseru"],["South Africa Standard Time", "Africa/Blantyre"],["South Africa Standard Time", "Africa/Maputo"],["South Africa Standard Time", "Africa/Kigali"],["South Africa Standard Time", "Africa/Mbabane"],["South Africa Standard Time", "Africa/Johannesburg"],["South Africa Standard Time", "Africa/Lusaka"],["South Africa Standard Time", "Africa/Harare"],["South Africa Standard Time", "Etc/GMT-2"],["FLE Standard Time", "Europe/Kiev"],["FLE Standard Time", "Europe/Mariehamn"],["FLE Standard Time", "Europe/Sofia"],["FLE Standard Time", "Europe/Tallinn"],["FLE Standard Time", "Europe/Helsinki"],["FLE Standard Time", "Europe/Vilnius"],["FLE Standard Time", "Europe/Riga"],["FLE Standard Time", "Europe/Kiev Europe/Uzhgorod Europe/Zaporozhye"],["Israel Standard Time", "Asia/Jerusalem"],["Israel Standard Time", "Asia/Jerusalem"],["Kaliningrad Standard Time", "Europe/Kaliningrad"],["Kaliningrad Standard Time", "Europe/Kaliningrad"],["Sudan Standard Time", "Africa/Khartoum"],["Sudan Standard Time", "Africa/Khartoum"],["Libya Standard Time", "Africa/Tripoli"],["Libya Standard Time", "Africa/Tripoli"],["Namibia Standard Time", "Africa/Windhoek"],["Namibia Standard Time", "Africa/Windhoek"],["Arabic Standard Time", "Asia/Baghdad"],["Arabic Standard Time", "Asia/Baghdad"],["Turkey Standard Time", "Europe/Istanbul"],["Turkey Standard Time", "Europe/Istanbul"],["Arab Standard Time", "Asia/Riyadh"],["Arab Standard Time", "Asia/Bahrain"],["Arab Standard Time", "Asia/Kuwait"],["Arab Standard Time", "Asia/Qatar"],["Arab Standard Time", "Asia/Riyadh"],["Arab Standard Time", "Asia/Aden"],["Belarus Standard Time", "Europe/Minsk"],["Belarus Standard Time", "Europe/Minsk"],["Russian Standard Time", "Europe/Moscow"],["Russian Standard Time", "Europe/Moscow Europe/Kirov Europe/Volgograd"],["Russian Standard Time", "Europe/Simferopol"],["E. Africa Standard Time", "Africa/Nairobi"],["E. Africa Standard Time", "Antarctica/Syowa"],["E. Africa Standard Time", "Africa/Djibouti"],["E. Africa Standard Time", "Africa/Asmera"],["E. Africa Standard Time", "Africa/Addis_Ababa"],["E. Africa Standard Time", "Africa/Nairobi"],["E. Africa Standard Time", "Indian/Comoro"],["E. Africa Standard Time", "Indian/Antananarivo"],["E. Africa Standard Time", "Africa/Mogadishu"],["E. Africa Standard Time", "Africa/Juba"],["E. Africa Standard Time", "Africa/Dar_es_Salaam"],["E. Africa Standard Time", "Africa/Kampala"],["E. Africa Standard Time", "Indian/Mayotte"],["E. Africa Standard Time", "Etc/GMT-3"],["Iran Standard Time", "Asia/Tehran"],["Iran Standard Time", "Asia/Tehran"],["Arabian Standard Time", "Asia/Dubai"],["Arabian Standard Time", "Asia/Dubai"],["Arabian Standard Time", "Asia/Muscat"],["Arabian Standard Time", "Etc/GMT-4"],["Astrakhan Standard Time", "Europe/Astrakhan"],["Astrakhan Standard Time", "Europe/Astrakhan Europe/Ulyanovsk"],["Azerbaijan Standard Time", "Asia/Baku"],["Azerbaijan Standard Time", "Asia/Baku"],["Russia Time Zone 3", "Europe/Samara"],["Russia Time Zone 3", "Europe/Samara"],["Mauritius Standard Time", "Indian/Mauritius"],["Mauritius Standard Time", "Indian/Mauritius"],["Mauritius Standard Time", "Indian/Reunion"],["Mauritius Standard Time", "Indian/Mahe"],["Saratov Standard Time", "Europe/Saratov"],["Saratov Standard Time", "Europe/Saratov"],["Georgian Standard Time", "Asia/Tbilisi"],["Georgian Standard Time", "Asia/Tbilisi"],["Caucasus Standard Time", "Asia/Yerevan"],["Caucasus Standard Time", "Asia/Yerevan"],["Afghanistan Standard Time", "Asia/Kabul"],["Afghanistan Standard Time", "Asia/Kabul"],["West Asia Standard Time", "Asia/Tashkent"],["West Asia Standard Time", "Antarctica/Mawson"],["West Asia Standard Time", "Asia/Oral Asia/Aqtau Asia/Aqtobe Asia/Atyrau"],["West Asia Standard Time", "Indian/Maldives"],["West Asia Standard Time", "Indian/Kerguelen"],["West Asia Standard Time", "Asia/Dushanbe"],["West Asia Standard Time", "Asia/Ashgabat"],["West Asia Standard Time", "Asia/Tashkent Asia/Samarkand"],["West Asia Standard Time", "Etc/GMT-5"],["Ekaterinburg Standard Time", "Asia/Yekaterinburg"],["Ekaterinburg Standard Time", "Asia/Yekaterinburg"],["Pakistan Standard Time", "Asia/Karachi"],["Pakistan Standard Time", "Asia/Karachi"],["India Standard Time", "Asia/Calcutta"],["India Standard Time", "Asia/Calcutta"],["Sri Lanka Standard Time", "Asia/Colombo"],["Sri Lanka Standard Time", "Asia/Colombo"],["Nepal Standard Time", "Asia/Katmandu"],["Nepal Standard Time", "Asia/Katmandu"],["Central Asia Standard Time", "Asia/Almaty"],["Central Asia Standard Time", "Antarctica/Vostok"],["Central Asia Standard Time", "Asia/Urumqi"],["Central Asia Standard Time", "Indian/Chagos"],["Central Asia Standard Time", "Asia/Bishkek"],["Central Asia Standard Time", "Asia/Almaty Asia/Qyzylorda"],["Central Asia Standard Time", "Etc/GMT-6"],["Bangladesh Standard Time", "Asia/Dhaka"],["Bangladesh Standard Time", "Asia/Dhaka"],["Bangladesh Standard Time", "Asia/Thimphu"],["Omsk Standard Time", "Asia/Omsk"],["Omsk Standard Time", "Asia/Omsk"],["Myanmar Standard Time", "Asia/Rangoon"],["Myanmar Standard Time", "Indian/Cocos"],["Myanmar Standard Time", "Asia/Rangoon"],["SE Asia Standard Time", "Asia/Bangkok"],["SE Asia Standard Time", "Antarctica/Davis"],["SE Asia Standard Time", "Indian/Christmas"],["SE Asia Standard Time", "Asia/Jakarta Asia/Pontianak"],["SE Asia Standard Time", "Asia/Phnom_Penh"],["SE Asia Standard Time", "Asia/Vientiane"],["SE Asia Standard Time", "Asia/Bangkok"],["SE Asia Standard Time", "Asia/Saigon"],["SE Asia Standard Time", "Etc/GMT-7"],["Altai Standard Time", "Asia/Barnaul"],["Altai Standard Time", "Asia/Barnaul"],["W. Mongolia Standard Time", "Asia/Hovd"],["W. Mongolia Standard Time", "Asia/Hovd"],["North Asia Standard Time", "Asia/Krasnoyarsk"],["North Asia Standard Time", "Asia/Krasnoyarsk Asia/Novokuznetsk"],["N. Central Asia Standard Time", "Asia/Novosibirsk"],["N. Central Asia Standard Time", "Asia/Novosibirsk"],["Tomsk Standard Time", "Asia/Tomsk"],["Tomsk Standard Time", "Asia/Tomsk"],["China Standard Time", "Asia/Shanghai"],["China Standard Time", "Asia/Shanghai"],["China Standard Time", "Asia/Hong_Kong"],["China Standard Time", "Asia/Macau"],["North Asia East Standard Time", "Asia/Irkutsk"],["North Asia East Standard Time", "Asia/Irkutsk"],["Singapore Standard Time", "Asia/Singapore"],["Singapore Standard Time", "Asia/Brunei"],["Singapore Standard Time", "Asia/Makassar"],["Singapore Standard Time", "Asia/Kuala_Lumpur Asia/Kuching"],["Singapore Standard Time", "Asia/Manila"],["Singapore Standard Time", "Asia/Singapore"],["Singapore Standard Time", "Etc/GMT-8"],["W. Australia Standard Time", "Australia/Perth"],["W. Australia Standard Time", "Antarctica/Casey"],["W. Australia Standard Time", "Australia/Perth"],["Taipei Standard Time", "Asia/Taipei"],["Taipei Standard Time", "Asia/Taipei"],["Ulaanbaatar Standard Time", "Asia/Ulaanbaatar"],["Ulaanbaatar Standard Time", "Asia/Ulaanbaatar Asia/Choibalsan"],["Aus Central W. Standard Time", "Australia/Eucla"],["Aus Central W. Standard Time", "Australia/Eucla"],["Transbaikal Standard Time", "Asia/Chita"],["Transbaikal Standard Time", "Asia/Chita"],["Tokyo Standard Time", "Asia/Tokyo"],["Tokyo Standard Time", "Asia/Jayapura"],["Tokyo Standard Time", "Asia/Tokyo"],["Tokyo Standard Time", "Pacific/Palau"],["Tokyo Standard Time", "Asia/Dili"],["Tokyo Standard Time", "Etc/GMT-9"],["North Korea Standard Time", "Asia/Pyongyang"],["North Korea Standard Time", "Asia/Pyongyang"],["Korea Standard Time", "Asia/Seoul"],["Korea Standard Time", "Asia/Seoul"],["Yakutsk Standard Time", "Asia/Yakutsk"],["Yakutsk Standard Time", "Asia/Yakutsk Asia/Khandyga"],["Cen. Australia Standard Time", "Australia/Adelaide"],["Cen. Australia Standard Time", "Australia/Adelaide Australia/Broken_Hill"],["AUS Central Standard Time", "Australia/Darwin"],["AUS Central Standard Time", "Australia/Darwin"],["E. Australia Standard Time", "Australia/Brisbane"],["E. Australia Standard Time", "Australia/Brisbane Australia/Lindeman"],["AUS Eastern Standard Time", "Australia/Sydney"],["AUS Eastern Standard Time", "Australia/Sydney Australia/Melbourne"],["West Pacific Standard Time", "Pacific/Port_Moresby"],["West Pacific Standard Time", "Antarctica/DumontDUrville"],["West Pacific Standard Time", "Pacific/Truk"],["West Pacific Standard Time", "Pacific/Guam"],["West Pacific Standard Time", "Pacific/Saipan"],["West Pacific Standard Time", "Pacific/Port_Moresby"],["West Pacific Standard Time", "Etc/GMT-10"],["Tasmania Standard Time", "Australia/Hobart"],["Tasmania Standard Time", "Australia/Hobart Australia/Currie"],["Vladivostok Standard Time", "Asia/Vladivostok"],["Vladivostok Standard Time", "Asia/Vladivostok Asia/Ust-Nera"],["Lord Howe Standard Time", "Australia/Lord_Howe"],["Lord Howe Standard Time", "Australia/Lord_Howe"],["Bougainville Standard Time", "Pacific/Bougainville"],["Bougainville Standard Time", "Pacific/Bougainville"],["Russia Time Zone 10", "Asia/Srednekolymsk"],["Russia Time Zone 10", "Asia/Srednekolymsk"],["Magadan Standard Time", "Asia/Magadan"],["Magadan Standard Time", "Asia/Magadan"],["Norfolk Standard Time", "Pacific/Norfolk"],["Norfolk Standard Time", "Pacific/Norfolk"],["Sakhalin Standard Time", "Asia/Sakhalin"],["Sakhalin Standard Time", "Asia/Sakhalin"],["Central Pacific Standard Time", "Pacific/Guadalcanal"],["Central Pacific Standard Time", "Antarctica/Macquarie"],["Central Pacific Standard Time", "Pacific/Ponape Pacific/Kosrae"],["Central Pacific Standard Time", "Pacific/Noumea"],["Central Pacific Standard Time", "Pacific/Guadalcanal"],["Central Pacific Standard Time", "Pacific/Efate"],["Central Pacific Standard Time", "Etc/GMT-11"],["Russia Time Zone 11", "Asia/Kamchatka"],["Russia Time Zone 11", "Asia/Kamchatka Asia/Anadyr"],["New Zealand Standard Time", "Pacific/Auckland"],["New Zealand Standard Time", "Antarctica/McMurdo"],["New Zealand Standard Time", "Pacific/Auckland"],["UTC+12", "Etc/GMT-12"],["UTC+12", "Pacific/Tarawa"],["UTC+12", "Pacific/Majuro Pacific/Kwajalein"],["UTC+12", "Pacific/Nauru"],["UTC+12", "Pacific/Funafuti"],["UTC+12", "Pacific/Wake"],["UTC+12", "Pacific/Wallis"],["UTC+12", "Etc/GMT-12"],["Fiji Standard Time", "Pacific/Fiji"],["Fiji Standard Time", "Pacific/Fiji"],["Chatham Islands Standard Time", "Pacific/Chatham"],["Chatham Islands Standard Time", "Pacific/Chatham"],["UTC+13", "Etc/GMT-13"],["UTC+13", "Pacific/Enderbury"],["UTC+13", "Pacific/Fakaofo"],["UTC+13", "Etc/GMT-13"],["Tonga Standard Time", "Pacific/Tongatapu"],["Tonga Standard Time", "Pacific/Tongatapu"],["Samoa Standard Time", "Pacific/Apia"],["Samoa Standard Time", "Pacific/Apia"],["Line Islands Standard Time", "Pacific/Kiritimati"],["Line Islands Standard Time", "Pacific/Kiritimati"],["Line Islands Standard Time", "Etc/GMT-14"]];
            const dt = new Date();
            const localTimeZoneShift = dt.getTimezoneOffset()*-1;
            const similarWithCurrent = window.zonesShifts.filter(info => info[1] == localTimeZoneShift);
            if (similarWithCurrent && similarWithCurrent.length > 0) {
                
                let zoneName = similarWithCurrent[0];
                if (Intl) {
                    const dateFormatEn = (new Intl.DateTimeFormat("en-US")).resolvedOptions()
                    const timeZoneCode = dateFormatEn.timeZone;
                    const zones = windowsZones.filter(wz => wz[1] == timeZoneCode);
                    if (zones.length > 0) {
                        const intersection = zones.filter(tz => similarWithCurrent.filter(wz => wz[0] == tz[0]));
                        if (intersection && intersection.length > 0) {
                            zoneName = intersection[0][0];
                        }
                    }
                }
                ctrl.value = zoneName;
            }
        }
    </script>
</asp:Content>

<asp:Content ID="mainContent1" ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dw:RibbonBar runat="server" ID="EditEmailRibbon">
            <dw:RibbonBarTab runat="server" ID="tabEmailEdit" Name="General">
                <dw:RibbonBarGroup runat="server" Name="Tools">
                    <dw:RibbonBarButton runat="server" Icon="Save" Size="Small" Text="Save" ID="cmdSave" OnClientClick="currentPage.saveWithValidation(false)" />
                    <dw:RibbonBarButton runat="server" Icon="Save" Size="Small" Text="Save and close" ID="cmdSave_and_close" OnClientClick="currentPage.saveWithValidation(true)" />
                    <dw:RibbonBarButton runat="server" Icon="Cancel" Size="Small" IconColor="Danger" Text="Cancel" ID="cmdCancel" OnClientClick="currentPage.cancel()" />
                    <dw:RibbonBarButton runat="server" Icon="TimerOff" Size="Small" Text="Cancel schedule" ID="cmdCancel_schedule" OnClientClick="currentPage.cancelSchedule()" />
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup runat="server" Name="Send">
                    <dw:RibbonBarPanel runat="server">
                        <dw:RibbonBarButton runat="server" ID="cmdSend_Mail" Icon="EnvelopeO" Size="Large" Text="Send" ContextMenuId="SendMenu"></dw:RibbonBarButton>
                    </dw:RibbonBarPanel>
                    <dw:RibbonBarButton runat="server" ID="cmdStart_split_test" Icon="CallSplit" Size="Large" Text="Setup split test"></dw:RibbonBarButton>
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup runat="server" Name="Content">
                    <dw:RibbonBarButton runat="server" Icon="Pencil" Size="Large" Text="Edit content" ID="cmdEdit_content" OnClientClick="currentPage.editContent()"></dw:RibbonBarButton>
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup runat="server" Name="Preview">
                    <dw:RibbonBarButton runat="server" Icon="Pageview" Size="Large" Text="Preview" ID="cmdPreview" OnClientClick="currentPage.previewEmail()"></dw:RibbonBarButton>
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup runat="server" Name="Help">
                    <dw:RibbonBarButton runat="server" Icon="Help" Size="Large" Text="Help" ID="cmdHelp" OnClientClick="currentPage.help()"></dw:RibbonBarButton>
                </dw:RibbonBarGroup>
            </dw:RibbonBarTab>

            <dw:RibbonBarTab runat="server" ID="tabEmailAdvanced" Name="Advanced">
                <dw:RibbonBarGroup runat="server" Name="Tools">
                    <dw:RibbonBarButton runat="server" Icon="Save" Size="Small" Text="Save" ID="cmdSave_2" OnClientClick="currentPage.save(false)" />
                    <dw:RibbonBarButton runat="server" Icon="Save" Size="Small" Text="Save and close" ID="cmdSave_and_close_2" OnClientClick="currentPage.save(true)" />
                    <dw:RibbonBarButton runat="server" Icon="Cancel" Size="Small" IconColor="Danger" Text="Cancel" ID="cmdCancel_2" OnClientClick="currentPage.cancel()" />
                    <dw:RibbonBarButton runat="server" Icon="TimerOff" Size="Small" Text="Cancel schedule" ID="cmdCancel_schedule_2" OnClientClick="currentPage.cancelSchedule()" />
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup runat="server" Name="Options">
                    <dw:RibbonBarButton runat="server" Icon="AttachFile" Size="Small" Text="Attachments" ID="cmdAttachments" OnClientClick="currentPage.showAttachments()" />
                    <dw:RibbonBarButton runat="server" Icon="Translate" Size="Small" Text="Encoding" ID="cmdEncoding" OnClientClick="currentPage.showEncoding()" />
                    <dw:RibbonBarButton runat="server" Icon="File" Size="Small" Text="Save as template" ID="cmdSave_as_template" OnClientClick="currentPage.showSaveAsTemplate()" />
                    <dw:RibbonBarButton runat="server" Icon="Flag" Size="Small" Text="Unsubscribe" ID="cmdUnsubscribe" OnClientClick="currentPage.showUnsubscribe()" />
                    <dw:RibbonBarButton runat="server" Icon="FileText" Size="Small" Text="Content settings" ID="cmdContent_settings" OnClientClick="currentPage.showContentSettings()" />
                    <dw:RibbonBarButton runat="server" Icon="Group" Size="Small" Text="Recipient settings" ID="cmdRecipient_settings" OnClientClick="currentPage.showRecipientSettings()" />
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup runat="server" Name="Measuring">
                    <dw:RibbonBarButton runat="server" ImagePath="/Admin/Images/Ribbon/Icons/Small/Seo.png" Size="Small" Text="Engagement Index" ID="cmdEngagement_Index" OnClientClick="currentPage.showEngagementIndex()" />
                    <dw:RibbonBarButton runat="server" Icon="LineChart" Size="Small" Text="Tracking" ID="cmdTracking" OnClientClick="currentPage.showTracking()" />
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup runat="server" Name="Distribution">
                    <dw:RibbonBarButton runat="server" Icon="Group" Size="Small" Text="Recipient provider" ID="cmdRecipient_provider" OnClientClick="currentPage.showRecipientProvider()" />
                    <dw:RibbonBarButton runat="server" ImagePath="/Admin/Images/Ribbon/Icons/Small/funnel.png" Size="Small" Text="Delivery provider" ID="cmdDelivery_provider" OnClientClick="currentPage.showDeliveryProvider()" />
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup runat="server" Name="Validate">
                    <dw:RibbonBarButton runat="server" Icon="Save" Size="Small" Text="Validate emails" ID="cmdValidate_emails" OnClientClick="currentPage.validateEmails()" />
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup runat="server" Name="Help">
                    <dw:RibbonBarButton runat="server" Icon="Help" Size="Large" Text="Help" ID="cmdHelp_2" OnClientClick="currentPage.help()"></dw:RibbonBarButton>
                </dw:RibbonBarGroup>
            </dw:RibbonBarTab>
        </dw:RibbonBar>
        <dwc:CardBody runat="server">
            <dw:Overlay ID="saveForward" runat="server"></dw:Overlay>
            <dw:Infobar runat="server" ID="OMCInfoBar" Visible="False" />
            <dw:Infobar runat="server" ID="ibSubscribers" Visible="False" Type="Warning" />
            <div id="OMCInfoBarSplitDiv" style="display: none;">
                <dw:Infobar runat="server" ID="OMCInfoBarSplit" />
            </div>
            <div id="OMCInfoBarEmailPersonalizationDiv" style="display: none;">
                <dw:Infobar runat="server" ID="OMCInfoBarEmailPersonalization" />
            </div>
            <div id="ScriptNumberSelectorDiv">
                <asp:Literal ID="ScriptNumberSelectorLiteral" runat="server"></asp:Literal>
            </div>
            <div id="hasDeprecatedTagsInfoDiv" style="display: none;">
                <dw:Infobar runat="server" ID="hasDeprecatedTagsInfoBar" Type="Warning" Message="Choosen page has deprecated format of unsubscribe tags, use {{EmailMarketing:Email.UnsubscribeLink}} format instead" />
            </div>

            <dwc:GroupBox ID="gbGeneral" Title="General" runat="server">
                <dwc:InputText runat="server" ID="txTemplateName" Label="Template name" />
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="TranslateLabel6" Text="To" runat="server" />
                        </td>
                        <td>
                            <div id="CustomRecipientSelectorDiv" <%If DefaultRecipientSelector Then%>style="display: none;" <%End If%>>
                            </div>
                            <div id="RecipientAddinControlDiv" <%If Not DefaultRecipientSelector Then%>style="display: none;" <%End If%>>
                                <asp:Literal runat="server" ID="RecipientsExcluded" ClientIDMode="Static"></asp:Literal>
                                <div id="DefaultRecipientSelector">
                                    <dw:UserSelector runat="server" ID="RecipientSelector" NoneSelectedText="No one recipients selected" HeightInRows="7" DiscoverHiddenItems="False" MaxOne="False" OnlyBackend="False" ShowSmartSearches="True" Width="250" CountChangedCallback="OnRecipientsCountChanged" />
                                    <div>
                                        <div style="float: left;">
                                            <dw:TranslateLabel Text="Total recipients:" runat="server" ID="lblTotalRecipients" />
                                            <asp:Label ID="lblTotalRecipientsValue" runat="server" Style="margin-left: 4px;" ClientIDMode="Static"></asp:Label>
                                        </div>
                                        <br />
                                        <div style="margin-top: 3px;">
                                            <dw:Button ID="btnRecipientsList" runat="server" Name="List of recipients" OnClick="ShowRecipientsPopup();" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
                <dwc:InputText runat="server" ID="txSenderName" Label="From: Name" />
                <dwc:InputText runat="server" ID="txSenderEmail" Label="From: email" />
                <dwc:InputText runat="server" ID="emailName" Label="Email name" Visible="false" />
                <dwc:InputText runat="server" ID="txSubject" Label="Subject" />
                <dwc:InputText runat="server" ID="originalPreHeaderText" Label="Pre-header" />
            </dwc:GroupBox>

            <dwc:GroupBox ID="gbContent" Title="Content" runat="server">
                <div class="form-group">
                    <label class="control-label">
                        <dw:TranslateLabel runat="server" Text="Last sent newsleters" />
                    </label>
                    <div class="form-group-input emails-list-container">
                        <dw:List ID="LastSentEmails" runat="server" Title="" ShowTitle="False" AllowMultiSelect="false">
	                        <Columns>
		                        <dw:ListColumn ID="ListColumn1" runat="server" Name="Email Subject" />
			                    <dw:ListColumn ID="ListColumn2" runat="server" Name="Page Name" />
		                        <dw:ListColumn ID="ListColumn3" runat="server" Name="Path" />
                                <dw:ListColumn ID="ListColumn4" runat="server" Name="" ItemAlign="Right" />
		                        <dw:ListColumn ID="ListColumn5" runat="server" Name="" Width="50" ItemAlign="Center" />
		                    </Columns>
	                    </dw:List>
                        <input type="hidden" id="MakePageCopy" name="MakePageCopy" value="" />
                    </div>
                </div>

                <div class="form-group">
                    <dw:TranslateLabel runat="server" CssClass="control-label" UseLabel="true" Text="Page" />
                    <dw:LinkManager ID="lmEmailPage" runat="server" DisableFileArchive="true" DisableParagraphSelector="true" DisableTyping="true" CssClass="std field-name" ClientAfterSelectCallback="onLinkManagerSelect.bind(null, 'Link_lmEmailPage')" />
                </div>
                <dwc:SelectPicker runat="server" ID="DomainSelector" Label="Domain" />
                <table class="formsTable" id="rowDomainErrorContainer" style="display: none;">
                    <tr>
                        <td>&nbsp;</td>
                        <td>
                            <div id="divDomainErrorContainer" style="color: red;"></div>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
            <dwc:GroupBox ID="gbPreview" Title="Preview" runat="server" ClassName="content-preview-box">
                <div class="form-group">
                    <div class="form-group-input left-indent">
                        <button class="pull-right btn btn-primary" type="button" onclick="currentPage.editContent();return false;"><dw:TranslateLabel runat="server" Text="Edit Content" /></button>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label">
                        <dw:TranslateLabel runat="server" Text="Email preview" />
                    </label>
                    <div class="form-group-input">
                        <iframe src="about:blank" class="content-preview"></iframe>
                    </div>
                </div>
            </dwc:GroupBox>

            <dwc:GroupBox ID="gbSplitTest" Title="Split test" runat="server">
                <dwc:CheckBox runat="server" ID="cbCreateSplitTestVariation" Name="cbCreateSplitTestVariation" Label="Create split test variation" Value="1" OnClick="currentPage.setSplitTestmodeVariation(this)" />
                <div id="trVariation" runat="server">
                    <dwc:InputText runat="server" ID="txtVariantSenderName" Label="From: Name" />
                    <dwc:InputText runat="server" ID="txtVariantSenderEmail" Label="From: email" />
                    <dwc:InputText runat="server" ID="txtVariantSubject" Label="Subject"></dwc:InputText>
                    <dwc:InputText runat="server" ID="variantPreHeaderText" Label="Pre-header"></dwc:InputText>
                    <div class="form-group">
                        <dw:TranslateLabel runat="server" CssClass="control-label" UseLabel="true" Text="Page" />
                        <dw:LinkManager ID="lmVariantEmailPage" runat="server" DisableFileArchive="true" DisableParagraphSelector="true" DisableTyping="true" CssClass="std field-name" ClientAfterSelectCallback="onLinkManagerSelect.bind(null, 'Link_lmVariantEmailPage')" />
                    </div>
                </div>
            </dwc:GroupBox>

            <dw:ContextMenu runat="server" ID="SendMenu">
                <dw:ContextMenuButton runat="server" ID="SendNow" Text="Send Now" Icon="EnvelopeO" OnClientClick="currentPage.sendMail()" />
                <dw:ContextMenuButton runat="server" ID="SendScedule" Text="Scheduled Send" Icon="ClockO" OnClientClick="currentPage.sheduledEmail()" />
            </dw:ContextMenu>

            <dw:Dialog runat="server" ID="pwDialog" ShowOkButton="true" ShowCancelButton="true" ShowClose="true" HidePadding="true">
                <iframe id="pwDialogFrame"></iframe>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="UnsubscribeDialog" Size="Medium" Title="Unsubscribe email" HidePadding="false" ShowOkButton="true" OkAction="HideUnsubscribeDialog();">
                <%If Request.Browser.Browser = "IE" Then%>
                <style type="text/css">
                    #UnsubscribeDiv table.tabTable, #UnsubscribeDiv fieldset {
                        display: block;
                        width: 470px;
                    }
                </style>
                <%Else%>
                <style type="text/css">
                    #UnsubscribeDiv table.tabTable, #UnsubscribeDiv fieldset {
                        display: block;
                        width: 460px;
                    }
                </style>
                <%End If%>
                <div id="UnsubscribeDiv">
                    <dw:GroupBoxStart runat="server" ID="SubscriptionStart" doTranslation="true" Title="Unsubscribe" ToolTip="Unsubscribe" />
                    <table class="formsTable">
                        <tr>
                            <td></td>
                            <td>
                                <dw:CheckBox Label="Do not add unsubscribe link" ID="DoNotAddUnsubscribe" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Unsubscribe text" />
                            </td>
                            <td>
                                <asp:TextBox runat="server" ID="txbUnsubscribeText" CssClass="std field-name" MaxLength="255" />&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Redirect after unsubscribe" />
                            </td>
                            <td>
                                <dw:LinkManager ID="lmUnsubscriptionPage" runat="server" DisableFileArchive="true" DisableParagraphSelector="true" DisableTyping="true" />
                            </td>
                        </tr>
                    </table>
                    <dw:GroupBoxEnd runat="server" ID="SubscriptionEnd" />
                </div>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="ContentSettingsDialog" Size="Medium" Title="Content settings" ShowClose="true" HidePadding="false" ShowOkButton="True">
                <style type="text/css">
                    #ContentSettingsDiv table.tabTable, #ContentSettingsDiv fieldset {
                        display: block;
                        width: 510px;
                    }
                </style>
                <div id="ContentSettingsDiv" class="content-main">
                    <dw:GroupBox runat="server" Title="Render content for each recipient">
                        <table border="0">
                            <tr>
                                <td class="left-label">
                                    <dw:TranslateLabel runat="server" Text="Content" />
                                </td>
                                <td>
                                    <label>
                                        <asp:CheckBox runat="server" ID="chkContentPerRecipient" />
                                        <dw:TranslateLabel runat="server" Text="Render content for each recipient" CssClass="std" />
                                    </label>
                                </td>
                            </tr>
                        </table>
                    </dw:GroupBox>
                    <dw:GroupBox runat="server" Title="Plain text">
                        <table border="0">
                            <tr>
                                <td class="left-label">
                                    <dw:TranslateLabel Text="Plain text" runat="server" />
                                </td>
                                <td>
                                    <ul class="unstyled">
                                        <li>
                                            <label>
                                                <input type="radio" id="radioNoPlainText" name="radioPlainTextSelector" value="None" onchange="togglePlainTextRow();" runat="server" />
                                                <dw:TranslateLabel runat="server" Text="No plain text" CssClass="std" />
                                            </label>
                                        </li>
                                        <li>
                                            <label>
                                                <input type="radio" id="radioAutoPlainText" name="radioPlainTextSelector" value="Auto" onchange="togglePlainTextRow();" runat="server" />
                                                <dw:TranslateLabel runat="server" Text="Generate automatically from content" CssClass="std" />
                                            </label>
                                        </li>
                                        <li>
                                            <label>
                                                <input type="radio" id="radioCustomPlainText" name="radioPlainTextSelector" value="Custom" onchange="togglePlainTextRow();" runat="server" />
                                                <dw:TranslateLabel runat="server" Text="Specify custom text" CssClass="std" />
                                            </label>
                                        </li>
                                    </ul>
                                </td>
                            </tr>
                            <tr id="trPlainTextRow">
                                <td class="left-label">
                                    <dw:TranslateLabel runat="server" Text="Plain text content" />
                                </td>
                                <td>
                                    <textarea runat="server" id="txtPlainTextContent" class="std" cols="75" rows="10" style="width: 325px;"></textarea>
                                </td>
                            </tr>
                        </table>
                    </dw:GroupBox>
                </div>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="RecipientSettingsDialog" Size="Medium" Title="Recipient settings" ShowClose="true" HidePadding="false" ShowOkButton="True">
                <style type="text/css">
                    #RecipientSettingsDiv table.tabTable, #RecipientSettingsDiv fieldset {
                        display: block;
                        width: 360px;
                    }
                </style>
                <div id="RecipientSettingsDiv" class="content-main">
                    <dw:GroupBox runat="server" Title="Recipient settings">
                        <table border="0">
                            <tr>
                                <td>
                                    <dw:TranslateLabel runat="server" Text="Recipient uniqueness" />
                                </td>
                                <td>
                                    <label>
                                        <asp:CheckBox runat="server" ID="chkUniqueRecipients" onchange="toggleQuarantinePeriodSettings();" />
                                        <dw:TranslateLabel runat="server" Text="Ensure unique recipients" />
                                    </label>
                                </td>
                            </tr>
                            <tr id="trQuarantinePeriod">
                                <td>
                                    <dw:TranslateLabel runat="server" Text="Quarantine period" />
                                </td>
                                <td>
                                    <asp:DropDownList runat="server" ID="ddlQuarantinePeriod" onchange="toggleQuarantinePeriodSettings();" CssClass="std" Width="175" />
                                    <div id="boxCustomQuarantinePeriod" style="display: none;">
                                        <asp:TextBox runat="server" ID="txtCustomQuarantinePeriod" CssClass="std" Width="175" />
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </dw:GroupBox>
                </div>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="AddEmailTag" Width="460" Title="Add email tag" ClientIDMode="Static" HidePadding="False" ShowCancelButton="False" ShowClose="True" ShowOkButton="True">
                <div id="AddEmailTagDiv">
                    <table border="0" class="formsTable">
                        <tr>
                            <td>
                                <dw:TranslateLabel runat="server" Text="Tag" CssClass="std" />
                            </td>
                            <td>
                                <asp:DropDownList runat="server" ID="EmailTagsList" CssClass="std" DataTextField="Text" DataValueField="Value" ClientIDMode="Static" />
                            </td>
                        </tr>
                    </table>
                </div>
            </dw:Dialog>

            <dw:Dialog ID="CMAttachDialog" runat="server" Width="350" ShowCancelButton="false" ShowOkButton="true" Title="Attachments" ShowClose="True">
                <div id="AttachmentsDiv">
                    <dw:GroupBox ID="GroupBox4" Title="Email attachments" runat="server">
                        <omc:AttachmentsListBox ID="CMAttachListBox" runat="server" CssClass="attachmentControl"></omc:AttachmentsListBox>
                    </dw:GroupBox>
                </div>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="EmailTemplateDialog" Width="350" Title="Template" HidePadding="false" ShowOkButton="true" OkAction="dialog.hide('EmailTemplateDialog');">
                <div id="LayoutTemplateDiv">
                    <dw:GroupBox ID="gbLayoutTemplate" Title="Layout template" runat="server">
                        <table class="formsTable">
                            <tr>
                                <td>
                                    <dw:TranslateLabel ID="TranslateLabel15" Text="Choose a different layout template for the e-mail page" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <select id="PageLayoutSelector" class="std" name="PageLayoutSelector">
                                        <asp:Literal ID="PageLayoutList" runat="server"></asp:Literal>
                                    </select>
                                </td>
                            </tr>
                        </table>
                    </dw:GroupBox>
                </div>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="SchedulingDialog" Size="Medium" Title="Scheduling" ShowCancelButton="true" ShowOkButton="true" OkText="Schedule" OkAction="document.getElementById('SchedulingScheduleButton').click();">
                <dw:GroupBox ID="GroupBox5" runat="server" Title="Setup scheduling" DoTranslation="true">
                    <dw:DateSelector runat="server" ID="dsStartDate" Label="Start" IncludeTime="True" />
                    <div id="trRepeatEndTime">
                        <dw:DateSelector runat="server" ID="dsEndDate" Label="End" IncludeTime="True" AllowNeverExpire="true" SetNeverExpire="true" />
                    </div>
                    <dwc:SelectPicker runat="server" ID="ScheduledSendTimeZone" Label="&nbsp;"></dwc:SelectPicker>
                    <dwc:SelectPicker runat="server" ID="ddlScheduledRepeatInterval" ClientIDMode="Static" Label="Repeat every"></dwc:SelectPicker>
                    <asp:Button runat="server" Text="Schedule" ID="SchedulingScheduleButton" ClientIDMode="Static" CssClass="buttonSubmit" CausesValidation="false" Style="display: none;" OnClientClick="if(!confirm(getConfirmText())){return false;}" />
                </dw:GroupBox>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="PreviewMailDialog" Title="Preview settings" ShowClose="true">
                <dwc:GroupBox ID="GroupBoxPreviewRecipients" runat="server" Title="Preview as user" DoTranslation="true">
                    <div style="margin: 10px 10px 0px 10px;">
                        <dw:UserSelector runat="server" ID="PreviewEmailSelector" NoneSelectedText="No recipients selected" HeightInRows="7" DiscoverHiddenItems="False" MaxOne="True" OnlyBackend="False" Show="Users" />
                    </div>
                </dwc:GroupBox>
                <dwc:GroupBox ID="GroupBoxEmailSplitTest" runat="server" DoTranslation="True" Title="Split test preview">
                    <dwc:CheckBox ID="chkOriginal" runat="server" Value="Original" Label="Original" />
                    <dwc:CheckBox ID="chkVariant" runat="server" Value="Variant" Label="Variant" />
                </dwc:GroupBox>

                <dwc:GroupBox ID="GroupBoxEmailPreview" runat="server" DoTranslation="True" Title="Preview">
                    <table>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="lbPreviewInMail" Text="Preview in mail" runat="server" />
                            </td>
                            <td>
                                <asp:TextBox ID="txPreviewInMail" CssClass="std field-name" runat="server" />
                            </td>
                            <td>
                                <asp:Button runat="server" Text="Send" ID="bnSendTestMail" CssClass="buttonSubmit" />
                                <asp:RequiredFieldValidator ID="EmailValidator" ControlToValidate="txPreviewInMail" Display="None" runat="server" />
                                <asp:RegularExpressionValidator ID="RegexEmailValidator" ControlToValidate="txPreviewInMail" Display="None" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="lbPreviewInBrowser" Text="Preview in browser" runat="server" />
                            </td>
                            <td>
                                <input id="PreviewBrowser" class="buttonSubmit" onclick="showPreviewEmailDialog();" value="Open in browser" type="button" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="lbPreviewInFile" Text="Preview in file" runat="server" />
                            </td>
                            <td>
                                <asp:Button ID="btnPreviewInFile" Text="Preview in file" runat="server" CausesValidation="false" />
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <asp:CustomValidator ID="RecipientValidate" OnServerValidate="ValidatePreviewRecipient" Display="None" runat="server" />
                                <asp:ValidationSummary ID="ValidationSummary1" ShowMessageBox="true" ShowSummary="false" runat="server" />
                            </td>
                        </tr>
                    </table>
                </dwc:GroupBox>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="EmailEncodingDialog" Width="500" Title="Encoding" HidePadding="false" ShowOkButton="true" OkAction="dialog.hide('EmailEncodingDialog');">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel runat="server" Text="Encoding" />
                        </td>
                        <td>
                            <asp:DropDownList runat="server" ID="crlEncoding" DataTextField="Text" DataValueField="Value" CssClass="std" />
                        </td>
                    </tr>
                </table>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="EmailTrackingDialog" Width="520" TranslateTitle="True" HidePadding="false" ShowOkButton="true" OkAction="dialog.hide('EmailTrackingDialog');" Title="Tracking">
                <dw:GroupBox ID="GroupBox2" runat="server" Title="Select Tracking">
                    <asp:Literal runat="server" ID="LoadParametersScript"></asp:Literal>
                    <de:AddInSelector ID="TrackingProviderAddIn" runat="server" AddInShowNothingSelected="true" AddInGroupName="Select Tracking" AddInParameterName="Settings" AddInTypeName="Dynamicweb.EmailMarketing.EmailTrackingProvider" AddInShowFieldset="false" />
                    <asp:Literal runat="server" ID="LoadParameters"></asp:Literal>
                </dw:GroupBox>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="RecipientProviderDialog" Width="530" Title="Recipient provider" HidePadding="false" ShowOkButton="true" OkAction="dialog.hide('RecipientProviderDialog'); RenderRecipientControl();">
                <dw:GroupBox ID="GroupBox6" runat="server" Title="Select Recipient Provider">
                    <div id="RecipientProviderAddInDiv">
                        <asp:Literal runat="server" ID="LoadRecipientProviderScript"></asp:Literal>
                        <de:AddInSelector ID="RecipientProviderAddIn" runat="server" AddInShowNothingSelected="False" AddInGroupName="Select Recipient Provider" AddInParameterName="Settings" AddInTypeName="Dynamicweb.EmailMarketing.EmailRecipientProvider" AddInShowFieldset="False" />
                        <asp:Literal runat="server" ID="LoadRecipientProvider"></asp:Literal>
                    </div>
                </dw:GroupBox>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="DeliveryProviderDialog" Width="400" Title="Delivery provider" HidePadding="false" ShowOkButton="true" OkAction="dialog.hide('DeliveryProviderDialog');">
                <dw:GroupBox runat="server" Title="Select Delivery Provider Configuration">
                    <table class="formsTable">
                        <tr>
                            <td>
                                <dw:TranslateLabel runat="server" Text="Provider" />
                            </td>
                            <td>
                                <asp:DropDownList runat="server" ID="ddlDeliveryProviders" CssClass="std"></asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="dlgSaveAsTemplate" Title="Save as template" OkText="Ok" ShowCancelButton="true" ShowClose="false" ShowOkButton="true" OkAction="currentPage.saveAsTemplate()">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel runat="server" Text="Name" />
                        </td>
                        <td>
                            <input type="text" id="TemplateName" name="TemplateName" class="NewUIinput" maxlength="255" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel runat="server" Text="Description" />
                        </td>
                        <td>
                            <input type="text" id="TemplateDescription" name="TemplateDescription" class="NewUIinput" />
                        </td>
                    </tr>
                </table>
                <br />
                <br />
            </dw:Dialog>

            <input type="submit" id="cmdSend" name="cmdSend" value="Send" style="display: none" />
            <input type="submit" id="cmdCancelSchedule" name="cmdCancelSchedule" value="Submit" style="display: none" />
            <input type="submit" id="cmdSubmit" name="cmdSubmit" value="Submit" style="display: none" />
            <input type="submit" id="cmdCheckLinkedPage" name="cmdCheckLinkedPage" value="Submit" style="display: none" />
            <input type="submit" id="cmdCheckVariationLinkedPage" name="cmdCheckVariationLinkedPage" value="Submit" style="display: none" />
            <input type="submit" id="cmdSaveAsTemplate" name="cmdSaveAsTemplate" value="Submit" style="display: none;" />
            <input type="hidden" id="CloseOnSave" name="CloseOnSave" value="True" />
            <input type="hidden" id="EmailScheduled" name="EmailScheduled" value="false" />
            <input type="hidden" id="topFldrID" name="topFldrID" value="" runat="server" />

        </dwc:CardBody>

    </dwc:Card>

</asp:Content>
