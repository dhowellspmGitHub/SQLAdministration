CREATE TABLE [dbo].[CommercialBuildingQuoteUnitClassificationAdditionalInterest] (
    [CommercialBuildingQuoteUnitClassificationAdditionalInterestId] INT           NOT NULL,
    [UnitNbr]                                                       INT           NULL,
    [ClassificationNbr]                                             INT           NULL,
    [QuoteNbr]                                                      VARCHAR (16)  NULL,
    [MortgageeSequenceNbr]                                          CHAR (3)      NULL,
    [MortgageeLoanNbr]                                              CHAR (35)     NULL,
    [PCAdditionalInterestNbr]                                       CHAR (10)     NULL,
    [InterestDesc]                                                  VARCHAR (255) NULL,
    [ToTheAttentionOfNm]                                            VARCHAR (50)  NULL,
    [EscrowInd]                                                     CHAR (1)      NULL,
    [CreatedTmstmp]                                                 DATETIME      NOT NULL,
    [UserCreatedId]                                                 CHAR (8)      NOT NULL,
    [UpdatedTmstmp]                                                 DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                                                 CHAR (8)      NOT NULL,
    [LastActionCd]                                                  CHAR (1)      NOT NULL,
    [SourceSystemCd]                                                CHAR (2)      NOT NULL,
    CONSTRAINT [PK_CommercialBuildingQuoteUnitClassificationAdditionalInterest] PRIMARY KEY CLUSTERED ([CommercialBuildingQuoteUnitClassificationAdditionalInterestId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialBuildingQuoteUnitClassificationAdditionalInterest_CommercialBuildingQuoteUnitClassification_01] FOREIGN KEY ([ClassificationNbr], [UnitNbr], [QuoteNbr]) REFERENCES [dbo].[CommercialBuildingQuoteUnitClassification] ([ClassificationNbr], [UnitNbr], [QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialBuildingQuoteUnitClassificationAdditionalInterest_01]
    ON [dbo].[CommercialBuildingQuoteUnitClassificationAdditionalInterest]([QuoteNbr] ASC)
    ON [POLICYCI];

