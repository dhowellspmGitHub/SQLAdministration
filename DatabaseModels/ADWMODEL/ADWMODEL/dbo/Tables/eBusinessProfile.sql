CREATE TABLE [dbo].[eBusinessProfile] (
    [EBusinessId]       VARCHAR (35)  NOT NULL,
    [CogenID]           VARCHAR (10)  NOT NULL,
    [EmailAddressDesc]  VARCHAR (254) NULL,
    [ProfileStatusDesc] CHAR (50)     NULL,
    [UpdatedTmpstmp]    DATETIME2 (7) NOT NULL,
    [UserUpdatedId]     CHAR (8)      NOT NULL,
    [CreatedTmstmp]     DATETIME      NOT NULL,
    [UserCreatedId]     CHAR (8)      NOT NULL,
    [LastActionCd]      CHAR (1)      NOT NULL,
    [SourceSystemCd]    CHAR (2)      NOT NULL,
    CONSTRAINT [PK_eBusinessProfile] PRIMARY KEY CLUSTERED ([EBusinessId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_eBusinessProfile]
    ON [dbo].[eBusinessProfile]([CogenID] ASC);

