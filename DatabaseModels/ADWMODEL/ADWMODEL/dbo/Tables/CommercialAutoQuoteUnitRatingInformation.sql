CREATE TABLE [dbo].[CommercialAutoQuoteUnitRatingInformation] (
    [UnitNbr]               INT            NOT NULL,
    [QuoteNbr]              VARCHAR (16)   NOT NULL,
    [SequenceNbr]           CHAR (3)       NOT NULL,
    [LineofBusinessCd]      CHAR (2)       NOT NULL,
    [SublineBusinessTypeCd] CHAR (1)       NOT NULL,
    [LastActionCd]          CHAR (1)       NOT NULL,
    [RatingFctr]            DECIMAL (4, 3) NULL,
    [RatingFieldNm]         VARCHAR (255)  NULL,
    [RatingValueTxt]        VARCHAR (100)  NULL,
    [UpdatedTmstmp]         DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]         CHAR (8)       NOT NULL,
    [SourceSystemCd]        CHAR (2)       NOT NULL,
    CONSTRAINT [PK_CommercialAutoQuoteUnitRatingInformation] PRIMARY KEY NONCLUSTERED ([UnitNbr] ASC, [QuoteNbr] ASC, [SequenceNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialAutoQuoteUnitRatingInformation_AutoQuoteUnit_01] FOREIGN KEY ([QuoteNbr], [UnitNbr]) REFERENCES [dbo].[AutoQuoteUnit] ([QuoteNbr], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialAutoQuoteUnitRatingInformation_01]
    ON [dbo].[CommercialAutoQuoteUnitRatingInformation]([QuoteNbr] ASC)
    ON [POLICYCI];

