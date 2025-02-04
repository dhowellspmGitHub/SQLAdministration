CREATE TABLE [dbo].[CommercialIMQuoteAdditionalInterest] (
    [CommercialIMQuoteAdditionalInterestId] INT           NOT NULL,
    [QuoteNbr]                              VARCHAR (16)  NULL,
    [IMPartCoverageTypeCd]                  VARCHAR (50)  NULL,
    [MortgageeSequenceNbr]                  CHAR (3)      NULL,
    [MortgageeLoanNbr]                      CHAR (35)     NULL,
    [PCAdditionalInterestNbr]               CHAR (10)     NULL,
    [InterestDesc]                          VARCHAR (255) NULL,
    [ToTheAttentionOfNm]                    VARCHAR (50)  NULL,
    [EscrowInd]                             CHAR (1)      NULL,
    [CreatedTmstmp]                         DATETIME      NOT NULL,
    [UserCreatedId]                         CHAR (8)      NOT NULL,
    [UpdatedTmstmp]                         DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                         CHAR (8)      NOT NULL,
    [LastActionCd]                          CHAR (1)      NOT NULL,
    [SourceSystemCd]                        CHAR (2)      NOT NULL,
    CONSTRAINT [PK_CommercialIMQuoteAdditionalInterest] PRIMARY KEY CLUSTERED ([CommercialIMQuoteAdditionalInterestId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialIMQuoteAdditionalInterest_CommercialIMQuote_01] FOREIGN KEY ([IMPartCoverageTypeCd], [QuoteNbr]) REFERENCES [dbo].[CommercialIMQuote] ([IMPartCoverageTypeCd], [QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialIMQuoteAdditionalInterest_01]
    ON [dbo].[CommercialIMQuoteAdditionalInterest]([QuoteNbr] ASC)
    ON [POLICYCI];

