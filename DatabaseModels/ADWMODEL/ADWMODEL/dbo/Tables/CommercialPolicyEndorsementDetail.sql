CREATE TABLE [dbo].[CommercialPolicyEndorsementDetail] (
    [PolicyId]                      INT            NOT NULL,
    [EndorsementDetailId]           INT            NOT NULL,
    [EndorsementId]                 INT            NOT NULL,
    [LocationID]                    BIGINT         NULL,
    [PolicyAdditionalInsuredId]     BIGINT         NULL,
    [PolicyNbr]                     VARCHAR (16)   NOT NULL,
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
    CONSTRAINT [PK_CommercialPolicyEndorsementDetail] PRIMARY KEY CLUSTERED ([EndorsementDetailId] ASC, [PolicyId] ASC, [EndorsementId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialPolicyEndorsementDetail_CommercialPolicyEndorsement_01] FOREIGN KEY ([PolicyId], [EndorsementId]) REFERENCES [dbo].[CommercialPolicyEndorsement] ([PolicyId], [EndorsementId]),
    CONSTRAINT [FK_CommercialPolicyEndorsementDetail_Location_01] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[Location] ([LocationID]),
    CONSTRAINT [FK_CommercialPolicyEndorsementDetail_PolicyAdditionalInsured_01] FOREIGN KEY ([PolicyAdditionalInsuredId]) REFERENCES [dbo].[PolicyAdditionalInsured] ([PolicyAdditionalInsuredId])
) ON [POLICYCD] TEXTIMAGE_ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialPolicyEndorsementDetail_01]
    ON [dbo].[CommercialPolicyEndorsementDetail]([PolicyId] ASC)
    ON [POLICYCI];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialPolicyEndorsementDetail_02]
    ON [dbo].[CommercialPolicyEndorsementDetail]([PolicyId] ASC, [EndorsementId] ASC)
    ON [POLICYCI];

