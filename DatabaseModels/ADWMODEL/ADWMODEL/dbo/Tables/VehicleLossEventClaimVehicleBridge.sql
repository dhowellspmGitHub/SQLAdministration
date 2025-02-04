CREATE TABLE [dbo].[VehicleLossEventClaimVehicleBridge] (
    [ClaimVehicleId] INT           NOT NULL,
    [LossEventId]    INT           NOT NULL,
    [UserUpdatedId]  CHAR (8)      NOT NULL,
    [UpdatedTmstmp]  DATETIME2 (7) NOT NULL,
    [LastActionCd]   CHAR (1)      NOT NULL,
    [SourceSystemCd] CHAR (2)      NOT NULL,
    CONSTRAINT [PK_VehicleLossEventClaimVehicleBridge] PRIMARY KEY NONCLUSTERED ([ClaimVehicleId] ASC, [LossEventId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_VehicleLEClaimVehicleBridge_ClaimVehicle_01] FOREIGN KEY ([ClaimVehicleId]) REFERENCES [dbo].[ClaimVehicle] ([ClaimVehicleId]),
    CONSTRAINT [FK_VehicleLEClaimVehicleBridge_VehicleLE_01] FOREIGN KEY ([LossEventId]) REFERENCES [dbo].[VehicleLossEvent] ([LossEventId])
) ON [CLAIMSCD];

