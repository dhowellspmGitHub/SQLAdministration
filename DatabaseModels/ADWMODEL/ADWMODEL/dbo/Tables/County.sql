CREATE TABLE [dbo].[County] (
    [CountyNbr]                  CHAR (3)         NOT NULL,
    [StateOrProvinceCd]          CHAR (3)         NOT NULL,
    [CurrentPopulationGroupNbr]  CHAR (3)         NOT NULL,
    [PreviousPopulationGroupNbr] CHAR (3)         NOT NULL,
    [CountyNm]                   CHAR (19)        NULL,
    [SalesDistrictNbr]           CHAR (2)         NULL,
    [FederationDistrictNbr]      CHAR (2)         NOT NULL,
    [CountyGeoAddressDesc]       VARCHAR (200)    NULL,
    [CountyLatitudeNbr]          DECIMAL (13, 10) NULL,
    [CountyLongitudeNbr]         DECIMAL (13, 10) NULL,
    [UpdatedTmstmp]              DATETIME2 (7)    NOT NULL,
    [UserUpdatedId]              CHAR (8)         NOT NULL,
    [LastActionCd]               CHAR (1)         NOT NULL,
    [SourceSystemCd]             CHAR (2)         NOT NULL,
    CONSTRAINT [PK_County] PRIMARY KEY CLUSTERED ([CountyNbr] ASC) ON [AGENCYCD],
    CONSTRAINT [FK_County_PopulationGroupFactor_01] FOREIGN KEY ([CurrentPopulationGroupNbr]) REFERENCES [dbo].[PopulationGroupFactor] ([PopulationGroupNbr]),
    CONSTRAINT [FK_County_PopulationGroupFactor_02] FOREIGN KEY ([PreviousPopulationGroupNbr]) REFERENCES [dbo].[PopulationGroupFactor] ([PopulationGroupNbr]),
    CONSTRAINT [FK_County_StateProvince_01] FOREIGN KEY ([StateOrProvinceCd]) REFERENCES [dbo].[StateProvince] ([StateOrProvinceCd])
) ON [AGENCYCD];

