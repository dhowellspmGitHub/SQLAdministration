CREATE TABLE [dbo].[FarmQuoteAnimal] (
    [QuoteNbr]            VARCHAR (16)  NOT NULL,
    [AnimalNbr]           INT           NOT NULL,
    [AnimalTypeDesc]      VARCHAR (50)  NULL,
    [AnimalBreedDesc]     VARCHAR (50)  NULL,
    [OtherAnimalTypeDesc] VARCHAR (250) NULL,
    [OtherBreedDesc]      VARCHAR (250) NULL,
    [BiteHistoryInd]      CHAR (1)      NULL,
    [CreatedTmstmp]       DATETIME      NOT NULL,
    [UserCreatedId]       CHAR (8)      NOT NULL,
    [UpdatedTmstmp]       DATETIME2 (7) NOT NULL,
    [UserUpdatedId]       CHAR (8)      NOT NULL,
    [LastActionCd]        CHAR (1)      NOT NULL,
    [SourceSystemCd]      CHAR (2)      NOT NULL,
    CONSTRAINT [PK_FarmQuoteAnimal] PRIMARY KEY CLUSTERED ([AnimalNbr] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmQuoteAnimal_FarmQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[FarmQuote] ([QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FarmQuoteAnimal_01]
    ON [dbo].[FarmQuoteAnimal]([QuoteNbr] ASC)
    ON [POLICYCI];

