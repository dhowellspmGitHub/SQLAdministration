CREATE TABLE [dbo].[FarmQuoteUnitDwellingRoofDetail] (
    [QuoteNbr]               VARCHAR (16)  NOT NULL,
    [UnitNbr]                INT           NOT NULL,
    [UnitTypeCd]             CHAR (1)      NOT NULL,
    [RoofPitchCd]            CHAR (2)      NULL,
    [RoofShapeCd]            CHAR (2)      NULL,
    [RoofTypeCd]             CHAR (2)      NULL,
    [RoofConstructionYearDt] CHAR (4)      NULL,
    [ExposureToTreesCd]      CHAR (2)      NULL,
    [CreatedTmstmp]          DATETIME      NOT NULL,
    [UserCreatedId]          CHAR (8)      NOT NULL,
    [UpdatedTmstmp]          DATETIME2 (7) NOT NULL,
    [UserUpdatedId]          CHAR (8)      NOT NULL,
    [LastActionCd]           CHAR (1)      NOT NULL,
    [SourceSystemCd]         CHAR (2)      NOT NULL,
    CONSTRAINT [PK_FarmQuoteUnitDwellingRoofDetail] PRIMARY KEY CLUSTERED ([UnitNbr] ASC, [UnitTypeCd] ASC, [QuoteNbr] ASC),
    CONSTRAINT [FK_FarmUnitDwellingRoofDetail_FarmUnitDwelling_01_1] FOREIGN KEY ([UnitNbr], [UnitTypeCd], [QuoteNbr]) REFERENCES [dbo].[FarmQuoteUnitDwelling] ([UnitNbr], [UnitTypeCd], [QuoteNbr])
);

