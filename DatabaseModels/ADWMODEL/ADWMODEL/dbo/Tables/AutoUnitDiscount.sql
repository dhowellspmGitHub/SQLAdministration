CREATE TABLE [dbo].[AutoUnitDiscount] (
    [AutoUnitDiscountId]    INT            NOT NULL,
    [PolicyId]              INT            NOT NULL,
    [UnitNbr]               INT            NOT NULL,
    [PolicyNbr]             VARCHAR (16)   NOT NULL,
    [SublineBusinessTypeCd] CHAR (1)       NOT NULL,
    [SavingsDiscountTypeCd] CHAR (2)       NULL,
    [SavingsDiscountAmt]    DECIMAL (9, 2) NULL,
    [UpdatedTmstmp]         DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]         CHAR (8)       NOT NULL,
    [LastActionCd]          CHAR (1)       NOT NULL,
    [SourceSystemCd]        CHAR (2)       NOT NULL,
    CONSTRAINT [PK_AutoUnitDiscount] PRIMARY KEY CLUSTERED ([AutoUnitDiscountId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AutoUnitDiscount_AutoUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[AutoUnit] ([PolicyId], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_AutoUnitDiscount_01]
    ON [dbo].[AutoUnitDiscount]([PolicyId] ASC, [UnitNbr] ASC)
    ON [POLICYCI];

