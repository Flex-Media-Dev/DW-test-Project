<?xml version="1.0" encoding="utf-8" ?>
<updates>
	<!--
	    Remember to update the corresponding versionnumber in AssemblyInfo.vb (AssemblyInformationalVersionAttribute). 
        Rules for version number can be found there as well.
	-->
    <current version="2147" releasedate="31-08-2020" internalversion="9.9.0.0" />

    <package version="2147" releasedate="31-08-2020">
        <database file="Dynamic.mdb">
            <GridRow>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='GridRow' AND COLUMN_NAME='GridRowMasterRowId'">
                    ALTER TABLE [GridRow] ADD [GridRowMasterRowId] INT NOT NULL DEFAULT 0;
                </sql>
            </GridRow>
        </database>
    </package>

    <package version="2146" releasedate="17-08-2020">
        <file name="DefaultAddressFormats.xml" source="/Files/System/CountryFormat" target="/Files/System/CountryFormat" overwrite="true" />
    </package>

    <package version="2145" date="22-06-2020">
		<database file="Dynamic.mdb">
		    <SettingPresetAccessUserRelation>
			    <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='SettingPresetAccessUserRelation'">
                    CREATE TABLE [SettingPresetAccessUserRelation](
                        [PresetRelationPresetId] [int] NOT NULL,
	                    [PresetRelationUserId] [int] NOT NULL,
                        CONSTRAINT [PK_SettingPresetAccessUserRelation] PRIMARY KEY CLUSTERED ([PresetRelationPresetId] ASC, [PresetRelationUserId] ASC)
                    )
			    </sql>
		    </SettingPresetAccessUserRelation>
		    <SettingPreset>
			    <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='SettingPreset'">
                    CREATE TABLE [SettingPreset](
	                    [PresetId] [int] IDENTITY(1,1) NOT NULL,
                        [PresetTarget] [nvarchar](255) NOT NULL,
                        [PresetName] [nvarchar](255) NOT NULL,
                        CONSTRAINT [PK_SettingPreset] PRIMARY KEY CLUSTERED ([PresetId] ASC)
                    )
			    </sql>
		    </SettingPreset>
		    <SettingPresetValues>
			    <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='SettingPresetValues'">
                    CREATE TABLE [SettingPresetValues](
	                    [PresetValuesPresetId] [int] NOT NULL,
                        [PresetValuesKey] [nvarchar](255) NOT NULL,
	                    [PresetValuesValue] [nvarchar](max) NULL,
                        CONSTRAINT [PK_SettingPresetValues] PRIMARY KEY CLUSTERED ([PresetValuesPresetId] ASC, [PresetValuesKey] ASC)
                    )
			    </sql>
		    </SettingPresetValues>
		</database>
    </package>

    <package version="2144" releasedate="01-06-2020">
        <database file="Dynamic.mdb">
            <GridRow>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='GridRow' AND COLUMN_NAME='GridRowUniqueId'">
                    ALTER TABLE [GridRow] ADD [GridRowUniqueId] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID();
                </sql>
            </GridRow>
        </database>
    </package>

    <package version="2143" releasedate="25-05-2020">
        <database file="Dynamic.mdb">
            <ItemList>
                <sql conditional="">
                    ALTER TABLE [ItemList] ADD [ItemListIsChangedOnLanguage] [BIT] NOT NULL DEFAULT 0;
                </sql>
            </ItemList>
        </database>
    </package>

     <package version="2142" date="22-05-2020">
		<database file="Dynamic.mdb">
		    <OrderState>
			    <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomOrderStates' AND COLUMN_NAME='OrderStateSendToDeliveryEmail'">
                    ALTER TABLE [EcomOrderStates] ADD [OrderStateSendToDeliveryEmail] [BIT] NULL
			    </sql>
                 <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomOrderStates' AND COLUMN_NAME='OrderStateSendToField'">
                    ALTER TABLE [EcomOrderStates] ADD [OrderStateSendToField] [BIT] NULL
			    </sql>
                 <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomOrderStates' AND COLUMN_NAME='OrderStateCustomRecipientField'">
                    ALTER TABLE [EcomOrderStates] ADD [OrderStateCustomRecipientField] [nvarchar](255) NULL
			    </sql>
		    </OrderState>
		</database>
    </package>

    <package version="2141" releasedate="21-04-2020">        
        <file name="ModalDialogWarning_Categories.cshtml" source="/Files/Templates/CookieWarning" target="/Files/Templates/CookieWarning" overwrite="false" />
    </package>

    <package version="2140" date="14-04-2020">
		<database file="Dynamic.mdb">
		    <GridRow>
			    <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='GridRow' AND COLUMN_NAME='GridRowHideForPhones'">
                    ALTER TABLE [GridRow] ADD [GridRowHideForPhones] [BIT] NULL
			    </sql>	
			   <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='GridRow' AND COLUMN_NAME='GridRowHideForTablets'">
                    ALTER TABLE [GridRow] ADD [GridRowHideForTablets] [BIT] NULL
			    </sql>	
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='GridRow' AND COLUMN_NAME='GridRowHideForDesktops'">
                    ALTER TABLE [GridRow] ADD [GridRowHideForDesktops] [BIT] NULL
			    </sql>	
		    </GridRow>
		</database>
    </package>

    <package version="2139" releasedate="16-03-2020">
        <database file="Dynamic.mdb">
		    <FormField>
			    <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='FormField' AND COLUMN_NAME='FormFieldTitle'">
                    ALTER TABLE [FormField] ADD [FormFieldTitle] [nvarchar](255) NULL;
			    </sql>			  
		    </FormField>
		</database>
    </package>

    <package version="2138" releasedate="13-03-2020">
        <database file="Dynamic.mdb">
		    <Discount>
			    <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomDiscount' AND COLUMN_NAME='DiscountCheckForValidationReason'">
                    ALTER TABLE [EcomDiscount] ADD [DiscountCheckForValidationReason] [BIT] NULL;
			    </sql>			  
		    </Discount>
		</database>
    </package>

    <package version="2137" releasedate="12-03-2020">
        <database file="Dynamic.mdb">
		    <Area>
			    <sql>
                    ALTER TABLE AccessUserAddress ALTER COLUMN AccessUserAddressCell NVARCHAR (255)
			    </sql>			  
		    </Area>
		</database>
    </package>

    <package version="2136" releasedate="12-03-2020">
        <database file="Dynamic.mdb">
		    <FormField>
			    <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='FormField' AND COLUMN_NAME='FormFieldInputPattern'">
                    ALTER TABLE [FormField] ADD [FormFieldInputPattern] [nvarchar](255) NULL;
			    </sql>			  
		    </FormField>
		</database>
    </package>

    <package version="2135" releasedate="02-03-2020">
        <database file="Dynamic.mdb">
		    <Area>
			    <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Area' AND COLUMN_NAME='AreaPublished'">
                    ALTER TABLE [Area] ADD [AreaPublished] [BIT] NOT NULL DEFAULT 1;
			    </sql>			  
		    </Area>
		</database>
    </package>

    <package version="2134" releasedate="11-02-2020">
        <file name="default.json" source="/Files/System/Editor/tinymce/config/" target="/Files/System/Editor/tinymce/config/" overwrite="true" />
    </package>

    <package version="2133" date="22-01-2020">
        <database file="Dynamic.mdb">
            <AccessUser>              
	            <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='AccessUser' AND COLUMN_NAME='AccessUserProfileCreatedDate'">
                    ALTER TABLE [AccessUser] ADD [AccessUserProfileCreatedDate] [datetime] NULL;
                </sql>
            </AccessUser>
        </database>
    </package>

    <package version="2132" date="15-01-2020">
		<database file="Dynamic.mdb">
		    <GridRow>
			    <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='GridRow' AND COLUMN_NAME='GridRowIsTemplate'">
                    ALTER TABLE [GridRow] ADD [GridRowIsTemplate] [BIT] NULL
			    </sql>	
			    <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='GridRow' AND COLUMN_NAME='GridRowTemplateName'">
                    ALTER TABLE [GridRow] ADD [GridRowTemplateName] [nvarchar](255) NULL
			    </sql>	
			    <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='GridRow' AND COLUMN_NAME='GridRowTemplateDescription'">
                    ALTER TABLE [GridRow] ADD [GridRowTemplateDescription] [nvarchar](255) NULL
			    </sql>	
			    <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='GridRow' AND COLUMN_NAME='GridRowTemplateImage'">
                    ALTER TABLE [GridRow] ADD [GridRowTemplateImage] [nvarchar](255) NULL
			    </sql>	
		    </GridRow>
		</database>
    </package>

    <package version="2131" releasedate="13-01-2020">
        <database file="Dynamic.mdb">
            <DataIntegration>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Endpoint' AND COLUMN_NAME='EndpointUseInLiveIntegration'">
                    ALTER TABLE [Endpoint] ADD [EndpointUseInLiveIntegration] [BIT] NULL
                </sql>
            </DataIntegration>
        </database>
    </package>

      <package version="2130" date="26-12-2019">
		<database file="Dynamic.mdb">
		    <Page>
			    <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Page' AND COLUMN_NAME='PageTemplateImage'">
                    ALTER TABLE [Page] ADD [PageTemplateImage] [nvarchar](255) NULL
			    </sql>			  
		    </Page>
		</database>
    </package>

    <package version="2129" date="20-12-2019">
		<database file="Dynamic.mdb">
		    <Paragraph>
			    <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Paragraph' AND COLUMN_NAME='ParagraphIsTemplate'">
                    ALTER TABLE [Paragraph] ADD [ParagraphIsTemplate] [BIT] NULL
			    </sql>
			    <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Paragraph' AND COLUMN_NAME='ParagraphTemplateDescription'">
                    ALTER TABLE [Paragraph] ADD [ParagraphTemplateDescription] [nvarchar](255) NULL
			    </sql>
		    </Paragraph>
		</database>
    </package>

    <package version="2128" releasedate="18-12-2019">
        <database file="Dynamic.mdb">
            <ScheduledTask>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='ScheduledTask' AND COLUMN_NAME = 'TaskLastResult'">
                    ALTER TABLE [ScheduledTask] ADD [TaskLastResult] BIT NULL
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='ScheduledTask' AND COLUMN_NAME = 'TaskCheckPrevious'">
                    ALTER TABLE [ScheduledTask] ADD [TaskCheckPrevious] BIT NULL
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='ScheduledTask' AND COLUMN_NAME = 'TaskSort'">
                    ALTER TABLE [ScheduledTask] ADD [TaskSort] INT NULL
                </sql>
            </ScheduledTask>
        </database>
    </package>

    <package version="2127" releasedate="21-11-2019">        
        <file name="Visitors - Most viewed pages.xml" source="/Files/System/OMC/Marketing reports/Visits/Behavior" target="/Files/System/OMC/Marketing reports/Visits/Behavior" overwrite="false" />
    </package>

    <package version="2126" date="20-11-2019">
		<database file="Dynamic.mdb">
		    <ContentBuilder>
			    <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='GridRow'">
                    CREATE TABLE [GridRow](
	                    [GridRowId] [int] IDENTITY(1,1) NOT NULL,
                        [GridRowPageId] [int] NOT NULL,
	                    [GridRowActive] [bit] NOT NULL,
                        [GridRowContainer] [nvarchar](max) NULL,
                        [GridRowDefinitionId] [nvarchar](255) NOT NULL,
	                    [GridRowItemType] [nvarchar](255) NULL,
	                    [GridRowItemId] [nvarchar](255) NULL,
                        [GridRowSort] [int] NOT NULL,
                        [GridRowValidFrom] [datetime] NULL,
                        [GridRowValidTo] [datetime] NULL,
                        [GridRowCreatedAt] [datetime] NULL,
                        [GridRowCreatedBy] [int] NULL,
                        [GridRowUpdatedAt] [datetime] NULL,
                        [GridRowUpdatedBy] [int] NULL
                        CONSTRAINT [PK_GridRow] PRIMARY KEY CLUSTERED ([GridRowId] ASC)
                    )
			    </sql>
		    </ContentBuilder>
		</database>
    </package>

    <package version="2125" date="20-11-2019">
		<database file="Dynamic.mdb">
		    <ContentBuilder>
			    <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Paragraph' AND COLUMN_NAME='ParagraphGridRowId'">
                    ALTER TABLE [Paragraph] ADD [ParagraphGridRowId] [INT] NULL
			    </sql>
			    <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Paragraph' AND COLUMN_NAME='ParagraphGridRowColumn'">
                    ALTER TABLE [Paragraph] ADD [ParagraphGridRowColumn] [INT] NULL
			    </sql>
		    </ContentBuilder>
		</database>
    </package>
    
    <package version="2124" date="13-11-2019">
		<database file="Dynamic.mdb">
		    <area>
			    <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Area' AND COLUMN_NAME='AreaReverseChargeForVat'">
                    ALTER TABLE [Area] ADD [AreaReverseChargeForVat] BIT NULL
			    </sql>
		    </area>
		</database>
	</package>
    
    <package version="2123" releasedate="12-11-2019">
        <database file="Dynamic.mdb">
            <AccessUser>              
	            <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='AccessUser' AND COLUMN_NAME='AccessUserReverseChargeForVat'">
                    ALTER TABLE [AccessUser] ADD [AccessUserReverseChargeForVat] [BIT] NOT NULL DEFAULT 0;
                </sql>
            </AccessUser>
        </database>
    </package>

    <package version="2122" date="08-11-2019">
		<database file="Dynamic.mdb">
		    <EmailMarketing>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EmailMarketingFlow' AND COLUMN_NAME='EmailMarketingFlowActive'">
                    ALTER TABLE [EmailMarketingFlow] ADD [EmailMarketingFlowActive] [BIT] NOT NULL DEFAULT 0;
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EmailMarketingFlow' AND COLUMN_NAME='EmailMarketingFlowStartDate'">
                    ALTER TABLE [EmailMarketingFlow] ADD [EmailMarketingFlowStartDate] [datetime] NOT NULL;
			    </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EmailMarketingFlow' AND COLUMN_NAME='EmailMarketingFlowCreatedDate'">
                    ALTER TABLE [EmailMarketingFlow] ADD [EmailMarketingFlowCreatedDate] [datetime] NOT NULL;
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EmailMarketingFlow' AND COLUMN_NAME='EmailMarketingFlowUpdatedDate'">
                    ALTER TABLE [EmailMarketingFlow] ADD [EmailMarketingFlowUpdatedDate] [datetime] NOT NULL;
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EmailMarketingFlow' AND COLUMN_NAME='EmailMarketingFlowRecipientsUpdateTime'">
                    ALTER TABLE [EmailMarketingFlow] ADD [EmailMarketingFlowRecipientsUpdateTime] [datetime] NULL;
                </sql>
			    <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EmailMarketingFlowRecipient'">
                    CREATE TABLE [EmailMarketingFlowRecipient](
	                    [EmailMarketingFlowRecipientId] [int] IDENTITY(1,1) NOT NULL,
	                    [EmailMarketingFlowRecipientFlowId] [int] NOT NULL,
                        [EmailMarketingFlowRecipientUserId] [int] NOT NULL,
	                    [EmailMarketingFlowRecipientDiscoveryTimestamp] [datetime] NOT NULL,
                        [EmailMarketingFlowRecipientLastProcessedStepId] [int] NULL,
                        [EmailMarketingFlowRecipientLastProcessedStepTime] [datetime] NULL
                        CONSTRAINT [PK_EmailMarketingFlowRecipient] PRIMARY KEY CLUSTERED ([EmailMarketingFlowRecipientId] ASC)
                    )
			    </sql>
			    <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EmailMarketingFlowStepHistory'">
                    CREATE TABLE [EmailMarketingFlowStepHistory](
	                    [EmailMarketingFlowStepHistoryId] [int] IDENTITY(1,1) NOT NULL,
	                    [EmailMarketingFlowStepHistoryFlowId] [int] NOT NULL,
                        [EmailMarketingFlowStepHistoryRecipientId] [int] NOT NULL,
                        [EmailMarketingFlowStepHistoryStepId] [int] NOT NULL,
                        [EmailMarketingFlowStepHistoryEmailRecipientId] [int] NOT NULL,
	                    [EmailMarketingFlowStepHistoryTimestamp] [datetime] NOT NULL
                        CONSTRAINT [PK_EmailMarketingFlowStepHistory] PRIMARY KEY CLUSTERED ([EmailMarketingFlowStepHistoryId] ASC)
                    )
			    </sql>
		    </EmailMarketing>
		</database>
    </package>

    <package version="2121" releasedate="30-10-2019">        
        <file name="Visitors - Campaign.xml" source="/Files/System/OMC/Marketing reports/Visits/Acquisition" target="/Files/System/OMC/Marketing reports/Visits/Acquisition" overwrite="false" />
        <file name="Visitors - Referrer type.xml" source="/Files/System/OMC/Marketing reports/Visits/Acquisition" target="/Files/System/OMC/Marketing reports/Visits/Acquisition" overwrite="false" />
        <file name="Visitors - Referrer.xml" source="/Files/System/OMC/Marketing reports/Visits/Acquisition" target="/Files/System/OMC/Marketing reports/Visits/Acquisition" overwrite="false" />
        <file name="Visitors - New vs Returning.xml" source="/Files/System/OMC/Marketing reports/Visits/Behavior" target="/Files/System/OMC/Marketing reports/Visits/Behavior" overwrite="false" />
        <file name="Visitors - Country.xml" source="/Files/System/OMC/Marketing reports/Visits/Geo" target="/Files/System/OMC/Marketing reports/Visits/Geo" overwrite="false" />
        <file name="Visitors - Device.xml" source="/Files/System/OMC/Marketing reports/Visits/Technology" target="/Files/System/OMC/Marketing reports/Visits/Technology" overwrite="false" />
        <file name="Visitors - Day.xml" source="/Files/System/OMC/Marketing reports/Visits/Overview" target="/Files/System/OMC/Marketing reports/Visits/Overview" overwrite="false" />
        <file name="Visitors - Time of day.xml" source="/Files/System/OMC/Marketing reports/Visits/Overview" target="/Files/System/OMC/Marketing reports/Visits/Overview" overwrite="false" />
        <file name="Visitors - Website.xml" source="/Files/System/OMC/Marketing reports/Visits/Overview" target="/Files/System/OMC/Marketing reports/Visits/Overview" overwrite="false" />
        <file name="Visitors - Year.xml" source="/Files/System/OMC/Marketing reports/Visits/Overview" target="/Files/System/OMC/Marketing reports/Visits/Overview" overwrite="false" />
    </package>

    <package version="2120" date="24-10-2019">
		<database file="Dynamic.mdb">
		    <EmailMarketing>
			    <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EmailMarketingFlowStep'">
                    CREATE TABLE [EmailMarketingFlowStep](
	                    [EmailMarketingFlowStepId] [int] IDENTITY(1,1) NOT NULL,
	                    [EmailMarketingFlowStepFlowId] [int] NOT NULL,
	                    [EmailMarketingFlowStepEmailId] [int] NOT NULL,
                        [EmailMarketingFlowStepDelayUnit] [int] NOT NULL,
                        [EmailMarketingFlowStepDelay] [int] NOT NULL
                        CONSTRAINT [PK_EmailMarketingFlowStep] PRIMARY KEY CLUSTERED ([EmailMarketingFlowStepId] ASC)
                    )
			    </sql>
		    </EmailMarketing>
		</database>
    </package>

    <package version="2119" date="24-10-2019" RunOnce="True">
        <database file="Dynamic.mdb">
            <NonBrowserSession>
                 <sql conditional="">
                    WITH duplicateNonBrowserSessions AS (
                        SELECT
                            SessionId,
                            SessionSessionId,
                            ROW_NUMBER() OVER (
                                PARTITION BY
                                    SessionSessionId
                                ORDER BY
                                    SessionSessionId
                            ) row_num
                        FROM  NonBrowserSession
                    ) DELETE FROM NonBrowserSession WHERE SessionId IN (SELECT SessionId FROM duplicateNonBrowserSessions WHERE row_num > 1)
                </sql>                      
            </NonBrowserSession>
        </database>
    </package>

    <package version="2118" date="23-10-2019">
        <database file="Dynamic.mdb">
            <AccessUserExternalLogin>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='ExternalLoginProvider' AND COLUMN_NAME='ProviderEnableForBackend'">
                    ALTER TABLE [ExternalLoginProvider] ADD [ProviderEnableForBackend] [BIT] NOT NULL DEFAULT 0;
                </sql>
            </AccessUserExternalLogin>
        </database>
    </package>

    <package version="2117" date="21-10-2019">
		<database file="Dynamic.mdb">
		    <EmailMarketing>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EmailMarketingFlow' AND COLUMN_NAME='EmailMarketingFlowRecipientsIds'">
                    ALTER TABLE [EmailMarketingFlow] ADD [EmailMarketingFlowRecipientsIds] [nvarchar](MAX) NULL;
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EmailMarketingFlow' AND COLUMN_NAME='EmailMarketingFlowStopAddingNewRecipients'">
                    ALTER TABLE [EmailMarketingFlow] ADD [EmailMarketingFlowStopAddingNewRecipients] [BIT] NOT NULL DEFAULT 0;
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EmailMarketingFlow' AND COLUMN_NAME='EmailMarketingFlowScheduledRepeatInterval'">
                    ALTER TABLE [EmailMarketingFlow] ADD [EmailMarketingFlowScheduledRepeatInterval] [INT] NULL;
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EmailMarketingFlow' AND COLUMN_NAME='EmailMarketingFlowProcessOnlyFlowRecipients'">
                    ALTER TABLE [EmailMarketingFlow] ADD [EmailMarketingFlowProcessOnlyFlowRecipients] [BIT] NOT NULL DEFAULT 0;
                </sql>
		    </EmailMarketing>
		</database>
	</package>


    ''
    <package version="2116" date="12-10-2019">
		<database file="Dynamic.mdb">
		    <EmailMarketing>
			    <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EmailMarketingFlowFolder'">
                    CREATE TABLE [EmailMarketingFlowFolder](
	                    [EmailMarketingFlowFolderId] [int] IDENTITY(1,1) NOT NULL,
	                    [EmailMarketingFlowFolderParentId] [int] NULL,
	                    [EmailMarketingFlowFolderName] [nvarchar](250) NOT NULL,
                        CONSTRAINT [PK_EmailMarketingFlowFolder] PRIMARY KEY CLUSTERED ([EmailMarketingFlowFolderId] ASC)
                    )
			    </sql>
			    <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EmailMarketingFlow'">
                    CREATE TABLE [EmailMarketingFlow](
	                    [EmailMarketingFlowId] [int] IDENTITY(1,1) NOT NULL,
	                    [EmailMarketingFlowFolderId] [int] NULL,
	                    [EmailMarketingFlowName] [nvarchar](250) NOT NULL,
                        CONSTRAINT [PK_EmailMarketingFlow] PRIMARY KEY CLUSTERED ([EmailMarketingFlowId] ASC)
                    )
			    </sql>
		    </EmailMarketing>
		</database>
	</package>

    <package version="2115" date="28-08-2019">
		<database file="Dynamic.mdb">
		    <area>
			    <sql conditional="">
                    ALTER TABLE [Area] ADD [AreaNofollow] BIT NULL
			    </sql>
			    <sql conditional="">
                    ALTER TABLE [Area] ADD [AreaNoindex] BIT NULL
			    </sql>
		    </area>
		</database>
	</package>

    <package version="2114" releasedate="26-08-2019" RunOnce="True">
        <database file="Dynamic.mdb">
            <dashboard>
                <sql conditional="">
                    DELETE FROM [DashboardWidget] WHERE [DashboardWidgetDashboardID] IN (SELECT d.[DashboardID] FROM [Dashboard] d WHERE d.DashboardType = 'Content')
                </sql>
                <sql conditional="">
                    DELETE FROM [Dashboard] WHERE DashboardType = 'Content'
                </sql>
            </dashboard>
        </database>
    </package>

    <package version="2113" releasedate="07-08-2019">
        <database file="Dynamic.mdb">
            <AccessUser>              
	            <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='AccessUser' AND COLUMN_NAME='AccessUserInformationSent'">
                    ALTER TABLE [AccessUser] ADD [AccessUserInformationSent] [datetime] NULL
                </sql>
            </AccessUser>
        </database>
    </package>

    <package version="2112" releasedate="05-08-2019">
        <!-- Removed -->
    </package>

    <package version="2111" releasedate="05-08-2019">
        <!-- Removed -->
    </package>

    <package version="2110" releasedate="05-08-2019">
        <!-- Removed -->
    </package>

    <package version="2109" releasedate="02-08-2019">
        <database file="Dynamic.mdb">
            <security>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='AccessUserToken'">
                    CREATE TABLE [AccessUserToken] (
                        [AccessUserTokenId] [int] NOT NULL IDENTITY(1, 1),
                        [AccessUserTokenHash] [nvarchar](128) NOT NULL,
                        [AccessUserTokenUserId] [int] NOT NULL,
                        [AccessUserTokenDeviceId] [nvarchar](100) NULL,
                        [AccessUserTokenName] [nvarchar](255) NULL,
                        [AccessUserTokenDescription] [nvarchar](MAX) NULL,
                        [AccessUserTokenCreatedDate] [datetime] NOT NULL,
                        CONSTRAINT [PK_AccessUserToken] PRIMARY KEY CLUSTERED ([AccessUserTokenId] ASC)
                    )
                </sql>
            </security>
        </database>
    </package>

    <package version="2108" releasedate="07-08-2019">
        <database file="Dynamic.mdb">
            <DataIntegration>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EndpointAuthentication'">
                    CREATE TABLE [EndpointAuthentication] (
                        [EndpointAuthenticationId] [int] IDENTITY(1,1) NOT NULL,
                        [EndpointAuthenticationName] [nvarchar](255) NOT NULL,
                        [EndpointAuthenticationType] [nvarchar](255) NOT NULL,
                        [EndpointAuthenticationParameters] [nvarchar](max) NULL 
                        CONSTRAINT [PK_EndpointAuthentication] PRIMARY KEY CLUSTERED ([EndpointAuthenticationId] ASC)
                    )
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Endpoint'">
                    CREATE TABLE [Endpoint] (
                        [EndpointId] [int] IDENTITY(1,1) NOT NULL,
                        [EndpointName] [nvarchar](255) NOT NULL,
                        [EndpointDescription] [nvarchar](max) NULL,
                        [EndpointUrl] [nvarchar](max) NULL,
                        [EndpointAuthenticationId] [int] NULL,
                        [EndpointRequestType] [nvarchar](10) NULL,
                        [EndpointHeaders] [nvarchar](max) NULL,
                        [EndpointBody] [nvarchar](max) NULL
                        CONSTRAINT [PK_Endpoint] PRIMARY KEY CLUSTERED ([EndpointId] ASC)
                    )
                </sql>
            </DataIntegration>
        </database>
    </package>

    <package version="2107" releasedate="12-06-2019">
        <database file="Dynamic.mdb">
            <Page>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Page' AND COLUMN_NAME='PageUrlDataProvider'">
                    ALTER TABLE [Page] ADD [PageUrlDataProvider] [nvarchar](255) NULL
                </sql>
            </Page>
            <Page>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Page' AND COLUMN_NAME='PageUrlDataProviderParameters'">
                    ALTER TABLE [Page] ADD [PageUrlDataProviderParameters] [nvarchar](max) NULL
                </sql>
            </Page>
        </database>
    </package>

    <package version="2106" releasedate="27-05-2019">
        <database file="Dynamic.mdb">
            <QueryPublisher>
                <sql conditional="">
                    UPDATE [Module] SET [ModuleAccess] = 1 WHERE [ModuleSystemName] = 'QueryPublisher'
                </sql>
            </QueryPublisher>
        </database>
    </package>

    <package version="2105" releasedate="09-04-2019">
        <database file="Dynamic.mdb">
            <Audit>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE TABLE_NAME='EcomCustomerFavoriteProducts' AND CONSTRAINT_NAME = 'DW_FK_EcomCustomerFavoriteProducts_EcomCustomerFavoriteLists'">
                    ALTER TABLE [dbo].[EcomCustomerFavoriteProducts] DROP CONSTRAINT [DW_FK_EcomCustomerFavoriteProducts_EcomCustomerFavoriteLists]
                </sql>  
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE TABLE_NAME='EcomCustomerFavoriteProducts' AND CONSTRAINT_NAME = 'DW_FK_EcomCustomerFavoriteProducts_EcomProducts'">
                    ALTER TABLE [dbo].[EcomCustomerFavoriteProducts] DROP CONSTRAINT [DW_FK_EcomCustomerFavoriteProducts_EcomProducts]
                </sql>  
            </Audit>            
        </database>
    </package>    

    <package version="2104" releasedate="18-04-2019">        
        <file name="BasicForms.xml" source="/Files/System/BulkDataEdit" target="/Files/System/BulkDataEdit" overwrite="false" />
        <file name="DM_Form.xml" source="/Files/System/BulkDataEdit" target="/Files/System/BulkDataEdit" overwrite="false" />
        <file name="eCom_CartV2.xml" source="/Files/System/BulkDataEdit" target="/Files/System/BulkDataEdit" overwrite="false" />
        <file name="eCom_Catalog.xml" source="/Files/System/BulkDataEdit" target="/Files/System/BulkDataEdit" overwrite="false" />
        <file name="eCom_CustomerCenter.xml" source="/Files/System/BulkDataEdit" target="/Files/System/BulkDataEdit" overwrite="false" />
        <file name="UserManagementFrontend.xml" source="/Files/System/BulkDataEdit" target="/Files/System/BulkDataEdit" overwrite="false" />
        <file name="UserManagementFrontendExtended.xml" source="/Files/System/BulkDataEdit" target="/Files/System/BulkDataEdit" overwrite="false" />
    </package>

    <package version="2103" releasedate="08-04-2019">
        <database file="Dynamic.mdb">
            <Audit>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='AuditDeletedObject' AND COLUMN_NAME='AuditDeletedObjectAuditKey1'">
                    ALTER TABLE [AuditDeletedObject] ADD [AuditDeletedObjectAuditKey1] [nvarchar](255) NULL
                </sql>
            </Audit>
            <Audit>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='AuditDeletedObject' AND COLUMN_NAME='AuditDeletedObjectAuditKey2'">
                    ALTER TABLE [AuditDeletedObject] ADD [AuditDeletedObjectAuditKey2] [nvarchar](255) NULL
                </sql>
            </Audit>
            <Audit>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='AuditDeletedObject' AND COLUMN_NAME='AuditDeletedObjectAuditKey3'">
                    ALTER TABLE [AuditDeletedObject] ADD [AuditDeletedObjectAuditKey3] [nvarchar](255) NULL
                </sql>
            </Audit>
        </database>
    </package>
    
    <package version="2102" releasedate="05-04-2019">
        <database file="Dynamic.mdb">
            <Audit>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='AuditDeletedObject'">
                    CREATE TABLE [AuditDeletedObject] (
	                    [AuditDeletedObjectId] [int] IDENTITY(1,1) NOT NULL,
	                    [AuditDeletedObjectAuditId] [int] NOT NULL,
	                    [AuditDeletedObjectInfo] [nvarchar](255) NULL,
                        CONSTRAINT [PK_AuditDeletedObject] PRIMARY KEY CLUSTERED ([AuditDeletedObjectId] ASC)
                    )
                </sql>               
            </Audit>            
        </database>
    </package>

    
    <package version="2101" releasedate="26-03-2019">
        <database file="Dynamic.mdb">
            <Task>
                <sql conditional="SELECT * FROM sys.indexes WHERE name = N'DW_IX_EcomStockUnitDetail_ProductId_VariantId_ProductNumber_StockUnitId'">
                   CREATE UNIQUE NONCLUSTERED INDEX [DW_IX_EcomStockUnitDetail_ProductId_VariantId_ProductNumber_StockUnitId] ON [EcomStockUnitDetail]
                    (
	                    [StockUnitDetailProductId] ASC,
	                    [StockUnitDetailProductNumber] ASC,
	                    [StockUnitDetailStockUnitId] ASC,
	                    [StockUnitDetailVariantId] ASC
                    )
                </sql>
            </Task>            
        </database>
    </package>

    <package version="2100" releasedate="26-03-2019">
        <database file="Dynamic.mdb">
            <Task>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomStockUnitDetail'">
                    CREATE TABLE [EcomStockUnitDetail] (
	                    [StockUnitDetailId] [bigint] IDENTITY(1,1) NOT NULL,
	                    [StockUnitDetailProductId] [nvarchar](30) NULL,
	                    [StockUnitDetailVariantId] [nvarchar](255) NULL,
	                    [StockUnitDetailProductNumber] [nvarchar](255) NULL,
	                    [StockUnitDetailStockUnitId] [nvarchar](50) NULL,
	                    [StockUnitDetailQuantity] [int] NOT NULL DEFAULT 0,
                        CONSTRAINT [PK_EcomStockUnitDetail] PRIMARY KEY CLUSTERED ([StockUnitDetailId] ASC)
                    )
                </sql>               
            </Task>            
        </database>
    </package>

     <package version="2099" releasedate="26-03-2019">
        <database file="Dynamic.mdb">
            <Form>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomStockUnit' AND COLUMN_NAME='StockUnitProductNumber'">
                    ALTER TABLE [EcomStockUnit] ADD [StockUnitProductNumber] [nvarchar](255) NULL;
                </sql>
            </Form>           
        </database>
    </package>

    <package version="2098" releasedate="22-02-2019">        
        <file name="FilepublishList.cshtml" source="/Files/Templates/Filepublish" target="/Files/Templates/Filepublish" overwrite="false" />
    </package>

    <package version="2097" releasedate="08-02-2019">
        <database file="Dynamic.mdb">
            <form>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='FormTemplate'">
                    CREATE TABLE [FormTemplate] (
	                    [FormTemplateId] [int] NOT NULL IDENTITY(1, 1),
	                    [FormTemplateAreadId] [int] NOT NULL DEFAULT 0,
	                    [FormTemplateType] [int] NOT NULL DEFAULT 0,
	                    [FormTemplateTemplate] [nvarchar](255) NULL,
	                    CONSTRAINT [PK_FormTemplate] PRIMARY KEY CLUSTERED ([FormTemplateId] ASC)
                    )
                </sql>
            </form>
        </database>
    </package>

    <package version="2096" releasedate="01-02-2019">
        <invoke type="Dynamicweb.Content.Management.UpdateScripts, Dynamicweb" method="AddAuditTableToAutoLogClean" />
    </package>

    <package version="2095" releasedate="29-01-2019">
        <setting key="/Globalsettings/System/Tracking/TableTimeInterval" value="None" />
        <setting key="/Globalsettings/System/Tracking/EnableTracking" value="False" />
        <setting key="/Globalsettings/System/Tracking/EnableLogging" value="True" />
    </package>

    <package version="2094" releasedate="23-01-2019">
        <database file="Dynamic.mdb">
            <Form>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Form' AND COLUMN_NAME='FormUniqueId'">
                    ALTER TABLE [Form] ADD [FormUniqueId] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID();
                </sql>
            </Form>
            <FormField>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='FormField' AND COLUMN_NAME='FormFieldUniqueId'">
                    ALTER TABLE [FormField] ADD [FormFieldUniqueId] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID();
                </sql>
            </FormField>
            <FormOptions>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='FormOptions' AND COLUMN_NAME='FormOptionsUniqueId'">
                    ALTER TABLE [FormOptions] ADD [FormOptionsUniqueId] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID();
                </sql>
            </FormOptions>
        </database>
    </package>

    <package version="2093" releasedate="23-01-2019">
        <database file="Dynamic.mdb">
            <form>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Form' AND COLUMN_NAME = 'FormDisplayCount'">
                    ALTER TABLE [Form] ADD [FormDisplayCount] INT NOT NULL DEFAULT 0;
                </sql>
            </form>
        </database>
    </package>

    <package version="2092" releasedate="17-01-2019">        
        <setting key="/Globalsettings/Settings/Auditing/EnableAuditing" value="False" />
    </package>

    <package version="2091" releasedate="11-01-2019">
        <database file="Dynamic.mdb">
            <DataProcessing>
                <sql conditional="">
                    UPDATE [Module] SET [ModuleIconClass] = 'SwitchCamera' WHERE [ModuleSystemName] = 'DataPortability';
                </sql>
            </DataProcessing>
        </database>
    </package>

    <package version="2090" releasedate="27-12-2018">        
        <file name="ProductViewListFacets.cshtml" source="/Files/Templates/eCom/ProductCatalog" target="/Files/Templates/eCom/ProductCatalog" overwrite="false" />
    </package>

    <package version="2089" releasedate="26-12-2018">
        <database file="Dynamic.mdb">
            <DataProcessing>
                <sql conditional="">
                    UPDATE [Module] SET [ModuleScript] = 'DataPortability/Default.aspx' WHERE [ModuleSystemName] = 'DataPortability';
                </sql>
            </DataProcessing>
        </database>
    </package>

    <package version="2088" releasedate="07-12-2018">
        <database file="Dynamic.mdb">
            <form>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='FormFieldRule'">
                    CREATE TABLE [FormFieldRule] (
	                    [FormFieldRuleId] [int] NOT NULL IDENTITY(1, 1),
	                    [FormFieldRuleActive] [bit] NOT NULL,
	                    [FormFieldRuleConditionType] [int] NOT NULL,
	                    [FormFieldRuleConditionValue] [nvarchar](MAX) NULL,
	                    [FormFieldRuleFieldId] [int] NOT NULL,
	                    [FormFieldRuleTargetFieldId] [int] NULL,
	                    [FormFieldRuleType] [int] NULL,
                        CONSTRAINT [PK_FormFieldRule] PRIMARY KEY CLUSTERED ([FormFieldRuleId] ASC)
                    )
                </sql>
            </form>
        </database>
    </package>

    <package version="2087" releasedate="07-12-2018">
        <database file="Dynamic.mdb">
            <AreaColorSwatch>
				<sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='AreaColorSwatch'">
                    CREATE TABLE [AreaColorSwatch](
	                    [AreaId] [int] NOT NULL,
	                    [AreaColorSwatchData] [nvarchar](MAX) NULL
                        CONSTRAINT [PK_AreaColorSwatch] PRIMARY KEY CLUSTERED ([AreaId] ASC)
                    )
				</sql>
			</AreaColorSwatch>			                  
        </database>
    </package>

    <package version="2086" releasedate="19-08-2018">
        <database file="Dynamic.mdb">
            <Audit>
				<sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Audit'">
                    CREATE TABLE [Audit](
	                    [AuditId] [int] IDENTITY(1,1) NOT NULL,
	                    [AuditArea] [nvarchar](255) NULL,
	                    [AuditType] [nvarchar](255) NOT NULL,
	                    [AuditKey1] [nvarchar](255) NOT NULL,
	                    [AuditKey2] [nvarchar](255) NULL,
	                    [AuditKey3] [nvarchar](255) NULL,
	                    [AuditParentId] [nvarchar](255) NULL,
	                    [AuditAction] [nvarchar](255) NOT NULL,
	                    [AuditTimestamp] [datetime] NOT NULL,
	                    [AuditUserId] [int] not null
                        CONSTRAINT [PK_Audit] PRIMARY KEY CLUSTERED ([AuditId] ASC)
                    )
				</sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='AuditDetail'">
                    CREATE TABLE [AuditDetail](
	                    [AuditDetailId] [int] IDENTITY(1,1) NOT NULL,
	                    [AuditDetailAuditId] [int] NOT NULL,
	                    [AuditDetailKey] [nvarchar](255) NOT NULL,
	                    [AuditDetailAction] [nvarchar](255) NOT NULL,
	                    [AuditDetailValue1] [nvarchar](max) NULL,
	                    [AuditDetailValue2] [nvarchar](max) NULL
                        CONSTRAINT [PK_AuditDetail] PRIMARY KEY CLUSTERED ([AuditDetailId] ASC)
                    )
				</sql>
			</Audit>			                  
        </database>
    </package>

    <package version="2085" releasedate="18-10-2018">
        <invoke type="Dynamicweb.Content.Management.UpdateScripts, Dynamicweb" method="CleanupWrongIndexBuildLogs" />
    </package>

    <package version="2084" releasedate="17-10-2018">        
        
    </package>

    <package version="2083" releasedate="25-09-2018">        
        <file name="Amazon Images.cshtml" source="/Files/Templates/Feeds" target="/Files/Templates/Feeds" overwrite="false" />
        <file name="Amazon Inventory.cshtml" source="/Files/Templates/Feeds" target="/Files/Templates/Feeds" overwrite="false" />
        <file name="Amazon Prices.cshtml" source="/Files/Templates/Feeds" target="/Files/Templates/Feeds" overwrite="false" />
        <file name="Amazon Products.cshtml" source="/Files/Templates/Feeds" target="/Files/Templates/Feeds" overwrite="false" />
    </package>

    <package version="2082" releasedate="19-09-2018" RunOnce="True">
        <invoke type="Dynamicweb.Content.Management.UpdateScripts, Dynamicweb" method="MigrateEventViewerNotificationConfiguration" />
    </package>

    <package version="2081" releasedate="28-05-2018">        
        <file name="ProductViewDetail.cshtml" source="/Files/Templates/eCom/ProductCatalog" target="/Files/Templates/eCom/ProductCatalog" overwrite="false" />
    </package>

    <package version="2080" releasedate="28-05-2018">        
        <file name="ProductViewList.cshtml" source="/Files/Templates/eCom/ProductCatalog" target="/Files/Templates/eCom/ProductCatalog" overwrite="false" />
    </package>

    <package version="2079" releasedate="20-08-2018">
        <database file="Dynamic.mdb">
            <ScheduledTask>
				<sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='ScheduledTask' AND COLUMN_NAME = 'TaskLastException'">
                    ALTER TABLE [ScheduledTask] ADD [TaskLastException] NVARCHAR(MAX) NULL
				</sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='ScheduledTask' AND COLUMN_NAME = 'TaskLastEventId'">
                    ALTER TABLE [ScheduledTask] ADD [TaskLastEventId] INT NULL
				</sql>
			</ScheduledTask>			                  
        </database>
    </package>

    <package version="2078" releasedate="10-07-2018">        
        <file name="ModalDialogWarning_Categories.html" source="/Files/Templates/CookieWarning" target="/Files/Templates/CookieWarning" overwrite="false" />
    </package>

<package version="2077" releasedate="18-06-2018">
        <database file="Dynamic.mdb">
            <Form>
				<sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='FormField' AND COLUMN_NAME = 'FormFieldHideInReceipt'">
                    ALTER TABLE [FormField] ADD [FormFieldHideInReceipt]  BIT NOT NULL DEFAULT 0
				</sql>
			</Form>			                  
        </database>
    </package>

    <package version="2076" releasedate="14-05-2018">        
        <file name="Default.xml" source="/Files/System/DataPortability/Definitions" target="/Files/System/DataPortability/Definitions" overwrite="false" />
    </package>

    <package version="2075" releasedate="14-05-2018">        
        <file name="Form.cshtml" source="/Files/Templates/DataPortability/Form" target="/Files/Templates/DataPortability/Form" overwrite="false" />
    </package>

    <package version="2074" releasedate="09-05-2018">
        <database file="Dynamic.mdb">
            <DataProcessing>
                <sql conditional="SELECT COUNT(*) FROM [Module] WHERE [ModuleSystemName] = 'DataPortability'">
                    INSERT INTO [Module]
                    ([ModuleSystemName], [ModuleName], [ModuleAccess], [ModuleParagraph], [ModuleIsBeta], [ModuleIconClass], [ModuleScript])
                    VALUES
                    ('DataPortability', 'Data Portability', blnTrue, blnTrue, blnTrue, 'ArrowsH', 'DataPortability/Default.aspx')
                </sql>
            </DataProcessing>
        </database>        
    </package>

    <package version="2073" releasedate="10-04-2018">
        <database file="Dynamic.mdb">
            <Task>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='GeneralLog' AND COLUMN_NAME='LogLevel'">
                    ALTER TABLE [GeneralLog] ADD [LogLevel] NVARCHAR(50) NULL;
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='GeneralLog' AND COLUMN_NAME='UserId'">
                    ALTER TABLE [GeneralLog] ADD [UserId] INT NULL;
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='GeneralLog' AND COLUMN_NAME='UtcOffset'">
                    ALTER TABLE [GeneralLog] ADD [UtcOffset] NVARCHAR(50) NULL;
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='GeneralLog' AND COLUMN_NAME='Exception'">
                    ALTER TABLE [GeneralLog] ADD [Exception] NVARCHAR(250) NULL;
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='GeneralLog' AND COLUMN_NAME='MachineName'">
                    ALTER TABLE [GeneralLog] ADD [MachineName] NVARCHAR(250) NULL;
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='GeneralLog' AND COLUMN_NAME='Category'">
                    ALTER TABLE [GeneralLog] ADD [Category] NVARCHAR(250) NULL;
                </sql>
             </Task>
        </database>
    </package>

    <package version="2072" releasedate="09-04-2018">
        <database file="Dynamic.mdb">
            <Form>
				<sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='FormField' AND COLUMN_NAME = 'FormFieldActivityId'">
                    ALTER TABLE [dbo].[FormField] ADD [FormFieldActivityId] [nvarchar](50) NULL
				</sql>
			</Form>			                  
        </database>
    </package>

     <package version="2071" releasedate="28-03-2018">
        <database file="Dynamic.mdb">
            <DataProcessing>
                <sql conditional="">
                    UPDATE [Module] SET [ModuleParagraphEditPath] = '/Admin/Module/DataProcessing/Default.aspx' WHERE [ModuleSystemName] = 'DataProcessing';                    
                </sql>
            </DataProcessing>
        </database>        
    </package>    

    <package version="2070" releasedate="27-03-2018">
        <database file="Dynamic.mdb">
            <DataProcessing>
                <sql conditional="SELECT COUNT(*) FROM [Module] WHERE [ModuleSystemName] = 'DataProcessing'">
                    INSERT INTO [Module]
                    ([ModuleSystemName], [ModuleName], [ModuleAccess], [ModuleParagraph], [ModuleIsBeta], [ModuleScript], [ModuleIconClass])
                    VALUES
                    ('DataProcessing', 'Data Processing', blnTrue, blnFalse, blnTrue, 'DataProcessing/Default.aspx', 'VerifiedUser')
                </sql>
            </DataProcessing>
        </database>        
    </package>

    <package version="2069" releasedate="16-03-2018">
        <database file="Dynamic.mdb">
            <DataProcessing>
				<sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='DataProcessingActivity'">
                    CREATE TABLE [DataProcessingActivity](
	                    [ActivityId] [nvarchar](50) NOT NULL,
	                    [ActivityName] [nvarchar](255) NOT NULL,
	                    [ActivityDescription] [nvarchar](max) NULL,
	                    [ActivityCreatedDate] [datetime] NULL,
	                    [ActivityUpdatedDate] [datetime] NULL,
                        CONSTRAINT [PK_DataProcessingActivity] PRIMARY KEY CLUSTERED ([ActivityId] ASC)
                    )
				</sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='DataProcessingConsent'">
                    CREATE TABLE [DataProcessingConsent](
	                    [ConsentActivityId] [nvarchar](50) NOT NULL,
	                    [ConsentSubjectId] [nvarchar](255) NOT NULL,
	                    [ConsentSubjectType] [nvarchar](50) NOT NULL,
	                    [ConsentStatus] [int] NOT NULL,
	                    [ConsentRequestUrl] [nvarchar](2048) NULL,
	                    [ConsentRequestUserHostAddress] [nvarchar](50) NULL,
	                    [ConsentRequestUserAgent] [nvarchar](255) NULL,
	                    [ConsentCreatedDate] [datetime] NULL,
	                    [ConsentUpdatedDate] [datetime] NULL,
	                    [ConsentChecksum] [nvarchar](255) NULL,
                        CONSTRAINT [PK_DataProcessingConsent] PRIMARY KEY CLUSTERED ([ConsentActivityId] ASC, [ConsentSubjectId] ASC, [ConsentSubjectType] ASC)
                    )
				</sql>
			</DataProcessing>			                  
        </database>
    </package>

    <package version="2068" date="16-03-2018">
	    <database file="Dynamic.mdb">
            <UnifiedPermission>
                <sql conditional="">
                    IF EXISTS (SELECT * FROM sys.indexes WHERE name = N'DW_IX_UnifiedPermission_Key_Name')
	                    DROP INDEX DW_IX_UnifiedPermission_Key_Name ON UnifiedPermission;
                    IF EXISTS (SELECT * FROM sys.indexes WHERE name = N'DW_IX_UnifiedPermission_UserId_Key_Name')
	                    DROP INDEX DW_IX_UnifiedPermission_UserId_Key_Name ON UnifiedPermission;
                    IF EXISTS (SELECT * FROM sys.indexes WHERE name = N'DW_IX_UnifiedPermission_UserId_Key_Name_SubName')
	                    DROP INDEX DW_IX_UnifiedPermission_UserId_Key_Name_SubName ON UnifiedPermission;
                </sql>
                <sql conditional="">
                    ALTER TABLE [UnifiedPermission] ALTER COLUMN [PermissionUserId] NVARCHAR(50) NULL;
                    ALTER TABLE [UnifiedPermission] ALTER COLUMN [PermissionKey] NVARCHAR(255) NULL;
                    ALTER TABLE [UnifiedPermission] ALTER COLUMN [PermissionName] NVARCHAR(100) NULL;
                    ALTER TABLE [UnifiedPermission] ALTER COLUMN [PermissionSubName] NVARCHAR(100) NULL;
                    CREATE NONCLUSTERED INDEX [DW_IX_UnifiedPermission_Key_Name] ON [UnifiedPermission]
                    (
	                    [PermissionKey] ASC,
	                    [PermissionName] ASC
                    )
                    CREATE NONCLUSTERED INDEX [DW_IX_UnifiedPermission_UserId_Key_Name_SubName] ON [UnifiedPermission]
                    (
	                    [PermissionUserId] ASC,
	                    [PermissionKey] ASC,
	                    [PermissionName] ASC,
	                    [PermissionSubName] ASC
                    ) INCLUDE ([PermissionLevel])
                </sql>
            </UnifiedPermission>
        </database>
    </package>

    <package version="2067" releasedate="14-03-2018">
        <database file="Dynamic.mdb">
            <Task>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='GeneralLog' AND COLUMN_NAME='LogFilePath'">
                    ALTER TABLE [GeneralLog] ADD [LogFilePath] NVARCHAR(MAX) NULL;
                </sql>
             </Task>
        </database>
    </package>

    <package version="2066" releasedate="06-03-2018">        
        <setting key="/Globalsettings/Ecom/EconomicIntegration/Credentials/DynamicwebAppPublicToken" value="ZzHUKtTtEeHebMlr0a6Egfp4Wt6g0zT5hXZv6fpW74E1" />
        <setting key="/Globalsettings/Ecom/EconomicIntegration/Credentials/DynamicwebAppSecretToken" value="B2AnlqBqny40mmMLBk5tp12Bxw0zMNDiFb68sFF4kRo1" />
    </package>

    <package version="2065" releasedate="21-02-2018">        
        <file name="SearchResultItem.html" source="/Files/Templates/Searchv1" target="/Files/Templates/Searchv1" overwrite="true" RunOnce="True" />
    </package>
    
    <package version="2064" releasedate="29-01-2018">
        <database file="Dynamic.mdb">
            <Task>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='AccessUser' AND COLUMN_NAME='DefaultPermission'">
                    ALTER TABLE [AccessUser] ADD [DefaultPermission] [int] NULL;
                </sql>
             </Task>
        </database>
    </package>

    <package version="2063" releasedate="20-12-2017">
        <database file="Dynamic.mdb">
            <ItemListRelation>
                <sql conditional="SELECT * FROM sys.indexes WHERE name = N'DW_IX_ItemListRelation_ListId'">
                    IF EXISTS (SELECT * FROM sys.indexes WHERE name = N'DW_IX_ItemListRelation_ListId')
	                DROP INDEX DW_IX_ItemListRelation_ListId ON ItemListRelation
                    CREATE NONCLUSTERED INDEX [DW_IX_ItemListRelation_ListId] ON [dbo].[ItemListRelation] ( [ItemListRelationItemListId] ASC, [ItemListRelationSort] ASC) INCLUDE ([ItemListRelationItemId])
                </sql>
             </ItemListRelation>
        </database>
    </package>
<package version="2062" releasedate="01-12-2017">
        <database file="Dynamic.mdb">
            <Task>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Task' AND COLUMN_NAME='TaskStartFromLastRun'">
                    ALTER TABLE [Task] ADD [TaskStartFromLastRun] BIT NULL NOT NULL DEFAULT 1;
                </sql>
             </Task>
        </database>
    </package>

    <package version="2061" releasedate="01-11-2017">
        <database file="Dynamic.mdb">
            <Paragraph>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Paragraph' AND COLUMN_NAME='ParagraphRowColor'">
                    ALTER TABLE [Paragraph] ADD [ParagraphRowColor] NVARCHAR(50) NULL;
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Paragraph' AND COLUMN_NAME='ParagraphRowImage'">
                    ALTER TABLE [Paragraph] ADD [ParagraphRowImage] NVARCHAR(255) NULL;
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Paragraph' AND COLUMN_NAME='ParagraphRowCssClass'">
                    ALTER TABLE [Paragraph] ADD [ParagraphRowCssClass] NVARCHAR(100) NULL;
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Paragraph' AND COLUMN_NAME='ParagraphRowId'">
                    ALTER TABLE [Paragraph] ADD [ParagraphRowId] NVARCHAR(50) NULL;
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Paragraph' AND COLUMN_NAME='ParagraphParentRowId'">
                    ALTER TABLE [Paragraph] ADD [ParagraphParentRowId] [int] NULL;
                </sql>
            </Paragraph>
        </database>
    </package>

    <package version="2060" releasedate="19-12-2017">
        <database file="Dynamic.mdb">
            <AccessUser>              
	            <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='AccessUser' AND COLUMN_NAME='AccessUserUserAndGroupType'">
                    ALTER TABLE [AccessUser] ADD [AccessUserUserAndGroupType] nvarchar(255) NULL
                </sql>
            </AccessUser>
        </database>
    </package>

    <package version="2059" releasedate="15-12-2017">        
        <file name="Extranet_SendInfo.html" source="/Files/Templates/ExtranetExtended" target="/Files/Templates/ExtranetExtended" overwrite="false" />
    </package>

    <package version="2058" releasedate="04-12-2017">
        <invoke type="Dynamicweb.Content.Management.UpdateScripts, Dynamicweb" method="FixQueryWidgetsQueryID" />
    </package>

    <package version="2057" date="08-11-2017">
	    <database file="Dynamic.mdb">
            <VersionData>
                <sql conditional="">
                    ALTER TABLE [VersionData] ALTER COLUMN [VersionDataType] nvarchar(255) NULL
                </sql>
            </VersionData>
        </database>
    </package>

    <package version="2056" date="24-10-2017">
	    <database file="Dynamic.mdb">
	        <Module>
		        <sql conditional="">
                    UPDATE [Module] SET ModuleAccess = 0, ModuleDeprecated = 1, ModuleHiddenMode = 1 WHERE [ModuleSystemName] = 'SocialMediaPublishing'
		        </sql>
	        </Module>
	    </database>
    </package>

    <package version="2052" releasedate="23-10-2017">
        <database file="Dynamic.mdb">
            <UnifiedPermission>
				<sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='UnifiedPermission'">
                    CREATE TABLE [UnifiedPermission](
	                    [PermissionID] [int] IDENTITY(1,1) NOT NULL,
	                    [PermissionUserId] [varchar](255) NULL,
	                    [PermissionKey] [varchar](100) NULL,
	                    [PermissionName] [varchar](255) NULL,
	                    [PermissionSubName] [varchar](255) NULL,
	                    [PermissionLevel] [smallint] NULL,
                        CONSTRAINT [PK_UnifiedPermission] PRIMARY KEY CLUSTERED ([PermissionID] ASC)
                     )                    
				</sql>
			</UnifiedPermission>			                  
        </database>
    </package>
    
    <package version="2051" releasedate="19-04-2017">
    	<database file="Dynamic.mdb">
            <EcomValidationGroups>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomValidationGroups' AND COLUMN_NAME='ValidationGroupDoNotValidateIfAllFieldsAreEmpty'">
                    ALTER TABLE [EcomValidationGroups] ADD [ValidationGroupDoNotValidateIfAllFieldsAreEmpty] BIT NOT NULL DEFAULT 0;
                </sql>
            </EcomValidationGroups>
        </database>
    </package>    

    <package version="2050" releasedate="12-09-2017">
        <database file="Dynamic.mdb">
            <Language>
				<sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Languages'">
                    CREATE TABLE [Languages] ([LanguageID] [int] IDENTITY(1,1) NOT NULL, [LanguageName] [nvarchar](255), [LanguageActive] [bit] NOT NULL, 
                        [LanguageDateFormatShort] [nvarchar](50), [LanguageDateFormatShortAndTime] [nvarchar](50), [LanguageDateFormatMedium] [nvarchar](50), 
	                    [LanguageDateFormatMediumAndTime] [nvarchar](50), [LanguageDateFormatLong] [nvarchar](50), [LanguageDateFormatLongAndTime] [nvarchar](50), 
	                    [LanguageDateFormatDropDown] [nvarchar](50), [LanguageDateFormatDropDownAndTime] [nvarchar](50), [LanguageLocale] [nvarchar](10) NOT NULL);

                    SET IDENTITY_INSERT [Languages] ON;
                    INSERT INTO [Languages] (LanguageID, LanguageName, LanguageActive, LanguageDateFormatShort, LanguageDateFormatShortAndTime, LanguageDateFormatMedium
                        , LanguageDateFormatMediumAndTime, LanguageDateFormatLong, LanguageDateFormatLongAndTime, LanguageDateFormatDropDown, LanguageDateFormatDropDownAndTime
                        , LanguageLocale)
                    VALUES
                        (1, N'Dansk', 1, N'dd-MM-yyyy', N'dd-MM-yyyy hh:mm', N'dd. mmm. yyyy', N'dd. mmm. yyyy hh:mm', N'dd. mmmm yyyy', N'dd. mmmm yyyy hh:mm', N'dd  MM  yy', N'dd  MM  yy   hh:mm', N'da-DK'),
                        (2, N'English', 1, N'MM-dd-yyyy', N'MM-dd-yyyy hh:mm', N'mmm. dd. yyyy', N'mmm. dd. yyyy hh:mm', N'mmmm dd, yyyy ', N'mmmm dd, yyyy hh:mm', N'MM  dd  yy', N'MM  dd  yy   hh:mm', N'en-GB'),
                        (3, N'Deutsch', 1, N'dd.MM.yyyy', N'dd.MM.yyyy hh:mm', N'dd. mmm yyyy', N'dd. mmm yyyy hh:mm', N'dd. mmmm yyyy', N'dd. mmmm yyyy hh:mm', N'dd  MM  yy', N'dd  MM  yy  hh:mm', N'de-DE'),
                        (4, N'Francais', 0, N'dd/MM/yyyy', N'dd/MM/yyyy hh:mm', N'dd mmm yyyy', N'dd mmm yyyy hh:mm', N'dd mmmm yyyy', N'dd mmmm yyyy hh:mm', N'dd  MM  yy', N'dd  MM  yy  hh:mm', N'fr-FR'),
                        (5, N'Español', 1, N'dd/MM/yyyy', N'dd/MM/yyyy hh:mm', N'dd mmm yyyy', N'dd mmm yyyy hh:mm', N'dd de mmmm de yyyy', N'dd de mmmm de yyyy hh:mm', N'dd  MM  yy', N'dd  MM  yy  hh:mm', N'es-ES'),
                        (6, N'Hebrew', 0, N'yy-MM-dd', N'yy-MM-dd hh:mm', N'yyyy-mmm-dd', N'yyyy-mmm-dd hh:mm', N'yyyy-mmmm-dd', N'yyyy-mmmm-dd hh:mm', N'yy  MM  dd', N'yy  MM  dd   hh:mm', N'he-IL'),
                        (7, N'汉语', 0, N'yyyy-MM-dd', N'yyyy-MM-dd hh:mm', N'yyyy-mmm-dd', N'yyyy-mmm-dd hh:mm', N'yyyy-mmmm-dd', N'yyyy-mmmm-dd hh:mm', N'yy  MM  dd ', N'yy  MM  dd   hh:mm', N'zh-CN'),
                        (8, N'日本語', 0, N'yyyy-MM-dd', N'yyyy-MM-dd hh:mm', N'yyyy年mmmdd日', N'yyyy年mmmdd日 hh:mm', N'yyyy-MM-dd', N'yyyy-MM-dd hh:mm', N'yy年 MM  dd日', N'yy年 MM  dd日 hh時mm分', N'ja-JP'),
                        (9, N'Svenska', 1, N'yyyy-MM-dd', N'yyyy-MM-dd hh:mm', N'dd mmm yyyy', N'dd mmm yyyy hh:mm', N'den dd mmmm yyyy', N'den dd mmmm yyyy hh:mm', N'yy  MM  dd', N'yy  MM  dd  hh:mm', N'sv-SE'),
                        (10, N'Føroyskt', 1, N'dd-MM-yyyy', N'dd-MM-yyyy hh.mm', N'dd. mmm yyyy', N'dd. mmm yyyy hh.mm', N'dd. mmmm yyyy', N'dd. mmmm yyyy hh.mm', N'dd  MM  yy', N'dd  MM  yy  hh.mm', N'fo-FO'),
                        (11, N'Norsk', 1, N'dd.MM.yyyy', N'dd.MM.yyyy hh:mm', N'dd. mmm yyyy', N'dd. mmm yyyy hh:mm', N'dd. mmmm yyyy', N'dd. mmmm yyyy hh:mm', N'dd  MM  yy', N'dd  MM  yy  hh:mm', N'nb-NO'),
                        (20, N'Português', 1, N'dd-MM-yyyy', N'dd-MM-yyyy hh:mm', N'dd/MM/yyyy', N'dd/MM/yyyy hh:mm', N'dd de mmmm de yyyy', N'dd de mmmm de yyyy hh:mm', N'dd  MM  yy', N'dd  MM  yy  hh:mm', N'pt-PT'),
                        (22, N'Pусский', 0, N'dd.MM.yyyy', N'dd.MM.yyyy hh:mm', N'dd/mmm/yyyy г.', N'dd mmm yyyy г. hh:mm', N'dd mmmm yyyy г.', N'dd mmmm yyyy г. hh:mm', N'dd MM yy', N'dd  MM  yy  hh:mm', N'ru-RU'),
                        (23, N'Nederlands', 1, N'dd.MM.yy', N'dd.MM.yy hh.mm', N'dd mmm yy', N'dd mmm yy hh.mm', N'dd mmmm yyyy', N'dd mmmm yyyy hh.mm', N'dd MM yy', N'dd MM yy hh.mm', N'nl-NL'),
                        (24, N'Íslenska', 0, N'dd-MM-yyyy', N'dd-MM-yyyy hh:mm', N'dd. mmm. yyyy', N'dd. mmm. yyyy hh:mm', N'dd. mmmm yyyy', N'dd. mmmm yyyy hh:mm', N'dd  MM  yy', N'dd  MM  yy   hh:mm', N'is-IS'),
                        (25, N'ελληνικά', 0, N'dd/MM/yyyy', N'dd/MM/yyyy hh:mm', N'dd mmmm yyyy', N'dd mmmm yyyy hh:mm', N'dddd, dd MMMM yyyy', N'dddd, dd MMMM yyyy hh:mm', N'dd MM yy', N'dd MM yy hh:mm', N'el-GR'),
                        (26, N'Italiano', 0, N'dd/MM/yyyy', N'dd/MM/yyyy hh:mm', N'dd mmm yyyy', N'dd mmm yyyy hh:mm', N'dd mmmm yyyy', N'dd mmmm yyyy hh:mm', N'dd  MM  yy', N'dd  MM  yy  hh:mm', N'it-IT'),
                        (27, N'Polski', 1, N'dd.MM.yyyy', N'dd.MM.yyyy hh:mm', N'dd.mmm.yyyy', N'dd.mmm.yyyy hh:mm', N'dd.mmmm.yyyy', N'dd.mmmm.yyyy hh:mm', N'dd MM yy', N'dd MM yy hh:mm', N'pl-PL'),
                        (28, N'Português (BR)', 1, N'dd-MM-yyyy', N'dd-MM-yyyy hh:mm', N'dd/MM/yyyy', N'dd/MM/yyyy hh:mm', N'dd de mmmm de yyyy', N'dd de mmmm de yyyy hh:mm', N'dd  MM  yy', N'dd  MM  yy  hh:mm', N'pt-br'),
                        (29, N'Română', 1, N'dd.MM.yyyy', N'dd-MM-yyyy hh:mm', N'dd. mmm yyyy', N'dd. mmm yyyy hh:mm', N'dd. mmmm yyyy', N'dd. mmmm yyyy hh:mm', N'dd  MM  yy', N'dd  MM  yy  hh:mm', N'ro-RO');
                    SET IDENTITY_INSERT [Languages] OFF;

				</sql>
			</Language>			                  
        </database>
    </package>

    <package version="2049" releasedate="07-09-2017">
        <database file="Dynamic.mdb">
            <Page>
				<sql conditional="">ALTER TABLE [Page] ADD [PageDisplayMode] INT NOT NULL DEFAULT 0</sql>
			</Page>			                  
        </database>
    </package>

    <package version="2048" releasedate="28-08-2017">
        <database file="Dynamic.mdb">
            <Module>
                <sql conditional="">
                    UPDATE [Module] SET [ModuleParagraph] = 1 WHERE [ModuleSystemName] = 'eCom_ShowList'
		        </sql>
			</Module>
		</database>
    </package>

    <package version="2047" releasedate="22-08-2017">
        <file name="FilepublishList.cshtml" source="/Files/Templates/Filepublish" target="/Files/Templates/Filepublish" overwrite="false" />
    </package>

    <package version="2046" releasedate="07-06-2017">
        <setting key="/Globalsettings/ItemTypes/GoogleFontApiKey" value="AIzaSyC_AeYoZz8_ia1EqDZUILjLkbqEWmm8a_0" />
    </package>
    
    <!--
        Named wrongly and is not in use...
    <package version="2045" releasedate="17-05-2017">
        <database file="Dynamic.mdb">
            <Paragraph>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Paragraph' AND COLUMN_NAME='ParentContainer'">
                    ALTER TABLE [Paragraph] ADD [ParentContainer] NVARCHAR(MAX) NULL;
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Paragraph' AND COLUMN_NAME='ContainerId'">
                    ALTER TABLE [Paragraph] ADD [ContainerId] NVARCHAR(MAX) NULL;
                </sql>
            </Paragraph>
        </database>
    </package>
        -->
    <package version="2044" releasedate="15-05-2017">
        <database file="Dynamic.mdb">
            <Paragraph>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Paragraph' AND COLUMN_NAME='ParagraphColumnsLarge'">
                    ALTER TABLE [Paragraph] ADD [ParagraphColumnsLarge] INT NULL;
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Paragraph' AND COLUMN_NAME='ParagraphColumnsMedium'">
                    ALTER TABLE [Paragraph] ADD [ParagraphColumnsMedium] INT NULL;
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Paragraph' AND COLUMN_NAME='ParagraphColumnsSmall'">
                    ALTER TABLE [Paragraph] ADD [ParagraphColumnsSmall] INT NULL;
                </sql>
            </Paragraph>
        </database>
    </package>

    <package version="2043" releasedate="10-05-2017">
        <database file="Dynamic.mdb">
            <RecycleBin>
                <sql conditional="">
                    ALTER TABLE [RecycleBin] ALTER COLUMN [RecycleBinDeletedAt] [datetime] not null
                </sql>
            </RecycleBin>
        </database>
    </package>

    <package version="2042" releasedate="05-04-2017">
        <database file="Dynamic.mdb">
            <Area>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Area' AND COLUMN_NAME='AreaUniqueId'">
                    ALTER TABLE [Area] ADD [AreaUniqueId] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID();
                </sql>
            </Area>
            <Page>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Page' AND COLUMN_NAME='PageUniqueId'">
                    ALTER TABLE [Page] ADD [PageUniqueId] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID();
                </sql>
            </Page>
            <Paragraph>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Paragraph' AND COLUMN_NAME='ParagraphUniqueId'">
                    ALTER TABLE [Paragraph] ADD [ParagraphUniqueId] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID();
                </sql>
            </Paragraph>
        </database>
    </package>

    <package version="2041" releasedate="04-05-2017">
        <database file="Dynamic.mdb">
            <ForumMessage>
                <sql conditional="SELECT * FROM sys.indexes WHERE ( name = N'DW_IX_ForumUserRelation_UserID' )">
                    CREATE NONCLUSTERED INDEX [DW_IX_ForumUserRelation_UserID] ON [ForumUserRelation]([ForumUserRelationUserID]);
                </sql>
            </ForumMessage>
        </database>
    </package>

    <package version="2040" releasedate="03-05-2017">
        <file name="MyListDetails.html" source="/Files/Templates/eCom/CustomerCenter" target="/Files/Templates/eCom/CustomerCenter" overwrite="false" />
    </package>

    <package version="2039" releasedate="28-04-2017">
        <database file="Dynamic.mdb">
            <ForumMessage>
                <sql conditional="SELECT * FROM sys.indexes WHERE ( name = N'DW_IX_ForumMessage_ParentId_CategoryID_IsActive' )">
                    CREATE NONCLUSTERED INDEX [DW_IX_ForumMessage_ParentId_CategoryID_IsActive] ON [ForumMessage]([ForumMessageParentId], [ForumMessageCategoryID], [ForumMessageIsActive]) INCLUDE ([ForumMessageCreated]);
                </sql>
            </ForumMessage>
        </database>
    </package>

    <package version="2038" releasedate="25-04-2017">
    	<database file="Dynamic.mdb">
            <Shop>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomShops' AND COLUMN_NAME='ShopDefaultPrintTemplate'">
                    ALTER TABLE [EcomShops] ADD [ShopDefaultPrintTemplate] NVARCHAR(MAX) NULL;
                </sql>
            </Shop>
        </database>
    </package>

    <package version="2037" releasedate="19-04-2017">
    	<database file="Dynamic.mdb">
            <Email>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EmailMarketingEmail' AND COLUMN_NAME='EmailDisableUnsubscribeTag' AND DATA_TYPE='bit'">
                    ALTER TABLE [EmailMarketingEmail] ADD [EmailDisableUnsubscribeTag] BIT NOT NULL DEFAULT 0;
                </sql>
            </Email>
        </database>
    </package>

    <package version="2036" releasedate="10-04-2017">
      <database file="Dynamic.mdb">
          <Statv2Session>
              <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Statv2Session' AND COLUMN_NAME='Statv2SessionExtranetUserID' AND DATA_TYPE='int'">
                  DECLARE @sql NVARCHAR(MAX);
                  SELECT TOP 1 @sql = N'ALTER TABLE Statv2Session DROP CONSTRAINT [' + dc.NAME + N']'
                    FROM sys.default_constraints dc
                    JOIN sys.columns c ON c.default_object_id = dc.object_id
                    WHERE dc.parent_object_id = OBJECT_ID('Statv2Session') AND c.name = N'Statv2SessionExtranetUserID'
                  IF @@ROWCOUNT > 0 EXEC (@sql)

                  IF EXISTS (SELECT * FROM sys.indexes WHERE name = N'Statv2SessionExtranetUserID')
	                DROP INDEX Statv2SessionExtranetUserID ON Statv2Session
                  IF EXISTS (SELECT * FROM sys.indexes WHERE name = N'DW_IX_Statv2Session_ExtranetUserId')
	                DROP INDEX DW_IX_Statv2Session_ExtranetUserId ON Statv2Session

                  ALTER TABLE [Statv2Session] ALTER COLUMN [Statv2SessionExtranetUserID] INT NULL;
                  ALTER TABLE [Statv2Session] ADD CONSTRAINT [DW_DF_Statv2Session_ExtranetUserId] DEFAULT ((0)) FOR [Statv2SessionExtranetUserId];
                  CREATE INDEX [DW_IX_Statv2Session_ExtranetUserId] ON [Statv2Session]([Statv2SessionExtranetUserId] ASC);
              </sql>
          </Statv2Session>
      </database>
    </package>

    <package version="2035" releasedate="21-03-2017">
      <database file="Dynamic.mdb">
        <dashboard>                      
            <sql conditional="">
                CREATE TABLE [Dashboard]
                (
                    [DashboardID] IDENTITY NOT NULL,
                    [DashboardType] nvarchar(255) NULL,
                    [DashboardPath] nvarchar(MAX) NULL,
                    [DashboardUserId] int NULL,
                    [DashboardTitle] nvarchar(255) NULL,
                    CONSTRAINT [DW_PK_DashboardID] PRIMARY KEY CLUSTERED ([DashboardID] ASC)
                )
            </sql>
            <sql conditional="">
                CREATE TABLE [DashboardWidget]
                (
                    [DashboardWidgetID] IDENTITY NOT NULL,
                    [DashboardWidgetDashboardID] int NULL,
                    [DashboardWidgetXml] nvarchar(MAX) NULL,
                    [DashboardWidgetOrder] int NOT NULL DEFAULT 0,
                    [DashboardWidgetCreatedDate] datetime NULL,
                    [DashboardWidgetUpdatedDate] datetime NULL,
                    CONSTRAINT [DW_PK_DashboardWidgetID] PRIMARY KEY CLUSTERED ([DashboardWidgetID] ASC)
                )
            </sql>
        </dashboard>
      </database>
    </package>

    <package version="2034" releasedate="20-03-2017">
        <file name="ExportUsers.xml" source="/Files/System/Integration/Jobs/ModuleSpecificJobs/UserManagementModuleJobs/ExportJobs" target="/Files/System/Integration/Jobs/ModuleSpecificJobs/UserManagementModuleJobs/ExportJobs" overwrite="true"/>        
    </package>

    <package version="2033" releasedate="02-02-2017">
		<database file="Dynamic.mdb">
            <ScheduledTask>
              <sql conditional="">
                  UPDATE [ScheduledTask] 
                  SET [TaskAssembly] = 'Dynamicweb.EmailMarketing, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null', [TaskNamespace] = 'Dynamicweb.EmailMarketing'
                  WHERE [TaskNamespace] = 'Dynamicweb.Modules.EmailMarketing';
              </sql>
            </ScheduledTask>
        </database>
    </package>

    <package version="2032" releasedate="01-02-2017">        
        <file name="Extranet_SendPasswordRecoveryEmail.html" source="/Files/Templates/ExtranetExtended" target="/Files/Templates/ExtranetExtended" overwrite="false" />
        <setting key="/Globalsettings/Modules/UserManagement/ExtranetPasswordSecurity/RecoveryTokenTimeout" value="24" />
    </package>

    <package version="2031" releasedate="31-01-2017">
        <setting key="/Globalsettings/Settings/Dictionary/DisableTranslationMarksForAngel" value="False" />
    </package>

    <package version="2030" date="30-12-2016">
		<database file="Dynamic.mdb">
		    <form>
			    <sql conditional="">
                    CREATE INDEX [DW_IX_ItemListRelation_ListId] ON [ItemListRelation]([ItemListRelationItemListId] ASC); 
			    </sql>
			    <sql conditional="">
                    CREATE INDEX [DW_IX_ItemListRelation_ItemId] ON [ItemListRelation]([ItemListRelationItemId] ASC); 
			    </sql>
		    </form>
		</database>
	</package>

    <package version="2029" date="30-01-2017" RunOnce="True">
	    <database file="Ecom.mdb">
	        <EmailDeliveryProvider>
		        <sql conditional="">
                    UPDATE [EmailDeliveryProvider] SET [DeliveryProviderConfiguration] = REPLACE(CONVERT(nvarchar(4000), [DeliveryProviderConfiguration]),'"Dynamicweb.EmailMessaging.MessageDeliveryProviders.DynamicwebSaveMessageProvider"','"Dynamicweb.Mailing.DeliveryProviders.SaveMessageProvider.SaveMessageProvider"') WHERE [DeliveryProviderConfiguration] LIKE '%"Dynamicweb.EmailMessaging.MessageDeliveryProviders.DynamicwebSaveMessageProvider"%';
                    UPDATE [EmailDeliveryProvider] SET [DeliveryProviderConfiguration] = REPLACE(CONVERT(nvarchar(4000), [DeliveryProviderConfiguration]),'"Dynamicweb.EmailMessaging.MessageDeliveryProviders.DynamicwebMandrillProvider"','"Dynamicweb.Mailing.DeliveryProviders.MandrillProvider.MandrillProvider"') WHERE [DeliveryProviderConfiguration] LIKE '%"Dynamicweb.EmailMessaging.MessageDeliveryProviders.DynamicwebMandrillProvider"%';
                    UPDATE [EmailDeliveryProvider] SET [DeliveryProviderConfiguration] = REPLACE(CONVERT(nvarchar(4000), [DeliveryProviderConfiguration]),'"Dynamicweb.EmailMessaging.MessageDeliveryProviders.DynamicwebSendGridProvider"','"Dynamicweb.Mailing.DeliveryProviders.SendGridProvider.SendGridProvider"') WHERE [DeliveryProviderConfiguration] LIKE '%"Dynamicweb.EmailMessaging.MessageDeliveryProviders.DynamicwebSendGridProvider"%';
                </sql>
            </EmailDeliveryProvider>
	    </database>
      </package>

    <package version="2028" releasedate="19-01-2017" RunOnce="True">
        <invoke type="Dynamicweb.Content.Management.UpdateScripts, Dynamicweb" method="FixItemTypeProductEditorOnDw9Upgrade" />
    </package>

    <package version="2027" releasedate="23-12-2016">
    	<database file="Dynamic.mdb">
            <Email>
                <sql conditional="">
                    ALTER TABLE [EmailMarketingEmail] ADD [EmailName] nvarchar(255) NULL;
                </sql>
            </Email>
        </database>
    </package>
      
    <package version="2026" releasedate="22-12-2016">
    	<database file="Dynamic.mdb">
            <ScheduledTask>
                <sql conditional="">
                    UPDATE [ScheduledTask] SET [TaskNamespace] = 'Dynamicweb.Indexing.Repositories.Tasks' WHERE [TaskNamespace] = 'Dynamicweb.Repositories.Tasks';
                </sql>
            </ScheduledTask>
        </database>
    </package>
    
    <package version="2025" date="15-12-2016">
		<database file="Dynamic.mdb">
		    <form>
			    <sql conditional="">
                    CREATE INDEX [DW_IX_FormSubmitDataSubmitID] ON [FormSubmitData]([FormSubmitDataSubmitID] ASC); 
			    </sql>
			    <sql conditional="">
                    CREATE INDEX [DW_IX_FormSubmitFormID] ON [FormSubmit]([FormSubmitFormID] ASC); 
			    </sql>
			    <sql conditional="">
                    CREATE INDEX [DW_IX_FormSubmitDate] ON [FormSubmit]([FormSubmitDate] ASC);
			    </sql>
		    </form>
		</database>
	</package>

    <package version="2024" releasedate="24-11-2016">
        <database file="Access.mdb">
            <AccessUserAddress>              
	            <sql conditional="">
                    ALTER TABLE [AccessUser] ADD [AccessUserAddressTitle] nvarchar(255) NULL
                </sql>
            </AccessUserAddress>
        </database>
    </package>

    <package version="2023" releasedate="07-11-2016" RunOnce="True">
        <file name="NuGet.Config" source="/Files/System/Packages" target="/Files/System/Packages" overwrite="true" />
    </package>

    <package version="2022" releasedate="24-10-2016">
        <database file="Dynamic.mdb">
            <Module>
                <sql conditional="">
                    UPDATE [Module] SET ModuleParagraph = 1 WHERE ModuleSystemName = 'UserManagementFrontend'
                </sql>
            </Module>
        </database>
    </package>
     
    <package version="2021" releasedate="19-10-2016" RunOnce="True">
        <folder action="delete" path="/Files/Templates/Audit" />
        <folder action="delete" path="/Files/Templates/Booking" />
        <folder action="delete" path="/Files/Templates/Calendar" />
        <folder action="delete" path="/Files/Templates/DBPub" />
        <folder action="delete" path="/Files/Templates/DBPub2" />
        <folder action="delete" path="/Files/Templates/Dealersearch" />
        <folder action="delete" path="/Files/Templates/DealersearchBase" />
        <folder action="delete" path="/Files/Templates/DealersearchExtranet" />
        <folder action="delete" path="/Files/Templates/DealersearchStandart" />
        <folder action="delete" path="/Files/Templates/eCards" />
        <folder action="delete" path="/Files/Templates/Editor" />
        <folder action="delete" path="/Files/Templates/FAQ" />
        <folder action="delete" path="/Files/Templates/Filemanager" />
        <folder action="delete" path="/Files/Templates/Filter" />
        <folder action="delete" path="/Files/Templates/Formmailer" />
        <folder action="delete" path="/Files/Templates/Images" />
        <folder action="delete" path="/Files/Templates/Ipaper" />
        <folder action="delete" path="/Files/Templates/Master" />
        <folder action="delete" path="/Files/Templates/MediaDB" />
        <folder action="delete" path="/Files/Templates/News" />
        <folder action="delete" path="/Files/Templates/Newsletters" />
        <folder action="delete" path="/Files/Templates/NewsletterSubscription" />
        <folder action="delete" path="/Files/Templates/NewsLetterV3" />
        <folder action="delete" path="/Files/Templates/Page" />
        <folder action="delete" path="/Files/Templates/PageFeatures" />
        <folder action="delete" path="/Files/Templates/ParagraphSetup" />
        <folder action="delete" path="/Files/Templates/Poll" />
        <folder action="delete" path="/Files/Templates/Recommendation" />
        <folder action="delete" path="/Files/Templates/RSSfeed" />
        <folder action="delete" path="/Files/Templates/StatisticsExtended" />
        <folder action="delete" path="/Files/Templates/StatisticsV3" />
        <folder action="delete" path="/Files/Templates/Survey" />
        <folder action="delete" path="/Files/Templates/Validation" />
    </package>

    <package version="2020" releasedate="07-10-2016">
        <setting key="/Globalsettings/Settings/CustomerAccess/LockAccessToItems" value="True" overwrite="true" />
    </package>

    <package version="2019" date="13-09-2016">
		<database file="Dynamic.mdb">
		    <area>
			    <sql conditional="">
                    DELETE FROM [EcomRecurringOrder] WHERE [RecurringOrderInterval] = 0
			    </sql>
		    </area>
		</database>
	</package>

    <package version="2018" releasedate="02-09-2016">
        <database file="Dynamic.mdb">
            <Module>
	            <sql conditional="">
                    IF (SELECT COUNT(*) FROM [Module] WHERE [ModuleSystemName] = 'UserManagementFrontend') > 0
	                    DELETE FROM [Module] WHERE ModuleSystemName = 'UserManagementFrontendExtended';
                    Else
	                    IF (SELECT COUNT(*) FROM [Module] WHERE [ModuleSystemName] = 'UserManagementFrontendExtended') > 0
		                    UPDATE [Module] SET [ModuleSystemName] = 'UserManagementFrontend' WHERE [ModuleSystemName] = 'UserManagementFrontendExtended';

                    UPDATE [Module] SET [ModuleParagraphEditPath] = '/Admin/Module/UserManagement', [ModuleIconClass] = 'Lock' WHERE [ModuleSystemName] = 'UserManagementFrontend';
                    UPDATE [Paragraph] SET [ParagraphModuleSystemName] = 'UserManagementFrontend' WHERE [ParagraphModuleSystemName] = 'UserManagementFrontendExtended';
                </sql>
	        </Module>
        </database>
    </package>

    <package version="2017" releasedate="25-07-2016">
		<database file="Dynamic.mdb">
            <Module>
			    <sql conditional="">
                    UPDATE [Module] SET [ModuleScript] = NULL WHERE [ModuleSystemName] = 'Workflow';
			    </sql>
	        </Module>
		</database>
	</package>

    <package version="2016" releasedate="24-06-2016">
        <setting key="/Globalsettings/Settings/Updates/DisableTemplateUpdates" value="False" overwrite="true" />
        <setting key="/Globalsettings/Settings/CustomerAccess/ShowAreabox" value="True" overwrite="true" />
        <setting key="/Globalsettings/Settings/CustomerAccess/LockNavigationFolder" value="False" overwrite="true" />
        <setting key="/Globalsettings/Modules/ImportExport/checkToken" value="True" overwrite="true" />
    </package>

    <package version="2015" releasedate="24-06-2016">
      <database file="Dynamic.mdb">
            <Paragraph>
	            <sql conditional="">
                    ALTER TABLE [Paragraph] DROP CONSTRAINT [DW_DF_Paragraph_BottomSpace]
                </sql>
            <sql conditional="">
                    ALTER TABLE [Paragraph] DROP CONSTRAINT [DW_DF_Paragraph_ImageHAlign]
            </sql>
            <sql conditional="">
                    ALTER TABLE [Paragraph] DROP CONSTRAINT [DW_DF_Paragraph_ImageHSpace]
            </sql>
            <sql conditional="">
                    ALTER TABLE [Paragraph] DROP CONSTRAINT [DW_DF_Paragraph_ImageVAlign]
		    </sql>
		    <sql conditional="">
                    ALTER TABLE [Paragraph] DROP CONSTRAINT [DW_DF_Paragraph_ImageVSpace]
		    </sql>		          
	        </Paragraph>
        </database>
    </package>

    <package version="2014" releasedate="24-06-2016">
      <database file="Dynamic.mdb">
            <Module>
            <sql conditional="">
                    UPDATE [Module] SET [ModuleIconClass] = 'Lock' WHERE [ModuleSystemName] = 'UserManagementFrontendExtended';
                    UPDATE [Module] SET [ModuleIconClass] = 'Star' WHERE [ModuleSystemName] = 'eCom_ShowList';
                    UPDATE [Module] SET [ModuleIconClass] = 'ViewQuilt' WHERE [ModuleSystemName] = 'eCom_Assortments';
                    UPDATE [Module] SET [ModuleIconClass] = 'Archive' WHERE [ModuleSystemName] = 'eCom_BackCatalog';
                    UPDATE [Module] SET [ModuleIconClass] = 'WalletGiftcard' WHERE [ModuleSystemName] = 'GiftCards';
                    UPDATE [Module] SET [ModuleIconClass] = 'Public' WHERE [ModuleSystemName] = 'eCom_International';
                    UPDATE [Module] SET [ModuleIconClass] = 'Store' WHERE [ModuleSystemName] = 'eCom_MultiShopAdvanced';
                    UPDATE [Module] SET [ModuleIconClass] = 'Tags' WHERE [ModuleSystemName] = 'eCom_DiscountMatrix';
                    UPDATE [Module] SET [ModuleIconClass] = 'List' WHERE [ModuleSystemName] = 'eCom_PartsListsExtended';
                    UPDATE [Module] SET [ModuleIconClass] = 'List' WHERE [ModuleSystemName] = 'eCom_PartsLists';
                    UPDATE [Module] SET [ModuleIconClass] = 'Payment' WHERE [ModuleSystemName] = 'eCom_Payment';
                    UPDATE [Module] SET [ModuleIconClass] = 'FlashOn' WHERE [ModuleSystemName] = 'eCom_PowerPack';
                    UPDATE [Module] SET [ModuleIconClass] = 'Money' WHERE [ModuleSystemName] = 'eCom_PricingExtended';
                    UPDATE [Module] SET [ModuleIconClass] = 'Money' WHERE [ModuleSystemName] = 'eCom_Pricing';
                    UPDATE [Module] SET [ModuleIconClass] = 'Search' WHERE [ModuleSystemName] = 'eCom_Search';
                    UPDATE [Module] SET [ModuleIconClass] = 'Search' WHERE [ModuleSystemName] = 'eCom_SearchExtended';
                    UPDATE [Module] SET [ModuleIconClass] = 'CircleO' WHERE [ModuleSystemName] = 'eCom_Units';
                    UPDATE [Module] SET [ModuleIconClass] = 'AssignmentTurnedIn' WHERE [ModuleSystemName] = 'eCom_Quotes';
                    UPDATE [Module] SET [ModuleIconClass] = 'AvTimer' WHERE [ModuleSystemName] = 'eCom_RecurringOrders';
                    UPDATE [Module] SET [ModuleIconClass] = 'GroupWork' WHERE [ModuleSystemName] = 'eCom_Related';
                    UPDATE [Module] SET [ModuleIconClass] = 'Tag' WHERE [ModuleSystemName] = 'eCom_SalesDiscount';
                    UPDATE [Module] SET [ModuleIconClass] = 'Tag' WHERE [ModuleSystemName] = 'eCom_SalesDiscountExtended';
                    UPDATE [Module] SET [ModuleIconClass] = 'ShoppingCart' WHERE [ModuleSystemName] = 'eCom_CartV2';
                    UPDATE [Module] SET [ModuleIconClass] = 'PieChart' WHERE [ModuleSystemName] = 'eCom_Statistics';
                    UPDATE [Module] SET [ModuleIconClass] = 'HdrWeak' WHERE [ModuleSystemName] = 'eCom_Variants';
                    UPDATE [Module] SET [ModuleIconClass] = 'HdrWeak' WHERE [ModuleSystemName] = 'eCom_VariantsExtended';
                    UPDATE [Module] SET [ModuleIconClass] = 'Ticket' WHERE [ModuleSystemName] = 'eCom_Vouchers';
                    UPDATE [Module] SET [ModuleIconClass] = 'AccountBalanceWallet' WHERE [ModuleSystemName] = 'eCom_economic';
                    UPDATE [Module] SET [ModuleIconClass] = 'ImportExport' WHERE [ModuleSystemName] = 'eCom_DataIntegrationERPBatch';
                    UPDATE [Module] SET [ModuleIconClass] = 'ImportExport' WHERE [ModuleSystemName] = 'eCom_DataIntegrationERPLiveIntegration';
                    UPDATE [Module] SET [ModuleIconClass] = 'Tachometer' WHERE [ModuleSystemName] = 'SeoExpress';
                    UPDATE [Module] SET [ModuleIconClass] = 'Tasks' WHERE [ModuleSystemName] = 'DM_Form_Extended';
                    UPDATE [Module] SET [ModuleIconClass] = 'Person' WHERE [ModuleSystemName] = 'UserManagementBackendExtended';
            </sql>  
            </Module>
        </database>
    </package>

    <package version="2013" releasedate="22-06-2016">
        <database file="Dynamic.mdb">
            <Module>
            <sql conditional="">
                    UPDATE [Module] SET [ModuleIconClass] = 'LibraryBooks' WHERE [ModuleSystemName] = 'RemoteHttp';
                    UPDATE [Module] SET [ModuleIconClass] = 'Assignment' WHERE [ModuleSystemName] = 'eCom_ContextOrderRenderer';
                    UPDATE [Module] SET [ModuleIconClass] = 'Ticket' WHERE [ModuleSystemName] = 'eCom_ContextVoucherRenderer';
                    UPDATE [Module] SET [ModuleIconClass] = 'AssignmentInd' WHERE [ModuleSystemName] = 'eCom_CustomerCenter';
                    UPDATE [Module] SET [ModuleIconClass] = 'SignIn' WHERE [ModuleSystemName] = 'ImportExport_DW8';
                    UPDATE [Module] SET [ModuleIconClass] = 'List' WHERE [ModuleSystemName] = 'DM_Publishing';
                    UPDATE [Module] SET [ModuleIconClass] = 'Email' WHERE [ModuleSystemName] = 'EmailMarketing';
                    UPDATE [Module] SET [ModuleIconClass] = 'Lock' WHERE [ModuleSystemName] = 'UserManagementFrontend';
                    UPDATE [Module] SET [ModuleIconClass] = 'FolderOpen' WHERE [ModuleSystemName] = 'Filepublish';
                    UPDATE [Module] SET [ModuleIconClass] = 'Tasks' WHERE [ModuleSystemName] = 'DM_Form';
                    UPDATE [Module] SET [ModuleIconClass] = 'Tasks' WHERE [ModuleSystemName] = 'BasicForms';
                    UPDATE [Module] SET [ModuleIconClass] = 'Forum' WHERE [ModuleSystemName] = 'BasicForum';
                    UPDATE [Module] SET [ModuleIconClass] = 'PhotoLibrary' WHERE [ModuleSystemName] = 'Gallery';
                    UPDATE [Module] SET [ModuleIconClass] = 'AssignmentInd' WHERE [ModuleSystemName] = 'eCom_IntegrationCustomerCenter';
                    UPDATE [Module] SET [ModuleIconClass] = 'Cube' WHERE [ModuleSystemName] = 'ItemCreator';
                    UPDATE [Module] SET [ModuleIconClass] = 'Cube' WHERE [ModuleSystemName] = 'ItemPublisher';
                    UPDATE [Module] SET [ModuleIconClass] = 'Language' WHERE [ModuleSystemName] = 'LanguageManagement';
                    UPDATE [Module] SET [ModuleIconClass] = 'Flag' WHERE [ModuleSystemName] = 'Leads';
                    UPDATE [Module] SET [ModuleIconClass] = 'CodeFork' WHERE [ModuleSystemName] = 'LoadBalancing';
                    UPDATE [Module] SET [ModuleIconClass] = 'Loyalty' WHERE [ModuleSystemName] = 'LoyaltyPoints';
                    UPDATE [Module] SET [ModuleIconClass] = 'MapMaker' WHERE [ModuleSystemName] = 'Maps';
                    UPDATE [Module] SET [ModuleIconClass] = 'Equalizer' WHERE [ModuleSystemName] = 'OMC';
                    UPDATE [Module] SET [ModuleIconClass] = 'ViewArray' WHERE [ModuleSystemName] = 'NewsV2';
                    UPDATE [Module] SET [ModuleIconClass] = 'AccountBox' WHERE [ModuleSystemName] = 'Profiling';
                    UPDATE [Module] SET [ModuleIconClass] = 'Archive' WHERE [ModuleSystemName] = 'eCom_Catalog';
                    UPDATE [Module] SET [ModuleIconClass] = 'FilterList' WHERE [ModuleSystemName] = 'QueryPublisher';
                    UPDATE [Module] SET [ModuleIconClass] = 'Search' WHERE [ModuleSystemName] = 'Searchv1';
                    UPDATE [Module] SET [ModuleIconClass] = 'Assignment' WHERE [ModuleSystemName] = 'eCom_CartV2';
                    UPDATE [Module] SET [ModuleIconClass] = 'Sitemap' WHERE [ModuleSystemName] = 'SitemapV2';
                    UPDATE [Module] SET [ModuleIconClass] = 'Sms' WHERE [ModuleSystemName] = 'Sms';
                    UPDATE [Module] SET [ModuleIconClass] = 'Users' WHERE [ModuleSystemName] = 'SocialMediaPublishing';
                    UPDATE [Module] SET [ModuleIconClass] = 'Clipboard' WHERE [ModuleSystemName] = 'Update';
                    UPDATE [Module] SET [ModuleIconClass] = 'Person' WHERE [ModuleSystemName] = 'UserManagementBackend';
                    UPDATE [Module] SET [ModuleIconClass] = 'Filter9' WHERE [ModuleSystemName] = 'VersionControl';
                    UPDATE [Module] SET [ModuleIconClass] = 'Layers' WHERE [ModuleSystemName] = 'Area';
                    UPDATE [Module] SET [ModuleIconClass] = 'PlayInstall' WHERE [ModuleSystemName] = 'Workflow';
            </sql>
            </Module>
        </database>
    </package>

    <package version="2012" releasedate="20-06-2016">
        <invoke type="Dynamicweb.Content.Management.UpdateScripts, Dynamicweb" method="UpdateDw8IconsToDw9KnownIcons" />
    </package>

    <package version="2011" releasedate="27-05-2016">
        <database file="Dynamic.mdb">
            <Module>
                <sql conditional="">
                    UPDATE [Paragraph] Set [ParagraphSort] = 1 WHERE [ParagraphSort] = 0
                </sql>
	        </Module>
        </database>
    </package>

    <package version="2010" releasedate="05-05-2016">
        <database file="Dynamic.mdb">
            <Module>
                <sql conditional="">
                    UPDATE [Module] SET [ModuleParagraph] = 0 WHERE [ModuleSystemName] = 'eCom_ShowList'                 
		        </sql>
			</Module>
		</database>
    </package>

    <package version="2009" releasedate="27-04-2016">
        <database file="Dynamic.mdb">
            <Module>
		        <sql conditional="">
                    WITH cte AS (
                        SELECT [ModuleSystemName], [ModuleAccess], ROW_NUMBER() OVER(PARTITION BY [ModuleSystemName] ORDER BY [ModuleSystemName], [ModuleAccess] DESC ) rnk
                        FROM [Module]
                    )
                    DELETE FROM cte WHERE rnk > 1;
		        </sql>		
            </Module>
        </database>
    </package>
    
    <package version="2008" releasedate="26-04-2016">
		<database file="Dynamic.mdb">
            <ScheduledTask>
              <sql conditional="">
                  UPDATE [ScheduledTask] SET [TaskAssembly] = 'Dynamicweb.Scheduling.Providers.AssortmentItemBuilderScheduledTaskAddIn.AssortmentItemBuilderScheduledTaskAddIn' WHERE [TaskAssembly] = 'Dynamicweb.Ecommerce.Assortments.AssortmentItemBuilderScheduledTaskAddIn';
                  UPDATE [ScheduledTask] SET [TaskAssembly] = 'Dynamicweb.Scheduling.Providers.CalculatedFieldsScheduledTaskAddIn.CalculatedFieldsScheduledTaskAddIn' WHERE [TaskAssembly] = 'Dynamicweb.eCommerce.CalculatedFields.CalculatedFieldsScheduledTaskAddIn';
                  UPDATE [ScheduledTask] SET [TaskAssembly] = 'Dynamicweb.Scheduling.Providers.CalculateSmartSearchScheduledTaskAddIn.CalculateSmartSearchScheduledTaskAddIn' WHERE [TaskAssembly] = 'Dynamicweb.Modules.Searching.SmartSearch.CalculateSmartSearchScheduledTastAddIn';
                  UPDATE [ScheduledTask] SET [TaskAssembly] = 'Dynamicweb.Scheduling.Providers.GroupsAsSmartSearchesScheduledTaskAddIn.GroupsAsSmartSearchesScheduledTaskAddIn' WHERE [TaskAssembly] = 'Dynamicweb.Modules.UserManagement.GroupsAsSmartSearchesScheduledTaskAddIn';
                  UPDATE [ScheduledTask] SET [TaskAssembly] = 'Dynamicweb.Scheduling.Providers.PointExpirationScheduledTaskAddIn.PointExpirationScheduledTaskAddIn' WHERE [TaskAssembly] = 'Dynamicweb.Ecommerce.Loyalty.PointExpirationScheduledTaskAddIn';
                  UPDATE [ScheduledTask] SET [TaskAssembly] = 'Dynamicweb.Scheduling.Providers.RecurringOrdersScheduledTaskAddIn.RecurringOrdersScheduledTaskAddIn' WHERE [TaskAssembly] = 'Dynamicweb.eCommerce.Orders.RecurringOrdersScheduledTaskAddIn';
              </sql>
            </ScheduledTask>
        </database>
    </package>

    <package version="2007" releasedate="20-04-2016">
        <database file="Dynamic.mdb">
			<Module>
              <sql conditional="">
                  UPDATE [Module] SET [ModuleName] = 'Websites' WHERE ModuleSystemName = 'Area'
              </sql>
			</Module>
		</database>
    </package>

    <package version="2006" releasedate="12-04-2016">
        <database file="Dynamic.mdb">
			<Module>
              <sql conditional="">
                  ALTER TABLE [Module] ADD ModuleIconClass nvarchar(255) NULL
              </sql>
			</Module>
		</database>
    </package>
   
    <package version="2005" releasedate="08-04-2016">
		<database file="Dynamic.mdb">
            <Module>
              <sql conditional="">
                  UPDATE [Module] SET [ModuleName] = 'Ecom varekatalog' WHERE ModuleSystemName = 'eCom_Catalog'
              </sql>
			</Module>
      </database>
    </package>

    <package version="2004" releasedate="31-03-2016">
        <database file="Dynamic.mdb">
	        <Area>
	            <sql conditional="">
                    ALTER TABLE Area ALTER COLUMN AreaDomain nvarchar(255) NULL
                </sql>                                
	        </Area>
        </database>
    </package>
    <package version="2003" releasedate="31-03-2016">
        <file name="ExportUsers.xml" source="/Files/System/Integration/Jobs/ModuleSpecificJobs/UserManagementModuleJobs/ExportJobs" target="/Files/System/Integration/Jobs/ModuleSpecificJobs/UserManagementModuleJobs/ExportJobs" overwrite="true"/>
        <file name="ExportUsersWithSelectedColumns.xml" source="/Files/System/Integration/Jobs/ModuleSpecificJobs/UserManagementModuleJobs/ExportJobs" target="/Files/System/Integration/Jobs/ModuleSpecificJobs/UserManagementModuleJobs/ExportJobs" overwrite="true"/>
        <file name="ImportUsers.xml" source="/Files/System/Integration/Jobs/ModuleSpecificJobs/UserManagementModuleJobs/ImportJobs" target="/Files/System/Integration/Jobs/ModuleSpecificJobs/UserManagementModuleJobs/ImportJobs" overwrite="true" />
        <file name="ImportUsersFromExcel.xml" source="/Files/System/Integration/Jobs/ModuleSpecificJobs/UserManagementModuleJobs/ImportJobs" target="/Files/System/Integration/Jobs/ModuleSpecificJobs/UserManagementModuleJobs/ImportJobs" overwrite="true" />
        <file name="ErpDataImport.xml" source="/Files/System/Integration/Jobs" target="/Files/System/Integration/Jobs" overwrite="true" />
        <file name="ErpOrderExport.xml" source="/Files/System/Integration/Jobs" target="/Files/System/Integration/Jobs" overwrite="true" />
        <file name="ErpUserExport.xml" source="/Files/System/Integration/Jobs" target="/Files/System/Integration/Jobs" overwrite="true" />
        <file name="ErpUserImport.xml" source="/Files/System/Integration/Jobs" target="/Files/System/Integration/Jobs" overwrite="true" />
    </package>

    <package version="2002" releasedate="22-03-2016">
        <file name="advanced.js" source="/Files/System/Editor/ckeditor/config/" target="/Files/System/Editor/ckeditor/config/" overwrite="true" />
        <file name="basic.js" source="/Files/System/Editor/ckeditor/config/" target="/Files/System/Editor/ckeditor/config/" overwrite="true" />
        <file name="clean.js" source="/Files/System/Editor/ckeditor/config/" target="/Files/System/Editor/ckeditor/config/" overwrite="true" />
        <file name="default.js" source="/Files/System/Editor/ckeditor/config/" target="/Files/System/Editor/ckeditor/config/" overwrite="true" />
        <file name="developer.js" source="/Files/System/Editor/ckeditor/config/" target="/Files/System/Editor/ckeditor/config/" overwrite="true" />
        <file name="email.js" source="/Files/System/Editor/ckeditor/config/" target="/Files/System/Editor/ckeditor/config/" overwrite="true" />
    </package>

    <package version="2001" releasedate="11-03-2016">
		<database file="Dynamic.mdb">
		    <Module>
                <sql conditional="">                    
                    DELETE FROM [Module]
                    WHERE ModuleSystemName = 'Accessibility' OR
                     ModuleSystemName = 'Audit' OR
                        ModuleSystemName = 'Booking' OR
                        ModuleSystemName = 'eCards' OR
                        ModuleSystemName = 'Calender' OR
                        ModuleSystemName = 'Calendar' OR
                        ModuleSystemName = 'CalendarV2' OR
                        ModuleSystemName = 'Contentsubscription' OR
                        ModuleSystemName = 'CRMIntegration' OR
                        ModuleSystemName = 'DealerSearch' OR
                        ModuleSystemName = 'eCards' OR
                        ModuleSystemName = 'CRMIntegration' OR
                        ModuleSystemName = 'DbPub' OR
                        ModuleSystemName = 'DBIntegration' OR
                        ModuleSystemName = 'DealerSearch' OR
                        ModuleSystemName = 'eCards' OR
                        ModuleSystemName = 'Employee' OR
                        ModuleSystemName = 'FactBoxes' OR
                        ModuleSystemName = 'FAQ' OR	
                        ModuleSystemName = 'Form' OR	        
                        ModuleSystemName = 'FormExtended' OR	        
                        ModuleSystemName = 'Forum' OR	        
                        ModuleSystemName = 'ForumV2' OR	        
                        ModuleSystemName = 'ImageGallery' OR	        
                        ModuleSystemName = 'DW_Integration_ImportExport' OR	        
                        ModuleSystemName = 'DW_Integration_ImportExportExtended' OR	        
                        ModuleSystemName = 'IndexingSearching' OR
                        ModuleSystemName = 'ControlLoader' OR
                        ModuleSystemName = 'iPaper' OR
                        ModuleSystemName = 'IpaperExtended' OR
                        ModuleSystemName = 'Keywordfinder' OR
                        ModuleSystemName = 'LanguagePack' OR
                        ModuleSystemName = 'LinkSearch' OR
                        ModuleSystemName = 'MediaDatabase' OR
                        ModuleSystemName = 'Metadata' OR
                        ModuleSystemName = 'Mindwork' OR
                        ModuleSystemName = 'PaymentGateway' OR
                        ModuleSystemName = 'ProductGallery' OR
                        ModuleSystemName = 'News' OR
                        ModuleSystemName = 'NewsLetter' OR
                        ModuleSystemName = 'NewsLetterExtended' OR
                        ModuleSystemName = 'NewsLetterV3' OR
                        ModuleSystemName = 'Poll' OR
                        ModuleSystemName = 'Rotation' OR
                        ModuleSystemName = 'RSSFeed' OR
                        ModuleSystemName = 'Seo' OR
                        ModuleSystemName = 'ShoppingCart' OR
                        ModuleSystemName = 'ShoppingCartV1' OR
                        ModuleSystemName = 'Sitemap' OR
                        ModuleSystemName = 'SmsOld' OR
                        ModuleSystemName = 'Statistics' OR
                        ModuleSystemName = 'StatisticsExtended' OR
                        ModuleSystemName = 'StatisticsV3' OR
                        ModuleSystemName = 'Survey' OR
                        ModuleSystemName = 'Tagwall' OR
                        ModuleSystemName = 'Template' OR
                        ModuleSystemName = 'Weblog' OR
                        ModuleSystemName = 'Recommendation'
                </sql>
		    </Module>
        </database>
    </package>

    <package version="2000" releasedate="02-24-2016">
        <database file="Dynamic.mdb">
            <RecycleBin>
                <sql conditional="">    
			        CREATE TABLE [RecycleBin](
	        [RecycleBinID] [int] IDENTITY(1,1) NOT NULL,
	        [RecycleBinType] [nvarchar](250) NOT NULL,
	        [RecycleBinObjectID] [nvarchar](250) NOT NULL,
	        [RecycleBinDescription] [nvarchar](250) NOT NULL,
	        [RecycleBinData] [nvarchar](max) NOT NULL,
	        [RecycleBinDeletedBy] [nvarchar](50) NOT NULL,
	        [RecycleBinDeletedAt] [date] NOT NULL,
	        [RecycleBinUnitID] [uniqueidentifier] NOT NULL,
	        [RecycleBinUnitPrimary] [bit] NOT NULL,
         CONSTRAINT [PK_RecycleBin] PRIMARY KEY CLUSTERED 
                    (
	        [RecycleBinID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
                </sql>                
                </RecycleBin>
        </database>
    </package>

    <package version="982" releasedate="14-10-2016">
        <database file="Access.mdb">
            <AccessUserAddress>              
	            <sql conditional="">
                    sp_rename 'AccessUserAddress.AccessUserAddressDefaultAddresCustomFields', 'AccessUserAddressDefaultAddressCustomFields', 'COLUMN'; 
                </sql>
            </AccessUserAddress>
        </database>
    </package>
    
    <package version="981" releasedate="23-09-2016">
        <database file="Access.mdb">
            <AccessUserAddress>              
	            <sql conditional="SELECT * FROM sys.columns WHERE Name = N'AccessUserAddressDefaultAddressCustomFields'">
                    ALTER TABLE [AccessUserAddress] ADD [AccessUserAddressDefaultAddresCustomFields] BIT NOT NULL DEFAULT 0
                </sql>
            </AccessUserAddress>
        </database>
    </package>

    <package version="980" releasedate="23-09-2016">
		<database file="Dynamic.mdb">
			<ScheduledTask>				
				<sql conditional="">ALTER TABLE [ScheduledTask] ALTER COLUMN [TaskTarget] NVARCHAR(2550) NULL</sql>
			</ScheduledTask>
		</database>
	</package>    
        
    <package version="979" date="21-09-2016">
		<database file="Dynamic.mdb">
		    <AccessUserPassword>
			    <sql conditional="">
                    ALTER TABLE [AccessUserPassword] ALTER COLUMN [AccessUserPasswordPassword] NVARCHAR(255) NULL
			    </sql>
		    </AccessUserPassword>
		</database>
        <invoke type="Dynamicweb.Content.Management.UpdateScripts, Dynamicweb" method="FixOldPasswords" />
	</package>

    <package version="978" date="20-09-2016">
		<database file="Dynamic.mdb">
		    <area>
			    <sql conditional="">
                    UPDATE [Module] SET ModuleIsBeta = 0 WHERE ModuleSystemName = 'QueryPublisher'
			    </sql>
		    </area>
		</database>
	</package>

    <package version="977" releasedate="16-09-2016">
        <database file="Access.mdb">
            <AccessUser>              
	            <sql conditional="">
                    ALTER TABLE [AccessUser] ADD [AccessUserCountryCode] NVARCHAR(2) NULL
                </sql>
            </AccessUser>
            <AccessUserAddress>              
	            <sql conditional="">
                    ALTER TABLE [AccessUserAddress] ADD [AccessUserAddressCountryCode] NVARCHAR(2) NULL
                </sql>
            </AccessUserAddress>
        </database>
    </package>

    <package version="976" releasedate="12-09-2016">        
        <file name="BuildNotificationTemplate.html" source="/Files/Templates/Repositories/Indexes/Notifications" target="/Files/Templates/Repositories/Indexes/Notifications" overwrite="false" />
    </package>

    <package version="975" releasedate="05-09-2016">
        <database file="Access.mdb">
            <AccessUser>
	            <sql conditional="">
                    ALTER TABLE [AccessUser] ALTER COLUMN [AccessUserStockLocationID] BIGINT NULL
                </sql>
            </AccessUser>
        </database>
    </package>

    <package version="974" date="05-09-2016">
		<database file="Dynamic.mdb">
		    <area>
			    <sql conditional="">
                    ALTER TABLE [Area] ALTER COLUMN [AreaStockLocationID] BIGINT NULL
			    </sql>
		    </area>
		</database>
	</package>

    <package version="973" releasedate="30-06-2016">
        <database file="Access.mdb">
            <AccessUser>              
	            <sql conditional="">
                    ALTER TABLE [AccessUser] ADD [AccessUserStockLocationID] INT NULL
                </sql>
            </AccessUser>
        </database>
    </package>

    <package version="972" date="30-06-2016">
		<database file="Dynamic.mdb">
		    <area>
			    <sql conditional="">
                    ALTER TABLE [Area] ADD [AreaStockLocationID] INT NULL
			    </sql>
		    </area>
		</database>
	</package>

    <package version="971" releasedate="07-06-2016">
        <database file="Access.mdb">
            <AccessUserAddress>              
	            <sql conditional="">
                    ALTER TABLE [AccessUser] ADD [AccessUserAddressTitle] nvarchar(255) NULL
                </sql>
            </AccessUserAddress>
        </database>
    </package>

    <package version="970" releasedate="03-03-2016">
      <database file="Dynamic.mdb">
        <form>                      
            <sql conditional="">
				ALTER TABLE [FormField] ADD [FormFieldSize] int NULL
            </sql>  
            <sql conditional="">
              CREATE TABLE [FormSubmit](
              [FormSubmitID] int IDENTITY NOT NULL,
              [FormSubmitFormID] int NULL DEFAULT 0,
              [FormSubmitDate] datetime NULL DEFAULT date(),
              [FormSubmitIp] nvarchar(30) NULL,
              [FormSubmitSessionId] nvarchar(30) NULL,
              [FormSubmitPageId] int NULL
              )
            </sql>
            <sql conditional="">
              CREATE TABLE [FormSubmitData](
              [FormSubmitDataID] int IDENTITY NOT NULL,
              [FormSubmitDataSubmitID] int NULL DEFAULT 0,
              [FormSubmitDataFieldID] int NULL DEFAULT 0,
              [FormSubmitDataFieldname] nvarchar(255) NULL,
              [FormSubmitDataValue] nvarchar(max) NULL)
            </sql>
            <sql conditional="">
			CREATE TABLE [FormRule]
            (
	            [FormRuleId] int IDENTITY NOT NULL,
		        [FormRuleType] int NULL DEFAULT 0,
		        [FormRuleFormID] int NULL,
	            [FormRuleName] TEXT NULL,
	            [FormRuleActive] bit NULL DEFAULT blnTrue,
	            [FormRuleMessage] nvarchar(MAX) NULL
        	)
		    </sql>
		    <sql conditional="">
			    CREATE TABLE [FormRuleCondition]
                (
	                [FormRuleConditionId] int IDENTITY NOT NULL,
                    [FormRuleConditionSort] int NULL DEFAULT 1,
                    [FormRuleConditionOperatorPrevious] int NULL DEFAULT 0,
	                [FormRuleConditionRuleId] int NULL,
	                [FormRuleConditionFieldId] int NULL,
	                [FormRuleConditionType] int NULL,
	                [FormRuleConditionParam1] nvarchar(MAX) NULL,
                    [FormRuleConditionParam2] nvarchar(MAX) NULL
                )
		    </sql>		
          <sql conditional="">
            CREATE INDEX [DW_PK_FormSubmitData] ON [FormSubmitData]([FormSubmitDataID] ASC);        
          </sql>
          <sql conditional="">
            CREATE INDEX [DW_PK_FormSubmit] ON [FormSubmit]([FormSubmitID] ASC);
          </sql>
          <sql conditional="">
            CREATE INDEX [DW_PK_FormRuleCondition] ON [FormRuleCondition]([FormRuleConditionId] ASC);
          </sql>
          <sql conditional="">
            CREATE INDEX [DW_PK_FormRule] ON [FormRule]([FormRuleId] ASC);
          </sql>
        </form>
      </database>
    </package>

    <package version="969" releasedate="01-13-2016">
        <database file="Dynamic.mdb">
            <UrlPath>                
	            <sql conditional="">
                    ALTER TABLE [UrlPath] ADD [UrlPathVisitsCount] INT NOT NULL DEFAULT 0
                </sql>                                
                <sql conditional="">                    
                    UPDATE [UrlPath] SET [UrlPathVisitsCount] = [VisitsCount] WHERE [VisitsCount] IS NOT NULL
                </sql>
                <sql conditional="">    
                    ALTER TABLE [UrlPath] DROP [VisitsCount]
                </sql>                
	        </UrlPath>
        </database>
    </package>

    <package version="968" releasedate="01-13-2016">
        <database file="Access.mdb">
            <AccessUserAddress>              
	            <sql conditional="">
                    ALTER TABLE [AccessUserAddress] ADD [AccessUserAddressPhoneBusiness] nvarchar(255) NULL
                </sql>
            </AccessUserAddress>
        </database>
    </package>

    <package version="967" releasedate="18-12-2015">
        <invoke type="Dynamicweb.Content.Management.UpdateScripts, Dynamicweb" method="Fix20388" />
    </package>

    <package version="966" releasedate="09-12-2015">
        <file name="LoginWithImpersonation.html" source="/Files/Templates/UserManagement/Login" target="/Files/Templates/UserManagement/Login" overwrite="false" />
    </package>

    <package version="965" releasedate="25-11-2015">        
    </package>

    <package version="964" releasedate="24-11-2015">
        <database file="Dynamic.mdb">
            <UrlPath>                
	            <sql conditional="">
                    ALTER TABLE [FormSubmit] ADD
                    [FormSubmitUserId] int NULL
                </sql>
	        </UrlPath>
        </database>
    </package>

    <package version="963" releasedate="23-11-2015">
        <database file="Dynamic.mdb">
            <UrlPath>                
	            <sql conditional="">
                    ALTER TABLE [UrlPath] ADD
                    [VisitsCount] int NULL
                </sql>
	        </UrlPath>
        </database>
    </package>

    <package version="962" releasedate="19-11-2015">
        <database file="Statisticsv2.mdb">
            <Statv2SessionBot>
                <sql conditional="SELECT * FROM sys.indexes WHERE ( name = N'DW_IX_Statv2SessionBot_Timestamp' )">
                    CREATE NONCLUSTERED INDEX [DW_IX_Statv2SessionBot_Timestamp] ON [Statv2SessionBot]([Statv2SessionTimestamp] ASC);
                </sql>
                <sql conditional="SELECT * FROM sys.indexes WHERE ( name = N'DW_IX_GeneralLog_LogDate' )">
                    CREATE NONCLUSTERED INDEX [DW_IX_GeneralLog_LogDate] ON [GeneralLog]([LogDate] ASC);
                </sql>
                <sql conditional="SELECT * FROM sys.indexes WHERE ( name = N'DW_IX_ActionLog_LogDate' )">
                    CREATE NONCLUSTERED INDEX [DW_IX_ActionLog_LogDate] ON [ActionLog]([LogDate] ASC);
                </sql>
                <sql conditional="SELECT * FROM sys.indexes WHERE ( name = N'DW_IX_TrashBin_TrashDate' )">
                    CREATE NONCLUSTERED INDEX [DW_IX_TrashBin_TrashDate] ON [TrashBin]([TrashBinTrashDate] ASC);
                </sql>
            </Statv2SessionBot>
        </database>
    </package>

    <package version="961" releasedate="11-11-2015">
        <file name="ProductDetailsComments.cshtml" source="/Files/Templates/eCom/Product" target="/Files/Templates/eCom/Product" overwrite="false" />         
    </package>
    
    <package version="960" releasedate="10-11-2015">
        <file name="DefaultConfirmation.cshtml" source="/Files/Templates/Forms/Confirmation" target="/Files/Templates/Forms/Confirmation" overwrite="false" />
        <file name="DefaultConfirmation.html" source="/Files/Templates/Forms/Confirmation" target="/Files/Templates/Forms/Confirmation" overwrite="false" />
        <file name="DefaultForm.cshtml" source="/Files/Templates/Forms/Form" target="/Files/Templates/Forms/Form" overwrite="false" />
        <file name="DefaultForm.html" source="/Files/Templates/Forms/Form" target="/Files/Templates/Forms/Form" overwrite="false" />
        <file name="DefaultMail.cshtml" source="/Files/Templates/Forms/Mail" target="/Files/Templates/Forms/Mail" overwrite="false" />
        <file name="DefaultMail.html" source="/Files/Templates/Forms/Mail" target="/Files/Templates/Forms/Mail" overwrite="false" />
        <file name="DefaultMailReceipt.cshtml" source="/Files/Templates/Forms/Mail" target="/Files/Templates/Forms/Mail" overwrite="false" />
        <file name="DefaultMailReceipt.html" source="/Files/Templates/Forms/Mail" target="/Files/Templates/Forms/Mail" overwrite="false" />
    </package>

    <package version="959" releasedate="30-10-2015">
        <file name="Comment.cshtml" source="/Files/Templates/Comments" target="/Files/Templates/Comments" overwrite="false" />
        <file name="Comment.html" source="/Files/Templates/Comments" target="/Files/Templates/Comments" overwrite="false" />
        <file name="Notify.cshtml" source="/Files/Templates/Comments" target="/Files/Templates/Comments" overwrite="false" />
        <file name="Notify.html" source="/Files/Templates/Comments" target="/Files/Templates/Comments" overwrite="false" />
        <file name="ReplyNotify.cshtml" source="/Files/Templates/Comments" target="/Files/Templates/Comments" overwrite="false" />
        <file name="ReplyNotify.html" source="/Files/Templates/Comments" target="/Files/Templates/Comments" overwrite="false" />
    </package>

    <package version="958" date="26-10-2015">
        <file name="ExportUsers.xml" source="/Files/System/Integration/Jobs/ModuleSpecificJobs/UserManagementModuleJobs/ExportJobs" target="/Files/System/Integration/Jobs/ModuleSpecificJobs/UserManagementModuleJobs/ExportJobs" overwrite="true"/>
        <file name="ExportUsersWithSelectedColumns.xml" source="/Files/System/Integration/Jobs/ModuleSpecificJobs/UserManagementModuleJobs/ExportJobs" target="/Files/System/Integration/Jobs/ModuleSpecificJobs/UserManagementModuleJobs/ExportJobs" overwrite="true"/>
        <file name="ImportUsers.xml" source="/Files/System/Integration/Jobs/ModuleSpecificJobs/UserManagementModuleJobs/ImportJobs" target="/Files/System/Integration/Jobs/ModuleSpecificJobs/UserManagementModuleJobs/ImportJobs" overwrite="true" />
        <file name="ImportUsersFromExcel.xml" source="/Files/System/Integration/Jobs/ModuleSpecificJobs/UserManagementModuleJobs/ImportJobs" target="/Files/System/Integration/Jobs/ModuleSpecificJobs/UserManagementModuleJobs/ImportJobs" overwrite="true" />
    </package>

    <package version="957" releasedate="13-10-2015">
        <setting key="/Globalsettings/Ecom/Navigation/CalcProductCountForGroup" value="true" overwrite="false" />
    </package>

    <package version="956" releasedate="22-09-2015">
        <database file="Access.mdb">
            <AccessUser>
                <sql conditional="SELECT COUNT(*) FROM [AccessType] WHERE [AccessTypeID] = 10">
                    INSERT INTO [AccessType] ([AccessTypeID], [AccessTypeDesc]) VALUES (10, 'Groups')
                </sql>
            </AccessUser>
        </database>
    </package>

    <package version="955" releasedate="15-09-2015">
        <database file="Dynamic.mdb">
            <Page>
	            <sql conditional="">ALTER TABLE [Page] ALTER COLUMN [PageContentType] NVARCHAR(50) NULL</sql>
	            <sql conditional="">UPDATE [Page] SET [PageContentType] = NULL WHERE [PageContentType] = '0'</sql>
            </Page>
        </database>
    </package>
        
    <package version="954" releasedate="02-09-2015">
        <setting key="/Globalsettings/Modules/UserManagement/EncryptNewPasswords" value="true" overwrite="true" />
    </package>
    
    <package version="953" releasedate="04-08-2015">
        <database file="Access.mdb">
            <AccessUser>                
	            <sql conditional="">
                    ALTER TABLE [AccessUser] ADD
                    [AccessUserItemType] NVARCHAR(255) NULL,
                    [AccessUserItemId] NVARCHAR(255) NULL,
                    [AccessUserDefaultUserItemType] NVARCHAR(255) NULL
                </sql>
	        </AccessUser>
        </database>
    </package>

    <package version="952" releasedate="28-07-2015">
        <database file="Access.mdb">
            <FolderPermission>
                <sql conditional="">
                    ALTER TABLE [AccessElementPermission] ADD
                        [AccessElementPermissionWriteTypePermission] nvarchar(50) NULL
                </sql>
            </FolderPermission>
        </database>
    </package>

    <package version="951" releasedate="02-07-2015">
        <database file="Statisticsv2.mdb">
            <NonBrowserSession>
                <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_NonBrowserSession_SessionId_EmailClient] ON [NonBrowserSession]
                    (
	                    [SessionSessionId] ASC,
	                    [SessionUserAgentEmailClient] ASC
                    )
                </sql>
                <sql conditional="">
                    DROP INDEX [DW_IX_NonBrowserSession_SessionId] ON [NonBrowserSession]
                </sql>
            </NonBrowserSession>
        </database>
    </package>

     <package version="950" releasedate="15-06-2015">
        <database file="Dynamic.mdb">
            <Clustering>
                <sql conditional="">
                    ALTER TABLE ClusteringInstance ADD InstanceHostName  nvarchar(255) NULL 
                </sql>
            </Clustering>
        </database>
    </package>
	<package version="949" date="05-05-2015">
		<database file="Dynamic.mdb">
		    <page>
			    <sql conditional="">
                    ALTER TABLE [Area] ADD
	                    [AreaIsCdnActive] bit NULL,
	                    [AreaCdnHost] nvarchar(255) NULL,
	                    [AreaCdnImageHost] nvarchar(255) NULL 
			    </sql>
		    </page>
		</database>
	</package>

     <package version="948" releasedate="29-04-2014">
        <database file="Dynamic.mdb">
            <QueryPublisher>
                <sql conditional="SELECT COUNT(*) FROM [Module] WHERE [ModuleSystemName] = 'QueryPublisher'">
                    INSERT INTO [Module]
                    ([ModuleSystemName], [ModuleName], [ModuleAccess], [ModuleParagraph], [ModuleIsBeta], [ModuleParagraphEditPath])
                    VALUES
                    ('QueryPublisher', 'Query publisher', blnTrue, blnTrue, blnTrue, '/Admin/Module/QueryPublisher')
                </sql>
            </QueryPublisher>
        </database>
         <file name="List.cshtml" source="/Files/Templates/QueryPublisher" target="/Files/Templates/QueryPublisher" overwrite="false" />   
    </package>

    <package version="947" releasedate="22-04-2015">
        <database file="Dynamic.mdb">
            <SmsMessage>                
				<sql conditional="">
                    UPDATE [Module] SET [ModuleIsBeta] = blnFalse WHERE [ModuleSystemName] = 'Sms'
                </sql>
            </SmsMessage>
        </database>
    </package>

    <package  version="946" releasedate="30-03-2015">
        <file name="ItemCreator.css" source="/Files/Templates/ItemCreator" target="/Files/Templates/ItemCreator" />
        <file name="Edit.html" source="/Files/Templates/ItemPublisher/Edit" target="/Files/Templates/ItemPublisher/Edit" />
    </package>

    <package version="945" releasedate="26-03-2015">
    </package>

    <package version="944" releasedate="26-03-2015">
        <database file="Dynamic.mdb">
            <Module>
                <sql conditional="">
                    IF EXISTS (SELECT * FROM [Module] WHERE [ModuleSystemName] = 'Form' AND [ModuleAccess] = blnTrue)
                        UPDATE [Module] SET [ModuleAccess] = blnTrue WHERE [ModuleSystemName] = 'BasicForms'                   
                </sql>
            </Module>
        </database>
    </package>

    <package version="943" releasedate="17-03-2015">
        <database file="Dynamic.mdb">
		<sql conditional="">
			CREATE TABLE [FormRule]
            (
	            [FormRuleId] int IDENTITY(1,1) NOT NULL,
		        [FormRuleType] int NULL DEFAULT ((0)),
		        [FormRuleFormID] int NULL,
	            [FormRuleName] nvarchar(255) NULL,
	            [FormRuleActive] bit NULL DEFAULT ((1)),
	            [FormRuleMessage] nvarchar(MAX) NULL,
		        CONSTRAINT [DW_PK_FormRule] PRIMARY KEY CLUSTERED ([FormRuleId] ASC)
        	)
		</sql>
		<sql conditional="">
			CREATE TABLE [FormRuleCondition]
            (
	            [FormRuleConditionId] int IDENTITY(1,1) NOT NULL,
                [FormRuleConditionSort] int NULL DEFAULT ((1)),
                [FormRuleConditionOperatorPrevious] int NULL DEFAULT ((0)),
	            [FormRuleConditionRuleId] int NULL,
	            [FormRuleConditionFieldId] int NULL,
	            [FormRuleConditionType] int NULL,
	            [FormRuleConditionParam1] nvarchar(MAX) NULL,
                [FormRuleConditionParam2] nvarchar(MAX) NULL,
	            CONSTRAINT [DW_PK_FormRuleCondition] PRIMARY KEY CLUSTERED ([FormRuleConditionId] ASC)
            )
		</sql>				
        </database>
    </package>

	 <package version="942" releasedate="13-03-2015">
        <database file="Dynamic.mdb">
            <form>
                <sql conditional="">
					ALTER TABLE Form ADD [FormFieldSize] int NULL
                </sql>
            </form>
        </database>
    </package>
    
	 <package version="941" releasedate="13-03-2015">
        <database file="Dynamic.mdb">
            <form>
                <sql conditional="">
					ALTER TABLE FormSubmit ADD [FormSubmitPageId] int NULL
                </sql>
            </form>
        </database>
    </package>

    <package version="940" releasedate="10-03-2015">
        <database file="Dynamic.mdb">
            <Clustering>
                <sql conditional="">
                    ALTER TABLE ClusteringInstance ADD InstanceEnabled BIT NOT NULL DEFAULT 0
                </sql>
            </Clustering>
        </database>
    </package>

    <package version="939" date="06-03-2014">
        <database file="Dynamic.mdb">
	        <Page>                
                <sql conditional="">
                    CREATE NONCLUSTERED INDEX [IX_Page_Item] ON [Page] ( [PageItemId] ASC, [PageItemType] ASC )
                </sql>
            </Page>
            <Paragraph>
                <sql conditional="">
                    CREATE NONCLUSTERED INDEX [IX_Paragraph_Item] ON [Paragraph] ( [ParagraphItemId] ASC, [ParagraphItemType] ASC )
                </sql>
	        </Paragraph>
        </database>        
    </package>

    <package version="938" releasedate="11-02-2015">
        <file name="user_details.html" source="/Files/Templates/UserManagement/UserProvider" target="/Files/Templates/UserManagement/UserProvider" overwrite="false" />        
    </package>

	<package version="937" releasedate="09-02-2015">
        <database file="Dynamic.mdb">
            <Module>
                <sql conditional="SELECT COUNT(*) FROM [Module] WHERE [ModuleSystemName] = 'BasicForms'">
                    INSERT INTO [Module] ([ModuleSystemName], [ModuleName], [ModuleIsBeta], [ModuleAccess], [ModuleParagraph], [ModuleScript])
                    VALUES ('BasicForms', 'Forms for editors', blnFalse, blnFalse, blnTrue, 'BasicForms/ListForms.aspx')
                </sql>
            </Module>
        </database>
    </package>
	 <package version="936" releasedate="09-02-2015">
        <database file="Dynamic.mdb">
            <form>
                <sql conditional="">
					ALTER TABLE Form
ADD
[FormMaxSubmits] int NULL,
[FormDefaultTemplate] NVARCHAR(255) NULL,
[FormCssClass] NVARCHAR(255) NULL,
[FormCreatedDate] datetime NULL,
[FormUpdatedDate] datetime NULL,
[FormCreatedBy] int NULL,
[FormUpdatedBy] int NULL
					</sql>
				<sql conditional="">

ALTER TABLE FormField
ADD
[FormFieldCreatedDate] datetime NULL,
[FormFieldUpdatedDate] datetime NULL,
[FormFieldCreatedBy] int NULL,
[FormFieldUpdatedBy] int NULL,
[FormFieldGroupID] int NULL,
[FormFieldCssClass] NVARCHAR(255) NULL,
[FormFieldPlaceholder] NVARCHAR(255) NULL,
[FormFieldDescription] NVARCHAR(MAX) NULL,
[FormFieldPrepend] NVARCHAR(255) NULL,
[FormFieldAppend] NVARCHAR(255) NULL
					</sql>
				<sql conditional="">
						CREATE TABLE [FormSubmit]
(
	[FormSubmitID] int IDENTITY(1,1) NOT NULL,
	[FormSubmitFormID] int NULL DEFAULT ((0)),
	[FormSubmitDate] datetime NULL DEFAULT (getdate()),
	[FormSubmitIp] nvarchar(30) NULL,
	[FormSubmitSessionId] nvarchar(30) NULL,
					CONSTRAINT [DW_PK_FormSubmit] PRIMARY KEY CLUSTERED ([FormSubmitID] ASC)
)
					</sql>
				<sql conditional="">
					CREATE TABLE [FormSubmitData](
	[FormSubmitDataID] int IDENTITY(1,1) NOT NULL,
	[FormSubmitDataSubmitID] int NULL DEFAULT ((0)),
	[FormSubmitDataFieldID] int NULL DEFAULT ((0)),
	[FormSubmitDataFieldname] nvarchar(255) NULL,
	[FormSubmitDataValue] nvarchar(max) NULL
					CONSTRAINT [DW_PK_FormSubmitData] PRIMARY KEY CLUSTERED ([FormSubmitDataID] ASC))

					</sql>
            </form>
        </database>
    </package>
	

    <package version="935" releasedate="30-01-2015">
      <invoke type="Dynamicweb.Content.Management.UpdateScripts, Dynamicweb" method="FixSmartSearchCategoryRules" />
    </package>
     
    <package version="934" releasedate="19-01-2015">
        <database file="Dynamic.mdb">
            <Clustering>
                <sql conditional="">
                    Alter table ClusteringInstance alter column	InstanceIP  nvarchar(15) NULL
                </sql>
            </Clustering>
        </database>
    </package>

    <package version="933" releasedate="19-01-2015">
        <database file="Dynamic.mdb">
            <Clustering>
                <sql conditional="">
                    CREATE TABLE [ClusteringInstance]
                    (
                        [InstanceId] int IDENTITY(1,1) NOT NULL,
                        [InstanceName] nvarchar(255) NULL,
                                                [InstanceMachineName] nvarchar(255) NULL,
                                                [InstanceIP] nvarchar(15) NULL,
                                                [InstanceStartup] datetime NULL,
                                                [InstanceUpdateDate] datetime NULL,
                        CONSTRAINT ClusteringInstance_PrimaryKey PRIMARY KEY([InstanceId])
                    )
                </sql>
            </Clustering>
        </database>
    </package>

    <package version="932" releasedate="19-01-2015">
        <file name="ListForumPublicUnsubscribe.html" source="/Files/Templates/BasicForum/ListForum" target="/Files/Templates/BasicForum/ListForum" overwrite="false" />
        <file name="ListThreadActivationPublicUnsubscribe.html" source="/Files/Templates/BasicForum/ListThread" target="/Files/Templates/BasicForum/ListThread" overwrite="false" />
        <file name="ListThreadPublicUnsubscribe.html" source="/Files/Templates/BasicForum/ListThread" target="/Files/Templates/BasicForum/ListThread" overwrite="false" />
        <file name="ShowThreadPublicUnsubscribe.html" source="/Files/Templates/BasicForum/ShowThread" target="/Files/Templates/BasicForum/ShowThread" overwrite="false" />
        <file name="UpdatePublicUnsubscribe.html" source="/Files/Templates/BasicForum/Subscription" target="/Files/Templates/BasicForum/Subscription" overwrite="false" />
    </package>

      <package version="931" releasedate="13-01-2015">
        <database file="Access.mdb">
            <Modules>                
                <sql conditional="">
                    delete from [module] where ModuleSystemName='QuerySandbox'
                </sql>
            </Modules>
        </database>
    </package>  

    <package version="930" releasedate="12-01-2015">
        <database file="Dynamic.mdb">
            <EmailMarketing>
                <sql conditional="">
                    ALTER TABLE EmailMarketingEmail ADD EmailIncludePlainTextContent BIT NULL
                </sql>
                <sql conditional="">
                    ALTER TABLE EmailMarketingEmail ADD EmailPlainTextContent NVARCHAR(MAX) NULL
                </sql>
                <sql conditional="">
                    ALTER TABLE EmailMessage ADD MessageIncludePlainTextBody BIT NULL
                </sql>
                <sql conditional="">
                    ALTER TABLE EmailMessage ADD MessagePlainTextBody NVARCHAR(MAX) NULL
                </sql>
            </EmailMarketing>
        </database>
    </package>

    <package version="929" releasedate="02-01-2015">
        <database file="Access.mdb">
            <AccessUser>                
                <sql conditional="">
                    ALTER TABLE [AccessUser] ADD [AccessUserExported] DATETIME NULL
                </sql>
            </AccessUser>
            <AccessUserAddress>                
                <sql conditional="">
                    ALTER TABLE [AccessUserAddress] ADD [AccessUserAddressExported] DATETIME NULL
                </sql>
            </AccessUserAddress>
        </database>
    </package>  

    <package version="928" releasedate="15-12-2014">
        <database file="Dynamic.mdb">
            <EmailMessaging>
                <sql conditional="">
                    ALTER TABLE EmailMessage ADD MessageQuarantinePeriod INT NULL
                </sql>
            </EmailMessaging>
        </database>
    </package>

    <package version="927" releasedate="12-12-2014">
        <database file="Dynamic.mdb">
            <EmailMarketing>
                <sql conditional="">
                    ALTER TABLE EmailMarketingEmail ADD EmailQuarantinePeriod INT NULL
                </sql>
                <sql conditional="">
                    ALTER TABLE EmailMarketingTopFolder ADD TopFolderQuarantinePeriod INT NULL
                </sql>
            </EmailMarketing>
        </database>
    </package>

    <package version="926" releasedate="12-12-2014">
        <database file="Access.mdb">
            <AccessUser>
                <sql conditional="">
                    ALTER TABLE [AccessUser] DROP [GroupSmartSearch], [LastCalculated]
                </sql> 
                <sql conditional="">
                    ALTER TABLE [AccessUser] ADD [AccessUserGroupSmartSearch] NVARCHAR(50) NULL,
                                                 [AccessUserGroupSmartSearchLastCalculatedTime] DATETIME NULL
                </sql>
            </AccessUser>
        </database>
    </package>  

    <package version="925" releasedate="11-12-2014">
        <database file="Dynamic.mdb">
            <TrashBin>
				<sql conditional="">ALTER TABLE [TrashBin] ADD [TrashBinItemValue] NVARCHAR(MAX) NULL</sql>
			</TrashBin>			                  
        </database>
    </package>

   <package version="924" releasedate="10-12-2014">
        <database file="Access.mdb">
            <AccessUser>
                <sql conditional="">
                    ALTER TABLE [AccessUser] DROP [RecalculateInterval]
                </sql>                  
            </AccessUser>
        </database>
    </package>

    <package version="923" releasedate="28-11-2014">
        <database file="Dynamic.mdb">
            <Page>
				<sql conditional="">ALTER TABLE [Page] ADD [PageNavigationProvider] NVARCHAR(255) NULL</sql>
			</Page>			                  
        </database>
    </package>

    <package version="921" date="6-11-2014">
        <file name="login.html" source="/Files/Templates/UserManagement/Login/" target="/Files/Templates/UserManagement/Login/" overwrite="true"/>
        <file name="password_reset.html" source="/Files/Templates/UserManagement/Login/" target="/Files/Templates/UserManagement/Login/" overwrite="true"/>
        <file name="password_recovery.html" source="/Files/Templates/UserManagement/Login/" target="/Files/Templates/UserManagement/Login/" overwrite="true"/>
    </package>

    <package version="919" date="31-10-2014">
        <database file="Access.mdb">
	        <AccessUser>
                <sql conditional="">
                    ALTER TABLE [AccessUser] ADD [AccessUserPasswordRecoveryToken] NVARCHAR(128) NULL,
                                                 [AccessUserPasswordRecoveryTokenExpirationTime] DateTime NULL
                </sql>
                <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_AccessUser_AccessUserPasswordRecoveryToken] ON [AccessUser] 
                    (
	                    [AccessUserPasswordRecoveryToken] ASC
                    )
                </sql>
	        </AccessUser>
        </database>
        
        <file name="login.html" source="/Files/Templates/UserManagement/Login/" target="/Files/Templates/UserManagement/Login/" overwrite="false"/>
        <file name="password_recovery_email.html" source="/Files/Templates/UserManagement/Login/" target="/Files/Templates/UserManagement/Login/" overwrite="false"/>
    </package>

    <package version="918" releasedate="23-10-2014">
        <database file="Dynamic.mdb">
            <RecommendationModel>
                <sql conditional="">
                    ALTER TABLE [RecommendationModel] ADD [RecommendationModelServiceModelData] NVARCHAR(MAX) NULL,
                                                          [RecommendationModelRecommendationsCacheLifetime] INT NULL,
                                                          [RecommendationModelExportRebuildServiceModel] BIT NULL
                </sql>
            </RecommendationModel>
        </database>
    </package>

    <package version="917" releasedate="21-10-2014">
        <database file="Dynamic.mdb">
            <Discount>
	            <sql conditional="">ALTER TABLE [EcomDiscount] ADD [DiscountProductIdByDiscount] NVARCHAR(30) NULL, 
                                                                   [DiscountProductVariantIdByDiscount] nvarchar(255) NULL
                </sql>
            </Discount>
        </database>
     </package>

    <package version="916" date="15-10-2014">
        <database file="Dynamic.mdb">
	        <Module>
                <sql conditional="">
                    UPDATE [Module] SET ModuleIsBeta = 0 WHERE ModuleSystemName = 'eCom_DataIntegrationERPBatch'
                </sql>
                <sql conditional="">
                    UPDATE [Module] SET ModuleIsBeta = 0 WHERE ModuleSystemName = 'eCom_DataIntegrationERPLiveIntegration'
                </sql>
                <sql conditional="">
                    UPDATE [Module] SET ModuleIsBeta = 0 WHERE ModuleSystemName = 'eCom_IntegrationCustomerCenter'
                </sql>
	        </Module>
        </database>
    </package>

    <package version="915" releasedate="13-10-2014">
        <database file="Dynamic.mdb">
            <Page>
	            <sql conditional="">
	                ALTER TABLE [ItemTypeDefinitions] ADD [ItemTypeDefinitionsModified] datetime NOT NULL
	            </sql>
            </Page>
        </database>
    </package>

    <package version="914" releasedate="08-10-2014">
        <database file="Dynamic.mdb">
            <Module>
                <sql conditional="">ALTER TABLE [NonBrowserSession] ADD [SessionUserAgentEmailClient] NVARCHAR(50) NULL</sql>
            </Module>
        </database>
    </package>

    <package version="913" releasedate="07-10-2014">
        <database file="Dynamic.mdb">
            <Module>
                <sql conditional="SELECT COUNT(*) FROM [Module] WHERE [ModuleSystemName] = 'LoadBalancing'">
                    INSERT INTO [Module] ([ModuleSystemName], [ModuleName], [ModuleIsBeta], [ModuleAccess], [ModuleParagraph])
                    VALUES ('LoadBalancing', 'Load balancing', blnFalse, blnFalse, blnFalse)
                </sql>
            </Module>
        </database>
    </package>

    <package version="912" releasedate="03-10-2014">
        <database file="Statistics.mdb">
            <StatExtranet>
                <sql conditional="">
                    CREATE TABLE [StatExtranet] (
	                    [StatExtranetAccessUserID] INT NULL,
	                    [StatExtranetTimeStamp] DATETIME NULL,
	                    [StatExtranetPageID] INT NULL
                    )
                </sql>
            </StatExtranet>
        </database>
    </package>

    <package version="911" releasedate="30-09-2014">
        <file name="Search words - Top 5.xml" target="Files/System/OMC/Reports/Marketing reports/Search Words" source="Files/System/OMC/Reports/Search Words" overwrite="true"/>
        <file name="Search words.xml" target="Files/System/OMC/Reports/Marketing reports/Search Words" source="Files/System/OMC/Reports/Search Words" overwrite="true"/>
        <file name="Search words - No results.xml" target="Files/System/OMC/Reports/Marketing reports/Search Words" source="Files/System/OMC/Reports/Search Words" overwrite="true"/>
    </package>

    <package version="910" date="30-09-2014">
        <database file="Dynamic.mdb">
            <Page>
                 <sql conditional="">UPDATE [Module] SET [ModuleName] = 'Personalization' WHERE [ModuleSystemName] = 'Profiling' AND [ModuleName] ='Profiling' </sql>
            </Page>
        </database>
    </package>

    <package version="909" date="17-09-2014">
        <database file="Dynamic.mdb">
            <Page>
                 <sql conditional="">UPDATE [Page] SET [PageSort] = 999 WHERE [PageSort] = 100 AND [PageMenuText] = 'Page templates'</sql>
            </Page>
        </database>
    </package>

    <package version="908" date="05-09-2014">
        <database file="Dynamic.mdb">
	        <Module>
	        <sql conditional="">UPDATE [Module] SET ModuleIsBeta = 0 WHERE ModuleSystemName = 'ItemCreator'</sql>
	        </Module>
        </database>
    </package>

    <package version="906" releasedate="15-08-2014">
        <file name="Recommendation.cshtml" source="/Files/Templates/Recommendation/" target="/Files/Templates/Recommendation/" overwrite="false"/>
        <file name="Recommendation.angularjs.cshtml" source="/Files/Templates/Recommendation/" target="/Files/Templates/Recommendation/" overwrite="false"/>
        <file name="recommendation.js" source="/Files/Templates/Recommendation/javascripts/" target="/Files/Templates/Recommendation/javascripts/" overwrite="false"/>
    </package>

    <package version="905" releasedate="11-08-2014">
        <database file="Dynamic.mdb">
            <EmailMarketingSplitTest>
                <sql conditional="">
                     ALTER TABLE [EmailMarketingSplitTest] ADD [SplitTestWinnerEndDate] DATETIME NULL                    
                </sql>
                <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_SplitTest_SplitTestWinnerEndDate] ON [EmailMarketingSplitTest] 
                    (
	                    [SplitTestWinnerEndDate] ASC
                    )
                </sql>
            </EmailMarketingSplitTest>            
        </database>
    </package>

    <package version="904" releasedate="29-07-2014">
        <database file="Dynamic.mdb">
            <RecommendationModel>
                <sql conditional="">
                    CREATE TABLE [RecommendationModel] (
                        [RecommendationModelId]                     IDENTITY       NOT NULL,
                        [RecommendationModelServiceUrl]             NVARCHAR (255) NULL,
                        [RecommendationModelServiceClientId]        NVARCHAR (255) NULL,
                        [RecommendationModelServiceModelId]         NVARCHAR (255) NULL,
                        [RecommendationModelServiceModelParameters] NVARCHAR (MAX) NULL,
                        [RecommendationModelName]                   NVARCHAR (255) NULL,
                        [RecommendationModelExportDataType]         NVARCHAR (255) NULL,
                        [RecommendationModelExportStartTime]        DATETIME       NULL,
                        [RecommendationModelExportInterval]         INT            NULL,
                        [RecommendationModelExportStatus]           NVARCHAR (255) NULL,
                        [RecommendationModelExportStartedAt]        DATETIME       NULL,
                        [RecommendationModelExportFinishedAt]       DATETIME       NULL,
                        CONSTRAINT [DW_PK_RecommendationModel] PRIMARY KEY CLUSTERED ([RecommendationModelId] ASC)
                    )
                </sql>
            </RecommendationModel>
            <Module>
                <sql conditional="SELECT COUNT(*) FROM [Module] WHERE [ModuleSystemName] = 'Recommendation'">
                    INSERT INTO [Module] ([ModuleSystemName], [ModuleName], [ModuleIsBeta], [ModuleAccess], [ModuleParagraph])
                    VALUES ('Recommendation', 'Recommendation', 1, 0, 1)
                </sql>
            </Module>
        </database>
    </package>

    <package version="903" releasedate="25-07-2014">
        <database file="Dynamic.mdb">
            <EmailMarketing>
                <sql conditional="">
                    ALTER TABLE [EmailMarketingEmail] ADD [EmailLastExportDate] DATETIME NULL
                </sql>                
            </EmailMarketing>
        </database>
    </package>
    <package version="902" releasedate="24-07-2014">
        <database file="Dynamic.mdb">
            <AccessUser>
                <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_AccessUser_AccessUserCreatedOn] ON [AccessUser] 
                    (
	                    [AccessUserCreatedOn] ASC
                    )
                </sql>
                <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_AccessUser_AccessUserUpdatedOn] ON [AccessUser] 
                    (
	                    [AccessUserUpdatedOn] ASC
                    )
                </sql>
                <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_AccessUser_AccessUserCreatedBy] ON [AccessUser] 
                    (
	                    [AccessUserCreatedBy] ASC
                    )
                </sql>
                <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_AccessUser_AccessUserUpdatedBy] ON [AccessUser] 
                    (
	                    [AccessUserUpdatedBy] ASC
                    )
                </sql>
                <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_AccessUser_AccessUserEmailPermissionUpdatedOn] ON [AccessUser] 
                    (
	                    [AccessUserEmailPermissionUpdatedOn] ASC
                    )
                </sql>
                <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_AccessUser_AccessUserLastLoginOn] ON [AccessUser] 
                    (
	                    [AccessUserLastLoginOn] ASC
                    )
                </sql>
            </AccessUser>
        </database>
    </package>
    <package version="901" releasedate="24-07-2014">
        <database file="Dynamic.mdb">
            <AccessUser>
                <sql conditional="">
                    ALTER TABLE [AccessUser] ADD [AccessUserLastOrderDate]  datetime NULL
                </sql>
                <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_AccessUser_AccessUserLastOrderDate] ON [AccessUser] 
                    (
	                    [AccessUserLastOrderDate] ASC
                    )
                </sql>
            </AccessUser>
        </database>
    </package>   
	<package version="899" releasedate="21-07-2014">
        <database file="Dynamic.mdb">
            <SmsMessage>
                <sql conditional="">
                    CREATE TABLE [SmsMessage]
                    (
                        [SmsMessageID] IDENTITY NOT NULL,
                        [SmsMessageName] nvarchar(max) NULL,
						[SmsMessageText] nvarchar(max) NULL,
						[SmsMessageSendToGroup] nvarchar(max) NULL,
						[SmsMessageCreated] datetime NULL,
						[SmsMessageUpdated] datetime NULL,
						[SmsMessageCreatedBy] int NULL,
						[SmsMessageUpdatedBy] int NULL,
						[SmsMessageRecipientCount] int NULL,
						[SmsMessageFirstMessageSent] datetime NULL,
						[SmsMessageLastMessageSent] datetime NULL,
                        [SmsMessageDeliveredCount] int NULL,
                        CONSTRAINT SmsMessage_PrimaryKey PRIMARY KEY([SmsMessageID])
                    
                    )
                </sql>
            </SmsMessage>
        </database>
    </package>
<package version="898" releasedate="21-07-2014">
		<database file="Dynamic.mdb">
            <Module>
				<sql conditional="SELECT COUNT(*) FROM [Module] WHERE [ModuleSystemName] = 'Sms'">
				INSERT INTO [Module] ([ModuleSystemName], [ModuleName], [ModuleAccess], [ModuleParagraph], [ModuleIsBeta], [ModuleScript])
									   VALUES ('Sms', 'Sms', blnFalse, blnFalse, blnTrue, 'Sms/SmsList.aspx')
				</sql>
			</Module>
		</database>
    </package>

	<package version="897" releasedate="10-07-2014">
        <database file="Dynamic.mdb">
            <SmsMessage>
                <sql conditional="">
                    ALTER TABLE [SmsMessage] ADD [SmsMessageDeliveredCount]  int NULL
                </sql>
				<sql conditional="">
                    UPDATE [Module] SET [ModuleScript] = '' WHERE [ModuleSystemName] = 'Sms'
                </sql>
            </SmsMessage>
        </database>
    </package>
    <package version="896" releasedate="15-07-2014">
        <database file="Dynamic.mdb">
            <OMCParagraphSegment>
                <sql conditional="">
                    CREATE TABLE [OMCParagraphSegment]
                    (
                    ParagraphSegmentID IDENTITY NOT NULL,
                    ParagraphSegmentParagraphID INT NOT NULL,
                    ParagraphSegmentShowAsDefault BIT NOT NULL DEFAULT blnTrue,
                    CONSTRAINT DW_PK_OMCParagraphSegment PRIMARY KEY CLUSTERED (ParagraphSegmentID ASC)
                    )
                </sql>
		        <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_OMCParagraphSegmentParagraph] 
                    ON [OMCParagraphSegment] (
                        [ParagraphSegmentParagraphID] ASC
                    )
                    INCLUDE 
                        ([ParagraphSegmentID])                    
                </sql>
                <sql conditional="">
                    CREATE TABLE [OMCParagraphSegmentSelection]
                    (
                    ParagraphSegmentSelectionID IDENTITY NOT NULL,
                    ParagraphSegmentSelectionSegmentID INT NOT NULL,
                    ParagraphSegmentSelectionSmartSearchID NVARCHAR(50) NOT NULL,
                    ParagraphSegmentSelectionSelected BIT NOT NULL DEFAULT blnFalse,
                    CONSTRAINT DW_PK_OMCParagraphSegmentSelection PRIMARY KEY CLUSTERED (ParagraphSegmentSelectionID ASC)
                    )
                </sql>
		        <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_OMCParagraphSegmentSelectionSegment] 
                    ON [OMCParagraphSegmentSelection] (
                        [ParagraphSegmentSelectionSegmentID] ASC
                    )
                    INCLUDE 
                        ([ParagraphSegmentSelectionID])                    
                </sql>

                <sql conditional="">
                    CREATE TABLE [OMCParagraphSegment]
                    (
                    ParagraphSegmentID INT NOT NULL,
                    ParagraphSegmentParagraphID INT NOT NULL,
                    ParagraphSegmentShowAsDefault BIT NOT NULL ,
                    CONSTRAINT DW_PK_OMCParagraphSegment PRIMARY KEY (ParagraphSegmentID )
                    )
                </sql>
		        <sql conditional="">
                    CREATE INDEX [DW_IX_OMCParagraphSegmentParagraph] 
                    ON [OMCParagraphSegment] (
                        [ParagraphSegmentParagraphID] ASC
                    )                 
                </sql>
                <sql conditional="">
                    CREATE TABLE [OMCParagraphSegmentSelection]
                    (
                    ParagraphSegmentSelectionID INT NOT NULL,
                    ParagraphSegmentSelectionSegmentID INT NOT NULL,
                    ParagraphSegmentSelectionSmartSearchID VARCHAR(50) NOT NULL,
                    ParagraphSegmentSelectionSelected BIT NOT NULL ,
                    CONSTRAINT DW_PK_OMCParagraphSegmentSelection PRIMARY KEY  (ParagraphSegmentSelectionID )
                    )
                </sql>
		        <sql conditional="">
                    CREATE INDEX [DW_IX_OMCParagraphSegmentSelectionSegment] 
                    ON [OMCParagraphSegmentSelection] (
                        [ParagraphSegmentSelectionSegmentID] ASC
                    )
                </sql>
            </OMCParagraphSegment>
        </database>
    </package>

    <package version="895" releasedate="04-07-2014">
        <database file="Dynamic.mdb">
            <NamedItemList>
                <sql conditional="">
                    CREATE TABLE [ItemNamedItemList]
                    (
                    ItemNamedItemListId IDENTITY NOT NULL,
                    ItemNamedItemListName NVARCHAR(255) NOT NULL,
                    ItemNamedItemListSourceType NVARCHAR(50) NOT NULL,
                    ItemNamedItemListSourceId BIGINT NOT NULL,
                    ItemNamedItemListItemListId INT NOT NULL,
                    CONSTRAINT DW_PK_ItemNamedItemList PRIMARY KEY CLUSTERED (ItemNamedItemListId ASC)
                    )
                </sql>
		        <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_ItemNamedItemListName] 
                    ON [ItemNamedItemList] (
                        [ItemNamedItemListName] ASC
                    )
                    INCLUDE 
                        ([ItemNamedItemListId])                    
                </sql>
		        <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_ItemNamedItemListSource] 
                    ON [ItemNamedItemList] (
                        [ItemNamedItemListSourceType] ASC,
                        [ItemNamedItemListSourceId] ASC
                    )
                    INCLUDE 
                        ([ItemNamedItemListId])                    
                </sql>
            </NamedItemList>
        </database>
    </package>

    <package version="894" releasedate="02-07-2014">
        <setting key="/Globalsettings/Settings/Dictionary/HideOldTranslationButton" value="false" overwrite="false" />
    </package>

    <package version="893" releasedate="01-07-2014">
        <database file="Dynamic.mdb">
            <VAT>
                <sql conditional="">
                    ALTER TABLE [Area] ADD [AreaEcomPricesWithVat] NVARCHAR(10)
                </sql>
            </VAT>
        </database>
    </package>

    <package version="892" releasedate="12-11-2013">
      <invoke type="Dynamicweb.Content.Management.UpdateScripts, Dynamicweb" method="MakeInheritableItemTypes" />
    </package>

    <package version="891" releasedate="27-06-2014">
        <setting key="/Globalsettings/Modules/UserManagement/ExtranetPasswordSecurity/LoginAttempts" value="3" overwrite="false" />
    </package>

    <package version="890" releasedate="24-06-2014">
        <setting key="/Globalsettings/Modules/UserManagement/ExtranetPasswordSecurity/PeriodLoginFailure" value="10" overwrite="false" />
        <setting key="/Globalsettings/Modules/UserManagement/ExtranetPasswordSecurity/BlockingPeriod" value="10" overwrite="false" />
    </package>

    <package version="889" releasedate="23-06-2014">
        <file name="ListThreadActivation.html" source="/Files/Templates/BasicForum/ListThread" target="/Files/Templates/BasicForum/ListThread" overwrite="false" />
    </package>

    <package version="888" date="16-06-2014">
        <database file="Dynamic.mdb">
            <EmailMarketingTopFolder>
                <sql conditional="">ALTER TABLE [EmailMarketingTopFolder] ADD [TopFolderRecipientProviderConfiguration] NVARCHAR(MAX) NULL</sql>
            </EmailMarketingTopFolder>
        </database>
    </package>

    <package version="887"  releasedate="10-06-2014">
        <database file="Dynamic.mdb">
            <Forum>
                <sql conditional="">
                    ALTER TABLE [ForumMessage] ADD [ForumMessageIsActive] BIT NOT NULL DEFAULT blnTrue
                </sql>
            </Forum>
        </database>
    </package>

    <package version="886" releasedate="05-06-2014">
        <database file="Dynamic.mdb">
            <ItemList>
                <sql conditional="">
                    CREATE TABLE [ItemList]
                    (
                        ItemListId IDENTITY NOT NULL,
                        ItemListItemType NVARCHAR(255) NOT NULL,
                        CONSTRAINT ItemList_PrimaryKey PRIMARY KEY([ItemListId])
                    )
                </sql>
                <sql conditional="">
                    CREATE TABLE [ItemListRelation]
                    (
                        ItemListRelationId IDENTITY NOT NULL,
                        ItemListRelationItemListId INT NOT NULL,
                        ItemListRelationItemId NVARCHAR(255) NOT NULL,
                        ItemListRelationSort INT NOT NULL,
                        CONSTRAINT ItemListRelation_PrimaryKey PRIMARY KEY([ItemListRelationId]),
                        CONSTRAINT ItemListRelation_FKItemListId FOREIGN KEY(ItemListRelationItemListId) REFERENCES ItemList(ItemListId)
                    )
                </sql>
            </ItemList>
        </database>
    </package>

    <package version="885" releasedate="20-05-2014">
        <database file="Dynamic.mdb">
            <QuerySandbox>
                <sql conditional="SELECT COUNT(*) FROM [Module] WHERE [ModuleSystemName] = 'QuerySandbox'">
                    INSERT INTO [Module]
                    ([ModuleSystemName], [ModuleName], [ModuleAccess], [ModuleParagraph], [ModuleIsBeta], [ModuleParagraphEditPath])
                    VALUES
                    ('QuerySandbox', 'Query sandbox', blnFalse, blnTrue, blnTrue, '/Admin/Module/QuerySandbox')
                </sql>
            </QuerySandbox>
        </database>
    </package>

    <package version="884"  releasedate="20-05-2014">
        <database file="Dynamic.mdb">
            <SocialMessage>
                <sql conditional="">
                    ALTER TABLE [SocialMessage] ADD [MessageFolderId] INT NULL, [MessageTopFolderId] INT NULL
                </sql>
            </SocialMessage>
            <SocialFolder>
                <sql conditional="">
                    CREATE TABLE [SocialFolder]
                    (
                        FolderId IDENTITY NOT NULL,
                        FolderParentId  INT NULL,
                        FolderName NVARCHAR(255) NULL,
                        FolderTopFolderId INT NULL,
                        CONSTRAINT SocialFolder_PrimaryKey PRIMARY KEY([FolderId])
                    )
                </sql>
            </SocialFolder>
            <SocialTopFolder>
                <sql conditional="">
                    CREATE TABLE [SocialTopFolder]
                    (
                        TopFolderId IDENTITY NOT NULL,
                        TopFolderName NVARCHAR(255) NULL,
                        TopFolderChannelIds NVARCHAR(MAX) NULL,
                        CONSTRAINT SocialTopFolder_PrimaryKey PRIMARY KEY([TopFolderId])
                    )
                </sql>
            </SocialTopFolder>
            <SocialFolder>
                <sql conditional="SELECT COUNT(*) FROM [SocialFolder] WHERE [FolderName] = 'Drafts' AND [FolderParentId] = 0 AND [FolderTopFolderId] = 1">
                    INSERT INTO SocialFolder ([FolderParentId], [FolderName], [FolderTopFolderId])
                    VALUES (0, 'Drafts', 1)
                </sql>
                <sql conditional="SELECT COUNT(*) FROM [SocialFolder] WHERE [FolderName] = 'Scheduled' AND [FolderParentId] = 0 AND [FolderTopFolderId] = 1">
                    INSERT INTO SocialFolder ([FolderParentId], [FolderName], [FolderTopFolderId])
                    VALUES (0, 'Scheduled', 1)
                </sql>
                <sql conditional="SELECT COUNT(*) FROM [SocialFolder] WHERE [FolderName] = 'Published' AND [FolderParentId] = 0 AND [FolderTopFolderId] = 1">
                    INSERT INTO SocialFolder ([FolderParentId], [FolderName], [FolderTopFolderId])
                    VALUES (0, 'Published', 1)
                </sql>
            </SocialFolder>
        </database>
    </package>

    <package version="883" releasedate="08-05-2014">
        <database file="Access.mdb">
            <AccessUser>
	            <sql conditional="">
	                ALTER TABLE [AccessUser] ADD 
                        [AccessUserTitle] NVARCHAR(255) NULL, 
                        [AccessUserFirstName] NVARCHAR(255) NULL, 
                        [AccessUserHouseNumber] NVARCHAR(255) NULL
	            </sql>
            </AccessUser>
            <EcomOrders>
	            <sql conditional="">
	                ALTER TABLE [EcomOrders] ADD 
                        [OrderCustomerTitle] NVARCHAR(255) NULL,
                        [OrderCustomerFirstName] NVARCHAR(255) NULL,
                        [OrderCustomerMiddleName] NVARCHAR(255) NULL,
                        [OrderCustomerHouseNumber] NVARCHAR(255) NULL,
                        [OrderDeliveryTitle] NVARCHAR(255) NULL,
                        [OrderDeliveryFirstName] NVARCHAR(255) NULL,
                        [OrderDeliveryMiddleName] NVARCHAR(255) NULL,
                        [OrderDeliveryHouseNumber] NVARCHAR(255) NULL 
	            </sql>
            </EcomOrders>
        </database>
    </package>
    
    <package version="882" releasedate="23-04-2014">
        <database file="Dynamic.mdb">
            <EmailMarketing>
                <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_NonBrowserSession_SessionId] ON [dbo].[NonBrowserSession]
                    (
	                    [SessionSessionId] ASC
                    )
                </sql>
            </EmailMarketing>
        </database>
    </package>

    <package version="881" releasedate="09-11-2013">
		<database file="Dynamic.mdb">
            <Module>
				<sql conditional="SELECT COUNT(*) FROM [EcomFilterDefinitionTranslation]">
				    INSERT INTO [EcomFilterDefinitionTranslation] ([EcomFilterDefinitionTranslationFilterDefinitionId], [EcomFilterDefinitionTranslationFilterDefinitionLanguageId], [EcomFilterDefinitionTranslationFilterDefinitionName])
                        SELECT EcomFilterDefinitionID, LanguageID,  EcomFilterDefinitionName FROM [EcomLanguages] CROSS JOIN [EcomFilterDefinition] ORDER BY EcomFilterDefinitionID
				</sql>
			</Module>
		</database>
    </package>

    <package version="880" releasedate="04-04-2014">
        <database file="Statisticsv2.mdb">
            <Statv2SessionBot>
                <sql conditional="">
                    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE ( name = N'DW_PK_Statv2SessionBot' ))
                        ALTER TABLE [Statv2SessionBot] ADD CONSTRAINT
	                        [DW_PK_Statv2SessionBot] PRIMARY KEY NONCLUSTERED ( Statv2SessionID ASC )
                </sql>
            </Statv2SessionBot>
        </database>
    </package>

    <package version="879" releasedate="04-04-2014">
        <file name="ExportUsersWithSelectedColumns.xml" source="/Files/System/Integration/Jobs/ModuleSpecificJobs/UserManagementModuleJobs/ExportJobs" target="/Files/System/Integration/Jobs/ModuleSpecificJobs/UserManagementModuleJobs/ExportJobs" overwrite="false" />
    </package>

    <package version="878" releasedate="03-04-2014">
        <database file="Access.mdb">
            <AccessUserExternalLogin>                
                <sql conditional="">
                    IF NOT EXISTS(SELECT * FROM sys.columns WHERE ( name = 'ProviderUserName' ) AND ( object_id = ( SELECT object_id FROM sys.tables WHERE ( name = 'AccessUserExternalLogin' ) ) ) )
                        ALTER TABLE [AccessUserExternalLogin] ADD [ProviderUserName] NVARCHAR(255) NULL                                     
                </sql>
                <sql conditional="SELECT NOW()">
                    ALTER TABLE [AccessUserExternalLogin] ADD [ProviderUserName] NVARCHAR(255) NULL
                </sql>
            </AccessUserExternalLogin>
        </database>
    </package>

    <package version="877" releasedate="01-04-2014">
        <database file="Dynamic.mdb">
            <EmailMarketing>
                <sql conditional="">
                    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE ( name = N'DW_IX_EmailRecipient_MessageId' ))
                        CREATE NONCLUSTERED INDEX [DW_IX_EmailRecipient_MessageId] ON [EmailRecipient]
                        (
	                        [RecipientMessageId] ASC
                        )
                        INCLUDE
                        (
	                        [RecipientId],
	                        [RecipientKey],
	                        [RecipientName],
	                        [RecipientEmailAddress],
	                        [RecipientSentTime],
	                        [RecipientErrorMessage],
	                        [RecipientErrorTime],
	                        [RecipientTags],
	                        [RecipientSecret]
                        )
                </sql>
            </EmailMarketing>
        </database>
    </package>

    <package version="876" releasedate="01-04-2014">
        <database file="Dynamic.mdb">
            <EmailMarketing>
                <sql conditional="">
                    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE ( name = N'DW_IX_EmailAction_MessageId_RecipientId_Type' ))
                        CREATE NONCLUSTERED INDEX [DW_IX_EmailAction_MessageId_RecipientId_Type] ON [EmailAction]
                        (
	                        [ActionMessageId] ASC,
	                        [ActionRecipientId] ASC,
	                        [ActionType] ASC
                        )
                </sql>
                <sql conditional="">
                    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE ( name = N'DW_IX_EmailRecipient_MessageId_Id' ))
                        CREATE NONCLUSTERED INDEX [DW_IX_EmailRecipient_MessageId_Id] ON [EmailRecipient]
                        (
	                        [RecipientMessageId] ASC,
	                        [RecipientId] ASC
                        )
                        INCLUDE 
                        (
	                        [RecipientKey],
	                        [RecipientName],
	                        [RecipientEmailAddress]
                        )
                </sql>
                <sql conditional="">
                    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE ( name = N'DW_IX_Statv2Object_Type' ))
                        CREATE NONCLUSTERED INDEX [DW_IX_Statv2Object_Type] ON [Statv2Object]
                        (
	                        [Statv2ObjectType] ASC
                        )
                        INCLUDE
                        (
	                        [Statv2ObjectSessionID],
	                        [Statv2ObjectElement]
                        )
                </sql>
                <sql conditional="">
                    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE ( name = N'DW_IX_EcomOrders_OrderID' ))
                        CREATE NONCLUSTERED INDEX [DW_IX_EcomOrders_OrderID] ON [EcomOrders]
                        (
	                        [OrderID] ASC
                        )
                        INCLUDE
                        (
	                        [OrderPriceBeforeFeesWithVAT]
                        )
                </sql>
            </EmailMarketing>
        </database>
    </package>

    <package version="875" releasedate="25-04-2014">
        <database file="Access.mdb">
            <AccessUser>
                <sql conditional="">
                    ALTER TABLE AccessUser ADD AccessUserAdministratorInGroups NVARCHAR(MAX) NULL
                </sql>
            </AccessUser>
        </database>
    </package>

    <package version="874" releasedate="21-04-2014">
        <database file="Ecom.mdb">
            <EcomFilterDefinition>
                <sql conditional="">
                    CREATE TABLE EcomValidationGroupsTranslation
                    (
                        EcomValidationGroupsTranslationValidationGroupID NVARCHAR(50) NOT NULL,
                        EcomValidationGroupsTranslationValidationGroupLanguageID NVARCHAR(50) NOT NULL,
                        EcomValidationGroupsTranslationValidationGroupName NVARCHAR(255) NULL,
                        CONSTRAINT EcomValidationGroupsTranslation_PK PRIMARY KEY(EcomValidationGroupsTranslationValidationGroupID, EcomValidationGroupsTranslationValidationGroupLanguageID),
                        CONSTRAINT EcomValidationGroupsTranslation_FKValidationGroupID FOREIGN KEY(EcomValidationGroupsTranslationValidationGroupID) REFERENCES EcomValidationGroups(ValidationGroupID),
                        CONSTRAINT EcomValidationGroupsTranslation_FKLanguageID FOREIGN KEY(EcomValidationGroupsTranslationValidationGroupLanguageID) REFERENCES EcomLanguages(LanguageID)
                    )
                </sql>
          		<sql conditional="SELECT COUNT(*) FROM [EcomValidationGroupsTranslation]">
				    INSERT INTO [EcomValidationGroupsTranslation] ([EcomValidationGroupsTranslationValidationGroupID], [EcomValidationGroupsTranslationValidationGroupLanguageID], [EcomValidationGroupsTranslationValidationGroupName])
                        SELECT ValidationGroupID, LanguageID,  ValidationGroupName FROM [EcomLanguages] CROSS JOIN [EcomValidationGroups] ORDER BY ValidationGroupID
				</sql>
            </EcomFilterDefinition>
        </database>
    </package>

    <package  version="873" releasedate="17-04-2014">
        <file name="CreatePost.html" target="Files/Templates/BasicForum/CreatePost" source="Files/Templates/BasicForum/CreatePost" overwrite="false"/>
        <file name="functions.js" target="Files/Templates/BasicForum" source="Files/Templates/BasicForum" overwrite="false"/>
    </package>   

    <package version="872" releasedate="08-04-2014">
        <file name="ExportUsersToExcel.xml" source="/Files/System/Integration/Jobs/ModuleSpecificJobs/UserManagementModuleJobs/ExportJobs" target="/Files/System/Integration/Jobs/ModuleSpecificJobs/UserManagementModuleJobs/ExportJobs" overwrite="false" />
        <file name="ExportUsersWithSelectedColumns.xml" source="/Files/System/Integration/Jobs/ModuleSpecificJobs/UserManagementModuleJobs/ExportJobs" target="/Files/System/Integration/Jobs/ModuleSpecificJobs/UserManagementModuleJobs/ExportJobs" overwrite="false" />
        <file name="ImportUsersFromExcel.xml" source="/Files/System/Integration/Jobs/ModuleSpecificJobs/UserManagementModuleJobs/ImportJobs" target="/Files/System/Integration/Jobs/ModuleSpecificJobs/UserManagementModuleJobs/ImportJobs" overwrite="false" />
    </package>

    <package version="871" releasedate="26-03-2014">
        <database file="Dynamic.mdb">
            <EmailMessaging>
                <sql conditional="">
                    IF NOT EXISTS(SELECT * FROM sys.columns WHERE ( name = 'RecipientSecret' ) AND ( object_id = ( SELECT object_id FROM sys.tables WHERE ( name = 'EmailRecipient' ) ) ) )
                        ALTER TABLE [EmailRecipient] ADD [RecipientSecret] NVARCHAR(50) NULL
                </sql>
                <sql conditional="SELECT NOW()">
                    ALTER TABLE [EmailRecipient] ADD [RecipientSecret] NVARCHAR(50) NULL
                </sql>
            </EmailMessaging>
        </database>
    </package>

	<package version="870" date="19-03-2014">
		<file name="developer.js" source="/Files/System/Editor/ckeditor/config/" target="/Files/System/Editor/ckeditor/config/" overwrite="false" />
	</package>

	<package version="869" date="17-03-2014">
		<database file="Dynamic.mdb">
		<Page>
			<sql conditional="">
                    ALTER TABLE [Area] ADD [AreaSSLMode] INT NULL
			</sql>
		</Page>
		</database>
	</package>

    <package version="868" releasedate="11-03-2014">
        <database file="Statisticsv2.mdb">
            <OMCLeadEmail>
                <sql conditional="">
                    IF NOT EXISTS(SELECT * FROM sys.columns WHERE ( name = 'LeadEmailLeadStates' ) AND ( object_id = ( SELECT object_id FROM sys.tables WHERE ( name = 'OMCLeadEmail' ) ) ) )
                        ALTER TABLE [OMCLeadEmail] ADD [LeadEmailLeadStates] NVARCHAR(MAX) NULL
                </sql>
                <sql conditional="SELECT NOW()">
                    ALTER TABLE [OMCLeadEmail] ADD [LeadEmailLeadStates] NVARCHAR(MAX) NULL
                </sql>
            </OMCLeadEmail>
        </database>
    </package>

    <package version="867" releasedate="03-03-2014">
        <database file="Ecom.mdb">
            <EcomFilterDefinition>
                <sql conditional="">
                    IF NOT EXISTS(SELECT * FROM sys.tables WHERE ( name = 'EcomFilterDefinitionTranslation' ) )
                        CREATE TABLE [EcomFilterDefinitionTranslation]
                        (
	                        [EcomFilterDefinitionTranslationId] INT NOT NULL IDENTITY(1,1),
	                        [EcomFilterDefinitionTranslationFilterDefinitionId] INT NOT NULL, 
                            [EcomFilterDefinitionTranslationFilterDefinitionLanguageId] NVARCHAR(50) NOT NULL, 
                            [EcomFilterDefinitionTranslationFilterDefinitionName] NVARCHAR(255) NULL,     
	                        CONSTRAINT [DW_PK_EcomFilterDefinitionTranslation] PRIMARY KEY NONCLUSTERED ([EcomFilterDefinitionTranslationFilterDefinitionId] ASC, [EcomFilterDefinitionTranslationFilterDefinitionLanguageId] ASC)
                        )
                </sql>
                <sql conditional="SELECT NOW()">
                    CREATE TABLE [EcomFilterDefinitionTranslation]
                        (
	                        [EcomFilterDefinitionTranslationId] INT NOT NULL IDENTITY(1,1),
	                        [EcomFilterDefinitionTranslationFilterDefinitionId] INT NOT NULL, 
                            [EcomFilterDefinitionTranslationFilterDefinitionLanguageId] NVARCHAR(50) NOT NULL, 
                            [EcomFilterDefinitionTranslationFilterDefinitionName] NVARCHAR(255) NULL,     
	                        PRIMARY KEY ([EcomFilterDefinitionTranslationFilterDefinitionId] ASC, [EcomFilterDefinitionTranslationFilterDefinitionLanguageId] ASC)
                        )
                </sql>
                <sql conditional="">
                    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE ( name = N'DW_IX_EcomFilterDefinitionTranslation_Id' )) AND EXISTS(SELECT * FROM sys.indexes WHERE ( name = N'DW_PK_EcomFilterDefinitionTranslation' ))
                        CREATE UNIQUE CLUSTERED INDEX DW_IX_EcomFilterDefinitionTranslation_Id
	                        ON [EcomFilterDefinitionTranslation]
                    (
	                        [EcomFilterDefinitionTranslationId] ASC
                    )
                </sql>
            </EcomFilterDefinition>
        </database>
    </package>

    <package version="866" releasedate="14-02-2014">
        <database file="Access.mdb">
            <AccessUser>
                <sql conditional="">
                    IF NOT EXISTS(SELECT * FROM sys.columns WHERE ( name = 'AccessUserLastLoginOn' ) AND ( object_id = ( SELECT object_id FROM sys.tables WHERE ( name = 'AccessUser' ) ) ) )
                        ALTER TABLE AccessUser ADD AccessUserLastLoginOn DATETIME NULL
                </sql>
                <sql conditional="SELECT NOW()">
                    ALTER TABLE AccessUser ADD AccessUserLastLoginOn DATETIME NULL
                </sql>
            </AccessUser>
        </database>
    </package>

    <package version="865" releasedate="07-02-2014">
        <database file="Statisticsv2.mdb">
            <Page>
                <sql conditional="">
                    IF NOT EXISTS(SELECT * FROM sys.columns WHERE ( name = 'Statv2ObjectPageID' ) AND ( object_id = ( SELECT object_id FROM sys.tables WHERE ( name = 'Statv2Object' ) ) ) )
                        ALTER TABLE [Statv2Object] ADD [Statv2ObjectPageID] INT NULL
                </sql>
                <sql conditional="SELECT NOW()">
                    ALTER TABLE [Statv2Object] ADD [Statv2ObjectPageID] INT NULL
                </sql>
            </Page>
        </database>
    </package>

     <package  version="864" releasedate="31-01-2014">
        <file name="InformationSaveCart.html" target="Files/Templates/eCom7/CartV2/Step" source="Files/Templates/eCom7/CartV2/Step" overwrite="false"/>
    </package>   

     <package version="863" date="27-01-2014">
    </package>

    <package version="862" releasedate="24-01-2014">
        <database file="Dynamic.mdb">
            <Module>
                <sql conditional="">
                    UPDATE [Module] SET [ModuleIsBeta] = 1 WHERE [ModuleSystemName] = 'ItemCreator' AND [ModuleIsBeta] = 0
                </sql>
			</Module>
		</database>
	</package>
</updates>