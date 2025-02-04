CREATE TABLE [dbo].[AutoQuoteUnitAdditionalInterest] (
    [AutoQuoteUnitAdditionalInterestId] INT           NOT NULL,
    [QuoteNbr]                          VARCHAR (16)  NOT NULL,
    [QuoteUnitNbr]                      INT           NOT NULL,
    [SublineBusinessTypeCd]             CHAR (1)      NOT NULL,
    [AdditionalInterestNbr]             CHAR (10)     NULL,
    [MortgageeLoanNbr]                  CHAR (15)     NULL,
    [InterestDesc]                      CHAR (30)     NULL,
    [ToTheAttentionOfNm]                VARCHAR (50)  NULL,
    [MortgageeSequenceNbr]              CHAR (3)      NULL,
    [AdditionalInterestAlt1Nm]          VARCHAR (84)  NULL,
    [AdditionalInterestAlt2Nm]          VARCHAR (84)  NULL,
    [AdditionalInterestAlt3Nm]          VARCHAR (84)  NULL,
    [UpdatedTmstmp]                     DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                     CHAR (8)      NOT NULL,
    [LastActionCd]                      CHAR (1)      NOT NULL,
    [SourceSystemCd]                    CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AutoQuoteUnitAdditionalInterest] PRIMARY KEY CLUSTERED ([AutoQuoteUnitAdditionalInterestId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AutoQuoteUnitAdditionalInterest_AutoQuoteUnit_01] FOREIGN KEY ([QuoteNbr], [QuoteUnitNbr]) REFERENCES [dbo].[AutoQuoteUnit] ([QuoteNbr], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_AutoQuoteUnitAdditionalInterest_01]
    ON [dbo].[AutoQuoteUnitAdditionalInterest]([QuoteNbr] ASC)
    ON [POLICYCI];

