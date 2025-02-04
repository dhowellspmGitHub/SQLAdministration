CREATE TABLE [dbo].[UmbrellaQuoteRiskInformation] (
    [QuoteNbr]           VARCHAR (16)   NOT NULL,
    [RateFieldNm]        VARCHAR (50)   NOT NULL,
    [RateFieldCnt]       INT            NULL,
    [PremiumAmt]         DECIMAL (9, 2) NULL,
    [ProratedPremiumAmt] DECIMAL (9, 2) NULL,
    [CreatedTmstmp]      DATETIME       NOT NULL,
    [UserCreatedId]      CHAR (8)       NOT NULL,
    [UpdatedTmstmp]      DATETIME2 (7)  NOT NULL,
    [LastActionCd]       CHAR (1)       NOT NULL,
    [SourceSystemCd]     CHAR (2)       NOT NULL,
    CONSTRAINT [PK_UmbrellaQuoteRiskInformation] PRIMARY KEY CLUSTERED ([QuoteNbr] ASC, [RateFieldNm] ASC) ON [POLICYCD],
    CONSTRAINT [FK_UmbrellaQuoteRiskInformation_UmbrellaQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[UmbrellaQuote] ([QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_UmbrellaQuoteRiskInformation_01]
    ON [dbo].[UmbrellaQuoteRiskInformation]([QuoteNbr] ASC)
    ON [POLICYCI];

