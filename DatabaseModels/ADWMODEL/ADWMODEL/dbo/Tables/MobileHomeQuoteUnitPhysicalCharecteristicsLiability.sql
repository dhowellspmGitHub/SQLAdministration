CREATE TABLE [dbo].[MobileHomeQuoteUnitPhysicalCharecteristicsLiability] (
    [PhysicalCharLiabilityCd] CHAR (10)     NOT NULL,
    [UnitNbr]                 INT           NOT NULL,
    [QuoteNbr]                VARCHAR (16)  NOT NULL,
    [DebitCreditPointsNbr]    INT           NULL,
    [PhysicalCharCategoryCd]  CHAR (10)     NULL,
    [UpdatedTmstmp]           DATETIME2 (7) NOT NULL,
    [UserUpdatedId]           CHAR (8)      NOT NULL,
    [LastActionCd]            CHAR (1)      NOT NULL,
    [SourceSystemCd]          CHAR (2)      NOT NULL,
    CONSTRAINT [PK_MobileHomeQuoteUnitPhysicalCharecteristicsLiability] PRIMARY KEY CLUSTERED ([QuoteNbr] ASC, [UnitNbr] ASC, [PhysicalCharLiabilityCd] ASC) ON [POLICYCD],
    CONSTRAINT [FK_MobileHomeQuoteUnitPhysicalCharecteristicsLiability_MobileHomeQuoteUnit_01] FOREIGN KEY ([QuoteNbr], [UnitNbr]) REFERENCES [dbo].[MobileHomeQuoteUnit] ([QuoteNbr], [UnitNbr])
) ON [POLICYCD];

