CREATE TABLE [dbo].[ClaimVehicleClaimVehicleDriverBridge] (
    [ClaimVehicleId]       INT           NOT NULL,
    [ClaimVehicleDriverId] INT           NOT NULL,
    [UserUpdatedId]        CHAR (8)      NOT NULL,
    [UpdatedTmstmp]        DATETIME2 (7) NOT NULL,
    [LastActionCd]         CHAR (1)      NOT NULL,
    [SourceSystemCd]       CHAR (2)      NOT NULL,
    CONSTRAINT [PK_ClaimVehicleClaimVehicleDriverBridge] PRIMARY KEY NONCLUSTERED ([ClaimVehicleId] ASC, [ClaimVehicleDriverId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ClaimVehicleClaimVehicleDriverBridge_ClaimVehicle_01] FOREIGN KEY ([ClaimVehicleId]) REFERENCES [dbo].[ClaimVehicle] ([ClaimVehicleId]),
    CONSTRAINT [FK_ClaimVehicleClaimVehicleDriverBridge_ClaimVehicleDriver_01] FOREIGN KEY ([ClaimVehicleDriverId]) REFERENCES [dbo].[ClaimVehicleDriver] ([ClaimVehicleDriverId])
) ON [CLAIMSCD];

