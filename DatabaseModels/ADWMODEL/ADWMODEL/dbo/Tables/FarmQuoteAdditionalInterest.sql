CREATE TABLE [dbo].[FarmQuoteAdditionalInterest] (
    [QuoteNbr]                VARCHAR (16)  NOT NULL,
    [FarmQuoteAdditionalId]   INT           NOT NULL,
    [MortgageeSequenceNbr]    CHAR (3)      NULL,
    [MortgageeLoanNbr]        CHAR (35)     NULL,
    [PCAdditionalInterestNbr] CHAR (10)     NULL,
    [InterestDesc]            VARCHAR (255) NULL,
    [ToTheAttentionOfNm]      VARCHAR (50)  NULL,
    [EscrowInd]               CHAR (1)      NULL,
    [CreatedTmstmp]           DATETIME      NOT NULL,
    [UserCreatedId]           CHAR (8)      NOT NULL,
    [UpdatedTmstmp]           DATETIME2 (7) NOT NULL,
    [UserUpdatedId]           CHAR (8)      NOT NULL,
    [LastActionCd]            CHAR (1)      NOT NULL,
    [SourceSystemCd]          CHAR (2)      NOT NULL,
    CONSTRAINT [PK_FarmQuoteAdditionalInterest] PRIMARY KEY CLUSTERED ([FarmQuoteAdditionalId] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmQuoteAdditionalInterest_FarmQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[FarmQuote] ([QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FarmQuoteAdditionalInterest_01]
    ON [dbo].[FarmQuoteAdditionalInterest]([QuoteNbr] ASC)
    ON [POLICYCI];

