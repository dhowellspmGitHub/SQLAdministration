CREATE TABLE [dbo].[LitigationLELocationAddressBridge] (
    [LitigationId]               INT           NOT NULL,
    [LossEventLocationAddressId] INT           NOT NULL,
    [UserUpdatedId]              CHAR (8)      NOT NULL,
    [UpdatedTmstmp]              DATETIME2 (7) NOT NULL,
    [LastActionCd]               CHAR (1)      NOT NULL,
    [SourceSystemCd]             CHAR (2)      NOT NULL,
    CONSTRAINT [PK_LitigationLELocationAddressBridge] PRIMARY KEY NONCLUSTERED ([LitigationId] ASC, [LossEventLocationAddressId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_LELocationAddress_LitigationLELocationAddressBridge_01] FOREIGN KEY ([LossEventLocationAddressId]) REFERENCES [dbo].[LossEventLocationAddress] ([LossEventLocationAddressId]),
    CONSTRAINT [FK_Litigation_LitigationLELocationAddressBridge_01] FOREIGN KEY ([LitigationId]) REFERENCES [dbo].[Litigation] ([LitigationId])
) ON [CLAIMSCD];

