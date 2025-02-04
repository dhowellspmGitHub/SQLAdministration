CREATE TABLE [dbo].[FireQuoteUnitRoofDetails] (
    [QuoteNbr]               VARCHAR (16)  NOT NULL,
    [UnitNbr]                INT           NOT NULL,
    [RoofNbr]                INT           NOT NULL,
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
    CONSTRAINT [PK_FireQuoteUnitRoofDetails] PRIMARY KEY CLUSTERED ([RoofNbr] ASC, [UnitNbr] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FireQuoteUnitRoofDetails_FireQuoteUnit_01] FOREIGN KEY ([UnitNbr], [QuoteNbr]) REFERENCES [dbo].[FireQuoteUnit] ([UnitNbr], [QuoteNbr])
) ON [POLICYCD];

