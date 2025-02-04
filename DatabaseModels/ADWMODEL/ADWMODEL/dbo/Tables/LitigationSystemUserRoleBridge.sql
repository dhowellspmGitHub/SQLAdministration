CREATE TABLE [dbo].[LitigationSystemUserRoleBridge] (
    [LitigationId]   INT           NOT NULL,
    [UserUpdatedId]  CHAR (8)      NOT NULL,
    [UpdatedTmstmp]  DATETIME2 (7) NOT NULL,
    [LastActionCd]   CHAR (1)      NOT NULL,
    [SourceSystemCd] CHAR (2)      NOT NULL,
    CONSTRAINT [PK_LitigationSystemUserRoleBridge] PRIMARY KEY NONCLUSTERED ([LitigationId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_LitigationSystemUserRoleBridge_Litigation] FOREIGN KEY ([LitigationId]) REFERENCES [dbo].[Litigation] ([LitigationId])
) ON [CLAIMSCD];

