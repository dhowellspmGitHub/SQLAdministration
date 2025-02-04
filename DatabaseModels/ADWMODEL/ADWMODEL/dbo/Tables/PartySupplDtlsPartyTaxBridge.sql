CREATE TABLE [dbo].[PartySupplDtlsPartyTaxBridge] (
    [PartyTaxId]                 INT           NOT NULL,
    [PartySupplementalDetailsId] INT           NOT NULL,
    [UpdatedTmstmp]              DATETIME2 (7) NOT NULL,
    [UserUpdatedId]              CHAR (8)      NOT NULL,
    [LastActionCd]               CHAR (1)      NOT NULL,
    CONSTRAINT [PK_PartySupplDtlsPartyTax] PRIMARY KEY CLUSTERED ([PartyTaxId] ASC, [PartySupplementalDetailsId] ASC) ON [CLIENTCD],
    CONSTRAINT [FK_PartySupplDtlsPartyTax_PartySupplementalDetails_01] FOREIGN KEY ([PartySupplementalDetailsId]) REFERENCES [dbo].[PartySupplementalDetails] ([PartySupplementalDetailsId]),
    CONSTRAINT [FK_PartySupplDtlsPartyTax_PartyTax_01] FOREIGN KEY ([PartyTaxId]) REFERENCES [dbo].[PartyTax] ([PartyTaxId])
) ON [CLIENTCD];

