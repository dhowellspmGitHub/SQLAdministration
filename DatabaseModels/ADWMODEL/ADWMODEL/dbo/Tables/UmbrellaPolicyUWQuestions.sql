CREATE TABLE [dbo].[UmbrellaPolicyUWQuestions] (
    [UmbrellaPolicyUWQuestionId] INT           NOT NULL,
    [QuestionCd]                 VARCHAR (10)  NOT NULL,
    [PolicyId]                   INT           NULL,
    [PolicyNbr]                  VARCHAR (16)  NOT NULL,
    [AnswerInd]                  BIT           NULL,
    [AnswerDesc1]                VARCHAR (255) NULL,
    [AnswerDesc2]                VARCHAR (255) NULL,
    [PatternTxt]                 VARCHAR (64)  NULL,
    [UpdatedTmstmp]              DATETIME2 (7) NULL,
    [UserUpdatedId]              CHAR (8)      NULL,
    [LastActionCd]               CHAR (1)      NULL,
    [SourceSystemCd]             CHAR (2)      NULL,
    CONSTRAINT [PK_UmbrellaPolicyUWQuestions] PRIMARY KEY CLUSTERED ([UmbrellaPolicyUWQuestionId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_UmbrellaPolicyUWQuestions_UmbrellaPolicy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[UmbrellaPolicy] ([PolicyId])
) ON [POLICYCD];

