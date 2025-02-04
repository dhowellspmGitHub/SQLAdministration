CREATE TABLE [dbo].[FireQuoteUnitAnimal] (
    [QuoteNbr]        VARCHAR (16)  NOT NULL,
    [UnitNbr]         INT           NOT NULL,
    [AnimalNbr]       INT           NOT NULL,
    [AnimalTypeDesc]  VARCHAR (50)  NULL,
    [AnimalBreedDesc] VARCHAR (50)  NULL,
    [BiteHistoryInd]  CHAR (1)      NULL,
    [UpdatedTmstmp]   DATETIME2 (7) NOT NULL,
    [UserUpdatedId]   CHAR (8)      NOT NULL,
    [LastActionCd]    CHAR (1)      NOT NULL,
    [SourceSystemCd]  CHAR (2)      NOT NULL,
    CONSTRAINT [PK_FireQuoteUnitAnimal] PRIMARY KEY CLUSTERED ([AnimalNbr] ASC, [UnitNbr] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FireQuoteUnitAnimal_FireQuoteUnit_01] FOREIGN KEY ([UnitNbr], [QuoteNbr]) REFERENCES [dbo].[FireQuoteUnit] ([UnitNbr], [QuoteNbr])
) ON [POLICYCD];

