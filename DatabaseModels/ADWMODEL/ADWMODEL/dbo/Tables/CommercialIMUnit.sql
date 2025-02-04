CREATE TABLE [dbo].[CommercialIMUnit] (
    [PolicyId]             INT            NOT NULL,
    [IMPartCoverageTypeCd] VARCHAR (50)   NOT NULL,
    [UnitNbr]              INT            NOT NULL,
    [LocationID]           BIGINT         NULL,
    [PolicyNbr]            VARCHAR (16)   NOT NULL,
    [ProgramCd]            CHAR (1)       NULL,
    [CashUnitNbr]          CHAR (3)       NULL,
    [PartDesc]             VARCHAR (50)   NULL,
    [ItemBasicDesc]        VARCHAR (250)  NULL,
    [InlandMarineClassCd]  CHAR (7)       NOT NULL,
    [ConstructionTypeDesc] CHAR (50)      NOT NULL,
    [LimitAmt]             DECIMAL (9)    NULL,
    [EquipmentIDNbr]       CHAR (20)      NOT NULL,
    [ManufacturerNm]       VARCHAR (50)   NULL,
    [ModelNm]              VARCHAR (100)  NULL,
    [ManufacturingYearDt]  CHAR (4)       NOT NULL,
    [RiskTypeCd]           CHAR (10)      NULL,
    [MilesDrivenNbr]       DECIMAL (5)    NULL,
    [LocationTypeCd]       VARCHAR (50)   NULL,
    [PurchaseYearDt]       CHAR (4)       NULL,
    [PremiumAmt]           DECIMAL (9, 2) NOT NULL,
    [TaxAmt]               DECIMAL (9, 2) NULL,
    [SurchargeTaxAmt]      DECIMAL (9, 2) NULL,
    [ValuationTypeDesc]    VARCHAR (200)  NULL,
    [LocationDesc]         VARCHAR (255)  NULL,
    [CreatedTmstmp]        DATETIME       NOT NULL,
    [UserCreatedId]        CHAR (8)       NOT NULL,
    [UpdatedTmstmp]        DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]        CHAR (8)       NOT NULL,
    [LastActionCd]         CHAR (1)       NOT NULL,
    [SourceSystemCd]       CHAR (2)       NOT NULL,
    CONSTRAINT [PK_CommercialIMUnit] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [IMPartCoverageTypeCd] ASC, [UnitNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialIMCoverageUnit_CommercialIM_01] FOREIGN KEY ([PolicyId], [IMPartCoverageTypeCd]) REFERENCES [dbo].[CommercialIM] ([PolicyId], [IMPartCoverageTypeCd]),
    CONSTRAINT [FK_CommercialIMUnit_Location_01] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[Location] ([LocationID])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialIMUnit_01]
    ON [dbo].[CommercialIMUnit]([PolicyId] ASC)
    ON [POLICYCI];

