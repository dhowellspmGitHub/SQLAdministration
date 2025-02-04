CREATE TABLE [dbo].[MobileHomeUnitAnimal] (
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
    CONSTRAINT [PK_MobileHomeUnitAnimal] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [UnitNbr] ASC, [AnimalNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_MobileHomeUnitAnimal_MobileHomeUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[MobileHomeUnit] ([PolicyId], [UnitNbr])
) ON [POLICYCD];

