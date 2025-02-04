CREATE TABLE [dbo].[PolicyPartyClaim] (
    [PolicyPartyClaimsId]       INT           NOT NULL,
    [PolicyPartyRelationId]     INT           NULL,
    [PolicyId]                  INT           NULL,
    [ClaimNbr]                  CHAR (10)     NOT NULL,
    [PolicyNbr]                 VARCHAR (16)  NULL,
    [SublineBusinessTypeCd]     CHAR (1)      NOT NULL,
    [ClaimSequenceNbr]          INT           NULL,
    [ClaimLossDt]               DATE          NULL,
    [LossOriginPointCnt]        CHAR (2)      NULL,
    [ClaimPointCnt]             INT           NULL,
    [LossAgedPointCnt]          CHAR (2)      NULL,
    [LossReasonCd]              CHAR (2)      NULL,
    [AccidentChargedOnPolicyCd] CHAR (1)      NULL,
    [AccidentChargedOnPolicyDt] CHAR (10)     NULL,
    [ClaimReceivedDt]           DATE          NULL,
    [DataSourceCd]              CHAR (2)      NULL,
    [ClaimForgivenInd]          CHAR (1)      NULL,
    [ClaimForgivenDt]           DATE          NULL,
    [CLUEVehicleOperatorNm]     CHAR (30)     NULL,
    [SurchargeExemptInd]        CHAR (1)      NULL,
    [UseInPlacementInd]         CHAR (1)      NULL,
    [AppliedPolicyNbr]          VARCHAR (16)  NULL,
    [UpdatedTmstmp]             DATETIME2 (7) NOT NULL,
    [UserUpdatedId]             CHAR (8)      NOT NULL,
    [LastActionCd]              CHAR (1)      NOT NULL,
    [SourceSystemCd]            CHAR (2)      NOT NULL,
    CONSTRAINT [PK_PolicyPartyClaim] PRIMARY KEY CLUSTERED ([PolicyPartyClaimsId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AutoPolicy_PolicyPartyClaim_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[AutoPolicy] ([PolicyId]),
    CONSTRAINT [FK_PolicyPartyRelation_PolicyPartyClaim_01] FOREIGN KEY ([PolicyPartyRelationId]) REFERENCES [dbo].[PolicyPartyRelation] ([PolicyPartyRelationId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_PolicyPartyClaim_01]
    ON [dbo].[PolicyPartyClaim]([PolicyId] ASC)
    ON [POLICYCI];

