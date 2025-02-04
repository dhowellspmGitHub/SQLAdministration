CREATE TABLE [dbo].[ETLJobStatus] (
    [ProcessId]        INT           IDENTITY (1, 1) NOT NULL,
    [ProcessCd]        CHAR (2)      NULL,
    [ProcessNm]        VARCHAR (100) NULL,
    [StatusCd]         CHAR (2)      NULL,
    [StatusInd]        CHAR (1)      NULL,
    [CurrentRecordInd] BIT           CONSTRAINT [DF_ETLJobStatus_CurrentRecordInd] DEFAULT ((0)) NOT NULL,
    [ETLTransactionDt] DATETIME2 (7) NOT NULL,
    [RunDt]            DATETIME2 (7) NULL,
    [StartingTimeStmp] DATETIME2 (7) NULL,
    [BatchCycleDt]     DATE          CONSTRAINT [DF_ETLJobStatus_BatchCycleDt] DEFAULT (CONVERT([date],'01/01/1900',(0))) NOT NULL,
    [UpdatedTmstmp]    DATETIME2 (7) NOT NULL,
    CONSTRAINT [PK_ETLJobStatus] PRIMARY KEY CLUSTERED ([ProcessId] ASC)
);

