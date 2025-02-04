CREATE TABLE [dbo].[CommercialIMQuote] (
    [QuoteNbr]                 VARCHAR (16)    NOT NULL,
    [IMPartCoverageTypeCd]     VARCHAR (50)    NOT NULL,
    [IMUnitNbr]                INT             NULL,
    [PartTypeDesc]             VARCHAR (200)   NULL,
    [MiscellaneousItemDesc]    VARCHAR (255)   NULL,
    [CoveragePropertyDesc]     VARCHAR (255)   NULL,
    [RiskTypeCd]               CHAR (10)       NULL,
    [RefigerationBreakdownInd] CHAR (1)        NULL,
    [UnattendedTheftInd]       CHAR (1)        NULL,
    [DeductibleAmt]            DECIMAL (18, 2) NULL,
    [StainGlassExcessInd]      CHAR (1)        NULL,
    [TotalCoverageLimitAmt]    DECIMAL (9)     NULL,
    [LimitAmt]                 DECIMAL (9)     NULL,
    [CreatedTmstmp]            DATETIME        NOT NULL,
    [UserCreatedId]            CHAR (8)        NOT NULL,
    [UpdatedTmstmp]            DATETIME2 (7)   NOT NULL,
    [UserUpdatedId]            CHAR (8)        NOT NULL,
    [LastActionCd]             CHAR (1)        NOT NULL,
    [SourceSystemCd]           CHAR (2)        NOT NULL,
    CONSTRAINT [PK_CommercialIMQuote] PRIMARY KEY CLUSTERED ([IMPartCoverageTypeCd] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialIMQuote_CommercialQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[CommercialQuote] ([QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialIMQuote_01]
    ON [dbo].[CommercialIMQuote]([QuoteNbr] ASC)
    ON [POLICYCI];

