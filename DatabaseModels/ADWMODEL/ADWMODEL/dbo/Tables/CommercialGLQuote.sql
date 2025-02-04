CREATE TABLE [dbo].[CommercialGLQuote] (
    [QuoteNbr]       VARCHAR (16)  NOT NULL,
    [CreatedTmstmp]  DATETIME      NOT NULL,
    [UserCreatedId]  CHAR (8)      NOT NULL,
    [UpdatedTmstmp]  DATETIME2 (7) NOT NULL,
    [UserUpdatedId]  CHAR (8)      NOT NULL,
    [LastActionCd]   CHAR (1)      NOT NULL,
    [SourceSystemCd] CHAR (2)      NOT NULL,
    CONSTRAINT [PK_CommercialGLQuote] PRIMARY KEY CLUSTERED ([QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialGLQuote_CommercialQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[CommercialQuote] ([QuoteNbr])
) ON [POLICYCD];

