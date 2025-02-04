CREATE TABLE [dbo].[HomeQuoteUnitRoofDetails] (
    [RoofNbr]                INT           NOT NULL,
    [UnitNbr]                INT           NOT NULL,
    [QuoteNbr]               VARCHAR (16)  NOT NULL,
    [RoofPitchCd]            CHAR (2)      NULL,
    [RoofDesc]               VARCHAR (255) NULL,
    [RoofShapeCd]            CHAR (2)      NULL,
    [RoofTypeCd]             CHAR (2)      NULL,
    [RoofConstructionYearDt] CHAR (4)      NULL,
    [RoofReplacedYearDt]     CHAR (4)      NULL,
    [ExposureToTreesCd]      CHAR (2)      NULL,
    [UpdatedTmstmp]          DATETIME2 (7) NOT NULL,
    [UserUpdatedId]          CHAR (8)      NOT NULL,
    [LastActionCd]           CHAR (1)      NOT NULL,
    [SourceSystemCd]         CHAR (2)      NOT NULL,
    CONSTRAINT [PK_HomeQuoteUnitRoofDetails] PRIMARY KEY CLUSTERED ([QuoteNbr] ASC, [UnitNbr] ASC, [RoofNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_HomeQuoteUnitRoofDetails_HomeQuoteUnit_01] FOREIGN KEY ([QuoteNbr], [UnitNbr]) REFERENCES [dbo].[HomeQuoteUnit] ([QuoteNbr], [UnitNbr])
) ON [POLICYCD];

