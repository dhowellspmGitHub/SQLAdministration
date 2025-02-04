CREATE TABLE [dbo].[CommercialBuildingQuoteUnitEndorsement] (
    [QuoteNbr]                      VARCHAR (16)    NOT NULL,
    [UnitNbr]                       INT             NOT NULL,
    [EndorsementNbr]                CHAR (10)       NOT NULL,
    [EndorsementId]                 INT             NOT NULL,
    [CashUnitNbr]                   CHAR (3)        NULL,
    [EndorsementLimitCd]            CHAR (3)        NULL,
    [EndorsementLimitAmt]           DECIMAL (9)     NULL,
    [EndorsementPremiumAmt]         DECIMAL (9, 2)  NULL,
    [IncreasedConstructionLimitAmt] DECIMAL (9)     NULL,
    [DemolitionLimitAmt]            DECIMAL (9)     NULL,
    [IncreasedLimitAmt]             DECIMAL (9)     NULL,
    [DayCnt]                        INT             NULL,
    [PropertyDesc]                  VARCHAR (255)   NULL,
    [PaymentFromDt]                 DATE            NULL,
    [PaymentToDt]                   DATE            NULL,
    [DeductiblePct]                 DECIMAL (5, 2)  NULL,
    [CoverageOptionsDesc]           VARCHAR (255)   NULL,
    [DeductibleAmt]                 DECIMAL (18, 2) NULL,
    [EachTreeLimitAmt]              DECIMAL (9)     NULL,
    [EachShrubLimitAmt]             DECIMAL (9)     NULL,
    [EachPlantLimitAmt]             DECIMAL (9)     NULL,
    [ConstructionTypeDesc]          CHAR (50)       NULL,
    [EndorsementProratedPremiumAmt] DECIMAL (9, 2)  NOT NULL,
    [UndamagedLossCoverageInd]      CHAR (1)        NULL,
    [PowerSupplyDesc]               VARCHAR (255)   NULL,
    [FullTimeEmployeeCnt]           INT             NULL,
    [PartTimeEmployeeCnt]           INT             NULL,
    [CreatedTmstmp]                 DATETIME        NOT NULL,
    [UserCreatedId]                 CHAR (8)        NOT NULL,
    [UpdatedTmstmp]                 DATETIME2 (7)   NOT NULL,
    [UserUpdatedId]                 CHAR (8)        NOT NULL,
    [LastActionCd]                  CHAR (1)        NOT NULL,
    [SourceSystemCd]                CHAR (2)        NOT NULL,
    CONSTRAINT [PK_CommercialBuildingQuoteUnitEndorsement] PRIMARY KEY CLUSTERED ([EndorsementNbr] ASC, [UnitNbr] ASC, [QuoteNbr] ASC, [EndorsementId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialBuildingQuoteUnitEndorsement_CommercialBuildingQuoteUnit_01] FOREIGN KEY ([UnitNbr], [QuoteNbr]) REFERENCES [dbo].[CommercialBuildingQuoteUnit] ([UnitNbr], [QuoteNbr]),
    CONSTRAINT [FK_CommercialBuildingQuoteUnitEndorsement_Endorsements_01] FOREIGN KEY ([EndorsementId]) REFERENCES [dbo].[Endorsements] ([EndorsementId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialBuildingQuoteUnitEndorsement_01]
    ON [dbo].[CommercialBuildingQuoteUnitEndorsement]([QuoteNbr] ASC)
    ON [POLICYCI];

