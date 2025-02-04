CREATE TABLE [dbo].[AutoUnitComment] (
    [AutoUnitCommentId]     INT           NOT NULL,
    [PolicyId]              INT           NOT NULL,
    [UnitNbr]               INT           NOT NULL,
    [PolicyNbr]             VARCHAR (16)  NOT NULL,
    [SublineBusinessTypeCd] CHAR (1)      NOT NULL,
    [CommentCd]             CHAR (2)      NULL,
    [CommentSeverityCd]     CHAR (1)      NULL,
    [CommentDt]             DATE          NULL,
    [CommentSubjectTxt]     VARCHAR (255) NULL,
    [CommentTxt]            VARCHAR (255) NULL,
    [CommentWriterCd]       CHAR (4)      NULL,
    [CommentSequenceNbr]    CHAR (3)      NULL,
    [UpdatedTmstmp]         DATETIME2 (7) NOT NULL,
    [UserUpdatedId]         CHAR (8)      NOT NULL,
    [LastActionCd]          CHAR (1)      NOT NULL,
    [SourceSystemCd]        CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AutoUnitComment] PRIMARY KEY CLUSTERED ([AutoUnitCommentId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AutoUnitComment_AutoUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[AutoUnit] ([PolicyId], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_AutoUnitComment_01]
    ON [dbo].[AutoUnitComment]([PolicyId] ASC, [UnitNbr] ASC)
    ON [POLICYCI];

