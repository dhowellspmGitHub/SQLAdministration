CREATE TABLE [dbo].[ACVCoverageGroup] (
    [ACVCoverageGroupId]        INT           NOT NULL,
    [ACVEStimatorId]            INT           NOT NULL,
    [ACVGenericValuationId]     INT           NOT NULL,
    [GroupDesc]                 VARCHAR (100) NULL,
    [ACVCoverageGroupNm]        VARCHAR (100) NULL,
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
    CONSTRAINT [PK_ACVCoverageGroup] PRIMARY KEY CLUSTERED ([ACVCoverageGroupId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ACVCoverageGroup_ACVEstimator_01] FOREIGN KEY ([ACVEStimatorId]) REFERENCES [dbo].[ACVEstimator] ([ACVEStimatorId]),
    CONSTRAINT [FK_ACVCoverageGroup_ACVGenericValuation_01] FOREIGN KEY ([ACVGenericValuationId]) REFERENCES [dbo].[ACVGenericValuation] ([ACVGenericValuationId])
) ON [CLAIMSCD];

