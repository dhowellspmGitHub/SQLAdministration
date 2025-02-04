CREATE TABLE [dbo].[HomeQuoteEndorsementDetail] (
    [HomeQuoteEndorsementDetailId] INT            NOT NULL,
    [AdditionalInterestId]         INT            NULL,
    [EndorsementId]                INT            NOT NULL,
    [QuoteNbr]                     VARCHAR (16)   NOT NULL,
    [EndorsementNbr]               CHAR (10)      NOT NULL,
    [ItemNbr]                      CHAR (3)       NOT NULL,
    [ArticleNbr]                   CHAR (3)       NULL,
    [ItemCoverageLimitAmt]         DECIMAL (9)    NULL,
    [ItemCoveragePremiumGrossAmt]  DECIMAL (9, 2) NULL,
    [AddressLine1Desc]             VARCHAR (100)  NULL,
    [AddressLine2Desc]             VARCHAR (100)  NULL,
    [AddressLine3Desc]             VARCHAR (100)  NULL,
    [CityNm]                       CHAR (30)      NULL,
    [StateOrProvinceCd]            CHAR (3)       NULL,
    [ZipCd]                        CHAR (9)       NULL,
    [CoverageOptionDesc]           VARCHAR (255)  NULL,
    [StructureDesc]                VARCHAR (255)  NULL,
    [NumberFamiliesCnt]            INT            NULL,
    [Name]                         VARCHAR (255)  NULL,
    [InterestDesc]                 VARCHAR (255)  NULL,
    [BusinessLocationDesc]         VARCHAR (255)  NULL,
    [IncidentalOccupanceDesc]      VARCHAR (255)  NULL,
    [RelationshipDesc]             VARCHAR (50)   NULL,
    [DaycareServiceDesc]           VARCHAR (255)  NULL,
    [LocationNameDesc]             VARCHAR (255)  NULL,
    [BusinessPursuitDesc]          VARCHAR (255)  NULL,
    [ShortDesc]                    VARCHAR (255)  NULL,
    [FarmTypeDesc]                 VARCHAR (100)  NULL,
    [AcresNbr]                     INT            NULL,
    [PrimaryOccupationInd]         CHAR (1)       NULL,
    [BoatTypeDesc]                 VARCHAR (50)   NULL,
    [BoatHorsePowerNbr]            INT            NULL,
    [BoatLengthNbr]                DECIMAL (3)    NULL,
    [ManufacturingYearDt]          CHAR (4)       NULL,
    [MakeDesc]                     VARCHAR (100)  NULL,
    [ModelNm]                      VARCHAR (100)  NULL,
    [SerialNbr]                    CHAR (20)      NULL,
    [UpdatedTmstmp]                DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]                CHAR (8)       NOT NULL,
    [LastActionCd]                 CHAR (1)       NOT NULL,
    [SourceSystemCd]               CHAR (2)       NOT NULL,
    CONSTRAINT [PK_HomeQuoteEndorsementDetail] PRIMARY KEY CLUSTERED ([HomeQuoteEndorsementDetailId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_HomeQuoteEndorsementDetail_AdditionalInterest_01] FOREIGN KEY ([AdditionalInterestId]) REFERENCES [dbo].[AdditionalInterest] ([AdditionalInterestId]),
    CONSTRAINT [FK_HomeQuoteEndorsementDetail_HomeQuoteEndorsement_01] FOREIGN KEY ([QuoteNbr], [EndorsementId]) REFERENCES [dbo].[HomeQuoteEndorsement] ([QuoteNbr], [EndorsementId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_HomeQuoteEndorsementDetail_01]
    ON [dbo].[HomeQuoteEndorsementDetail]([QuoteNbr] ASC)
    ON [POLICYCI];

