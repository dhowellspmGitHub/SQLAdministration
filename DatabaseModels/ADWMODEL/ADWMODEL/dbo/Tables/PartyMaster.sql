CREATE TABLE [dbo].[PartyMaster] (
    [ClientReferenceNbr] CHAR (10)     NOT NULL,
    [EffectiveDt]        DATE          NOT NULL,
    [ExpirationDt]       DATE          NULL,
    [UpdatedTmstmp]      DATETIME2 (7) NOT NULL,
    [UserUpdatedId]      CHAR (8)      NOT NULL,
    [LastActionCd]       CHAR (1)      NOT NULL,
    [SourceSystemCd]     CHAR (2)      NOT NULL,
    CONSTRAINT [PK_PartyMaster] PRIMARY KEY CLUSTERED ([ClientReferenceNbr] ASC) ON [CLIENTCD]
) ON [CLIENTCD];

