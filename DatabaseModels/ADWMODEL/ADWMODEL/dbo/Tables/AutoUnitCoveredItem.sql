CREATE TABLE [dbo].[AutoUnitCoveredItem] (
    [AutoUnitCoveredItemId]  INT           NOT NULL,
    [PolicyId]               INT           NOT NULL,
    [UnitNbr]                INT           NOT NULL,
    [PolicyNbr]              VARCHAR (16)  NOT NULL,
    [SublineBusinessTypeCd]  CHAR (1)      NOT NULL,
    [ItemNbr]                CHAR (3)      NULL,
    [ItemDesc]               CHAR (150)    NULL,
    [AutoUnitEndorsementNbr] CHAR (10)     NULL,
    [ItemStatedAmt]          DECIMAL (7)   NULL,
    [UpdatedTmstmp]          DATETIME2 (7) NOT NULL,
    [UserUpdatedId]          CHAR (8)      NOT NULL,
    [LastActionCd]           CHAR (1)      NOT NULL,
    [SourceSystemCd]         CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AutoUnitCoveredItem] PRIMARY KEY CLUSTERED ([AutoUnitCoveredItemId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AutoUnitCoveredItem_AutoUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[AutoUnit] ([PolicyId], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_AutoUnitCoveredItem_01]
    ON [dbo].[AutoUnitCoveredItem]([PolicyId] ASC, [UnitNbr] ASC)
    ON [POLICYCI];

