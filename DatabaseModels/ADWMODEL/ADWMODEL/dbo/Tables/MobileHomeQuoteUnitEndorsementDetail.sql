CREATE TABLE [dbo].[MobileHomeQuoteUnitEndorsementDetail] (
    [MHQuoteEndorsementUnitDetailId] INT            NOT NULL,
    [EndorsementId]                  INT            NOT NULL,
    [QuoteNbr]                       VARCHAR (16)   NOT NULL,
    [UnitNbr]                        INT            NOT NULL,
    [ItemNbr]                        CHAR (3)       NOT NULL,
    [EndorsementNbr]                 CHAR (10)      NOT NULL,
    [ArticleNbr]                     CHAR (3)       NULL,
    [ItemCoverageLimitAmt]           DECIMAL (9)    NULL,
    [ItemCoveragePremiumGrossAmt]    DECIMAL (9, 2) NULL,
    [CoverageOptionDesc]             VARCHAR (255)  NULL,
    [EarthquakeInd]                  BIT            NULL,
    [ArticleDesc]                    VARCHAR (100)  NULL,
    [LongDesc]                       VARCHAR (750)  NULL,
    [ShortDesc]                      VARCHAR (255)  NULL,
    [StructureDesc]                  VARCHAR (255)  NULL,
    [UpdatedTmstmp]                  DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]                  CHAR (8)       NOT NULL,
    [LastActionCd]                   CHAR (1)       NOT NULL,
    [SourceSystemCd]                 CHAR (2)       NOT NULL,
    CONSTRAINT [PK_MobileHomeQuoteUnitEndorsementDetail] PRIMARY KEY CLUSTERED ([MHQuoteEndorsementUnitDetailId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_MobileHomeQuoteUnitEndorsementDetail_MobileHomeQuoteUnitEndorsement_01] FOREIGN KEY ([QuoteNbr], [UnitNbr], [EndorsementId]) REFERENCES [dbo].[MobileHomeQuoteUnitEndorsement] ([QuoteNbr], [UnitNbr], [EndorsementId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_MobileHomeQuoteUnitEndorsementDetail_01]
    ON [dbo].[MobileHomeQuoteUnitEndorsementDetail]([QuoteNbr] ASC)
    ON [POLICYCI];

