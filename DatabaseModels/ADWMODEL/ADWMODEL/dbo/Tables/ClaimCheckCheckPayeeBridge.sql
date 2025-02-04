CREATE TABLE [dbo].[ClaimCheckCheckPayeeBridge] (
    [CheckId]        INT           NOT NULL,
    [CheckPayeeId]   INT           NOT NULL,
    [UserUpdatedId]  CHAR (8)      NOT NULL,
    [UpdatedTmstmp]  DATETIME2 (7) NOT NULL,
    [LastActionCd]   CHAR (1)      NOT NULL,
    [SourceSystemCd] CHAR (2)      NOT NULL,
    CONSTRAINT [PK_ClaimCheckCheckPayeeBridge] PRIMARY KEY NONCLUSTERED ([CheckId] ASC, [CheckPayeeId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ClaimCheckCheckPayeeBridge_CheckPayee_01] FOREIGN KEY ([CheckPayeeId]) REFERENCES [dbo].[CheckPayee] ([CheckPayeeId]),
    CONSTRAINT [FK_ClaimCheckCheckPayeeBridge_ClaimCheck_01] FOREIGN KEY ([CheckId]) REFERENCES [dbo].[ClaimCheck] ([CheckId])
) ON [CLAIMSCD];

