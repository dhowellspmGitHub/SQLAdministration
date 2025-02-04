CREATE TABLE [dbo].[Relationships] (
    [RelationShipCd]   CHAR (2)      NOT NULL,
    [SubjectAreaCd]    CHAR (3)      NOT NULL,
    [RelationshipDesc] VARCHAR (50)  NULL,
    [EffectiveDt]      DATE          NULL,
    [ExpirationDt]     DATE          NULL,
    [UpdatedTmstmp]    DATETIME2 (7) NOT NULL,
    [UserUpdatedId]    CHAR (8)      NOT NULL,
    [LastActionCd]     CHAR (1)      NOT NULL,
    [SourceSystemCd]   CHAR (2)      NOT NULL,
    CONSTRAINT [PK_Relationships] PRIMARY KEY CLUSTERED ([RelationShipCd] ASC, [SubjectAreaCd] ASC) ON [CLIENTCD]
) ON [CLIENTCD];

