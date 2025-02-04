﻿CREATE TABLE [dbo].[FireQuoteUnitEQEndorsementDetail] (
    [QuoteNbr]              VARCHAR (16)   NOT NULL,
    [UnitNbr]               INT            NOT NULL,
    [EndorsementId]         INT            NOT NULL,
    [ItemNbr]               CHAR (3)       NOT NULL,
    [EndorsementNbr]        CHAR (10)      NOT NULL,
    [EndorsementLimitCd]    CHAR (3)       NULL,
    [EndorsementLimitAmt]   DECIMAL (9)    NULL,
    [EndorsementPremiumAmt] DECIMAL (9, 2) NULL,
    [ConstructionTypeDesc]  CHAR (50)      NULL,
    [StructureDesc]         VARCHAR (255)  NULL,
    [AddressLine1Desc]      VARCHAR (100)  NULL,
    [AddressLine2Desc]      VARCHAR (100)  NULL,
    [AddressLine3Desc]      VARCHAR (100)  NULL,
    [CityNm]                CHAR (30)      NULL,
    [StateOrProvinceCd]     CHAR (3)       NULL,
    [ZipCd]                 CHAR (9)       NULL,
    [UpdatedTmstmp]         DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]         CHAR (8)       NOT NULL,
    [LastActionCd]          CHAR (1)       NOT NULL,
    [SourceSystemCd]        CHAR (2)       NOT NULL,
    CONSTRAINT [PK_FireQuoteUnitEQEndorsementDetail] PRIMARY KEY CLUSTERED ([EndorsementId] ASC, [ItemNbr] ASC, [UnitNbr] ASC, [QuoteNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FireQuoteUnitEQEndorsementDetail_FireQuoteUnit_01] FOREIGN KEY ([UnitNbr], [QuoteNbr]) REFERENCES [dbo].[FireQuoteUnit] ([UnitNbr], [QuoteNbr])
) ON [POLICYCD];

