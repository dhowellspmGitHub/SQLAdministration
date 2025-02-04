CREATE TABLE [dbo].[ExposureSubrogationDetailsBridge] (
    [ExposureId]                INT           NOT NULL,
    [SubrogationDetailsId]      INT           NOT NULL,
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
    CONSTRAINT [PK_ExposureSubrogationDetailsBridge] PRIMARY KEY CLUSTERED ([ExposureId] ASC, [SubrogationDetailsId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ExposureSubrogationDetailsBridge_Exposure_01] FOREIGN KEY ([ExposureId]) REFERENCES [dbo].[Exposure] ([ExposureId]),
    CONSTRAINT [FK_ExposureSubrogationDetailsBridge_SubrogationDetails_01] FOREIGN KEY ([SubrogationDetailsId]) REFERENCES [dbo].[SubrogationDetails] ([SubrogationDetailsId])
) ON [CLAIMSCD];

