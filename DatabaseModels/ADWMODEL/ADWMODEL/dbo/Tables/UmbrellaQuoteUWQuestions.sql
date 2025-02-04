CREATE TABLE [dbo].[UmbrellaQuoteUWQuestions] (
    [UmbrellaQuoteUWQuestionId] INT           NOT NULL,
    [QuestionCd]                VARCHAR (10)  NOT NULL,
    [QuoteNbr]                  VARCHAR (16)  NULL,
    [AnswerInd]                 BIT           NOT NULL,
    [AnswerDesc1]               VARCHAR (255) NULL,
    [AnswerDesc2]               VARCHAR (255) NULL,
    [PatternTxt]                VARCHAR (64)  NULL,
    [UpdatedTmstmp]             DATETIME2 (7) NULL,
    [UserUpdatedId]             CHAR (8)      NULL,
    [LastActionCd]              CHAR (1)      NULL,
    [SourceSystem]              CHAR (2)      NULL,
    CONSTRAINT [PK_UmbrellaQuoteUWQuestions] PRIMARY KEY CLUSTERED ([UmbrellaQuoteUWQuestionId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_UmbrellaQuoteUWQuestions_UmbrellaQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[UmbrellaQuote] ([QuoteNbr])
) ON [POLICYCD];

