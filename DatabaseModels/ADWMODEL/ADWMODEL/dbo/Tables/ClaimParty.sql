CREATE TABLE [dbo].[ClaimParty] (
    [ClaimPartyRelationId] INT           NOT NULL,
    [UpdatedTmstmp]        DATETIME2 (7) NOT NULL,
    [UserUpdatedId]        CHAR (8)      NOT NULL,
    [LastActionCd]         CHAR (1)      NOT NULL,
    [SourceSystemCd]       CHAR (2)      NOT NULL,
    CONSTRAINT [PK_ClaimParty] PRIMARY KEY CLUSTERED ([ClaimPartyRelationId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ClaimParty_ClaimPartyRelation_01] FOREIGN KEY ([ClaimPartyRelationId]) REFERENCES [dbo].[ClaimPartyRelation] ([ClaimPartyRelationId])
) ON [CLAIMSCD];

