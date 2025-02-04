CREATE TABLE [dbo].[PropertyLELELocationAddressBridge] (
    [LossEventLocationAddressId] INT           NOT NULL,
    [LossEventId]                INT           NOT NULL,
    [UserUpdatedId]              CHAR (8)      NOT NULL,
    [UpdatedTmstmp]              DATETIME2 (7) NOT NULL,
    [LastActionCd]               CHAR (1)      NOT NULL,
    [SourceSystemCd]             CHAR (2)      NOT NULL,
    CONSTRAINT [PK_PropertyLELELocationAddressBridge] PRIMARY KEY NONCLUSTERED ([LossEventLocationAddressId] ASC, [LossEventId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_PropertyLELELocationAddress_LELocationAddress_01] FOREIGN KEY ([LossEventLocationAddressId]) REFERENCES [dbo].[LossEventLocationAddress] ([LossEventLocationAddressId]),
    CONSTRAINT [FK_PropertyLELELocationAddress_PropertyLossEvent_01] FOREIGN KEY ([LossEventId]) REFERENCES [dbo].[PropertyLossEvent] ([LossEventId])
) ON [CLAIMSCD];

