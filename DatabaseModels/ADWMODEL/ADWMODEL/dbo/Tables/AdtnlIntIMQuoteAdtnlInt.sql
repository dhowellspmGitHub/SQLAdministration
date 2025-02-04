CREATE TABLE [dbo].[AdtnlIntIMQuoteAdtnlInt] (
    [AdditionalInterestId]                  INT           NOT NULL,
    [CommercialIMQuoteAdditionalInterestId] INT           NOT NULL,
    [QuoteNbr]                              VARCHAR (16)  NOT NULL,
    [UpdatedTmstmp]                         DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                         CHAR (8)      NOT NULL,
    [LastActionCd]                          CHAR (1)      NOT NULL,
    [SourceSystemCd]                        CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AdtnlIntIMQuoteAdtnlInt] PRIMARY KEY CLUSTERED ([CommercialIMQuoteAdditionalInterestId] ASC, [AdditionalInterestId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AdditionalInterestIMQuoteAdditionalInterest_AdditionalInterest_01] FOREIGN KEY ([AdditionalInterestId]) REFERENCES [dbo].[AdditionalInterest] ([AdditionalInterestId]),
    CONSTRAINT [FK_AdditionalInterestIMQuoteAdditionalInterest_CommercialIMQuoteAdditionalInterest_01] FOREIGN KEY ([CommercialIMQuoteAdditionalInterestId]) REFERENCES [dbo].[CommercialIMQuoteAdditionalInterest] ([CommercialIMQuoteAdditionalInterestId])
) ON [POLICYCD];

