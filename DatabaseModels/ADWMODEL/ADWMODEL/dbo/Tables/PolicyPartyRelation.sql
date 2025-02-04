CREATE TABLE [dbo].[PolicyPartyRelation] (
    [PolicyPartyRelationId]      INT           NOT NULL,
    [PolicyId]                   INT           NOT NULL,
    [RelationShipCd]             CHAR (2)      NOT NULL,
    [SubjectAreaCd]              CHAR (3)      NOT NULL,
    [PartyNameId]                INT           NULL,
    [PartyAdditionalDetailsId]   CHAR (18)     NULL,
    [PartySupplementalDetailsId] INT           NULL,
    [PartyAddressId]             INT           NULL,
    [PartyLongNameId]            INT           NULL,
    [PartyLongAddressId]         INT           NULL,
    [ClientReferenceNbr]         CHAR (10)     NOT NULL,
    [PolicyNbr]                  VARCHAR (16)  NOT NULL,
    [CurrentRecordInd]           BIT           NOT NULL,
    [EffectiveDt]                DATE          NULL,
    [ExpirationDt]               DATE          NULL,
    [DriverAddedDt]              DATETIME2 (7) NULL,
    [UpdatedTmstmp]              DATETIME2 (7) NOT NULL,
    [UserUpdatedId]              CHAR (8)      NOT NULL,
    [LastActionCd]               CHAR (1)      NOT NULL,
    [SourceSystemCd]             CHAR (2)      NOT NULL,
    CONSTRAINT [PK_PolicyPartyRelation] PRIMARY KEY CLUSTERED ([PolicyPartyRelationId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_PolicyPartyRelation_PartyAdditionalDetails_01] FOREIGN KEY ([PartyAdditionalDetailsId]) REFERENCES [dbo].[PartyAdditionalDetails] ([PartyAdditionalDetailsId]),
    CONSTRAINT [FK_PolicyPartyRelation_PartyAddress_01] FOREIGN KEY ([PartyAddressId]) REFERENCES [dbo].[PartyAddress] ([PartyAddressId]),
    CONSTRAINT [FK_PolicyPartyRelation_PartyLongNameAddress_01] FOREIGN KEY ([PartyLongAddressId]) REFERENCES [dbo].[PartyLongNameAddress] ([PartyLongNameAddressId]),
    CONSTRAINT [FK_PolicyPartyRelation_PartyLongNameAddress_02] FOREIGN KEY ([PartyLongNameId]) REFERENCES [dbo].[PartyLongNameAddress] ([PartyLongNameAddressId]),
    CONSTRAINT [FK_PolicyPartyRelation_PartyName_01] FOREIGN KEY ([PartyNameId]) REFERENCES [dbo].[PartyName] ([PartyNameId]),
    CONSTRAINT [FK_PolicyPartyRelation_PartySupplementalDetails_01] FOREIGN KEY ([PartySupplementalDetailsId]) REFERENCES [dbo].[PartySupplementalDetails] ([PartySupplementalDetailsId]),
    CONSTRAINT [FK_PolicyPartyRelation_Policy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[Policy] ([PolicyId]),
    CONSTRAINT [FK_PolicyPartyRelation_Relationships_01] FOREIGN KEY ([RelationShipCd], [SubjectAreaCd]) REFERENCES [dbo].[Relationships] ([RelationShipCd], [SubjectAreaCd])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_PolicyPartyRelation_02]
    ON [dbo].[PolicyPartyRelation]([PolicyId] ASC, [PolicyNbr] ASC, [CurrentRecordInd] ASC)
    ON [POLICYCI];


GO
CREATE NONCLUSTERED INDEX [IX_PolicyPartyRelation_01]
    ON [dbo].[PolicyPartyRelation]([PolicyId] ASC)
    ON [POLICYCI];

