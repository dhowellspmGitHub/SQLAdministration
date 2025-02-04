CREATE TABLE [dbo].[BoatQuote] (
    [QuoteNbr]             VARCHAR (16)  NOT NULL,
    [ComputerRatedLevelCd] CHAR (1)      NULL,
    [UserUpdatedId]        CHAR (8)      NOT NULL,
    [UpdatedTmstmp]        DATETIME2 (7) NOT NULL,
    [LastActionCd]         CHAR (1)      NOT NULL,
    [SourceSystemCd]       CHAR (2)      NOT NULL,
    CONSTRAINT [PK_BoatQuote] PRIMARY KEY CLUSTERED ([QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_BoatQuote_Quote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[Quote] ([QuoteNbr])
) ON [POLICYCD];

