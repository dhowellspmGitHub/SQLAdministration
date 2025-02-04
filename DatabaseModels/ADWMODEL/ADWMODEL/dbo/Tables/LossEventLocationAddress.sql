CREATE TABLE [dbo].[LossEventLocationAddress] (
    [LossEventLocationAddressId] INT           NOT NULL,
    [StateOrProvinceCd]          CHAR (3)      NULL,
    [CountyDesc]                 VARCHAR (60)  NULL,
    [AddressLine1Desc]           VARCHAR (100) NULL,
    [AddressLine2Desc]           VARCHAR (100) NULL,
    [AddressLine3Desc]           VARCHAR (100) NULL,
    [CityNm]                     CHAR (30)     NULL,
    [ZipCd]                      CHAR (10)     NULL,
    [UpdatedTmstmp]              DATETIME2 (7) NOT NULL,
    [UserUpdatedId]              CHAR (8)      NOT NULL,
    [LastActionCd]               CHAR (1)      NOT NULL,
    [SourceSystemCd]             CHAR (2)      NOT NULL,
    [SourceSystemId]             INT           NOT NULL,
    [ClaimUserCreateTime]        DATETIME2 (7) NOT NULL,
    [ClaimUserCreatedId]         CHAR (8)      NOT NULL,
    [ClaimUserUpdatedId]         CHAR (8)      NOT NULL,
    [ClaimUpdatedTmstmp]         DATETIME2 (7) NOT NULL,
    [CurrentRecordInd]           BIT           NOT NULL,
    [RetiredInd]                 CHAR (1)      NOT NULL,
    CONSTRAINT [PK_LossEventLocation] PRIMARY KEY CLUSTERED ([LossEventLocationAddressId] ASC) ON [CLAIMSCD]
) ON [CLAIMSCD];

