CREATE TABLE [dbo].[CommercialQuoteEndorsementDetail] (
    [QuoteNbr]                      VARCHAR (16)   NOT NULL,
    [EndorsementDetailId]           INT            NOT NULL,
    [EndorsementId]                 INT            NOT NULL,
    [LocationID]                    BIGINT         NULL,
    [EndorsementNbr]                CHAR (10)      NOT NULL,
    [ItemNbr]                       CHAR (3)       NOT NULL,
    [ArticleNbr]                    CHAR (3)       NOT NULL,
    [ItemCoverageLimitAmt]          DECIMAL (9)    NULL,
    [ItemCoveragePremiumGrossAmt]   DECIMAL (9, 2) NULL,
    [LastTransactionDt]             DATE           NULL,
    [ItemBasicDesc]                 VARCHAR (250)  NULL,
    [ItemFreeFormDesc]              TEXT           NULL,
    [HazzardCd]                     CHAR (22)      NULL,
    [IncludedExcludedCountryNm]     VARCHAR (255)  NULL,
    [BasicPremiumAmt]               DECIMAL (9, 2) NULL,
    [EndorsementLimitAmt]           DECIMAL (9)    NULL,
    [LocationDesc]                  VARCHAR (255)  NULL,
    [EndorsementProratedPremiumAmt] DECIMAL (9, 2) NULL,
    [UpdatedTmstmp]                 DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]                 CHAR (8)       NOT NULL,
    [LastActionCd]                  CHAR (1)       NOT NULL,
    [SourceSystemCd]                CHAR (2)       NOT NULL,
    CONSTRAINT [PK_CommercialQuoteEndorsementDetail] PRIMARY KEY CLUSTERED ([EndorsementDetailId] ASC, [EndorsementId] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialQuoteEndorsementDetail_CommercialQuoteEndorsement_01] FOREIGN KEY ([QuoteNbr], [EndorsementId]) REFERENCES [dbo].[CommercialQuoteEndorsement] ([QuoteNbr], [EndorsementId]),
    CONSTRAINT [FK_CommercialQuoteEndorsementDetail_Location_01] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[Location] ([LocationID])
) ON [POLICYCD] TEXTIMAGE_ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialQuoteEndorsementDetail_01]
    ON [dbo].[CommercialQuoteEndorsementDetail]([QuoteNbr] ASC)
    ON [POLICYCI];

