CREATE TABLE [dbo].[PopulationGroupFactor] (
    [PopulationGroupNbr] CHAR (3)       NOT NULL,
    [PopulationFctr]     DECIMAL (5, 5) NULL,
    [UpdatedTmstmp]      DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]      CHAR (8)       NOT NULL,
    [LastActionCd]       CHAR (1)       NOT NULL,
    [SourceSystemCd]     CHAR (2)       NOT NULL,
    CONSTRAINT [PK_PopulationGroupFactor] PRIMARY KEY CLUSTERED ([PopulationGroupNbr] ASC) ON [AGENCYCD]
) ON [AGENCYCD];

