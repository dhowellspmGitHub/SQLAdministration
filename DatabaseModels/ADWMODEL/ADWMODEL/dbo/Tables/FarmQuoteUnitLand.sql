CREATE TABLE [dbo].[FarmQuoteUnitLand] (
    [QuoteNbr]                 VARCHAR (16)   NOT NULL,
    [UnitNbr]                  INT            NOT NULL,
    [UnitTypeCd]               CHAR (1)       NOT NULL,
    [LocationID]               BIGINT         NULL,
    [AcersCnt]                 DECIMAL (9, 2) NULL,
    [AdditionalDesc]           VARCHAR (255)  NULL,
    [OwnOrLeaseDesc]           VARCHAR (255)  NULL,
    [AdjoinedToDesc]           VARCHAR (255)  NULL,
    [LiabilityLimitAmt]        DECIMAL (9)    NULL,
    [MineSubsidenceCoverageCd] CHAR (1)       NULL,
    [CreatedTmstmp]            DATETIME       NOT NULL,
    [UserCreatedId]            CHAR (8)       NOT NULL,
    [UpdatedTmstmp]            DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]            CHAR (8)       NOT NULL,
    [LastActionCd]             CHAR (1)       NOT NULL,
    [SourceSystemCd]           CHAR (2)       NOT NULL,
    CONSTRAINT [PK_FarmQuoteUnitLand] PRIMARY KEY CLUSTERED ([UnitNbr] ASC, [UnitTypeCd] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmUnitQuoteLand_FarmUnitQuote_01] FOREIGN KEY ([UnitNbr], [UnitTypeCd], [QuoteNbr]) REFERENCES [dbo].[FarmQuoteUnit] ([UnitNbr], [UnitTypeCd], [QuoteNbr]),
    CONSTRAINT [FK_FarmUnitQuoteLand_Location_01] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[Location] ([LocationID])
) ON [POLICYCD];

