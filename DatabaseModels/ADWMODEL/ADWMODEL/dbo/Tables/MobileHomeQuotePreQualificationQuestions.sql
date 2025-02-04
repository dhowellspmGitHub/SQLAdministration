CREATE TABLE [dbo].[MobileHomeQuotePreQualificationQuestions] (
    [MHPQQuestionId] INT           NOT NULL,
    [QuoteNbr]       VARCHAR (16)  NOT NULL,
    [QuestionCd]     VARCHAR (10)  NOT NULL,
    [AnswerInd]      CHAR (1)      NULL,
    [AnswerDesc]     VARCHAR (255) NULL,
    [UpdatedTmstmp]  DATETIME2 (7) NOT NULL,
    [UserUpdatedId]  CHAR (8)      NOT NULL,
    [LastActionCd]   CHAR (1)      NOT NULL,
    [SourceSystemCd] CHAR (2)      NOT NULL,
    CONSTRAINT [PK_MobileHomeQuotePreQualificationQuestions] PRIMARY KEY NONCLUSTERED ([QuoteNbr] ASC, [QuestionCd] ASC, [MHPQQuestionId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_MobileHomeQuotePreQualificationQuestions_MobileHomeQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[MobileHomeQuote] ([QuoteNbr]),
    CONSTRAINT [FK_MobileHomeQuotePreQualificationQuestions_PolicyPreQualificationQuoteQuestions_01] FOREIGN KEY ([QuestionCd]) REFERENCES [dbo].[PolicyPreQualificationQuoteQuestions] ([QuestionCd])
) ON [POLICYCD];

