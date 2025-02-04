CREATE TABLE [dbo].[ACVCoverageLineItem] (
    [ACVCoverageLineItemId]     INT           NOT NULL,
    [ACVCoverageGroupId]        INT           NOT NULL,
    [ACVGenericValuationId]     INT           NOT NULL,
    [LineItemDesc]              VARCHAR (100) NULL,
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
    CONSTRAINT [PK_ACVCoverageLineItem] PRIMARY KEY CLUSTERED ([ACVCoverageLineItemId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ACVCoverageLineItem_ACVCoverageGroup_01] FOREIGN KEY ([ACVCoverageGroupId]) REFERENCES [dbo].[ACVCoverageGroup] ([ACVCoverageGroupId]),
    CONSTRAINT [FK_ACVCoverageLineItem_ACVGenericValuation_01] FOREIGN KEY ([ACVGenericValuationId]) REFERENCES [dbo].[ACVGenericValuation] ([ACVGenericValuationId])
) ON [CLAIMSCD];

