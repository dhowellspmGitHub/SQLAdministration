CREATE TABLE [dbo].[FarmQuoteUnitDwellingSupplementalHeatingDetail] (
    [QuoteNbr]                   VARCHAR (16)  NOT NULL,
    [UnitNbr]                    INT           NOT NULL,
    [UnitTypeCd]                 CHAR (1)      NOT NULL,
    [ItemNbr]                    CHAR (3)      NOT NULL,
    [SupplementalHeatFuelTypeCd] CHAR (1)      NULL,
    [SupplementalHeatUnitTypeCd] CHAR (1)      NULL,
    [SupplementalHeatUnitCnt]    INT           NULL,
    [CreatedTmstmp]              DATETIME      NOT NULL,
    [UserCreatedId]              CHAR (8)      NOT NULL,
    [UpdatedTmstmp]              DATETIME2 (7) NOT NULL,
    [UserUpdatedId]              CHAR (8)      NOT NULL,
    [LastActionCd]               CHAR (1)      NOT NULL,
    [SourceSystemCd]             CHAR (2)      NOT NULL,
    CONSTRAINT [PK_FarmQuoteUnitDwellingSupplementalHeatingDetail] PRIMARY KEY CLUSTERED ([UnitNbr] ASC, [ItemNbr] ASC, [UnitTypeCd] ASC, [QuoteNbr] ASC),
    CONSTRAINT [FK_FarmUnitDwellingSupplementalHeatingDetail_FarmUnitDwelling_01] FOREIGN KEY ([UnitNbr], [UnitTypeCd], [QuoteNbr]) REFERENCES [dbo].[FarmQuoteUnitDwelling] ([UnitNbr], [UnitTypeCd], [QuoteNbr])
);

