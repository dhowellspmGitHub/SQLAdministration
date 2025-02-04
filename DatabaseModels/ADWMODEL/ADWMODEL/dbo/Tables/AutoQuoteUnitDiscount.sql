CREATE TABLE [dbo].[AutoQuoteUnitDiscount] (
    [AutoQuoteUnitDiscountId] INT            NOT NULL,
    [QuoteNbr]                VARCHAR (16)   NOT NULL,
    [QuoteUnitNbr]            INT            NOT NULL,
    [SublineBusinessTypeCd]   CHAR (1)       NOT NULL,
    [SavingsDiscountTypeCd]   CHAR (2)       NULL,
    [SavingsDiscountAmt]      DECIMAL (9, 2) NULL,
    [UpdatedTmstmp]           DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]           CHAR (8)       NOT NULL,
    [LastActionCd]            CHAR (1)       NOT NULL,
    [SourceSystemCd]          CHAR (2)       NOT NULL,
    CONSTRAINT [PK_AutoQuoteUnitDiscount] PRIMARY KEY CLUSTERED ([AutoQuoteUnitDiscountId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AutoQuoteUnitDiscount_AutoQuoteUnit_01] FOREIGN KEY ([QuoteNbr], [QuoteUnitNbr]) REFERENCES [dbo].[AutoQuoteUnit] ([QuoteNbr], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_AutoQuoteUnitDiscount_01]
    ON [dbo].[AutoQuoteUnitDiscount]([QuoteNbr] ASC)
    ON [POLICYCI];

