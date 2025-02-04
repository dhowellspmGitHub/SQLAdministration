CREATE TABLE [dbo].[CommercialBuildingQuoteUnitAdditionalInterest] (
    [CommercialBuildingQuoteUnitAdditionalInterestId] INT           NOT NULL,
    [QuoteNbr]                                        VARCHAR (16)  NOT NULL,
    [UnitNbr]                                         INT           NOT NULL,
    [MortgageeSequenceNbr]                            CHAR (3)      NULL,
    [MortgageeLoanNbr]                                CHAR (35)     NULL,
    [PCAdditionalInterestNbr]                         CHAR (10)     NULL,
    [InterestDesc]                                    VARCHAR (255) NULL,
    [ToTheAttentionOfNm]                              VARCHAR (50)  NULL,
    [EscrowInd]                                       CHAR (1)      NULL,
    [CreatedTmstmp]                                   DATETIME      NOT NULL,
    [UserCreatedId]                                   CHAR (8)      NOT NULL,
    [UpdatedTmstmp]                                   DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                                   CHAR (8)      NOT NULL,
    [LastActionCd]                                    CHAR (1)      NOT NULL,
    [SourceSystemCd]                                  CHAR (2)      NOT NULL,
    CONSTRAINT [PK_CommercialBuildingQuoteUnitAdditionalInterest] PRIMARY KEY CLUSTERED ([CommercialBuildingQuoteUnitAdditionalInterestId] ASC, [QuoteNbr] ASC, [UnitNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialBuildingQuoteUnitAdditionalInterest_CommercialBuildingQuoteUnit_01] FOREIGN KEY ([UnitNbr], [QuoteNbr]) REFERENCES [dbo].[CommercialBuildingQuoteUnit] ([UnitNbr], [QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialBuildingQuoteUnitAdditionalInterest_01]
    ON [dbo].[CommercialBuildingQuoteUnitAdditionalInterest]([QuoteNbr] ASC)
    ON [POLICYCI];

