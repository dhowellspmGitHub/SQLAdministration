CREATE TABLE [dbo].[FireQuoteUnitEndorsement] (
    [QuoteNbr]                VARCHAR (16)   NOT NULL,
    [EndorsementId]           INT            NOT NULL,
    [UnitNbr]                 INT            NOT NULL,
    [EndorsementNbr]          CHAR (10)      NOT NULL,
    [EndorsementLimitAmt]     DECIMAL (9)    NULL,
    [EndorsementPremiumAmt]   DECIMAL (9, 2) NULL,
    [VaneerExclusionInd]      CHAR (1)       NULL,
    [EarthQuakeDeductiblePct] DECIMAL (9, 2) NULL,
    [LimitIncreaseInPct]      DECIMAL (9, 2) NULL,
    [OccupancyDesc]           VARCHAR (30)   NULL,
    [CoverageOptionsDesc]     VARCHAR (255)  NULL,
    [UpdatedTmstmp]           DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]           CHAR (8)       NOT NULL,
    [LastActionCd]            CHAR (1)       NOT NULL,
    [SourceSystemCd]          CHAR (2)       NOT NULL,
    CONSTRAINT [PK_FireQuoteUnitEndorsement] PRIMARY KEY CLUSTERED ([UnitNbr] ASC, [EndorsementId] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FireQuoteUnitEndorsement_Endorsements_01] FOREIGN KEY ([EndorsementId]) REFERENCES [dbo].[Endorsements] ([EndorsementId]),
    CONSTRAINT [FK_FireQuoteUnitEndorsement_FireQuoteUnit_01] FOREIGN KEY ([UnitNbr], [QuoteNbr]) REFERENCES [dbo].[FireQuoteUnit] ([UnitNbr], [QuoteNbr])
) ON [POLICYCD];

