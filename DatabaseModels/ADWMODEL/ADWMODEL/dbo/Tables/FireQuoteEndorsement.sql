CREATE TABLE [dbo].[FireQuoteEndorsement] (
    [QuoteNbr]              VARCHAR (16)   NOT NULL,
    [EndorsementId]         INT            NOT NULL,
    [EndorsementNbr]        CHAR (10)      NOT NULL,
    [EndorsementLimitCd]    CHAR (3)       NULL,
    [EndorsementLimitAmt]   DECIMAL (9)    NULL,
    [EndorsementPremiumAmt] DECIMAL (9, 2) NULL,
    [UpdatedTmstmp]         DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]         CHAR (8)       NOT NULL,
    [LastActionCd]          CHAR (1)       NOT NULL,
    [SourceSystemCd]        CHAR (2)       NOT NULL,
    CONSTRAINT [PK_FireQuoteEndorsement] PRIMARY KEY NONCLUSTERED ([EndorsementId] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FireQuoteEndorsement_FireQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[FireQuote] ([QuoteNbr])
) ON [POLICYCD];

