CREATE TABLE [dbo].[FarmQuotePhysicalCharacteristicsLiability] (
    [QuoteNbr]                VARCHAR (16)  NOT NULL,
    [PhysicalCharLiabilityCd] CHAR (10)     NOT NULL,
    [DebitCreditPointsNbr]    INT           NULL,
    [PhysicalCharCategoryCd]  CHAR (10)     NULL,
    [CreatedTmstmp]           DATETIME      NOT NULL,
    [UserCreatedId]           CHAR (8)      NOT NULL,
    [UpdatedTmstmp]           DATETIME2 (7) NOT NULL,
    [UserUpdatedId]           CHAR (8)      NOT NULL,
    [LastActionCd]            CHAR (1)      NOT NULL,
    [SourceSystemCd]          CHAR (2)      NOT NULL,
    CONSTRAINT [PK_FarmQuotePhysicalCharacteristicsLiability] PRIMARY KEY CLUSTERED ([QuoteNbr] ASC, [PhysicalCharLiabilityCd] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmQuotePhysicalCharacteristicsLiability_FarmQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[FarmQuote] ([QuoteNbr])
) ON [POLICYCD];

