CREATE TABLE [dbo].[ACVEstimator] (
    [ACVEStimatorId]            INT           NOT NULL,
    [EstimatorStateId]          INT           NULL,
    [EstimateTmstmp]            DATETIME2 (7) NULL,
    [EstimatorNm]               VARCHAR (100) NULL,
    [EstimatorStreetAddress]    VARCHAR (100) NULL,
    [EstimatorCity]             VARCHAR (60)  NULL,
    [EstimatorZip]              CHAR (10)     NULL,
    [EstimatorEmail]            VARCHAR (100) NULL,
    [CurrentRecordInd]          BIT           NOT NULL,
    [RetiredInd]                CHAR (1)      NOT NULL,
    [SourceSystemId]            INT           NOT NULL,
    [SourceSystemCreatedTmstmp] DATETIME2 (7) NOT NULL,
    [SourceSystemUserCreatedId] CHAR (10)     NOT NULL,
    [SourceSystemUpdatedTmstmp] DATETIME2 (7) NOT NULL,
    [SourceSystemUserUpdatedId] CHAR (10)     NOT NULL,
    [UpdatedTmstmp]             DATETIME2 (7) NOT NULL,
    [UserUpdatedId]             CHAR (8)      NOT NULL,
    [LastActionCd]              CHAR (1)      NOT NULL,
    [SourceSystemCd]            CHAR (2)      NOT NULL,
    CONSTRAINT [PK_ACVEstimator] PRIMARY KEY CLUSTERED ([ACVEStimatorId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ACVEstimator_ClaimCodeLookup_01] FOREIGN KEY ([EstimatorStateId]) REFERENCES [dbo].[ClaimCodeLookup] ([ClaimCodeLookupId])
) ON [CLAIMSCD];

