CREATE TABLE [dbo].[FireUnitAnimal] (
    [PolicyId]        INT           NOT NULL,
    [UnitNbr]         INT           NOT NULL,
    [AnimalNbr]       INT           NOT NULL,
    [PolicyNbr]       VARCHAR (16)  NOT NULL,
    [AnimalTypeDesc]  VARCHAR (50)  NULL,
    [AnimalBreedDesc] VARCHAR (50)  NULL,
    [BiteHistoryInd]  CHAR (1)      NULL,
    [UpdatedTmstmp]   DATETIME2 (7) NOT NULL,
    [UserUpdatedId]   CHAR (8)      NOT NULL,
    [LastActionCd]    CHAR (1)      NOT NULL,
    [SourceSystemCd]  CHAR (2)      NOT NULL,
    CONSTRAINT [PK_FireUnitAnimal] PRIMARY KEY CLUSTERED ([AnimalNbr] ASC, [UnitNbr] ASC, [PolicyId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FireUnitAnimal_FireUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[FireUnit] ([PolicyId], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FireUnitAnimal_01]
    ON [dbo].[FireUnitAnimal]([PolicyId] ASC)
    ON [POLICYCI];

