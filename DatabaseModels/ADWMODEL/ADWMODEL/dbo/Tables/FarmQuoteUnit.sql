CREATE TABLE [dbo].[FarmQuoteUnit] (
    [QuoteNbr]                 VARCHAR (16)  NOT NULL,
    [UnitNbr]                  INT           NOT NULL,
    [UnitTypeCd]               CHAR (1)      NOT NULL,
    [LocationID]               BIGINT        NULL,
    [FarmAcresNbr]             INT           NULL,
    [MineSubsidenceCoverageCd] CHAR (1)      NULL,
    [UnitAddedDt]              DATE          NULL,
    [UnitInceptionDt]          DATE          NULL,
    [TerritoryCd]              CHAR (1)      NULL,
    [UpdatedTmstmp]            DATETIME2 (7) NOT NULL,
    [UserUpdatedId]            CHAR (8)      NOT NULL,
    [LastActionCd]             CHAR (1)      NOT NULL,
    [SourceSystemCd]           CHAR (2)      NOT NULL,
    CONSTRAINT [PK_FarmQuoteUnit] PRIMARY KEY CLUSTERED ([UnitNbr] ASC, [UnitTypeCd] ASC, [QuoteNbr] ASC),
    CONSTRAINT [FK_FarmUnitQuote_FarmQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[FarmQuote] ([QuoteNbr]),
    CONSTRAINT [FK_FarmUnitQuote_Location_01] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[Location] ([LocationID])
);

