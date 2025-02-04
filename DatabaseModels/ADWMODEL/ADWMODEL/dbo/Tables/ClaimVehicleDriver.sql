CREATE TABLE [dbo].[ClaimVehicleDriver] (
    [ClaimVehicleDriverId] INT           NOT NULL,
    [UserUpdatedId]        CHAR (8)      NOT NULL,
    [UpdatedTmstmp]        DATETIME2 (7) NOT NULL,
    [LastActionCd]         CHAR (1)      NOT NULL,
    [SourceSystemCd]       CHAR (2)      NOT NULL,
    [ClaimUserCreateTime]  DATETIME2 (7) NOT NULL,
    [ClaimUserCreatedId]   CHAR (8)      NOT NULL,
    [ClaimUserUpdatedId]   CHAR (8)      NOT NULL,
    [ClaimUpdatedTmstmp]   DATETIME2 (7) NOT NULL,
    [CoveredPartyTypeId]   INT           NULL,
    [CurrentRecordInd]     BIT           NOT NULL,
    [RetiredInd]           CHAR (1)      NOT NULL,
    [SourceSystemId]       INT           NOT NULL,
    [PartyID]              INT           NOT NULL,
    CONSTRAINT [PK_ClaimVehicleDriver] PRIMARY KEY CLUSTERED ([ClaimVehicleDriverId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ClaimVehicleDriver_ClaimCodeLookup_01] FOREIGN KEY ([CoveredPartyTypeId]) REFERENCES [dbo].[ClaimCodeLookup] ([ClaimCodeLookupId]),
    CONSTRAINT [FK_ClaimVehicleDriver_Party_01] FOREIGN KEY ([PartyID]) REFERENCES [dbo].[Party] ([PartyId])
) ON [CLAIMSCD];

