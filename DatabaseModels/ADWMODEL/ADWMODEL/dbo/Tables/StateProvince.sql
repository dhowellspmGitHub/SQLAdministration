CREATE TABLE [dbo].[StateProvince] (
    [StateOrProvinceCd] CHAR (3)      NOT NULL,
    [ISOCountryCd]      CHAR (2)      NOT NULL,
    [StateOrProvinceNm] VARCHAR (60)  NULL,
    [UpdatedTmstmp]     DATETIME2 (7) NOT NULL,
    [UserUpdatedId]     CHAR (8)      NOT NULL,
    [LastActionCd]      CHAR (1)      NOT NULL,
    [SourceSystemCd]    CHAR (2)      NOT NULL,
    CONSTRAINT [PK_StateProvince] PRIMARY KEY CLUSTERED ([StateOrProvinceCd] ASC) ON [AGENCYCD],
    CONSTRAINT [FK_StateProvince_Country_01] FOREIGN KEY ([ISOCountryCd]) REFERENCES [dbo].[Country] ([ISOCountryCd])
) ON [AGENCYCD];

