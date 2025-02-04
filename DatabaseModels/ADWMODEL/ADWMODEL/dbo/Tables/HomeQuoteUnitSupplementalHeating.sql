CREATE TABLE [dbo].[HomeQuoteUnitSupplementalHeating] (
    [ItemNbr]                    CHAR (3)      NOT NULL,
    [UnitNbr]                    INT           NOT NULL,
    [QuoteNbr]                   VARCHAR (16)  NOT NULL,
    [SupplementalHeatFuelTypeCd] CHAR (1)      NULL,
    [SupplementalHeatUnitTypeCd] CHAR (1)      NULL,
    [SupplementalHeatUnitCnt]    INT           NULL,
    [UpdatedTmstmp]              DATETIME2 (7) NOT NULL,
    [UserUpdatedId]              CHAR (8)      NOT NULL,
    [LastActionCd]               CHAR (1)      NOT NULL,
    [SourceSystemCd]             CHAR (2)      NOT NULL,
    CONSTRAINT [PK_HomeQuoteUnitSupplementalHeating] PRIMARY KEY CLUSTERED ([QuoteNbr] ASC, [UnitNbr] ASC, [ItemNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_HomeQuoteUnitSupplementalHeating_HomeQuoteUnit_01] FOREIGN KEY ([QuoteNbr], [UnitNbr]) REFERENCES [dbo].[HomeQuoteUnit] ([QuoteNbr], [UnitNbr])
) ON [POLICYCD];

