CREATE TABLE [dbo].[UserPhoto] (
    [PhotoUserId]        VARCHAR (255)   NOT NULL,
    [PhotoBinaryDataTxt] VARBINARY (MAX) NULL,
    [UpdatedTmstmp]      DATETIME2 (7)   NOT NULL,
    [UserUpdatedId]      CHAR (8)        NOT NULL,
    [LastActionCd]       CHAR (1)        NOT NULL,
    [SourceSystemCd]     CHAR (2)        NOT NULL,
    CONSTRAINT [PK_UserPhoto] PRIMARY KEY CLUSTERED ([PhotoUserId] ASC)
);

