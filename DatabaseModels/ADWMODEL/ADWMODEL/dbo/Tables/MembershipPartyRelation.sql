﻿CREATE TABLE [dbo].[MembershipPartyRelation] (
    [MembershipPartyRelationId]    INT           NOT NULL,
    [MembershipId]                 INT           NOT NULL,
    [PartyId]                      INT           NOT NULL,
    [RelationShipCd]               CHAR (2)      NOT NULL,
    [SubjectAreaCd]                CHAR (3)      NOT NULL,
    [MembershipForeignAddressId]   INT           NULL,
    [MembershipAlternateAddressId] INT           NULL,
    [CurrentRecordInd]             BIT           NOT NULL,
    [EffectiveDt]                  DATE          NULL,
    [ExpiryDt]                     DATE          NULL,
    [SourceSystemUserUpdatedId]    CHAR (10)     NOT NULL,
    [SourceSystemUpdatedTmstmp]    DATETIME2 (7) NOT NULL,
    [UpdatedTmstmp]                DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                CHAR (8)      NOT NULL,
    [LastActionCd]                 CHAR (1)      NOT NULL,
    [SourceSystemCd]               CHAR (2)      NOT NULL,
    CONSTRAINT [PK_MembershipPartyRelation] PRIMARY KEY CLUSTERED ([MembershipPartyRelationId] ASC) ON [MEMBERCD],
    CONSTRAINT [FK_MembershipPartyRelation_Membership_01] FOREIGN KEY ([MembershipId]) REFERENCES [dbo].[Membership] ([MembershipId]),
    CONSTRAINT [FK_MembershipPartyRelation_Party_01] FOREIGN KEY ([PartyId]) REFERENCES [dbo].[Party] ([PartyId]),
    CONSTRAINT [FK_MembershipPartyRelation_PartyAddress_01] FOREIGN KEY ([MembershipAlternateAddressId]) REFERENCES [dbo].[PartyAddress] ([PartyAddressId]),
    CONSTRAINT [FK_MembershipPartyRelation_PartyLongNameAddress_01] FOREIGN KEY ([MembershipForeignAddressId]) REFERENCES [dbo].[PartyLongNameAddress] ([PartyLongNameAddressId]),
    CONSTRAINT [FK_MembershipPartyRelation_Relationships] FOREIGN KEY ([RelationShipCd], [SubjectAreaCd]) REFERENCES [dbo].[Relationships] ([RelationShipCd], [SubjectAreaCd])
) ON [MEMBERCD];

