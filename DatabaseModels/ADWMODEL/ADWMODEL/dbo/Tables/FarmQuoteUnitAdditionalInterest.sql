CREATE TABLE [dbo].[FarmQuoteUnitAdditionalInterest] (
    [FarmQuoteUnitAdditionalInterestId] INT           NOT NULL,
    [QuoteNbr]                          VARCHAR (16)  NULL,
    [UnitNbr]                           INT           NULL,
    [UnitTypeCd]                        CHAR (1)      NULL,
    [ActiveMortgageeInd]                BIT           NOT NULL,
    [PCAdditionalInterestNbr]           CHAR (10)     NULL,
    [MortgageeSequenceNbr]              CHAR (3)      NULL,
    [MortgageeLoanNbr]                  CHAR (15)     NULL,
    [InterestDesc]                      CHAR (30)     NULL,
    [ToTheAttentionOfNm]                VARCHAR (50)  NULL,
    [EscrowInd]                         CHAR (1)      NULL,
    [UpdatedTmstmp]                     DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                     CHAR (8)      NOT NULL,
    [LastActionCd]                      CHAR (1)      NOT NULL,
    [SourceSystemCd]                    CHAR (2)      NOT NULL,
    CONSTRAINT [PK_FarmQuoteUnitAdditionalInterest] PRIMARY KEY CLUSTERED ([FarmQuoteUnitAdditionalInterestId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AdditionalInterestFarmQuoteUnitAdditionalInterest_FarmUnitQuote_01] FOREIGN KEY ([UnitNbr], [UnitTypeCd], [QuoteNbr]) REFERENCES [dbo].[FarmQuoteUnit] ([UnitNbr], [UnitTypeCd], [QuoteNbr])
) ON [POLICYCD];

