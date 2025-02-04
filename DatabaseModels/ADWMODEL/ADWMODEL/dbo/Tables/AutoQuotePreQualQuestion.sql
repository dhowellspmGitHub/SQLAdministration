CREATE TABLE [dbo].[AutoQuotePreQualQuestion] (
    [AutoPQQuestionId]  INT           NOT NULL,
    [QuoteNbr]          VARCHAR (16)  NULL,
    [QuestionCd]        VARCHAR (10)  NULL,
    [AnswerInd]         CHAR (1)      NULL,
    [AnswerDesc]        VARCHAR (255) NULL,
    [QuestionPatternCd] VARCHAR (60)  NULL,
    [UpdatedTmstmp]     DATETIME2 (7) NOT NULL,
    [UserUpdatedId]     CHAR (8)      NOT NULL,
    [LastActionCd]      CHAR (1)      NOT NULL,
    [SourceSystemCd]    CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AutoQuotePreQualQuestion] PRIMARY KEY CLUSTERED ([AutoPQQuestionId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AutoQuotePreQualQuestion_Quote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[Quote] ([QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_AutoQuotePreQualQuestion_01]
    ON [dbo].[AutoQuotePreQualQuestion]([QuoteNbr] ASC)
    ON [POLICYCI];

