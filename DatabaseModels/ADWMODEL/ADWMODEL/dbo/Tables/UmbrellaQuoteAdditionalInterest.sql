CREATE TABLE [dbo].[UmbrellaQuoteAdditionalInterest] (
    [UmbrellaQuoteUnitAdditionalInterestId] INT           NOT NULL,
    [QuoteNbr]                              VARCHAR (16)  NOT NULL,
    [ActiveMortgageeInd]                    BIT           NOT NULL,
    [PCAdditionalInterestNbr]               CHAR (10)     NULL,
    [MortgageeSequenceNbr]                  CHAR (3)      NULL,
    [MortgageeLoanNbr]                      CHAR (15)     NULL,
    [InterestDesc]                          CHAR (30)     NULL,
    [ToTheAttentionOfNm]                    VARCHAR (50)  NULL,
    [EscrowInd]                             CHAR (1)      NULL,
    [UpdatedTmstmp]                         DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                         CHAR (8)      NOT NULL,
    [LastActionCd]                          CHAR (1)      NOT NULL,
    [SourceSystemCd]                        CHAR (2)      NOT NULL,
    CONSTRAINT [PK_UmbrellaQuotePolicyAdditionalInterest] PRIMARY KEY CLUSTERED ([UmbrellaQuoteUnitAdditionalInterestId] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_UmbrellaQuoteAdditionalInterest_QuoteNumber_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[Quote] ([QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_UmbrellaQuoteAdditionalInterest_01]
    ON [dbo].[UmbrellaQuoteAdditionalInterest]([QuoteNbr] ASC)
    ON [POLICYCI];

