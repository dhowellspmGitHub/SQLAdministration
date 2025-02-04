CREATE TABLE [dbo].[ClaimPartyRelationBridge] (
    [ClaimPartyRelationId] INT           NOT NULL,
    [PartyId]              INT           NOT NULL,
    [RelationShipCd]       CHAR (2)      NOT NULL,
    [ClaimID]              INT           NOT NULL,
    [ClientReferenceNbr]   CHAR (10)     NOT NULL,
    [ClaimSystemEntityId]  INT           NULL,
    [RetiredClaimPartyInd] CHAR (1)      NULL,
    [ClaimSystemEntityNm]  VARCHAR (30)  NULL,
    [CurrentRecordInd]     BIT           NOT NULL,
    [UpdatedTmstmp]        DATETIME2 (7) NOT NULL,
    [UserUpdatedId]        CHAR (8)      NOT NULL,
    [LastActionCd]         CHAR (1)      NOT NULL,
    [SourceSystemCd]       CHAR (2)      NOT NULL,
    [SourceSystemId]       INT           NOT NULL,
    CONSTRAINT [PK_ClaimPartyRelationBridge] PRIMARY KEY CLUSTERED ([ClaimPartyRelationId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ClaimPartyRelationBridge_Claim_01] FOREIGN KEY ([ClaimID]) REFERENCES [dbo].[Claim] ([ClaimID]),
    CONSTRAINT [FK_ClaimPartyRelationBridge_Party_01] FOREIGN KEY ([PartyId]) REFERENCES [dbo].[Party] ([PartyId])
) ON [CLAIMSCD];

