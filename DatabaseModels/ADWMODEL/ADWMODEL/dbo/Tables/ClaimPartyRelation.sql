CREATE TABLE [dbo].[ClaimPartyRelation] (
    [ClaimPartyRelationId]    INT           NOT NULL,
    [PartyId]                 INT           NOT NULL,
    [RelationShipCd]          CHAR (2)      NOT NULL,
    [SubjectAreaCd]           CHAR (3)      NOT NULL,
    [ClaimId]                 INT           NOT NULL,
    [ClientReferenceNbr]      CHAR (10)     NOT NULL,
    [ClaimSystemEntityId]     INT           NULL,
    [RetiredClaimPartyInd]    CHAR (1)      NULL,
    [ClaimSystemEntityNm]     VARCHAR (30)  NULL,
    [MostRecentClaimPartyInd] CHAR (1)      NULL,
    [UpdatedTmstmp]           DATETIME2 (7) NOT NULL,
    [UserUpdatedId]           CHAR (8)      NOT NULL,
    [LastActionCd]            CHAR (1)      NOT NULL,
    [SourceSystemCd]          CHAR (2)      NOT NULL,
    CONSTRAINT [PK_ClaimPartyRelation] PRIMARY KEY CLUSTERED ([ClaimPartyRelationId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ClaimPartyRelation_Party_01] FOREIGN KEY ([PartyId]) REFERENCES [dbo].[Party] ([PartyId]),
    CONSTRAINT [FK_ClaimPartyRelation_Relationships_01] FOREIGN KEY ([RelationShipCd], [SubjectAreaCd]) REFERENCES [dbo].[Relationships] ([RelationShipCd], [SubjectAreaCd])
) ON [CLAIMSCD];

