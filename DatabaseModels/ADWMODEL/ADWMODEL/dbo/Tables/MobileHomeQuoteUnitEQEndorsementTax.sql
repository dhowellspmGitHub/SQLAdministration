CREATE TABLE [dbo].[MobileHomeQuoteUnitEQEndorsementTax] (
    [QuoteNbr]                    VARCHAR (16)   NOT NULL,
    [UnitNbr]                     INT            NOT NULL,
    [EndorsementId]               INT            NOT NULL,
    [ItemNbr]                     CHAR (3)       NOT NULL,
    [MunicipalTaxCd]              CHAR (4)       NULL,
    [MunTaxRateFctr]              DECIMAL (9, 4) NULL,
    [MunTaxPremiumAmt]            DECIMAL (9, 2) NULL,
    [CountyTaxCd]                 CHAR (4)       NULL,
    [CountyTaxRateFctr]           DECIMAL (9, 4) NULL,
    [CountyTaxPremiumAmt]         DECIMAL (9, 2) NULL,
    [StateSurchargeTaxPremiumAmt] DECIMAL (9, 2) NULL,
    [UpdatedTmstmp]               DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]               CHAR (8)       NOT NULL,
    [LastActionCd]                CHAR (1)       NOT NULL,
    [SourceSystemCd]              CHAR (2)       NOT NULL,
    CONSTRAINT [PK_MobileHomeQuoteUnitEQEndorsementTax] PRIMARY KEY CLUSTERED ([QuoteNbr] ASC, [UnitNbr] ASC, [EndorsementId] ASC, [ItemNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_MobileHomeQuoteUnitEQEndorsementTax_MobileHomeQuoteUnitEQEndorsementDetail_01] FOREIGN KEY ([QuoteNbr], [UnitNbr], [EndorsementId], [ItemNbr]) REFERENCES [dbo].[MobileHomeQuoteUnitEQEndorsementDetail] ([QuoteNbr], [UnitNbr], [EndorsementId], [ItemNbr])
) ON [POLICYCD];

