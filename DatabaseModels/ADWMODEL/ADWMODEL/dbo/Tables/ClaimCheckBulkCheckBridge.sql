CREATE TABLE [dbo].[ClaimCheckBulkCheckBridge] (
    [CheckId]        INT           NOT NULL,
    [BulkCheckId]    INT           NOT NULL,
    [UserUpdatedId]  CHAR (8)      NOT NULL,
    [UpdatedTmstmp]  DATETIME2 (7) NOT NULL,
    [LastActionCd]   CHAR (1)      NOT NULL,
    [SourceSystemCd] CHAR (2)      NOT NULL,
    CONSTRAINT [PK_ClaimCheckBulkCheckBridge] PRIMARY KEY NONCLUSTERED ([CheckId] ASC, [BulkCheckId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_ClaimCheckBulkCheckBridge_BulkCheck_01] FOREIGN KEY ([BulkCheckId]) REFERENCES [dbo].[BulkCheck] ([BulkCheckId]),
    CONSTRAINT [FK_ClaimCheckBulkCheckBridge_ClaimCheck_01] FOREIGN KEY ([CheckId]) REFERENCES [dbo].[ClaimCheck] ([CheckId])
) ON [CLAIMSCD];

