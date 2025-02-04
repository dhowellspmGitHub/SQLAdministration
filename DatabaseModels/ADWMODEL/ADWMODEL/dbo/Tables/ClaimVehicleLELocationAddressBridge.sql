CREATE TABLE [dbo].[ClaimVehicleLELocationAddressBridge] (
    [ClaimVehicleId]             INT           NOT NULL,
    [LossEventLocationAddressId] INT           NOT NULL,
    [UserUpdatedId]              CHAR (8)      NOT NULL,
    [UpdatedTmstmp]              DATETIME2 (7) NOT NULL,
    [LastActionCd]               CHAR (1)      NOT NULL,
    [SourceSystemCd]             CHAR (2)      NOT NULL,
    CONSTRAINT [PK_ClaimVehicleLELocationAddress] PRIMARY KEY CLUSTERED ([ClaimVehicleId] ASC, [LossEventLocationAddressId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ClaimVehicleLELocationAddressBridge_ClaimVehicle_01] FOREIGN KEY ([ClaimVehicleId]) REFERENCES [dbo].[ClaimVehicle] ([ClaimVehicleId]),
    CONSTRAINT [FK_ClaimVehicleLELocationAddressBridge_LELocationAddress_01] FOREIGN KEY ([LossEventLocationAddressId]) REFERENCES [dbo].[LossEventLocationAddress] ([LossEventLocationAddressId])
) ON [CLAIMSCD];

