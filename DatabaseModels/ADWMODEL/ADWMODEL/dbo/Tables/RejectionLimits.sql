CREATE TABLE [dbo].[RejectionLimits] (
    [ProcessCd]          CHAR (10)     NOT NULL,
    [ProcessDetailsCd]   VARCHAR (50)  NULL,
    [RejectionLimitNbr]  INT           NULL,
    [RejectionLimitDesc] VARCHAR (100) NULL,
    [UpdatedTmstmp]      DATETIME2 (7) NOT NULL,
    [UserUpdatedId]      CHAR (8)      NOT NULL,
    [LastActionCd]       CHAR (1)      NOT NULL,
    [SourceSystemCd]     CHAR (2)      NOT NULL,
    CONSTRAINT [PK_RejectionLimits] PRIMARY KEY CLUSTERED ([ProcessCd] ASC)
);

