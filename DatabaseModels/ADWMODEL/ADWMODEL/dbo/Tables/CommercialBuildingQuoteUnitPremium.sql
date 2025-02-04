CREATE TABLE [dbo].[CommercialBuildingQuoteUnitPremium] (
    [QuoteNbr]                   VARCHAR (16)   NOT NULL,
    [UnitNbr]                    INT            NOT NULL,
    [CashUnitNbr]                CHAR (3)       NULL,
    [BasicPolicyPremiumAmt]      DECIMAL (9, 2) NOT NULL,
    [TotalEndorsementPremiumAmt] DECIMAL (9, 2) NOT NULL,
    [TotalPolicyDiscountAmt]     DECIMAL (9, 2) NOT NULL,
    [TotalUnitTaxAmt]            DECIMAL (9, 2) NOT NULL,
    [TotalUnitPremiumAmt]        DECIMAL (9, 2) NOT NULL,
    [EQTotalPremiumAmt]          DECIMAL (9, 2) NOT NULL,
    [EqTotalTaxAmt]              DECIMAL (9, 2) NOT NULL,
    [SurchargeTaxAmt]            DECIMAL (9, 2) NULL,
    [EQTaxAmt]                   DECIMAL (9, 2) NOT NULL,
    [EQSurchargeTaxAmt]          DECIMAL (9, 2) NULL,
    [EQProratedTaxAmt]           DECIMAL (9, 2) NOT NULL,
    [EQProratedSurchargeTaxAmt]  DECIMAL (9, 2) NULL,
    [EQSurplusTaxAmt]            DECIMAL (9, 2) NULL,
    [CreatedTmstmp]              DATETIME       NOT NULL,
    [UserCreatedId]              CHAR (8)       NOT NULL,
    [UpdatedTmstmp]              DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]              CHAR (8)       NOT NULL,
    [LastActionCd]               CHAR (1)       NOT NULL,
    [SourceSystemCd]             CHAR (2)       NOT NULL,
    CONSTRAINT [PK_CommercialBuildingQuoteUnitPremium] PRIMARY KEY CLUSTERED ([UnitNbr] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialBuildingQuoteUnitPremium_CommercialBuildingQuoteUnit_01] FOREIGN KEY ([UnitNbr], [QuoteNbr]) REFERENCES [dbo].[CommercialBuildingQuoteUnit] ([UnitNbr], [QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialBuildingQuoteUnitPremium_01]
    ON [dbo].[CommercialBuildingQuoteUnitPremium]([QuoteNbr] ASC)
    ON [POLICYCI];

