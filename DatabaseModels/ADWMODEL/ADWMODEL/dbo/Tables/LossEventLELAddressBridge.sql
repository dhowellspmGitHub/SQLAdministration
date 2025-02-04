CREATE TABLE [dbo].[LossEventLELAddressBridge] (
    [LossEventId]                INT           NOT NULL,
    [LossEventLocationAddressId] INT           NOT NULL,
    [UserUpdatedId]              CHAR (8)      NOT NULL,
    [UpdatedTmstmp]              DATETIME2 (7) NOT NULL,
    [LastActionCd]               CHAR (1)      NOT NULL,
    [SourceSystemCd]             CHAR (2)      NOT NULL,
    CONSTRAINT [PK_LossEventLELAddressBridge] PRIMARY KEY CLUSTERED ([LossEventId] ASC, [LossEventLocationAddressId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_LossEventLELAddressBridge_LELAddress_01] FOREIGN KEY ([LossEventLocationAddressId]) REFERENCES [dbo].[LossEventLocationAddress] ([LossEventLocationAddressId]),
    CONSTRAINT [FK_LossEventLELAddressBridge_LossEvent_01] FOREIGN KEY ([LossEventId]) REFERENCES [dbo].[LossEvent] ([LossEventId])
) ON [CLAIMSCD];

