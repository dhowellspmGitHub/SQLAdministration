CREATE TABLE [dbo].[AutoPolicyComment] (
    [AutoPolicyCommentId]   INT           NOT NULL,
    [PolicyId]              INT           NOT NULL,
    [PolicyNbr]             VARCHAR (16)  NOT NULL,
    [SublineBusinessTypeCd] CHAR (1)      NOT NULL,
    [CommentCd]             CHAR (2)      NULL,
    [CommentSequenceNbr]    CHAR (3)      NULL,
    [CommentTopicDesc]      VARCHAR (255) NULL,
    [CommentDt]             DATE          NULL,
    [CommentSeverityCd]     CHAR (1)      NULL,
    [CommentSubjectTxt]     VARCHAR (255) NULL,
    [CommentTxt]            VARCHAR (255) NULL,
    [CommentWriter]         CHAR (4)      NULL,
    [UpdatedTmstmp]         DATETIME2 (7) NOT NULL,
    [UserUpdatedId]         CHAR (8)      NOT NULL,
    [LastActionCd]          CHAR (1)      NOT NULL,
    [SourceSystemCd]        CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AutoPolicyComment] PRIMARY KEY CLUSTERED ([AutoPolicyCommentId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AutoPolicyComment_AutoPolicy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[AutoPolicy] ([PolicyId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_AutoPolicyComment_01]
    ON [dbo].[AutoPolicyComment]([PolicyId] ASC)
    ON [POLICYCI];

