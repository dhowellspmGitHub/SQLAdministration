CREATE TABLE [dbo].[FarmQuoteUnitRiskInformation] (
    [QuoteNbr]       VARCHAR (16)   NOT NULL,
    [UnitNbr]        INT            NOT NULL,
    [UnitTypeCd]     CHAR (1)       NOT NULL,
    [SequenceNbr]    CHAR (3)       NOT NULL,
    [RatingFctr]     DECIMAL (4, 3) NULL,
    [RateFieldNm]    VARCHAR (50)   NULL,
    [CreatedTmstmp]  DATETIME       NOT NULL,
    [UserCreatedId]  CHAR (8)       NOT NULL,
    [UpdatedTmstmp]  DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]  CHAR (8)       NOT NULL,
    [LastActionCd]   CHAR (1)       NOT NULL,
    [SourceSystemCd] CHAR (2)       NOT NULL,
    CONSTRAINT [PK_FarmQuoteUnitRiskInformation] PRIMARY KEY CLUSTERED ([UnitNbr] ASC, [UnitTypeCd] ASC, [QuoteNbr] ASC, [SequenceNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmUnitQuoteRiskInformation_FarmUnitQuote_01] FOREIGN KEY ([UnitNbr], [UnitTypeCd], [QuoteNbr]) REFERENCES [dbo].[FarmQuoteUnit] ([UnitNbr], [UnitTypeCd], [QuoteNbr])
) ON [POLICYCD];

