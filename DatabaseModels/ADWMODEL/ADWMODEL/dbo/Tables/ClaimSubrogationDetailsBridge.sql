CREATE TABLE [dbo].[ClaimSubrogationDetailsBridge] (
    [ClaimId]              INT           NOT NULL,
    [SubrogationDetailsId] INT           NOT NULL,
    [UpdatedTmstmp]        DATETIME2 (7) NOT NULL,
    [UserUpdatedId]        CHAR (8)      NOT NULL,
    [LastActionCd]         CHAR (1)      NOT NULL,
    [SourceSystemCd]       CHAR (2)      NOT NULL,
    CONSTRAINT [PK_ClaimsSubrogationDetailsBridge] PRIMARY KEY CLUSTERED ([ClaimId] ASC, [SubrogationDetailsId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ClaimSubrogationDetailsBridge_Claim_01] FOREIGN KEY ([ClaimId]) REFERENCES [dbo].[Claim] ([ClaimID]),
    CONSTRAINT [FK_ClaimSubrogationDetailsBridge_SubrogationDetails_01] FOREIGN KEY ([SubrogationDetailsId]) REFERENCES [dbo].[SubrogationDetails] ([SubrogationDetailsId])
) ON [CLAIMSCD];

