CREATE TABLE [dbo].[FarmQuotePreQualificationQuestions] (
    [FarmPQQuestionId] INT           NOT NULL,
    [QuoteNbr]         VARCHAR (16)  NOT NULL,
    [QuestionCd]       VARCHAR (10)  NOT NULL,
    [AnswerInd]        CHAR (1)      NULL,
    [AnswerDesc]       VARCHAR (255) NULL,
    [UpdatedTmstmp]    DATETIME2 (7) NOT NULL,
    [UserUpdatedId]    CHAR (8)      NOT NULL,
    [LastActionCd]     CHAR (1)      NOT NULL,
    [SourceSystemCd]   CHAR (2)      NOT NULL,
    CONSTRAINT [PK_FarmQuotePreQualificationQuestions] PRIMARY KEY CLUSTERED ([FarmPQQuestionId] ASC, [QuestionCd] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmQuotePreQualificationQuestions_FarmQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[FarmQuote] ([QuoteNbr])
) ON [POLICYCD];

