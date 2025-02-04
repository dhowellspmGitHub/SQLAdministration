CREATE TABLE [dbo].[AutoUnitPremium] (
    [PolicyId]                       INT            NOT NULL,
    [UnitNbr]                        INT            NOT NULL,
    [PolicyNbr]                      VARCHAR (16)   NOT NULL,
    [SublineBusinessTypeCd]          CHAR (1)       NOT NULL,
    [BasicUnitPremiumAmt]            DECIMAL (9, 2) NULL,
    [TotalUnitPremiumAmt]            DECIMAL (9, 2) NULL,
    [TotalUnitCoveragePremiumAmt]    DECIMAL (9, 2) NULL,
    [TotalUnitEndorsementPremiumAmt] DECIMAL (9, 2) NULL,
    [TotalUnitDiscountSavingsAmt]    DECIMAL (9, 2) NULL,
    [TotalTaxAmt]                    DECIMAL (9, 2) NULL,
    [UpdatedTmstmp]                  DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]                  CHAR (8)       NOT NULL,
    [LastActionCd]                   CHAR (1)       NOT NULL,
    [SourceSystemCd]                 CHAR (2)       NOT NULL,
    CONSTRAINT [PK_AutoUnitPremium] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [UnitNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AutoUnitPremium_AutoUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[AutoUnit] ([PolicyId], [UnitNbr])
) ON [POLICYCD];

