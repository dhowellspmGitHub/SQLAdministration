CREATE TABLE [dbo].[HomeQuoteUnitAnimal] (
    [AnimalNbr]       INT           NOT NULL,
    [UnitNbr]         INT           NOT NULL,
    [QuoteNbr]        VARCHAR (16)  NOT NULL,
    [AnimalTypeDesc]  VARCHAR (50)  NULL,
    [AnimalBreedDesc] VARCHAR (50)  NULL,
    [BiteHistoryInd]  CHAR (1)      NULL,
    [UpdatedTmstmp]   DATETIME2 (7) NOT NULL,
    [UserUpdatedId]   CHAR (8)      NOT NULL,
    [LastActionCd]    CHAR (1)      NOT NULL,
    [SourceSystemCd]  CHAR (2)      NOT NULL,
    CONSTRAINT [PK_HomeQuoteUnitAnimal] PRIMARY KEY CLUSTERED ([QuoteNbr] ASC, [UnitNbr] ASC, [AnimalNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_HomeQuoteUnitAnimal_HomeQuoteUnit_01] FOREIGN KEY ([QuoteNbr], [UnitNbr]) REFERENCES [dbo].[HomeQuoteUnit] ([QuoteNbr], [UnitNbr])
) ON [POLICYCD];

