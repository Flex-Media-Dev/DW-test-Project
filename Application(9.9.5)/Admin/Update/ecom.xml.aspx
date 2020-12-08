<?xml version="1.0" encoding="UTF-8" ?>
<updates>
    <!--
	    Remember to update the corresponding versionnumber in AssemblyInfo.vb (AssemblyInformationalVersionAttribute). 
        Rules for version number can be found there as well.
	-->
  
    <current version="2191" releasedate="21-11-2020" />
    
    <package version="2191" releasedate="21-11-2020">
        <database file="Ecom.mdb">
            <Audit>
                <sql conditional="">
                    ALTER TABLE [dbo].[EcomCustomerFavoriteProducts] DROP CONSTRAINT [DW_FK_EcomCustomerFavoriteProducts_EcomProducts]
                </sql>  
            </Audit>            
        </database>
    </package>

    <package version="2190" date="10-11-2020">
	    <database file="Ecom.mdb">
            <EcomProductField>
                <sql conditional="">                             
                    ALTER TABLE [EcomProductField] ADD [ProductFieldIsStandard] BIT NOT NULL DEFAULT 0;
                </sql>
            </EcomProductField>
        </database>
    </package>

    <package version="2189" date="29-10-2020">
        <database file="Ecom.mdb">
            <EcomNumbers>
                <sql conditional="">
                    IF NOT EXISTS( SELECT NumberID FROM EcomNumbers WHERE ( NumberType = 'ASSIGNMENTRULE' ) )
	                    INSERT INTO EcomNumbers ( NumberID, NumberType, NumberDescription, NumberCounter, NumberPrefix, NumberPostFix, NumberAdd, NumberEditable, NumberTableName, NumberColumnName )
	                    VALUES ( '54', 'ASSIGNMENTRULE', 'Product assignment rule id', 0, 'ASSIGNMENTRULE', '', 1, 0, 'EcomProductAssignmentRule', 'EcomProductAssignmentRuleId' )
                </sql>
                <sql conditional="">
                    IF NOT EXISTS( SELECT NumberID FROM EcomNumbers WHERE ( NumberType = 'ASSIGNMENTRULEITEM' ) )
	                    INSERT INTO EcomNumbers ( NumberID, NumberType, NumberDescription, NumberCounter, NumberPrefix, NumberPostFix, NumberAdd, NumberEditable, NumberTableName, NumberColumnName )
	                    VALUES ( '55', 'ASSIGNMENTRULEITEM', 'Product assignment rule mapping id', 0, 'ASSIGNMENTRULEITEM', '', 1, 0, 'EcomProductAssignmentRuleMapping', 'EcomProductAssignmentRuleMappingId' )
                </sql>
            </EcomNumbers>
        </database>
    </package>

    <package version="2188" date="20-10-2020">
        <database file="Ecom.mdb">
            <EcomFieldType>
                <sql conditional="">
                    UPDATE [EcomFieldType] SET [FieldTypeDBSQL] = N'NVARCHAR(MAX) NULL' WHERE [FieldTypeId] = 15 AND [FieldTypeDW] ='List';
                </sql>
            </EcomFieldType>
        </database>
    </package>

    <package version="2187" date="14-05-2020">
        <file name="InformationInlineForm.cshtml" source="/Files/Templates/eCom7/CartV2/Step/" target="/Files/Templates/eCom7/CartV2/Step/" overwrite="false"/>
    </package>

    <package version="2186" date="21-09-2020">
        <database file="Ecom.mdb">
            <EcomProductAssignmentRuleShop>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomProductAssignmentRuleShop'">
                    CREATE TABLE [EcomProductAssignmentRuleShop](
	                    [EcomProductAssignmentRuleShopRuleId] [nvarchar](255) NOT NULL,
	                    [EcomProductAssignmentRuleShopShopId] [nvarchar](255) NOT NULL,
                        CONSTRAINT [DW_PK_EcomProductAssignmentRuleShop] PRIMARY KEY NONCLUSTERED ([EcomProductAssignmentRuleShopRuleId] ASC, [EcomProductAssignmentRuleShopShopId] ASC)
                    )
                </sql>
            </EcomProductAssignmentRuleShop>
        </database>
    </package>

    <package version="2185" date="15-09-2020">
        <database file="Ecom.mdb">
            <EcomProductAssignmentRule>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomProductAssignmentRule'">
                    CREATE TABLE [EcomProductAssignmentRule](
	                    [EcomProductAssignmentRuleId] [nvarchar](255) NOT NULL,
	                    [EcomProductAssignmentRuleName] [nvarchar](255) NULL,
                        [EcomProductAssignmentRuleActive] [bit] NOT NULL DEFAULT 0,
                        [EcomProductAssignmentRuleIsQueryRule] [bit] NOT NULL DEFAULT 0,
	                    [EcomProductAssignmentRuleRepositoryQuery] [nvarchar](255) NULL,
                        CONSTRAINT [DW_PK_EcomProductAssignmentRule] PRIMARY KEY NONCLUSTERED ([EcomProductAssignmentRuleId] ASC)
                    )
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomProductAssignmentRuleMapping'">
                    CREATE TABLE [EcomProductAssignmentRuleMapping](
	                    [EcomProductAssignmentRuleMappingId] [nvarchar](255) NOT NULL,
	                    [EcomProductAssignmentRuleMappingRuleId] [nvarchar](255) NULL,
                        [EcomProductAssignmentRuleMappingGroupFieldId] [nvarchar](255) NULL,
                        [EcomProductAssignmentRuleMappingQueryParameter] [nvarchar](255) NULL,
                        CONSTRAINT [DW_PK_EcomProductAssignmentRuleMapping] PRIMARY KEY NONCLUSTERED ([EcomProductAssignmentRuleMappingId] ASC)
                    )
                </sql>
            </EcomProductAssignmentRule>
        </database>
    </package>

    <package version="2184" date="16-09-2020">
        <database file="Ecom.mdb">
            <Ecom7Tree>
                <sql conditional="SELECT COUNT(*) FROM Ecom7Tree WHERE TreeChildPopulate = 'PRODASSIGN'">
                    INSERT INTO Ecom7Tree (ParentId,Text,Alt,TreeIcon, TreeUrl, TreeChildPopulate, TreeSort, TreeHasAccessModuleSystemName)
                    VALUES (94, 'Auto-assign products',7, 'tree/btn_properties.png','/Admin/Module/eCom_Catalog/dw7/ProductAssignment/ProductAssignmentRulesList.aspx','PRODASSIGN',91, NULL);
                </sql>
            </Ecom7Tree>
        </database>
    </package>

    <package version="2183" date="15-09-2020">
        <database file="Ecom.mdb">
            <EcomDiscount>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomDiscount' AND COLUMN_NAME='DiscountLoyaltyPointsRate'">
                    ALTER TABLE [EcomDiscount] ADD [DiscountLoyaltyPointsRate] [FLOAT] NULL
                </sql>
            </EcomDiscount>
        </database>
    </package>
    
    <package version="2182" date="07-09-2020">
	    <database file="Ecom.mdb">
            <EcomCountries>                
                <sql conditional="select Count(*) from INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS where DELETE_RULE ='CASCADE' AND CONSTRAINT_NAME = 'DW_FK_EcomCountryText_EcomCountries'">
                    ALTER TABLE [EcomCountryText] DROP CONSTRAINT [DW_FK_EcomCountryText_EcomCountries];
                    ALTER TABLE [EcomCountryText] WITH CHECK ADD CONSTRAINT [DW_FK_EcomCountryText_EcomCountries] FOREIGN KEY([CountryTextCode2], [CountryTextRegionCode]) REFERENCES [EcomCountries] ([CountryCode2], [CountryRegionCode]) ON DELETE CASCADE ON UPDATE CASCADE;
                </sql>
            </EcomCountries>
        </database>
    </package>

    <package version="2181" date="10-08-2020">
	    <database file="Ecom.mdb">
            <EcomOrders>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EcomOrders' AND COLUMN_NAME = 'OrderPointsToUse'">
                    ALTER TABLE [EcomOrders] ADD [OrderPointsToUse] FLOAT NULL;
                </sql>
            </EcomOrders>
        </database>
    </package>

    <package version="2180" date="04-08-2020">
        <database file="Ecom.mdb">
            <Ecom7Tree>
                <sql conditional="SELECT COUNT(*) FROM Ecom7Tree WHERE TreeChildPopulate = 'ASSETCATEGORIES'">
                    INSERT INTO Ecom7Tree (ParentId,Text,Alt,TreeIcon, TreeUrl, TreeChildPopulate, TreeSort, TreeHasAccessModuleSystemName)
                    VALUES (93, 'Asset categories',7, 'tree/btn_properties.png','/Admin/Module/eCom_Catalog/dw7/ImageGroup/ImageGroupList.aspx','ASSETCATEGORIES',123, NULL);
                </sql>
            </Ecom7Tree>
        </database>
    </package>

    <package version="2179" date="17-07-2020">
	    <database file="Ecom.mdb">
            <EcomOrders>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EcomFieldDisplayGroupTranslation' AND COLUMN_NAME = 'FieldDisplayGroupTranslationGroupSystemName'">
                    ALTER TABLE [EcomFieldDisplayGroupTranslation] ADD [FieldDisplayGroupTranslationGroupSystemName] NVARCHAR(255) NULL;
                </sql>
                <sql conditional="SELECT IIF(COUNT(*) = 0, 1, 0) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EcomFieldDisplayGroupTranslation' AND COLUMN_NAME = 'FieldDisplayGroupTranslationGroupSystemName'">
                    UPDATE EcomFieldDisplayGroupTranslation SET FieldDisplayGroupTranslationGroupSystemName=(SELECT FieldDisplayGroupSystemName FROM EcomFieldDisplayGroups WHERE FieldDisplayGroupId = FieldDisplayGroupTranslationGroupId) WHERE FieldDisplayGroupTranslationGroupSystemName IS NULL;
                    ALTER TABLE [EcomFieldDisplayGroupTranslation] ALTER COLUMN FieldDisplayGroupTranslationGroupSystemName NVARCHAR(255) NOT NULL;
                    ALTER TABLE [EcomFieldDisplayGroupTranslation] DROP CONSTRAINT [PK_EcomFieldDisplayGroupTranslation];
                    ALTER TABLE [EcomFieldDisplayGroupTranslation] ADD CONSTRAINT [PK_EcomFieldDisplayGroupTranslation_V1] PRIMARY KEY CLUSTERED ([FieldDisplayGroupTranslationGroupSystemName] ASC, [FieldDisplayGroupTranslationLanguageId] ASC);
                </sql>
                <sql conditional="SELECT IIF(Column_Default IS NULL, 0, 1) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EcomFieldDisplayGroupTranslation' AND COLUMN_NAME = 'FieldDisplayGroupTranslationGroupId'">
                    ALTER TABLE [EcomFieldDisplayGroupTranslation] ADD CONSTRAINT DF_EcomFieldDisplayGroupTranslation_FieldDisplayGroupTranslationGroupId DEFAULT 0 FOR FieldDisplayGroupTranslationGroupId
                </sql>
                <sql conditional="SELECT IIF(COUNT(*) = 0, 1, 0) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EcomFieldDisplayGroupTranslation' AND COLUMN_NAME = 'FieldDisplayGroupTranslationGroupId'">
                    ALTER TABLE [EcomFieldDisplayGroupTranslation] ADD FieldDisplayGroupTranslationGroupId int NOT NULL CONSTRAINT DF_EcomFieldDisplayGroupTranslation_FieldDisplayGroupTranslationGroupId DEFAULT 0
                </sql>
            </EcomOrders>
        </database>
    </package>

    <package version="2178" releasedate="29-06-2020">
         <database file="Ecom.mdb">
            <EcomDetailGroup>
				<sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomDetailsGroup' AND COLUMN_NAME='DetailsGroupIsSystemGroup'">
                    ALTER TABLE [EcomDetailsGroup] ADD [DetailsGroupIsSystemGroup] BIT NOT NULL DEFAULT 0;
				</sql>
            </EcomDetailGroup>
            <EcomDetailGroup>
                <sql conditional="SELECT COUNT(*) FROM EcomDetailsGroup WHERE EcomDetailsGroupSystemName = 'Images' AND DetailsGroupIsSystemGroup = 1">
                    INSERT INTO EcomDetailsGroup VALUES ('Images', 1, 0, 0, '', 0, 1)
                </sql>
            </EcomDetailGroup>
            <EcomDetailGroupTranslation>
                <sql conditional="SELECT COUNT(*) FROM EcomDetailsGroupTranslation WHERE DetailsGroupTranslationText = 'Images'">
                    INSERT INTO EcomDetailsGroupTranslation (DetailsGroupTranslationGroupId, DetailsGroupTranslationLanguageId, DetailsGroupTranslationText) 
                    SELECT EcomDetailsGroupId, (SELECT LanguageId FROM EcomLanguages WHERE LanguageIsDefault = 1) as DefaultLanguageId, EcomDetailsGroupSystemName FROM EcomDetailsGroup WHERE EcomDetailsGroupSystemName = 'Images' AND DetailsGroupIsSystemGroup = 1
                </sql>
            </EcomDetailGroupTranslation>
            <EcomDetails>
				<sql conditional="">
                    UPDATE EcomDetails SET DetailsGroupId = (SELECT EcomDetailsGroupId FROM EcomDetailsGroup WHERE EcomDetailsGroupSystemName = 'Images' AND DetailsGroupIsSystemGroup = 1) WHERE DetailType = 0 AND DetailsGroupId IS NULL
				</sql>
            </EcomDetails>
        </database>
    </package>

    <package version="2177" releasedate="22-06-2020">
	    <database file="Ecom.mdb">
	        <EcomCountries>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomCountries' AND COLUMN_NAME='CountryAddressDisplayFormatMode'">
                    ALTER TABLE [EcomCountries] ADD [CountryAddressDisplayFormatMode] [INT] NULL
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomCountries' AND COLUMN_NAME='CountryAddressDisplayFormat'">
                    ALTER TABLE [EcomCountries] ADD [CountryAddressDisplayFormat] NVARCHAR(MAX) NULL   
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomCountries' AND COLUMN_NAME='CountryAddressEditFormatMode'">
                    ALTER TABLE [EcomCountries] ADD [CountryAddressEditFormatMode] [INT] NULL   
                </sql>
                 <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomCountries' AND COLUMN_NAME='CountryAddressEditFormat'">
                    ALTER TABLE [EcomCountries] ADD [CountryAddressEditFormat] NVARCHAR(MAX) NULL   
                </sql>
	        </EcomCountries>
        </database>
    </package>

    <package version="2176" releasedate="12-06-2020">
        <invoke type="Dynamicweb.Ecommerce.Content.Management.UpdateScripts, Dynamicweb.Ecommerce" method="FixBrokenPIMPermissions_ShopsAndGroups" />
    </package>

    <package version="2174" releasedate="09-06-2020">
        <database file="Ecom.mdb">
            <EcomGroups>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomGroups' AND COLUMN_NAME='GroupProductRelationRuleField1'">
                    ALTER TABLE [EcomGroups] ADD [GroupProductRelationRuleField1] NVARCHAR(255) NULL
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomGroups' AND COLUMN_NAME='GroupProductRelationRuleValue1'">
                    ALTER TABLE [EcomGroups] ADD [GroupProductRelationRuleValue1] NVARCHAR(MAX) NULL   
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomGroups' AND COLUMN_NAME='GroupProductRelationRuleField2'">
                    ALTER TABLE [EcomGroups] ADD [GroupProductRelationRuleField2] NVARCHAR(255) NULL
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomGroups' AND COLUMN_NAME='GroupProductRelationRuleValue2'">
                    ALTER TABLE [EcomGroups] ADD [GroupProductRelationRuleValue2] NVARCHAR(MAX) NULL   
                </sql>
            </EcomGroups>
        </database>
    </package> 

    <package version="2172" releasedate="05-06-2020">
        <database file="Ecom.mdb">
            <EcomGroupProductRelation>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomGroupProductRelation' AND COLUMN_NAME='GroupProductRelationRuleId'">
                    ALTER TABLE [EcomGroupProductRelation] ADD [GroupProductRelationRuleId] [nvarchar](50) NULL; 
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomGroupProductRelation' AND COLUMN_NAME='GroupProductRelationCreated'">
                    ALTER TABLE [EcomGroupProductRelation] ADD [GroupProductRelationCreated] DATETIME NOT NULL DEFAULT GETDATE();
                </sql>
            </EcomGroupProductRelation>
        </database>
    </package>

    <package version="2171" releasedate="02-06-2020">
        <database file="Ecom.mdb">
            <EcomProductCategoryFieldTranslation>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomProductCategoryFieldTranslation' AND COLUMN_NAME='FieldTranslationErrorMessage'">
                    ALTER TABLE [EcomProductCategoryFieldTranslation] ADD [FieldTranslationErrorMessage] [nvarchar](255) NULL;                    
                </sql>
            </EcomProductCategoryFieldTranslation>
            <EcomProductCategoryField>
				<sql conditional="">
                    ALTER TABLE [EcomProductCategoryField] DROP [FieldValidationErrorMessage]
				</sql>
            </EcomProductCategoryField>
        </database>
    </package>
    
    <package version="2170" date="01-06-2020">
        <file name="ManualForm.cshtml" source="/Files/Templates/eCom7/CheckoutHandler/AuthorizeNet/Post/" target="/Files/Templates/eCom7/CheckoutHandler/AuthorizeNet/Post/" overwrite="false"/>
        <file name="PartialHostedForm.cshtml" source="/Files/Templates/eCom7/CheckoutHandler/AuthorizeNet/Post/" target="/Files/Templates/eCom7/CheckoutHandler/AuthorizeNet/Post/" overwrite="false"/>
    </package>

    <package version="2169" date="28-05-2020">
	    <database file="Ecom.mdb">
            <EcomProductCategoryField>
				<sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomProductCategoryField' AND COLUMN_NAME='FieldValidationPattern'">
                    ALTER TABLE [EcomProductCategoryField] ADD [FieldValidationPattern] NVARCHAR(255) NULL;
                    ALTER TABLE [EcomProductCategoryField] ADD [FieldValidationErrorMessage] NVARCHAR(255) NULL;
				</sql>
            </EcomProductCategoryField>
        </database>
    </package>

    <package version="2168" date="28-05-2020">
	    <database file="Ecom.mdb">
            <EcomProductField>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EcomProductField' AND COLUMN_NAME = 'ProductFieldValidationPattern'">
                    ALTER TABLE [EcomProductField] ADD [ProductFieldValidationPattern] NVARCHAR(255) NULL;
                    ALTER TABLE [EcomProductField] ADD [ProductFieldValidationErrorMessage] NVARCHAR(255) NULL;
                </sql>
            </EcomProductField>
        </database>
    </package>

     <package version="2167" releasedate="28-05-2020">
        <database file="Dynamic.mdb">
            <eCom_CustomerExperienceCenter>
                <sql conditional="SELECT COUNT(*) FROM [Module] WHERE [ModuleSystemName] = 'eCom_CustomerExperienceCenter'">
                    INSERT INTO [Module]
                        ([ModuleSystemName], [ModuleName], [ModuleAccess], [ModuleParagraph], [ModuleIsBeta], [ModuleEcomNotInstalledAccess])
                    VALUES
                        ('eCom_CustomerExperienceCenter', 'Customer experience center', 1, 1, 0, 0)
                </sql>
            </eCom_CustomerExperienceCenter>
        </database>
        <file name="OrderViewList.cshtml" source="/Files/Templates/eCom/CustomerExperienceCenter/" target="/Files/Templates/eCom/CustomerExperienceCenter/" overwrite="false"/>
        <file name="OrderViewDetail.cshtml" source="/Files/Templates/eCom/CustomerExperienceCenter/" target="/Files/Templates/eCom/CustomerExperienceCenter/" overwrite="false"/>
    </package>

    <package version="2166" date="14-05-2020">
        <file name="InlineForm.cshtml" source="/Files/Templates/eCom7/CheckoutHandler/QuickPayPaymentWindow/Post/" target="/Files/Templates/eCom7/CheckoutHandler/QuickPayPaymentWindow/Post/" overwrite="false"/>
    </package>
    
    <package version="2165" date="07-05-2020">
        <file name="checkouthandler_error.cshtml" source="/Files/Templates/eCom7/CheckoutHandler/Adyen/Error/" target="/Files/Templates/eCom7/CheckoutHandler/Adyen/Error/" overwrite="false"/>
        <file name="checkouthandler_cancel.html" source="/Files/Templates/eCom7/CheckoutHandler/Adyen/Cancel/" target="/Files/Templates/eCom7/CheckoutHandler/Adyen/Cancel/" overwrite="false"/>
        <file name="Payments.cshtml" source="/Files/Templates/eCom7/CheckoutHandler/Adyen/Form/" target="/Files/Templates/eCom7/CheckoutHandler/Adyen/Form/" overwrite="false"/>
    </package>

    <package version="2164" date="20-04-2020">
	    <database file="Ecom.mdb">
            <EcomOrders>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EcomFieldDisplayGroups' AND COLUMN_NAME = 'FieldDisplayGroupSystemName'">
                    ALTER TABLE [EcomFieldDisplayGroups] ADD [FieldDisplayGroupSystemName] NVARCHAR(255) NULL;
                </sql>
            </EcomOrders>
        </database>
        <invoke type="Dynamicweb.Content.Management.UpdateScripts, Dynamicweb" method="UpdateEmptyFieldDisplayGroupSystemName" />
    </package>

    <package version="2163" date="10-04-2020">
        <file name="IceCatLanguageMapper.xml" source="/Files/System/Integration/OpenCatalog/IceCat/" target="/Files/System/Integration/OpenCatalog/IceCat/" overwrite="false"/>
    </package>

    <package version="2161" date="24-03-2020">
	    <database file="Ecom.mdb">
            <EcomPrices>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EcomPrices' AND COLUMN_NAME = 'PriceIsWithVat'">
                    ALTER TABLE [EcomPrices] ADD [PriceIsWithVat] BIT NULL;
                </sql>
            </EcomPrices>
        </database>
    </package>

    <package version="2160" date="17-03-2020">
	    <database file="Ecom.mdb">
            <EcomOrders>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EcomOrders' AND COLUMN_NAME = 'OrderReference'">
                    ALTER TABLE [EcomOrders] ADD [OrderReference] NVARCHAR(255) NULL;
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EcomOrders' AND COLUMN_NAME = 'OrderShippingDate'">
                    ALTER TABLE [EcomOrders] ADD [OrderShippingDate] DATETIME NULL;
                </sql>
            </EcomOrders>
        </database>
    </package>

	<package version="2159" releasedate="16-03-2020">
        <file name="Payment.html" target="/Files/Templates/eCom7/CheckoutHandler/EbizCharge/Payment" source="/Files/Templates/eCom7/CheckoutHandler/EbizCharge/Payment" />
        <file name="Payment.cshtml" target="/Files/Templates/eCom7/CheckoutHandler/EbizCharge/Payment" source="/Files/Templates/eCom7/CheckoutHandler/EbizCharge/Payment" />
    </package>

    <package version="2158" releasedate="05-03-2020">
        <database file="Ecom.mdb">
            <EcomProducts>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomProducts' AND COLUMN_NAME='ProductDiscontinued'">
                    ALTER TABLE [EcomProducts] ADD [ProductDiscontinued] [BIT] NOT NULL DEFAULT 0;
				</sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomProducts' AND COLUMN_NAME='ProductDiscontinuedReplacementProductId'">
                    ALTER TABLE [EcomProducts] ADD [ProductReplacementProductId] [NVARCHAR](30) NULL;
				</sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomProducts' AND COLUMN_NAME='ProductDiscontinuedReplacementVariantId'">
                    ALTER TABLE [EcomProducts] ADD [ProductReplacementVariantId] [NVARCHAR](255) NULL;
				</sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomProducts' AND COLUMN_NAME='ProductDiscontinuedAction'">
                    ALTER TABLE [EcomProducts] ADD [ProductDiscontinuedAction] [INT] NOT NULL DEFAULT 0;
				</sql>
            </EcomProducts>
        </database>
    </package>

    <package version="2157" date="04-03-2020">
        <file name="ChannableImportOrdersQuickSetup.xml" source="/Files/System/Integration/Jobs" target="/Files/System/Integration/Jobs/"  overwrite="false"/>
        <file name="channableOrders.xslt" source="/Files/System/Integration" target="/Files/System/Integration/"  overwrite="false"/>
    </package>

    <package version="2156" releasedate="28-02-2020">
        <database file="Ecom.mdb">
            <EcomProducts>
				<sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EcomProducts' AND COLUMN_NAME = 'ProductExpectedDelivery'">
                    ALTER TABLE [EcomProducts] ADD [ProductExpectedDelivery] [DATETIME] NULL;
				</sql>
            </EcomProducts>
        </database>
    </package>

    <package version="2155" date="21-02-2020">
	    <database file="Ecom.mdb">
            <EcomFeed>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EcomFeed' AND COLUMN_NAME = 'FeedUserId'">
                    ALTER TABLE [EcomFeed] ADD [FeedUserId] [int] NULL;
                </sql>
            </EcomFeed>
        </database>
    </package>
    
    <package version="2154" date="29-01-2020">
        <file name="channable_products_transformer.xslt" source="/Files/Templates/Feeds" target="/Files/Templates/Feeds/"  overwrite="false"/>
    </package>
    
    <package version="2153" releasedate="12-12-2019">
        <database file="Ecom.mdb">
            <Ecom7Tree>
                <sql conditional="SELECT COUNT(*) FROM Ecom7Tree WHERE TreeChildPopulate = 'CARTSFLOW'">
                    INSERT INTO [Ecom7Tree] ([ParentId], [Text], [Alt], [TreeIcon], [TreeIconOpen], [TreeUrl], [TreeChildPopulate], [TreeSort], [TreeHasAccessModuleSystemName]) 
                    VALUES(92, N'Cart flows', NULL, N'/Admin/Module/eCom_Catalog/images/buttons/shoppingcart.png', NULL, N'Lists/EcomOrderFlow_List.aspx?OrderType=cart', N'CARTSFLOW', 71, N'eCom_CartV2')
                </sql>
            </Ecom7Tree>
        </database>
    </package>
    
    <package version="2152" releasedate="11-12-2019">
        <file name="checkouthandler_error.cshtml" target="/Files/Templates/eCom7/CheckoutHandler/ErrorTemplate" source="/Files/Templates/eCom7/CheckoutHandler/ErrorTemplate" />
    </package>
        
     <package version="2151" releasedate="05-12-2019">
        <database file="Ecom.mdb" >
            <Ecom7Tree>
                <sql conditional="SELECT COUNT(*) FROM [EcomTree] WHERE [TreeChildPopulate] = 'CARTS'">
                    INSERT INTO [EcomTree] ([Parentid], [Text], [TreeIcon], [TreeUrl], [TreeChildPopulate], [TreeSort], [TreeHasAccessModuleSystemName])
                    VALUES (1, N'Carts', N'/Admin/Module/eCom_Catalog/dw7/images/buttons/shoppingcart.png', N'Lists/EcomList.aspx?type=CART', 'CARTS', 5, 'eCom_Catalog');
                </sql>
            </Ecom7Tree>
        </database>
    </package>

    <package version="2150" date="05-12-2019">
        <file name="icecatProducts.xslt" source="/Files/System/Integration/OpenCatalog/IceCat/" target="/Files/System/Integration/OpenCatalog/IceCat/" overwrite="false"/>
    </package>

    <package version="2149" date="29-11-2019">
	    <database file="Ecom.mdb">
            <EcomProductField>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EcomProductField' AND COLUMN_NAME = 'ProductFieldAutoId'">
                    ALTER TABLE [EcomProductField] ADD [ProductFieldAutoId] [int] IDENTITY(1,1) NOT NULL;
                </sql>
            </EcomProductField>
        </database>
    </package>

    <package version="2148" date="25-11-2019">
	    <database file="Ecom.mdb">
            <EcomOrders>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EcomOrders' AND COLUMN_NAME = 'OrderVATCountryCode'">
                    ALTER TABLE [EcomOrders] ADD [OrderVATCountryCode] NVARCHAR(50) NULL;
                </sql>
            </EcomOrders>
        </database>
    </package>

    <package version="2147" date="20-11-2019">
	    <database file="Ecom.mdb">
            <EcomGiftCardTransaction>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EcomGiftCard' AND COLUMN_NAME = 'GiftCardVATPercent'">
                    ALTER TABLE [EcomGiftCard] ADD [GiftCardVATPercent] FLOAT NULL;
                </sql>
            </EcomGiftCardTransaction>
        </database>
    </package>
        
    <package version="2145" date="07-11-2019">
        <file name="channable_products_transformer.xslt" source="/Files/Templates/Feeds" target="/Files/Templates/Feeds/"  overwrite="false"/>
        <file name="ChannableFeedSetUp.xml" source="/Files/System/Integration" target="/Files/System/Integration/"  overwrite="false"/>
        <file name="ChannableFeedQuickSetup.xml" source="/Files/System/Integration/Jobs" target="/Files/System/Integration/Jobs/"  overwrite="false"/>
        <setting key="/Globalsettings/Ecom/Required/ProductCategories/ChannableFieds.Brand" value="True" overwrite="false" />
        <setting key="/Globalsettings/Ecom/Required/ProductCategories/ChannableFieds.Ean" value="True" overwrite="false" />
    </package>
    
    <package version="2144" releasedate="07-11-2019">
        <database file="Ecom.mdb">
            <EcomAssortmentItems>
	            <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EcomAssortmentItems' AND COLUMN_NAME = 'AssortmentItemAutoID' AND DATA_TYPE = 'BIGINT'">
                    IF EXISTS (SELECT * FROM sys.indexes WHERE name = N'DW_IX_EcomAssortmentItems_ProductID')
                        DROP INDEX [DW_IX_EcomAssortmentItems_ProductID] ON [EcomAssortmentItems];
                    IF EXISTS (SELECT * FROM sys.indexes WHERE name = N'IX_EcomAssortmentItems_AutoID')
                        DROP INDEX [IX_EcomAssortmentItems_AutoID] ON [EcomAssortmentItems];
                    IF EXISTS (SELECT * FROM sys.indexes WHERE name = N'IX_EcomAssortmentItems_AssortmentID')
                        DROP INDEX [IX_EcomAssortmentItems_AssortmentID] ON [EcomAssortmentItems];
                    IF EXISTS (SELECT * FROM sys.indexes WHERE name = N'IX_EcomAssortmentItems_RelationType_RelationAutoID')
                        DROP INDEX [IX_EcomAssortmentItems_RelationType_RelationAutoID] ON [EcomAssortmentItems];
                    IF EXISTS (SELECT * FROM sys.indexes WHERE name = N'IX_EcomAssortmentItems_LanguageID_ProductID_ProductVariantID')
                        DROP INDEX [IX_EcomAssortmentItems_LanguageID_ProductID_ProductVariantID] ON [EcomAssortmentItems];
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EcomAssortmentItems' AND COLUMN_NAME = 'AssortmentItemAutoID' AND DATA_TYPE = 'BIGINT'">
                    ALTER TABLE [EcomAssortmentItems] ALTER COLUMN [AssortmentItemAutoID] BIGINT NOT NULL;

                    CREATE NONCLUSTERED INDEX [DW_IX_EcomAssortmentItems_ProductID] ON [dbo].[EcomAssortmentItems] 
	                    (
		                    [AssortmentItemProductID] ASC
	                    )
	                    INCLUDE ([AssortmentItemAssortmentID],[AssortmentItemProductVariantID],[AssortmentItemAutoID]); 
                </sql>
                <sql conditional="">
		            IF EXISTS( SELECT 'Enterprise' AS EngineEdition WHERE SERVERPROPERTY('EngineEdition') = 3 )
			            BEGIN
                            IF NOT EXISTS(SELECT object_id FROM sys.indexes WHERE name = 'IX_EcomAssortmentItems_AutoID')
                                    CREATE UNIQUE CLUSTERED INDEX IX_EcomAssortmentItems_AutoID 
                                    ON EcomAssortmentItems ( AssortmentItemAutoID ASC )
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON );

                            IF NOT EXISTS(SELECT object_id FROM sys.indexes WHERE name = 'IX_EcomAssortmentItems_AssortmentID')
                                    CREATE NONCLUSTERED INDEX IX_EcomAssortmentItems_AssortmentID 
                                    ON EcomAssortmentItems ( AssortmentItemAssortmentID ASC )
                                    INCLUDE ( AssortmentItemAutoID ) 
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON );

                            IF NOT EXISTS(SELECT object_id FROM sys.indexes WHERE name = 'IX_EcomAssortmentItems_RelationType_RelationAutoID')
                                    CREATE NONCLUSTERED INDEX IX_EcomAssortmentItems_RelationType_RelationAutoID 
                                    ON EcomAssortmentItems ( AssortmentItemRelationType ASC, AssortmentItemRelationAutoID ASC )
                                    INCLUDE ( AssortmentItemAutoID ) 
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON );

                            IF NOT EXISTS(SELECT object_id FROM sys.indexes WHERE name = 'IX_EcomAssortmentItems_LanguageID_ProductID_ProductVariantID')
				                    CREATE NONCLUSTERED INDEX IX_EcomAssortmentItems_LanguageID_ProductID_ProductVariantID 
                                    ON EcomAssortmentItems ( AssortmentItemLanguageID ASC, AssortmentItemProductID ASC, AssortmentItemProductVariantID ASC )
                                    INCLUDE ( AssortmentItemAutoID ) 
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON );
                        END
                </sql>
                <sql conditional="">
		            IF NOT EXISTS( SELECT 'Enterprise' AS EngineEdition WHERE SERVERPROPERTY('EngineEdition') = 3 )
			            BEGIN
                            IF NOT EXISTS(SELECT object_id FROM sys.indexes WHERE name = 'IX_EcomAssortmentItems_AutoID')
                                    CREATE UNIQUE CLUSTERED INDEX IX_EcomAssortmentItems_AutoID 
                                    ON EcomAssortmentItems ( AssortmentItemAutoID ASC )
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF );

                            IF NOT EXISTS(SELECT object_id FROM sys.indexes WHERE name = 'IX_EcomAssortmentItems_AssortmentID')
                                    CREATE NONCLUSTERED INDEX IX_EcomAssortmentItems_AssortmentID 
                                    ON EcomAssortmentItems ( AssortmentItemAssortmentID ASC )
                                    INCLUDE ( AssortmentItemAutoID ) 
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF );

                            IF NOT EXISTS(SELECT object_id FROM sys.indexes WHERE name = 'IX_EcomAssortmentItems_RelationType_RelationAutoID')
                                    CREATE NONCLUSTERED INDEX IX_EcomAssortmentItems_RelationType_RelationAutoID 
                                    ON EcomAssortmentItems ( AssortmentItemRelationType ASC, AssortmentItemRelationAutoID ASC )
                                    INCLUDE ( AssortmentItemAutoID ) 
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF );

                            IF NOT EXISTS(SELECT object_id FROM sys.indexes WHERE name = 'IX_EcomAssortmentItems_LanguageID_ProductID_ProductVariantID')
				                    CREATE NONCLUSTERED INDEX IX_EcomAssortmentItems_LanguageID_ProductID_ProductVariantID 
                                    ON EcomAssortmentItems ( AssortmentItemLanguageID ASC, AssortmentItemProductID ASC, AssortmentItemProductVariantID ASC )
                                    INCLUDE ( AssortmentItemAutoID ) 
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF );
                        END
                </sql>
            </EcomAssortmentItems>
        </database>
    </package>
  
    <package version="2143" releasedate="30-10-2019">
        <file name="EmbededDibs.cshtml" target="/Files/Templates/eCom7/CheckoutHandler/DibsEasy/Form" source="/Files/Templates/eCom7/CheckoutHandler/DibsEasy/Form" />
        <file name="checkouthandler_error.cshtml" target="/Files/Templates/eCom7/CheckoutHandler/DibsEasy/Error" source="/Files/Templates/eCom7/CheckoutHandler/DibsEasy/Error" />
    </package>
    
    <package version="2142" date="18-10-2019">
	    <database file="Ecom.mdb">
            <EcomPayments>
                <sql conditional="">
                    ALTER TABLE [EcomDiscountTranslation] ADD
                        [DiscountTranslationDescription] NVARCHAR(MAX) NULL,
                        [DiscountTranslationCampaignName] NVARCHAR(255) NULL 
                </sql>
            </EcomPayments>
        </database>
    </package>

    <package version="2141" date="17-10-2019">
	    <database file="Ecom.mdb">
            <EcomPayments>
                <sql conditional="">
                    ALTER TABLE [EcomPayments] ADD
                        [PaymentUserGroups] NVARCHAR(MAX) NULL,
                        [PaymentAllowAnonymousUsers] BIT NOT NULL DEFAULT 0
                </sql>
            </EcomPayments>
        </database>
    </package>

    <package version="2140" date="14-10-2019">
        <database file="Ecom.mdb">
            <EcomCustomerFavoriteLists>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomOrders' AND COLUMN_NAME='OrderDisplayName'">
                    ALTER TABLE [EcomOrders] ADD [OrderDisplayName] NVARCHAR(255) NULL;
                    ALTER TABLE [EcomOrders] ADD [OrderDiscountPercentage] [FLOAT] NOT NULL DEFAULT 0;
                    ALTER TABLE [EcomOrders] ADD [OrderDiscountAmount] [FLOAT] NOT NULL DEFAULT 0;
                    ALTER TABLE [EcomOrderLines] ADD [OrderLineDiscountPercentage] [FLOAT] NOT NULL DEFAULT 0;
                    ALTER TABLE [EcomOrderLines] ADD [OrderLineUnitPriceBeforeDiscount] [FLOAT] NOT NULL DEFAULT 0;
                </sql>
            </EcomCustomerFavoriteLists>
        </database>
    </package>

    <package version="2139" releasedate="08-10-2019">
        <database file="Ecom.mdb">
            <EcomProducts>
				<sql conditional="">
                    ALTER TABLE [EcomProducts] ADD [ProductPurchaseMinimumQuantity] [FLOAT] NULL;
                    ALTER TABLE [EcomProducts] ADD [ProductPurchaseQuantityStep] [FLOAT] NULL;
				</sql>
            </EcomProducts>
        </database>
    </package>
    
    <package version="2138" releasedate="02-10-2019">
        <setting key="/Globalsettings/Ecom/Product/Details/Extensions" value="jpg,jpeg,png,bmp,tiff,pdf,docx,xlsx,ppt,avi" overwrite="false" />
        <database file="Ecom.mdb">
            <DetailsGroup>
				<sql conditional="">
                    ALTER TABLE [EcomDetailsGroup] ADD [DetailsGroupExtensions] [NVARCHAR](255) NULL;
                    ALTER TABLE [EcomDetailsGroup] ADD [DetailsGroupControlType] [INT] NULL;
				</sql>
            </DetailsGroup>
        </database>
    </package>

    <package version="2137" releasedate="01-10-2019">
        <file name="CartList.html" source="/Files/Templates/eCom/CustomerCenter" target="/Files/Templates/eCom/CustomerCenter"  overwrite="false"/>
        <file name="CartDetail.html" source="/Files/Templates/eCom/CustomerCenter" target="/Files/Templates/eCom/CustomerCenter"  overwrite="false"/>
    </package>  

    <package version="2136" date="30-06-2015">
        <database file="Ecom.mdb">
            <EcomCustomerFavoriteLists>
                <sql conditional="">
                    ALTER TABLE [EcomCustomerFavoriteLists] ADD [IsShared] BIT NOT NULL DEFAULT 0
                </sql>
            </EcomCustomerFavoriteLists>
        </database>
    </package>
    
    <package version="2135" releasedate="24-09-2019">
        <invoke type="Dynamicweb.Content.Management.UpdateScripts, Dynamicweb" method="FixQueriesMultiEditViewFieldNamesRollback" />
    </package>

    <package version="2134" date="18-09-2019">
	    <database file="Ecom.mdb">
            <EcomShippings>
                <sql conditional="">
                    UPDATE [EcomShippings] SET [ShippingActive] = 1 WHERE [ShippingActive] IS NULL
                </sql>
            </EcomShippings>
        </database>
    </package>

    <package version="2133" releasedate="13-09-2019">
        <database file="Ecom.mdb">
            <EcomShops>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomGroups' AND COLUMN_NAME='GroupCompletionRules'">
                    ALTER TABLE [EcomGroups] ADD [GroupCompletionRules] NVARCHAR(MAX) NULL
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomGroups' AND COLUMN_NAME='GroupCompletionLanguageIds'">
                    ALTER TABLE [EcomGroups] ADD [GroupCompletionLanguageIds] NVARCHAR(MAX) NULL   
                </sql>
            </EcomShops>
        </database>
    </package>  

    <package version="2131" date="01-08-2019">
	    <database file="Ecom.mdb">
            <EcomGroupFacets>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomGroupFacetRelation' AND COLUMN_NAME='GroupFacetRelationDisabled'">
                    ALTER TABLE [EcomGroupFacetRelation] ADD [GroupFacetRelationDisabled] [bit] NOT NULL DEFAULT 0
                </sql>
                <sql conditional="">
                    ALTER TABLE [EcomGroupFacetRelation] ALTER COLUMN [GroupFacetRelationFacetField] [nvarchar](255) NULL;
                    ALTER TABLE [EcomGroupFacetRelation] ALTER COLUMN [GroupFacetRelationQueryParameter] [nvarchar](100) NULL;
                </sql>
            </EcomGroupFacets>
        </database>
    </package>

    <package version="2130" date="24-07-2019">
	    <database file="Ecom.mdb">
            <EcomGroupFacets>
                <sql conditional="">
                    ALTER TABLE [EcomGroupFacetRelation] ADD [GroupFacetRelationOrder] [int] NOT NULL DEFAULT 0
                </sql>
            </EcomGroupFacets>
        </database>
    </package>

    <package version="2129" date="18-07-2019">
        <database file="Ecom.mdb">
            <Module>
                <sql conditional="SELECT * FROM [EcomTree] WHERE [Parentid] = 1 AND [TreeChildPopulate] = 'FAVORITELISTS'">
                    INSERT INTO [EcomTree] ([Parentid],[Text],[TreeUrl],[TreeChildPopulate],[TreeSort],[TreeHasAccessModuleSystemName],[TreeIcon])
                        VALUES (1,'Favorite lists','','FAVORITELISTS',13,'eCom_CustomerCenter','FAVORITELISTS')
                </sql>
            </Module>
        </database>
    </package>

    <package version="2128" date="15-07-2019">
	    <database file="Ecom.mdb">
            <EcomShippings>
                <sql conditional="">
                    ALTER TABLE [EcomShippings] ADD
                        [ShippingUserGroups] NVARCHAR(MAX) NULL,
                        [ShippingAllowAnonymousUsers] BIT NOT NULL DEFAULT 0
                </sql>
            </EcomShippings>
        </database>
    </package>

    <package version="2127" releasedate="10-07-2019">
        <database file="Ecom.mdb">
            <EcomGroupFacets>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomGroupFacetRelation'">
                    CREATE TABLE [EcomGroupFacetRelation] (
	                    [GroupFacetRelationId] [int] IDENTITY(1,1) NOT NULL,
	                    [GroupFacetRelationGroupId] [nvarchar](255) NOT NULL,
	                    [GroupFacetRelationRepository] [nvarchar](100) NOT NULL,
	                    [GroupFacetRelationFacetGroup] [nvarchar](100) NOT NULL,
	                    [GroupFacetRelationFacetField] [nvarchar](255) NOT NULL,
	                    [GroupFacetRelationQueryParameter] [nvarchar](100) NOT NULL,
                        CONSTRAINT [PK_EcomGroupFacetRelation] PRIMARY KEY CLUSTERED ([GroupFacetRelationId] ASC)
                    )
                </sql>
            </EcomGroupFacets>
        </database>
    </package>

    <package version="2126" releasedate="07-06-2019">
        <database file="Ecom.mdb">
            <EcomShops>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE (TABLE_NAME='EcomShops' AND COLUMN_NAME='ShopImagePatternMain') OR (TABLE_NAME='EcomShops' AND COLUMN_NAME='ShopImagePatternVariant')">
                    ALTER TABLE [EcomShops] ADD 
                        [ShopImagePatternMain] NVARCHAR(255) NULL,
                        [ShopImagePatternVariant] NVARCHAR(255) NULL
                </sql>
            </EcomShops>
        </database>
    </package>

    <package version="2125" releasedate="27-05-2019">
        <setting key="/Globalsettings/Ecom/Unit/Dimensions" value="cm" overwrite="false" />
    </package>

    <package version="2124" date="24-05-2019">
        <database file="Ecom.mdb">
            <Products>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomCustomerFavoriteProducts' AND COLUMN_NAME='CustomerFavoriteProductAutoId'">
                    ALTER TABLE [EcomCustomerFavoriteProducts] ADD [CustomerFavoriteProductAutoId] IDENTITY NOT NULL
                </sql>
            </Products>
        </database>
    </package>

    <package version="2123" releasedate="24-05-2017">
        <database file="Dynamic.mdb">
            <EcomProducts>
                <sql conditional="">
                    ALTER TABLE [EcomProducts] ADD [ProductEAN] [NVARCHAR](255) NULL
                    ALTER TABLE [EcomProducts] ADD [ProductWidth] FLOAT NULL
                    ALTER TABLE [EcomProducts] ADD [ProductHeight] FLOAT NULL
                    ALTER TABLE [EcomProducts] ADD [ProductDepth] FLOAT NULL
                    ALTER TABLE [EcomProducts] ADD [ProductNeverOutOfStock] BIT NOT NULL DEFAULT 0
                </sql>
            </EcomProducts>
        </database>
    </package>

    <package version="2122" releasedate="22-05-2019">
        <database file="Ecom.mdb">
            <EcomDiscount>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomDiscount' AND COLUMN_NAME='DiscountOrderTotalPriceCurrencyCode'">
                    ALTER TABLE [EcomDiscount] ADD [DiscountOrderTotalPriceCurrencyCode] [nvarchar](3) NULL
                </sql>
            </EcomDiscount>
        </database>
    </package>
    
    <package version="2121" releasedate="21-05-2019">
        <invoke type="Dynamicweb.Content.Management.UpdateScripts, Dynamicweb" method="RemoveExcludedCompletionRuleFields" />
    </package>

    <package version="2120" releasedate="17-05-2019">
	    <database file="Ecom.mdb">
	        <EcomCountries>
                <sql conditional="">
                    ALTER TABLE [EcomCountries] ALTER COLUMN [CountryCultureInfo] [nvarchar](15) NOT NULL;
                </sql>
	        </EcomCountries>
        </database>
    </package>

    <package version="2119" releasedate="26-04-2019">
        <invoke type="Dynamicweb.Content.Management.UpdateScripts, Dynamicweb" method="FixSelectedProductFieldNames" />
    </package>

    <package version="2118" releasedate="18-04-2019">
        <database file="Ecom.mdb">
            <EcomProductCategory>
                <sql conditional="SELECT COUNT(*)-1 FROM sys.default_constraints dc INNER JOIN sys.columns c ON dc.parent_object_id = c.object_id AND c.column_id = dc.parent_column_id where c.Name = 'CategoryProductProperties'"> 
                    DECLARE @ConstraintName NVARCHAR(100);
                    SELECT @ConstraintName = dc.Name FROM sys.default_constraints dc INNER JOIN sys.columns c ON dc.parent_object_id = c.object_id AND c.column_id = dc.parent_column_id where c.Name = 'CategoryProductProperties';
                    EXEC('ALTER TABLE EcomProductCategory DROP CONSTRAINT ' + @ConstraintName);
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomProductCategory' AND COLUMN_NAME='CategoryType'"> 
                    ALTER TABLE [EcomProductCategory] ADD [CategoryType] [INT] NULL;
                </sql>  
                <sql conditional="SELECT CASE COUNT(*) WHEN 0 THEN 1 ELSE 0 END FROM [EcomProductCategory] WHERE [CategoryType] IS NULL"> 
                    UPDATE [EcomProductCategory] SET [CategoryType] = [CategoryProductProperties] WHERE [CategoryType] IS NULL;
                </sql>                 
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomProductCategory' AND COLUMN_NAME='CategoryProductProperties'">
                    ALTER TABLE [EcomProductCategory] ADD [CategoryProductProperties] BIT NOT NULL DEFAULT 0
                </sql>
            </EcomProductCategory>
        </database>
    </package>

    <package version="2117" date="10-04-2019">
	    <database file="Ecom.mdb">
            <EcomProductCategoryField>
				<sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomProductCategoryField' AND COLUMN_NAME='FieldForeignCategoryId'">
                    ALTER TABLE [EcomProductCategoryField] ADD [FieldForeignCategoryId] NVARCHAR(50) NULL
				</sql>
            </EcomProductCategoryField>
        </database>
    </package>

    <package version="2116" releasedate="08-04-2019">
        <database file="Ecom.mdb">
            <EcomDiscount>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomDiscount' AND COLUMN_NAME='DiscountExtenderType'">
                    ALTER TABLE [EcomDiscount] ADD [DiscountExtenderType] [nvarchar](255) NULL
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomDiscount' AND COLUMN_NAME='DiscountExtenderSettings'">
                    ALTER TABLE [EcomDiscount] ADD [DiscountExtenderSettings] [nvarchar](MAX) NULL
                </sql>
            </EcomDiscount>
        </database>
    </package>

    <package version="2115" date="18-02-2019">
	    <database file="Ecom.mdb">
            <EcomProductDynamicStructures>
				<sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='DynamicStructures'">
                    CREATE TABLE [DynamicStructures](
	                    [DynamicStructureId] [INT] IDENTITY(1,1) NOT NULL,
	                    [DynamicStructureTitle] [NVARCHAR](255) NULL,
	                    [DynamicStructureQueryId] [NVARCHAR](36) NULL,
                        [DynamicStructureUniqueId] UNIQUEIDENTIFIER CONSTRAINT [DW_DynamicStructureUniqueId] DEFAULT (newsequentialid()) NOT NULL
                    );

                    INSERT INTO DynamicStructures ([DynamicStructureTitle], [DynamicStructureQueryId])
                    SELECT [DynamicStructureTitle], [DynamicStructureQueryId] from [EcomProductDynamicStructures]

                    UPDATE [DynamicStructures] SET [DynamicStructureUniqueId] = newid();
                    UPDATE [UnifiedPermission] SET [PermissionKey] = d.[DynamicStructureUniqueId] FROM [UnifiedPermission] p INNER JOIN  [DynamicStructures] d ON p.[PermissionKey] = d.[DynamicStructureId] WHERE p.[PermissionName] = 'DynamicStructure' AND p.[PermissionSubName] &lt;&gt; 'VirtualNode';
				</sql>
            </EcomProductDynamicStructures>
            <DynamicStructureLevels>
				<sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='DynamicStructureLevels'">
                    CREATE TABLE [DynamicStructureLevels](
	                    [DynamicStructureLevelId] [INT] IDENTITY(1,1) NOT NULL,
	                    [DynamicStructureLevelStructureId] [NVARCHAR](50) NOT NULL DEFAULT '',
	                    [DynamicStructureLevelField] [NVARCHAR](255) NULL,
                        [DynamicStructureLevelSortDirection] INT NOT NULL DEFAULT 0,
                        [DynamicStructureLevelIndex] INT NOT NULL DEFAULT 0,
	                    CONSTRAINT [PK_DynamicStructureLevels] PRIMARY KEY CLUSTERED ([DynamicStructureLevelId] ASC)
                    );
				</sql>                
                <sql conditional="SELECT COUNT(*)-1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='DynamicStructures' AND COLUMN_NAME='DynamicStructureField1'">                    
                    INSERT INTO DynamicStructureLevels ([DynamicStructureLevelStructureId], [DynamicStructureLevelField], [DynamicStructureLevelSortDirection], [DynamicStructureLevelIndex])
                    SELECT [DynamicStructureUniqueId], [DynamicStructureField1], [DynamicStructureSortDirection1], 1 from [DynamicStructures] where [DynamicStructureField1] &lt;&gt; ''
                    UNION ALL
                    SELECT [DynamicStructureUniqueId], [DynamicStructureField2], [DynamicStructureSortDirection2], 2 from [DynamicStructures] where [DynamicStructureField2] &lt;&gt; ''
                    UNION ALL
                    SELECT [DynamicStructureUniqueId], [DynamicStructureField3], [DynamicStructureSortDirection3], 3 from [DynamicStructures] where [DynamicStructureField3] &lt;&gt; ''
                    UNION ALL
                    SELECT [DynamicStructureUniqueId], [DynamicStructureField4], [DynamicStructureSortDirection4], 4 from [DynamicStructures] where [DynamicStructureField4] &lt;&gt; ''
                    UNION ALL
                    SELECT [DynamicStructureUniqueId], [DynamicStructureField5], [DynamicStructureSortDirection5], 5 from [DynamicStructures] where [DynamicStructureField5] &lt;&gt; ''
                </sql>
            </DynamicStructureLevels>
        </database>
    </package>

    <package version="2114" releasedate="25-02-2019">
        <database file="Ecom.mdb">
            <EcomFieldDisplayGroups>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomFieldDisplayGroups' AND COLUMN_NAME='FieldDisplayGroupAvailableInFrontend'">
                    ALTER TABLE [EcomFieldDisplayGroups] ADD [FieldDisplayGroupAvailableInFrontend] BIT NOT NULL DEFAULT 0
                </sql>
            </EcomFieldDisplayGroups>
        </database>
    </package>
  
    <package version="2112" releasedate="11-02-2019">
        <file name="EmbededDibs.html" target="/Files/Templates/eCom7/CheckoutHandler/DibsEasy/Form" source="/Files/Templates/eCom7/CheckoutHandler/DibsEasy/Form" />
        <file name="checkouthandler_error.html" target="/Files/Templates/eCom7/CheckoutHandler/DibsEasy/Error" source="/Files/Templates/eCom7/CheckoutHandler/DibsEasy/Error" />
    </package>

    <package version="2111" date="30-01-2019">
	    <database file="Ecom.mdb">
            <EcomPayments>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomPayments' AND COLUMN_NAME='PaymentActive'">
                    ALTER TABLE [EcomPayments] ADD [PaymentActive] BIT NOT NULL DEFAULT 1
                </sql>
            </EcomPayments>
        </database>
    </package>

    <package version="2110" date="30-01-2019">
	    <database file="Ecom.mdb">
            <EcomShippings>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomShippings' AND COLUMN_NAME='ShippingActive'">
                    ALTER TABLE [EcomShippings] ADD [ShippingActive] BIT NOT NULL DEFAULT 1
                </sql>
            </EcomShippings>
        </database>
    </package>

    <package version="2109" date="28-01-2019">
	    <database file="Ecom.mdb">
            <EcomVoucherLists>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomVoucherLists' AND COLUMN_NAME='VoucherListCreatedDate'">
                    ALTER TABLE [EcomVoucherLists] ADD [VoucherListCreatedDate] DATETIME NULL
                </sql>
            </EcomVoucherLists>
        </database>
    </package>

    <package version="2108" date="28-01-2019">
	    <database file="Ecom.mdb">
            <EcomShippings>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomShippings' AND COLUMN_NAME='ShippingEligibleForFreeShipping'">
                    ALTER TABLE [EcomShippings] ADD [ShippingEligibleForFreeShipping] BIT NOT NULL DEFAULT 0
                </sql>
            </EcomShippings>
        </database>
    </package>

<package version="2107" releasedate="05-11-2018">
        <database file="Ecom.mdb">
            <EcomDiscount>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomDiscount' AND COLUMN_NAME='DiscountCreatedDate'">
                    ALTER TABLE [EcomDiscount] ADD [DiscountCreatedDate] DATETIME NULL
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomDiscount' AND COLUMN_NAME='DiscountUpdatedDate'">
                    ALTER TABLE [EcomDiscount] ADD [DiscountUpdatedDate] DATETIME NULL
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomDiscount' AND COLUMN_NAME='DiscountCreatedBy'">
                    ALTER TABLE [EcomDiscount] ADD [DiscountCreatedBy] INT NULL DEFAULT 0
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomDiscount' AND COLUMN_NAME='DiscountUpdatedBy'">
                    ALTER TABLE [EcomDiscount] ADD [DiscountUpdatedBy] INT NULL DEFAULT 0
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomDiscount' AND COLUMN_NAME='DiscountOnlyApplyToNonDiscountedItems'">
                    ALTER TABLE [EcomDiscount] ADD [DiscountOnlyApplyToNonDiscountedItems] BIT NULL DEFAULT 0
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomDiscount' AND COLUMN_NAME='DiscountStopFurtherProcessing'">
                    ALTER TABLE [EcomDiscount] ADD [DiscountStopFurtherProcessing] BIT NULL DEFAULT 0
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomDiscount' AND COLUMN_NAME='DiscountAddFreeShipping'">
                    ALTER TABLE [EcomDiscount] ADD [DiscountAddFreeShipping] BIT NULL DEFAULT 0
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomDiscount' AND COLUMN_NAME='DiscountUsePerCustomer'">
                    ALTER TABLE [EcomDiscount] ADD [DiscountUsePerCustomer] INT NULL DEFAULT 0
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomDiscount' AND COLUMN_NAME='DiscountPriority'">
                    ALTER TABLE [EcomDiscount] ADD [DiscountPriority] INT NULL DEFAULT 0
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomDiscount' AND COLUMN_NAME='DiscountMaximumLimits'">
                    ALTER TABLE [EcomDiscount] ADD [DiscountMaximumLimits] [nvarchar](max) NULL
                </sql>
            </EcomDiscount>
        </database>
    </package>

    <package version="2106" date="21-01-2019">
	    <database file="Ecom.mdb">
            <EcomShippings>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomShippings' AND COLUMN_NAME='ShippingTakeDiscountIntoAccount'">
                    ALTER TABLE [EcomShippings] ADD [ShippingTakeDiscountIntoAccount] BIT NOT NULL DEFAULT 0
                </sql>
            </EcomShippings>
        </database>
    </package>

    <package version="2105" releasedate="07-01-2019">
        <database file="Ecom.mdb">
            <EcomFieldDisplayGroups>
				<sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomFieldDisplayGroupTranslation'">
                    CREATE TABLE [EcomFieldDisplayGroupTranslation](
	                    [FieldDisplayGroupTranslationGroupId] [int] NOT NULL,
	                    [FieldDisplayGroupTranslationLanguageId] [nvarchar](50) NOT NULL,
	                    [FieldDisplayGroupTranslationText] [nvarchar](255) NULL,
	                    CONSTRAINT [PK_EcomFieldDisplayGroupTranslation] PRIMARY KEY CLUSTERED ([FieldDisplayGroupTranslationGroupId] ASC, [FieldDisplayGroupTranslationLanguageId] ASC)
                    )
				</sql>
            </EcomFieldDisplayGroups>
        </database>
    </package>

    <package version="2104" releasedate="04-01-2019">
        <database file="Ecom.mdb">
            <EcomFieldDisplayGroups>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomFieldDisplayGroups' AND COLUMN_NAME='FieldDisplayGroupShopIds'">
                    ALTER TABLE [EcomFieldDisplayGroups] ADD [FieldDisplayGroupShopIds] NVARCHAR(MAX) NULL   
                </sql>
            </EcomFieldDisplayGroups>
        </database>
    </package>  

    <package version="2103" releasedate="04-01-2019">
       <database file="Ecom.mdb">
            <Ecom7Tree>
                 <sql conditional="SELECT COUNT(*) FROM Ecom7Tree WHERE TreeChildPopulate = 'FIELDDISPLAYGROUPS'">
                    INSERT INTO Ecom7Tree (ParentId, [Text], Alt, TreeIcon, TreeIconOpen, TreeUrl, TreeChildPopulate, TreeSort, TreeHasAccessModuleSystemName) 
                    VALUES (93, 'Field display groups', 7, 'tree/btn_properties.png', NULL, '/Admin/Module/eCom_Catalog/dw7/FieldDisplayGroups/FieldDisplayGroupList.aspx', 'FIELDDISPLAYGROUPS', 122, NULL)
                </sql>
            </Ecom7Tree>
        </database>
    </package>



    <package version="2102" releasedate="04-12-2018">
        <file name="OrderNotificationTemplate.html" target="/Files/Templates/Economic/Notifications" source="Files/Templates/Economic/Notifications" />        
    </package>

    <package version="2101" releasedate="29-11-2018">
        <database file="Ecom.mdb">
            <EcomShops>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomShops' AND COLUMN_NAME='ShopCompletionLanguageIds'">
                    ALTER TABLE [EcomShops] ADD [ShopCompletionLanguageIds] NVARCHAR(MAX) NULL   
                </sql>
            </EcomShops>
        </database>
    </package>  

    <package version="2100" releasedate="01-11-2018">
        <database file="Ecom.mdb">
            <EcomProductDynamicStructures>
				<sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomProductDynamicStructures'">
                    CREATE TABLE [EcomProductDynamicStructures](
	                    [DynamicStructureId] [INT] IDENTITY(1,1) NOT NULL,
	                    [DynamicStructureTitle] [NVARCHAR](255) NULL,
	                    [DynamicStructureQueryId] [NVARCHAR](36) NULL,
	                    [DynamicStructureField1] [NVARCHAR](255) NULL,
                        [DynamicStructureSortDirection1] INT NOT NULL DEFAULT 0,
	                    [DynamicStructureField2] [NVARCHAR](255) NULL,
                        [DynamicStructureSortDirection2] INT NOT NULL DEFAULT 0,
	                    [DynamicStructureField3] [NVARCHAR](255) NULL,
                        [DynamicStructureSortDirection3] INT NOT NULL DEFAULT 0,
	                    [DynamicStructureField4] [NVARCHAR](255) NULL,
                        [DynamicStructureSortDirection4] INT NOT NULL DEFAULT 0,
	                    [DynamicStructureField5] [NVARCHAR](255) NULL,
                        [DynamicStructureSortDirection5] INT NOT NULL DEFAULT 0,
	                    CONSTRAINT [PK_EcomProductDynamicStructures] PRIMARY KEY CLUSTERED ([DynamicStructureId] ASC)
                    )
				</sql>
            </EcomProductDynamicStructures>
        </database>
    </package>

    <package version="2099" releasedate="05-10-2018">
        <database file="Ecom.mdb">
            <EcomFeed>
                <sql conditional="">
                    ALTER TABLE [EcomFeed] ADD [FeedShopIds] NVARCHAR(MAX) NULL   
                </sql>
            </EcomFeed>
        </database>
    </package>  

    <package version="2098" releasedate="27-09-2018">
        <database file="Ecom.mdb">
            <EcomFieldDisplayGroups>
				<sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomFieldDisplayGroups'">
                    CREATE TABLE [EcomFieldDisplayGroups](
	                    [FieldDisplayGroupId] [INT] IDENTITY(1,1) NOT NULL,
	                    [FieldDisplayGroupName] [NVARCHAR](255) NULL,
	                    [FieldDisplayGroupFieldIds] [NVARCHAR](MAX) NULL,
                        [FieldDisplayGroupSortIndex] INT NOT NULL DEFAULT 0,
	                    CONSTRAINT [PK_EcomFieldDisplayGroups] PRIMARY KEY CLUSTERED ([FieldDisplayGroupId] ASC)
                    )
				</sql>
            </EcomFieldDisplayGroups>
        </database>
    </package>

    <package version="2097" releasedate="21-09-2018">
        <database file="Ecom.mdb">
            <EcomCompletionRules>
				<sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomCompletionRules'">
                    CREATE TABLE [EcomCompletionRules](
	                    [EcomCompletionRuleId] [int] IDENTITY(1,1) NOT NULL,
	                    [EcomCompletionRuleName] [nvarchar](255) NOT NULL,
	                    [EcomCompletionRuleDescription] [nvarchar](MAX) NULL,
	                    [EcomCompletionRuleProductFields] [nvarchar](MAX) NULL,
	                    CONSTRAINT [PK_EcomCompletionRules] PRIMARY KEY CLUSTERED ([EcomCompletionRuleId] ASC)
                    )
				</sql>
            </EcomCompletionRules>
            <EcomShops>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomShops' AND COLUMN_NAME='ShopCompletionRules'">
                    ALTER TABLE [EcomShops] ADD [ShopCompletionRules] NVARCHAR(MAX) NULL
                </sql>
            </EcomShops>
        </database>
    </package>    

    <package version="2096" releasedate="21-09-2018">
        <database file="Ecom.mdb">
            <EcomFeed>
                <sql conditional="">
                    ALTER TABLE [EcomFeed] ADD [FeedParentId] [INT] NULL   
                    ALTER TABLE [EcomFeed] ADD [FeedIsFolder] [BIT] NULL
                </sql>
            </EcomFeed>
        </database>
    </package>  
    
    <package version="2095" date="07-09-2018">
        <file name="Dynamicweb CSV.cshtml" source="/Files/Templates/Feeds" target="/Files/Templates/Feeds/"  overwrite="false"/>
        <file name="Dynamicweb Xml.cshtml" source="/Files/Templates/Feeds" target="/Files/Templates/Feeds/"  overwrite="false"/>
    </package>  

    <package version="2094" date="21-08-2018">
        <file name="Json.cshtml" source="/Files/Templates/Feeds" target="/Files/Templates/Feeds/"  overwrite="false"/>
    </package>

    <package version="2093" releasedate="15-08-2018">
        <database file="Ecom.mdb">
            <EcomFeed>
                <sql conditional="">
                    ALTER TABLE [EcomFeed] ADD [FeedLanguageIds] NVARCHAR(MAX) NULL   
                    ALTER TABLE [EcomFeed] ADD [FeedCurrencyCodes] NVARCHAR(MAX) NULL
                    ALTER TABLE [EcomFeed] DROP [FeedLanguageId]
                    ALTER TABLE [EcomFeed] DROP [FeedCurrencyCode]
                    ALTER TABLE [EcomFeed] DROP [FeedFormatId]
                    ALTER TABLE [EcomFeed] DROP [FeedSelectedFields]
                    ALTER TABLE [EcomFeed] DROP [FeedRelations]
                </sql>
            </EcomFeed>
        </database>
    </package>  

     <package version="2092" releasedate="14-08-2018">
        <database file="Ecom.mdb">
            <EcomFeed>
                <sql conditional="">
                    ALTER TABLE [EcomFeed] ADD [FeedProvider] NVARCHAR(255) NULL   
                    ALTER TABLE [EcomFeed] ADD [FeedProviderConfiguration] NVARCHAR(MAX) NULL  
                </sql>
            </EcomFeed>
        </database>
    </package>  

    <package version="2091" releasedate="14-08-2018">
        <database file="Ecom.mdb">
            <Module>
                <sql conditional="">
                    UPDATE [Module] SET [ModuleEcomNotInstalledAccess] = 0 WHERE [ModuleSystemName] = 'eCom_ProductCatalog'
                </sql>
            </Module>
        </database>
    </package>

     <package version="2090" releasedate="08-05-2018">
        <database file="Ecom.mdb">
            <EcomFieldType>
                <sql conditional="">
                    ALTER TABLE [EcomFieldType] ADD [FieldTypeProvider] NVARCHAR(255) NULL   
                    ALTER TABLE [EcomFieldType] ADD [FieldTypeProviderConfiguration] NVARCHAR(MAX) NULL  
                </sql>
            </EcomFieldType>
        </database>
    </package>

    <package version="2089" releasedate="15-06-2018">
        <database file="Ecom.mdb">
            <EcomProductGroupField>
                <sql conditional="">
                    ALTER TABLE [EcomProductGroupField] ADD [ProductGroupFieldDescription] [nvarchar](MAX) NULL                    
                </sql>
            </EcomProductGroupField>
        </database>
    </package>

    <package version="2088" releasedate="12-06-2018">
        <database file="Ecom.mdb">
            <EcomNumbers>
                <sql conditional="">
                    IF NOT EXISTS( SELECT [ISOCode2] FROM [EcomGlobalISO] WHERE ( ISOCode2 = 'ME' ) )
	                    INSERT INTO EcomGlobalISO ( 
       [ISOCode2]
      ,[ISOCode3]
      ,[ISOCountryNameDK]
      ,[ISOCountryNameUK]
      ,[ISOCurrencyDK]
      ,[ISOCurrencyUK]
      ,[ISOCurrencyCode]
      ,[ISOCurrencyCodeOld]
      ,[ISOCurrencySymbol]
       )
	                    VALUES ( 'ME', 'MNE', 'Montenegro', 'Montenegro', 'Euro', '', '978', '40', 'EUR' )
                </sql>
            </EcomNumbers>
        </database>
    </package>

    <package version="2087" releasedate="07-06-2018">
        <database file="Ecom.mdb">
            <EcomFeed>
				<sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomFeed'">
                    CREATE TABLE [EcomFeed](
	                    [FeedId] [INT] IDENTITY(1,1) NOT NULL,
	                    [FeedName] [NVARCHAR](255) NULL,
	                    [FeedSource] [INT] NULL,
	                    [FeedChannelId] [NVARCHAR](255) NULL,
	                    [FeedProductsAndGroups] [NVARCHAR](MAX) NULL,
	                    [FeedIncludeSubroups] [BIT] NULL,
	                    [FeedIndexQueryId] [NVARCHAR](36) NULL,
	                    [FeedIndexQueryParameters] [NVARCHAR](MAX) NULL,
	                    [FeedIndexQuerySorting] [NVARCHAR](MAX) NULL,
	                    [FeedLanguageId] [NVARCHAR](50) NULL,
	                    [FeedCurrencyCode] [NVARCHAR](3) NULL,
	                    [FeedFormatId] [INT] NULL,
	                    [FeedSelectedFields] [NVARCHAR](MAX) NULL,
	                    [FeedRelations] [INT] NULL,
	                    CONSTRAINT [PK_EcomFeed] PRIMARY KEY CLUSTERED ([FeedId] ASC)
                    )
				</sql>
            </EcomFeed>
        </database>
    </package>
    
    <package version="2086" releasedate="21-05-2018">
        <database file="Ecom.mdb">
            <EcomDetails>
				<sql conditional="">
                    ALTER TABLE [EcomDetails] ADD [DetailsGroupId] int NULL
				</sql>
            </EcomDetails>
        </database>
    </package>

    <package version="2085" releasedate="21-05-2018">
        <database file="Ecom.mdb">
            <EcomProductFieldTranslation>
                <sql conditional="">
                    ALTER TABLE [EcomProductFieldTranslation] ADD [ProductFieldTranslationDescription] [nvarchar](MAX) NULL                    
                </sql>
            </EcomProductFieldTranslation>
            <EcomProductCategoryFieldTranslation>
                <sql conditional="">
                    ALTER TABLE [EcomProductCategoryFieldTranslation] ADD [FieldTranslationDescription] [nvarchar](MAX) NULL                    
                </sql>
            </EcomProductCategoryFieldTranslation>
        </database>
    </package>
    
    <package version="2084" releasedate="18-05-2018">
        <database file="Ecom.mdb">
            <DetailsGroup>
				<sql conditional="">
                    DROP TABLE [EcomDetailsGroupText]
				</sql>
				<sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomDetailsGroupTranslation'">
                    CREATE TABLE [EcomDetailsGroupTranslation](
	                    [DetailsGroupTranslationGroupId] [int] NOT NULL,
	                    [DetailsGroupTranslationLanguageId] [nvarchar](50) NOT NULL,
	                    [DetailsGroupTranslationText] [nvarchar](255) NULL,
	                    CONSTRAINT [PK_EcomDetailsGroupTranslation] PRIMARY KEY CLUSTERED ([DetailsGroupTranslationGroupId] ASC, [DetailsGroupTranslationLanguageId] ASC)
                    )
				</sql>
            </DetailsGroup>
        </database>
    </package>

    <package version="2083" releasedate="28-04-2018">
        <database file="Ecom.mdb">
            <DetailsGroup>
				<sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomDetailsGroup'">
                    CREATE TABLE [EcomDetailsGroup](
	                    [EcomDetailsGroupId] [int] IDENTITY(1,1) NOT NULL,
	                    [EcomDetailsGroupSystemName] [nvarchar](255) NOT NULL,
	                    [DetailsGroupInheritanceType] [int] NULL,
	                    [DetailsGroupIcon] [int] NULL,
                        [DetailsGroupIconColor] [int] NULL,
	                    CONSTRAINT [PK_EcomDetailsGroup] PRIMARY KEY CLUSTERED ([EcomDetailsGroupId] ASC)
                    )
				</sql>
				<sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomDetailsGroupText'">
                    CREATE TABLE [EcomDetailsGroupText](
	                    [DetailsGroupTextGroupId] [int] NOT NULL,
	                    [DetailsGroupTextLanguageId] [nvarchar](50) NOT NULL,
	                    [DetailsGroupTextText] [nvarchar](255) NULL,
	                    CONSTRAINT [PK_EcomDetailsGroupText] PRIMARY KEY CLUSTERED ([DetailsGroupTextGroupId] ASC, [DetailsGroupTextLanguageId] ASC)
                    )
				</sql>
            </DetailsGroup>
        </database>
    </package>

    <package version="2082" releasedate="26-04-2018">
        <database file="Ecom.mdb">
            <Ecom7Tree>
                <sql conditional="SELECT COUNT(*) FROM Ecom7Tree WHERE TreeChildPopulate = 'FIELDTYPES'">
                    INSERT INTO Ecom7Tree (ParentId, [Text], Alt, TreeIcon, TreeIconOpen, TreeUrl, TreeChildPopulate, TreeSort, TreeHasAccessModuleSystemName) 
                    VALUES(93, 'Field types', 7, 'tree/btn_properties.png', NULL, 'Lists/EcomFieldTypes_List.aspx', 'FIELDTYPES', 121, NULL)
                </sql>
            </Ecom7Tree>
        </database>
    </package>
    
    <package version="2081" releasedate="19-04-2018">
        <database file="Ecom.mdb">
            <EcomProducts>
                <sql conditional="">
                    ALTER TABLE [EcomDetails] ADD [DetailIsDefault] BIT NOT NULL DEFAULT 0    
                </sql>
            </EcomProducts>
        </database>
    </package>
    
    <package version="2080" releasedate="24-03-2018">
        <database file="Dynamic.mdb">
            <EcomGroups>
                <sql conditional="">
                    ALTER TABLE [EcomShops] ADD [ShopType] INT NOT NULL DEFAULT 1                 
                </sql>
                <sql conditional="">
                    UPDATE [EcomShops] SET [ShopType] = 2 WHERE [ShopType] = 1 AND [ShopProductWarehouse] = 1               
                </sql>
            </EcomGroups>
        </database>
    </package>
    
    <package version="2079" releasedate="24-03-2018">
        <database file="Dynamic.mdb">
            <EcomGroups>
                <sql conditional="">
                    ALTER TABLE [EcomGroups] ADD [GroupWorkflowId] INT NOT NULL DEFAULT 0
                </sql>
            </EcomGroups>
        </database>
    </package>

    <package version="2078" releasedate="23-03-2018">
        <database file="Ecom.mdb">
            <SystemField>
                <sql conditional="">
                    UPDATE [SystemField]
                    SET [SystemFieldOptions] = REPLACE([SystemFieldOptions], '&lt;Option Key="Religious or educational org"&gt;F&lt;/Option&gt;', '&lt;Option Key="Religious org"&gt;F&lt;/Option&gt;&lt;Option Key="Educational org"&gt;M&lt;/Option&gt;')
                    WHERE [SystemFieldSystemName] = 'EntityUseCode' AND [SystemFieldTableName] = 'AccessUser' AND [SystemFieldOptions] LIKE '%&lt;Option Key="Religious or educational org"&gt;F&lt;/Option&gt;%'
                </sql>
            </SystemField>
        </database>
    </package>

    <package version="2077" releasedate="12-02-2018">
        <database file="Ecom.mdb">
            <EcomGroupProductRelation>
                <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_EcomGroupProductRelation_ProductId] ON [EcomGroupProductRelation] ([GroupProductRelationProductId])
                </sql>
            </EcomGroupProductRelation>
        </database>
    </package>

    <package version="2076" releasedate="06-02-2018">
        <database file="Ecom.mdb">
            <EcomOrders>
                <sql conditional="">
                    ALTER TABLE [EcomProductsRelated] DROP CONSTRAINT [DW_PK_EcomProductsRelated];
                    ALTER TABLE [EcomProductsRelated] ADD CONSTRAINT [DW_PK_EcomProductsRelated] PRIMARY KEY NONCLUSTERED ([ProductRelatedProductID], [ProductRelatedProductRelID], [ProductRelatedGroupID], [ProductRelatedProductRelVariantID]);
                </sql>
            </EcomOrders>
        </database>
    </package> 

    <package version="2075" releasedate="30-01-2018">
        <database file="Ecom.mdb">
            <ScheduledTask>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='ScheduledTask' AND COLUMN_NAME='TaskStartFromLastRun'">
                    ALTER TABLE [ScheduledTask] ADD [TaskStartFromLastRun] BIT NOT NULL DEFAULT 0
                </sql>
            </ScheduledTask>
        </database>
    </package>

    <package version="2074" releasedate="23-01-2018">
        <invoke type="Dynamicweb.Content.Management.UpdateScripts, Dynamicweb" method="FixBrokenGiftCardCodes" />
    </package>

    <package version="2073" releasedate="22-01-2018">
        <database file="Ecom.mdb">
            <EcomGroups>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomVariantGroups' AND COLUMN_NAME='VariantGroupFamily'">
                    ALTER TABLE [EcomVariantGroups] ADD [VariantGroupFamily] [BIT] NOT NULL DEFAULT(0)
                </sql>
            </EcomGroups>
        </database>
    </package>

    <package version="2072" releasedate="16-01-2016">
        <database file="Ecom.mdb">
            <EcomGroups>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomGroups' AND COLUMN_NAME='GroupMetaUrlIgnoreParent'">
                    ALTER TABLE [EcomGroups] ADD [GroupMetaUrlIgnoreParent] [BIT] NOT NULL DEFAULT(0)
                </sql>
            </EcomGroups>
        </database>
    </package>
    
    <package version="2071" releasedate="16-01-2018">
        <database file="Ecom.mdb">
            <EcomShops>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomShops' AND COLUMN_NAME='ShopImageUploadFolder'">
                    ALTER TABLE [EcomShops] ADD [ShopImageUploadFolder] NVARCHAR(255) NULL
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomShops' AND COLUMN_NAME='ShopAutoCreateUploadFolderPerProduct'">
                    ALTER TABLE [EcomShops] ADD [ShopAutoCreateUploadFolderPerProduct] BIT NOT NULL DEFAULT 0
                </sql>
            </EcomShops>
        </database>
    </package>

    <package version="2070" releasedate="15-01-2018">
        <database file="Ecom.mdb">
            <EcomDiscount>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomDiscount' AND COLUMN_NAME='DiscountCampaignName'">
                    ALTER TABLE [EcomDiscount] ADD [DiscountCampaignName] NVARCHAR(255) NULL
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomDiscount' AND COLUMN_NAME='DiscountCampaignImage'">
                    ALTER TABLE [EcomDiscount] ADD [DiscountCampaignImage] [nvarchar](255) NULL
                </sql>
                <sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomDiscount' AND COLUMN_NAME='DiscountCampaignColor'">
                    ALTER TABLE [EcomDiscount] ADD [DiscountCampaignColor] [nvarchar](50) NULL
                </sql>
            </EcomDiscount>
        </database>
    </package>

    
    <package version="2069" releasedate="12-01-2018">
        <database file="Ecom.mdb">
            <Ecom7Tree>
                <sql conditional="SELECT COUNT(*) FROM Ecom7Tree WHERE TreeChildPopulate = 'ORDERDISCOUNTS' AND parentId=94 AND TreeHasAccessModuleSystemName='eCom_DiscountMatrix'">
                    UPDATE Ecom7Tree 
                    SET TreeHasAccessModuleSystemName = 'eCom_DiscountMatrix'
                    WHERE TreeChildPopulate = 'ORDERDISCOUNTS' AND parentId=94
                </sql>
            </Ecom7Tree>
            <Ecom7Tree>
                <sql conditional="SELECT COUNT(*) FROM EcomTree WHERE TreeChildPopulate = 'ORDERDISCOUNTS' AND parentId=1 AND TreeHasAccessModuleSystemName='eCom_DiscountMatrix'">
                    UPDATE EcomTree 
                    SET TreeHasAccessModuleSystemName = 'eCom_DiscountMatrix'
                    WHERE TreeChildPopulate = 'ORDERDISCOUNTS' AND parentId=1
                </sql>
            </Ecom7Tree>
            <Ecom7Tree>
                  <sql conditional="SELECT COUNT(*) FROM EcomTree WHERE TreeChildPopulate = 'VOUCHERS' AND parentId=1 AND TreeHasAccessModuleSystemName='eCom_Vouchers'">
                    UPDATE EcomTree 
                    SET TreeHasAccessModuleSystemName = 'eCom_Vouchers'
                    WHERE TreeChildPopulate = 'VOUCHERS'
                </sql>
            </Ecom7Tree>
            <Ecom7Tree>
                  <sql conditional="SELECT COUNT(*) FROM EcomTree WHERE TreeChildPopulate = 'GIFTCARDS' AND parentId=1 AND TreeHasAccessModuleSystemName='GiftCards'">
                    UPDATE EcomTree 
                    SET TreeHasAccessModuleSystemName = 'GiftCards'
                    WHERE TreeChildPopulate = 'GIFTCARDS'
                </sql>
            </Ecom7Tree>
              <Ecom7Tree>
                  <sql conditional="SELECT COUNT(*) FROM EcomTree WHERE TreeChildPopulate = 'RMAS' AND parentId=1 AND TreeHasAccessModuleSystemName='RMA'">
                    UPDATE EcomTree 
                    SET TreeHasAccessModuleSystemName = 'RMA'
                    WHERE TreeChildPopulate = 'RMAS'
                </sql>
            </Ecom7Tree>
        </database>
    </package> 

    <package version="2068" date="11-01-2018">
        <file name="WorkflowNotificationTemplate.cshtml" source="/Files/Templates/PIM/Workflow notifications" target="/Files/Templates/PIM/Workflow notifications"  overwrite="false"/>
    </package>

    <package version="2067" releasedate="04-01-2018">
        <database file="Ecom.mdb">
            <EcomProductCategoryFieldValue>
                <sql conditional="">
                    ALTER TABLE [EcomProductCategoryFieldValue] ADD [FieldValueSortOrder] INT NOT NULL DEFAULT 0
                </sql>
            </EcomProductCategoryFieldValue>
        </database>
    </package>

    <package version="2066" date="21-12-2017">
        <file name="EmailNotificationTemplate.cshtml" source="/Files/Templates/PIM/Notifications" target="/Files/Templates/PIM/Notifications"  overwrite="false"/>
        <file name="EmailHelpers.cshtml" source="/Files/Templates/PIM/Includes" target="/Files/Templates/PIM/Includes"  overwrite="false"/>    
        <file name="EmailMaster.cshtml" source="/Files/Templates/PIM/Includes" target="/Files/Templates/PIM/Includes"  overwrite="false"/>  
    </package>
    

    <package version="2064" releasedate="12-12-2017">
        <database file="Dynamic.mdb">
            <EcomProducts>
                <sql conditional="">
                    ALTER TABLE [EcomProducts] ADD [ProductWorkflowStateId] INT NOT NULL DEFAULT 0
                </sql>
            </EcomProducts>
        </database>
    </package>

    <package version="2063" releasedate="27-11-2017">
        <database file="Dynamic.mdb">
            <Workflow>
                <sql conditional="">
					ALTER TABLE [Workflow] ADD [WorkflowCreatedDate] DATETIME NULL
                </sql>
			</Workflow>
        </database>
    </package>

    <package version="2062" releasedate="24-11-2017">
        <database file="Ecom.mdb">
            <EcomProductCategory>
                <sql conditional="">
                    ALTER TABLE [EcomProductCategoryField] ADD [FieldHideEmpty] BIT NOT NULL DEFAULT 0
                </sql>
            </EcomProductCategory>
        </database>
    </package>

    <package version="2061" releasedate="24-11-2017">
        <database file="Ecom.mdb">
            <EcomProductCategory>
                <sql conditional="">
                    ALTER TABLE [EcomProductCategory] ADD [CategoryProductProperties] BIT NOT NULL DEFAULT 0
                </sql>
            </EcomProductCategory>
        </database>
    </package>
    
    <package version="2060" releasedate="24-11-2017">
        <database file="Dynamic.mdb">
            <Ecom7Tree>
                <sql conditional="">
                    DELETE FROM Ecom7Tree WHERE TreeChildPopulate = 'PRODUCTMANAGEMENT' AND parentId=94
                </sql>
            </Ecom7Tree>
        </database>
    </package>

    <package version="2059" releasedate="24-11-2017">
        <database file="Dynamic.mdb">
            <Workflow>
				<sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Workflow'">
                    CREATE TABLE [Workflow](
	                    [WorkflowId] [int] IDENTITY(1,1) NOT NULL,
	                    [WorkflowName] [nvarchar](255) NULL,
                        CONSTRAINT [PK_Workflow] PRIMARY KEY CLUSTERED ([WorkflowId] ASC)
                     )                    
				</sql>
				<sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WorkflowNotification'">
                    CREATE TABLE [WorkflowNotification](
	                    [WorkflowNotificationId] [int] IDENTITY(1,1) NOT NULL,
	                    [WorkflowNotificationWorkflowId] [int] NOT NULL,
                        [WorkflowNotificationSubject] [nvarchar](255) NULL,
                        [WorkflowNotificationSender] [nvarchar](255) NULL,
                        [WorkflowNotificationSenderName] [nvarchar](255) NULL,
                        [WorkflowNotificationTemplate] [nvarchar](255) NULL,
                        [WorkflowNotificationUsers] [nvarchar](255) NULL,
                        CONSTRAINT [PK_WorkflowNotification] PRIMARY KEY CLUSTERED ([WorkflowNotificationId] ASC)
                     )                    
				</sql>
				<sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WorkflowState'">
                    CREATE TABLE [WorkflowState](
	                    [WorkflowStateId] [int] IDENTITY(1,1) NOT NULL,
	                    [WorkflowStateWorkflowId] [int] NOT NULL,
                        [WorkflowStateName] [nvarchar](255) NULL,
                        CONSTRAINT [PK_WorkflowState] PRIMARY KEY CLUSTERED ([WorkflowStateId] ASC)
                     )                    
				</sql>
				<sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WorkflowGoToState'">
                    CREATE TABLE [WorkflowGoToState](
	                    [WorkflowGoToStateStateId] [int] NOT NULL,
	                    [WorkflowGoToStateGoToStateId] [int] NOT NULL,
                        CONSTRAINT [PK_WorkflowGoToState] PRIMARY KEY CLUSTERED ([WorkflowGoToStateStateId] ASC, [WorkflowGoToStateGoToStateId] ASC)
                     )
				</sql>
				<sql conditional="SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WorkflowStateNotificationRelation'">
                    CREATE TABLE [WorkflowStateNotificationRelation](
	                    [WorkflowStateNotificationRelationStateId] [int] NOT NULL,
	                    [WorkflowStateNotificationRelationNotificationId] [int] NOT NULL,
                        CONSTRAINT [PK_WorkflowStateNotificationRelation] PRIMARY KEY CLUSTERED ([WorkflowStateNotificationRelationStateId] ASC, [WorkflowStateNotificationRelationNotificationId] ASC)
                     )
				</sql>
			</Workflow>
        </database>
    </package>

    <package version="2058" releasedate="23-11-2017">
        <database file="Dynamic.mdb">
            <EcomProducts>
                <sql conditional="">
                    ALTER TABLE [EcomProducts] ADD [ProductApprovalState] INT NOT NULL DEFAULT 0
                </sql>
            </EcomProducts>
        </database>
    </package>
  
    <package version="2057" releasedate="22-11-2017">
        <database file="Dynamic.mdb">
            <EcomOrderStates>
		        <sql conditional="">
                    ALTER TABLE [EcomOrderStates] ADD [OrderStateAllowEdit] BIT NOT NULL DEFAULT 0
                </sql>
            </EcomOrderStates>
        </database>
    </package>
  
    <package version="2056" releasedate="10-10-2017">
        <file name="EmailError.cshtml" target="/Files/Templates/eCom7/CheckoutHandler/AltaPay/NotifyUser" source="/Files/Templates/eCom7/CheckoutHandler/AltaPay/NotifyUser" />
        <file name="EmailSuccess.cshtml" target="/Files/Templates/eCom7/CheckoutHandler/AltaPay/NotifyUser" source="/Files/Templates/eCom7/CheckoutHandler/AltaPay/NotifyUser" />
        <file name="Open.cshtml" target="/Files/Templates/eCom7/CheckoutHandler/AltaPay/Open" source="/Files/Templates/eCom7/CheckoutHandler/AltaPay/Open" />
    </package>
  
    <package version="2055" releasedate="12-09-2017">
        <file name="Form.cshtml" target="/Files/Templates/eCom7/CheckoutHandler/AltaPay/Form" source="/Files/Templates/eCom7/CheckoutHandler/AltaPay/Form" />
        <file name="Error.cshtml" target="/Files/Templates/eCom7/CheckoutHandler/AltaPay/Error" source="/Files/Templates/eCom7/CheckoutHandler/AltaPay/Error" />
    </package>

    <package version="2054" releasedate="17-08-2017">
    	<database file="Dynamic.mdb">
            <EcomCountries>
                <sql conditional="">
                    IF EXISTS (SELECT * FROM sys.indexes WHERE name = N'DW_IX_EcomCountries_Id')
                        DROP INDEX [DW_IX_EcomCountries_Id] ON [EcomCountries];
                </sql>
                <sql conditional="">
                    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EcomCountries' AND COLUMN_NAME='CountryId')
                        ALTER TABLE [EcomCountries] DROP [CountryId];
                </sql>
            </EcomCountries>
        </database>
    </package> 
      

    
    <package version="2053" releasedate="17-08-2017">
    	<database file="Dynamic.mdb">
            <EcomAddressValidatorSettings>
                <sql conditional="">
                    ALTER TABLE [EcomAddressValidatorSettings] ADD [AddressValidatorUserGroupIds] NVARCHAR(MAX) NULL
                </sql>
            </EcomAddressValidatorSettings>
        </database>
    </package>

    <package version="2052" releasedate="09-08-2017">
        <database file="Ecom.mdb">
            <EcomOrders>
                <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_EcomOrders_Date] ON [EcomOrders] ([OrderDate])
                </sql>
            </EcomOrders>
        </database>
    </package>

    <package version="2051" date="09-08-2017">
        <database file="Ecom.mdb">
            <EcomGlobalISO>
                <sql conditional="">
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'GHS' WHERE ISOID = '75' AND [ISOCode3] = 'GHA' AND [ISOCurrencySymbol] = 'GHC';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'SDG' WHERE ISOID = '196' AND [ISOCode3] = 'SDN' AND [ISOCurrencySymbol] = 'SDP';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'CLP' WHERE ISOID = '42' AND [ISOCode3] = 'CHL' AND [ISOCurrencySymbol] = 'CLF';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'AZN' WHERE ISOID = '15' AND [ISOCode3] = 'AZE' AND [ISOCurrencySymbol] = 'AZM';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'RUB' WHERE ISOID = '172' AND [ISOCode3] = 'RUS' AND [ISOCurrencySymbol] = 'RUR';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'BYN' WHERE ISOID = '20' AND [ISOCode3] = 'BLR' AND [ISOCurrencySymbol] = 'BYR';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'ZMW' WHERE ISOID = '235' AND [ISOCode3] = 'ZMB' AND [ISOCurrencySymbol] = 'ZMK';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'BGN' WHERE ISOID = '34' AND [ISOCode3] = 'BGR' AND [ISOCurrencySymbol] = 'BGL';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'BAM' WHERE ISOID = '27' AND [ISOCode3] = 'BIH' AND [ISOCurrencySymbol] = 'EUR';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'UGX' WHERE ISOID = '217' AND [ISOCode3] = 'UGA' AND [ISOCurrencySymbol] = 'UGS';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'XOF' WHERE ISOID = '208' AND [ISOCode3] = 'TGO' AND [ISOCurrencySymbol] = 'XAF';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'EUR' WHERE ISOID = '51' AND [ISOCode3] = 'CYP' AND [ISOCurrencySymbol] = 'CYP';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'ZAR' WHERE ISOID = '115' AND [ISOCode3] = 'LSO' AND [ISOCurrencySymbol] = 'LSL';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'MGA' WHERE ISOID = '123' AND [ISOCode3] = 'MDG' AND [ISOCurrencySymbol] = 'MGF';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'EUR' WHERE ISOID = '129' AND [ISOCode3] = 'MLT' AND [ISOCurrencySymbol] = 'MTL';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'EUR' WHERE ISOID = '186' AND [ISOCode3] = 'SVN' AND [ISOCurrencySymbol] = 'SIT';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'USD' WHERE ISOID = '234' AND [ISOCode3] = 'ZWE' AND [ISOCurrencySymbol] = 'ZWD';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'PEN' WHERE ISOID = '163' AND [ISOCode3] = 'PER' AND [ISOCurrencySymbol] = 'PEI';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'USD' WHERE ISOID = '57' AND [ISOCode3] = 'SLV' AND [ISOCurrencySymbol] = 'SVC';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'VEF' WHERE ISOID = '229' AND [ISOCode3] = 'VEN' AND [ISOCurrencySymbol] = 'VEB';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'EUR' WHERE ISOID = '60' AND [ISOCode3] = 'EST' AND [ISOCurrencySymbol] = 'EEK';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'XOF' WHERE ISOID = '35' AND [ISOCode3] = 'BFA' AND [ISOCurrencySymbol] = 'BFF';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'XOF' WHERE ISOID = '23' AND [ISOCode3] = 'BEN' AND [ISOCurrencySymbol] = 'XAF';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'XAF' WHERE ISOID = '47' AND [ISOCode3] = 'COG' AND [ISOCurrencySymbol] = 'CDF';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'AOA' WHERE ISOID = '7' AND [ISOCode3] = 'AGO' AND [ISOCurrencySymbol] = 'AON';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'EUR' WHERE ISOID = '120' AND [ISOCode3] = 'LTU' AND [ISOCurrencySymbol] = 'LTL';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'EUR' WHERE ISOID = '114' AND [ISOCode3] = 'LVA' AND [ISOCurrencySymbol] = 'LVL';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'MZN' WHERE ISOID = '143' AND [ISOCode3] = 'MOZ' AND [ISOCurrencySymbol] = 'MZM';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'SRD' WHERE ISOID = '197' AND [ISOCode3] = 'SUR' AND [ISOCurrencySymbol] = 'SRG';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'AFN' WHERE ISOID = '1' AND [ISOCode3] = 'AFG' AND [ISOCurrencySymbol] = 'AFA';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'XOF' WHERE ISOID = '84' AND [ISOCode3] = 'GNB' AND [ISOCurrencySymbol] = 'GWP';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'RON' WHERE ISOID = '171' AND [ISOCode3] = 'ROU' AND [ISOCurrencySymbol] = 'ROL';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'EUR' WHERE ISOID = '185' AND [ISOCode3] = 'SVK' AND [ISOCurrencySymbol] = 'SKK';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'TJS' WHERE ISOID = '205' AND [ISOCode3] = 'TJK' AND [ISOCurrencySymbol] = 'TJR';
                    UPDATE EcomGlobalISO SET [ISOCurrencySymbol] = 'TMT' WHERE ISOID = '214' AND [ISOCode3] = 'TKM' AND [ISOCurrencySymbol] = 'TMM';
                </sql>
            </EcomGlobalISO>
        </database>
    </package>

    <package version="2050" releasedate="04-08-2017">
        <database file="Ecom.mdb">
            <EcomShops>
                <sql conditional="">
                    ALTER TABLE [EcomOrders] ADD [OrderReturnOperations] NVARCHAR(MAX) NULL
                </sql>
            </EcomShops>
        </database>
    </package>

    <package version="2049" date="14-07-2017">
        <file name="EmailNotificationTemplate.html" source="/Files/Templates/PIM/Notifications" target="/Files/Templates/PIM/Notifications"  overwrite="false"/>        
    </package>

    <package version="2048" releasedate="11-07-2017">
        <setting key="/Globalsettings/Ecom/ProductLanguageControl/Language/ProductUpdated" value="True" overwrite="false" />
        <setting key="/Globalsettings/Ecom/ProductLanguageControl/Variant/ProductUpdated" value="True" overwrite="false" />
    </package>

    <package version="2047" releasedate="10-07-2017">
        <database file="Ecom.mdb">
            <EcomPIMNotifications>
                <sql conditional="">
                    CREATE TABLE EcomPIMNotifications
                    (
                        NotificationId INT NOT NULL IDENTITY(1,1),
                        NotificationTitle NVARCHAR(255) NULL,
                        NotificationSubject NVARCHAR(255) NULL,
                        NotificationRecipients NVARCHAR(255) NULL,
                        NotificationRecipientGroups NVARCHAR(255) NULL,
                        NotificationQueryId NVARCHAR(255) NULL,
                        NotificationMaxItems INT NOT NULL,
                        NotificationRule NVARCHAR(50) NOT NULL,
                        NotificationRuleItemsCount INT NULL,
                        NotificationTemplate NVARCHAR(255) NULL,
                        NotificationPlaceholder1 NVARCHAR(255) NULL,
                        NotificationPlaceholder2 NVARCHAR(255) NULL,
                        NotificationPlaceholder3 NVARCHAR(255) NULL,
                        NotificationPlaceholder4 NVARCHAR(255) NULL,
                        NotificationPlaceholder5 NVARCHAR(255) NULL,
                        NotificationCreated DATETIME NOT NULL,
                        NotificationSentTime DATETIME NULL,
                        CONSTRAINT DW_PK_EcomPIMNotifications PRIMARY KEY CLUSTERED (NotificationId)
                    )
                </sql>
            </EcomPIMNotifications>
        </database>
    </package>

    <package version="2046" releasedate="05-07-2017">
        <database file="Ecom.mdb">
            <EcomShops>
                <sql conditional="">
                    ALTER TABLE [EcomShops] ADD [ShopImageSearchInSubFolders] [BIT] NOT NULL DEFAULT 0
                </sql>
            </EcomShops>
        </database>
    </package>
    
    <package version="2045" releasedate="23-06-2017">
        <database file="Ecom.mdb">
            <EcomOrderDiscount>
                <sql conditional="">
                    ALTER TABLE [EcomDiscount] ADD [DiscountApplyToProduct] INT NOT NULL CONSTRAINT DW_DF_EcomDiscount_ApplyToProduct DEFAULT(1)
                </sql>
            </EcomOrderDiscount>
        </database>
    </package>

    <package version="2044" releasedate="21-06-2017">
        <database file="Ecom.mdb">
            <EcomGroups>
                <sql conditional="">
                    ALTER TABLE [EcomGroups] ADD [GroupInheritCategoryFieldsFromParent] [BIT] NOT NULL CONSTRAINT [EcomGroups_GroupInheritCategoryFieldsFromParent] DEFAULT(0)
                </sql>
            </EcomGroups>
        </database>
    </package>

    <package version="2043" releasedate="20-06-2017">
        <database file="Ecom.mdb">
            <EcomShops>
                <sql conditional="">
                    ALTER TABLE [EcomShops] ADD [ShopAutoBuildIndex] [BIT] NOT NULL CONSTRAINT [EcomShops_ShopAutoBuildIndex] DEFAULT(0)
                </sql>
                <sql conditional="">
                    ALTER TABLE [EcomShops] ADD [ShopIndexRepository] [nvarchar](128) NULL, [ShopIndexName] [nvarchar](128) NULL
                </sql>
            </EcomShops>
        </database>
    </package>    
    
    <package version="2042" releasedate="31-05-2017">
        <database file="Ecom.mdb">
            <EcomProducts>
                <sql conditional="">
                    ALTER TABLE [EcomProducts] ADD [ProductShowInProductList] [BIT] NOT NULL CONSTRAINT [EcomProducts_ProductShowInProductList] DEFAULT(0)
                </sql>
            </EcomProducts>
        </database>
    </package>

    <package version="2041" releasedate="25-05-2017">
        <database file="Ecom.mdb">
            <EcomShops>
                <sql conditional="">
                    ALTER TABLE [EcomShops] ADD [ShopProductPrimaryPageId] [INT] NULL
                </sql>
            </EcomShops>
        </database>
    </package>
        
    <package version="2040" date="24-05-2017">
    </package>

    <package version="2039" releasedate="04-05-2017">
        <database file="Ecom.mdb">
            <EcomShops>
                <sql conditional="">
                    ALTER TABLE [EcomShops] ADD [ShopProductWarehouse] [BIT] NOT NULL CONSTRAINT [EcomShops_DefaultShopProductWarehouse] DEFAULT(0)
                </sql>
            </EcomShops>
        </database>
    </package>

    <package version="2038" releasedate="28-04-2017">
        <database file="Ecom.mdb" >
            <EcomRmaEmailConfigurations>
                <sql conditional="">
                    ALTER TABLE [EcomRmaEmailConfigurations] ADD [RmaEmailConfigurationSenderNameForCustomer] [BIT] NOT NULL CONSTRAINT [EcomRmaEmailConfigurations_DefaultRmaEmailConfigurationSenderNameForCustomer] DEFAULT(0)
                </sql>
            </EcomRmaEmailConfigurations>
        </database>
    </package>
    
    <package version="2036" releasedate="24-04-2017">
        <database file="Ecom.mdb" >
            <EcomRmaEmailConfigurations>
                <sql conditional="">
                    ALTER TABLE [EcomRmaEmailConfigurations] ADD [RmaEmailConfigurationSenderEmailForCustomer] [BIT] NOT NULL CONSTRAINT [EcomRmaEmailConfigurations_DefaultRmaEmailConfigurationSenderEmailForCustomer] DEFAULT(0)
                </sql>
            </EcomRmaEmailConfigurations>
        </database>
    </package>

     <package version="2035" releasedate="05-04-2017">
        <database file="Ecom.mdb" >
            <Ecom7Tree>
                <sql conditional="">
                    DELETE FROM [EcomTree] WHERE [TreeHasAccessModuleSystemName] = 'eCom_PCM' OR [TreeChildPopulate] = 'PRODUCTMANAGEMENT';
                </sql>
                <sql conditional="">
                    DELETE FROM [EcomTree] WHERE [TreeChildPopulate] = 'DASHBOARD' AND [Id] NOT IN (SELECT MAX([Id]) FROM [EcomTree] GROUP BY [TreeChildPopulate])
                </sql>
            </Ecom7Tree>
        </database>
    </package>

     <package version="2034" releasedate="21-03-2017">
        <database file="Ecom.mdb" >
            <Ecom7Tree>
                <sql conditional="SELECT COUNT(*) FROM EcomTree WHERE TreeChildPopulate = 'DASHBOARD'">
                    UPDATE EcomTree SET TreeSort = TreeSort + 1 WHERE parentId = 1;
                    INSERT INTO EcomTree (parentId, Text, Alt, TreeIcon, TreeIconOpen, TreeUrl, TreeChildPopulate, TreeSort, TreeHasAccessModuleSystemName) VALUES(1, 'Dashboard', NULL, 'tree/btn_stats.png', NULL, '/Admin/module/eCom_Catalog/dw7/dashboard.aspx', 'DASHBOARD', 1, 'eCom_Dashboard');
                </sql>
            </Ecom7Tree>
        </database>
    </package>

     <package version="2033" releasedate="20-03-2017">
        <database file="Ecom.mdb" >
            <Ecom7Tree>
                <sql conditional="">
                    UPDATE Ecom7Tree
                    SET Text = 'PIM'
                    WHERE TreeChildPopulate = 'PRODUCTMANAGEMENT'
                </sql>
            </Ecom7Tree>
        </database>
    </package>

          <package version="2032" releasedate="20-03-2017">
        <database file="Ecom.mdb">
            <AccessUserCard>
		        <sql conditional="">
                    Update [Module]
                    SET ModuleName = 'PIM'
                    WHERE ModuleSystemName = 'eCom_PCM'
		        </sql>
	        </AccessUserCard>
            <EcomTree>
                <sql conditional="">
                    UPDATE EcomTree
                    SET Text = 'PIM'
                    WHERE TreeChildPopulate = 'PRODUCTMANAGEMENT'
                </sql>
            </EcomTree>
        </database>
    </package>

    <package version="2031" date="15-03-2017">
	    <database file="Ecom.mdb">
	        <EcomLanguages>
		        <sql conditional="SELECT COUNT(*) FROM [dbo].[EcomLanguages] WHERE [LanguageIsDefault] = 1">
                  UPDATE [EcomLanguages] SET [LanguageIsDefault] = 1
                  WHERE [LanguageId] = (SELECT TOP 1 [LanguageId] FROM [EcomLanguages])
                </sql>
            </EcomLanguages>
	    </database>
      </package>

    <package version="2030" date="07-03-2017">
        <database file="Ecom.mdb">
            <Ecom7Tree>
                <sql conditional="SELECT COUNT(*) FROM [dbo].[Ecom7Tree] WHERE [TreeHasAccessModuleSystemName] = 'eCom_Assortments' OR [TreeChildPopulate] = 'ASSORTMENTS' HAVING COUNT(*) = 1">
                    DELETE FROM Ecom7Tree WHERE [TreeHasAccessModuleSystemName] = 'eCom_Assortments' OR [TreeChildPopulate] = 'ASSORTMENTS';

                    INSERT INTO [Ecom7Tree] ([ParentId], [Text], [Alt], [TreeIcon], [TreeUrl], [TreeChildPopulate], [TreeSort], [TreeHasAccessModuleSystemName])
                    VALUES (94, 'Assortments', NULL, 
                        '/Admin/Images/eCom/Module_eCom_Assortments_small.gif', 
                        '/Admin/Module/eCom_Catalog/dw7/edit/EcomAdvConfigAssortments_Edit.aspx', 
                        'ASSORTMENTS', 75, 'eCom_Assortments');
                </sql>
            </Ecom7Tree>
        </database>
    </package>

    <package version="2029" date="20-02-2017" RunOnce="True">
        <database file="Ecom.mdb">
            <EcomOrderDebuggingInfo>
                <sql conditional="">
                    ALTER TABLE [EcomOrderDebuggingInfo] ADD [OrderDebuggingInfoOrderAutoId] INT
                </sql>
                <sql conditional="">
                    UPDATE od
                    SET od.[OrderDebuggingInfoOrderAutoId] = o.[OrderAutoId]
                    FROM [EcomOrderDebuggingInfo] od 
                    JOIN [EcomOrders] o ON od.[OrderDebuggingInfoOrderId] = o.[OrderId]
                </sql>
                <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_OrderDebuggingInfo_OrderAutoId] ON [EcomOrderDebuggingInfo] ([OrderDebuggingInfoOrderAutoId] ASC)  
                </sql>
            </EcomOrderDebuggingInfo>
        </database>
    </package>

    <package version="2028" date="17-02-2017" RunOnce="True">
	    <database file="Ecom.mdb">
	        <EcomProductCategoryFieldValue>
		        <sql conditional="">
                    UPDATE fv
                    SET fv.[FieldValueValue] = REPLACE(REPLACE(REPLACE(fv.[FieldValueValue], ' ', ''), '.', ''), ',', '.')
                    FROM [EcomProductCategoryFieldValue] fv
                    JOIN [EcomProductCategoryField] f ON f.[FieldId] = fv.[FieldValueFieldId] AND  f.[FieldCategoryId] = fv.[FieldValueFieldCategoryId]
                    WHERE f.[FieldType] = 7 AND CHARINDEX(',', fv.[FieldValueValue]) > CHARINDEX('.', fv.[FieldValueValue])
                </sql>
                <sql conditional="">
                    UPDATE gfv
                    SET gfv.[FieldValueValue] = REPLACE(REPLACE(REPLACE(gfv.[FieldValueValue], ' ', ''), '.', ''), ',', '.')
                    FROM [EcomProductCategoryFieldGroupValue] gfv
                    JOIN [EcomProductCategoryField] f ON f.[FieldId] = gfv.[FieldValueFieldId] AND  f.[FieldCategoryId] = gfv.[FieldValueFieldCategoryId]
                    WHERE f.[FieldType] = 7 AND CHARINDEX(',', gfv.[FieldValueValue]) > CHARINDEX('.', gfv.[FieldValueValue])
                </sql>
            </EcomProductCategoryFieldValue>
	    </database>
    </package>


    <package version="2027" releasedate="14-02-2017" RunOnce="True">
	    <database file="Ecom.mdb">
	        <EcomCountries>
                <sql conditional="">ALTER TABLE [EcomCountryText] DROP CONSTRAINT [PK_EcomCountryText];</sql>
                <sql conditional="">ALTER TABLE [EcomCountryText] DROP CONSTRAINT [DW_PK_EcomCountryText];</sql>
                <sql conditional="">ALTER TABLE [EcomCountryText] DROP CONSTRAINT [FK_EcomCountryText_EcomCountries];</sql>
                <sql conditional="">ALTER TABLE [EcomCountryText] DROP CONSTRAINT [DW_FK_EcomCountryText_EcomCountries];</sql>
                <sql conditional="">ALTER TABLE [EcomCountryText] DROP CONSTRAINT [DW_DF_EcomCountryText_RegionCode];</sql>
                <sql conditional="">ALTER TABLE [EcomCountries] DROP CONSTRAINT [PK_EcomCountries];</sql>
                <sql conditional="">ALTER TABLE [EcomCountries] DROP CONSTRAINT [DW_PK_EcomCountries];</sql>
                <sql conditional="">ALTER TABLE [EcomCountries] DROP CONSTRAINT [DW_DF_EcomCountries_RegionCode];</sql>
                <sql conditional="">ALTER TABLE [EcomFees] DROP CONSTRAINT [DW_DF_EcomFees_RegionCode];</sql>
                <sql conditional="">ALTER TABLE [EcomMethodCountryRelation] DROP CONSTRAINT [DW_DF_EcomMethodCountryRelation_RegionCode];</sql>
                <sql conditional="">
                    ALTER TABLE [EcomCountries] ALTER COLUMN [CountryRegionCode] [nvarchar](3) NOT NULL; 
                    ALTER TABLE [EcomCountryText] ALTER COLUMN [CountryTextRegionCode] [nvarchar](3) NOT NULL;
                    ALTER TABLE [EcomFees] ALTER COLUMN [FeeRegionCode] [nvarchar](3) NOT NULL; 
                    ALTER TABLE [EcomMethodCountryRelation] ALTER COLUMN [MethodCountryRelRegionCode] [nvarchar](3) NOT NULL; 
                </sql>
                <sql conditional="">ALTER TABLE [EcomCountries] ADD CONSTRAINT [DW_PK_EcomCountries] PRIMARY KEY NONCLUSTERED ([CountryCode2],[CountryRegionCode]);</sql>
                <sql conditional="">ALTER TABLE [EcomCountryText] ADD  CONSTRAINT [DW_PK_EcomCountryText] PRIMARY KEY NONCLUSTERED ([CountryTextCode2],[CountryTextRegionCode],[CountryTextLanguageId]);</sql>
                <sql conditional="">ALTER TABLE [EcomCountryText] WITH CHECK ADD CONSTRAINT [DW_FK_EcomCountryText_EcomCountries] FOREIGN KEY([CountryTextCode2], [CountryTextRegionCode]) REFERENCES [EcomCountries] ([CountryCode2], [CountryRegionCode]);</sql>
                <sql conditional="">ALTER TABLE [EcomCountries] ADD CONSTRAINT [DW_DF_EcomCountries_RegionCode]  DEFAULT (N'') FOR [CountryRegionCode];</sql>
                <sql conditional="">ALTER TABLE [EcomCountryText] ADD  CONSTRAINT [DW_DF_EcomCountryText_RegionCode]  DEFAULT (N'') FOR [CountryTextRegionCode];</sql>
                <sql conditional="">ALTER TABLE [EcomFees] ADD  CONSTRAINT [DW_DF_EcomFees_RegionCode]  DEFAULT (N'') FOR [FeeRegionCode];</sql>
                <sql conditional="">ALTER TABLE [EcomMethodCountryRelation] ADD  CONSTRAINT [DW_DF_EcomMethodCountryRelation_RegionCode]  DEFAULT (N'') FOR [MethodCountryRelRegionCode];</sql>
	        </EcomCountries>
        </database>
    </package>

    <package version="2026" date="10-02-2017">
	    <database file="Ecom.mdb">
	        <EcomProductField>
		        <sql conditional="">
                    ALTER TABLE [EcomStockUnit] ADD [StockUnitDescription] NVARCHAR(255) NULL
                </sql>
            </EcomProductField>
	    </database>
    </package>

    <package version="2025" date="10-02-2017">
	    <database file="Ecom.mdb">
	        <EcomProductField>
		        <sql conditional="">
                    ALTER TABLE [EcomProductField] ADD [ProductFieldDoNotRender] BIT NOT NULL DEFAULT 0;
                    ALTER TABLE [EcomProductCategoryField] ADD [FieldDoNotRender] BIT NOT NULL DEFAULT 0;
                </sql>
            </EcomProductField>
	    </database>
    </package>

    <package version="2024" date="06-02-2017">
	    <database file="Ecom.mdb">
	        <EcomNumbers>
		        <sql conditional="">
                    ALTER TABLE [EcomNumbers] ADD [NumberTableName] [nvarchar](128) NULL, [NumberColumnName] [nvarchar](128) NULL;
                </sql>
                <sql conditional="">
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomFees', [NumberColumnName] = 'FeeID' WHERE NumberType = 'FEE';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomShippings', [NumberColumnName] = 'ShippingID' WHERE NumberType = 'SHIP';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomPayments', [NumberColumnName] = 'PaymentID' WHERE NumberType = 'PAY';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomVariantGroups', [NumberColumnName] = 'VariantGroupID' WHERE NumberType = 'VARGRP';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomProducts', [NumberColumnName] = 'ProductID' WHERE NumberType = 'PROD';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomGroups', [NumberColumnName] = 'GroupID' WHERE NumberType = 'GROUP';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomVariantsOptions', [NumberColumnName] = 'VariantOptionID' WHERE NumberType = 'VO';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomSalesDiscount', [NumberColumnName] = 'SalesDiscountID' WHERE NumberType = 'SALESDISCNT';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomStockGroups', [NumberColumnName] = 'StockGroupID' WHERE NumberType = 'STOCKGRP';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomMethodCountryRelation', [NumberColumnName] = 'MethodCountryRelCode2' WHERE NumberType = 'COUNTRYREL';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomRoundings', [NumberColumnName] = 'RoundingID' WHERE NumberType = 'ROUNDING';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomProducts', [NumberColumnName] = 'ProductID' WHERE NumberType = 'PROD';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomVatGroups', [NumberColumnName] = 'VatGroupID' WHERE NumberType = 'VATGRP';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomPrices', [NumberColumnName] = 'PriceID' WHERE NumberType = 'PRICE';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomProductsRelatedGroups', [NumberColumnName] = 'RelatedGroupID' WHERE NumberType = 'RELGRP';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomVariantgroupProductRelation', [NumberColumnName] = 'VariantgroupProductRelationID' WHERE NumberType = 'VARGRPPRODREL';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomShops', [NumberColumnName] = 'ShopID' WHERE NumberType = 'SHOP';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomLanguages', [NumberColumnName] = 'LanguageID' WHERE NumberType = 'LANG';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomPeriods', [NumberColumnName] = 'PeriodID' WHERE NumberType = 'PERIOD';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomManufacturers', [NumberColumnName] = 'ManufacturerID' WHERE NumberType = 'MANU';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomOrderStates', [NumberColumnName] = 'OrderStateID' WHERE NumberType = 'OS';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomOrders', [NumberColumnName] = 'OrderID' WHERE NumberType = 'ORDER';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomOrderLines', [NumberColumnName] = 'OrderLineID' WHERE NumberType = 'OL';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomDetails', [NumberColumnName] = 'DetailID' WHERE NumberType = 'DETAIL';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomProductField', [NumberColumnName] = 'ProductFieldID' WHERE NumberType = 'FIELD';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomProductItems', [NumberColumnName] = 'ProductItemID' WHERE NumberType = 'PRODITEM';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomOrderField', [NumberColumnName] = 'OrderFieldID' WHERE NumberType = 'ORDERFIELD';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomOrders', [NumberColumnName] = 'OrderID' WHERE NumberType = 'CART';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomStockStatus', [NumberColumnName] = 'StockStatusID' WHERE NumberType = 'STOCKSTATUS';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomProductGroupField', [NumberColumnName] = 'ProductGroupFieldID' WHERE NumberType = 'GROUPFIELD';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomValidationGroups', [NumberColumnName] = 'ValidationGroupID' WHERE NumberType = 'VALIDATIONGROUP';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomValidations', [NumberColumnName] = 'ValidationID' WHERE NumberType = 'VALIDATION';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomValidationRules', [NumberColumnName] = 'ValidationRuleID' WHERE NumberType = 'VALIDATIONRULE';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomOrders', [NumberColumnName] = 'OrderGatewayUniqueID' WHERE NumberType = 'ORDERGATEWAYUNIQUEID';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomFieldOption', [NumberColumnName] = 'FieldOptionID' WHERE NumberType = 'FIELDOPT';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomRmas', [NumberColumnName] = 'RmaID' WHERE NumberType = 'RMA';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomStockStatusLanguageValue', [NumberColumnName] = 'StockStatusLanguageValueID' WHERE NumberType = 'LANGUAGEVALUE';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomStockStatusLine', [NumberColumnName] = 'StockStatusLinesID' WHERE NumberType = 'STOCKSTATUSLINE';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomOrderContexts', [NumberColumnName] = 'OrderContextID' WHERE NumberType = 'ORDERCONTEXT';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomAssortments', [NumberColumnName] = 'AssortmentID' WHERE NumberType = 'ASSORTMENT';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomOrders', [NumberColumnName] = 'OrderID' WHERE NumberType = 'QUOTE';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomGiftCard', [NumberColumnName] = 'GiftCardId' WHERE NumberType = 'GIFTCARD';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomOrders', [NumberColumnName] = 'OrderID' WHERE NumberType = 'REC';
                    UPDATE [EcomNumbers] SET [NumberTableName] = 'EcomOrders', [NumberColumnName] = 'OrderID' WHERE NumberType = 'LEDGERENTRIES';
                </sql>
            </EcomNumbers>
	    </database>
    </package>

    <package version="2023" date="27-01-2017">
        <database file="Ecom.mdb">
	        <EcomOrders>
		        <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_EcomOrders_SecondaryUserId] ON [EcomOrders] ([OrderSecondaryUserId])
                    CREATE NONCLUSTERED INDEX [DW_IX_EcomOrders_Deleted] ON [EcomOrders] ([OrderDeleted])
                </sql>
            </EcomOrders>
        </database>
        <file name="ProductNotification.html" source="/Files/Templates/eCom/Product" target="/Files/Templates/eCom/Product"  overwrite="false"/>
    </package>

    <package version="2022" date="26-01-2017">
	    <database file="Ecom.mdb">
	        <EcomSalesDiscount>
		        <sql conditional="">
                    UPDATE [EcomSalesDiscount] SET [SalesDiscountDiscountType] = 'Dynamicweb.Ecommerce.Orders.SalesDiscounts.ProductDiscount', [SalesDiscountParameters] = REPLACE(CONVERT(nvarchar(4000), [SalesDiscountParameters]),'"Dynamicweb.eCommerce.Orders.SalesDiscounts.ProductDiscount"','"Dynamicweb.Ecommerce.Orders.SalesDiscounts.ProductDiscount"') WHERE [SalesDiscountDiscountType] = 'Dynamicweb.eCommerce.Orders.SalesDiscounts.ProductDiscount';
                </sql>
            </EcomSalesDiscount>
	    </database>
      </package>

    <package version="2021" releasedate="18-01-2017">
        <database file="Ecom.mdb">
            <Ecom7Tree>
                <sql conditional="SELECT COUNT(*) FROM Ecom7Tree WHERE TreeChildPopulate = 'PRODUCTMANAGEMENT'">
                    INSERT INTO Ecom7Tree (parentId, Text, Alt, TreeIcon, TreeIconOpen, TreeUrl, TreeChildPopulate, TreeSort, TreeHasAccessModuleSystemName)
                    VALUES(94, 'Product Management', NULL, '/Admin/Module/eCom_Catalog/images/buttons/btn_productManagement.gif', NULL, '/Admin/Module/eCom_Catalog/dw7/edit/EcomAdvConfigProductManagement.aspx', 'PRODUCTMANAGEMENT', 300, 'eCom_PCM')
                </sql>
            </Ecom7Tree>
        </database>
    </package>

        <package version="2020" releasedate="18-01-2017">
        <database file="Ecom.mdb">
            <AccessUserCard>
		        <sql conditional="select count(*) from [Module] where ModuleSystemName='eCom_PCM'">
                    Insert into [Module] ([ModuleSystemName],[ModuleName],[ModuleAccess],[ModuleParagraph],[ModuleSearch],[ModuleIsBeta] )values ('eCom_PCM','Product Management',0,0,0,0)
		        </sql>
	        </AccessUserCard>
            <EcomTree>
                <sql conditional="SELECT COUNT(*) FROM EcomTree WHERE TreeChildPopulate = 'PRODUCTMANAGEMENT'">
                    INSERT INTO EcomTree (parentId, 1Text, Alt, TreeIcon, TreeIconOpen, TreeUrl, TreeChildPopulate, TreeSort, TreeHasAccessModuleSystemName)
                    VALUES(1, 'Product Management', NULL, '/Admin/Module/eCom_Catalog/images/buttons/btn_productManagement.gif', NULL, NULL, 'PRODUCTMANAGEMENT', 2, 'eCom_PCM')
                </sql>
                <sql conditional="SELECT COUNT(*) FROM EcomTree WHERE TreeChildPopulate = 'PRODUCTMANAGEMENT' AND TreeSort = 2">
                    UPDATE EcomTree
                    SET TreeSort = 2
                    WHERE TreeChildPopulate = 'PRODUCTMANAGEMENT'
                </sql>
                <sql conditional="SELECT COUNT(*) FROM EcomTree WHERE TreeChildPopulate = 'ORDERS' AND TreeSort = 3">
                    UPDATE EcomTree
                    SET TreeSort = 3
                    WHERE TreeChildPopulate = 'ORDERS'
                </sql>
            </EcomTree>
        </database>
    </package>

    <package version="2019" releasedate="13-01-2017">
        <database file="Ecom.mdb">
            <Ecom7Tree>
                <sql conditional="">
                    UPDATE [Ecom7Tree] SET [Text] = 'Email notifications' WHERE [TreeChildPopulate] = 'RMAEMAILCONFIGS'
                </sql>
            </Ecom7Tree>
        </database>
    </package>

    <package version="2018" releasedate="11-01-2017">
        <file name="LedgerEntryList.html" source="/Files/Templates/eCom/CustomerCenter" target="/Files/Templates/eCom/CustomerCenter"  overwrite="false"/>
        <file name="LedgerEntryDetail.html" source="/Files/Templates/eCom/CustomerCenter" target="/Files/Templates/eCom/CustomerCenter"  overwrite="false"/>
        <file name="NavigationLedgerEntries.html" source="/Files/Templates/eCom/CustomerCenter" target="/Files/Templates/eCom/CustomerCenter"  overwrite="false"/>
        <database file="Ecom.mdb">
            <EcomOrders>
                <sql conditional="">
                    ALTER TABLE [EcomOrders] ADD 
                        [OrderIsLedgerEntry] BIT NOT NULL DEFAULT 0,
                        [OrderIsPayable] BIT NOT NULL DEFAULT 1
                </sql>
            </EcomOrders>
            <EcomNumbers>
                <sql conditional="">
                    IF NOT EXISTS( SELECT NumberID FROM EcomNumbers WHERE ( NumberType = 'LEDGER' ) )
	                    INSERT INTO EcomNumbers ( NumberID, NumberType, NumberDescription, NumberCounter, NumberPrefix, NumberPostFix, NumberAdd, NumberEditable )
	                    VALUES ( '53', 'LEDGERENTRIES', 'Ledger entries', 0, 'LEDGER', '', 1, 0 )
                </sql>
            </EcomNumbers>
            <EcomTree>
                <sql conditional="SELECT COUNT(*) FROM EcomTree WHERE TreeChildPopulate = 'LEDGERENTRIES'">
                    INSERT INTO EcomTree (parentId, Text, Alt, TreeIcon, TreeIconOpen, TreeUrl, TreeChildPopulate, TreeSort, TreeHasAccessModuleSystemName)
                    VALUES(1, 'Ledger', NULL, NULL, NULL, NULL, 'LEDGERENTRIES', 6, NULL)
                </sql>
                <sql conditional="">
                    UPDATE [EcomTree] SET [TreeSort] = [TreeSort] + 1 WHERE ([TreeChildPopulate] = 'RMAS' AND [TreeSort] = 6) OR ([TreeChildPopulate] = 'STAT' AND [TreeSort] = 7)
                </sql>
            </EcomTree>
        </database>
    </package>

    <package version="2017" releasedate="30-12-2016">    
        <database file="Ecom.mdb">
            <Ecom7Tree>
                <sql conditional="">
                    DELETE FROM [Ecom7Tree] WHERE [TreeUrl] = '/Admin/Module/eCom_Catalog/dw7/edit/EcomAdvConfigBoosting_Edit.aspx'
                </sql>
            </Ecom7Tree>            
        </database>
    </package>

    <package version="2016" date="29-12-2016">
        <database file="Ecom.mdb">
            <EcomShops>
                <sql conditional="">
                    ALTER TABLE [EcomShops] ADD 
                        [ShopUseAlternativeImages] BIT DEFAULT 0,
                        [ShopImageFolder] NVARCHAR(255) NULL,
                        [ShopImagePatternSmall] NVARCHAR(255) NULL,
                        [ShopImagePatternMedium] NVARCHAR(255) NULL,
                        [ShopImagePatternLarge] NVARCHAR(255) NULL,
                        [ShopAlternativeImagePatterns] NVARCHAR(MAX) NULL
                </sql>
            </EcomShops>
        </database>
    </package>

    <package version="2015" releasedate="28-12-2016">    
        <database file="Ecom.mdb">
            <EcomProducts>
                <sql conditional="">
                    ALTER TABLE [EcomProducts] ADD [ProductHidden] BIT NULL DEFAULT 0
                </sql>
            </EcomProducts>            
        </database>
    </package>
    
    <package version="2014" releasedate="20-12-2016">
        <database file="Ecom.mdb">
            <Ecom7Tree>
                <sql conditional="">
                    UPDATE [Ecom7Tree] SET [TreeUrl] = '/Admin/Module/eCom_Catalog/dw7/edit/EcomAdvConfigGeneral_Edit.aspx' WHERE [TreeUrl] = '/Admin/Module/Ecom_cpl.aspx?cmd=1';
                    UPDATE [Ecom7Tree] SET [TreeUrl] = '/Admin/Module/eCom_Catalog/dw7/edit/EcomAdvConfigLanguage_Edit.aspx' WHERE [TreeUrl] = '/Admin/Module/Ecom_cpl.aspx?cmd=2';
                    UPDATE [Ecom7Tree] SET [TreeUrl] = '/Admin/Module/eCom_Catalog/dw7/edit/EcomAdvConfigPrices_Edit.aspx' WHERE [TreeUrl] = '/Admin/Module/Ecom_cpl.aspx?cmd=3';
                    DELETE FROM [Ecom7Tree] WHERE [TreeUrl] = '/Admin/Module/Ecom_cpl.aspx?cmd=4';
                    UPDATE [Ecom7Tree] SET [TreeUrl] = '/Admin/Module/eCom_Catalog/dw7/edit/EcomAdvConfigSalesDiscounts_Edit.aspx' WHERE [TreeUrl] = '/Admin/Module/Ecom_cpl.aspx?cmd=5';
                    UPDATE [Ecom7Tree] SET [TreeUrl] = '/Admin/Module/eCom_Catalog/dw7/edit/EcomAdvConfigImages_Edit.aspx' WHERE [TreeUrl] = '/Admin/Module/Ecom_cpl.aspx?cmd=6';
                    UPDATE [Ecom7Tree] SET [TreeUrl] = '/Admin/Module/eCom_Catalog/dw7/edit/EcomAdvConfigShoppingCart_Edit.aspx' WHERE [TreeUrl] = '/Admin/Module/Ecom_cpl.aspx?cmd=7';
                    UPDATE [Ecom7Tree] SET [TreeUrl] = '/Admin/Module/eCom_Catalog/dw7/edit/EcomAdvConfigAssortments_Edit.aspx' WHERE [TreeUrl] = '/Admin/Module/Ecom_cpl.aspx?cmd=9';
                </sql>
            </Ecom7Tree>
        </database>
    </package>

    <package version="2013" releasedate="14-11-2016">
        <database file="Ecom.mdb">
            <EcomOrderDiscount>
                <sql conditional="">
                    ALTER TABLE [EcomDiscount] ADD [DiscountAmountProductFieldName] NVARCHAR(255) NULL
                </sql>
            </EcomOrderDiscount>
        </database>
    </package>

    <package version="2012" date="24-10-2016">
        <database file="Ecom.mdb">
            <EcomFieldType>
                <sql conditional="">
                    ALTER TABLE [EcomFieldType] DROP [FieldTypeDB]
                </sql>
                <sql conditional="">
                    ALTER TABLE [EcomFieldType] DROP [FieldTypeOption]
                </sql>
            </EcomFieldType>
            <Module>
                <sql conditional="">
                    DROP TABLE [EcomPropertyFieldOption]
                </sql>
                <sql conditional="">
                    DROP TABLE [EcomPropertyValue]
                </sql>
                <sql conditional="">
                    DROP TABLE [EcomPropertyTypeRelation]
                </sql>
                <sql conditional="">
                    DROP TABLE [EcomPropertyField]
                </sql>
                <sql conditional="">
                    DROP TABLE [EcomPropertyGroup]
                </sql>
                <sql conditional="">
                    DROP TABLE [EcomPropertyType]
                </sql>
            </Module>
        </database>
    </package>
    

    <package version="2011" date="29-06-2016">
	    <database file="Ecom.mdb">
            <Module>
		        <sql conditional="">
                    UPDATE [EcomTree] SET [Alt] = 7 WHERE [Parentid] = 1 AND [TreeChildPopulate] IN ('VOUCHERS','SALESDISCOUNTS')
                </sql>
            </Module>
        </database>
    </package>  

    <package version="2010" date="28-06-2016">
        <database file="Ecom.mdb">
            <Module>
                <sql conditional="SELECT * FROM [EcomTree] WHERE [Parentid] = 1 AND [TreeChildPopulate] IN ('VOUCHERS','LOYALTYPOINTS','ORDERDISCOUNTS','SALESDISCOUNTS','GIFTCARDS')">
                    INSERT INTO [EcomTree] ([Parentid],[Text],[TreeUrl],[TreeChildPopulate],[TreeSort],[TreeHasAccessModuleSystemName],[TreeIcon])
                        VALUES (1,'Vouchers', '/Admin/Module/eCom_Catalog/dw7/Vouchers/VouchersManagerMain.aspx','VOUCHERS',11,'eCom_Catalog','tree/btn_vouchers.png'),
                                (1,'Loyalty points', '/Admin/Module/eCom_Catalog/dw7/Lists/EcomReward_List.aspx?update=true','LOYALTYPOINTS',10,'LoyaltyPoints','/Admin/Module/eCom_Catalog/dw7/images/tree/eCom_LoyaltyPoints_Settings_small.png'),
                                (1,'Order discounts', '/Admin/Module/eCom_Catalog/dw7/lists/EcomOrderDiscount_List.aspx','ORDERDISCOUNTS',8,'','/Admin/Module/eCom_Catalog/images/buttons/btn_discount.gif'),
                                (1,'Rabatter', '/Admin/Module/eCom_Catalog/dw7/Lists/EcomSalesDiscount_List.aspx','SALESDISCOUNTS',9,'eCom_SalesDiscount, eCom_SalesDiscountExtended','tree/btn_salesdiscount.png'),
                                (1,'GiftCards', '/Admin/Module/eCom_Catalog/dw7/GiftCards/GiftCardsList.aspx','GIFTCARDS',12,'eCom_CartV2','/Admin/Module/eCom_Catalog/images/buttons/btn_giftcard.gif')
                </sql>
                <sql conditional="">
                    DELETE FROM Ecom7tree WHERE [parentId] = 92 AND [TreeChildPopulate] IN ('ORDERDISCOUNTSLIST','LOYALTYPOINTS','GIFTCARDS','ECOMVOUCHERSMANAGER','SALESDISCNT')
                </sql>
            </Module>
        </database>
    </package>

    <package version="2009" date="28-06-2016">
	    <database file="Ecom.mdb">
            <Module>
                <sql conditional="">
                    DELETE FROM Ecom7tree WHERE [parentId] = 93 AND [TreeChildPopulate] = 'CALCFIELD'
                </sql>
                <sql conditional="">
                    DELETE FROM Ecom7tree WHERE [parentId] = 93 AND [TreeChildPopulate] = 'PROPTYPE'
                </sql>
            </Module>
        </database>
    </package>

    <package version="2008" date="21-06-2016">
        <file name="LoyaltyPointList.html" source="/Files/Templates/eCom/CustomerCenter" target="/Files/Templates/eCom/CustomerCenter"  overwrite="false"/>
        <file name="LoyaltyPointDetails.html" source="/Files/Templates/eCom/CustomerCenter" target="/Files/Templates/eCom/CustomerCenter"  overwrite="false"/>
    </package>

    <package version="2007" date="15-06-2016">
        <database file="Ecom.mdb">
	        <Module>
		        <sql conditional="">
                    DELETE FROM Ecom7tree WHERE [parentId] = 93 AND [TreeChildPopulate] = 'SEARCHFILTERS'
                </sql>
            </Module>
	    </database>
      </package>

    <package version="2006" date="26-04-2016">
	    <database file="Ecom.mdb">
	        <EcomSalesDiscount>
		    <sql conditional="">
                    UPDATE [EcomSalesDiscount] SET [SalesDiscountDiscountType] = 'Dynamicweb.Ecommerce.SalesDiscounts.OrderFieldDiscount.OrderFieldDiscount', [SalesDiscountParameters] = REPLACE(CONVERT(nvarchar(4000), [SalesDiscountParameters]),'"Dynamicweb.eCommerce.Orders.SalesDiscounts.OrderFieldDiscount"','"Dynamicweb.Ecommerce.SalesDiscounts.OrderFieldDiscount.OrderFieldDiscount"') WHERE [SalesDiscountDiscountType] = 'Dynamicweb.eCommerce.Orders.SalesDiscounts.OrderFieldDiscount';
                    UPDATE [EcomSalesDiscount] SET [SalesDiscountDiscountType] = 'Dynamicweb.Ecommerce.SalesDiscounts.OrderFieldShippingDiscount.OrderFieldShippingDiscount', [SalesDiscountParameters] = REPLACE(CONVERT(nvarchar(4000), [SalesDiscountParameters]),'"Dynamicweb.eCommerce.Orders.SalesDiscounts.OrderFieldShippingDiscount"','"Dynamicweb.Ecommerce.SalesDiscounts.OrderFieldShippingDiscount.OrderFieldShippingDiscount"') WHERE [SalesDiscountDiscountType] = 'Dynamicweb.eCommerce.Orders.SalesDiscounts.OrderFieldShippingDiscount';
                    UPDATE [EcomSalesDiscount] SET [SalesDiscountDiscountType] = 'Dynamicweb.Ecommerce.SalesDiscounts.PriceFieldPriceProvider.PriceFieldPriceProvider', [SalesDiscountParameters] = REPLACE(CONVERT(nvarchar(4000), [SalesDiscountParameters]),'"Dynamicweb.eCommerce.Orders.SalesDiscounts.PriceFieldPriceProvider"','"Dynamicweb.Ecommerce.SalesDiscounts.PriceFieldPriceProvider.PriceFieldPriceProvider"') WHERE [SalesDiscountDiscountType] = 'Dynamicweb.eCommerce.Orders.SalesDiscounts.PriceFieldPriceProvider';
                    UPDATE [EcomSalesDiscount] SET [SalesDiscountDiscountType] = 'Dynamicweb.Ecommerce.SalesDiscounts.ProductOrderFieldDiscount.ProductOrderFieldDiscount', [SalesDiscountParameters] = REPLACE(CONVERT(nvarchar(4000), [SalesDiscountParameters]),'"Dynamicweb.eCommerce.Orders.SalesDiscounts.ProductOrderFieldDiscount"','"Dynamicweb.Ecommerce.SalesDiscounts.ProductOrderFieldDiscount.ProductOrderFieldDiscount"') WHERE [SalesDiscountDiscountType] = 'Dynamicweb.eCommerce.Orders.SalesDiscounts.ProductOrderFieldDiscount';
                    UPDATE [EcomSalesDiscount] SET [SalesDiscountDiscountType] = 'Dynamicweb.Ecommerce.SalesDiscounts.ProductPriceFieldDiscount.ProductPriceFieldDiscount', [SalesDiscountParameters] = REPLACE(CONVERT(nvarchar(4000), [SalesDiscountParameters]),'"Dynamicweb.eCommerce.Orders.SalesDiscounts.ProductPriceFieldDiscount"','"Dynamicweb.Ecommerce.SalesDiscounts.ProductPriceFieldDiscount.ProductPriceFieldDiscount"') WHERE [SalesDiscountDiscountType] = 'Dynamicweb.eCommerce.Orders.SalesDiscounts.ProductPriceFieldDiscount';
                    UPDATE [EcomSalesDiscount] SET [SalesDiscountDiscountType] = 'Dynamicweb.Ecommerce.SalesDiscounts.ProductQuantityDiscount.ProductQuantityDiscount', [SalesDiscountParameters] = REPLACE(CONVERT(nvarchar(4000), [SalesDiscountParameters]),'"Dynamicweb.eCommerce.Orders.SalesDiscounts.ProductQuantityDiscount"','"Dynamicweb.Ecommerce.SalesDiscounts.ProductQuantityDiscount.ProductQuantityDiscount"') WHERE [SalesDiscountDiscountType] = 'Dynamicweb.eCommerce.Orders.SalesDiscounts.ProductQuantityDiscount';
                    UPDATE [EcomSalesDiscount] SET [SalesDiscountDiscountType] = 'Dynamicweb.Ecommerce.SalesDiscounts.ShippingDiscount.ShippingDiscount', [SalesDiscountParameters] = REPLACE(CONVERT(nvarchar(4000), [SalesDiscountParameters]),'"Dynamicweb.eCommerce.Orders.SalesDiscounts.ShippingDiscount"','"Dynamicweb.Ecommerce.SalesDiscounts.ShippingDiscount.ShippingDiscount"') WHERE [SalesDiscountDiscountType] = 'Dynamicweb.eCommerce.Orders.SalesDiscounts.ShippingDiscount';
                    UPDATE [EcomSalesDiscount] SET [SalesDiscountDiscountType] = 'Dynamicweb.Ecommerce.SalesDiscounts.ShippingPaymentDiscount.ShippingPaymentDiscount', [SalesDiscountParameters] = REPLACE(CONVERT(nvarchar(4000), [SalesDiscountParameters]),'"Dynamicweb.eCommerce.Orders.SalesDiscounts.ShippingPaymentDiscount"','"Dynamicweb.Ecommerce.SalesDiscounts.ShippingPaymentDiscount.ShippingPaymentDiscount"') WHERE [SalesDiscountDiscountType] = 'Dynamicweb.eCommerce.Orders.SalesDiscounts.ShippingPaymentDiscount';
                    UPDATE [EcomSalesDiscount] SET [SalesDiscountDiscountType] = 'Dynamicweb.Ecommerce.SalesDiscounts.SimpleVoucherDiscount.SimpleVoucherDiscount', [SalesDiscountParameters] = REPLACE(CONVERT(nvarchar(4000), [SalesDiscountParameters]),'"Dynamicweb.eCommerce.Orders.SalesDiscounts.SimpleVoucherDiscount"','"Dynamicweb.Ecommerce.SalesDiscounts.SimpleVoucherDiscount.SimpleVoucherDiscount"') WHERE [SalesDiscountDiscountType] = 'Dynamicweb.eCommerce.Orders.SalesDiscounts.SimpleVoucherDiscount';
                    UPDATE [EcomSalesDiscount] SET [SalesDiscountDiscountType] = 'Dynamicweb.Ecommerce.SalesDiscounts.TotalProductCountDiscount.TotalProductCountDiscount', [SalesDiscountParameters] = REPLACE(CONVERT(nvarchar(4000), [SalesDiscountParameters]),'"Dynamicweb.eCommerce.Orders.SalesDiscounts.TotalProductCountDiscount"','"Dynamicweb.Ecommerce.SalesDiscounts.TotalProductCountDiscount.TotalProductCountDiscount"') WHERE [SalesDiscountDiscountType] = 'Dynamicweb.eCommerce.Orders.SalesDiscounts.TotalProductCountDiscount';
                    UPDATE [EcomSalesDiscount] SET [SalesDiscountDiscountType] = 'Dynamicweb.Ecommerce.SalesDiscounts.TotalSalesPriceDiscount.TotalSalesPriceDiscount', [SalesDiscountParameters] = REPLACE(CONVERT(nvarchar(4000), [SalesDiscountParameters]),'"Dynamicweb.eCommerce.Orders.SalesDiscounts.TotalSalesPriceDiscount"','"Dynamicweb.Ecommerce.SalesDiscounts.TotalSalesPriceDiscount.TotalSalesPriceDiscount"') WHERE [SalesDiscountDiscountType] = 'Dynamicweb.eCommerce.Orders.SalesDiscounts.TotalSalesPriceDiscount';
		    </sql>
            </EcomSalesDiscount>
	    </database>
      </package>

    <package version="2005" date="25-04-2016">
	    <database file="Ecom.mdb">
	        <EcomPayments>
		        <sql conditional="">
                    UPDATE [EcomPayments] SET [PaymentCheckoutSystemName] = 'Dynamicweb.Ecommerce.CheckoutHandlers.AuthorizeNet.AuthorizeNet', [PaymentCheckoutParameters] = REPLACE([PaymentCheckoutParameters],'"Dynamicweb.eCommerce.Cart.CheckoutHandlers.AuthorizeNet"','"Dynamicweb.Ecommerce.CheckoutHandlers.AuthorizeNet.AuthorizeNet"') WHERE [PaymentCheckoutSystemName] = 'Dynamicweb.eCommerce.Cart.CheckoutHandlers.AuthorizeNet';
                    UPDATE [EcomPayments] SET [PaymentCheckoutSystemName] = 'Dynamicweb.Ecommerce.CheckoutHandlers.AuthorizeNetAIM.AuthorizeNetAIM', [PaymentCheckoutParameters] = REPLACE([PaymentCheckoutParameters],'"Dynamicweb.eCommerce.Cart.CheckoutHandlers.AuthorizeNetAIM"','"Dynamicweb.Ecommerce.CheckoutHandlers.AuthorizeNetAIM.AuthorizeNetAIM"') WHERE [PaymentCheckoutSystemName] = 'Dynamicweb.eCommerce.Cart.CheckoutHandlers.AuthorizeNetAIM';
                    UPDATE [EcomPayments] SET [PaymentCheckoutSystemName] = 'Dynamicweb.Ecommerce.CheckoutHandlers.BBSPayment.BBSPayment', [PaymentCheckoutParameters] = REPLACE([PaymentCheckoutParameters],'"Dynamicweb.eCommerce.Cart.CheckoutHandlers.BBSPayment"','"Dynamicweb.Ecommerce.CheckoutHandlers.BBSPayment.BBSPayment"') WHERE [PaymentCheckoutSystemName] = 'Dynamicweb.eCommerce.Cart.CheckoutHandlers.BBSPayment';
                    UPDATE [EcomPayments] SET [PaymentCheckoutSystemName] = 'Dynamicweb.Ecommerce.CheckoutHandlers.BeanstreamHostedForm.BeanstreamHostedForm', [PaymentCheckoutParameters] = REPLACE([PaymentCheckoutParameters],'"Dynamicweb.eCommerce.BeanstreamCheckoutHandler.BeanstreamHostedForm"','"Dynamicweb.Ecommerce.CheckoutHandlers.BeanstreamHostedForm.BeanstreamHostedForm"') WHERE [PaymentCheckoutSystemName] = 'Dynamicweb.eCommerce.BeanstreamCheckoutHandler.BeanstreamHostedForm';
                    UPDATE [EcomPayments] SET [PaymentCheckoutSystemName] = 'Dynamicweb.Ecommerce.CheckoutHandlers.Buckaroo.Buckaroo', [PaymentCheckoutParameters] = REPLACE([PaymentCheckoutParameters],'"Dynamicweb.eCommerce.Cart.CheckoutHandlers.Buckaroo"','"Dynamicweb.Ecommerce.CheckoutHandlers.Buckaroo.Buckaroo"') WHERE [PaymentCheckoutSystemName] = 'Dynamicweb.eCommerce.Cart.CheckoutHandlers.Buckaroo';
                    UPDATE [EcomPayments] SET [PaymentCheckoutSystemName] = 'Dynamicweb.Ecommerce.CheckoutHandlers.ChargeLogicConnect.ChargeLogicConnect', [PaymentCheckoutParameters] = REPLACE([PaymentCheckoutParameters],'"Dynamicweb.eCommerce.Cart.CheckoutHandlers.ChargeLogicConnect"','"Dynamicweb.Ecommerce.CheckoutHandlers.ChargeLogicConnect.ChargeLogicConnect"') WHERE [PaymentCheckoutSystemName] = 'Dynamicweb.eCommerce.Cart.CheckoutHandlers.ChargeLogicConnect';
                    UPDATE [EcomPayments] SET [PaymentCheckoutSystemName] = 'Dynamicweb.Ecommerce.CheckoutHandlers.CyberSource.CyberSource', [PaymentCheckoutParameters] = REPLACE([PaymentCheckoutParameters],'"Dynamicweb.eCommerce.Cart.CheckoutHandlers.CyberSourceHandler.CyberSource"','"Dynamicweb.Ecommerce.CheckoutHandlers.CyberSource.CyberSource"') WHERE [PaymentCheckoutSystemName] = 'Dynamicweb.eCommerce.Cart.CheckoutHandlers.CyberSourceHandler.CyberSource';
                    UPDATE [EcomPayments] SET [PaymentCheckoutSystemName] = 'Dynamicweb.Ecommerce.CheckoutHandlers.Dibs.Dibs', [PaymentCheckoutParameters] = REPLACE([PaymentCheckoutParameters],'"Dynamicweb.eCommerce.Cart.CheckoutHandlers.Dibs"','"Dynamicweb.Ecommerce.CheckoutHandlers.Dibs.Dibs"') WHERE [PaymentCheckoutSystemName] = 'Dynamicweb.eCommerce.Cart.CheckoutHandlers.Dibs';
                    UPDATE [EcomPayments] SET [PaymentCheckoutSystemName] = 'Dynamicweb.Ecommerce.CheckoutHandlers.DibsMobile.DibsMobile', [PaymentCheckoutParameters] = REPLACE([PaymentCheckoutParameters],'"Dynamicweb.eCommerce.Cart.CheckoutHandlers.DibsMobile"','"Dynamicweb.Ecommerce.CheckoutHandlers.DibsMobile.DibsMobile"') WHERE [PaymentCheckoutSystemName] = 'Dynamicweb.eCommerce.Cart.CheckoutHandlers.DibsMobile';
                    UPDATE [EcomPayments] SET [PaymentCheckoutSystemName] = 'Dynamicweb.Ecommerce.CheckoutHandlers.DibsPaymentWindow.DibsPaymentWindow', [PaymentCheckoutParameters] = REPLACE([PaymentCheckoutParameters],'"Dynamicweb.eCommerce.Cart.CheckoutHandlers.DibsPaymentWindow"','"Dynamicweb.Ecommerce.CheckoutHandlers.DibsPaymentWindow.DibsPaymentWindow"') WHERE [PaymentCheckoutSystemName] = 'Dynamicweb.eCommerce.Cart.CheckoutHandlers.DibsPaymentWindow';
                    UPDATE [EcomPayments] SET [PaymentCheckoutSystemName] = 'Dynamicweb.Ecommerce.CheckoutHandlers.DocData.DocData', [PaymentCheckoutParameters] = REPLACE([PaymentCheckoutParameters],'"Dynamicweb.eCommerce.Cart.CheckoutHandlers.DocData"','"Dynamicweb.Ecommerce.CheckoutHandlers.DocData.DocData"') WHERE [PaymentCheckoutSystemName] = 'Dynamicweb.eCommerce.Cart.CheckoutHandlers.DocData';
                    UPDATE [EcomPayments] SET [PaymentCheckoutSystemName] = 'Dynamicweb.Ecommerce.CheckoutHandlers.EPayPaymentWindow.EPayPaymentWindow', [PaymentCheckoutParameters] = REPLACE([PaymentCheckoutParameters],'"Dynamicweb.eCommerce.Cart.CheckoutHandlers.EPayPaymentWindow"','"Dynamicweb.Ecommerce.CheckoutHandlers.EPayPaymentWindow.EPayPaymentWindow"') WHERE [PaymentCheckoutSystemName] = 'Dynamicweb.eCommerce.Cart.CheckoutHandlers.EPayPaymentWindow';
                    UPDATE [EcomPayments] SET [PaymentCheckoutSystemName] = 'Dynamicweb.Ecommerce.CheckoutHandlers.KlarnaCheckout.KlarnaCheckout', [PaymentCheckoutParameters] = REPLACE([PaymentCheckoutParameters],'"Dynamicweb.eCommerce.Cart.CheckoutHandlers.KlarnaCheckout"','"Dynamicweb.Ecommerce.CheckoutHandlers.KlarnaCheckout.KlarnaCheckout"') WHERE [PaymentCheckoutSystemName] = 'Dynamicweb.eCommerce.Cart.CheckoutHandlers.KlarnaCheckout';
                    UPDATE [EcomPayments] SET [PaymentCheckoutSystemName] = 'Dynamicweb.Ecommerce.CheckoutHandlers.KlarnaCheckout.KlarnaInvoice', [PaymentCheckoutParameters] = REPLACE([PaymentCheckoutParameters],'"Dynamicweb.eCommerce.Cart.CheckoutHandlers.KlarnaInvoice"','"Dynamicweb.Ecommerce.CheckoutHandlers.KlarnaCheckout.KlarnaInvoice"') WHERE [PaymentCheckoutSystemName] = 'Dynamicweb.eCommerce.Cart.CheckoutHandlers.KlarnaInvoice';
                    UPDATE [EcomPayments] SET [PaymentCheckoutSystemName] = 'Dynamicweb.Ecommerce.CheckoutHandlers.Ogone.Ogone', [PaymentCheckoutParameters] = REPLACE([PaymentCheckoutParameters],'"Dynamicweb.eCommerce.Cart.CheckoutHandlers.Ogone"','"Dynamicweb.Ecommerce.CheckoutHandlers.Ogone.Ogone"') WHERE [PaymentCheckoutSystemName] = 'Dynamicweb.eCommerce.Cart.CheckoutHandlers.Ogone';
                    UPDATE [EcomPayments] SET [PaymentCheckoutSystemName] = 'Dynamicweb.Ecommerce.CheckoutHandlers.PayPalExpressCheckout.PayPalExpressCheckout', [PaymentCheckoutParameters] = REPLACE([PaymentCheckoutParameters],'"Dynamicweb.eCommerce.Cart.CheckoutHandlers.PayPalExpressCheckout"','"Dynamicweb.Ecommerce.CheckoutHandlers.PayPalExpressCheckout.PayPalExpressCheckout"') WHERE [PaymentCheckoutSystemName] = 'Dynamicweb.eCommerce.Cart.CheckoutHandlers.PayPalExpressCheckout';
                    UPDATE [EcomPayments] SET [PaymentCheckoutSystemName] = 'Dynamicweb.Ecommerce.CheckoutHandlers.QuickPay3.QuickPay3', [PaymentCheckoutParameters] = REPLACE([PaymentCheckoutParameters],'"Dynamicweb.eCommerce.Cart.CheckoutHandlers.QuickPay3"','"Dynamicweb.Ecommerce.CheckoutHandlers.QuickPay3.QuickPay3"') WHERE [PaymentCheckoutSystemName] = 'Dynamicweb.eCommerce.Cart.CheckoutHandlers.QuickPay3';
                    UPDATE [EcomPayments] SET [PaymentCheckoutSystemName] = 'Dynamicweb.Ecommerce.CheckoutHandlers.QuickPayPaymentWindow.QuickPayPaymentWindow', [PaymentCheckoutParameters] = REPLACE([PaymentCheckoutParameters],'"Dynamicweb.eCommerce.Cart.CheckoutHandlers.QuickPayPaymentWindow"','"Dynamicweb.Ecommerce.CheckoutHandlers.QuickPayPaymentWindow.QuickPayPaymentWindow"') WHERE [PaymentCheckoutSystemName] = 'Dynamicweb.eCommerce.Cart.CheckoutHandlers.QuickPayPaymentWindow';
                    UPDATE [EcomPayments] SET [PaymentCheckoutSystemName] = 'Dynamicweb.Ecommerce.CheckoutHandlers.StripeCheckout.StripeCheckout', [PaymentCheckoutParameters] = REPLACE([PaymentCheckoutParameters],'"Dynamicweb.eCommerce.Cart.CheckoutHandlers.StripeCheckout"','"Dynamicweb.Ecommerce.CheckoutHandlers.StripeCheckout.StripeCheckout"') WHERE [PaymentCheckoutSystemName] = 'Dynamicweb.eCommerce.Cart.CheckoutHandlers.StripeCheckout';
                </sql>
            </EcomPayments>
	    </database>
    </package>

    <package version="2004" date="25-04-2016">
	    <database file="Ecom.mdb">
            <EcomShippings>
                <sql conditional="">
                    UPDATE [EcomShippings] SET [ShippingServiceSystemName] = 'Dynamicweb.Ecommerce.ShippingProviders.FedEx.FedEx', [ShippingServiceParameters] = REPLACE([ShippingServiceParameters],'"Dynamicweb.eCommerce.Cart.ShippingProviders.FedEx"','"Dynamicweb.Ecommerce.ShippingProviders.FedEx.FedEx"') WHERE [ShippingServiceSystemName] = 'Dynamicweb.eCommerce.Cart.ShippingProviders.FedEx';
                    UPDATE [EcomShippings] SET [ShippingServiceSystemName] = 'Dynamicweb.Ecommerce.ShippingProviders.GLS.GLS', [ShippingServiceParameters] = REPLACE([ShippingServiceParameters],'"Dynamicweb.eCommerce.Cart.ShippingProviders.GLS"','"Dynamicweb.Ecommerce.ShippingProviders.GLS.GLS"') WHERE [ShippingServiceSystemName] = 'Dynamicweb.eCommerce.Cart.ShippingProviders.GLS';
                    UPDATE [EcomShippings] SET [ShippingServiceSystemName] = 'Dynamicweb.Ecommerce.ShippingProviders.PostDanmark.PostDanmark', [ShippingServiceParameters] = REPLACE([ShippingServiceParameters],'"Dynamicweb.eCommerce.Cart.ShippingProviders.PostDanmark"','"Dynamicweb.Ecommerce.ShippingProviders.PostDanmark.PostDanmark"') WHERE [ShippingServiceSystemName] = 'Dynamicweb.eCommerce.Cart.ShippingProviders.PostDanmark';
                    UPDATE [EcomShippings] SET [ShippingServiceSystemName] = 'Dynamicweb.Ecommerce.ShippingProviders.PostDanmarkServicePoint.PostDanmarkServicePoint', [ShippingServiceParameters] = REPLACE([ShippingServiceParameters],'"Dynamicweb.eCommerce.Cart.ShippingProviders.PostDanmarkServicePoint"','"Dynamicweb.Ecommerce.ShippingProviders.PostDanmarkServicePoint.PostDanmarkServicePoint"') WHERE [ShippingServiceSystemName] = 'Dynamicweb.eCommerce.Cart.ShippingProviders.PostDanmarkServicePoint';
                    UPDATE [EcomShippings] SET [ShippingServiceSystemName] = 'Dynamicweb.Ecommerce.ShippingProviders.Unifaun.Unifaun', [ShippingServiceParameters] = REPLACE([ShippingServiceParameters],'"Dynamicweb.eCommerce.Cart.ShippingProviders.Unifaun"','"Dynamicweb.Ecommerce.ShippingProviders.Unifaun.Unifaun"') WHERE [ShippingServiceSystemName] = 'Dynamicweb.eCommerce.Cart.ShippingProviders.Unifaun';
                    UPDATE [EcomShippings] SET [ShippingServiceSystemName] = 'Dynamicweb.Ecommerce.ShippingProviders.UPS.UPS', [ShippingServiceParameters] = REPLACE([ShippingServiceParameters],'"Dynamicweb.eCommerce.Cart.ShippingProviders.UPS"','"Dynamicweb.Ecommerce.ShippingProviders.UPS.UPS"') WHERE [ShippingServiceSystemName] = 'Dynamicweb.eCommerce.Cart.ShippingProviders.UPS';
                    UPDATE [EcomShippings] SET [ShippingServiceSystemName] = 'Dynamicweb.Ecommerce.ShippingProviders.USPS.USPS', [ShippingServiceParameters] = REPLACE([ShippingServiceParameters],'"Dynamicweb.eCommerce.Cart.ShippingProviders.USPS"','"Dynamicweb.Ecommerce.ShippingProviders.USPS.USPS"') WHERE [ShippingServiceSystemName] = 'Dynamicweb.eCommerce.Cart.ShippingProviders.USPS';
                </sql>
            </EcomShippings>
            <EcomAddressValidatorSettings>
                <sql conditional="">
                    UPDATE [EcomAddressValidatorSettings] SET [AddressValidatorProviderSettings] = REPLACE([AddressValidatorProviderSettings],'"Dynamicweb.eCommerce.Cart.ShippingProviders.AddressValidation.FedexAddressValidationProvider"','"Dynamicweb.Ecommerce.ShippingProviders.FedEx.FedexAddressValidationProvider"');
                </sql>
            </EcomAddressValidatorSettings>
        </database>
    </package>

    <package version="2003" date="19-04-2016">
        <database file="Ecom.mdb">
	        <EcomTaxSettings>
                <sql conditional="">
                    UPDATE [EcomTaxSettings] SET [TaxSettingProviderSettings] = REPLACE([TaxSettingProviderSettings],'"Dynamicweb.Ecommerce.TaxProviders.AvalaraTaxProvider"','"Dynamicweb.Ecommerce.TaxProviders.AvalaraTaxProvider.AvalaraTaxProvider"');
                    UPDATE [EcomTaxSettings] SET [TaxSettingProviderSettings] = REPLACE([TaxSettingProviderSettings],'"Dynamicweb.Ecommerce.TaxProviders.EcomTaxProvider"','"Dynamicweb.Ecommerce.TaxProviders.EcomTaxProvider.EcomTaxProvider"');
                </sql>
            </EcomTaxSettings>
            <EcomAddressValidatorSettings>
                <sql conditional="">
                    UPDATE [EcomAddressValidatorSettings] SET [AddressValidatorProviderSettings] = REPLACE([AddressValidatorProviderSettings],'"Dynamicweb.eCommerce.TaxProviders.AddressValidation.AvalaraAddressValidatorProvider"','"Dynamicweb.Ecommerce.TaxProviders.AvalaraTaxProvider.AvalaraAddressValidatorProvider"');
                </sql>
            </EcomAddressValidatorSettings>
        </database>
    </package>

    <package version="2002" date="18-04-2016">
        <database file="Ecom.mdb">
            <Module>
                <sql conditional="">
                    UPDATE [Module] SET [ModuleName] = 'DataManagement Form' WHERE [ModuleSystemName] = 'DM_Form_Extended';
                    UPDATE [Module] SET [ModuleName] = 'eCom styklister' WHERE [ModuleSystemName] = 'eCom_PartsListsExtended';
                    UPDATE [Module] SET [ModuleName] = 'eCom priser' WHERE [ModuleSystemName] = 'eCom_PricingExtended';
                    UPDATE [Module] SET [ModuleName] = 'eCom salgsrabat' WHERE [ModuleSystemName] = 'eCom_SalesDiscountExtended';
                    UPDATE [Module] SET [ModuleName] = 'Product search' WHERE [ModuleSystemName] = 'eCom_SearchExtended';
                    UPDATE [Module] SET [ModuleName] = 'eCom varianter' WHERE [ModuleSystemName] = 'eCom_VariantsExtended';
                    UPDATE [Module] SET [ModuleName] = 'Extranet' WHERE [ModuleSystemName] = 'UserManagementFrontendExtended';
                    UPDATE [Module] SET [ModuleName] = 'Brugere' WHERE [ModuleSystemName] = 'UserManagementBackendExtended';
                </sql>
            </Module>
        </database>        
    </package>

    <package version="2001" date="16-03-2016">
	    <database file="Ecom.mdb">
            <Module>
                <sql conditional="">
                    delete from Ecom7tree where text like 'Searching'
                </sql>
            </Module>
        </database>
    </package>

    <package version="2000" date="16-03-2016">
        <database file="Ecom.mdb">
            <Module>
                <sql conditional="">
                    UPDATE [Module] SET [ModuleName] = 'Sitemap' WHERE [ModuleSystemName] = 'SitemapV2';
                    UPDATE [Module] SET [ModuleName] = 'Calendar' WHERE [ModuleSystemName] = 'Calendar';
                    UPDATE [Module] SET [ModuleName] = 'News' WHERE [ModuleSystemName] = 'NewsV2';
                    UPDATE [Module] SET [ModuleName] = 'NewsLetter' WHERE [ModuleSystemName] = 'NewsLetterV3';
                    UPDATE [Module] SET [ModuleName] = 'Shopping Cart' WHERE [ModuleSystemName] = 'eCom_CartV2';
                </sql>
            </Module>
        </database>
    </package>

	<package version="512" releasedate="23-10-2016">
        <file name="Payment.html" target="/Files/Templates/eCom7/CheckoutHandler/CyberSource/Payment" source="/Files/Templates/eCom7/CheckoutHandler/CyberSource/Payment" />
    </package>

    <package version="511" releasedate="07-10-2016">
        <database file="Access.mdb">
            <AccessUser>              
	            <sql conditional="">
                    ALTER TABLE [EcomOrders] ALTER COLUMN OrderTransactionCardType [nvarchar](100) NULL
                </sql>
            </AccessUser>
        </database>
    </package>

    <package version="510" releasedate="22-09-2014">
        <file name="LedgerEntryList.html" source="/Files/Templates/eCom/CustomerCenter" target="/Files/Templates/eCom/CustomerCenter"  overwrite="false"/>
        <file name="LedgerEntryDetail.html" source="/Files/Templates/eCom/CustomerCenter" target="/Files/Templates/eCom/CustomerCenter"  overwrite="false"/>
        <file name="NavigationLedgerEntries.html" source="/Files/Templates/eCom/CustomerCenter" target="/Files/Templates/eCom/CustomerCenter"  overwrite="false"/>
        <database file="Ecom.mdb">
            <EcomOrders>
                <sql conditional="">
                    ALTER TABLE [EcomOrders] ADD 
                        [OrderIsLedgerEntry] BIT NOT NULL DEFAULT 0,
                        [OrderIsPayable] BIT NOT NULL DEFAULT 1
                </sql>
            </EcomOrders>
            <EcomNumbers>
                <sql conditional="">
                    IF NOT EXISTS( SELECT NumberID FROM EcomNumbers WHERE ( NumberType = 'LEDGER' ) )
	                    INSERT INTO EcomNumbers ( NumberID, NumberType, NumberDescription, NumberCounter, NumberPrefix, NumberPostFix, NumberAdd, NumberEditable )
	                    VALUES ( '53', 'LEDGERENTRIES', 'Ledger entries', 0, 'LEDGER', '', 1, 0 )
                </sql>
            </EcomNumbers>
            <EcomTree>
                <sql conditional="SELECT COUNT(*) FROM EcomTree WHERE TreeChildPopulate = 'LEDGERENTRIES'">
                    INSERT INTO EcomTree (parentId, Text, Alt, TreeIcon, TreeIconOpen, TreeUrl, TreeChildPopulate, TreeSort, TreeHasAccessModuleSystemName)
                    VALUES(1, 'Ledger', NULL, NULL, NULL, NULL, 'LEDGERENTRIES', 6, NULL)
                </sql>
                <sql conditional="">
                    UPDATE [EcomTree] SET [TreeSort] = [TreeSort] + 1 WHERE ([TreeChildPopulate] = 'RMAS' AND [TreeSort] = 6) OR ([TreeChildPopulate] = 'STAT' AND [TreeSort] = 7)
                </sql>
            </EcomTree>
        </database>
    </package>

    <package version="509" releasedate="19-09-2016">
        <setting key="/Globalsettings/Ecom/ProductLanguageControl/Language/ProductMetaTitle" value="True" overwrite="false" />
        <setting key="/Globalsettings/Ecom/ProductLanguageControl/Variant/ProductMetaTitle" value="True" overwrite="false" />
        <setting key="/Globalsettings/Ecom/ProductLanguageControl/Language/ProductMetaDescription" value="True" overwrite="false" />
        <setting key="/Globalsettings/Ecom/ProductLanguageControl/Variant/ProductMetaDescription" value="True" overwrite="false" />
        <setting key="/Globalsettings/Ecom/ProductLanguageControl/Language/ProductMetaKeywords" value="True" overwrite="false" />
        <setting key="/Globalsettings/Ecom/ProductLanguageControl/Variant/ProductMetaKeywords" value="True" overwrite="false" />
        <setting key="/Globalsettings/Ecom/ProductLanguageControl/Language/ProductMetaUrl" value="True" overwrite="false" />
        <setting key="/Globalsettings/Ecom/ProductLanguageControl/Variant/ProductMetaUrl" value="True" overwrite="false" />
        <setting key="/Globalsettings/Ecom/ProductLanguageControl/Language/ProductMetaCanonical" value="True" overwrite="false" />
        <setting key="/Globalsettings/Ecom/ProductLanguageControl/Variant/ProductMetaCanonical" value="True" overwrite="false" />
    </package>

    <package version="508" date="16-09-2016">
        <database file="Ecom.mdb">
            <EcomStockLocation >
                <sql conditional="">
                    ALTER TABLE [EcomOrderLineFieldGroupRelation] ADD [OrderLineFieldGroupRelationShopID] NVARCHAR(255) NOT NULL DEFAULT ''
                    BEGIN
		                DECLARE @PK_Name NVARCHAR(100) 
		                SELECT @PK_Name = name FROM sys.key_constraints WHERE [type] = 'PK' AND [parent_object_id] = Object_id('EcomOrderLineFieldGroupRelation');

					    IF NOT @PK_Name = ''
			                EXEC('ALTER TABLE [EcomOrderLineFieldGroupRelation] DROP CONSTRAINT ' + @PK_Name)
					END
                    ALTER TABLE [EcomOrderLineFieldGroupRelation] ADD CONSTRAINT [DW_PK_EcomOrderLineFieldGroupRelation] PRIMARY KEY(OrderLineFieldGroupRelationSystemName, OrderLineFieldGroupRelationGroupID, OrderLineFieldGroupRelationShopID)
                </sql>
            </EcomStockLocation>
        </database>
    </package>

    <package version="507" releasedate="12-09-2014">
        <database file="Ecom.mdb">
            <EcomOrders>
                <sql conditional="">
                    ALTER TABLE [EcomOrders] DROP [OrderIsBalanceItem] 
                </sql>
            </EcomOrders>
            <EcomNumbers>
                <sql conditional="">
                    DELETE FROM EcomNumbers WHERE NumberType = 'BALANCE' 
                </sql>
            </EcomNumbers>
            <EcomTree>
                <sql conditional="">
                    DELETE FROM EcomTree WHERE TreeChildPopulate = 'BALANCEITEMS'
                </sql>
            </EcomTree>
        </database>
    </package>

    <package version="506" date="05-09-2016">
        <database file="Ecom.mdb">
            <EcomStockLocation >
                <sql conditional="">
                    ALTER TABLE [EcomStockLocation] DROP CONSTRAINT [EcomStockLocation_PrimaryKey]
                    ALTER TABLE [EcomStockLocation] ALTER COLUMN [StockLocationID] BIGINT NOT NULL
                    ALTER TABLE [EcomStockLocation] ADD CONSTRAINT [EcomStockLocation_PrimaryKey] PRIMARY KEY([StockLocationID])
                </sql>
                <sql conditional="">
                    IF EXISTS(SELECT object_id FROM sys.columns WHERE ( name = 'StockLocationGroupID' ))
	                BEGIN
		                DECLARE @defaultName NVARCHAR(100) 
		                SELECT @defaultName = OBJECT_NAME(default_object_id) FROM sys.columns WHERE ( name = 'StockLocationGroupID' )

					    IF NOT @defaultName = ''
			                EXEC('ALTER TABLE [EcomStockLocation] DROP CONSTRAINT ' + @defaultName)
					END
                    ALTER TABLE [EcomStockLocation] ALTER COLUMN [StockLocationGroupID] BIGINT NOT NULL
                    ALTER TABLE [EcomStockLocation] ADD CONSTRAINT [EcomStockLocation_DefaultValueGroupID] DEFAULT 0 FOR [StockLocationGroupID]                    
                </sql>
            </EcomStockLocation>
            <EcomStockUnit>
                <sql conditional="">
                    ALTER TABLE [EcomStockUnit] ALTER COLUMN [StockUnitStockLocationID] BIGINT NULL
                </sql>
            </EcomStockUnit>
            <EcomShopStockLocationRelation>
                <sql conditional="">
                    ALTER TABLE [EcomShopStockLocationRelation] DROP CONSTRAINT [EcomShopStockLocationRelation$PrimaryKey]
                    ALTER TABLE [EcomShopStockLocationRelation] ALTER COLUMN [ShopRelationStockLocationID] BIGINT NOT NULL
                    ALTER TABLE [EcomShopStockLocationRelation] ADD CONSTRAINT [EcomShopStockLocationRelation$PrimaryKey] PRIMARY KEY(ShopRelationStockLocationID, ShopRelationShopID)
                </sql>
            </EcomShopStockLocationRelation>
            <EcomPrices>
                <sql conditional="">ALTER TABLE [EcomPrices] ALTER COLUMN [PriceStockLocationID] BIGINT NULL</sql>
            </EcomPrices>
            <EcomShops>
                <sql conditional="">ALTER TABLE [EcomShops] ALTER COLUMN [ShopStockLocationID] BIGINT NULL</sql>
            </EcomShops>
        </database>
    </package>

    <package version="505" date="28-08-2016">
        <database file="Ecom.mdb">
            <EcomOrders>                
                <sql conditional="">
                    ALTER TABLE [EcomOrders] ADD [OrderTransactionToken] NVARCHAR(MAX) NULL
                    ALTER TABLE [EcomOrders] ADD [OrderTransactionTokenCheckSum] NVARCHAR(128) NULL
                </sql>
            </EcomOrders>
        </database>
    </package>

    <package version="504" date="04-07-2016">
        <database file="Ecom.mdb">
            <EcomShops>
                <sql conditional="">ALTER TABLE [EcomPrices] ADD [PriceStockLocationID] INT NULL</sql>
            </EcomShops>
        </database>
    </package>

    <package version="503" date="30-06-2016">
        <database file="Ecom.mdb">
            <EcomShops>
                <sql conditional="">ALTER TABLE [EcomShops] ADD [ShopStockLocationID] INT NULL</sql>
            </EcomShops>
        </database>
    </package>

    <package version="502" date="25-04-2016">
        <file name="UnifaunServicePoints.cshtml" source="/Files/Templates/eCom7/ShippingProvider/" target="/Files/Templates/eCom7/ShippingProvider/" overwrite="false"/>
        <file name="UnifaunServicePoints_Ajax.cshtml" source="/Files/Templates/eCom7/ShippingProvider/" target="/Files/Templates/eCom7/ShippingProvider/" overwrite="false"/>
        <file name="GLS.cshtml" source="/Files/Templates/eCom7/ShippingProvider/" target="/Files/Templates/eCom7/ShippingProvider/" overwrite="false"/>
        <file name="PostDanmarkServicePoints.cshtml" source="/Files/Templates/eCom7/ShippingProvider/" target="/Files/Templates/eCom7/ShippingProvider/" overwrite="false"/>
        <file name="PostDanmarkServicePoints_Ajax.cshtml" source="/Files/Templates/eCom7/ShippingProvider/" target="/Files/Templates/eCom7/ShippingProvider/" overwrite="false"/>
        <file name="OneStepCheckout.cshtml" source="/Files/Templates/eCom7/CartV2/Step/" target="/Files/Templates/eCom7/CartV2/Step/" overwrite="false"/>
        <file name="Style.css" source="/Files/Templates/eCom7/ShippingProvider/" target="/Files/Templates/eCom7/ShippingProvider/" overwrite="false"/>
    </package>

    <package version="501" date="13-04-2016">
	    <database file="Ecom.mdb">
	        <Ecom7Tree>
		        <sql conditional="">
                    UPDATE [Ecom7Tree] SET [Text] = 'Loyalty points' WHERE [parentId] = 92 AND [TreeChildPopulate] = 'LOYALTYPOINTS'
                </sql>
		        <sql conditional="">
                    UPDATE [Ecom7Tree] SET [Text] = 'Boosting' WHERE [parentId] = 94 AND [TreeChildPopulate] = 'BOOSTING'
                </sql>
            </Ecom7Tree>
        </database>
    </package>  

    <package version="500" date="08-04-2016">
        <database file="Ecom.mdb">
            <Products>
                <sql conditional="">
                    ALTER TABLE [EcomOrders] ADD [OrderAutoID] IDENTITY NOT NULL
                </sql>
                <sql conditional="">
                    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = N'DW_IX_EcomOrders_AutoId' )
	                    CREATE UNIQUE CLUSTERED INDEX DW_IX_EcomOrders_AutoId 
	                    ON EcomOrders
	                    (
		                    OrderAutoID ASC
	                    )
                </sql>
            </Products>
        </database>
    </package>

    <package version="499" date="11-03-2016">
	    <database file="Ecom.mdb">
            <EcomShippings>
                <sql conditional="">
                    ALTER TABLE [EcomShippings] ADD [ShippingFeeRulesSource] INT NOT NULL CONSTRAINT DW_DF_Shipping_FeeRulesSource DEFAULT 1
                </sql>
                <sql conditional="">
                    UPDATE [EcomShippings] SET [ShippingFeeRulesSource] = 2 WHERE [ShippingServiceSystemName] IS NULL
                </sql>
            </EcomShippings>
        </database>
    </package>

    <package version="498" date="24-02-2016">
        <file name="UnifaunServicePoints.html" source="/Files/Templates/eCom7/ShippingProvider/" target="/Files/Templates/eCom7/ShippingProvider/" overwrite="false"/>
        <file name="UnifaunServicePoints_Ajax.html" source="/Files/Templates/eCom7/ShippingProvider/" target="/Files/Templates/eCom7/ShippingProvider/" overwrite="false"/>
    </package>

    <package version="497" date="12-01-2016">
	    <database file="Dynamic.mdb">
	        <module>
		        <sql conditional="">DELETE FROM [Module] WHERE [ModuleSystemName] = 'eCom_ContextProductRenderer'</sql>
	        </module>
	    </database>
    </package>

    <package version="496" releasedate="16-12-2015">
        <database file="Ecom.mdb">
            <EcomTree>
                <sql conditional="">
                    update [EcomProducts] set [ProductPriceType] = 0 where [ProductPriceType] = 2
                </sql>
            </EcomTree>
        </database>
    </package>    
    
    <package version="495" releasedate="10-12-2015">
        <database file="Ecom.mdb">
            <EcomTree>
                <sql conditional="">
                    DELETE FROM EcomTree WHERE TreeChildPopulate = 'NOTIFICATIONS' AND parentId = 1
                </sql>
            </EcomTree>
        </database>
    </package>

    <package version="494" releasedate="07-12-2015">
        <database file="Ecom.mdb">
            <EcomTree>
                <sql conditional="">
                    ALTER TABLE [EcomNotification] ADD [NotificationCreated] DATETIME NOT NULL DEFAULT GETDATE()
                </sql>
            </EcomTree>
        </database>
    </package>

    <package version="493" date="26-11-2015">
        <database file="Ecom.mdb">
	        <EcomNotification>
		        <sql conditional="SELECT object_id FROM sys.tables WHERE ( name = 'EcomNotification' )">
                    CREATE TABLE EcomNotification
                    (
                        NotificationID INT NOT NULL IDENTITY(1,1),
                        NotificationUserID NVARCHAR(50) NOT NULL,
                        NotificationEmail NVARCHAR(255) NULL,
                        NotificationProductID NVARCHAR(30) NOT NULL,
                        NotificationProductVariantID NVARCHAR(50) NOT NULL,
                        NotificationProductLanguageID NVARCHAR(50) NOT NULL,
                        NotificationProductUnitID NVARCHAR(75) NOT NULL,
                        NotificationContextLanguageID NVARCHAR(50) NOT NULL,
                        NotificationContextAreaID INT NOT NULL,
                        NotificationCreated DATETIME NOT NULL,
                        NotificationSentTime DATETIME NULL,
                        CONSTRAINT DW_PK_EcomNotification PRIMARY KEY CLUSTERED (NotificationID)
                    )
                    CREATE NONCLUSTERED INDEX [DW_IX_EcomNotification_UserID] ON [EcomNotification] ([NotificationUserID])
                    CREATE NONCLUSTERED INDEX [DW_IX_EcomNotification_Email] ON [EcomNotification] ([NotificationEmail])
                    CREATE NONCLUSTERED INDEX [DW_IX_EcomNotification_ProductID_VariantId_LanguageId] ON [EcomNotification] ([NotificationProductID], [NotificationProductVariantID], [NotificationProductLanguageID])
                    CREATE NONCLUSTERED INDEX [DW_IX_EcomNotification_AreaID] ON [EcomNotification] ([NotificationContextAreaID])
                    CREATE NONCLUSTERED INDEX [DW_IX_EcomNotification_Created] ON [EcomNotification] ([NotificationCreated])
                    CREATE NONCLUSTERED INDEX [DW_IX_EcomNotification_SentTime] ON [EcomNotification] ([NotificationSentTime])
                </sql>
            </EcomNotification>
        </database>
        <file name="ProductNotification.html" source="/Files/Templates/eCom/Product" target="/Files/Templates/eCom/Product"  overwrite="false"/>
    </package>

    <package version="492" releasedate="20-11-2015">
        <file name="ProductVariantGroupProperties.html" source="/Files/Templates/eCom/Product" target="/Files/Templates/eCom/Product"  overwrite="false"/>
    </package>
    
    <package version="491" releasedate="17-11-2015">
        <database file="Ecom.mdb">
            <EcomShopLanguageRelation>
                <sql conditional="">
                    WITH t AS (
	                    SELECT eslr.*, ROW_NUMBER() OVER(PARTITION BY eslr.ShopID ORDER BY ShopID) AS rn
	                    FROM EcomShopLanguageRelation eslr
	                    )
                    UPDATE EcomShopLanguageRelation
                    SET EcomShopLanguageRelation.IsDefault = 1
                    FROM (
	                    SELECT t.ShopID, t.LanguageID, t.ID
	                    FROM t
		                    JOIN (
			                    SELECT ShopID
			                    FROM EcomShopLanguageRelation
			                    GROUP by ShopID
			                    HAVING MAX(CAST(IsDefault AS INT)) = 0
			                    ) AS t2 ON t2.ShopID = t.ShopID
	                    WHERE t.rn = 1
                    ) t3
                    WHERE 
	                    EcomShopLanguageRelation.ShopID = t3.ShopID AND
	                    EcomShopLanguageRelation.LanguageID = t3.LanguageID AND
	                    EcomShopLanguageRelation.ID = t3.ID
                </sql>
            </EcomShopLanguageRelation>
        </database>
    </package>

    <package version="490" date="05-11-2015">
        <database file="Ecom.mdb">
	        <EcomVariantGroupProperty>
		        <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.tables WHERE ( name = 'EcomVariantGroupProperty' ) )
                        CREATE TABLE EcomVariantGroupProperty
                        (
                            VariantGroupPropertyID NVARCHAR(50) NOT NULL,
                            VariantGroupPropertyGroupID NVARCHAR(255) NOT NULL,
                            VariantGroupPropertyName NVARCHAR(255) NULL,
                            VariantGroupPropertySystemName NVARCHAR(255) NULL,
                            CONSTRAINT DW_PK_VariantGroupProperties PRIMARY KEY CLUSTERED (VariantGroupPropertyID ASC)
                        )
                </sql>
            </EcomVariantGroupProperty>
	        <EcomVariantGroupOptionPropertyValue>
		        <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.tables WHERE ( name = 'EcomVariantGroupOptionPropertyValue' ) )
                        CREATE TABLE EcomVariantGroupOptionPropertyValue
                        (
                            VariantGroupOptionPropertyValueOptionID NVARCHAR(50) NOT NULL,
                            VariantGroupOptionPropertyValuePropertyID NVARCHAR(50) NOT NULL,
                            VariantGroupOptionPropertyValueLanguageID NVARCHAR(50) NOT NULL,
                            VariantGroupOptionPropertyValue NVARCHAR(255) NULL,
                            CONSTRAINT DW_PK_VariantGroupOptionPropertyValues PRIMARY KEY CLUSTERED (VariantGroupOptionPropertyValueOptionID,VariantGroupOptionPropertyValuePropertyID,VariantGroupOptionPropertyValueLanguageID ASC)
                        )
                </sql>
            </EcomVariantGroupOptionPropertyValue>
        </database>
    </package>
    
    <package version="489" releasedate="26-10-2015">
        <file name="InformationSavedCardsAndRecurring.html" source="/Files/Templates/eCom7/CartV2/Step" target="/Files/Templates/eCom7/CartV2/Step"  overwrite="false"/>
    </package>

    <package version="488" date="26-10-2015">
	    <database file="Ecom.mdb">
            <EcomShippings>
                <sql conditional="">
                    ALTER TABLE [EcomShippings] ADD 
                    [ShippingLimitsUseLogic] INT NOT NULL CONSTRAINT DW_DF_Shipping_LimitsUseLogic DEFAULT 2
                </sql>
            </EcomShippings>
        </database>
    </package>
    <package version="487" date="22-10-2015">
	    <database file="Dynamic.mdb">
            <EcomNumbers>
                <sql conditional="">
                    IF NOT EXISTS( SELECT NumberID FROM EcomNumbers WHERE ( NumberType = 'REC' ) )
	                    INSERT INTO EcomNumbers ( NumberID, NumberType, NumberDescription, NumberCounter, NumberPrefix, NumberPostFix, NumberAdd, NumberEditable )
	                    VALUES ( '52', 'REC', 'Recurring Orders', 0, 'REC', '', 1, 0 )
                </sql>
            </EcomNumbers> 
	    </database>
    </package>
    <package version="486" date="21-10-2015">
	    <database file="Dynamic.mdb">
	        <module>
		        <sql conditional="">DELETE FROM [Module] WHERE [ModuleSystemName] = 'eCom_C5Integration'</sql>
	        </module>
	    </database>
    </package>

    <package version="485" date="16-10-2015">
	    <database file="Ecom.mdb">
	        <AccessUserCard>
		        <sql conditional="">
                    ALTER TABLE [AccessUserCard] ADD
	                    [AccessUserCardIsDefault] bit NOT NULL CONSTRAINT DW_DF_AccessUserCard_IsDefault DEFAULT 0
                </sql>
	        </AccessUserCard>
	    </database>
    </package>
    <package version="484" date="16-10-2015">
	    <database file="Ecom.mdb">
	        <Module>
		        <sql conditional="SELECT COUNT(*) FROM [Module] WHERE [ModuleSystemName] = 'eCom_C5Integration'">
                    UPDATE [Module] SET ModuleAccess = 0, ModuleDeprecated = 1, ModuleHiddenMode = 1 WHERE [ModuleSystemName] = 'eCom_C5Integration'
		        </sql>
	        </Module>
	    </database>
    </package>
    <package version="483" date="15-10-2015">
	    <database file="Ecom.mdb">
	        <Module>
		        <sql conditional="SELECT COUNT(*) FROM [Module] WHERE [ModuleSystemName] = 'eCom_C5Integration'">
                    UPDATE [Module] SET ModuleAccess = 0 WHERE [ModuleSystemName] = 'eCom_C5Integration'
		        </sql>
	        </Module>
	    </database>
    </package>
    <package version="482" date="09-08-2015">
	    <database file="Ecom.mdb">
	        <AccessUserCard>
		        <sql conditional="">
                   alter table EcomOrders add  OrderIsRecurringOrderTemplate bit		        
		        </sql>
	        </AccessUserCard>
	    </database>
    </package>
        <package version="481" date="09-08-2015">
	    <database file="Ecom.mdb">
	        <AccessUserCard>
		        <sql conditional="select count(*) from [Module] where ModuleSystemName='eCom_RecurringOrders'">
                    Insert into [Module] ([ModuleSystemName],[ModuleName],[ModuleAccess],[ModuleParagraph],[ModuleSearch],[ModuleIsBeta] )values ('eCom_RecurringOrders','Recurring Orders',1,0,0,0)
		        </sql>
	        </AccessUserCard>
	    </database>
    </package>
        <package version="480" date="09-08-2015">
	    <database file="Ecom.mdb">
	        <AccessUserCard>
		        <sql conditional="select count(*) from EcomTree where TreeChildPopulate='RECURRINGORDERS'">
                    Insert into ecomtree ([Parentid],[TEXT],[TreeChildPopulate],[TreeSort],[TreeHasAccessModuleSystemName] )values (1,'Recurring orders','RECURRINGORDERS',5,'eCom_RecurringOrders')
		        </sql>
	        </AccessUserCard>
	    </database>
    </package>
    <package version="479" date="09-08-2015">
	    <database file="Ecom.mdb">
	        <AccessUserCard>
		        <sql conditional="select count(*) from EcomTree where Treesort=7 and TreeChildPopulate='STAT'">
                    update ecomtree set treesort=7 where treesort=6 and Treechildpopulate='STAT'
		        </sql>
	        </AccessUserCard>
	    </database>
    </package>

    <package version="478" date="09-08-2015">
	    <database file="Ecom.mdb">
	        <AccessUserCard>
		        <sql conditional="select count(*) from EcomTree where Treesort=6 and TreeChildPopulate='RMAS'">
	                update ecomtree set treesort=6 where treesort=5 and Treechildpopulate='RMAS'
		        </sql>
	        </AccessUserCard>
	    </database>
    </package>

      <package version="477" date="24-09-2015">
	    <database file="Ecom.mdb">
            <Module>
                <sql conditional="SELECT COUNT(*) FROM [Module] WHERE [ModuleSystemName] = 'GiftCards' AND ModuleParagraph = 0">
                    UPDATE [Module] SET ModuleParagraph = 0 WHERE [ModuleSystemName] = 'GiftCards' AND ModuleParagraph = 1
                </sql>
            </Module>
	    </database>
      </package>

      <package version="476" date="22-09-2015">
	    <database file="Ecom.mdb">
	      <EcomShippings>
		    <sql conditional="">
                ALTER TABLE [EcomShippings] ADD [ShippingIcon] NVARCHAR(255) NULL
		    </sql>
	      </EcomShippings>
	    </database>
      </package>

    <package version="475" releasedate="04-09-2015">
        <file name="Post_custom.html" target="/Files/Templates/eCom7/CheckoutHandler/Stripe/Post" source="/Files/Templates/eCom7/CheckoutHandler/Stripe/Post" />
        <file name="Post_simple.html" target="/Files/Templates/eCom7/CheckoutHandler/Stripe/Post" source="/Files/Templates/eCom7/CheckoutHandler/Stripe/Post" />
        <file name="checkouthandler_error.html" target="/Files/Templates/eCom7/CheckoutHandler/Stripe/Error" source="/Files/Templates/eCom7/CheckoutHandler/Stripe/Error" />
    </package>    

    <package version="474" releasedate="27-08-2015">
        <file name="SavedCardLog.html" source="/Files/Templates/eCom/CustomerCenter" target="/Files/Templates/eCom/CustomerCenter"  overwrite="false"/>
    </package>

    <package version="473" releasedate="26-08-2015">
	    <database file="Ecom.mdb">
            <EcomOrders>
		        <sql conditional="">
                    ALTER TABLE [EcomOrders] ADD [OrderSavedCardID] INT NULL                                       
		        </sql>
            </EcomOrders>
        </database>
        <file name="InformationSavedCards.html" source="/Files/Templates/eCom7/CartV2/Step" target="/Files/Templates/eCom7/CartV2/Step"  overwrite="false"/>
        <file name="Payment_confirmation.html" source="/Files/Templates/eCom7/CheckoutHandler/ChargeLogic/Payment" target="/Files/Templates/eCom7/CheckoutHandler/ChargeLogic/Payment"  overwrite="false"/>
    </package>

    <package version="472" date="24-08-2015">
	    <database file="Ecom.mdb">
	        <AccessUserCard>
		        <sql conditional="">
                    ALTER TABLE [AccessUserCard] ALTER COLUMN AccessUserCardCheckSum NVARCHAR(128)
                </sql>
	        </AccessUserCard>
	    </database>
    </package>

    <package version="471" date="24-08-2015">
	    <database file="Ecom.mdb">
	        <AccessUserCard>
		        <sql conditional="">
                    ALTER TABLE [AccessUserCard] ADD [AccessUserCardCheckSum] NVARCHAR(50) NULL
                </sql>
	        </AccessUserCard>
	    </database>
    </package>

    <package version="470" date="24-08-2015">
        <file name="SavedCardList.html" source="/Files/Templates/eCom/CustomerCenter" target="/Files/Templates/eCom/CustomerCenter"  overwrite="false"/>
        <file name="NavigationSavedCards.html" source="/Files/Templates/eCom/CustomerCenter" target="/Files/Templates/eCom/CustomerCenter"  overwrite="false"/>
    </package>

    <package version="469" date="13-08-2015">
	    <database file="Ecom.mdb">
	        <EcomProductsRelated>
		        <sql conditional="">
                    ALTER TABLE [EcomProductsRelated]  ADD [ProductRelatedLimitVariant] NVARCHAR(MAX) NULL                        
                </sql>
	        </EcomProductsRelated>
	    </database>
    </package>

    <package version="468" releasedate="10-08-2015">
	    <database file="Ecom.mdb">
            <AccessUserCard>
		        <sql conditional="">   
                    ALTER TABLE [AccessUserCard] ADD [AccessUserCardUsedDate] DATETIME NOT NULL DEFAULT GETDATE()  
		        </sql>
            </AccessUserCard>
        </database>
    </package>

    <package version="467" date="20-07-2015">
        <file name="OrderListRecurring.html" source="/Files/Templates/eCom/CustomerCenter" target="/Files/Templates/eCom/CustomerCenter"  overwrite="false"/>
        <file name="PrintOrderRecurring.html" source="/Files/Templates/eCom/CustomerCenter" target="/Files/Templates/eCom/CustomerCenter"  overwrite="false"/>
        <file name="RecurringOrderList.html" source="/Files/Templates/eCom/CustomerCenter" target="/Files/Templates/eCom/CustomerCenter"  overwrite="false"/>
        <file name="RecurringOrderDetails.html" source="/Files/Templates/eCom/CustomerCenter" target="/Files/Templates/eCom/CustomerCenter"  overwrite="false"/>
        <file name="NavigationRecurringOrders.html" source="/Files/Templates/eCom/CustomerCenter" target="/Files/Templates/eCom/CustomerCenter"  overwrite="false"/>        
        <file name="recurringOrder.png" source="/Files/Templates/eCom/CustomerCenter/Images" target="/Files/Templates/eCom/CustomerCenter/Images" overwrite="false" />
    </package>

    <package version="466" releasedate="13-07-2015">
	    <database file="Ecom.mdb">
            <EcomRecurringOrders>
		        <sql conditional="">   
                    ALTER TABLE [EcomRecurringOrder] ADD [RecurringOrderLastDelivery] DATETIME NULL    
		        </sql>
            </EcomRecurringOrders>
        </database>
    </package>

    <package version="465" releasedate="13-17-2015">
	    <database file="Ecom.mdb">
            <EcomFees>
		        <sql conditional="">
                    update [EcomFees] set [FeeOrderPrice] = 0 where [FeeOrderPrice] &lt; 0 and [FeeMethod] = 'SHIP'
		        </sql>
            </EcomFees>
        </database>
    </package>

    <package version="464" releasedate="08-07-2015">
	    <database file="Ecom.mdb">
            <EcomRecurringOrders>
		        <sql conditional="">
                    ALTER TABLE [EcomOrders] ADD [OrderPaymentRecurringInfo] NVARCHAR(MAX) NULL    
                    ALTER TABLE [EcomRecurringOrder] DROP [RecurringOrderPaymentRecurringInfo], [RecurringOrderPaymentID], [RecurringOrderLanguageID]                                    
		        </sql>
            </EcomRecurringOrders>
        </database>
    </package>

    <package version="463" date="07-07-2015">
        <database file="Ecom.mdb">
	        <EcomRecurringOrders>
		        <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.tables WHERE ( name = 'EcomRecurringOrder' ) )
                        CREATE TABLE EcomRecurringOrder
                        (
                            RecurringOrderId INT NOT NULL IDENTITY(1,1),
                            RecurringOrderUserID INT NOT NULL,
                            RecurringOrderBaseOrderID NVARCHAR(50) NULL,
                            RecurringOrderStartDate DATETIME NULL,
                            RecurringOrderEndDate DATETIME NULL,
                            RecurringOrderInterval INT NOT NULL,
                            RecurringOrderIntervalUnit INT NOT NULL,
                            RecurringOrderCanceledDeliveries NVARCHAR(MAX) NULL,
                            RecurringOrderPaymentRecurringInfo NVARCHAR(MAX) NULL,
                            RecurringOrderPaymentID NVARCHAR(50) NULL,
                            RecurringOrderLanguageID NVARCHAR(50) NULL,
                            CONSTRAINT DW_PK_RecurringOrders PRIMARY KEY CLUSTERED (RecurringOrderId ASC)
                        )
                </sql>
                <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_RecurringOrder_UserID] ON [EcomRecurringOrder] ([RecurringOrderUserID] ASC)
                    CREATE NONCLUSTERED INDEX [DW_IX_RecurringOrder_BaseOrderID] ON [EcomRecurringOrder] ([RecurringOrderBaseOrderID] ASC)
                </sql>
            </EcomRecurringOrders>
            <EcomOrders>
                <sql conditional="">
                    ALTER TABLE [EcomOrders] ADD [OrderRecurringOrderId] INT NULL
                </sql>
            </EcomOrders>
        </database>
        <file name="InformationRecurringOrders.html" target="/Files/Templates/eCom7/CartV2/Step" source="/Files/Templates/eCom7/CartV2/Step" />
        <file name="ReceiptRecurringOrders.html" target="/Files/Templates/eCom7/CartV2/Step" source="/Files/Templates/eCom7/CartV2/Step" />
    </package>
    
    <package version="462" releasedate="02-07-2015">
        <database file="Ecom.mdb">
            <ProductCategories>
                <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_EcomProductCategoryFieldValue_FieldValue_ProductId_VariantId_LanguageId]
                    ON [EcomProductCategoryFieldValue] ([FieldValueProductId], [FieldValueProductVariantId], [FieldValueProductLanguageId])
                    INCLUDE ([FieldValueFieldId], [FieldValueFieldCategoryId], [FieldValueValue])
                </sql>
            </ProductCategories>
        </database>
    </package>

    <package version="461" date="30-06-2015">
        <database file="Ecom.mdb">
            <EcomCustomerFavoriteLists>
                <sql conditional="">ALTER TABLE [EcomCustomerFavoriteLists] ADD 
                                                [IsPublished] BIT NOT NULL DEFAULT 0,
                                                [PublishedToDate] DATETIME NULL,
                                                [Type] NVARCHAR(255),
                                                [IsDefault] BIT NOT NULL DEFAULT 0,
                                                [Description] NVARCHAR(MAX),
                                                [PublishedId] NVARCHAR(255)
                </sql>
            </EcomCustomerFavoriteLists>
            <EcomCustomerFavoriteProducts>
                <sql conditional="">ALTER TABLE [EcomCustomerFavoriteProducts] ADD 
                                                [Quantity] INT NULL,
                                                [SortOrder] INT NULL
                </sql>
            </EcomCustomerFavoriteProducts>
        </database>
    </package>

    <package version="460" releasedate="30-06-2015">
        <database file="Ecom.mdb">
            <EcomOrders>
                <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_EcomProducts_ExcludeFromIndex] ON [EcomProducts] ([ProductExcludeFromIndex]) INCLUDE ([ProductID])
                </sql>
                <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_EcomProductCategoryFieldValue_CategoryId_ProductId] ON [EcomProductCategoryFieldValue] ([FieldValueFieldCategoryId], [FieldValueProductId]) 
                </sql>
            </EcomOrders>
        </database>
    </package>

    <package version="459" releasedate="29-06-2015">
        <database file="Ecom.mdb">
            <EcomShippings>
                <sql conditional="">
                    ALTER TABLE [EcomOrders] ADD [OrderShippingFeeRuleName] NVARCHAR(255) NULL
                </sql>
            </EcomShippings>
        </database>
    </package>

    <package version="458" date="23-06-2015">
    </package>

    <package version="457" date="19-06-2015">
	    <database file="Ecom.mdb">
	        <AccessUserCard>
		        <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.tables WHERE ( name = 'AccessUserCard' ) )
                        CREATE TABLE AccessUserCard
                        (
                            AccessUserCardId INT NOT NULL IDENTITY(1,1),
                            AccessUserCardUserID INT NOT NULL ,
                            AccessUserCardName NVARCHAR(50) NOT NULL,
                            AccessUserCardType NVARCHAR(20) NOT NULL,
                            AccessUserCardIdentifier NVARCHAR(20) NOT NULL,
                            AccessUserCardToken NVARCHAR(MAX) NOT NULL,
                            AccessUserCardPaymentID NVARCHAR(50) NOT NULL,
                            AccessUserCardLanguageID NVARCHAR(50) NOT NULL,
                            AccessUserCardUsedDate DATETIME NOT NULL DEFAULT GETDATE(),
                            CONSTRAINT DW_PK_AccessUserCard PRIMARY KEY CLUSTERED (AccessUserCardId ASC)
                        )
                </sql>
                <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_AccessUserCard_UserID] ON [AccessUserCard] ([AccessUserCardUserID] ASC)
                </sql>
            </AccessUserCard>            
        </database>
    </package>

    <package version="456" releasedate="11-06-2015">
        <database file="Ecom.mdb">
            <EcomGiftCardTransaction>
                <sql conditional="">
                    ALTER TABLE [EcomGiftCardTransaction] ADD [GiftCardTransactionOrderLineId] NVARCHAR(50) NOT NULL DEFAULT ''
                </sql>
            </EcomGiftCardTransaction>
        </database>
    </package>

    <package version="455" date="03-06-2015">
        <file name="InformationWithStatesGiftCards.html" target="/Files/Templates/eCom7/CartV2/Step" source="/Files/Templates/eCom7/CartV2/Step" />
    </package>

    <package version="454" releasedate="03-06-2015">
        <database file="Ecom.mdb">
            <EcomOrders>
                <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_EcomOrders_CustomerAccessUserID] 
                    ON [EcomOrders] ([OrderCustomerAccessUserID] ASC)
                </sql>
                <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_EcomOrders_CompletedDate] 
                    ON [EcomOrders] ([OrderCompletedDate] ASC)
                </sql>
            </EcomOrders>
        </database>
    </package>

    <package version="453" date="01-06-2014">
	    <database file="Ecom.mdb">
            <EcomShippings>
                <sql conditional="">
                    ALTER TABLE [EcomShippings] ADD 
                    [ShippingFeeSelection] NVARCHAR(10) NULL
                </sql>
            </EcomShippings>
	        <EcomFees>
		        <sql conditional="">
                    ALTER TABLE EcomFees ADD
                     [FeeName] NVARCHAR(255) NULL,
                     [FeeActive] BIT NOT NULL CONSTRAINT DW_DF_Fee_Active DEFAULT 1,
	                 [FeeValidFrom] DATETIME NULL,
	                 [FeeValidTo] DATETIME NULL,
	                 [FeeAccessUserId] INT NULL,
	                 [FeeAccessUserGroupId] INT NULL,
                     [FeeAccessUserCustomerNumber] NVARCHAR(255) NULL,
                     [FeeShopId]  NVARCHAR(255) NULL, 
                     [FeeProductsAndGroups] NVARCHAR(MAX) NOT NULL CONSTRAINT DW_DF_Fee_ProductsAndGroups DEFAULT '[all]',
	                 [FeeOrderContextId] NVARCHAR(50) NULL,
                     [FeeCurrencyCode] NVARCHAR(3) NULL,
                     [FeeZip] NVARCHAR(MAX) NULL
		        </sql>
	        </EcomFees>
        </database>
    </package>
    
   <package version="452" date="21-05-2015">
    <database file="Ecom.mdb">
        <Ecom7Tree>
                <sql conditional="SELECT TOP 1 [id] FROM [Ecom7Tree] WHERE [Text] = 'GiftCards'">                    
                    INSERT INTO [Ecom7Tree]
                    (
                        [ParentId],
                        [Text],
                        [Alt],
                        [TreeIcon],
                        [TreeUrl],
                        [TreeChildPopulate],
                        [TreeSort],
                        [TreeHasAccessModuleSystemName]
                    )
                    VALUES
                    (
                        92,
                        'GiftCards',
                        NULL,
                        '/Admin/Module/eCom_Catalog/images/buttons/btn_giftcard.gif',
                        '/Admin/Module/eCom_Catalog/dw7/GiftCards/GiftCardsList.aspx',
                        'GIFTCARDS',
                        43,
                        'eCom_CartV2'
                    ),
                    (
                        94,
                        'GiftCards',
                        NULL,
                        '/Admin/Module/eCom_Catalog/images/buttons/btn_giftcard.gif',
                        '/Admin/Module/eCom_Catalog/dw7/GiftCards/GiftCardsAdvancedSettings.aspx',
                        'GIFTCARDS',
                        74,
                        'eCom_CartV2'
                    )
                </sql>
        </Ecom7Tree>
        <Module>
            <sql conditional="SELECT COUNT(*) FROM [Module] WHERE [ModuleSystemName] = 'GiftCards'">
                INSERT INTO [Module] (ModuleSystemName,  ModuleName, ModuleIsBeta, ModuleAccess, ModuleParagraph, ModuleEcomNotInstalledAccess)
                VALUES               ('GiftCards'     , 'GiftCards',            0,            1,               0,                            0)
            </sql>
        </Module>
    </database>
   </package>

    <package version="451" releasedate="20-05-2015">
        <database file="Ecom.mdb">
            <EcomOrderDiscount>
                <sql conditional="">
                    ALTER TABLE [EcomOrders] ALTER COLUMN [OrderVoucherCode] [nvarchar(max)] NULL
                </sql>
            </EcomOrderDiscount>
        </database>
    </package>

    <package version="450" releasedate="19-05-2015">
        <database file="Ecom.mdb">
            <EcomOrders>
                <sql conditional="">
                    ALTER TABLE [EcomOrders] ADD [OrderGiftcardTransactionFailed] BIT NOT NULL DEFAULT 0
                </sql>
            </EcomOrders>
        </database>
    </package>

    <package version="449" releasedate="19-05-2015">
        <database file="Ecom.mdb">
            <EcomOrderLines>
                <sql conditional="">
                    ALTER TABLE [EcomOrderLines] ADD [OrderLineGiftCardCode] NVARCHAR(MAX) NULL
                </sql>
            </EcomOrderLines>
        </database>
    </package>

    <package version="448" releasedate="14-05-2015">
        <database file="Ecom.mdb">
            <EcomProducts>
                <sql conditional="">
                     ALTER TABLE [EcomProductCategoryFieldGroupValue] DROP CONSTRAINT [EcomProductCategoryFieldGroupValue$GroupForeignKey]
                </sql>
                <sql conditional="">
                     ALTER TABLE [EcomProductCategoryFieldGroupValue] DROP CONSTRAINT [EcomProductCategoryFieldGroupValue$CategoryFieldForeignKey]
                </sql>
            </EcomProducts>
        </database>
    </package>
    
    <package version="447" date="14-05-2015">
	    <database file="Ecom.mdb">
	        <EcomGiftCard>
		        <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.tables WHERE ( name = 'EcomGiftCard' ) )
                        CREATE TABLE EcomGiftCard
                        (
                            GiftCardAutoId BIGINT NOT NULL IDENTITY(1,1),
                            GiftCardId NVARCHAR(50) NOT NULL ,
                            GiftCardName NVARCHAR(MAX) NOT NULL,
                            GiftCardCode NVARCHAR(MAX) NOT NULL,
                            GiftCardExpiryDate DATETIME NOT NULL DEFAULT GETDATE(),
                            GiftCardCurrency NVARCHAR(10) NULL DEFAULT NULL,
                            CONSTRAINT DW_PK_EcomGiftCard PRIMARY KEY CLUSTERED (GiftCardId ASC),
                        )
                </sql>
            </EcomGiftCard>            
            <EcomNumbers>
                <sql conditional="">
                    IF NOT EXISTS( SELECT NumberID FROM EcomNumbers WHERE ( NumberType = 'GIFTCARD' ) )
	                    INSERT INTO EcomNumbers ( NumberID, NumberType, NumberDescription, NumberCounter, NumberPrefix, NumberPostFix, NumberAdd, NumberEditable )
	                    VALUES ( '51', 'GIFTCARD', 'Gift Cards', 0, 'GIFTCARD', '', 1, 0 )
                </sql>
            </EcomNumbers>           
            <EcomGiftCardTransaction>
		        <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.tables WHERE ( name = 'EcomGiftCardTransaction' ) )
                        CREATE TABLE EcomGiftCardTransaction
                        (
                            GiftCardTransactionId BIGINT NOT NULL IDENTITY(1,1),
                            GiftCardTransactionAmount FLOAT NOT NULL,
                            GiftCardTransactionOrderId NVARCHAR(50) NOT NULL,
                            GiftCardTransactionGiftCardId NVARCHAR(50) NULL DEFAULT NULL,
                            GiftCardTransactionDate DATETIME NOT NULL DEFAULT GETDATE(),
                            CONSTRAINT DW_PK_EcomGiftCardTransaction PRIMARY KEY CLUSTERED (GiftCardTransactionId ASC),
                        )
                </sql>
            </EcomGiftCardTransaction> 
        </database>
        <file name="ProductGiftCard.html" target="/Files/Templates/eCom/Product" source="/Files/Templates/eCom/Product" />
        <file name="ProductListGiftCard.html" target="/Files/Templates/eCom/ProductList" source="/Files/Templates/eCom/ProductList" />
        <file name="ReceiptGiftCard.html" target="/Files/Templates/eCom7/CartV2/Step" source="/Files/Templates/eCom7/CartV2/Step" />
    </package>

    <package version="446" releasedate="23-04-2015">
	    <database file="Ecom.mdb">
	        <EcomProducts>
                <sql conditional="">
                    CREATE TABLE [EcomProductCategoryFieldGroupValue](
	                    [FieldValueFieldId] [nvarchar](255) NOT NULL,
	                    [FieldValueFieldCategoryId] [nvarchar](50) NOT NULL,
	                    [FieldValueGroupId] [nvarchar](255) NOT NULL,
	                    [FieldValueGroupLanguageId] [nvarchar](50) NOT NULL,
	                    [FieldValueValue] [nvarchar](max) NULL,
                     CONSTRAINT [EcomProductCategoryFieldGroupValue$PrimaryKey] PRIMARY KEY CLUSTERED 
                    (
	                    [FieldValueFieldId] ASC,
	                    [FieldValueFieldCategoryId] ASC,
	                    [FieldValueGroupId] ASC,
	                    [FieldValueGroupLanguageId] ASC
                    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
                    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
                </sql>
                <sql conditional="">
                    ALTER TABLE [EcomProductCategoryFieldGroupValue]  WITH CHECK ADD  CONSTRAINT [EcomProductCategoryFieldGroupValue$CategoryFieldForeignKey] FOREIGN KEY([FieldValueFieldId], [FieldValueFieldCategoryId])
                    REFERENCES [EcomProductCategoryField] ([FieldId], [FieldCategoryId])
                </sql>
                <sql conditional="">
                    ALTER TABLE [EcomProductCategoryFieldGroupValue]  WITH CHECK ADD  CONSTRAINT [EcomProductCategoryFieldGroupValue$GroupForeignKey] FOREIGN KEY([FieldValueGroupId], [FieldValueGroupLanguageId])
                    REFERENCES [EcomGroups] ([GroupID], [GroupLanguageID])
                </sql>
                <sql conditional="">
                    ALTER TABLE EcomGroupRelations ADD GroupRelationsInheritCategories bit NOT NULL CONSTRAINT DF_EcomGroupRelations_GroupRelationsInheritCategories DEFAULT 0
                </sql>
	        </EcomProducts>
        </database>
    </package>

    <package version="445" date="21-04-2015">
    <database file="Ecom.mdb">
        <EcomGlobalISO>
            <sql conditional="">
                UPDATE EcomGlobalISO SET [ISOCode3] = 'ROU' WHERE ISOID = '171' AND [ISOCode3] = 'ROM'
            </sql>
        </EcomGlobalISO>
    </database>
    </package>

    <package version="444" releasedate="10-04-2015">
        <database file="Ecom.mdb">
            <EcomOrderDiscount>
                <sql conditional="">
                    update [EcomDiscount] set DiscountOrderContextId = NULL where DiscountOrderContextId not in (select d.DiscountOrderContextId from [EcomDiscount] d
                        join [EcomOrderContexts] c on c.OrderContextID = d.DiscountOrderContextId)
                </sql>
                <sql conditional="">
                    ALTER TABLE [EcomDiscount] ADD CONSTRAINT
	                    FK_EcomDiscount_EcomOrderContexts FOREIGN KEY ([DiscountOrderContextId]) REFERENCES [EcomOrderContexts] ([OrderContextID])
                         ON UPDATE  NO ACTION 
	                     ON DELETE  SET NULL 
                </sql>
            </EcomOrderDiscount>
        </database>
    </package>

    <package version="443" releasedate="10-04-2015">
        <file name="Payment.html" target="/Files/Templates/eCom7/CheckoutHandler/KlarnaInvoice/Payment" source="/Files/Templates/eCom7/CheckoutHandler/KlarnaInvoice/Payment" />
        <file name="Payment_AddressUpdating.html" target="/Files/Templates/eCom7/CheckoutHandler/KlarnaInvoice/Payment" source="/Files/Templates/eCom7/CheckoutHandler/KlarnaInvoice/Payment" />
        <file name="Payment_AddressUpdating_SE.html" target="/Files/Templates/eCom7/CheckoutHandler/KlarnaInvoice/Payment" source="/Files/Templates/eCom7/CheckoutHandler/KlarnaInvoice/Payment" />
        <file name="Payment_DateOfBirth.html" target="/Files/Templates/eCom7/CheckoutHandler/KlarnaInvoice/Payment" source="/Files/Templates/eCom7/CheckoutHandler/KlarnaInvoice/Payment" />
        <file name="invoice.css" target="/Files/Templates/eCom7/CheckoutHandler/KlarnaInvoice/Payment" source="/Files/Templates/eCom7/CheckoutHandler/KlarnaInvoice/Payment" />
        <file name="invoice.js" target="/Files/Templates/eCom7/CheckoutHandler/KlarnaInvoice/Payment" source="/Files/Templates/eCom7/CheckoutHandler/KlarnaInvoice/Payment" />
        <file name="PaymentMethods.html" target="/Files/Templates/eCom7/CheckoutHandler/KlarnaInvoice/SelectPaymentMethod" source="/Files/Templates/eCom7/CheckoutHandler/KlarnaInvoice/SelectPaymentMethod" />
        <file name="PaymentMethods_AT.html" target="/Files/Templates/eCom7/CheckoutHandler/KlarnaInvoice/SelectPaymentMethod" source="/Files/Templates/eCom7/CheckoutHandler/KlarnaInvoice/SelectPaymentMethod" />
        <file name="PaymentMethods_DE.html" target="/Files/Templates/eCom7/CheckoutHandler/KlarnaInvoice/SelectPaymentMethod" source="/Files/Templates/eCom7/CheckoutHandler/KlarnaInvoice/SelectPaymentMethod" />
        <file name="PaymentMethods_DK.html" target="/Files/Templates/eCom7/CheckoutHandler/KlarnaInvoice/SelectPaymentMethod" source="/Files/Templates/eCom7/CheckoutHandler/KlarnaInvoice/SelectPaymentMethod" />
        <file name="PaymentMethods_FI.html" target="/Files/Templates/eCom7/CheckoutHandler/KlarnaInvoice/SelectPaymentMethod" source="/Files/Templates/eCom7/CheckoutHandler/KlarnaInvoice/SelectPaymentMethod" />
        <file name="PaymentMethods_NL.html" target="/Files/Templates/eCom7/CheckoutHandler/KlarnaInvoice/SelectPaymentMethod" source="/Files/Templates/eCom7/CheckoutHandler/KlarnaInvoice/SelectPaymentMethod" />
        <file name="PaymentMethods_NO.html" target="/Files/Templates/eCom7/CheckoutHandler/KlarnaInvoice/SelectPaymentMethod" source="/Files/Templates/eCom7/CheckoutHandler/KlarnaInvoice/SelectPaymentMethod" />
        <file name="PaymentMethods_SE.html" target="/Files/Templates/eCom7/CheckoutHandler/KlarnaInvoice/SelectPaymentMethod" source="/Files/Templates/eCom7/CheckoutHandler/KlarnaInvoice/SelectPaymentMethod" />
        <file name="checkouthandler_cancel.html" target="/Files/Templates/eCom7/CheckoutHandler/KlarnaInvoice/Cancel" source="/Files/Templates/eCom7/CheckoutHandler/KlarnaInvoice/Cancel" />
        <file name="checkouthandler_error.html" target="/Files/Templates/eCom7/CheckoutHandler/KlarnaInvoice/Error" source="/Files/Templates/eCom7/CheckoutHandler/KlarnaInvoice/Error" />
    </package>

    <package version="442" releasedate="26-03-2015">
        <database file="Ecom.mdb">
            <EcomOrderDiscount>
                <sql conditional="">
                    ALTER TABLE [EcomDiscount] ADD [DiscountOrderContextId] [nvarchar](50) NULL
                </sql>
            </EcomOrderDiscount>
        </database>
    </package>

    <package version="441" releasedate="20-03-2015">
        <file name="Payment.html" target="/Files/Templates/eCom7/CheckoutHandler/KlarnaCheckout/Payment" source="/Files/Templates/eCom7/CheckoutHandler/KlarnaCheckout/Payment" />
        <file name="Confirmation.html" target="/Files/Templates/eCom7/CheckoutHandler/KlarnaCheckout/Confirmation" source="/Files/Templates/eCom7/CheckoutHandler/KlarnaCheckout/Confirmation" />
        <file name="checkouthandler_cancel.html" target="/Files/Templates/eCom7/CheckoutHandler/KlarnaCheckout/Cancel" source="/Files/Templates/eCom7/CheckoutHandler/KlarnaCheckout/Cancel" />
        <file name="checkouthandler_error.html" target="/Files/Templates/eCom7/CheckoutHandler/KlarnaCheckout/Error" source="/Files/Templates/eCom7/CheckoutHandler/KlarnaCheckout/Error" />
    </package>

    <package version="440" releasedate="19-03-2015">
        <file name="Payment.html" target="/Files/Templates/eCom7/CheckoutHandler/ChargeLogic/Payment" source="/Files/Templates/eCom7/CheckoutHandler/ChargeLogic/Payment" />
        <file name="checkouthandler_cancel.html" target="/Files/Templates/eCom7/CheckoutHandler/ChargeLogic/Cancel" source="/Files/Templates/eCom7/CheckoutHandler/ChargeLogic/Cancel" />
        <file name="checkouthandler_error.html" target="/Files/Templates/eCom7/CheckoutHandler/ChargeLogic/Error" source="/Files/Templates/eCom7/CheckoutHandler/ChargeLogic/Error" />
    </package>
    
    <package version="439" releasedate="18-03-2015">
        <file name="Post.html" target="/Files/Templates/eCom7/CheckoutHandler/Beanstream/Post" source="/Files/Templates/eCom7/CheckoutHandler/Beanstream/Post" />
        <file name="Post_iframe.html" target="/Files/Templates/eCom7/CheckoutHandler/Beanstream/Post" source="/Files/Templates/eCom7/CheckoutHandler/Beanstream/Post" />
        <file name="checkouthandler_cancel.html" target="/Files/Templates/eCom7/CheckoutHandler/Beanstream/Cancel" source="/Files/Templates/eCom7/CheckoutHandler/Beanstream/Cancel" />
        <file name="checkouthandler_error.html" target="/Files/Templates/eCom7/CheckoutHandler/Beanstream/Error" source="/Files/Templates/eCom7/CheckoutHandler/Beanstream/Error" />
    </package>

    <package version="438" releasedate="16-03-2015">
        <database file="Dynamic.mdb">
            <Module>                
                <sql conditional="">UPDATE [Module] SET ModuleIsBeta = 0 WHERE ModuleSystemName = 'eCom_MultiShopAdvanced'</sql>                
                <sql conditional="">DELETE FROM [Module] WHERE ModuleSystemName = 'eCom_Center'</sql>
            </Module>
        </database>        
    </package>

    <package version="437" releasedate="13-03-2015">
        <file name="checkouthandler_cancel.html" target="/Files/Templates/eCom7/CheckoutHandler/CyberSource/Cancel" source="/Files/Templates/eCom7/CheckoutHandler/CyberSource/Cancel" />
        <file name="checkouthandler_error.html" target="/Files/Templates/eCom7/CheckoutHandler/CyberSource/Error" source="/Files/Templates/eCom7/CheckoutHandler/CyberSource/Error" />
    </package>

    <package version="436" releasedate="11-03-2015">
        <database file="Ecom.mdb">
            <EcomOrders>
                <sql conditional="">
                    ALTER TABLE [EcomProductsRelated] ADD [ProductRelatedProductRelVariantID] [nvarchar](255) NOT NULL DEFAULT '';
                    ALTER TABLE [EcomProductsRelated] DROP CONSTRAINT [EcomProductsRelated$PrimaryKey];
                    ALTER TABLE [EcomProductsRelated] ADD CONSTRAINT [EcomProductsRelated$PrimaryKey] PRIMARY KEY NONCLUSTERED ([ProductRelatedProductID], [ProductRelatedProductRelID], [ProductRelatedGroupID], [ProductRelatedProductRelVariantID]);
                </sql>
            </EcomOrders>
        </database>
    </package>

    <package version="435" date="11-03-2015">
	    <database file="Ecom.mdb">
	        <Ecom7Tree>
		        <sql conditional="">
                    UPDATE [Ecom7Tree] SET [Text] = 'Order discounts' WHERE [parentId] = 92 AND [TreeChildPopulate] = 'ORDERDISCOUNTSLIST'
                </sql>
		        <sql conditional="">
                    UPDATE [Ecom7Tree] SET [Text] = 'Order discounts' WHERE [parentId] = 94 AND [TreeChildPopulate] = 'ORDERDISCOUNTS'
		        </sql>
            </Ecom7Tree>
        </database>
    </package>  
    
    <package version="434" date="10-03-2015">
	    <database file="Ecom.mdb">
	        <EcomAssortments>
		        <sql conditional="">
                    ALTER TABLE [EcomOrderStates] ADD [OrderStateAllowOrder] BIT NOT NULL DEFAULT 1
                </sql>
            </EcomAssortments>
        </database>
    </package>  

    <package version="433" date="02-03-2015">
	    <database file="Ecom.mdb">
	        <EcomAssortments>
		        <sql conditional="">
                    ALTER TABLE [EcomAssortments] ADD [AssortmentAllowAnonymousUsers] BIT NOT NULL DEFAULT 0
                </sql>
            </EcomAssortments>
        </database>
    </package>  

    <package version="432" releasedate="27-02-2015">
        <database file="Ecom.mdb">
            <EcomOrders>
                <sql conditional="">
                    ALTER TABLE [EcomOrders] ADD [OrderContextID] [nvarchar](50) NULL
                </sql>
            </EcomOrders>
        </database>
    </package>

    <package version="431" releasedate="12-02-2015">
        <database file="Ecom.mdb">
            <EcomOrders>
                <sql conditional="">
                    ALTER TABLE [EcomProductVatGroups] ADD [ProductVatGroupProductVariantID] [nvarchar](255) NOT NULL DEFAULT ''
                </sql>
            </EcomOrders>
        </database>
    </package>

    <package version="430" releasedate="11-02-2015">
        <database file="Ecom.mdb">
            <EcomProductFieldTranslation>
                <sql conditional="">
                    IF (NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'EcomProductVatGroups'))
                    BEGIN
                        CREATE TABLE [EcomProductVatGroups](
	                        [ProductVatGroupID] [int] IDENTITY(1,1) NOT NULL,
	                        [ProductVatGroupProductID] [nvarchar](30) NOT NULL,
	                        [ProductVatGroupProductVariantID] [nvarchar](255) NOT NULL,
	                        [ProductVatGroupVatGroupID] [nvarchar](50) NOT NULL,
	                        [ProductVatGroupCountryID] [nvarchar](2) NULL
                        CONSTRAINT [PK_EcomProductVatGroups] PRIMARY KEY CLUSTERED ([ProductVatGroupID] ASC)) 
                    END
                </sql>
                <sql conditional="">
                        CREATE NONCLUSTERED INDEX [DW_IX_EcomProductVatGroups_ProductID_ProductVariantID] 
                        ON [EcomProductVatGroups] (
                            [ProductVatGroupProductID] ASC,
                            [ProductVatGroupProductVariantID] ASC
                        )
                </sql>
            </EcomProductFieldTranslation>
        </database>
    </package>      
        
    <package version="429" releasedate="06-02-2015">
        <database file="Ecom.mdb">
            <EcomOrders>
                <sql conditional="">
                    ALTER TABLE [EcomOrders] ADD [OrderVoucherUseType] INT NOT NULL DEFAULT 0
                </sql>
            </EcomOrders>
        </database>
    </package>
        
    <package version="428" releasedate="05-02-2015">
        <database file="Ecom.mdb">
            <EcomDiscount>
                <sql conditional="">
                    ALTER TABLE [EcomPrices] ADD [PriceIsInformative] BIT NULL
                </sql>
            </EcomDiscount>
        </database>
    </package>
        
    <package version="427" releasedate="03-02-2015">
        <database file="Ecom.mdb">
            <EcomDiscount>
                <sql conditional="">
                    ALTER TABLE [EcomDiscount] ADD [DiscountDescription] NVARCHAR(MAX) NULL
                </sql>
            </EcomDiscount>
        </database>
    </package>

    <package version="426" releasedate="26-01-2015">
        <database file="Ecom.mdb">
            <EcomOrders>
                <sql conditional="">
                    ALTER TABLE [EcomOrders] ADD 
                        [OrderTaxTransactionNumber] NVARCHAR(50) NULL
                </sql>
            </EcomOrders>
        </database>
    </package>

    <package version="425" releasedate="22-01-2015">
        <database file="Ecom.mdb">
            <EcomRmas>
                <sql conditional="">
                    ALTER TABLE [EcomRmas] ADD 
                        [RmaCustomerCountryCode] NVARCHAR(50) NULL,
                        [RmaDeliveryCountryCode] NVARCHAR(50) NULL
                </sql>
            </EcomRmas>
        </database>
    </package>

    <package version="423" releasedate="19-01-2015">
        <database file="Ecom.mdb">
            <EcomDiscount>
                <sql conditional="">
                    ALTER TABLE [EcomDiscount] ADD [DiscountAssignableFromProducts] BIT NOT NULL DEFAULT 0
                </sql>
            </EcomDiscount>
        </database>
    </package>

    <package version="422" date="16-01-2015">
	    <database file="Ecom.mdb">
            <EcomLoyaltyRewardRule>
		        <sql conditional="">
                    ALTER TABLE [EcomLoyaltyRewardRule] ADD
	                    [LoyaltyRewardRuleOrderLineFieldName] NVARCHAR(255) NULL
                </sql>
            </EcomLoyaltyRewardRule>
        </database>
    </package>
    <package version="421" date="15-01-2015">
	    <database file="Ecom.mdb">
            <EcomLoyaltyRewardRule>
		        <sql conditional="">
                    ALTER TABLE [EcomLoyaltyRewardRule] ADD
	                    [LoyaltyRewardRuleOrderFieldName] NVARCHAR(255) NULL,
	                    [LoyaltyRewardRuleOrderFieldValue] NVARCHAR(MAX) NULL,
	                    [LoyaltyRewardRuleVoucherListId] INT NULL
                </sql>
            </EcomLoyaltyRewardRule>
        </database>
    </package>

    <package version="420" releasedate="14-01-2015">
        <database file="Ecom.mdb">
            <EcomProductFieldTranslation>
                <sql conditional="">
                    IF (NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'EcomFieldOptionTranslation'))
                    BEGIN
                        CREATE TABLE [EcomFieldOptionTranslation](
	                        [EcomFieldOptionTranslationID] [int] IDENTITY(1,1) NOT NULL,
	                        [EcomFieldOptionTranslationOptionID] [nvarchar](255) NOT NULL,
	                        [EcomFieldOptionTranslationLanguageID] [nvarchar](50) NOT NULL,
	                        [EcomFieldOptionTranslationName] [nvarchar](255) NULL,
                        CONSTRAINT [PK_EcomFieldOptionTranslation] PRIMARY KEY CLUSTERED ([EcomFieldOptionTranslationID] ASC)) 
                    END
                </sql>
            </EcomProductFieldTranslation>
        </database>
    </package>  

    <package version="419" date="30-12-2014">
	    <database file="Ecom.mdb">
	        <EcomOrders>
		        <sql conditional="">
                    ALTER TABLE [EcomOrders] ADD [OrderPriceCalculatedByProvider] BIT NOT NULL DEFAULT 0
                </sql>
            </EcomOrders>
        </database>
    </package>

    <package version="418" date="30-12-2014">
	    <database file="Ecom.mdb">
	        <EcomAssortments>
		        <sql conditional="">
                    ALTER TABLE [EcomAssortments] ADD [AssortmentIncludeSubgroups] BIT NOT NULL DEFAULT 0
                </sql>
            </EcomAssortments>
        </database>
    </package>    

    <package version="417" date="30-12-2014">
	    <database file="Ecom.mdb">
            <EcomLoyaltyRewardRule>
		        <sql conditional="">
                    ALTER TABLE [EcomLoyaltyRewardRule] ADD
                     [LoyaltyRewardRuleName] NVARCHAR(255) NULL,
                     [LoyaltyRewardRuleActive] BIT NOT NULL CONSTRAINT DW_DF_LoyaltyRewardRule_Active DEFAULT 1,
	                 [LoyaltyRewardRuleValidFrom] DATETIME NULL,
	                 [LoyaltyRewardRuleValidTo] DATETIME NULL,
	                 [LoyaltyRewardRuleAccessUserId] INT NULL,
	                 [LoyaltyRewardRuleAccessUserGroupId] INT NULL,
                     [LoyaltyRewardRuleAccessUserCustomerNumber] NVARCHAR(255) NULL,
                     [LoyaltyRewardRuleProductsAndGroups] NVARCHAR(MAX) NOT NULL DEFAULT '[all]',
	                 [LoyaltyRewardRuleCountryCode2] NVARCHAR(2) NULL,
	                 [LoyaltyRewardRuleShippingId] NVARCHAR(50) NULL,
	                 [LoyaltyRewardRulePaymentId] NVARCHAR(50) NULL,
	                 [LoyaltyRewardRuleProductQuantification] INT NOT NULL CONSTRAINT DW_DF_EcomLoyaltyRewardRule_ProductQuantification DEFAULT 0, 
	                 [LoyaltyRewardRuleProductQuantity] FLOAT NULL,
                     [LoyaltyRewardRuleOrderTotalPriceCondition] INT NOT NULL CONSTRAINT DW_DF_EcomLoyaltyRewardRule_OrderTotalPriceCondition DEFAULT 5,
	                 [LoyaltyRewardRuleOrderTotalPrice] FLOAT NULL
                </sql>
		        <sql conditional="">
                    update [EcomLoyaltyRewardRule] set LoyaltyRewardRuleProductsAndGroups = '[some]' + IIF(LoyaltyRewardRuleGroupId &lt;&gt; '',IIF(LoyaltyRewardRuleGroupId LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]'), '[ss:' + LoyaltyRewardRuleGroupId + ']', '[g:' + LoyaltyRewardRuleGroupId + ']'), '') + IIF(LoyaltyRewardRuleProductId &lt;&gt; '', '[p:' + LoyaltyRewardRuleProductId + ',' + isnull(LoyaltyRewardRuleProductVariantId, '') + ']', '')
                </sql>
                <sql conditional="">
                    update [EcomLoyaltyRewardRule] set LoyaltyRewardRuleName = 'Rule_' + CONVERT(nvarchar(Max), LoyaltyRewardRuleId) Where LoyaltyRewardRuleName is null
                </sql>
                <sql conditional="">
                    update [EcomLoyaltyRewardRule] set LoyaltyRewardRuleValidFrom = GETDATE() Where LoyaltyRewardRuleValidFrom is null
                </sql>
                <sql conditional="">
                    update [EcomLoyaltyRewardRule] set LoyaltyRewardRuleValidTo = DATEADD (year, 1, GETDATE()) Where LoyaltyRewardRuleValidTo is null
                </sql>
            </EcomLoyaltyRewardRule>
        </database>
    </package>

    <package version="416" date="24-12-2014">
	    <database file="Ecom.mdb">
	        <EcomAssortments>
		        <sql conditional="">
                    ALTER TABLE [EcomAssortments] ADD [AssortmentActive] BIT NOT NULL DEFAULT 1
                </sql>
            </EcomAssortments>
        </database>
    </package>

    <package version="415" releasedate="19-12-2014">
	    <database file="Ecom.mdb">
            <EcomProducts>
		        <sql conditional="">ALTER TABLE [EcomProducts] DROP [ProductPeriodIdOfProduct]</sql>
            </EcomProducts>
        </database>
    </package>

    <package version="414" releasedate="18-12-2014">
        <invoke type="Dynamicweb.Content.Management.UpdateScripts, Dynamicweb" method="CreateEcomProductsRelatedGroupsIndexes" />
    </package>

    <package version="413" date="4-12-2014">
	    <database file="Ecom.mdb">
            <EcomOrderDiscount>
		        <sql conditional="">
                    ALTER TABLE [EcomDiscount] ADD [DiscountProductsAndGroups] NVARCHAR(MAX) NOT NULL DEFAULT '[some]'
                </sql>
                <sql conditional="">
                    update EcomDiscount set DiscountProductsAndGroups = '[some]' + IIF(DiscountGroupId &lt;&gt; '',IIF(DiscountGroupId LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]'), '[ss:' + DiscountGroupId + ']', '[g:' + DiscountGroupId + ']'), '') + IIF(DiscountProductId &lt;&gt; '', '[p:' + DiscountProductId + ',' + DiscountProductVariantId + ']', '')
                    where DiscountProductsAndGroups is null
                </sql>
            </EcomOrderDiscount>
	    </database>
    </package>


    <package version="412" date="21-11-2014">
	    <database file="Ecom.mdb">
	        <EcomOrders>
		        <sql conditional="">
                    ALTER TABLE [EcomOrders] ADD [OrderVisitorSessionDate] DATETIME NULL
                </sql>
		        <sql conditional="">
                    UPDATE [EcomOrders] SET [OrderVisitorSessionDate] = [OrderDate] WHERE [OrderVisitorSessionDate] IS NULL
                </sql>
            </EcomOrders>
        </database>
    </package>

    <package version="411" releasedate="20-11-2014">
	    <database file="Ecom.mdb">
            <EcomOrderDiscount>
		        <sql conditional="">
                    ALTER TABLE [EcomDiscount] ADD [DiscountExcludedProductsAndGroups] NVARCHAR(MAX) NOT NULL DEFAULT '[some]'
                </sql>
            </EcomOrderDiscount>
        </database>
    </package>

    <package version="410" date="17-11-2014">
	    <database file="Ecom.mdb">
	        <EcomLoyaltyReward>
		        <sql conditional="">
                    ALTER TABLE [EcomLoyaltyReward] ADD [LoyaltyRewardArchived] BIT NOT NULL DEFAULT 0
                </sql>
            </EcomLoyaltyReward>
        </database>
    </package>

    <package version="409" releasedate="30-10-2014">
        <database file="Ecom.mdb">
            <EcomProductFieldTranslation>
                <sql conditional="">
                    IF (NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'EcomProductFieldTranslation'))
                    BEGIN
                        CREATE TABLE [EcomProductFieldTranslation](
	                        [ProductFieldTranslationID] [int] IDENTITY(1,1) NOT NULL,
	                        [ProductFieldTranslationFieldID] [nvarchar](255) NOT NULL,
	                        [ProductFieldTranslationLanguageID] [nvarchar](50) NOT NULL,
	                        [ProductFieldTranslationName] [nvarchar](255) NULL,
                        CONSTRAINT [PK_EcomProductFieldTranslation] PRIMARY KEY CLUSTERED ([ProductFieldTranslationID] ASC)) 
                    END
                </sql>
            </EcomProductFieldTranslation>
        </database>
    </package>
      
    <package version="408" releasedate="08-10-2014">
        <database file="Ecom.mdb">
            <EcomCurrencies>
                <sql conditional="">
                    ALTER TABLE [EcomCurrencies] ADD [CurrencyPositivePattern] INT NULL
                </sql>
                <sql conditional="">
                    ALTER TABLE [EcomCurrencies] ADD [CurrencyNegativePattern] INT NULL
                </sql>
            </EcomCurrencies>
        </database>
    </package>

    <package version="407" releasedate="02-10-2014">
        <database file="Dynamic.mdb">
            <EcomOrder>
	            <sql conditional="">ALTER TABLE [EcomOrders] ADD [OrderCheckoutPageID] INT NOT NULL DEFAULT 0</sql>
            </EcomOrder>
        </database>
    </package>

    <package version="406" releasedate="26-09-2014">
        <database file="Dynamic.mdb">
            <Module>
                <sql conditional="">
                    UPDATE [Module] SET ModuleIsBeta = 0 WHERE ModuleSystemName = 'eCom_ContextOrderRenderer'
                </sql>
            </Module>
        </database>
    </package>

    <package version="405" releasedate="25-09-2014">
        <database file="Ecom.mdb">
            <ScheduledTask>
                <sql conditional="">
                    UPDATE ScheduledTask SET TaskMinute = 1440 WHERE TaskAssembly = 'Dynamicweb.eCommerce.Loyalty.PointExpirationScheduledTaskAddIn' AND TaskMinute = 1
                </sql>
            </ScheduledTask>
        </database>
    </package>

    <package version="404" releasedate="25-09-2014">
        <database file="Ecom.mdb">
            <ScheduledTask>
                <sql conditional="">
                    UPDATE ScheduledTask SET TaskType = 6 WHERE TaskAssembly = 'Dynamicweb.eCommerce.Assortments.AssortmentItemBuilderScheduledTaskAddIn'
                </sql>
            </ScheduledTask>
        </database>
    </package>

    <package version="403" releasedate="25-09-2014">
        <database file="Ecom.mdb">
            <ScheduledTask>
                <sql conditional="">
                    UPDATE ScheduledTask SET TaskType = 6 WHERE TaskAssembly = 'Dynamicweb.eCommerce.Loyalty.PointExpirationScheduledTaskAddIn'
                </sql>
            </ScheduledTask>
        </database>
    </package>

    <package version="402" releasedate="18-09-2014">
        <file name="details.html" source="/Files/Templates/eCom/LoyaltyPoints/" target="/Files/Templates/eCom/LoyaltyPoints/" overwrite="false"/>
        <file name="list.html" source="/Files/Templates/eCom/LoyaltyPoints/" target="/Files/Templates/eCom/LoyaltyPoints/" overwrite="false"/>
    </package>

    <package version="401" releasedate="18-09-2014">
        <file name="ProductLoyaltyPoints.html" target="/Files/Templates/eCom/Product" source="/Files/Templates/eCom/Product" />
        <file name="ProductListLoyaltyPoints.html" target="/Files/Templates/eCom/ProductList" source="/Files/Templates/eCom/ProductList" />
    </package>

    <package version="400" releasedate="16-09-2014">
        <database file="Ecom.mdb">
            <Ecom7Tree>
                <sql conditional="SELECT * FROM Ecom7Tree WHERE TreeChildPopulate = 'LOYALTYPOINTS' AND TreeHasAccessModuleSystemName Like '%LoyaltyPoints%'">
                    UPDATE Ecom7Tree SET TreeHasAccessModuleSystemName = 'LoyaltyPoints' WHERE TreeChildPopulate = 'LOYALTYPOINTS'
                </sql>
            </Ecom7Tree>
        </database>
    </package>


    <package version="399" releasedate="08-09-2014">
        <database file="Dynamic.mdb">
            <EcomOrder>
	            <sql conditional="">ALTER TABLE [EcomOrders] ADD [OrderTransactionCardNumber] NVARCHAR(50) NULL</sql>
            </EcomOrder>
        </database>
    </package>

    <package version="398" releasedate="05-09-2014" >
        <database file="Ecom.mdb">
            <EcomDiscount>
		        <sql conditional="">
                    ALTER TABLE [EcomDiscount] ADD DiscountApplyOnce BIT NULL
                </sql>
	        </EcomDiscount>
        </database>
    </package>

    <package version="397" releasedate="05-09-2014">
        <invoke type="Dynamicweb.Content.Management.UpdateScripts, Dynamicweb" method="AddDefaultQuoteStates" />
    </package>

    <package version="396" releasedate="04-09-2014">
        <database file="Ecom.mdb">
            <EcomNumbers>
                <sql conditional="">
                    IF NOT EXISTS( SELECT NumberID FROM EcomNumbers WHERE ( NumberType = 'QUOTE' ) )
	                    INSERT INTO EcomNumbers ( NumberID, NumberType, NumberDescription, NumberCounter, NumberPrefix, NumberPostFix, NumberAdd, NumberEditable )
	                    VALUES ( '50', 'QUOTE', 'Quote', 0, 'QUOTE', '', 1, 0 )
                </sql>
            </EcomNumbers>
        </database>
    </package>

    <package version="395" releasedate="22-08-2014">
        <database file="Ecom.mdb">
            <Module>
                <sql conditional="SELECT COUNT(*) FROM [Module] WHERE [ModuleSystemName] = 'eCom_DiscountMatrix'">
                    INSERT INTO [Module] (ModuleSystemName, ModuleName, ModuleAccess, ModuleEcomNotInstalledAccess)
                    VALUES ('eCom_DiscountMatrix', 'Discount matrix', 0, 0)
                </sql>
            </Module>
        </database>
    </package>

    <package version="394" date="19-08-2014">
        <database file="Ecom.mdb">
            <Ecom7Tree>
                <sql conditional="">
                    UPDATE [Ecom7Tree] SET [parentId] = 92 WHERE [parentId] = 93 and [TreeChildPopulate] in ('SALESDISCNT','ECOMVOUCHERSMANAGER','LOYALTYPOINTS')
                </sql>
                <sql conditional="">
                    UPDATE [Ecom7Tree] SET [TreeSort] = 41 WHERE [parentId] = 92 and [TreeChildPopulate] = 'LOYALTYPOINTS'
                </sql>
            </Ecom7Tree>
        </database>
    </package>

    <package version="393" releasedate="19-08-2014">
        <database file="Ecom.mdb">
            <Module>
                <sql conditional="SELECT COUNT(*) FROM [Module] WHERE [ModuleSystemName] = 'LoyaltyPoints'">
                    INSERT INTO [Module] (ModuleSystemName, ModuleName, ModuleIsBeta, ModuleAccess, ModuleParagraph, ModuleEcomNotInstalledAccess)
                    VALUES ('LoyaltyPoints', 'Loyalty points', 0, 1,1, 0)
                </sql>
            </Module>
        </database>
    </package>


    <package version="392" releasedate="18-08-2014">
        <file name="ProductListCustomerCenterList.html" target="/Files/Templates/eCom/ProductList" source="/Files/Templates/eCom/ProductList" />
    </package>

    <package version="391" releasedate="15-08-2014">
        <database file="Ecom.mdb">
                <Module>
                <sql conditional="">
                    UPDATE [Module] SET [ModuleIsBeta] = 0 WHERE [ModuleSystemName] = 'eCom_Quotes'
                </sql>
            </Module>
        </database>
    </package>

    <package version="390" date="14-08-2014">
        <database file="Access.mdb">
            <AccessUser>
		        <sql conditional="">
                    ALTER TABLE [AccessUser] ADD AccessUserPointBalance FLOAT NULL
                </sql>
	        </AccessUser>
        </database>
    </package>

    <package version="389" date="07-08-2014">
        <database file="Ecom.mdb">
            <Ecom7Tree>
                <sql conditional="SELECT [ParentId] FROM [Ecom7Tree] WHERE [TreeUrl] = '/Admin/Module/Recommendation/ModelList.aspx'">
                    INSERT INTO [Ecom7Tree]
                    (
                        [ParentId],
                        [Text],
                        [Alt],
                        [TreeIcon],
                        [TreeUrl],
                        [TreeChildPopulate],
                        [TreeSort],
                        [TreeHasAccessModuleSystemName]
                    )
                    VALUES
                    (
                        96,
		                'Models',
		                7,
		                '/Admin/Module/Recommendation/images/tree/recommendation_models.jpg',
		                '/Admin/Module/Recommendation/ModelList.aspx',
		                'RECOMMENDATIONMODELS',
		                10,
		                'Recommendation'
                    )
                </sql>
            </Ecom7Tree>
        </database>
    </package>

    <package version="388" releasedate="05-07-2014">
        <database file="Ecom.mdb">
            <Module>
                <sql conditional="SELECT COUNT(*) FROM [Module] WHERE [ModuleSystemName] = 'eCom_Quotes'">
                    INSERT INTO [Module] ([ModuleSystemName], [ModuleName], [ModuleIsBeta], [ModuleAccess])
                    VALUES ('eCom_Quotes', 'Quotes', 1, 0)
                </sql>
            </Module>
            <EcomTree>
                <sql conditional="SELECT COUNT(*) FROM EcomTree WHERE TreeChildPopulate = 'QUOTES'">
                    INSERT INTO EcomTree (parentId, Text, Alt, TreeIcon, TreeIconOpen, TreeUrl, TreeChildPopulate, TreeSort, TreeHasAccessModuleSystemName)
                    VALUES(1, 'Quotes', NULL, NULL, NULL, NULL, 'QUOTES', 4, 'eCom_Quotes')
                </sql>
                <sql conditional="">
                  UPDATE [EcomTree] SET [TreeSort] = 5 WHERE [TreeUrl] = 'RmaList.aspx'
                </sql>
            </EcomTree>
        </database>
    </package>

    <package version="387" date="31-07-2014">
        <file name="QuoteList.html" source="/Files/Templates/eCom/CustomerCenter" target="/Files/Templates/eCom/CustomerCenter"  overwrite="false"/>
        <file name="QuoteDetail.html" source="/Files/Templates/eCom/CustomerCenter" target="/Files/Templates/eCom/CustomerCenter"  overwrite="false"/>
        <file name="NavigationQuotes.html" source="/Files/Templates/eCom/CustomerCenter" target="/Files/Templates/eCom/CustomerCenter"  overwrite="false"/>
    </package>

    <package version="386" releasedate="25-07-2014">
        <database file="Ecom.mdb">
            <Quotes>
                <sql conditional="">
                    ALTER TABLE [EcomOrders] ADD [OrderIsQuote] BIT NOT NULL DEFAULT 0
                </sql>
                <sql conditional="">
                    ALTER TABLE [EcomOrderFlow] ADD [OrderFlowOrderType] INT NOT NULL DEFAULT 0
                </sql>
                <sql conditional="">
                    ALTER TABLE [EcomOrderStates] ADD [OrderStateOrderType] INT NOT NULL DEFAULT 0
                </sql>
                <sql conditional="">
                    CREATE TABLE [EcomOrderStateRules]
                    (
	                    OrderStateRuleId INT IDENTITY(1,1) NOT NULL,
	                    OrderStateRuleFromState NVARCHAR(50) NOT NULL,
	                    OrderStateRuleToState NVARCHAR(50) NOT NULL,
	                    CONSTRAINT DW_PK_EcomOrderStateRules PRIMARY KEY CLUSTERED (OrderStateRuleId ASC)
                    ) 
                </sql>
                <sql conditional="SELECT [ParentId] FROM [Ecom7Tree] WHERE  [TreeUrl] = 'Lists/EcomOrderFlow_List.aspx?OrderType=quotes'">
                    INSERT INTO [Ecom7Tree]
                    (
                        [ParentId],
                        [Text],
                        [Alt],
                        [TreeIcon],
                        [TreeUrl],
                        [TreeChildPopulate],
                        [TreeSort],
                        [TreeHasAccessModuleSystemName]
                    )
                    VALUES
                    (
                        92,
		                'Quote flows',
		                7,
		                'tree/btn_quotes.png',
		                'Lists/EcomOrderFlow_List.aspx?OrderType=quotes',
		                'QUOTESFLOW',
		                72,
		                'eCom_CartV2'
                    )
                </sql>
            </Quotes>
        </database>
    </package>
    
    <package version="385" releasedate="25-07-2014">
        <database file="Ecom.mdb">
            <Ecom7Tree>
                <sql conditional="SELECT [ParentId] FROM [Ecom7Tree] WHERE  [TreeUrl] = '/Admin/Module/eCom_Catalog/dw7/lists/EcomOrderDiscount_List.aspx'">
                    INSERT INTO [Ecom7Tree]
                    (
                        [ParentId],
                        [Text],
                        [Alt],
                        [TreeIcon],
                        [TreeUrl],
                        [TreeChildPopulate],
                        [TreeSort],
                        [TreeHasAccessModuleSystemName]
                    )
                    VALUES
                    (
                        92,
                        'Discount matrix',
                        NULL,
                        '/Admin/Module/eCom_Catalog/images/buttons/btn_discount.gif',
                        '/Admin/Module/eCom_Catalog/dw7/lists/EcomOrderDiscount_List.aspx',
                        'ORDERDISCOUNTSLIST',
                        31,
                        ''
                    )
                </sql>
            </Ecom7Tree>
        </database>
    </package>

    <package version="384" releasedate="11-07-2014">
        <database file="Ecom.mdb">
            <TotalDiscount>
                <sql conditional="">
                    ALTER TABLE [EcomOrders] ADD [OrderTotalDiscountWithVAT] FLOAT NULL,
                                                 [OrderTotalDiscountWithoutVAT] FLOAT NULL,
                                                 [OrderTotalDiscountVAT] FLOAT NULL,
                                                 [OrderTotalDiscountVATPercent] FLOAT NULL
                </sql>
                <sql conditional="">
                    ALTER TABLE [EcomOrderLines] ADD [OrderLineTotalDiscountWithVAT] FLOAT NULL,
                                                     [OrderLineTotalDiscountWithoutVAT] FLOAT NULL,
                                                     [OrderLineTotalDiscountVAT] FLOAT NULL,
                                                     [OrderLineTotalDiscountVATPercent] FLOAT NULL
                </sql>
            </TotalDiscount>
        </database>
    </package>

    <package version="383" releasedate="11-07-2014">
        <database file="Ecom.mdb">
            <Ecom7Tree>
                <sql conditional="SELECT [ParentId] FROM [Ecom7Tree] WHERE  [TreeUrl] = '/Admin/Module/eCom_Catalog/dw7/edit/EcomAdvConfigOrderDiscounts_Edit.aspx'">
                    INSERT INTO [Ecom7Tree]
                    (
                        [ParentId],
                        [Text],
                        [Alt],
                        [TreeIcon],
                        [TreeUrl],
                        [TreeChildPopulate],
                        [TreeSort],
                        [TreeHasAccessModuleSystemName]
                    )
                    VALUES
                    (
                        94,
                        'Discount matrix',
                        NULL,
                        '/Admin/Module/eCom_Catalog/images/buttons/btn_discount.gif',
                        '/Admin/Module/eCom_Catalog/dw7/edit/EcomAdvConfigOrderDiscounts_Edit.aspx',
                        'ORDERDISCOUNTS',
                        72,
                        ''
                    )
                </sql>
            </Ecom7Tree>
        </database>
    </package>

    <package version="382" releasedate="11-07-2014">
        <database file="Ecom.mdb">
            <EcomOrderDiscount>
                <sql conditional="">
                    CREATE TABLE [EcomDiscount]
                    (
	                    DiscountId BIGINT IDENTITY(1,1) NOT NULL,
	                    DiscountType INT NOT NULL CONSTRAINT DW_DF_EcomDiscount_Type DEFAULT 0,
	                    DiscountName NVARCHAR(255) NULL,
	                    DiscountActive BIT NOT NULL CONSTRAINT DW_DF_EcomDiscount_Active DEFAULT 1,
	                    DiscountValidFrom DATETIME NULL,
	                    DiscountValidTo DATETIME NULL,
	                    DiscountDiscountType INT NOT NULL CONSTRAINT DW_DF_EcomDiscount_DiscountType DEFAULT 0,
	                    DiscountAmount FLOAT NULL,
	                    DiscountCurrencyCode NVARCHAR(3) NULL,
	                    DiscountPercentage FLOAT NULL,
	                    DiscountProductId NVARCHAR(30) NULL,
	                    DiscountProductVariantId NVARCHAR(255) NULL,
	                    DiscountGroupId NVARCHAR(50) NULL,
	                    DiscountShopId  NVARCHAR(255) NULL,                           
	                    DiscountLanguageId NVARCHAR(50) NULL,
	                    DiscountProductQuantification INT NOT NULL CONSTRAINT DW_DF_EcomDiscount_ProductQuantification DEFAULT 0, 
	                    DiscountProductQuantity FLOAT NULL,
	                    DiscountAccessUserId INT NULL,
	                    DiscountAccessUserGroupId INT NULL,
	                    DiscountAccessUserCustomerNumber NVARCHAR(255) NULL,
	                    DiscountCountryCode2 NVARCHAR(2) NULL,
	                    DiscountShippingId NVARCHAR(50) NULL,
	                    DiscountPaymentId NVARCHAR(50) NULL,
	                    DiscountOrderFieldName NVARCHAR(255) NULL,
	                    DiscountOrderFieldValue NVARCHAR(MAX) NULL,
	                    DiscountVoucherListId INT NULL,
	                    DiscountOrderTotalPriceCondition INT NOT NULL CONSTRAINT DW_DF_EcomDiscount_OrderTotalPriceCondition DEFAULT 5,
	                    DiscountOrderTotalPrice FLOAT NULL,
	                    CONSTRAINT DW_PK_EcomDiscount PRIMARY KEY CLUSTERED (DiscountId ASC)
                    ) 
                </sql>
                <sql conditional="">
                        CREATE NONCLUSTERED INDEX [DW_IX_EcomDiscount_Type] 
                        ON [EcomDiscount] (
                            [DiscountType] ASC
                        )
                        INCLUDE 
                            ([DiscountId])
                </sql>
            </EcomOrderDiscount>
            <EcomOrderDiscountTranslation>
                <sql conditional="">
                        CREATE TABLE [EcomDiscountTranslation]
                        (
	                        DiscountTranslationAutoId BIGINT IDENTITY(1,1) NOT NULL,
	                        DiscountTranslationDiscountId BIGINT NOT NULL,
	                        DiscountTranslationLanguageId NVARCHAR(255) NOT NULL,
	                        DiscountTranslationName NVARCHAR(255) NOT NULL,
	                        CONSTRAINT DW_PK_EcomDiscountTranslation PRIMARY KEY (DiscountTranslationDiscountId ASC, DiscountTranslationLanguageId ASC)
                        )
                </sql>
                <sql conditional="">
                        CREATE UNIQUE CLUSTERED INDEX DW_IX_EcomDiscountTranslation_AutoId
                        ON [EcomDiscountTranslation]
                        (
                                [DiscountTranslationAutoId] ASC
                        )
                </sql>
                <sql conditional="">
                        CREATE NONCLUSTERED INDEX [DW_IX_EcomDiscountTranslation_LanguageId] 
                        ON [EcomDiscountTranslation] (
                            [DiscountTranslationLanguageId] ASC
                        )
                        INCLUDE 
                            ([DiscountTranslationAutoId])
                </sql>
                 <sql conditional="">
                        CREATE NONCLUSTERED INDEX [DW_IX_EcomDiscountTranslation_DiscountId] 
                        ON [EcomDiscountTranslation] (
                            [DiscountTranslationDiscountId] ASC
                        )
                        INCLUDE 
                            ([DiscountTranslationAutoId]) 
                </sql>
            </EcomOrderDiscountTranslation>
        </database>
    </package>

    <package version="381" releasedate="11-07-2014">
        <database file="Ecom.mdb">
            <TotalDiscount>
                <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_OrderDebuggingInfo_OrderId] 
                    ON [EcomOrderDebuggingInfo] (
                        [OrderDebuggingInfoOrderId] ASC
                    )
                    INCLUDE 
                        ([OrderDebuggingInfoId])    
                </sql>
            </TotalDiscount>
        </database>
    </package>

    <package version="380" releasedate="10-07-2014">
        <database file="Ecom.mdb">
            <Ecom7Tree>
                <sql conditional="SELECT [ParentId] FROM [Ecom7Tree] WHERE  [TreeUrl] = '/Admin/module/eCom_Catalog/dw7/Lists/EcomReward_List.aspx?update=true'">
                    INSERT INTO [Ecom7Tree]
                    (
                        [ParentId],
                        [Text],
                        [Alt],
                        [TreeIcon],
                        [TreeUrl],
                        [TreeChildPopulate],
                        [TreeSort],
                        [TreeHasAccessModuleSystemName]
                    )
                    VALUES
                    (
                        93,
                        'Loyalty points',
                        NULL,
                        '/Admin/Module/eCom_Catalog/dw7/images/tree/eCom_LoyaltyPoints_Settings_small.png',
                        '/Admin/module/eCom_Catalog/dw7/Lists/EcomReward_List.aspx?update=true',
                        'LOYALTYPOINTS',
                        43,
                        'LoyaltyPoints'
                    )
                </sql>
            </Ecom7Tree>
        </database>
    </package>

    <package version="379" releasedate="03-07-2014">
        <database file="Ecom.mdb">
            <EcomOrderStates>
                <sql conditional="">
                    ALTER TABLE [EcomOrderStates] ADD [OrderStateSortOrder] INT NULL
                </sql>
            </EcomOrderStates>
        </database>
    </package>

    <package version="378" releasedate="02-07-2014">
        <database file="Ecom.mdb">
            <ReverseChargeForVat>
                <sql conditional="">
                    ALTER TABLE [EcomOrderLines] ADD [OrderLineReverseChargeForVat] BIT
                </sql>
                <sql conditional="">
                    ALTER TABLE [EcomVatCountryRelations] ADD [VatCountryRelReverseChargeForVat] BIT
                </sql>
            </ReverseChargeForVat>
        </database>
    </package>

        <package version="377" releasedate="02-07-2014">
            <database file="ecom.mdb">
                <EcomOrders>
                    <sql conditional="">
                        IF EXISTS( SELECT object_id FROM sys.columns WHERE ( name = 'OrderTotalPoints' ) AND ( is_nullable = 0 ) )
	                        BEGIN
		                        ALTER TABLE [EcomOrders] ALTER COLUMN [OrderTotalPoints] FLOAT NULL
		                        DECLARE @defaultName NVARCHAR(100) 
		                        SELECT @defaultName = OBJECT_NAME(default_object_id) FROM sys.columns WHERE ( name = 'OrderTotalPoints' )
		                        IF NOT @defaultName = ''
			                        EXEC('ALTER TABLE [EcomOrders] DROP CONSTRAINT ' + @defaultName)
	                        END
                    </sql>
                    <sql conditional="">
                        IF EXISTS( SELECT object_id FROM sys.columns WHERE ( name = 'OrderTotalRewardPoints' ) AND ( is_nullable = 0 ) )
	                        BEGIN
		                        ALTER TABLE [EcomOrders] ALTER COLUMN [OrderTotalRewardPoints] FLOAT NULL
		                        DECLARE @defaultName NVARCHAR(100) 
		                        SELECT @defaultName = OBJECT_NAME(default_object_id) FROM sys.columns WHERE ( name = 'OrderTotalRewardPoints' )
		                        IF NOT @defaultName = ''
			                        EXEC('ALTER TABLE [EcomOrders] DROP CONSTRAINT ' + @defaultName)
	                        END
                    </sql>
                </EcomOrders>
                <EcomOrderLines>
                    <sql conditional="">
                        IF EXISTS( SELECT object_id FROM sys.columns WHERE ( name = 'OrderLineUnitPoints' ) AND ( is_nullable = 0 ) )
	                        BEGIN
		                        ALTER TABLE [EcomOrderLines] ALTER COLUMN [OrderLineUnitPoints] FLOAT NULL
		                        DECLARE @defaultName NVARCHAR(100) 
		                        SELECT @defaultName = OBJECT_NAME(default_object_id) FROM sys.columns WHERE ( name = 'OrderLineUnitPoints' )
		                        IF NOT @defaultName = ''
			                        EXEC('ALTER TABLE [EcomOrderLines] DROP CONSTRAINT ' + @defaultName)
	                        END
                    </sql>
                    <sql conditional="">
                        IF EXISTS( SELECT object_id FROM sys.columns WHERE ( name = 'OrderLineUnitRewardPoints' ) AND ( is_nullable = 0 ) )
	                        BEGIN
		                        ALTER TABLE [EcomOrderLines] ALTER COLUMN [OrderLineUnitRewardPoints] FLOAT NULL
		                        DECLARE @defaultName NVARCHAR(100) 
		                        SELECT @defaultName = OBJECT_NAME(default_object_id) FROM sys.columns WHERE ( name = 'OrderLineUnitRewardPoints' )
		                        IF NOT @defaultName = ''
			                        EXEC('ALTER TABLE [EcomOrderLines] DROP CONSTRAINT ' + @defaultName)
	                        END
                    </sql>
                    <sql conditional="">
                        IF EXISTS( SELECT object_id FROM sys.columns WHERE ( name = 'OrderLinePoints' ) AND ( is_nullable = 0 ) )
	                        BEGIN
		                        ALTER TABLE [EcomOrderLines] ALTER COLUMN [OrderLinePoints] FLOAT NULL
		                        DECLARE @defaultName NVARCHAR(100) 
		                        SELECT @defaultName = OBJECT_NAME(default_object_id) FROM sys.columns WHERE ( name = 'OrderLinePoints' )
		                        IF NOT @defaultName = ''
			                        EXEC('ALTER TABLE [EcomOrderLines] DROP CONSTRAINT ' + @defaultName)
	                        END
                    </sql>
                    <sql conditional="">
                        IF EXISTS( SELECT object_id FROM sys.columns WHERE ( name = 'OrderLineRewardPoints' ) AND ( is_nullable = 0 ) )
	                        BEGIN
		                        ALTER TABLE [EcomOrderLines] ALTER COLUMN [OrderLineRewardPoints] FLOAT NULL
		                        DECLARE @defaultName NVARCHAR(100) 
		                        SELECT @defaultName = OBJECT_NAME(default_object_id) FROM sys.columns WHERE ( name = 'OrderLineRewardPoints' )
		                        IF NOT @defaultName = ''
			                        EXEC('ALTER TABLE [EcomOrderLines] DROP CONSTRAINT ' + @defaultName)
	                        END
                    </sql>
                    <sql conditional="">
                        IF EXISTS( SELECT object_id FROM sys.columns WHERE ( name = 'OrderLineRewardId' ) AND ( is_nullable = 0 ) )
	                        BEGIN
		                        ALTER TABLE [EcomOrderLines] ALTER COLUMN [OrderLineRewardId] INT NULL
		                        DECLARE @defaultName NVARCHAR(100) 
		                        SELECT @defaultName = OBJECT_NAME(default_object_id) FROM sys.columns WHERE ( name = 'OrderLineRewardId' )
		                        IF NOT @defaultName = ''
			                        EXEC('ALTER TABLE [EcomOrderLines] DROP CONSTRAINT ' + @defaultName)
	                        END
                    </sql>
                </EcomOrderLines>
            </database>
        </package>

        <package version="376" releasedate="02-07-2014" intervalversion="8.5.0.0">
            <database file="Dynamic.mdb">
                <Module>
                    <sql conditional="SELECT ModuleId FROM [Module] WHERE ModuleSystemName = 'eCom_ContextVoucherRenderer'">
                        INSERT INTO [Module] (
                             [ModuleSystemName]
                            ,[ModuleName]
                            ,[ModuleAccess]
                            ,[ModuleParagraph]
                            ,[ModuleEcomNotInstalledAccess]
                        )
                        VALUES
                        (
                            'eCom_ContextVoucherRenderer'
                            ,'Context Voucher Renderer'
                            ,1
                            ,1
                            ,0
                        )
                    </sql>
                </Module>
            </database>
        </package>

        <package version="375" releasedate="11-06-2014">
            <database file="Ecom.mdb">
                <Ecom7Tree>
                    <sql conditional="">
                        UPDATE [Ecom7Tree] SET [TreeHasAccessModuleSystemName] = 'eCom_Assortments' WHERE [TreeUrl] = '/Admin/Module/Ecom_cpl.aspx?cmd=9'
                    </sql>
                </Ecom7Tree>
            </database>
        </package>

        <package version="374" releasedate="11-06-2014">
        <database file="Ecom.mdb">
            <Ecom7Tree>
                <sql conditional="SELECT [ParentId] FROM [Ecom7Tree] WHERE  [TreeUrl] = '/Admin/Module/eCom_Catalog/dw7/edit/EcomAdvConfigBoosting_Edit.aspx'">
                    INSERT INTO [Ecom7Tree]
                    (
                        [ParentId],
                        [Text],
                        [Alt],
                        [TreeIcon],
                        [TreeUrl],
                        [TreeChildPopulate],
                        [TreeSort],
                        [TreeHasAccessModuleSystemName]
                    )
                    VALUES
                    (
                        94,
                        'Boosting',
                        7,
                        '/Admin/Images/Ribbon/Icons/Small/data_find.png',
                        '/Admin/Module/eCom_Catalog/dw7/edit/EcomAdvConfigBoosting_Edit.aspx',
                        'BOOSTING',
                        130,
                        ''
                    )
                </sql>
            </Ecom7Tree>
        </database>
    </package>
    
        

        <package version="373" releasedate="03-06-2014">
            <database file="Dynamic.mdb">
                <Module>
                    <sql conditional="">
                        UPDATE [Module] SET [ModuleParagraph] = 1 WHERE [ModuleSystemName] = 'eCom_ContextVoucherRenderer'
                    </sql>
                </Module>
            </database>
        </package>

        <package version="372" releasedate="03-06-2014">        
        </package>


        <package version="371" releasedate="02-06-2014">
        <database file="Ecom.mdb">
            <Ecom7Tree>
                <sql conditional="SELECT [ParentId] FROM [Ecom7Tree] WHERE  [TreeUrl] = '/Admin/Module/eCom_Catalog/dw7/edit/EcomAdvConfigLoyaltyPoints_Edit.aspx'">
                    INSERT INTO [Ecom7Tree]
                    (
                        [ParentId],
                        [Text],
                        [Alt],
                        [TreeIcon],
                        [TreeUrl],
                        [TreeChildPopulate],
                        [TreeSort],
                        [TreeHasAccessModuleSystemName]
                    )
                    VALUES
                    (
                        94,
                        'Loyalty points',
                        NULL,
                        '/Admin/Module/eCom_Catalog/dw7/images/tree/eCom_LoyaltyPoints_Settings_small.png',
                        '/Admin/Module/eCom_Catalog/dw7/edit/EcomAdvConfigLoyaltyPoints_Edit.aspx',
                        'LOYALTYPOINTS',
                        73,
                        'LoyaltyPoints'
                    )
                </sql>
            </Ecom7Tree>
        </database>
    </package>


    <package version="370" date="26-05-2014">
	    <database file="Ecom.mdb">
	        <EcomLoyaltyUserTransaction>
		        <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.tables WHERE ( name = 'EcomLoyaltyUserTransaction' ) )
                        CREATE TABLE EcomLoyaltyUserTransaction
                        (
                            LoyaltyUserTransactionId BIGINT NOT NULL IDENTITY(1,1),
                            LoyaltyUserTransactionUserId INT NOT NULL ,
                            LoyaltyUserTransactionRewardId INT NULL,
                            LoyaltyUserTransactionDate DATETIME NOT NULL DEFAULT GETDATE(),
                            LoyaltyUserTransactionPoints FLOAT NOT NULL,
                            LoyaltyUserTransactionObjectType NVARCHAR(255) NULL DEFAULT NULL,
                            LoyaltyUserTransactionObjectElement NVARCHAR(255) NULL DEFAULT NULL,
                            LoyaltyUserTransactionComment NVARCHAR(255) NULL DEFAULT NULL,
                            CONSTRAINT DW_PK_EcomLoyaltyUserTransaction PRIMARY KEY CLUSTERED (LoyaltyUserTransactionId ASC),
                        )
                </sql>
		        <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_EcomLoyaltyUserTransaction_UserId] 
                    ON [EcomLoyaltyUserTransaction] 
                        ([LoyaltyUserTransactionUserId] ASC)
                    INCLUDE 
                        ([LoyaltyUserTransactionId])                    
                </sql>
		        <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_EcomLoyaltyUserTransaction_RewardId] 
                    ON [EcomLoyaltyUserTransaction] 
                        ([LoyaltyUserTransactionRewardId] ASC)
                    INCLUDE 
                        ([LoyaltyUserTransactionId])
                </sql>
	        </EcomLoyaltyUserTransaction>
	        <EcomLoyaltyReward>
		        <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.tables WHERE ( name = 'EcomLoyaltyReward' ) )
                        CREATE TABLE EcomLoyaltyReward
                        (
                            LoyaltyRewardId INT NOT NULL IDENTITY(1,1) ,
                            LoyaltyRewardName NVARCHAR(50) NOT NULL ,
                            LoyaltyRewardType INT NOT NULL ,
                            LoyaltyRewardActive BIT NOT NULL DEFAULT 1,
                            LoyaltyRewardPoints FLOAT NULL DEFAULT NULL,
                            LoyaltyRewardCurrencyCode NVARCHAR(3) NULL DEFAULT NULL,
                            LoyaltyRewardRoundingId NVARCHAR(50) NULL DEFAULT NULL,
                            LoyaltyRewardPercentage FLOAT NULL DEFAULT NULL,
                            CONSTRAINT DW_PK_EcomLoyaltyReward PRIMARY KEY CLUSTERED (LoyaltyRewardId ASC),
                        )
                </sql>
		        <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_EcomLoyaltyReward_Active] 
                    ON [EcomLoyaltyReward] 
                        ([LoyaltyRewardActive] ASC)
                    INCLUDE 
                        ([LoyaltyRewardId])                    
                </sql>
		        <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_EcomLoyaltyReward_CurrencyCode] 
                    ON [EcomLoyaltyReward] 
                        ([LoyaltyRewardCurrencyCode] ASC)
                    INCLUDE 
                        ([LoyaltyRewardId])                    
                </sql>
		        <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_EcomLoyaltyReward_RoundingId] 
                    ON [EcomLoyaltyReward] 
                        ([LoyaltyRewardRoundingId] ASC)
                    INCLUDE 
                        ([LoyaltyRewardId])                    
                </sql>
	        </EcomLoyaltyReward>
	        <EcomLoyaltyRewardTranslation>
		        <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.tables WHERE ( name = 'EcomLoyaltyRewardTranslation' ) )
                        CREATE TABLE EcomLoyaltyRewardTranslation
                        (
                            LoyaltyRewardTranslationAutoId INT NOT NULL IDENTITY(1,1),
                            LoyaltyRewardTranslationRewardId INT NOT NULL,
                            LoyaltyRewardTranslationLanguageId NVARCHAR(50) NOT NULL,
                            LoyaltyRewardTranslationName NVARCHAR(50) NOT NULL,
                            CONSTRAINT DW_PK_EcomLoyaltyRewardTranslation PRIMARY KEY NONCLUSTERED (LoyaltyRewardTranslationLanguageId ASC, LoyaltyRewardTranslationRewardId ASC)
                        )
                </sql>
		        <sql conditional="">
                    CREATE CLUSTERED INDEX [DW_IX_EcomLoyaltyRewardTranslation_AutoId] 
                    ON [EcomLoyaltyRewardTranslation] 
                        ([LoyaltyRewardTranslationAutoId] ASC)
                </sql>
	        </EcomLoyaltyRewardTranslation>
	        <EcomLoyaltyRewardRule>
		        <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.tables WHERE ( name = 'EcomLoyaltyRewardRule' ) )
                        CREATE TABLE EcomLoyaltyRewardRule
                        (
                            LoyaltyRewardRuleId INT NOT NULL IDENTITY(1,1),
                            LoyaltyRewardRuleRewardId INT NOT NULL, 
                            LoyaltyRewardRuleShopId NVARCHAR(255) NULL DEFAULT NULL,
                            LoyaltyRewardRuleGroupId NVARCHAR(50) NULL DEFAULT NULL,
                            LoyaltyRewardRuleProductId NVARCHAR(30) NULL DEFAULT NULL,
                            LoyaltyRewardRuleProductVariantId NVARCHAR(255) NULL DEFAULT NULL,
                            LoyaltyRewardRuleProductLanguageId NVARCHAR(255) NULL DEFAULT NULL,
                            CONSTRAINT DW_PK_EcomLoyaltyRewardRule PRIMARY KEY CLUSTERED (LoyaltyRewardRuleId ASC),
                        )
                </sql>
		        <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_EcomLoyaltyRewardRule_RewardId] 
                    ON [EcomLoyaltyRewardRule] 
                        ([LoyaltyRewardRuleRewardId] ASC)
                    INCLUDE 
                        ([LoyaltyRewardRuleId])                    
                </sql>
		        <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_EcomLoyaltyRewardRule_ShopId] 
                    ON [EcomLoyaltyRewardRule] 
                        ([LoyaltyRewardRuleShopId] ASC)
                    INCLUDE 
                        ([LoyaltyRewardRuleId])                    
                </sql>
		        <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_EcomLoyaltyRewardRule_GroupId] 
                    ON [EcomLoyaltyRewardRule] 
                        ([LoyaltyRewardRuleGroupId] ASC)
                    INCLUDE 
                        ([LoyaltyRewardRuleId])                    
                </sql>
		        <sql conditional="">
                    CREATE NONCLUSTERED INDEX [DW_IX_EcomLoyaltyRewardRule_ProductLanguageId_ProductVariantId_ProductId] 
                    ON [EcomLoyaltyRewardRule] 
                        ([LoyaltyRewardRuleProductLanguageId] ASC,
                        [LoyaltyRewardRuleProductVariantId] ASC,
                        [LoyaltyRewardRuleProductId] ASC)
                    INCLUDE 
                        ([LoyaltyRewardRuleId])                    
                </sql>
	        </EcomLoyaltyRewardRule>
	        <EcomProducts>
		        <sql conditional="">
                    ALTER TABLE [EcomProducts]  ADD ProductPoints FLOAT NULL DEFAULT NULL
                </sql>
	        </EcomProducts>
	        <EcomOrders>
		        <sql conditional="">
                    ALTER TABLE [EcomOrders]  ADD OrderTotalPoints FLOAT NULL DEFAULT NULL, 
                                                  OrderTotalRewardPoints FLOAT NULL DEFAULT NULL
                </sql>
	        </EcomOrders>
	        <EcomOrderLines>
		        <sql conditional="">
                    ALTER TABLE [EcomOrderLines]  ADD OrderLineUnitPoints FLOAT NULL DEFAULT NULL, 
                                                      OrderLineUnitRewardPoints FLOAT NULL DEFAULT NULL,
                                                      OrderLinePoints FLOAT NULL DEFAULT NULL,
                                                      OrderLineRewardPoints FLOAT NULL DEFAULT NULL,
                                                      OrderLineRewardId INT NULL DEFAULT NULL
                </sql>
	        </EcomOrderLines>
	    </database>
    </package>

    <package version="369" date="14-05-2014">
	    <database file="Ecom.mdb">
	        <EcomSalesDiscount>
		        <sql conditional="">
                    ALTER TABLE [EcomSalesDiscount]  ADD SalesDiscountMinimumBasketSize FLOAT NULL
                </sql>
	        </EcomSalesDiscount>
	    </database>
    </package>

    <package version="368" releasedate="07-05-2014">
        <database file="Ecom.mdb">
            <EcomOrderLines>
                <sql conditional="">
                    ALTER TABLE [EcomOrderLines] ADD [OrderLinePriceCalculationReference] NVARCHAR(255) NULL
                </sql>
                <sql conditional="">
                    ALTER TABLE [EcomOrderLines] ADD [OrderLineUnitPriceCalculationReference] NVARCHAR(255) NULL
                </sql>
            </EcomOrderLines>
        </database>
    </package>

    <package version="367" releasedate="08-05-2014">
        <database file="Ecom.mdb">
            <ProductUnitCounter>
                <sql conditional="">
                    UPDATE EcomProducts
                    SET ProductUnitCounter = (SELECT DISTINCT COUNT(StockUnitID) FROM EcomStockUnit WHERE StockUnitProductID=ProductID)
                    WHERE ProductUnitCounter = 0
                </sql>
            </ProductUnitCounter>
        </database>
    </package>

    <package version="366" releasedate="05-05-2014">
        <database file="Ecom.mdb">
            <EcomFilterDefinition>
                <sql conditional="">
                    ALTER TABLE [EcomFilterDefinition] ADD [EcomFilterDefinitionSorting] INT NULL
                </sql>
            </EcomFilterDefinition>
        </database>
    </package>

    <package version="365" date="28-04-2014">
        <file name="PostDanmarkServicePoints.html" source="/Files/Templates/eCom7/ShippingProvider/" target="/Files/Templates/eCom7/ShippingProvider/" overwrite="false"/>
        <file name="PostDanmarkServicePoints_Ajax.html" source="/Files/Templates/eCom7/ShippingProvider/" target="/Files/Templates/eCom7/ShippingProvider/" overwrite="false"/>
    </package>

    <package version="364" releasedate="09-04-2014">
        <database file="Ecom.mdb">
            <EcomProductGroupField>
                <sql conditional="">
                    ALTER TABLE [EcomProductGroupField] ADD [ProductGroupFieldRequired] BIT NULL
                </sql>
            </EcomProductGroupField>
        </database>
    </package>


    <package version="363" releasedate="03-02-2014">
        <database file="Ecom.mdb">
            <EcomOrders>
                <sql conditional="">
                    IF NOT EXISTS(SELECT * FROM sys.columns WHERE ( name = 'OrderPriceCalculationDate' ) AND ( object_id = ( SELECT object_id FROM sys.tables WHERE ( name = 'EcomOrders' ) ) ) )
                        ALTER TABLE [EcomOrders] ADD OrderPriceCalculationDate DATETIME NULL
                </sql>
                <sql conditional="SELECT NOW()">
                    ALTER TABLE [EcomOrders] ADD OrderPriceCalculationDate DATETIME NULL
                </sql>
            </EcomOrders>
        </database>

        <file name="PaymentWindowPostTemplate.html" target="/Files/Templates/eCom7/CheckoutHandler/DIBS/Post" source="/Files/Templates/eCom7/CheckoutHandler/DIBS/Post" />
    </package>

    <package version="362" releasedate="04-04-2014">        
    </package>

    <package version="361" releasedate="03-04-2014">
        <database file="Ecom.mdb">
            <EcomFilters>
                <sql conditional="SELECT CASE WHEN COUNT(*) > 0 THEN 0 ELSE 1 END AS [AllowClean] FROM [EcomProductCategory]">
                    SELECT [EcomFilterSettingDefinitionID]
                    INTO #OldCategories
                      FROM [EcomFilterSetting]
                      WHERE
                      [EcomFilterSettingName] = 'Field'
                      AND [EcomFilterSettingValue] LIKE 'CF_[[]%'
                      AND CHARINDEX(']', [EcomFilterSettingValue], 5) > 5
                      AND NOT SUBSTRING([EcomFilterSettingValue], 5, CHARINDEX(']', [EcomFilterSettingValue], 5) - 5) IN (SELECT CategoryId  FROM [EcomProductCategory]);

                    DELETE FROM [EcomFilterDefinitionTranslation] WHERE [EcomFilterDefinitionTranslationFilterDefinitionID] IN (SELECT [EcomFilterSettingDefinitionID] FROM  #OldCategories);
                    DELETE FROM [EcomGroupFilterSetting] WHERE [EcomGroupFilterSettingDefinitionID] IN (SELECT [EcomFilterSettingDefinitionID] FROM  #OldCategories);
                    DELETE FROM [EcomGroupFilterOption] WHERE [EcomGroupFilterOptionDefinitionID]  IN (SELECT [EcomFilterSettingDefinitionID] FROM  #OldCategories);
                    DELETE FROM [EcomFilterSetting] WHERE [EcomFilterSettingDefinitionID] IN (SELECT [EcomFilterSettingDefinitionID] FROM  #OldCategories);
                    DELETE FROM [EcomFilterVisibilityCondition] WHERE [EcomFilterVisibilityConditionDefinitionID] IN  (SELECT [EcomFilterSettingDefinitionID] FROM  #OldCategories);
                    DELETE FROM [EcomFilterDefinition] WHERE [EcomFilterDefinitionID] IN (SELECT [EcomFilterSettingDefinitionID] FROM  #OldCategories);
                    DROP TABLE #OldCategories;
                </sql>
            </EcomFilters>
        </database>
    </package>

    <package version="360" releasedate="30-04-2014">
        <database file="Ecom.mdb">
            <Ecom7Tree>
                <sql conditional="SELECT [ParentId] FROM [Ecom7Tree] WHERE [TreeUrl] = '/Admin/Module/Ecom_cpl.aspx?cmd=9' OR [TreeHasAccessModuleSystemName] = 'eCom_Assortments'">
                    INSERT INTO [Ecom7Tree]
                    (
                        [ParentId],
                        [Text],
                        [Alt],
                        [TreeIcon],
                        [TreeUrl],
                        [TreeChildPopulate],
                        [TreeSort],
                        [TreeHasAccessModuleSystemName]
                    )
                    VALUES
                    (
                        94,
                        'Assortments',
                        NULL,
                        '/Admin/Images/eCom/Module_eCom_Assortments_small.gif',
                        '/Admin/Module/Ecom_cpl.aspx?cmd=9',
                        'ASSORTMENTS',
                        75,
                        'eCom_Catalog'
                    )
                </sql>
            </Ecom7Tree>
        </database>
    </package>
        
    <package version="359" releasedate="22-04-2014">
        <file name="ReceiptTaxes.html" target="Files/Templates/eCom7/CartV2/Step" source="Files/Templates/eCom7/CartV2/Step" />
    </package>

    <package version="358" releasedate="27-03-2014">
        <database file="Ecom.mdb">
            <EcomPrices>
                <sql conditional="">
                    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE ( name = N'DW_IX_EcomPrices_ProductId_ProductVariantId_ProductLanguageId' ) )
	                    CREATE NONCLUSTERED INDEX [DW_IX_EcomPrices_ProductId_ProductVariantId_ProductLanguageId] 
	                    ON [EcomPrices] 
	                    (
		                    [PriceProductID] ASC,
		                    [PriceProductVariantID] ASC,
		                    [PriceProductLanguageID] ASC
	                    )
	                    INCLUDE 
	                    (
		                    [PriceCurrency],
		                    [PriceQuantity],
		                    [PriceUnitID],
		                    [PricePeriodID],
		                    [PriceUserCustomerNumber],
		                    [PriceCountry],
		                    [PriceShopId],
		                    [PriceValidFrom],
		                    [PriceValidTo],
		                    [PriceUserId],
		                    [PriceUserGroupId],
		                    [PriceAmount]
	                    )
                </sql>
            </EcomPrices>
        </database>
    </package>

    <package version="357" releasedate="27-03-2014">
        <database file="Ecom.mdb">
            <EcomPrices>
                <sql conditional="">
                    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE ( name = N'DW_IX_EcomPrices_AutoId' ) )
	                    CREATE UNIQUE CLUSTERED INDEX [DW_IX_EcomPrices_AutoId]
	                    ON [EcomPrices]([PriceAutoId] ASC)
                </sql>
            </EcomPrices>
        </database>
    </package>

    <package version="356" releasedate="27-03-2014">
        <database file="Ecom.mdb">
            <EcomPrices>
                <sql conditional="">
                    IF NOT EXISTS(SELECT * FROM sys.columns WHERE ( name = 'PriceAutoId' ) AND ( object_id = ( SELECT object_id FROM sys.tables WHERE ( name = 'EcomPrices' ) ) ) )
	                    ALTER TABLE [EcomPrices] ADD [PriceAutoId] INT NOT NULL IDENTITY(1,1)
                </sql>
                <sql conditional="SELECT NOW()">
                    ALTER TABLE [EcomPrices] ADD [PriceAutoId] INT NOT NULL IDENTITY(1,1)
                </sql>
            </EcomPrices>
        </database>
    </package>

    <package version="355" releasedate="24-03-2014">
        <database file="Ecom.mdb">
            <EcomProducts>
                <sql conditional="">
                    IF EXISTS (SELECT * FROM sys.indexes WHERE name = N'EverythingIndex_on_EcomProducts')
	                    DROP INDEX EverythingIndex_on_EcomProducts 
	                    ON EcomProducts
                </sql>
                <sql conditional="">
                    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = N'DW_IX_EcomProducts_AutoId' )
	                    CREATE UNIQUE CLUSTERED INDEX DW_IX_EcomProducts_AutoId 
	                    ON EcomProducts
	                    (
		                    ProductAutoId ASC
	                    )
                </sql>
            </EcomProducts>
        </database>
    </package>

    <package version="354" releasedate="19-03-2014">
        <file name="Navigation.html" target="/Files/Templates/eCom/CustomerCenter" source="/Files/Templates/eCom/CustomerCenter" />
        <file name="NavigationFull.html" target="/Files/Templates/eCom/CustomerCenter" source="/Files/Templates/eCom/CustomerCenter" />
        <file name="NavigationRMA.html" target="/Files/Templates/eCom/CustomerCenter" source="/Files/Templates/eCom/CustomerCenter" />
    </package>

    <package version="353" releasedate="28-02-2014">
        <database file="Dynamic.mdb">
            <Module>
                <sql conditional="SELECT COUNT(*) FROM [Module] WHERE [ModuleSystemName] = 'eCom_BackCatalog' AND [ModuleEcomNotInstalledAccess] = 0">
                    UPDATE [Module] SET [ModuleEcomNotInstalledAccess] = 0 WHERE [ModuleSystemName] = 'eCom_ShowList'
                </sql>
            </Module>
        </database>
    </package>

     <package version="352" date="25-02-2014">
		<database file="Dynamic.mdb">
			<EcomPeriods>
				<sql conditional="">
                    ALTER TABLE EcomPeriods ADD PeriodHidden BIT NOT NULL DEFAULT blnFalse
				</sql>     		
          	</EcomPeriods>
            <EcomTree>
                <sql conditional="">
                    UPDATE EcomTree SET [Text] = 'Publication periods' WHERE [Text] LIKE 'Kampagner'
                </sql>
          	</EcomTree>		
            <Ecom7Tree>
                <sql conditional="">
                    UPDATE Ecom7Tree SET [Text] = 'Publication periods' WHERE [Text] LIKE 'Kampagner'
                </sql>
          	</Ecom7Tree>			  
		</database>
    </package>

    <package version="351" releasedate="07-02-2014">
        <file name="ProductListCustomerCenterList.html" target="/Files/Templates/eCom/ProductList" source="/Files/Templates/eCom/ProductList" />
        <file name="FavoritesList.html" target="/Files/Templates/eCom/CustomerCenter" source="/Files/Templates/eCom/CustomerCenter" />
        <file name="MyList.html" target="/Files/Templates/eCom/CustomerCenter" source="/Files/Templates/eCom/CustomerCenter" />
    </package>

    <package version="350" releasedate="06-02-2014">
        <file name="Post.html" target="Files/Templates/eCom7/CheckoutHandler/ePay/Post" source="Files/Templates/eCom7/CheckoutHandler/ePay/Post" />
        <file name="Post_simple.html" target="Files/Templates/eCom7/CheckoutHandler/ePay/Post" source="Files/Templates/eCom7/CheckoutHandler/ePay/Post" />
        <file name="Cancel.html" target="Files/Templates/eCom7/CheckoutHandler/ePay/Cancel" source="Files/Templates/eCom7/CheckoutHandler/ePay/Cancel" />
        <file name="Error.html" target="Files/Templates/eCom7/CheckoutHandler/ePay/Error" source="Files/Templates/eCom7/CheckoutHandler/ePay/Error" />
    </package>

    <package version="349" releasedate="05-02-2014">
        <database file="Ecom.mdb">
            <EcomOrderLines>
                <sql conditional="">
                    IF NOT EXISTS(SELECT * FROM sys.columns WHERE ( name = 'OrderLineWishListId' ) AND ( object_id = ( SELECT object_id FROM sys.tables WHERE ( name = 'EcomOrderLines' ) ) ) )
                        ALTER TABLE [EcomOrderLines] ADD OrderLineWishListId INT NOT NULL DEFAULT 0
                </sql>
                <sql conditional="SELECT NOW()">
                    ALTER TABLE [EcomOrderLines] ADD OrderLineWishListId INT NOT NULL DEFAULT 0
                </sql>
            </EcomOrderLines>
        </database>
    </package>

    <package version="348" releasedate="04-02-2014">
    </package>

    <package version="347" releasedate="04-02-2014">        
        <database file="Dynamic.mdb">
            <Module>
                <sql conditional="SELECT COUNT(*) FROM [Module] WHERE [ModuleSystemName] = 'eCom_Vouchers'">
                    INSERT INTO [Module]    (   [ModuleSystemName]  , [ModuleName]  , [ModuleAccess], [ModuleParagraph] , [ModuleEcomNotInstalledAccess]    , [ModuleIsBeta])
                    VALUES                  (   'eCom_Vouchers'     , 'Vouchers'    , blnFalse      , blnFalse          , blnFalse                          , blnFalse      )                    
                </sql>
            </Module>
        </database>
    </package>

    <package version="346" date="13-03-2014">
	    <database file="Ecom.mdb">
            <EcomOrderStates>
                <sql conditional="">ALTER TABLE [EcomOrderStates] ADD 
                                        [OrderStateSendToCustomer] BIT NULL,
                                        [OrderStateOthersMailTemplate] NVARCHAR(255) NULL,
                                        [OrderStateOthersRecipients] NVARCHAR(MAX) NULL
                </sql>
                <sql conditional="">
                    UPDATE [EcomOrderStates] SET [OrderStateSendToCustomer] = blnTrue WHERE [OrderStateSendToCustomer] IS NULL AND [OrderStateMailTemplate] IS NOT NULL
                </sql>
            </EcomOrderStates>
        </database>
    </package>

    <package version="345" releasedate="04-03-2014">
        <database file="Ecom.mdb">
            <EcomAssortmentItems>
                <sql conditional="">
                    IF NOT EXISTS( SELECT index_id FROM sys.indexes WHERE ( name = 'DW_IX_EcomAssortmentItems_ProductID' ) )
	                    CREATE NONCLUSTERED INDEX [DW_IX_EcomAssortmentItems_ProductID] ON [dbo].[EcomAssortmentItems] 
	                    (
		                    [AssortmentItemProductID] ASC
	                    )
	                    INCLUDE ([AssortmentItemAssortmentID],[AssortmentItemProductVariantID],[AssortmentItemAutoID]) 
                </sql>
            </EcomAssortmentItems>
            <EcomProducts>
                <sql conditional="">
                    IF NOT EXISTS( SELECT index_id FROM sys.indexes WHERE ( name = 'DW_IX_EcomProducts_Active_LanguageID_VariantID_ProductID_Name' ) )
	                    CREATE UNIQUE NONCLUSTERED INDEX [DW_IX_EcomProducts_Active_LanguageID_VariantID_ProductID_Name] ON [dbo].[EcomProducts] 
	                    (
		                    [ProductActive] ASC,
		                    [ProductLanguageID] ASC,
		                    [ProductVariantID] ASC,
		                    [ProductID] ASC,
		                    [ProductName] ASC
	                    )
                </sql>
            </EcomProducts>
            <EcomGroupProductRelation>
                <sql conditional="">
                    IF NOT EXISTS( SELECT index_id FROM sys.indexes WHERE ( name = 'DW_IX_EcomGroupProductRelation_GroupID_ProductID' ) )
	                    CREATE UNIQUE NONCLUSTERED INDEX [DW_IX_EcomGroupProductRelation_GroupID_ProductID] ON [dbo].[EcomGroupProductRelation] 
	                    (
		                    [GroupProductRelationProductID] ASC,
		                    [GroupProductRelationGroupID] ASC
	                    )
	                    INCLUDE ([GroupProductRelationSorting],[GroupProductRelationId]) 
                </sql>
            </EcomGroupProductRelation>
        </database>
    </package>
    
    <package version="344" releasedate="11-02-2014">
        <database file="Ecom.mdb">
            <EcomAssortments>
                <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.tables WHERE ( name = 'EcomAssortments' ) )
                        CREATE TABLE EcomAssortments
                        (
	                        AssortmentID NVARCHAR(50) NOT NULL,
	                        AssortmentLanguageID NVARCHAR(50) NOT NULL,
	                        AssortmentName NVARCHAR(255) NULL,
	                        AssortmentNumber NVARCHAR(255) NULL,
	                        AssortmentPeriodID NVARCHAR(50) NULL,
	                        AssortmentLastBuildDate DATETIME NULL,
	                        AssortmentRebuildRequired BIT NOT NULL DEFAULT(0),
	                        AssortmentAutoID INT IDENTITY(1,1) NOT NULL,
	                        CONSTRAINT PK_EcomAssortments PRIMARY KEY NONCLUSTERED ( AssortmentID ASC, AssortmentLanguageID ASC ),
	                        CONSTRAINT FK_EcomAssortments_EcomLanguages FOREIGN KEY ( AssortmentLanguageID ) REFERENCES EcomLanguages ( LanguageID ) ON UPDATE CASCADE ON DELETE CASCADE,
	                        CONSTRAINT FK_EcomAssortments_EcomPeriods FOREIGN KEY ( AssortmentPeriodID ) REFERENCES EcomPeriods ( PeriodID ) ON UPDATE CASCADE ON DELETE SET NULL
                        )
                </sql>
                <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.indexes WHERE ( name = 'IX_EcomAssortments_AutoID' ) )
	                    BEGIN
		                    IF EXISTS( SELECT 'Enterprise' AS EngineEdition WHERE SERVERPROPERTY('EngineEdition') = 3 )
			                    BEGIN
                                    CREATE UNIQUE CLUSTERED INDEX IX_EcomAssortments_AutoID
                                    ON EcomAssortments ( AssortmentAutoID ASC )
                                    WITH ( PAD_INDEX  = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON ) 
			                    END
		                    ELSE
			                    BEGIN
                                    CREATE UNIQUE CLUSTERED INDEX IX_EcomAssortments_AutoID
                                    ON EcomAssortments ( AssortmentAutoID ASC )
                                    WITH ( PAD_INDEX  = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF ) 
			                    END
	                    END
                </sql>
                <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.indexes WHERE ( name = 'IX_EcomAssortments_LanguageID' ) )
	                    BEGIN
		                    IF EXISTS( SELECT 'Enterprise' AS EngineEdition WHERE SERVERPROPERTY('EngineEdition') = 3 )
			                    BEGIN
				                    CREATE NONCLUSTERED INDEX IX_EcomAssortments_LanguageID
                                    ON EcomAssortments ( AssortmentLanguageID ASC )
                                    INCLUDE ( AssortmentAutoID ) 
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON )
			                    END
		                    ELSE
			                    BEGIN
				                    CREATE NONCLUSTERED INDEX IX_EcomAssortments_LanguageID
                                    ON EcomAssortments ( AssortmentLanguageID ASC )
                                    INCLUDE ( AssortmentAutoID ) 
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF )
			                    END
	                    END
                </sql>
                <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.indexes WHERE ( name = 'IX_EcomAssortments_PeriodID' ) )
	                    BEGIN
		                    IF EXISTS( SELECT 'Enterprise' AS EngineEdition WHERE SERVERPROPERTY('EngineEdition') = 3 )
			                    BEGIN
                                    CREATE NONCLUSTERED INDEX IX_EcomAssortments_PeriodID 
                                    ON EcomAssortments ( AssortmentPeriodID ASC )
                                    INCLUDE ( AssortmentAutoID ) 
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON )
			                    END
		                    ELSE
			                    BEGIN
                                    CREATE NONCLUSTERED INDEX IX_EcomAssortments_PeriodID 
                                    ON EcomAssortments ( AssortmentPeriodID ASC )
                                    INCLUDE ( AssortmentAutoID ) 
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF )
			                    END
	                    END
                </sql>
            </EcomAssortments>
            <EcomAssortmentPermissions>
                <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.tables WHERE ( name = 'EcomAssortmentPermissions' ) )
                        CREATE TABLE EcomAssortmentPermissions
                        (
	                        AssortmentPermissionAssortmentID NVARCHAR(50) NOT NULL,
	                        AssortmentPermissionAccessUserID INT NOT NULL,
	                        AssortmentPermissionAutoID INT IDENTITY(1,1) NOT NULL,
	                        CONSTRAINT PK_EcomAssortmentPermissions PRIMARY KEY NONCLUSTERED ( AssortmentPermissionAssortmentID ASC, AssortmentPermissionAccessUserID ASC ),
	                        CONSTRAINT FK_EcomAssortmentPermissions_AccessUser FOREIGN KEY( AssortmentPermissionAccessUserID ) REFERENCES AccessUser ( AccessUserID ) ON UPDATE CASCADE ON DELETE CASCADE
                        )
                </sql>
                <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.indexes WHERE ( name = 'IX_EcomAssortmentPermissions_AutoID' ) )
	                    BEGIN
		                    IF EXISTS( SELECT 'Enterprise' AS EngineEdition WHERE SERVERPROPERTY('EngineEdition') = 3 )
			                    BEGIN
                                    CREATE UNIQUE CLUSTERED INDEX IX_EcomAssortmentPermissions_AutoID 
                                    ON dbo.EcomAssortmentPermissions ( AssortmentPermissionAutoID ASC )
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON )
			                    END
		                    ELSE
			                    BEGIN
                                    CREATE UNIQUE CLUSTERED INDEX IX_EcomAssortmentPermissions_AutoID 
                                    ON dbo.EcomAssortmentPermissions ( AssortmentPermissionAutoID ASC )
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF )
			                    END
	                    END
                </sql>
                <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.indexes WHERE ( name = 'IX_EcomAssortmentPermissions_AssortmentID' ) )
	                    BEGIN
		                    IF EXISTS( SELECT 'Enterprise' AS EngineEdition WHERE SERVERPROPERTY('EngineEdition') = 3 )
			                    BEGIN
                                    CREATE NONCLUSTERED INDEX IX_EcomAssortmentPermissions_AssortmentID 
                                    ON EcomAssortmentPermissions ( AssortmentPermissionAssortmentID ASC )
                                    INCLUDE ( AssortmentPermissionAutoID ) 
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON ) 
			                    END
		                    ELSE
			                    BEGIN
                                    CREATE NONCLUSTERED INDEX IX_EcomAssortmentPermissions_AssortmentID 
                                    ON EcomAssortmentPermissions ( AssortmentPermissionAssortmentID ASC )
                                    INCLUDE ( AssortmentPermissionAutoID ) 
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF ) 
			                    END
	                    END
                </sql>
                <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.indexes WHERE ( name = 'IX_EcomAssortmentPermissions_AccessUserID' ) )
	                    BEGIN
		                    IF EXISTS( SELECT 'Enterprise' AS EngineEdition WHERE SERVERPROPERTY('EngineEdition') = 3 )
			                    BEGIN
                                    CREATE NONCLUSTERED INDEX IX_EcomAssortmentPermissions_AccessUserID
                                    ON EcomAssortmentPermissions ( AssortmentPermissionAccessUserID ASC )
                                    INCLUDE ( AssortmentPermissionAutoID ) 
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON )
			                    END
		                    ELSE
			                    BEGIN
                                    CREATE NONCLUSTERED INDEX IX_EcomAssortmentPermissions_AccessUserID
                                    ON EcomAssortmentPermissions ( AssortmentPermissionAccessUserID ASC )
                                    INCLUDE ( AssortmentPermissionAutoID ) 
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF )
			                    END
	                    END
                </sql>
            </EcomAssortmentPermissions>
            <EcomAssortmentShopRelations>
                <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.tables WHERE ( name = 'EcomAssortmentShopRelations' ) )
	                    CREATE TABLE EcomAssortmentShopRelations
	                    (
		                    AssortmentShopRelationAssortmentID NVARCHAR(50) NOT NULL,
		                    AssortmentShopRelationShopID NVARCHAR(255) NOT NULL,
		                    AssortmentShopRelationAutoID INT NOT NULL IDENTITY(1,1)
		                    CONSTRAINT PK_EcomAssortmentShopRelations PRIMARY KEY NONCLUSTERED ( AssortmentShopRelationAssortmentID, AssortmentShopRelationShopID ),
		                    CONSTRAINT FK_EcomAssortmentShopRelations_EcomShops FOREIGN KEY ( AssortmentShopRelationShopID ) REFERENCES EcomShops ( ShopID ) ON UPDATE CASCADE ON DELETE CASCADE	
	                    )
                </sql>
                <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.indexes WHERE ( name = 'IX_EcomAssortmentShopRelations_AutoID' ) )
	                    BEGIN
		                    IF EXISTS( SELECT 'Enterprise' AS EngineEdition WHERE SERVERPROPERTY('EngineEdition') = 3 )
			                    BEGIN
                                    CREATE UNIQUE CLUSTERED INDEX IX_EcomAssortmentShopRelations_AutoID 
                                    ON EcomAssortmentShopRelations ( AssortmentShopRelationAutoID ASC )
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON ) 
			                    END
		                    ELSE
			                    BEGIN
                                    CREATE UNIQUE CLUSTERED INDEX IX_EcomAssortmentShopRelations_AutoID 
                                    ON EcomAssortmentShopRelations ( AssortmentShopRelationAutoID ASC )
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF ) 
			                    END
	                    END
                </sql>
                <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.indexes WHERE ( name = 'IX_EcomAssortmentShopRelations_AssortmentID' ) )
	                    BEGIN
		                    IF EXISTS( SELECT 'Enterprise' AS EngineEdition WHERE SERVERPROPERTY('EngineEdition') = 3 )
			                    BEGIN
                                    CREATE NONCLUSTERED INDEX IX_EcomAssortmentShopRelations_AssortmentID 
                                    ON EcomAssortmentShopRelations ( AssortmentShopRelationAssortmentID ASC )
                                    INCLUDE ( AssortmentShopRelationAutoID ) 
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON )
			                    END
		                    ELSE
			                    BEGIN
				                    CREATE NONCLUSTERED INDEX IX_EcomAssortmentShopRelations_AssortmentID 
                                    ON EcomAssortmentShopRelations ( AssortmentShopRelationAssortmentID ASC )
                                    INCLUDE ( AssortmentShopRelationAutoID ) 
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF )
			                    END
	                    END
                </sql>
                <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.indexes WHERE ( name = 'IX_EcomAssortmentShopRelations_ShopID' ) )
	                    BEGIN
		                    IF EXISTS( SELECT 'Enterprise' AS EngineEdition WHERE SERVERPROPERTY('EngineEdition') = 3 )
			                    BEGIN
                                    CREATE NONCLUSTERED INDEX IX_EcomAssortmentShopRelations_ShopID 
                                    ON EcomAssortmentShopRelations ( AssortmentShopRelationShopID ASC )
                                    INCLUDE ( AssortmentShopRelationAutoID ) 
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON )
			                    END
		                    ELSE
			                    BEGIN
				                    CREATE NONCLUSTERED INDEX IX_EcomAssortmentShopRelations_ShopID 
                                    ON EcomAssortmentShopRelations ( AssortmentShopRelationShopID ASC )
                                    INCLUDE ( AssortmentShopRelationAutoID ) 
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON )
			                    END
	                    END
                </sql>
            </EcomAssortmentShopRelations>
            <EcomAssortmentGroupRelations>
                <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.tables WHERE ( name = 'EcomAssortmentGroupRelations' ) )
	                    CREATE TABLE EcomAssortmentGroupRelations
	                    (
		                    AssortmentGroupRelationAssortmentID NVARCHAR(50) NOT NULL,
		                    AssortmentGroupRelationGroupID NVARCHAR(255) NOT NULL,
		                    AssortmentGroupRelationAutoID INT NOT NULL IDENTITY(1,1)
		                    CONSTRAINT PK_EcomAssortmentGroupRelations PRIMARY KEY NONCLUSTERED ( AssortmentGroupRelationAssortmentID, AssortmentGroupRelationGroupID )
	                    )
                </sql>
                <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.indexes WHERE ( name = 'IX_EcomAssortmentGroupRelations_AutoID' ) )
	                    BEGIN
		                    IF EXISTS( SELECT 'Enterprise' AS EngineEdition WHERE SERVERPROPERTY('EngineEdition') = 3 )
			                    BEGIN
                                    CREATE UNIQUE CLUSTERED INDEX IX_EcomAssortmentGroupRelations_AutoID 
                                    ON EcomAssortmentGroupRelations ( AssortmentGroupRelationAutoID ASC )
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON )
			                    END
		                    ELSE
			                    BEGIN
                                    CREATE UNIQUE CLUSTERED INDEX IX_EcomAssortmentGroupRelations_AutoID 
                                    ON EcomAssortmentGroupRelations ( AssortmentGroupRelationAutoID ASC )
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF )
			                    END
	                    END
                </sql>
                <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.indexes WHERE ( name = 'IX_EcomAssortmentGroupRelations_AssortmentID' ) )
	                    BEGIN
		                    IF EXISTS( SELECT 'Enterprise' AS EngineEdition WHERE SERVERPROPERTY('EngineEdition') = 3 )
			                    BEGIN
                                    CREATE NONCLUSTERED INDEX IX_EcomAssortmentGroupRelations_AssortmentID 
                                    ON EcomAssortmentGroupRelations ( AssortmentGroupRelationAssortmentID ASC )
                                    INCLUDE ( AssortmentGroupRelationAutoID ) 
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON )
			                    END
		                    ELSE
			                    BEGIN
                                    CREATE NONCLUSTERED INDEX IX_EcomAssortmentGroupRelations_AssortmentID 
                                    ON EcomAssortmentGroupRelations ( AssortmentGroupRelationAssortmentID ASC )
                                    INCLUDE ( AssortmentGroupRelationAutoID ) 
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF )
			                    END
	                    END
                </sql>
                <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.indexes WHERE ( name = 'IX_EcomAssortmentGroupRelations_GroupID' ) )
	                    BEGIN
		                    IF EXISTS( SELECT 'Enterprise' AS EngineEdition WHERE SERVERPROPERTY('EngineEdition') = 3 )
			                    BEGIN
                                    CREATE NONCLUSTERED INDEX IX_EcomAssortmentGroupRelations_GroupID 
                                    ON EcomAssortmentGroupRelations ( AssortmentGroupRelationGroupID ASC )
                                    INCLUDE ( AssortmentGroupRelationAutoID ) 
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON ) 
			                    END
		                    ELSE
			                    BEGIN
				                    CREATE NONCLUSTERED INDEX IX_EcomAssortmentGroupRelations_GroupID 
                                    ON EcomAssortmentGroupRelations ( AssortmentGroupRelationGroupID ASC )
                                    INCLUDE ( AssortmentGroupRelationAutoID ) 
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF ) 
			                    END
	                    END
                </sql>
            </EcomAssortmentGroupRelations>
            <EcomAssortmentProductRelations>
                <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.tables WHERE ( name = 'EcomAssortmentProductRelations' ) )
	                    CREATE TABLE EcomAssortmentProductRelations
	                    (
		                    AssortmentProductRelationAssortmentID NVARCHAR(50) NOT NULL,
		                    AssortmentProductRelationProductID NVARCHAR(30) NOT NULL,
		                    AssortmentProductRelationProductVariantID NVARCHAR(255) NOT NULL,
		                    AssortmentProductRelationAutoID INT NOT NULL IDENTITY(1,1),
		                    AssortmentProductRelationProductNumber NVARCHAR(255) NULL
		                    CONSTRAINT PK_EcomAssortmentProductRelations PRIMARY KEY NONCLUSTERED ( AssortmentProductRelationAssortmentID, AssortmentProductRelationProductID, AssortmentProductRelationProductVariantID )
	                    )
                </sql>
                <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.indexes WHERE ( name = 'IX_EcomAssortmentProductRelations_AssortmentID' ) )
	                    BEGIN
		                    IF EXISTS( SELECT 'Enterprise' AS EngineEdition WHERE SERVERPROPERTY('EngineEdition') = 3 )
			                    BEGIN
				                    CREATE NONCLUSTERED INDEX IX_EcomAssortmentProductRelations_AssortmentID 
                                    ON EcomAssortmentProductRelations ( AssortmentProductRelationAssortmentID ASC )
                                    INCLUDE ( AssortmentProductRelationAutoID ) 
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON ) 
			                    END
		                    ELSE
			                    BEGIN
				                    CREATE NONCLUSTERED INDEX IX_EcomAssortmentProductRelations_AssortmentID 
                                    ON EcomAssortmentProductRelations ( AssortmentProductRelationAssortmentID ASC )
                                    INCLUDE ( AssortmentProductRelationAutoID ) 
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF ) 
			                    END
	                    END
                </sql>
                <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.indexes WHERE ( name = 'IX_EcomAssortmentProductRelations_ProductID_ProductVariantID' ) )
	                    BEGIN
		                    IF EXISTS( SELECT 'Enterprise' AS EngineEdition WHERE SERVERPROPERTY('EngineEdition') = 3 )
			                    BEGIN
                                    CREATE NONCLUSTERED INDEX IX_EcomAssortmentProductRelations_ProductID_ProductVariantID 
                                    ON EcomAssortmentProductRelations ( AssortmentProductRelationProductID ASC, AssortmentProductRelationProductVariantID ASC )
                                    INCLUDE ( AssortmentProductRelationAutoID ) 
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON )
			                    END
		                    ELSE
			                    BEGIN
				                    CREATE NONCLUSTERED INDEX IX_EcomAssortmentProductRelations_ProductID_ProductVariantID 
                                    ON EcomAssortmentProductRelations ( AssortmentProductRelationProductID ASC, AssortmentProductRelationProductVariantID ASC )
                                    INCLUDE ( AssortmentProductRelationAutoID ) 
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF )
			                    END
	                    END
                </sql>
            </EcomAssortmentProductRelations>
            <EcomAssortmentItems>
                <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.tables WHERE ( name = 'EcomAssortmentItems' ) )
                        CREATE TABLE EcomAssortmentItems
                        (
	                        AssortmentItemAssortmentID NVARCHAR(50) NOT NULL,
	                        AssortmentItemRelationAutoID INT NOT NULL,
	                        AssortmentItemRelationType NVARCHAR(50) NOT NULL,
	                        AssortmentItemLanguageID NVARCHAR(50) NOT NULL,
	                        AssortmentItemProductID NVARCHAR(30) NOT NULL,
	                        AssortmentItemProductVariantID NVARCHAR(255) NOT NULL,
	                        AssortmentItemAutoID INT IDENTITY(1,1) NOT NULL,
	                        CONSTRAINT PK_EcomAssortmentItems PRIMARY KEY NONCLUSTERED ( AssortmentItemAssortmentID ASC, AssortmentItemRelationAutoID ASC, AssortmentItemRelationType ASC, AssortmentItemLanguageID ASC, AssortmentItemProductID ASC, AssortmentItemProductVariantID ASC ),
	                        CONSTRAINT FK_EcomAssortmentItems_EcomAssortments FOREIGN KEY( AssortmentItemAssortmentID, AssortmentItemLanguageID ) REFERENCES EcomAssortments ( AssortmentID, AssortmentLanguageID ) ON UPDATE CASCADE ON DELETE CASCADE
                        )
                </sql>
                <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.indexes WHERE ( name = 'IX_EcomAssortmentItems_AutoID' ) )
	                    BEGIN
		                    IF EXISTS( SELECT 'Enterprise' AS EngineEdition WHERE SERVERPROPERTY('EngineEdition') = 3 )
			                    BEGIN
                                    CREATE UNIQUE CLUSTERED INDEX IX_EcomAssortmentItems_AutoID 
                                    ON EcomAssortmentItems ( AssortmentItemAutoID ASC )
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON )
			                    END
		                    ELSE
			                    BEGIN
				                    CREATE UNIQUE CLUSTERED INDEX IX_EcomAssortmentItems_AutoID 
                                    ON EcomAssortmentItems ( AssortmentItemAutoID ASC )
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF )
			                    END
	                    END
                </sql>
                <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.indexes WHERE ( name = 'IX_EcomAssortmentItems_AssortmentID' ) )
	                    BEGIN
		                    IF EXISTS( SELECT 'Enterprise' AS EngineEdition WHERE SERVERPROPERTY('EngineEdition') = 3 )
			                    BEGIN
                                    CREATE NONCLUSTERED INDEX IX_EcomAssortmentItems_AssortmentID 
                                    ON EcomAssortmentItems ( AssortmentItemAssortmentID ASC )
                                    INCLUDE ( AssortmentItemAutoID ) 
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON )
			                    END
		                    ELSE
			                    BEGIN
				                    CREATE NONCLUSTERED INDEX IX_EcomAssortmentItems_AssortmentID 
                                    ON EcomAssortmentItems ( AssortmentItemAssortmentID ASC )
                                    INCLUDE ( AssortmentItemAutoID ) 
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF )
			                    END
	                    END
                </sql>
                <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.indexes WHERE ( name = 'IX_EcomAssortmentItems_RelationType_RelationAutoID' ) )
	                    BEGIN
		                    IF EXISTS( SELECT 'Enterprise' AS EngineEdition WHERE SERVERPROPERTY('EngineEdition') = 3 )
			                    BEGIN
				                    CREATE NONCLUSTERED INDEX IX_EcomAssortmentItems_RelationType_RelationAutoID 
                                    ON EcomAssortmentItems ( AssortmentItemRelationType ASC, AssortmentItemRelationAutoID ASC )
                                    INCLUDE ( AssortmentItemAutoID ) 
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON )
			                    END
		                    ELSE
			                    BEGIN
				                    CREATE NONCLUSTERED INDEX IX_EcomAssortmentItems_RelationType_RelationAutoID 
                                    ON EcomAssortmentItems ( AssortmentItemRelationType ASC, AssortmentItemRelationAutoID ASC )
                                    INCLUDE ( AssortmentItemAutoID ) 
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF )
			                    END
	                    END
                </sql>
                <sql conditional="">
                    IF NOT EXISTS( SELECT object_id FROM sys.indexes WHERE ( name = 'IX_EcomAssortmentItems_LanguageID_ProductID_ProductVariantID' ) )
	                    BEGIN
		                    IF EXISTS( SELECT 'Enterprise' AS EngineEdition WHERE SERVERPROPERTY('EngineEdition') = 3 )
			                    BEGIN
				                    CREATE NONCLUSTERED INDEX IX_EcomAssortmentItems_LanguageID_ProductID_ProductVariantID 
                                    ON EcomAssortmentItems ( AssortmentItemLanguageID ASC, AssortmentItemProductID ASC, AssortmentItemProductVariantID ASC )
                                    INCLUDE ( AssortmentItemAutoID ) 
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON )
			                    END
		                    ELSE
			                    BEGIN
				                    CREATE NONCLUSTERED INDEX IX_EcomAssortmentItems_LanguageID_ProductID_ProductVariantID 
                                    ON EcomAssortmentItems ( AssortmentItemLanguageID ASC, AssortmentItemProductID ASC, AssortmentItemProductVariantID ASC )
                                    INCLUDE ( AssortmentItemAutoID ) 
                                    WITH ( PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF )
			                    END
	                    END
                </sql>
            </EcomAssortmentItems>
            <EcomNumbers>
                <sql conditional="">
                    IF NOT EXISTS( SELECT NumberID FROM EcomNumbers WHERE ( NumberType = 'ASSORTMENT' ) )
	                    INSERT INTO EcomNumbers ( NumberID, NumberType, NumberDescription, NumberCounter, NumberPrefix, NumberPostFix, NumberAdd, NumberEditable )
	                    VALUES ( '49', 'ASSORTMENT', 'Assortments', 0, 'ASSORTMENT', '', 1, 0 )
                </sql>
            </EcomNumbers>
        </database>
    </package>

    <package version="343" releasedate="03-02-2014">
        <database file="Ecom.mdb">
            <EcomOrders>
                <sql conditional="">
                    IF NOT EXISTS(SELECT * FROM sys.columns WHERE ( name = 'OrderExternalPaymentFee' ) AND ( object_id = ( SELECT object_id FROM sys.tables WHERE ( name = 'EcomOrders' ) ) ) )
                    ALTER TABLE [EcomOrders] ADD OrderExternalPaymentFee FLOAT NULL
                </sql>
                <sql conditional="SELECT NOW()">
                    ALTER TABLE [EcomOrders] ADD OrderExternalPaymentFee FLOAT NULL
                </sql>
            </EcomOrders>
        </database>

        <file name="PaymentWindowPostTemplate.html" target="/Files/Templates/eCom7/CheckoutHandler/DIBS/Post" source="/Files/Templates/eCom7/CheckoutHandler/DIBS/Post" />
    </package>

    <package version="342" releasedate="31-01-2014">
        <file name="PublicList.html" target="/Files/Templates/eCom/CustomerCenter/ShowList" source="/Files/Templates/eCom/CustomerCenter/ShowList" />
        <database file="Dynamic.mdb">
            <Module>
                <sql conditional="SELECT COUNT(*) FROM [Module] WHERE [ModuleSystemName] = 'eCom_ShowList'">
                    INSERT INTO [Module]    (   [ModuleSystemName]  , [ModuleName]  , [ModuleAccess], [ModuleParagraph] , [ModuleIsBeta], [ModuleEcomNotInstalledAccess])
                    VALUES                  (   'eCom_ShowList'     , 'Show List'   , blnTrue       , blnTrue           , blnFalse      , 0                             )
                </sql>
            </Module>
        </database>
    </package>

    <package version="341" releasedate="29-01-2014">
        <database file="Ecom.mdb">
            <EcomOrderLineFields>
                <sql conditional="">
                    IF NOT EXISTS(SELECT * FROM sys.columns WHERE ( name = 'EcomOrderLineFieldsSorting' ) AND ( object_id = ( SELECT object_id FROM sys.tables WHERE ( name = 'EcomOrderLineFields' ) ) ) )
                    ALTER TABLE [EcomOrderLineFields] ADD [EcomOrderLineFieldsSorting] INT NULL
                </sql>
                <sql conditional="SELECT NOW()">
                    ALTER TABLE [EcomOrderLineFields] ADD [EcomOrderLineFieldsSorting] INT NULL
                </sql>
            </EcomOrderLineFields>
        </database>
    </package>

    <package version="340" releasedate="30-01-2014">
        <file name="MyListEmail.html" target="/Files/Templates/eCom/CustomerCenter" source="/Files/Templates/eCom/CustomerCenter" />
    </package>

    <package version="339" releasedate="27-01-2014">
        <file name="FavoritesList.html" target="/Files/Templates/eCom/CustomerCenter" source="/Files/Templates/eCom/CustomerCenter" />
    </package>
</updates>
