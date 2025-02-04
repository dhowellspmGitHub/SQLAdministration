CREATE TABLE [dbo].[AdtnlIntFarmQuoteAdtnlInt] (
    [AdditionalInterestId]  INT           NOT NULL,
    [FarmQuoteAdditionalId] INT           NOT NULL,
    [QuoteNbr]              VARCHAR (16)  NOT NULL,
    [UpdatedTmstmp]         DATETIME2 (7) NOT NULL,
    [UserUpdatedId]         CHAR (8)      NOT NULL,
    [LastActionCd]          CHAR (1)      NOT NULL,
    [SourceSystemCd]        CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AdtnlIntFarmQuoteAdtnlInt] PRIMARY KEY CLUSTERED ([FarmQuoteAdditionalId] ASC, [QuoteNbr] ASC, [AdditionalInterestId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AdditionalInterestFarmQuoteAdditionalInterest_AdditionalInterest_01] FOREIGN KEY ([AdditionalInterestId]) REFERENCES [dbo].[AdditionalInterest] ([AdditionalInterestId]),
    CONSTRAINT [FK_AdditionalInterestFarmQuoteAdditionalInterest_FarmQuoteAdditionalInterest_01] FOREIGN KEY ([FarmQuoteAdditionalId], [QuoteNbr]) REFERENCES [dbo].[FarmQuoteAdditionalInterest] ([FarmQuoteAdditionalId], [QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_AdtnlIntFarmQuoteAdtnlInt_01]
    ON [dbo].[AdtnlIntFarmQuoteAdtnlInt]([QuoteNbr] ASC)
    ON [POLICYCI];

