CREATE TABLE [dbo].[Policy] (
    [PolicyId]                     INT            NOT NULL,
    [QuoteNbr]                     VARCHAR (16)   NULL,
    [AccountBillNbr]               CHAR (10)      NULL,
    [NewBusinessAgentNbr]          CHAR (4)       NULL,
    [RenewalAgentNbr]              CHAR (4)       NULL,
    [PolicyNbr]                    VARCHAR (16)   NOT NULL,
    [LineofBusinessCd]             CHAR (2)       NOT NULL,
    [SublineBusinessTypeCd]        CHAR (1)       NOT NULL,
    [CountyNbr]                    CHAR (3)       NOT NULL,
    [PolicyMembershipNbr]          CHAR (10)      NOT NULL,
    [AgencyNbr]                    CHAR (3)       NOT NULL,
    [CurrentRecordInd]             BIT            NOT NULL,
    [CompanyNbr]                   CHAR (3)       NULL,
    [VersionReasonCd]              VARCHAR (2)    NULL,
    [VersionReasonDesc]            VARCHAR (100)  NULL,
    [ActivePropertyCd]             VARCHAR (22)   NULL,
    [ActivePropertyDesc]           VARCHAR (200)  NULL,
    [BookletEditionDt]             DECIMAL (5)    NULL,
    [BookletNbr]                   VARCHAR (10)   NULL,
    [PolicyIssueDt]                DATE           NULL,
    [PolicyEffectiveDt]            DATE           NULL,
    [PolicyExpirationDt]           DATE           NULL,
    [OriginalInceptionDt]          DATE           NULL,
    [NewBusinessProcessDt]         DATE           NULL,
    [TransactionDt]                DATE           NULL,
    [PolicyChangeEffectiveDt]      DATE           NULL,
    [CancelProcessingDt]           DATE           NULL,
    [PolicyStatusCd]               VARCHAR (22)   NULL,
    [PolicyStatusDesc]             VARCHAR (200)  NULL,
    [PolicyStatusChangeDt]         DATE           NULL,
    [ReinstatementTypeCd]          VARCHAR (22)   NULL,
    [ReinstatementTypeDesc]        VARCHAR (200)  NULL,
    [ReinstatementDt]              DATE           NULL,
    [ReinstatementTimesCnt]        INT            NULL,
    [ReinstatementWithLapseInd]    CHAR (1)       NULL,
    [PolicyMigrationTierInd]       CHAR (1)       NULL,
    [ReviewReason1Cd]              CHAR (2)       NULL,
    [ReviewReason2Cd]              CHAR (2)       NULL,
    [ReviewCompletionDt]           DATE           NULL,
    [ReviewDueDt]                  DATE           NULL,
    [TerminationDt]                DATE           NULL,
    [TerminationEffectiveTm]       TIME (7)       NULL,
    [TerminationAMPMInd]           CHAR (1)       NULL,
    [TerminationReasonCd]          CHAR (2)       NULL,
    [TerminationReason2Cd]         CHAR (2)       NULL,
    [TerminationReasonDesc]        VARCHAR (200)  NULL,
    [TermCd]                       CHAR (2)       NULL,
    [ExposureMonthsNbr]            INT            NULL,
    [SuppressCommissionInd]        CHAR (1)       NULL,
    [UnderwriterNbr]               CHAR (4)       NULL,
    [DiscountMembershipNbr]        CHAR (10)      NULL,
    [ConversionInd]                CHAR (1)       NULL,
    [NonPayCancellationCnt]        DECIMAL (3)    NULL,
    [PolicyFormCd]                 VARCHAR (10)   NULL,
    [ReinsuranceCategoryCd]        CHAR (2)       NULL,
    [PendingReasonCd]              CHAR (3)       NULL,
    [PendingActivityDt]            DATE           NULL,
    [PendingActivityCd]            CHAR (3)       NULL,
    [PolicyUserUpdatedId]          CHAR (10)      NULL,
    [TownTaxCd]                    CHAR (3)       NULL,
    [TaxRatePct]                   DECIMAL (5)    NULL,
    [AutoInsuranceScoreNbr]        DECIMAL (5)    NULL,
    [PropertyInsuranceScoreNbr]    DECIMAL (5)    NULL,
    [PolicyLegacyDiscountPct]      DECIMAL (3, 2) NULL,
    [SourceSystemBasedOnId]        INT            NULL,
    [SourceSystemTransactionId]    BIGINT         NULL,
    [ChildTableUpdatedTmstmp]      DATETIME2 (7)  NOT NULL,
    [LegacyRelationshipDesc]       VARCHAR (50)   NULL,
    [LegacyDiscountMembershipNbr]  CHAR (10)      NULL,
    [ProductCd]                    VARCHAR (64)   NULL,
    [CatEventCd]                   VARCHAR (50)   NULL,
    [PolicyDeclaration1Nm]         VARCHAR (100)  NULL,
    [PolicyDeclaration2Nm]         VARCHAR (100)  NULL,
    [DoingBusinessAsNm]            VARCHAR (70)   NULL,
    [PolicyDeclarationAddress1Txt] VARCHAR (70)   NULL,
    [PolicyDeclarationAddress2Txt] VARCHAR (70)   NULL,
    [PolicyDeclarationAddress3Txt] VARCHAR (70)   NULL,
    [ExemptEmployeeInd]            CHAR (1)       NULL,
    [CoverageCompetitorNm]         VARCHAR (256)  NULL,
    [CreatedTmstmp]                DATETIME       NOT NULL,
    [UserCreatedId]                CHAR (8)       NOT NULL,
    [SourceSystemId]               INT            NOT NULL,
    [UpdatedTmstmp]                DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]                CHAR (8)       NOT NULL,
    [LastActionCd]                 CHAR (1)       NOT NULL,
    [SourceSystemCd]               CHAR (2)       NOT NULL,
    CONSTRAINT [PK_Policy] PRIMARY KEY CLUSTERED ([PolicyId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_Policy_Account_01] FOREIGN KEY ([AccountBillNbr]) REFERENCES [dbo].[Account] ([AccountBillNbr]),
    CONSTRAINT [FK_Policy_Quote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[Quote] ([QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_Policy_03]
    ON [dbo].[Policy]([SourceSystemId] ASC)
    ON [POLICYCI];


GO
CREATE NONCLUSTERED INDEX [IX_Policy_02]
    ON [dbo].[Policy]([CurrentRecordInd] ASC, [SourceSystemCd] ASC)
    ON [POLICYCI];


GO
CREATE NONCLUSTERED INDEX [IX_Policy_01]
    ON [dbo].[Policy]([PolicyNbr] ASC)
    ON [POLICYCI];

