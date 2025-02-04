CREATE TABLE [dbo].[FarmUnitPremium] (
    [PolicyId]                   INT            NOT NULL,
    [UnitNbr]                    INT            NOT NULL,
    [UnitTypeCd]                 CHAR (1)       NOT NULL,
    [PolicyNbr]                  VARCHAR (16)   NOT NULL,
    [SourceSystemDisplayUnitNbr] INT            NULL,
    [CashUnitNbr]                CHAR (3)       NULL,
    [BasicPolicyPremiumAmt]      DECIMAL (9, 2) NULL,
    [TotalEndorsementPremiumAmt] DECIMAL (9, 2) NULL,
    [TotalUnitTaxAmt]            DECIMAL (9, 2) NULL,
    [TotalUnitPremiumAmt]        DECIMAL (9, 2) NULL,
    [TotalDiscountAmt]           DECIMAL (9, 2) NULL,
    [TotalCoveragePremiumAmt]    DECIMAL (9, 2) NULL,
    [EQTotalPremiumAmt]          DECIMAL (9, 2) NULL,
    [EQMunicipalPremiumTaxAmt]   DECIMAL (9, 2) NULL,
    [EQCountyPremiumTaxAmt]      DECIMAL (9, 2) NULL,
    [EQTotalTaxAmt]              DECIMAL (9, 2) NULL,
    [TaxAmt]                     DECIMAL (9, 2) NULL,
    [EQTaxAmt]                   DECIMAL (9, 2) NULL,
    [SurchargeTaxAmt]            DECIMAL (9, 2) NULL,
    [EQSurchargeTaxAmt]          DECIMAL (9, 2) NULL,
    [EQSurplusTaxAmt]            DECIMAL (9, 2) NULL,
    [CreatedTmstmp]              DATETIME       NOT NULL,
    [UserCreatedId]              CHAR (8)       NOT NULL,
    [UpdatedTmstmp]              DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]              CHAR (8)       NOT NULL,
    [LastActionCd]               CHAR (1)       NOT NULL,
    [SourceSystemCd]             CHAR (2)       NOT NULL,
    CONSTRAINT [PK_FarmUnitPremium] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [UnitNbr] ASC, [UnitTypeCd] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmUnitPremium_FarmUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr], [UnitTypeCd]) REFERENCES [dbo].[FarmUnit] ([PolicyId], [UnitNbr], [UnitTypeCd])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FarmUnitPremium_01]
    ON [dbo].[FarmUnitPremium]([PolicyId] ASC)
    ON [POLICYCI];

