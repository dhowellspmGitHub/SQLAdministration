CREATE TABLE [dbo].[MobileHomePolicyEndorsementDetail] (
    [EndorsementDetailId]         INT            NOT NULL,
    [AdditionalInterestId]        INT            NULL,
    [EndorsementId]               INT            NOT NULL,
    [PolicyId]                    INT            NOT NULL,
    [PolicyNbr]                   VARCHAR (16)   NOT NULL,
    [EndorsementNbr]              CHAR (10)      NOT NULL,
    [ItemNbr]                     CHAR (3)       NOT NULL,
    [ArticleNbr]                  CHAR (3)       NOT NULL,
    [ItemCoverageLimitAmt]        DECIMAL (9)    NULL,
    [ItemCoveragePremiumGrossAmt] DECIMAL (9, 2) NULL,
    [LastTransactionDt]           DATE           NULL,
    [ItemBasicDesc]               VARCHAR (250)  NULL,
    [ItemFreeFormDesc]            TEXT           NULL,
    [StructureDesc]               VARCHAR (255)  NULL,
    [ShortDesc]                   VARCHAR (255)  NULL,
    [AddressLine1Desc]            VARCHAR (100)  NULL,
    [AddressLine2Desc]            VARCHAR (100)  NULL,
    [AddressLine3Desc]            VARCHAR (100)  NULL,
    [CityNm]                      CHAR (30)      NULL,
    [StateOrProvinceCd]           CHAR (3)       NULL,
    [ZipCd]                       CHAR (9)       NULL,
    [CoverageOptionDesc]          VARCHAR (255)  NULL,
    [ManufacturingYearDt]         CHAR (4)       NULL,
    [MakeDesc]                    VARCHAR (100)  NULL,
    [ModelNm]                     VARCHAR (100)  NULL,
    [SerialNbr]                   CHAR (20)      NULL,
    [DaycareServiceDesc]          VARCHAR (255)  NULL,
    [BusinessLocationDesc]        VARCHAR (255)  NULL,
    [IncidentalOccupanceDesc]     VARCHAR (255)  NULL,
    [LocationNameDesc]            VARCHAR (255)  NULL,
    [Name]                        VARCHAR (255)  NULL,
    [RelationshipDesc]            VARCHAR (50)   NULL,
    [NumberFamiliesCnt]           INT            NULL,
    [BusinessPursuitDesc]         VARCHAR (255)  NULL,
    [FarmTypeDesc]                VARCHAR (100)  NULL,
    [PrimaryOccupationInd]        CHAR (1)       NULL,
    [AcresNbr]                    INT            NULL,
    [UpdatedTmstmp]               DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]               CHAR (8)       NOT NULL,
    [LastActionCd]                CHAR (1)       NOT NULL,
    [SourceSystemCd]              CHAR (2)       NOT NULL,
    CONSTRAINT [PK_MobileHomePolicyEndorsementDetail] PRIMARY KEY CLUSTERED ([EndorsementDetailId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_MobileHomePolicyEndorsementDetail_AdditionalInterest_01] FOREIGN KEY ([AdditionalInterestId]) REFERENCES [dbo].[AdditionalInterest] ([AdditionalInterestId]),
    CONSTRAINT [FK_MobileHomePolicyEndorsementDetail_MobileHomePolicyEndorsement_01] FOREIGN KEY ([PolicyId], [EndorsementId]) REFERENCES [dbo].[MobileHomePolicyEndorsement] ([PolicyId], [EndorsementId])
) ON [POLICYCD] TEXTIMAGE_ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_MobileHomePolicyEndorsementDetail_01]
    ON [dbo].[MobileHomePolicyEndorsementDetail]([PolicyId] ASC)
    ON [POLICYCI];

