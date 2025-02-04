CREATE TABLE [dbo].[AutoQuoteUnitPremium] (
    [QuoteNbr]                    VARCHAR (16)   NOT NULL,
    [QuoteUnitNbr]                INT            NOT NULL,
    [SublineBusinessTypeCd]       CHAR (1)       NOT NULL,
    [BasicUnitPremiumAmt]         DECIMAL (9, 2) NULL,
    [TotalUnitPremiumAmt]         DECIMAL (9, 2) NULL,
    [TotalUnitCoveragePremiumAmt] DECIMAL (9, 2) NULL,
    [TotalEndorsementPremiumAmt]  DECIMAL (9, 2) NULL,
    [TotalUnitDiscountSavingsAmt] DECIMAL (9, 2) NULL,
    [TotalTaxAmt]                 DECIMAL (9, 2) NULL,
    [UpdatedTmstmp]               DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]               CHAR (8)       NOT NULL,
    [LastActionCd]                CHAR (1)       NOT NULL,
    [SourceSystemCd]              CHAR (2)       NOT NULL,
    CONSTRAINT [PK_AutoQuoteUnitPremium] PRIMARY KEY CLUSTERED ([QuoteNbr] ASC, [QuoteUnitNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AutoQuoteUnitPremium_AutoQuoteUnit_01] FOREIGN KEY ([QuoteNbr], [QuoteUnitNbr]) REFERENCES [dbo].[AutoQuoteUnit] ([QuoteNbr], [UnitNbr])
) ON [POLICYCD];

