CREATE TABLE [dbo].[FirePolicyEndorsementDetail] (
    [EndorsementDetailId]         INT            NOT NULL,
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
    [UpdatedTmstmp]               DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]               CHAR (8)       NOT NULL,
    [LastActionCd]                CHAR (1)       NOT NULL,
    [SourceSystemCd]              CHAR (2)       NOT NULL,
    CONSTRAINT [PK_FirePolicyEndorsementDetail] PRIMARY KEY CLUSTERED ([EndorsementDetailId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FirePolicyEndorsementDetail_FirePolicyEndorsement_01] FOREIGN KEY ([PolicyId], [EndorsementId]) REFERENCES [dbo].[FirePolicyEndorsement] ([PolicyId], [EndorsementId])
) ON [POLICYCD] TEXTIMAGE_ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FirePolicyEndorsementDetail_01]
    ON [dbo].[FirePolicyEndorsementDetail]([PolicyId] ASC)
    ON [POLICYCI];

