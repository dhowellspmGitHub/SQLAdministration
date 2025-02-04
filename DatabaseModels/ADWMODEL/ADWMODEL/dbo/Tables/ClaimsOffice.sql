CREATE TABLE [dbo].[ClaimsOffice] (
    [ClaimBranchNbr]            CHAR (3)         NOT NULL,
    [CountyNbr]                 CHAR (3)         NOT NULL,
    [ClaimOfficeNm]             VARCHAR (50)     NOT NULL,
    [PhoneNbr]                  CHAR (16)        NOT NULL,
    [AddressLine1Desc]          VARCHAR (100)    NOT NULL,
    [AddressLine2Desc]          VARCHAR (100)    NULL,
    [CityNm]                    CHAR (30)        NOT NULL,
    [StateOrProvinceCd]         CHAR (3)         NOT NULL,
    [ZipCd]                     CHAR (9)         NOT NULL,
    [CurrentRecordInd]          BIT              NOT NULL,
    [ClaimOfficeLatitudeNbr]    DECIMAL (13, 10) NULL,
    [ClaimOfficeLongitudeNbr]   DECIMAL (13, 10) NULL,
    [ClaimOfficeGeoAddressDesc] VARCHAR (200)    NULL,
    [ClaimsOfficeClosedInd]     BIT              NULL,
    [SourceSystemId]            INT              NOT NULL,
    [UpdatedTmstmp]             DATETIME2 (7)    NOT NULL,
    [UserUpdatedId]             CHAR (8)         NOT NULL,
    [LastActionCd]              CHAR (1)         NOT NULL,
    CONSTRAINT [PK_ClaimOffice] PRIMARY KEY CLUSTERED ([ClaimBranchNbr] ASC) ON [CLAIMSCD]
) ON [CLAIMSCD];

