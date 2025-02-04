CREATE TABLE [dbo].[UmbrellaQuoteEndorsement] (
    [QuoteNbr]              VARCHAR (16)   NOT NULL,
    [EndorsementId]         INT            NOT NULL,
    [EndorsementNbr]        CHAR (10)      NOT NULL,
    [EndorsementLimitCd]    CHAR (3)       NULL,
    [EndorsementLimitAmt]   DECIMAL (9)    NULL,
    [EndorsementPremiumAmt] DECIMAL (9, 2) NULL,
    [TrusteeNm]             VARCHAR (255)  NULL,
    [UpdatedTmstmp]         DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]         CHAR (8)       NOT NULL,
    [LastActionCd]          CHAR (1)       NOT NULL,
    [SourceSystemCd]        CHAR (2)       NOT NULL,
    CONSTRAINT [PK_UmbrellaQuoteEndorsement] PRIMARY KEY CLUSTERED ([QuoteNbr] ASC, [EndorsementId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_UmbrellaQuoteEndorsement_Endorsements_01] FOREIGN KEY ([EndorsementId]) REFERENCES [dbo].[Endorsements] ([EndorsementId]),
    CONSTRAINT [FK_UmbrellaQuoteEndorsement_UmbrellaQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[UmbrellaQuote] ([QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_UmbrellaQuoteEndorsement_01]
    ON [dbo].[UmbrellaQuoteEndorsement]([QuoteNbr] ASC)
    ON [POLICYCI];

