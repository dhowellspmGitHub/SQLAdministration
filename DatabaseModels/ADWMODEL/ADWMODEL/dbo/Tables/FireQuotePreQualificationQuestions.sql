CREATE TABLE [dbo].[FireQuotePreQualificationQuestions] (
    [QuoteNbr]         VARCHAR (16)  NOT NULL,
    [FirePQQuestionId] INT           NOT NULL,
    [QuestionCd]       VARCHAR (10)  NOT NULL,
    [AnswerInd]        CHAR (1)      NULL,
    [AnswerDesc]       VARCHAR (255) NULL,
    [UpdatedTmstmp]    DATETIME2 (7) NOT NULL,
    [UserUpdatedId]    CHAR (8)      NOT NULL,
    [LastActionCd]     CHAR (1)      NOT NULL,
    [SourceSystemCd]   CHAR (2)      NOT NULL,
    CONSTRAINT [PK_FireQuotePreQualificationQuestions] PRIMARY KEY NONCLUSTERED ([QuestionCd] ASC, [FirePQQuestionId] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FireQuotePreQualificationQuestions_FireQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[FireQuote] ([QuoteNbr]),
    CONSTRAINT [FK_FireQuotePreQualificationQuestions_PolicyPreQualificationQuoteQuestions_01] FOREIGN KEY ([QuestionCd]) REFERENCES [dbo].[PolicyPreQualificationQuoteQuestions] ([QuestionCd])
) ON [POLICYCD];

