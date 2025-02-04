CREATE TABLE [dbo].[CommercialBuildingQuoteUnitSupplementalHeating] (
    [QuoteNbr]                   VARCHAR (16)  NOT NULL,
    [UnitNbr]                    INT           NOT NULL,
    [ItemNbr]                    CHAR (3)      NOT NULL,
    [SupplementalHeatFuelTypeCd] CHAR (1)      NULL,
    [SupplementalHeatUnitTypeCd] CHAR (1)      NULL,
    [SupplementalHeatUnitCnt]    INT           NULL,
    [UpdatedTmstmp]              DATETIME2 (7) NOT NULL,
    [UserUpdatedId]              CHAR (8)      NOT NULL,
    [LastActionCd]               CHAR (1)      NOT NULL,
    [SourceSystemCd]             CHAR (2)      NOT NULL,
    CONSTRAINT [PK_CommercialBuildingQuoteUnitSupplementalHeating] PRIMARY KEY CLUSTERED ([ItemNbr] ASC, [QuoteNbr] ASC, [UnitNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialBuildingQuoteUnitSupplementalHeating_CommercialBuildingQuoteUnit_01] FOREIGN KEY ([UnitNbr], [QuoteNbr]) REFERENCES [dbo].[CommercialBuildingQuoteUnit] ([UnitNbr], [QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialBuildingQuoteUnitSupplementalHeating_01]
    ON [dbo].[CommercialBuildingQuoteUnitSupplementalHeating]([QuoteNbr] ASC)
    ON [POLICYCI];

