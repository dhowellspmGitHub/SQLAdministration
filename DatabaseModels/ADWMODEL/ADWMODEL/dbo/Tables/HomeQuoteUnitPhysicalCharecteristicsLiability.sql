CREATE TABLE [dbo].[HomeQuoteUnitPhysicalCharecteristicsLiability] (
    [PhysicalCharLiabilityCd] CHAR (10)     NOT NULL,
    [UnitNbr]                 INT           NOT NULL,
    [QuoteNbr]                VARCHAR (16)  NOT NULL,
    [DebitCreditPointsNbr]    INT           NULL,
    [PhysicalCharCategoryCd]  CHAR (10)     NULL,
    [UpdatedTmstmp]           DATETIME2 (7) NOT NULL,
    [UserUpdatedId]           CHAR (8)      NOT NULL,
    [LastActionCd]            CHAR (1)      NOT NULL,
    [SourceSystemCd]          CHAR (2)      NOT NULL,
    CONSTRAINT [PK_HomeQuoteUnitPhysicalCharecteristicsLiability] PRIMARY KEY CLUSTERED ([PhysicalCharLiabilityCd] ASC, [UnitNbr] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_HomeQuoteUnitPhysicalCharecteristicsLiability_HomeQuoteUnit_01] FOREIGN KEY ([QuoteNbr], [UnitNbr]) REFERENCES [dbo].[HomeQuoteUnit] ([QuoteNbr], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_HomeQuoteUnitPhysicalCharecteristicsLiability_01]
    ON [dbo].[HomeQuoteUnitPhysicalCharecteristicsLiability]([QuoteNbr] ASC)
    ON [POLICYCI];

