CREATE TABLE [dbo].[ClaimException] (
    [ExceptionId]         INT           NOT NULL,
    [StageNm]             VARCHAR (100) NULL,
    [JobNm]               VARCHAR (100) NULL,
    [TargetTableNm]       VARCHAR (100) NULL,
    [SourceTableNm]       VARCHAR (100) NULL,
    [SourceNbr]           CHAR (50)     NULL,
    [SourceSystemId]      INT           NULL,
    [RejectionReasonDesc] VARCHAR (200) NULL,
    [UpdatedTmstmp]       DATETIME2 (7) NOT NULL,
    [UserUpdatedId]       CHAR (8)      NOT NULL,
    [LastActionCd]        CHAR (1)      NOT NULL,
    [SourceSystemCd]      CHAR (2)      NOT NULL,
    CONSTRAINT [PK_ClaimException] PRIMARY KEY CLUSTERED ([ExceptionId] ASC) ON [CLAIMSCD]
) ON [CLAIMSCD];

