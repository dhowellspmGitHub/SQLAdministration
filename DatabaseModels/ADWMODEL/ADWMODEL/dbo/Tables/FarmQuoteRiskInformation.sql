CREATE TABLE [dbo].[FarmQuoteRiskInformation] (
    [QuoteNbr]       VARCHAR (16)   NOT NULL,
    [SequenceNbr]    CHAR (3)       NOT NULL,
    [RatingFctr]     DECIMAL (4, 3) NULL,
    [RateFieldNm]    VARCHAR (50)   NULL,
    [CreatedTmstmp]  DATETIME       NOT NULL,
    [UserCreatedId]  CHAR (8)       NOT NULL,
    [UpdatedTmstmp]  DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]  CHAR (8)       NOT NULL,
    [LastActionCd]   CHAR (1)       NOT NULL,
    [SourceSystemCd] CHAR (2)       NOT NULL,
    CONSTRAINT [PK_FarmQuoteRiskInformation] PRIMARY KEY CLUSTERED ([QuoteNbr] ASC, [SequenceNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmQuoteRiskInformation_FarmQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[FarmQuote] ([QuoteNbr])
) ON [POLICYCD];

