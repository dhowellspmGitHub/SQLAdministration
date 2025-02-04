CREATE TABLE [dbo].[FarmPolicyEndorsementDetail] (
    [PolicyId]                     INT            NOT NULL,
    [EndorsementDetailId]          INT            NOT NULL,
    [EndorsementId]                INT            NOT NULL,
    [LocationID]                   BIGINT         NULL,
    [PolicyNbr]                    VARCHAR (16)   NOT NULL,
    [EndorsementNbr]               CHAR (10)      NOT NULL,
    [ItemNbr]                      CHAR (3)       NOT NULL,
    [ArticleNbr]                   CHAR (3)       NOT NULL,
    [ItemCoverageLimitAmt]         DECIMAL (9)    NULL,
    [ItemCoveragePremiumGrossAmt]  DECIMAL (9, 2) NULL,
    [LastTransactionDt]            DATE           NULL,
    [ItemBasicDesc]                VARCHAR (250)  NULL,
    [ItemFreeFormDesc]             TEXT           NULL,
    [CompanyOrClientNm]            VARCHAR (255)  NULL,
    [RelationshipDesc]             VARCHAR (50)   NULL,
    [AnimalBreedDesc]              VARCHAR (50)   NULL,
    [AnimalNm]                     VARCHAR (50)   NULL,
    [RegistrationNbr]              CHAR (20)      NULL,
    [IncreaseContentsCoverageInd]  CHAR (1)       NULL,
    [BusinessPursuitExceptionDesc] VARCHAR (255)  NULL,
    [OwnPct]                       DECIMAL (5, 2) NULL,
    [AnimalUseDesc]                VARCHAR (255)  NULL,
    [TrustMemberNm]                VARCHAR (50)   NULL,
    [TrustAddressDesc]             VARCHAR (100)  NULL,
    [LocationDesc]                 VARCHAR (255)  NULL,
    [CoverageDesc]                 VARCHAR (250)  NULL,
    [ManufacturerNm]               VARCHAR (50)   NULL,
    [ManufacturingYearDt]          CHAR (4)       NULL,
    [ModelNm]                      VARCHAR (100)  NULL,
    [SerialNbr]                    CHAR (20)      NULL,
    [UpdatedTmstmp]                DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]                CHAR (8)       NOT NULL,
    [LastActionCd]                 CHAR (1)       NOT NULL,
    [SourceSystemCd]               CHAR (2)       NOT NULL,
    CONSTRAINT [PK_FarmPolicyEndorsementDetail] PRIMARY KEY CLUSTERED ([EndorsementDetailId] ASC, [EndorsementId] ASC, [PolicyId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmPolicyEndorsementDetail_FarmPolicyEndorsement_01] FOREIGN KEY ([PolicyId], [EndorsementId]) REFERENCES [dbo].[FarmPolicyEndorsement] ([PolicyId], [EndorsementId]),
    CONSTRAINT [FK_FarmPolicyEndorsementDetail_Location_01] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[Location] ([LocationID])
) ON [POLICYCD] TEXTIMAGE_ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FarmPolicyEndorsementDetail_01]
    ON [dbo].[FarmPolicyEndorsementDetail]([PolicyId] ASC)
    ON [POLICYCI];


GO
CREATE NONCLUSTERED INDEX [IX_FarmPolicyEndorsementDetail_02]
    ON [dbo].[FarmPolicyEndorsementDetail]([PolicyId] ASC, [EndorsementId] ASC)
    ON [POLICYCI];

