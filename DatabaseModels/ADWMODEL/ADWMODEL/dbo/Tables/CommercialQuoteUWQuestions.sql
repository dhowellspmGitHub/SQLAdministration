CREATE TABLE [dbo].[CommercialQuoteUWQuestions] (
    [CommercialQuoteUWQuestionId] INT           NOT NULL,
    [QuestionCd]                  VARCHAR (10)  NOT NULL,
    [QuoteNbr]                    VARCHAR (16)  NOT NULL,
    [AnswerInd]                   CHAR (1)      NULL,
    [Answer1Desc]                 VARCHAR (255) NULL,
    [Answer2Desc]                 VARCHAR (255) NULL,
    [UpdatedTmstmp]               DATETIME2 (7) NOT NULL,
    [UserUpdatedId]               CHAR (8)      NOT NULL,
    [LastActionCd]                CHAR (1)      NOT NULL,
    [SourceSystemCd]              CHAR (2)      NOT NULL,
    CONSTRAINT [PK_CommercialQuoteUWQuestions] PRIMARY KEY CLUSTERED ([CommercialQuoteUWQuestionId] ASC, [QuestionCd] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialQuoteUWQuestions_CommercialQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[CommercialQuote] ([QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialQuoteUWQuestions_01]
    ON [dbo].[CommercialQuoteUWQuestions]([QuoteNbr] ASC)
    ON [POLICYCI];

