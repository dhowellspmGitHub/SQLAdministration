CREATE TABLE [dbo].[Location] (
    [LocationID]        BIGINT        NOT NULL,
    [CreatedTmstmp]     DATETIME      NOT NULL,
    [AddressLine1Desc]  VARCHAR (100) NOT NULL,
    [AddressLine2Desc]  VARCHAR (100) NOT NULL,
    [AddressLine3Desc]  VARCHAR (100) NOT NULL,
    [CityNm]            CHAR (30)     NOT NULL,
    [StateOrProvinceCd] CHAR (3)      NOT NULL,
    [ZipCd]             CHAR (9)      NOT NULL,
    [UserCreatedId]     CHAR (8)      NOT NULL,
    [UpdatedTmstmp]     DATETIME2 (7) NOT NULL,
    [UserUpdatedId]     CHAR (8)      NOT NULL,
    [LastActionCd]      CHAR (1)      NOT NULL,
    [SourceSystemCd]    CHAR (2)      NOT NULL,
    CONSTRAINT [PK_Location] PRIMARY KEY CLUSTERED ([LocationID] ASC) ON [POLICYCD]
) ON [POLICYCD];

