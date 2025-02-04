CREATE TABLE [dbo].[MobileHomeUnitEndorsementDetail] (
    [EndorsementUnitDetailId]     INT            NOT NULL,
    [PolicyId]                    INT            NOT NULL,
    [EndorsementId]               INT            NOT NULL,
    [UnitNbr]                     INT            NOT NULL,
    [ItemNbr]                     CHAR (3)       NOT NULL,
    [PolicyNbr]                   VARCHAR (16)   NOT NULL,
    [EndorsementNbr]              CHAR (10)      NOT NULL,
    [ArticleNbr]                  CHAR (3)       NULL,
    [ItemCoverageLimitAmt]        DECIMAL (9)    NULL,
    [ItemCoveragePremiumGrossAmt] DECIMAL (9, 2) NULL,
    [CoverageOptionDesc]          VARCHAR (255)  NULL,
    [EarthquakeInd]               BIT            NULL,
    [ArticleDesc]                 VARCHAR (100)  NULL,
    [LongDesc]                    VARCHAR (750)  NULL,
    [ShortDesc]                   VARCHAR (255)  NULL,
    [StructureDesc]               VARCHAR (255)  NULL,
    [UpdatedTmstmp]               DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]               CHAR (8)       NOT NULL,
    [LastActionCd]                CHAR (1)       NOT NULL,
    [SourceSystemCd]              CHAR (2)       NOT NULL,
    CONSTRAINT [PK_MobileHomeUnitEndorsementDetail] PRIMARY KEY CLUSTERED ([EndorsementUnitDetailId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_MobileHomePolicyEndorsementDetail_MobileHomePolicyEndorsement_01_1] FOREIGN KEY ([EndorsementId], [PolicyId], [UnitNbr]) REFERENCES [dbo].[MobileHomeUnitEndorsement] ([EndorsementId], [PolicyId], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_MobileHomeUnitEndorsementDetail_01]
    ON [dbo].[MobileHomeUnitEndorsementDetail]([PolicyId] ASC)
    ON [POLICYCI];

