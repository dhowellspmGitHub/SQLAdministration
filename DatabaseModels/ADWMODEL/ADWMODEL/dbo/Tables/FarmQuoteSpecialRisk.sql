CREATE TABLE [dbo].[FarmQuoteSpecialRisk] (
    [QuoteNbr]               VARCHAR (16)   NOT NULL,
    [FarmQuoteSpecialRiskId] INT            NOT NULL,
    [SpecialRiskDaysNbr]     INT            NULL,
    [SpecialRiskPremiumAmt]  DECIMAL (9, 2) NULL,
    [PatternCd]              VARCHAR (64)   NULL,
    [UpdatedTmstmp]          DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]          CHAR (8)       NOT NULL,
    [LastActionCd]           CHAR (1)       NOT NULL,
    [SourceSystemCd]         CHAR (2)       NOT NULL,
    CONSTRAINT [PK_FarmQuoteSpecialRisk] PRIMARY KEY CLUSTERED ([FarmQuoteSpecialRiskId] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmQuoteSpecialRisk_FarmQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[FarmQuote] ([QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FarmQuoteSpecialRisk_01]
    ON [dbo].[FarmQuoteSpecialRisk]([QuoteNbr] ASC)
    ON [POLICYCI];

