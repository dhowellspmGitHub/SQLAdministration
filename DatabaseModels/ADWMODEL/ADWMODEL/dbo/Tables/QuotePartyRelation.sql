CREATE TABLE [dbo].[QuotePartyRelation] (
    [QuotePartyRelationId]       INT           NOT NULL,
    [QuoteNbr]                   VARCHAR (16)  NOT NULL,
    [RelationShipCd]             CHAR (2)      NOT NULL,
    [SubjectAreaCd]              CHAR (3)      NOT NULL,
    [PartyNameId]                INT           NULL,
    [PartyAdditionalDetailsId]   CHAR (18)     NULL,
    [PartySupplementalDetailsId] INT           NULL,
    [PartyAddressId]             INT           NULL,
    [PartyLongNameId]            INT           NULL,
    [PartyLongAddressId]         INT           NULL,
    [ClientReferenceNbr]         CHAR (10)     NOT NULL,
    [CurrentRecordInd]           BIT           NOT NULL,
    [EffectiveDt]                DATE          NULL,
    [ExpirationDt]               DATE          NULL,
    [UpdatedTmstmp]              DATETIME2 (7) NOT NULL,
    [UserUpdatedId]              CHAR (8)      NOT NULL,
    [LastActionCd]               CHAR (1)      NOT NULL,
    [SourceSystemCd]             CHAR (2)      NOT NULL,
    CONSTRAINT [PK_QuotePartyRelation] PRIMARY KEY CLUSTERED ([QuotePartyRelationId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_PartyAddress_QuotePartyRelation_01] FOREIGN KEY ([PartyAddressId]) REFERENCES [dbo].[PartyAddress] ([PartyAddressId]),
    CONSTRAINT [FK_QuotePartyRelation_PartyAdditionalDetails_01] FOREIGN KEY ([PartyAdditionalDetailsId]) REFERENCES [dbo].[PartyAdditionalDetails] ([PartyAdditionalDetailsId]),
    CONSTRAINT [FK_QuotePartyRelation_PartyLongNameAddress_01] FOREIGN KEY ([PartyLongNameId]) REFERENCES [dbo].[PartyLongNameAddress] ([PartyLongNameAddressId]),
    CONSTRAINT [FK_QuotePartyRelation_PartyLongNameAddress_02] FOREIGN KEY ([PartyLongAddressId]) REFERENCES [dbo].[PartyLongNameAddress] ([PartyLongNameAddressId]),
    CONSTRAINT [FK_QuotePartyRelation_PartyName_01] FOREIGN KEY ([PartyNameId]) REFERENCES [dbo].[PartyName] ([PartyNameId]),
    CONSTRAINT [FK_QuotePartyRelation_PartySupplementalDetails_01] FOREIGN KEY ([PartySupplementalDetailsId]) REFERENCES [dbo].[PartySupplementalDetails] ([PartySupplementalDetailsId]),
    CONSTRAINT [FK_QuotePartyRelation_Quote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[Quote] ([QuoteNbr]),
    CONSTRAINT [FK_QuotePartyRelation_Relationships_01] FOREIGN KEY ([RelationShipCd], [SubjectAreaCd]) REFERENCES [dbo].[Relationships] ([RelationShipCd], [SubjectAreaCd])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_QuotePartyRelation_01]
    ON [dbo].[QuotePartyRelation]([QuoteNbr] ASC)
    ON [POLICYCI];

