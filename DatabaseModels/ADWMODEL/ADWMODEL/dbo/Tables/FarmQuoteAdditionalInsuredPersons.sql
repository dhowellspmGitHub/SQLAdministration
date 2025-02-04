CREATE TABLE [dbo].[FarmQuoteAdditionalInsuredPersons] (
    [QuoteNbr]                   VARCHAR (16)  NOT NULL,
    [AdditionalInsuredNbr]       INT           NOT NULL,
    [AdditionalInsuredPersonsNm] VARCHAR (50)  NULL,
    [UpdatedTmstmp]              DATETIME2 (7) NOT NULL,
    [UserUpdatedId]              CHAR (8)      NOT NULL,
    [LastActionCd]               CHAR (1)      NOT NULL,
    [SourceSystemCd]             CHAR (2)      NOT NULL,
    CONSTRAINT [PK_FarmQuoteAdditionalInsuredPersons] PRIMARY KEY CLUSTERED ([AdditionalInsuredNbr] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmQuoteAdditionalInsuredPersons_FarmQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[FarmQuote] ([QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FarmQuoteAdditionalInsuredPersons_01]
    ON [dbo].[FarmQuoteAdditionalInsuredPersons]([QuoteNbr] ASC)
    ON [POLICYCI];

