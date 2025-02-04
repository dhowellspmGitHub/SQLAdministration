CREATE TABLE [dbo].[CommercialPolicyUWQuestions] (
    [CommercialPolicyUWQuestionId] INT           NOT NULL,
    [QuestionCd]                   VARCHAR (10)  NOT NULL,
    [PolicyId]                     INT           NOT NULL,
    [AnswerInd]                    CHAR (1)      NULL,
    [Answer1Desc]                  VARCHAR (255) NULL,
    [Answer2Desc]                  VARCHAR (255) NULL,
    [UpdatedTmstmp]                DATETIME2 (7) NOT NULL,
    [UserUpdatedId]                CHAR (8)      NOT NULL,
    [LastActionCd]                 CHAR (1)      NOT NULL,
    [SourceSystemCd]               CHAR (2)      NOT NULL,
    CONSTRAINT [PK_CommercialPolicyUWQuestions] PRIMARY KEY CLUSTERED ([CommercialPolicyUWQuestionId] ASC, [QuestionCd] ASC, [PolicyId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialPolicyUWQuestions_CommercialPolicy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[CommercialPolicy] ([PolicyId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialPolicyUWQuestions_01]
    ON [dbo].[CommercialPolicyUWQuestions]([PolicyId] ASC)
    ON [POLICYCI];

