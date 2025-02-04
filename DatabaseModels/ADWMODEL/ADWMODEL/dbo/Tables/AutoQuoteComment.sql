CREATE TABLE [dbo].[AutoQuoteComment] (
    [AutoQuoteCommentId]    INT           NOT NULL,
    [QuoteNbr]              VARCHAR (16)  NOT NULL,
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
    CONSTRAINT [PK_AutoQuoteComment] PRIMARY KEY CLUSTERED ([AutoQuoteCommentId] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AutoQuoteComment_AutoQuote_01] FOREIGN KEY ([QuoteNbr]) REFERENCES [dbo].[AutoQuote] ([QuoteNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_AutoQuoteComment_01]
    ON [dbo].[AutoQuoteComment]([QuoteNbr] ASC)
    ON [POLICYCI];

