CREATE TABLE [dbo].[BoatQuoteEndorsementDetail] (
    [BoatQuoteEndorsementDetailId] INT            NOT NULL,
    [EndorsementId]                INT            NOT NULL,
    [QuoteNbr]                     VARCHAR (16)   NOT NULL,
    [EndorsementNbr]               CHAR (10)      NOT NULL,
    [ItemNbr]                      CHAR (3)       NULL,
    [ArticleNbr]                   CHAR (3)       NULL,
    [ItemCoverageLimitAmt]         DECIMAL (9)    NULL,
    [ItemCoveragePremiumGrossAmt]  DECIMAL (9, 2) NULL,
    [ShortDesc]                    VARCHAR (255)  NULL,
    [UpdatedTmstmp]                DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]                CHAR (8)       NOT NULL,
    [LastActionCd]                 CHAR (1)       NOT NULL,
    [SourceSystemCd]               CHAR (2)       NOT NULL,
    CONSTRAINT [PK_BoatQuoteEndorsementDetail] PRIMARY KEY CLUSTERED ([BoatQuoteEndorsementDetailId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_BoatQuoteEndorsementDetail_BoatQuoteEndorsement_01] FOREIGN KEY ([QuoteNbr], [EndorsementId]) REFERENCES [dbo].[BoatQuoteEndorsement] ([QuoteNbr], [EndorsementId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_BoatQuoteEndorsementDetail_01]
    ON [dbo].[BoatQuoteEndorsementDetail]([QuoteNbr] ASC)
    ON [POLICYCI];

