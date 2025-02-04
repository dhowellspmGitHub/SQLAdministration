CREATE TABLE [dbo].[ACVLineItemDetails] (
    [ACVLineItemDetailsId]      INT           NOT NULL,
    [ACVGenericValuationId]     INT           NOT NULL,
    [ACVCoverageLineItemId]     INT           NOT NULL,
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
    CONSTRAINT [PK_ACVLineItemDetails] PRIMARY KEY CLUSTERED ([ACVLineItemDetailsId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ACVLineItemDetails_ACVCoverageLineItem_01] FOREIGN KEY ([ACVCoverageLineItemId]) REFERENCES [dbo].[ACVCoverageLineItem] ([ACVCoverageLineItemId]),
    CONSTRAINT [FK_ACVLineItemDetails_ACVGenericValuation_01] FOREIGN KEY ([ACVGenericValuationId]) REFERENCES [dbo].[ACVGenericValuation] ([ACVGenericValuationId])
) ON [CLAIMSCD];

