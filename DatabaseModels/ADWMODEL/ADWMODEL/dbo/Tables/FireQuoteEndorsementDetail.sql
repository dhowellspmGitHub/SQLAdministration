CREATE TABLE [dbo].[FireQuoteEndorsementDetail] (
    [EndorsementDetailId]         INT            NOT NULL,
    [QuoteNbr]                    VARCHAR (16)   NOT NULL,
    [EndorsementId]               INT            NOT NULL,
    [EndorsementNbr]              CHAR (10)      NOT NULL,
    [ItemNbr]                     CHAR (3)       NOT NULL,
    [ArticleNbr]                  CHAR (3)       NOT NULL,
    [ItemCoverageLimitAmt]        DECIMAL (9)    NULL,
    [ItemCoveragePremiumGrossAmt] DECIMAL (9, 2) NULL,
    [UpdatedTmstmp]               DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]               CHAR (8)       NOT NULL,
    [LastActionCd]                CHAR (1)       NOT NULL,
    [SourceSystemCd]              CHAR (2)       NOT NULL,
    CONSTRAINT [PK_FireQuoteEndorsementDetail] PRIMARY KEY NONCLUSTERED ([EndorsementDetailId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FireQuoteEndorsementDetail_FireQuoteEndorsement_01] FOREIGN KEY ([EndorsementId], [QuoteNbr]) REFERENCES [dbo].[FireQuoteEndorsement] ([EndorsementId], [QuoteNbr])
) ON [POLICYCD];

