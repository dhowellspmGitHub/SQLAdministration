CREATE TABLE [dbo].[FireUnitEQEndorsementTax] (
    [PolicyId]                    INT            NOT NULL,
    [UnitNbr]                     INT            NOT NULL,
    [EndorsementId]               INT            NOT NULL,
    [ItemNbr]                     CHAR (3)       NOT NULL,
    [PolicyNbr]                   VARCHAR (16)   NOT NULL,
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
    CONSTRAINT [PK_FireUnitEQEndorsementTax] PRIMARY KEY CLUSTERED ([ItemNbr] ASC, [PolicyId] ASC, [UnitNbr] ASC, [EndorsementId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FireUnitEQEndorsementTax_FireUnitEQEndorsementDetail_01] FOREIGN KEY ([EndorsementId], [ItemNbr], [UnitNbr], [PolicyId]) REFERENCES [dbo].[FireUnitEQEndorsementDetail] ([EndorsementId], [ItemNbr], [UnitNbr], [PolicyId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FireUnitEQEndorsementTax_01]
    ON [dbo].[FireUnitEQEndorsementTax]([PolicyId] ASC)
    ON [POLICYCI];

