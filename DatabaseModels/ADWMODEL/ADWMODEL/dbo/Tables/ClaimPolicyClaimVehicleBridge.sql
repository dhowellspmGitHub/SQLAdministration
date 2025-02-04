CREATE TABLE [dbo].[ClaimPolicyClaimVehicleBridge] (
    [ClaimPolicyId]  INT           NOT NULL,
    [ClaimVehicleId] INT           NOT NULL,
    [UpdatedTmstmp]  DATETIME2 (7) NOT NULL,
    [UserUpdatedId]  CHAR (8)      NOT NULL,
    [LastActionCd]   CHAR (1)      NOT NULL,
    [SourceSystemId] INT           NOT NULL,
    CONSTRAINT [PK_ClaimPolicyClaimVehicleBridge] PRIMARY KEY CLUSTERED ([ClaimPolicyId] ASC, [ClaimVehicleId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ClaimPolicyClaimVehicleBridge_ClaimsPolicy_01] FOREIGN KEY ([ClaimPolicyId]) REFERENCES [dbo].[ClaimPolicy] ([ClaimPolicyId]),
    CONSTRAINT [FK_ClaimPolicyClaimVehicleBridge_ClaimVehicle] FOREIGN KEY ([ClaimVehicleId]) REFERENCES [dbo].[ClaimVehicle] ([ClaimVehicleId])
) ON [CLAIMSCD];

