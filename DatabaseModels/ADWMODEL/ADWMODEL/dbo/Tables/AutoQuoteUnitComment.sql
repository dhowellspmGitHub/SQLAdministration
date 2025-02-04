CREATE TABLE [dbo].[AutoQuoteUnitComment] (
    [AutoQuoteUnitCommentId] INT           NOT NULL,
    [QuoteNbr]               VARCHAR (16)  NULL,
    [QuoteUnitNbr]           INT           NULL,
    [SublineBusinessTypeCd]  CHAR (1)      NOT NULL,
    [CommentCd]              CHAR (2)      NULL,
    [CommentSeverityCd]      CHAR (1)      NULL,
    [CommentDt]              DATE          NULL,
    [CommentSubjectTxt]      VARCHAR (255) NULL,
    [CommentTxt]             VARCHAR (255) NULL,
    [CommentWriter]          CHAR (4)      NULL,
    [CommentSequenceNbr]     CHAR (3)      NULL,
    [UpdatedTmstmp]          DATETIME2 (7) NOT NULL,
    [UserUpdatedId]          CHAR (8)      NOT NULL,
    [LastActionCd]           CHAR (1)      NOT NULL,
    [SourceSystemCd]         CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AutoQuoteUnitComment] PRIMARY KEY CLUSTERED ([AutoQuoteUnitCommentId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AutoQuoteUnitComment_AutoQuoteUnit_01] FOREIGN KEY ([QuoteNbr], [QuoteUnitNbr]) REFERENCES [dbo].[AutoQuoteUnit] ([QuoteNbr], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_AutoQuoteUnitComment_01]
    ON [dbo].[AutoQuoteUnitComment]([QuoteNbr] ASC)
    ON [POLICYCI];

