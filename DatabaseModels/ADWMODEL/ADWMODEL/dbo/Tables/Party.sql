CREATE TABLE [dbo].[Party] (
    [PartyId]                    INT           NOT NULL,
    [PartyPrimaryNameId]         INT           NOT NULL,
    [PartySupplementalDetailsId] INT           NULL,
    [PartyAdditionalDetailsId]   CHAR (18)     NULL,
    [PartyAddressId]             INT           NOT NULL,
    [ClientReferenceNbr]         CHAR (10)     NOT NULL,
    [EffectiveDt]                DATE          NULL,
    [ExpirationDt]               DATE          NULL,
    [UpdatedTmstmp]              DATETIME2 (7) NOT NULL,
    [UserUpdatedId]              CHAR (8)      NOT NULL,
    [LastActionCd]               CHAR (1)      NOT NULL,
    [SourceSystemCd]             CHAR (2)      NOT NULL,
    CONSTRAINT [PK_Party] PRIMARY KEY CLUSTERED ([PartyId] ASC) ON [CLIENTCD],
    CONSTRAINT [FK_Party_PartyAdditionalDetails_01] FOREIGN KEY ([PartyAdditionalDetailsId]) REFERENCES [dbo].[PartyAdditionalDetails] ([PartyAdditionalDetailsId]),
    CONSTRAINT [FK_Party_PartyAddress_01] FOREIGN KEY ([PartyAddressId]) REFERENCES [dbo].[PartyAddress] ([PartyAddressId]),
    CONSTRAINT [FK_Party_PartyName_01] FOREIGN KEY ([PartyPrimaryNameId]) REFERENCES [dbo].[PartyName] ([PartyNameId]),
    CONSTRAINT [FK_Party_PartySupplementalDetailsID_01] FOREIGN KEY ([PartySupplementalDetailsId]) REFERENCES [dbo].[PartySupplementalDetails] ([PartySupplementalDetailsId])
) ON [CLIENTCD];


GO
CREATE NONCLUSTERED INDEX [IX_Party_01]
    ON [dbo].[Party]([ClientReferenceNbr] ASC)
    ON [CLIENTCI];

