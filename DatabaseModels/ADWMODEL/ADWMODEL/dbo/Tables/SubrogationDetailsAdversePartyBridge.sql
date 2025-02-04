CREATE TABLE [dbo].[SubrogationDetailsAdversePartyBridge] (
    [SubrogationDetailsId]      INT           NOT NULL,
    [SubrogationAdversePartyId] INT           NOT NULL,
    [UpdatedTmstmp]             DATETIME2 (7) NOT NULL,
    [UserUpdatedId]             CHAR (8)      NOT NULL,
    [LastActionCd]              CHAR (1)      NOT NULL,
    [SourceSystemCd]            CHAR (2)      NOT NULL,
    CONSTRAINT [PK_SubrogationDetailsAdversePartyBridge] PRIMARY KEY CLUSTERED ([SubrogationDetailsId] ASC, [SubrogationAdversePartyId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_SubrogationDetailsAdversePartyBridge_SubrogationAdverseParty_01] FOREIGN KEY ([SubrogationAdversePartyId]) REFERENCES [dbo].[SubrogationAdverseParty] ([SubrogationAdversePartyId]),
    CONSTRAINT [FK_SubrogationDetailsAdversePartyBridge_SubrogationDetails_01] FOREIGN KEY ([SubrogationDetailsId]) REFERENCES [dbo].[SubrogationDetails] ([SubrogationDetailsId])
) ON [CLAIMSCD];

