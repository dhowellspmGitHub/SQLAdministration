CREATE TABLE [dbo].[Exception] (
    [ExceptionId]         INT           IDENTITY (1, 1) NOT NULL,
    [StageNm]             VARCHAR (100) NULL,
    [JobNm]               VARCHAR (100) NULL,
    [TargetTableNm]       VARCHAR (100) NULL,
    [SourceTableNm]       VARCHAR (100) NULL,
    [SourceNbr]           VARCHAR (50)  NULL,
    [SourceSystemId]      INT           NULL,
    [RejectionReasonDesc] VARCHAR (200) NULL,
    [CurrentRecordInd]    BIT           NOT NULL,
    [InsertedTmstmp]      DATETIME2 (7) NOT NULL,
    [UpdatedTmstmp]       DATETIME2 (7) NOT NULL,
    [UserUpdatedId]       CHAR (8)      NOT NULL,
    [LastActionCd]        CHAR (1)      NOT NULL,
    [SourceSystemCd]      CHAR (2)      NOT NULL,
    CONSTRAINT [PK_CommonException] PRIMARY KEY CLUSTERED ([ExceptionId] ASC)
);

