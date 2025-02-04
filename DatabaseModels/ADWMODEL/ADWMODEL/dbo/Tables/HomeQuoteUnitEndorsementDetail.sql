CREATE TABLE [dbo].[HomeQuoteUnitEndorsementDetail] (
    [HomeQuoteEndorsementUnitDetailId] INT            NOT NULL,
    [EndorsementId]                    INT            NOT NULL,
    [QuoteNbr]                         VARCHAR (16)   NOT NULL,
    [UnitNbr]                          INT            NOT NULL,
    [ItemNbr]                          CHAR (3)       NOT NULL,
    [EndorsementNbr]                   CHAR (10)      NOT NULL,
    [AddressLine1Desc]                 VARCHAR (100)  NULL,
    [AddressLine2Desc]                 VARCHAR (100)  NULL,
    [AddressLine3Desc]                 VARCHAR (100)  NULL,
    [CityNm]                           CHAR (30)      NULL,
    [StateOrProvinceCd]                CHAR (3)       NULL,
    [ZipCd]                            CHAR (9)       NULL,
    [ArticleNbr]                       CHAR (3)       NULL,
    [ItemCoverageLimitAmt]             DECIMAL (9)    NULL,
    [ItemCoveragePremiumGrossAmt]      DECIMAL (9, 2) NULL,
    [StructureDesc]                    VARCHAR (255)  NULL,
    [LocationNameDesc]                 VARCHAR (255)  NULL,
    [ArticleDesc]                      VARCHAR (100)  NULL,
    [LongDesc]                         VARCHAR (750)  NULL,
    [ShortDesc]                        VARCHAR (255)  NULL,
    [UpdatedTmstmp]                    DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]                    CHAR (8)       NOT NULL,
    [LastActionCd]                     CHAR (1)       NOT NULL,
    [SourceSystemCd]                   CHAR (2)       NOT NULL,
    CONSTRAINT [PK_HomeQuoteUnitEndorsementDetail] PRIMARY KEY CLUSTERED ([HomeQuoteEndorsementUnitDetailId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_HomeQuoteUnitEndorsementDetail_HomeQuoteUnitEndorsement_01] FOREIGN KEY ([QuoteNbr], [UnitNbr], [EndorsementId]) REFERENCES [dbo].[HomeQuoteUnitEndorsement] ([QuoteNbr], [UnitNbr], [EndorsementId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_HomeQuoteUnitEndorsementDetail_01]
    ON [dbo].[HomeQuoteUnitEndorsementDetail]([QuoteNbr] ASC)
    ON [POLICYCI];

