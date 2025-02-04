CREATE TABLE [dbo].[UserMaster] (
    [UserMasterId]        INT           NOT NULL,
    [ActiveDirectoryGUId] CHAR (40)     NULL,
    [EmployeeNbr]         INT           NULL,
    [HireDt]              DATE          NULL,
    [UserID]              VARCHAR (20)  NOT NULL,
    [PersonUserInd]       BIT           NOT NULL,
    [StartingDt]          DATE          NULL,
    [TerminationDt]       DATE          NULL,
    [ActiveInd]           BIT           NOT NULL,
    [CurrentRecordInd]    BIT           NOT NULL,
    [UpdatedTmstmp]       DATETIME2 (7) NOT NULL,
    [UserUpdatedId]       CHAR (8)      NOT NULL,
    [LastActionCd]        CHAR (1)      NOT NULL,
    [SourceSystemCd]      CHAR (2)      NOT NULL,
    CONSTRAINT [PK_UserMaster] PRIMARY KEY NONCLUSTERED ([UserMasterId] ASC)
);

