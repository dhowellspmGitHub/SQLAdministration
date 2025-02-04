CREATE TABLE [dbo].[QuotePartyClaim] (
    [QuotePartyClaimsId]        INT           NOT NULL,
    [QuoteNbr]                  VARCHAR (16)  NOT NULL,
    [QuotePartyRelationId]      INT           NULL,
    [ClaimNbr]                  CHAR (10)     NOT NULL,
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
    [InsertedTmstmp]            DATETIME2 (7) NOT NULL,
    [UpdatedTmstmp]             DATETIME2 (7) NOT NULL,
    [UserUpdatedId]             CHAR (8)      NOT NULL,
    [LastActionCd]              CHAR (1)      NOT NULL,
    [SourceSystemCd]            CHAR (2)      NOT NULL,
    CONSTRAINT [PK_QuotePartyClaim] PRIMARY KEY CLUSTERED ([QuotePartyClaimsId] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_QuotePartyClaim_AutoQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[AutoQuote] ([QuoteNbr]),
    CONSTRAINT [FK_QuotePartyClaim_QuotePartyRelation_01] FOREIGN KEY ([QuotePartyRelationId]) REFERENCES [dbo].[QuotePartyRelation] ([QuotePartyRelationId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_QuotePartyClaim_01]
    ON [dbo].[QuotePartyClaim]([QuoteNbr] ASC)
    ON [POLICYCI];

