CREATE TABLE [dbo].[AdtnlIntUmbrellaQuoteAdtnlInt] (
    [AdditionalInterestId]                  INT           NOT NULL,
    [UmbrellaQuoteUnitAdditionalInterestId] INT           NOT NULL,
    [QuoteNbr]                              VARCHAR (16)  NOT NULL,
    [UpdatedTmstmp]                         DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                         CHAR (8)      NOT NULL,
    [LastActionCd]                          CHAR (1)      NOT NULL,
    [SourceSystemCd]                        CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AdtnlIntUmbrellaQuoteAdtnlInt] PRIMARY KEY CLUSTERED ([UmbrellaQuoteUnitAdditionalInterestId] ASC, [AdditionalInterestId] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AdditionalInterestUmbrellaQuoteUnitAdditionalInterest_AdditionalInterest_01] FOREIGN KEY ([AdditionalInterestId]) REFERENCES [dbo].[AdditionalInterest] ([AdditionalInterestId]),
    CONSTRAINT [FK_AdditionalInterestUmbrellaQuoteUnitAdditionalInterest_UmbrellaQuoteUnitAdditionalInterest_01] FOREIGN KEY ([UmbrellaQuoteUnitAdditionalInterestId], [QuoteNbr]) REFERENCES [dbo].[UmbrellaQuoteAdditionalInterest] ([UmbrellaQuoteUnitAdditionalInterestId], [QuoteNbr])
) ON [POLICYCD];

