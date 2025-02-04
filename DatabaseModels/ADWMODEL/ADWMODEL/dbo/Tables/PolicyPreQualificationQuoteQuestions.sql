CREATE TABLE [dbo].[PolicyPreQualificationQuoteQuestions] (
    [QuestionCd]       VARCHAR (10)  NOT NULL,
    [QuestionDesc]     VARCHAR (255) NOT NULL,
    [LineofBusinessCd] CHAR (2)      NOT NULL,
    [PatternTxt]       VARCHAR (100) NULL,
    [UpdatedTmstmp]    DATETIME2 (7) NOT NULL,
    [UserUpdatedId]    CHAR (8)      NOT NULL,
    [LastActionCd]     CHAR (1)      NOT NULL,
    [SourceSystemCd]   CHAR (2)      NOT NULL,
    CONSTRAINT [PK_PolicyPreQualificationQuoteQuestions] PRIMARY KEY CLUSTERED ([QuestionCd] ASC) ON [POLICYCD]
) ON [POLICYCD];

