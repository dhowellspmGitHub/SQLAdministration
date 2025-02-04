CREATE TABLE [dbo].[CATGroupAutomation] (
    [CATGroupAutomationId]      INT           NOT NULL,
    [ClaimGroupId]              INT           NOT NULL,
    [CatastropheNbr]            CHAR (10)     NOT NULL,
    [AutoEnabledInd]            BIT           NULL,
    [PropertyEnabledInd]        BIT           NULL,
    [CurrentRecordInd]          BIT           NOT NULL,
    [RetiredInd]                CHAR (1)      NOT NULL,
    [SourceSystemId]            INT           NOT NULL,
    [SourceSystemCreatedTmstmp] DATETIME2 (7) NOT NULL,
    [SourceSystemUserCreatedCd] CHAR (10)     NOT NULL,
    [SourceSystemUpdatedTmstmp] DATETIME2 (7) NOT NULL,
    [SourceSystemUserUpdatedCd] CHAR (10)     NOT NULL,
    [UpdatedTmstmp]             DATETIME2 (7) NOT NULL,
    [UserUpdatedCd]             CHAR (10)     NOT NULL,
    [LastActionCd]              CHAR (1)      NOT NULL,
    [SourceSystemCd]            CHAR (2)      NOT NULL,
    CONSTRAINT [PK_CATGroupAutomation] PRIMARY KEY CLUSTERED ([CATGroupAutomationId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_CATGroupAutomation_Catastrophe_01] FOREIGN KEY ([CatastropheNbr]) REFERENCES [dbo].[Catastrophe] ([CatastropheNbr]),
    CONSTRAINT [FK_CATGroupAutomation_ClaimGroup_01] FOREIGN KEY ([ClaimGroupId]) REFERENCES [dbo].[ClaimGroup] ([ClaimGroupId])
) ON [CLAIMSCD];

