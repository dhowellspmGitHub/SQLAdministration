CREATE TABLE [dbo].[Country] (
    [ISOCountryCd]   CHAR (2)      NOT NULL,
    [CountryNm]      VARCHAR (100) NULL,
    [UpdatedTmstmp]  DATETIME2 (7) NOT NULL,
    [UserUpdatedId]  CHAR (8)      NOT NULL,
    [LastActionCd]   CHAR (1)      NOT NULL,
    [SourceSystemCd] CHAR (2)      NOT NULL,
    CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED ([ISOCountryCd] ASC) ON [AGENCYCD]
) ON [AGENCYCD];

