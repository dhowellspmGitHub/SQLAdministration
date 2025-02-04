CREATE TABLE [dbo].[AutoQuotePhysicalCharacteristicsLiability] (
    [QuoteNbr]                VARCHAR (16)  NOT NULL,
    [PhysicalCharLiabilityCd] CHAR (10)     NOT NULL,
    [DebitCreditPointsNbr]    INT           NULL,
    [LastActionCd]            CHAR (1)      NOT NULL,
    [SourceSystemPatternCd]   VARCHAR (50)  NULL,
    [SourceSystemCd]          CHAR (2)      NOT NULL,
    [UpdatedTmstmp]           DATETIME2 (7) NOT NULL,
    [UserUpdatedId]           CHAR (8)      NOT NULL,
    CONSTRAINT [PK_AutoQuotePhysicalCharacteristicsLiability] PRIMARY KEY CLUSTERED ([QuoteNbr] ASC, [PhysicalCharLiabilityCd] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AutoQuotePhysicalCharacteristicsLiability_Quote] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[Quote] ([QuoteNbr])
) ON [POLICYCD];

