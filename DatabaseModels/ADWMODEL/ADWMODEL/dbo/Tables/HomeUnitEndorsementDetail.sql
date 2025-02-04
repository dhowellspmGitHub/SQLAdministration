CREATE TABLE [dbo].[HomeUnitEndorsementDetail] (
    [EndorsementUnitDetailId]     INT            NOT NULL,
    [EndorsementId]               INT            NOT NULL,
    [PolicyId]                    INT            NOT NULL,
    [UnitNbr]                     INT            NOT NULL,
    [ItemNbr]                     CHAR (3)       NOT NULL,
    [PolicyNbr]                   VARCHAR (16)   NOT NULL,
    [EndorsementNbr]              CHAR (10)      NOT NULL,
    [AddressLine1Desc]            VARCHAR (100)  NULL,
    [AddressLine2Desc]            VARCHAR (100)  NULL,
    [AddressLine3Desc]            VARCHAR (100)  NULL,
    [CityNm]                      CHAR (30)      NULL,
    [StateOrProvinceCd]           CHAR (3)       NULL,
    [ZipCd]                       CHAR (9)       NULL,
    [ArticleNbr]                  CHAR (3)       NULL,
    [ItemCoverageLimitAmt]        DECIMAL (9)    NULL,
    [ItemCoveragePremiumGrossAmt] DECIMAL (9, 2) NULL,
    [StructureDesc]               VARCHAR (255)  NULL,
    [LocationNameDesc]            VARCHAR (255)  NULL,
    [ShortDesc]                   VARCHAR (255)  NULL,
    [ArticleDesc]                 VARCHAR (100)  NULL,
    [LongDesc]                    VARCHAR (750)  NULL,
    [UpdatedTmstmp]               DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]               CHAR (8)       NOT NULL,
    [LastActionCd]                CHAR (1)       NOT NULL,
    [SourceSystemCd]              CHAR (2)       NOT NULL,
    CONSTRAINT [PK_HomeUnitEndorsementDetail] PRIMARY KEY CLUSTERED ([EndorsementUnitDetailId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_HomeUnitEndorsementDetail_HomeUnitEndorsement_01] FOREIGN KEY ([EndorsementId], [PolicyId], [UnitNbr]) REFERENCES [dbo].[HomeUnitEndorsement] ([EndorsementId], [PolicyId], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_HomeUnitEndorsementDetail_01]
    ON [dbo].[HomeUnitEndorsementDetail]([PolicyId] ASC)
    ON [POLICYCD];

