CREATE TABLE [dbo].[AutoQuoteUnitCoveredItem] (
    [AutoQuoteUnitCoveredItemId]  INT           NOT NULL,
    [QuoteNbr]                    VARCHAR (16)  NOT NULL,
    [QuoteUnitNbr]                INT           NOT NULL,
    [SublineBusinessTypeCd]       CHAR (1)      NOT NULL,
    [ItemNbr]                     CHAR (3)      NOT NULL,
    [ItemDesc]                    CHAR (150)    NULL,
    [AutoQuoteUnitEndorsementNbr] CHAR (10)     NULL,
    [ItemStatedAmt]               DECIMAL (7)   NULL,
    [UpdatedTmstmp]               DATETIME2 (7) NOT NULL,
    [UserUpdatedId]               CHAR (8)      NOT NULL,
    [LastActionCd]                CHAR (1)      NOT NULL,
    [SourceSystemCd]              CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AutoQuoteUnitCoveredItem] PRIMARY KEY CLUSTERED ([AutoQuoteUnitCoveredItemId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AutoQuoteUnitCoveredItem_AutoQuoteUnit_01] FOREIGN KEY ([QuoteNbr], [QuoteUnitNbr]) REFERENCES [dbo].[AutoQuoteUnit] ([QuoteNbr], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_AutoQuoteUnitCoveredItem_01]
    ON [dbo].[AutoQuoteUnitCoveredItem]([QuoteNbr] ASC)
    ON [POLICYCI];

