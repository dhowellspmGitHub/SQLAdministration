CREATE TABLE [dbo].[FireQuoteUnitAdditionalInterest] (
    [FireQuoteUnitAdditionalInterestId] INT           NOT NULL,
    [QuoteNbr]                          VARCHAR (16)  NOT NULL,
    [UnitNbr]                           INT           NOT NULL,
    [PCAdditionalInterestNbr]           CHAR (10)     NULL,
    [ActiveMortgageeInd]                BIT           NOT NULL,
    [MortgageeSequenceNbr]              CHAR (1)      NULL,
    [MortgageeLoanNbr]                  CHAR (15)     NULL,
    [InterestDesc]                      CHAR (30)     NULL,
    [ToTheAttentionOfNm]                VARCHAR (50)  NULL,
    [EscrowInd]                         CHAR (1)      NULL,
    [AdditionalInterestAlt1Nm]          CHAR (30)     NULL,
    [AdditionalInterestAlt2Nm]          CHAR (30)     NULL,
    [AdditionalInterestAlt3Nm]          CHAR (30)     NULL,
    [UpdatedTmstmp]                     DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                     CHAR (8)      NOT NULL,
    [LastActionCd]                      CHAR (1)      NOT NULL,
    [SourceSystemCd]                    CHAR (2)      NOT NULL,
    CONSTRAINT [PK_FireQuoteUnitAdditionalInterest] PRIMARY KEY CLUSTERED ([FireQuoteUnitAdditionalInterestId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FireQuoteUnitAdditionalInterest_FireQuoteUnit_01] FOREIGN KEY ([UnitNbr], [QuoteNbr]) REFERENCES [dbo].[FireQuoteUnit] ([UnitNbr], [QuoteNbr])
) ON [POLICYCD];

