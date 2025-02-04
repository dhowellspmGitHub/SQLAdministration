CREATE TABLE [dbo].[MobileHomeQuoteUnitAdditionalDetails] (
    [MHQuoteUnitAdditionalDetailsId] INT           NOT NULL,
    [QuoteNbr]                       VARCHAR (16)  NOT NULL,
    [UnitNbr]                        INT           NOT NULL,
    [ItemNbr]                        CHAR (3)      NOT NULL,
    [ItemDesc]                       VARCHAR (150) NULL,
    [CoverageCd]                     CHAR (3)      NULL,
    [CoverageLimitAmt]               DECIMAL (9)   NULL,
    [MineSubsidenceInd]              CHAR (1)      NULL,
    [UpdatedTmstmp]                  DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                  CHAR (8)      NOT NULL,
    [LastActionCd]                   CHAR (1)      NOT NULL,
    [SourceSystemCd]                 CHAR (2)      NOT NULL,
    CONSTRAINT [PK_MobileHomeQuoteUnitAdditionalDetails] PRIMARY KEY CLUSTERED ([MHQuoteUnitAdditionalDetailsId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_MobileHomeQuoteUnitAdditionalDetails_MobileHomeQuoteUnit_01] FOREIGN KEY ([QuoteNbr], [UnitNbr]) REFERENCES [dbo].[MobileHomeQuoteUnit] ([QuoteNbr], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_MobileHomeQuoteUnitAdditionalDetails_01]
    ON [dbo].[MobileHomeQuoteUnitAdditionalDetails]([QuoteNbr] ASC)
    ON [POLICYCI];

